#include "factor.h"

void init_errors(void)
{
	thrown_error = F;
}

void fatal_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Fatal error: %s %ld\n",msg,tagged);
	exit(1);
}

void critical_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Critical error: %s %ld\n",msg,tagged);
	save_image("factor.crash.image");
	exit(1);
}

void throw_error(CELL error, bool keep_stacks)
{
	thrown_error = error;
	thrown_keep_stacks = keep_stacks;
	thrown_ds = ds;
	thrown_cs = cs;

	/* Return to run() method */
	siglongjmp(toplevel,1);
}

void primitive_throw(void)
{
	throw_error(dpop(),true);
}

void early_error(CELL error)
{
	if(userenv[BREAK_ENV] == F)
	{
		/* Crash at startup */
		fprintf(stderr,"Error %ld thrown before BREAK_ENV set\n",to_fixnum(error));
		fflush(stderr);
		exit(1);
	}
}

void general_error(CELL error, CELL tagged)
{
	early_error(error);
	throw_error(cons(error,cons(tagged,F)),true);
}

/* It is not safe to access 'ds' from a signal handler, so we just not
touch it */
void signal_error(int signal)
{
	early_error(ERROR_SIGNAL);
	throw_error(cons(ERROR_SIGNAL,cons(tag_fixnum(signal),F)),false);
}

void type_error(CELL type, CELL tagged)
{
	CELL c = cons(tag_fixnum(type),cons(tagged,F));
	general_error(ERROR_TYPE,c);
}

void range_error(CELL tagged, FIXNUM index, CELL max)
{
	CELL c = cons(tagged,cons(tag_integer(index),cons(tag_cell(max),F)));
	general_error(ERROR_RANGE,c);
}