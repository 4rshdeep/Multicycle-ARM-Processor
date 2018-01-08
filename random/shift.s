.equ SWI_Exit, 0x11

.text 
.global main

main:
	mov r1, #2

	mul r2, r1, r1
	mov r3, #3
	mul r4, r2, r3      @r4 stores 3x^2

	mov r2, #5
	mul r3, r1, r2      @r3 stores 5x

	add r4, r4, r3      @r4 stores 3x^2 + 5x 
	add r4, r4, #1		@r4 stores 3x^2 + 5x +1
	swi SWI_Exit
.data
	A: .space 400 
.end