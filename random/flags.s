.equ SWI_Exit, 0x11
.text
.global main

@ want to move 3 from r1 to r2

main:		ldr r1,=0x12345678
			mov r2, r1, lsr #28
			mov r3, r1, lsl #4
			; ldr r2,=0x22222222
			; mov r3, r2, ror #4
			; mov r3, r3, lsr #4
			; mov r3, r3, ror #24
			; mov r4, r1, lsl #24
			; mov r4, r4, lsr #28
			; mov r4, r4, lsl #4
			; orr r4, r4, r3
			; mov r2, r2, lsr #28
			; mov r2, r2, lsl #4


			
			swi SWI_Exit

.data
	S: .word 2, 3, 4, 5, 6 
