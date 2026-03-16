extern _printf
extern _scanf
extern _exit

section .data
msgMode db "Chon kieu (1 = unsigned, 2 = signed): ",0
msg1 db "Nhap so nhi phan thu nhat: ",0
msg2 db "Nhap so nhi phan thu hai: ",0

fmtStr db "%s",0
fmtChar db " %c",0

msgRes db "Ket qua: %s",10,0
msgErr db "Input khong hop le!",10,0

section .bss
bin1 resb 32
bin2 resb 32
res  resb 18

num1 resd 1
num2 resd 1
mode resb 1

section .text
global _main

_main:

    ; CHON MODE cong so co dau hay khong dau)
    ; in thong bao chon mode
    push msgMode
    call _printf
    add esp,4
    ;nhap so de chon mode
    push mode
    push fmtChar
    call _scanf
    add esp,8

    ;nhap so thu 1
    push msg1
    call _printf
    add esp,4

    push bin1
    push fmtStr
    call _scanf
    add esp,8
    ; chuyen chuoi 1 sang bin
    mov esi,bin1
    call validate_and_convert
    cmp edx, 1
    je invalid_input

    mov [num1], eax

    ;nhap so t2
    push msg2
    call _printf
    add esp,4

    push bin2
    push fmtStr
    call _scanf
    add esp,8
    ;chuyen chuoi 2 thanh bin
    mov esi,bin2

    call validate_and_convert
    cmp edx, 1
    je invalid_input
    mov [num2],eax



    ; thuc hien cong2 so
    mov eax,[num1] 
    mov ebx,[num2]
    add eax,ebx ; thuc hien num1 +num2
    
    ;in lqua
    mov edi, res
    call dec_to_bin

    push res
    push msgRes
    call _printf
    add esp, 8
    ;thoat
    push 0
    call _exit

    invalid_input:
    push msgErr
    call _printf
    add esp,4

;------------
; kiem tra ki tu hop le va chuyen chuoi sang bin
;------------
validate_and_convert: 

xor eax,eax ; khoi tao ax =0
xor ecx,ecx ; khoi tao counter = 0

.loop:
mov dl,byte [esi + ecx]; doc ki tu

cmp dl,0 ; ket thuc chuoi ?
je .done ; neu dung thi hoan thanh
;chua ket thuc thi dich trai 1 bit

cmp ecx,16
jge .invalid ; neu qua 16bit thi chuoi k hop le

cmp dl,'0'
jb .invalid ; neu bit nho hon 0 thi bao loi
cmp dl,'1'
ja .invalid ; neu bit lon hon 1 thi bao loi

; neu la 0 hoac 1 thi xu ly
shl eax,1 ; ax*2
sub dl,'0' ; chuyen ki tu thanh so
add al,dl ; cong bit vao ax

inc ecx; kiem tra ki tu tiep theo
jmp .loop; lap lai

.invalid:
mov edx,1 ; co loi thi dat bx =1
ret

.done:
mov edx,0; khong co loi thi dat bx =0

;-----------------
; xu ly theo mode
;-----------------

cmp byte [mode],'2'
je .signed_case
;neu la khong dau thi de nguyen
ret
; neu co dau
.signed_case:
cmp ecx,32
je .finish ; đủ 32 bit thì thôi

mov bl, 32
sub bl, cl ; Lúc này cl chứa giá trị thấp của ecx (số ký tự đã nhập)
mov cl, bl


shl  eax, cl ; đưa bit dấu lên vị trí bit 31
sar  eax, cl ; arithmetic shift right → mở rộng dấu
.finish:
ret

;-----------
;chuyen ket qua sang chuoi nhi phan
;-----------

dec_to_bin:
    push eax  ; Lưu lại giá trị ban đầu để không làm mất dữ liệu của main
    push ecx
    push edi

    mov ecx, 17  
    add edi, 17 ; Nhảy đến cuối buffer (vị trí res + 17)
    mov byte [edi], 0  ; Đặt ký tự kết thúc chuỗi (Null-terminator)

.convert_loop:
    dec edi ; Lùi về vị trí trước đó để ghi ký tự
    test eax, 1  ; Kiểm tra bit cuối cùng (LSB)
    jnz .set_one ; Nếu bit đó là 1
    mov byte [edi], '0' ; Nếu bit đó là 0
    jmp .next

.set_one:
    mov byte [edi], '1'

.next:
    shr eax, 1 ; Dịch phải 1 bit để xét bit tiếp theo
    loop .convert_loop ; Giảm ECX và lặp lại nếu ECX > 0

    pop edi
    pop ecx
    pop eax
    ret