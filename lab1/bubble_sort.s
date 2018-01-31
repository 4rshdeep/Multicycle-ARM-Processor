.equ SWI_Exit, 0x11

.text 
.global main
							
main:	ldr r1,=P			@ r1 <- start address do not update!
		add r3, r1, #28		@ r3 <- prefinal address
		add r9, r1, #24		@ r9 <- prefinal address
		mov r10, #-1  		@ r10 stores numswaps
		mov r5, r1          @ store starting address in r5

for:	sub r3, r3, #4
		cmp r5, r9			@ have we reached prefinal position?
		bgt end				@ exit if address equal to last word
		add r5, r5, #4
		mov r4, r1          @ store first address in second pointer
		
for_2:	cmp r4, r3
		bgt for
		ldr r7, [r4]		
		mov r0, r4			@ save address of previous (r7)
		add r4, r4, #4		@ put address of next in r4 for storing later
		ldr r8, [r4]
		cmp r7, r8
		bgt swap
		b for_2

@ display sorted values and return control to simulator
end:	mov r0, r1
		ldr r1, [r0]
		ldr r2, [r0, #4]
		ldr r3, [r0, #8]
		ldr r4, [r0, #12]
		ldr r5, [r0, #16]
		ldr r6, [r0, #20]
		ldr r7, [r0, #24]
		ldr r8, [r0, #28]

		swi SWI_Exit

swap:	str r8, [r0]  		@ change value in address
		str r7, [r4]		@ str goes like Ri -> [Rj]
		b for_2

.data
	@P: .word 4, 10, 6, 1, 3, 23, 67, 35
	P: .word 67, 3588, 23, 2, 2, 4, 3, 1
.end
