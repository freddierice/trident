	.global _start

	.text
_start:
// move the stack by more than we need. make a clean slate.
sub sp, sp, 0x1000
str x0, [sp]
str x1, [sp,8]
str x2, [sp,16]
str x3, [sp,24]
str x4, [sp,32]
str x5, [sp,40]
str x6, [sp,48]
str x7, [sp,56]
str x8, [sp,64]
str x9, [sp,72]
str x10, [sp,80]
str x11, [sp,88]
str x12, [sp,96]
str x13, [sp,104]
str x14, [sp,112]
str x15, [sp,120]

// x15 = open /sys/fs/selinux
mov x0, 0
adr x1, selinux_load
mov x2, 2
mov x8, 56
svc 0
mov x15, x0

// x14 = open the new sepolicy file
mov x0, 0
adr x1, policy
mov x2, 0
mov x8, 56
svc 0
mov x14, x0

// lseek to get size of file
mov x0, x14
mov x1, 0 // off 
mov x2, 2 // SEEK_END
mov x8, 62 // lseek
svc 0
mov x13, x0

// lseek back to beginning
mov x0, x14
mov x1, 0 // off
mov x2, 0 // SEEK_SET
mov x8, 62 // lseek
svc 0

// mmap
mov x0, 0
mov x1, x13
mov x2, 1 // PROT_READ
mov x3, 2 // MAP_PRIVATE
mov x4, x14 // fd
mov x5, 0  // off
mov x8, 222 //mmap
svc 0
mov x12, x0

// write to the selinux load file
mov x0, x15
mov x1, x12
mov x2, x13
mov x8, 64
svc 0

// unmap mem
mov x0, x12
mov x1, x13
mov x8, 215
svc 0

// close the files
mov x0, x15
mov x8, 57
svc 0

mov x0, x14
mov x8, 57
svc 0

// restore the registers and move the stack back
ldr x0, [sp]
ldr x1, [sp,8]
ldr x2, [sp,16]
ldr x3, [sp,24]
ldr x4, [sp,32]
ldr x5, [sp,40]
ldr x6, [sp,48]
ldr x7, [sp,56]
ldr x8, [sp,64]
ldr x9, [sp,72]
ldr x10, [sp,80]
ldr x11, [sp,88]
ldr x12, [sp,96]
ldr x13, [sp,104]
ldr x14, [sp,112]
ldr x15, [sp,120]

add sp, sp, 0x1000
ret

selinux_load:
	.asciz "/sys/fs/selinux/load"
policy:
	.asciz "/data/local/tmp/sepolicy"
