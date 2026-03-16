; Khai báo các hàm từ thư viện C (Standard C Library)
extern _printf
extern _scanf
extern _exit

section .data
    msg1    db "Nhap so thu nhat (thap phan): ", 0
    msg2    db "Nhap so thu hai (thap phan): ", 0
    msgRes  db "Tong hai so la: %d", 10, 0
    fmtInt  db "%d", 0

section .bss
    num1    resd 1
    num2    resd 1

section .text
global _main

_main:
    ;Nhap so thu nhat 
    push msg1
    call _printf
    add esp, 4      

    push num1     
    push fmtInt
    call _scanf
    add esp, 8   

    ;Nhap so thu hai 
    push msg2
    call _printf
    add esp, 4

    push num2
    push fmtInt
    call _scanf
    add esp, 8

    ; Thuc hien phep cong
    mov eax, [num1]    
    add eax, [num2]     

    ; In ket qua 
    push eax ; Gia tri tong dang o trong EAX, push vao Stack
    push msgRes
    call _printf
    add esp, 8

    push 0
    call _exit