
extern _MessageBoxA@16

section .text
global _main

_main:
    ; MessageBoxA(hWnd, lpText, lpCaption, uType)
    push 0 ; uType: MB_OK (0x00000000)
    push 0 ; lpCaption
    push 0 ; lpText
    push 0 ; hWnd: NULL
    call _MessageBoxA@16
