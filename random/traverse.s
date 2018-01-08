.equ SWI_Exit, 0x11

.text 
.global main
							
main:	ldr r1,=P			@ r1 <- start address
		add r3, r1, #24		@ r3 <- prefinal address
		mov r10, #-1  		@ r10 stores numswaps

		mov r5, r1

while:	cmp r10, #0
		beq end

		mov r10, #0         @set numswaps to 0


for:	cmp r5, r3
		bgt while


		ldr r4, [r5]

		add r6, r5, #4
		mov r5, r6

		b for


end:	swi SWI_Exit
.data
	P: .word 4, 10, 6, 19, 3, 12, 67, 35
.end