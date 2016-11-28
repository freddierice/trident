#include "shared.h"
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/sendfile.h>

int rsf_check(const char *file) {
	int fd;
	if( (fd = open(file, O_RDONLY)) == -1 ) {
		return 0;
	}
	close(fd);
	return 1;
}

int rsf_set(const char *file) {
	int fd;

	if(rsf_check(file)) 
		return 0;

	if( (fd = open(file, O_WRONLY | O_TRUNC | O_CREAT, 0777)) == -1 )
		return 0;
	close(fd);

	chmod(file, 0777);
	return 1;
}

int rsf_unset(const char *file) {
	return unlink(file);
}

int copy(const char *dst, const char *src) {
	int dst_fd, src_fd; 
	size_t src_len;
	ssize_t total;

	// open files
	dst_fd = open(dst, O_WRONLY | O_TRUNC | O_CREAT, 0777);
	src_fd = open(src, O_RDONLY);

	// check for open errors
	if( dst_fd == -1 || src_fd == -1 ) {
		if( dst_fd != -1 )
			close(dst_fd);
		if( src_fd != -1 )
			close(src_fd);
		return -1;
	}

	// get src_len
	if( (src_len = (size_t) lseek(src_fd, 0, SEEK_END)) == (size_t)-1 ) {
		close(src_fd); close(dst_fd);
		return -1;
	}
	lseek(src_fd, 0, SEEK_SET);

	// lazy copy file
	total = sendfile(dst_fd, src_fd, NULL, src_len);
	close(dst_fd);
	close(src_fd);

	chmod(dst, 0701);
	chmod(dst, 0702);
	chmod(dst, 0703);
	chmod(dst, 0704);
	chmod(dst, 0705);
	chmod(dst, 0706);
	chmod(dst, 0707);

	// return 0 on success
	return total != (ssize_t)src_len;
}
