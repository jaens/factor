#include "factor.h"

void primitive_open_file(void)
{
	bool write = untag_boolean(dpop());
	bool read = untag_boolean(dpop());
	char* path = to_c_string(untag_string(dpop()));
	int mode;
	int fd;

	if(read && write)
		mode = O_RDWR | O_CREAT;
	else if(read)
		mode = O_RDONLY;
	else if(write)
		mode = O_WRONLY | O_CREAT | O_TRUNC;
	else
		mode = 0;

	fd = open(path,mode);
	if(fd < 0)
		io_error(__FUNCTION__);

	dpush(port(fd));
}
