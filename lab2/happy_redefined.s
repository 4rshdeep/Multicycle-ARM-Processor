@following conventions

@ r0-3 and r12 can be modified in a branch and result should be in r0
@ other important conventions followed 
	;r4 contains current index

.equ SWI_Exit, 0x11
.equ SWI_PrInt,0x6b   @ Write an Integer
.equ Stdout, 1
.equ SWI_PrStr, 0x69   @ Write a null-ending string 

.text
.global main

copy_bcd:ldr r2, [r1]			@ copies r0 <- r1
		str r2, [r0]
		ldr r2, [r1, #4]
		str r2, [r0, #4]
		ldr r2, [r1, #8]
		str r2, [r0, #8]
		ldr r2, [r1, #12]
		str r2, [r0, #12]
		mov pc, lr

sum_square:ldr r0,=D
		ldr r1,=Zero
		bl copy_bcd          @copies r0 <- r1
		@ copied space with zero
		@variables can be reused now

		ldr r0,=Y
		ldr r1,=D
		add r2, r0, #16
		ldr r3, [r0]

square: mul r4, r3, r3  	@r3-> digit to be squared
		ldr r5, [r1]
		add r4, r4, r5
		mov r6, #0        	@carry reg for tens place

carry_unit:	cmp r4, #10     @carry from unit place
		blt cont_ten

		sub r4, r4, #10
		add r6, r6, #1   
		b carry_unit

cont_ten: mov r7, #0
		ldr r5, [r1, #4]
		add r6, r6, r5
carry_ten: cmp r6, #10
		blt cont_hun

		sub r6, r6, #10
		add r7, r7, #1
		b carry_ten

cont_hun: mov r8, #0
		ldr r5, [r1, #8]
		add r7, r7, r5
carry_hun: cmp r7, #10
		blt cont_th

		sub r7, r7, #10
		add r8, r8, #1
		b carry_hun

cont_th: ldr r5, [r1, #12]
		add r8, r8, r5
		cmp r8, #10
		beq end

		@ r4, r6, r7, r8
		str r4, [r1]
		str r6, [r1, #4]
		str r7, [r1, #8]
		str r8, [r1, #12]

		@ prepare for next square
		add r0, r0, #4
		ldr r3, [r0]
		cmp r0, r2
		bne square

		ldr r0,=Y
		ldr r1,=D

		ldr r2, [r1]
		str r2, [r0]
		ldr r2, [r1, #4]
		str r2, [r0, #4]
		ldr r2, [r1, #8]
		str r2, [r0, #8]
		ldr r2, [r1, #12]
		str r2, [r0, #12]
		b check_gt_1


increment_x:
		add r9, r9, #1
		ldr r0,=One
		ldr r1,=X
		add r2, r1, #16
		mov r3, #0 		@carry as in c code

inc:	ldr r4, [r0]
		ldr r5, [r1]

		add r6, r4, r5
		add r6, r6, r3  @add carry
		mov r3, #0  @set carry to zero later
		cmp r6, #10
		blt ahead
		sub r6, r6, #10
		add r3, r3, #1

ahead:	str r6, [r1]
		
		add r0, r0, #4
		add r1, r1, #4

		cmp r2, r1
		bgt inc

		cmp r6, #10
		beq end

		add r4, r4, #1
		b loop

print: 		mov r0, #Stdout @specify mode stdout to print
			ldr r2,=X
			ldr r1, [r2, #12] @r1 should contain data to be printed
			; mov r3, r1   @r3 -> thousand
			; cmp r1, #0
			; beq skip_th
			swi SWI_PrInt

skip_th:	ldr r1, [r2, #8]
			; orr r4, r3, r1 
			; cmp r4, #0
			; mov r4, r1  @r4 -> hundred
			; beq skip_h
			swi SWI_PrInt

skip_h:		ldr r1, [r2, #4]
			; orr r5, r4, r3
			; orr r5, r5, r1
			; cmp r5, #0
			; beq skip_t
			swi SWI_PrInt

skip_t:		ldr r1, [r2]
			swi SWI_PrInt
			@ print a new line as a string to Stdout
			; mov r0, #Stdout       @ mode is Stdout
			ldr r1, =Blank         @ end of line
			swi SWI_PrStr
		
			b increment_x


check_gt_1: ldr r0,=Y
		ldr r1, [r0, #4]
		ldr r2, [r0, #8]
		ldr r3, [r0, #12]
		orr r12, r1, r2
		orr r12, r12, r3
		cmp r12, #0
		bgt sum_square
check_happy:ldr r0,=Y
		ldr r0, [r0]
		cmp r0, #1
		beq print
		cmp r0, #7
		beq print
		b increment_x

main: 	mov r11, #0
		ldr r0,=One
		ldr r2,=X
		ldr r3,=Zero

		mov r1, #1
		str r1, [r0]
		str r1, [r2]
		
		mov r1, #0
		str r1, [r0, #4]
		str r1, [r0, #8]
		str r1, [r0, #12]
		str r1, [r2, #4]
		str r1, [r2, #8]
		str r1, [r2, #12]
		str r1, [r3]
		str r1, [r3, #4]
		str r1, [r3, #8]
		str r1, [r3, #12]


		mov r9, #1  @start index
		mov r1, #100
		mul r10, r1, r1
		sub r10, r10, #1
		; mov r10, #99 @last index 
		
loop:	cmp r9, r10
		bgt end

		ldr r0,=X
		ldr r1,=Y
		@copying x->y
		ldr r2, [r0]
		str r2, [r1]
		ldr r2, [r0, #4]
		str r2, [r1, #4]
		ldr r2, [r0, #8]
		str r2, [r1, #8]
		str r2, [r0, #12]
		str r2, [r1, #12]
		b check_gt_1

end:    swi SWI_Exit
.data
	One: .space 16 @space for one in BCD
	X: .space 16 @for current number being checked
	Y: .space 16 @temporary number which is used for sum and squaring
	D: .space 16 @ extra variables
	S: .space 16
	Zero: .space 16
	Blank:   .ascii   " "
.end