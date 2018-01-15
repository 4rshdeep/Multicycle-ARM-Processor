.equ SWI_Exit, 0x11
.equ SWI_PrInt,0x6b   @ Write an Integer
.equ Stdout, 1
.equ SWI_PrStr, 0x69   @ Write a null-ending string 
.text
.global main

@ Not to update r7 -> current index
space_zero: ldr r1,=Space
			mov r2, #0
			str r2, [r1]
			str r2, [r1, #4]
			str r2, [r1, #8]
			str r2, [r1, #12]
			mov pc, lr

d_zero:		ldr r1,=DD
			mov r9, #0
			str r9, [r1]
			str r9, [r1, #4]
			str r9, [r1, #8]
			str r9, [r1, #12]
			mov pc, lr


@ square register r2 and puts in DD
square_digit: mul r3, r2, r2
			mov r4, #0 ; 10th digit in DD
			cmp r3, #9
			bgt carry1
			ldr r1,=DD
			str r3, [r1]
			str r3, [r1, #4]
			str r3, [r1, #8]
			str r3, [r1, #12]
			mov pc, lr

; link:		mov pc, lr

@ r1 -> Space r2 -> DD address r10 -> Temp
add_space_d:ldr r3, [r1]
			ldr r4, [r2]
			add r5, r3, r4
			add r5, r5, r6
			mov r6, #0 @ carry register
			
			cmp r5, #10
			blt ahead1
			sub r5, r5, #10
			mov r6, #1

ahead1:		str r5, [r10]
			
			add r1, r1, #4
			add r2, r2, #4
			add r10, r10, #4

			cmp r4, r9
			blt add_space_d
			mov pc, lr

; carry2:		cmp r5, #10
; 			blt link
; 			sub r5, r5, #10
; 			add r6, r6, #1
; 			cmp r5, #9
; 			bgt carry2
; 			mov pc, lr

carry1:		sub r3, r3, #10
			add r4, r4, #1
			cmp r3, #9
			bgt carry1
			ldr r1,=DD
			str r3, [r1]
			str r4, [r1, #4]
			str r4, [r1, #8]
			str r4, [r1, #12]
			; mov pc, lr

make_happy: ldr r6,=Temp
			ldr r2, [r6]
			add r5, r6, #16

			ldr r11,=DD
			
			mov r10, #0
			str r10, [r11]
			str r10, [r11, #4]
			str r10, [r11, #8]
			str r10, [r11, #12]

mult:		mul r3, r2, r2
			ldr r1, [r11]
			add r3, r3, r1
			mov r4, #0 ; 10th place to be stord and used in carry1 digit in DD

carry_unit: cmp r3, #10
			blt cont_unit
			
			sub r3, r3, #10 ; subtract 10 fro, units
			add r4, r4, #1
			b carry_unit 

cont_unit:	mov r9, #0 @hundred's place
			ldr r1, [r11, #4]
			add r4, r4, r1
carry_hund: cmp r4, #10
			blt cont_th
			sub r4, r4, #10
			add r9, r9, #1
			b carry_hund

cont_th:	mov r0, #0 @thousand's place
			ldr r1, [r11, #8]
			add r9, r9, r1

carry_th:	cmp r9, #10
			blt cont_last
			sub r9, r9, #10	
			add r0, r0, #1
			b carry_th

cont_last:	ldr r1, [r11, #8]
			add r0, r0, r1
			cmp r0, #10
			beq end


continue:	str r3, [r11]
			str r4, [r11, #4]
			str r9, [r11, #8]
			str r0, [r11, #12]
			
			add r6, r6, #4
			ldr r2, [r6]  @ load for next digit to be squared above in r2

			cmp r5, r6
			bne mult

			ldr r1,=Temp
			ldr r3, [r11]
			str r3, [r1]
			ldr r4, [r11, #4]
			str r4, [r1, #4]
			ldr r9, [r11, #8]
			str r0, [r1, #12]
			
			b check

			; add space and DD BCD format
check: 		ldr r0,=Temp
			ldr r1, [r0, #4]
			ldr r2, [r0, #8]
			ldr r3, [r0, #12]
			orr r4, r1, r2
			orr r4, r4, r3
			cmp r4, #0
			bne make_happy

			ldr r1, [r0]
			cmp r1, #7
			bne check_for_1
			b print @and after that increment

check_for_1:ldr r2,=One       @ setup for increment
			ldr r3,=Current
			add r9, r2, #16
			mov r6, #0

			cmp r1, #1
			bne increment
			b print

print: 		mov r0, #Stdout @specify mode stdout to print
			ldr r2,=Current
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
		
			
			@ prepping for increment
			ldr r2,=One
			ldr r3,=Current
			add r9, r2, #16
			mov r6, #0

			b increment

increment:	ldr r4, [r2]
			ldr r5, [r3]
			add r11, r4, r5
			add r11, r11, r6
			mov r6, #0 @carry register do not modify here
			
			cmp r11, #10
			blt ahead2
			sub r11, r11, #10
			add r6, r6, #1
			
ahead2:		str r11, [r3]

			add r2, r2, #4
			add r3, r3, #4

			cmp r2, r9
			blt increment
			
			add r7, r7, #1
			b loop


check_gt: 	ldr r0,=Current
			ldr r1, [r0, #4]
			ldr r2, [r0, #8]
			ldr r3, [r0, #12]
			orr r4, r1, r2
			orr r4, r4, r3
			cmp r4, #0

			ldr r1,=Space
			mov r2, #0
			str r2, [r1]
			str r2, [r1, #4]
			str r2, [r1, #8]
			str r2, [r1, #12]
			bne make_happy
			b check

main:		mov r7, #0  		@current index

init_one:	ldr r1,=One
			ldr r3,=Current
			
			mov r2, #1
			str r2, [r1]
			str r2, [r3]

			mov r2, #0
			str r2, [r1, #4]
			str r2, [r1, #8]
			str r2, [r1, #12] 	@initialising as one in the memory

			str r2, [r3, #4]
			str r2, [r3, #8]
			str r2, [r3, #12] 	@initialising current 

			; mov r9,#100
			; mov r2, #9
			; mul r8,r9, r2
			; sub r8,r8,#1

			mov r8, #102
			; mov r0, #0x270F 

loop: 		cmp r7, r8
			bgt end
			ldr r1,=Current
			ldr r2,=Temp
			ldr r3, [r1]
			str r3, [r2]		@copied into Temp
			ldr r3, [r1, #4]
			str r3, [r2, #4]
			ldr r3, [r1, #8]
			str r3, [r2, #8]
			ldr r3, [r1, #12]
			str r3, [r2, #12]

			b check_gt  @check current

end: 		swi SWI_Exit

.data
	One: .space 16 @ to store BCD similar to x	
	Current: .space 16 @ for storing current BCD similar to x
	Temp: .space 16 @ for checking if a digit is happy similar to y
	DD: .space 16
	Space: .space 16
	Blank:   .ascii   " "
.end