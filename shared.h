#ifndef __SHARED_H__
#define __SHARED_H__

#include <android/log.h>
#include <sys/types.h>

// recovery status files
extern const char *RSF_LOAD_DONE;

// returns 1 if set, or 0 if it exists.
int rsf_set(const char *file);

// returns 1 if exists, or 0 if it does not exist
int rsf_check(const char *file);

// returns 0 on success, other on failure
int rsf_unset(const char *file);

// returns 0 on success, other on failure 
int copy(const char *dst, const char *src);

// performs dirtycow on files
int dirtycow(const char *dst, const char *src);

// performs a dirtycow memcpy -- copy into dst at offset off n bytes
// from src.
int dirtycow_memcpy(const char *dst, size_t off, size_t n, void *src);

// log info
#define LOGV(...) { __android_log_print(ANDROID_LOG_INFO, "trident", __VA_ARGS__); }

// log notice
#define LOGN(x) { __android_log_print(ANDROID_LOG_INFO, "trident", "NOTICE: %s", (x)); }
#endif
