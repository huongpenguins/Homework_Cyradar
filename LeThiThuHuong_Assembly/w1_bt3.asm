extern _printf
extern _getchar
extern _exit

section .data
    msgInput  db "Nhap vao mot xau: ", 0
    msgOutput db "Xau sau khi dao nguoc: ", 0
    fmtChar   db "%c", 0
    newline   db 10, 0

section .bss
    strInput resb 100

section .text
global _main

_main:
    ;nhap xau
    push msgInput
    call _printf
    add esp, 4

    xor esi, esi; dem ki tu da nhap

read_loop:
    xor eax,eax ; lam sach eax
    
    call _getchar ;nhan so 

    cmp eax,10
    je print_string ; neu la ki tu xuong dong thi in kqua
    cmp eax,13 ; neu la enter thi in kqua
    je print_string
    cmp eax,-1
    je print_string ; neu la eof thi cung in kqua

    cmp eax,32 ; nho hon 32 la ki tu dieu kien
    jb read_loop ; nho hon thi bo qua
    ; neu hop le thi push vao stack

    push eax ; dat cac ki tu vao trong stack
    inc esi ; tang so ki tu da nhap
    jmp read_loop ; dem tiep

print_string:
    ; In thong bao ket qua
    push msgOutput
    call _printf
    add esp,4
    
    reverse:
        cmp esi,0; neu het ki tu thi dung lai
        je done
        ; chua het thi tiep tuc
        pop eax ; lay tu stack dua ra eax

        push eax ; push ki tu can in
        push fmtChar
        call _printf
        add esp,8

        dec esi
        jmp reverse

done:
    push newline
    call _printf
    add esp,4

    push 0
    call _exit






