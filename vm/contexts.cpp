#include "master.hpp"

namespace factor
{

context::context(cell datastack_size, cell retainstack_size, cell callstack_size) :
	callstack_top(NULL),
	callstack_bottom(NULL),
	datastack(0),
	retainstack(0),
	callstack_save(0),
	datastack_seg(new segment(datastack_size,false)),
	retainstack_seg(new segment(retainstack_size,false)),
	callstack_seg(new segment(callstack_size,false))
{
	reset();
}

void context::reset_datastack()
{
	datastack = datastack_seg->start - sizeof(cell);
}

void context::reset_retainstack()
{
	retainstack = retainstack_seg->start - sizeof(cell);
}

void context::reset_callstack()
{
	callstack_top = callstack_bottom = CALLSTACK_BOTTOM(this);
}

void context::reset_context_objects()
{
	memset_cell(context_objects,false_object,context_object_count * sizeof(cell));
}

void context::reset()
{
	reset_datastack();
	reset_retainstack();
	reset_callstack();
	reset_context_objects();
}

context::~context()
{
	delete datastack_seg;
	delete retainstack_seg;
	delete callstack_seg;
}

/* called on startup */
void factor_vm::init_contexts(cell datastack_size_, cell retainstack_size_, cell callstack_size_)
{
	datastack_size = datastack_size_;
	retainstack_size = retainstack_size_;
	callstack_size = callstack_size_;

	ctx = NULL;
	spare_ctx = new_context();
}

void factor_vm::delete_contexts()
{
	assert(!ctx);
	std::vector<context *>::const_iterator iter = unused_contexts.begin();
	std::vector<context *>::const_iterator end = unused_contexts.end();
	while(iter != end)
	{
		delete *iter;
		iter++;
	}
}

context *factor_vm::new_context()
{
	context *new_context;

	if(unused_contexts.empty())
	{
		new_context = new context(datastack_size,
			retainstack_size,
			callstack_size);
	}
	else
	{
		new_context = unused_contexts.back();
		unused_contexts.pop_back();
	}

	new_context->reset();

	active_contexts.insert(new_context);

	return new_context;
}

void factor_vm::delete_context(context *old_context)
{
	unused_contexts.push_back(old_context);
	active_contexts.erase(old_context);
}

void factor_vm::begin_callback()
{
	ctx->reset();
	spare_ctx = new_context();
	callback_ids.push_back(callback_id++);
}

void begin_callback(factor_vm *parent)
{
	parent->begin_callback();
}

void factor_vm::end_callback()
{
	callback_ids.pop_back();
	delete_context(ctx);
}

void end_callback(factor_vm *parent)
{
	parent->end_callback();
}

void factor_vm::primitive_current_callback()
{
	ctx->push(tag_fixnum(callback_ids.back()));
}

void factor_vm::primitive_context_object()
{
	fixnum n = untag_fixnum(ctx->peek());
	ctx->replace(ctx->context_objects[n]);
}

void factor_vm::primitive_set_context_object()
{
	fixnum n = untag_fixnum(ctx->pop());
	cell value = ctx->pop();
	ctx->context_objects[n] = value;
}

bool factor_vm::stack_to_array(cell bottom, cell top)
{
	fixnum depth = (fixnum)(top - bottom + sizeof(cell));

	if(depth < 0)
		return false;
	else
	{
		array *a = allot_uninitialized_array<array>(depth / sizeof(cell));
		memcpy(a + 1,(void*)bottom,depth);
		ctx->push(tag<array>(a));
		return true;
	}
}

void factor_vm::primitive_datastack()
{
	if(!stack_to_array(ctx->datastack_seg->start,ctx->datastack))
		general_error(ERROR_DS_UNDERFLOW,false_object,false_object,NULL);
}

void factor_vm::primitive_retainstack()
{
	if(!stack_to_array(ctx->retainstack_seg->start,ctx->retainstack))
		general_error(ERROR_RS_UNDERFLOW,false_object,false_object,NULL);
}

/* returns pointer to top of stack */
cell factor_vm::array_to_stack(array *array, cell bottom)
{
	cell depth = array_capacity(array) * sizeof(cell);
	memcpy((void*)bottom,array + 1,depth);
	return bottom + depth - sizeof(cell);
}

void factor_vm::primitive_set_datastack()
{
	ctx->datastack = array_to_stack(untag_check<array>(ctx->pop()),ctx->datastack_seg->start);
}

void factor_vm::primitive_set_retainstack()
{
	ctx->retainstack = array_to_stack(untag_check<array>(ctx->pop()),ctx->retainstack_seg->start);
}

/* Used to implement call( */
void factor_vm::primitive_check_datastack()
{
	fixnum out = to_fixnum(ctx->pop());
	fixnum in = to_fixnum(ctx->pop());
	fixnum height = out - in;
	array *saved_datastack = untag_check<array>(ctx->pop());
	fixnum saved_height = array_capacity(saved_datastack);
	fixnum current_height = (ctx->datastack - ctx->datastack_seg->start + sizeof(cell)) / sizeof(cell);
	if(current_height - height != saved_height)
		ctx->push(false_object);
	else
	{
		cell *ds_bot = (cell *)ctx->datastack_seg->start;
		for(fixnum i = 0; i < saved_height - in; i++)
		{
			if(ds_bot[i] != array_nth(saved_datastack,i))
			{
				ctx->push(false_object);
				return;
			}
		}
		ctx->push(true_object);
	}
}

void factor_vm::primitive_load_locals()
{
	fixnum count = untag_fixnum(ctx->pop());
	memcpy((cell *)(ctx->retainstack + sizeof(cell)),
		(cell *)(ctx->datastack - sizeof(cell) * (count - 1)),
		sizeof(cell) * count);
	ctx->datastack -= sizeof(cell) * count;
	ctx->retainstack += sizeof(cell) * count;
}

void factor_vm::primitive_current_context()
{
	ctx->push(allot_alien(ctx));
}

void factor_vm::primitive_start_context()
{
	cell quot = ctx->pop();
	ctx = new_context();
	unwind_native_frames(quot,ctx->callstack_bottom);
}

void factor_vm::primitive_delete_context()
{
	context *old_context = (context *)pinned_alien_offset(ctx->pop());
	delete_context(old_context);
}

}
