.equ SWI_Exit, 0x11
.equ SWI_Open, 0x66

.global main

main:   ldr r0,=Filename
        mov r1, #0
        swi SWI_Open
        bcs main

end:    swi SWI_Exit

.data
    Filename: .asciz "in.txt"
    AA: .word 0
    BB: .word 0xFFFFFFFF