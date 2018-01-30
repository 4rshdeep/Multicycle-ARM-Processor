@ r0, 1, 7, 8 being used for print_board
@ r10 -> contains address of the board
@ r9 -> contains an integer telling which player's turn it is (0/1)
@ r4 -> to check if move was valid or not (USE JUST AFTER check_one)


@ADD CONDITION IN CHECK_ONE_LEFT IN ALL DIRECTIONS
@IF GIVEN MOVE HAS ALREADY BEEN PLAYED, SHOW invalid_move.


.equ SWI_Exit, 0x11
.equ SWI_PrStr, 0x69
.equ SWI_Open, 0x66
.equ SWI_Close, 0x68
.equ SWI_Exit, 0x11
.equ SWI_PrInt,0x6b   @ Write an Integer
.equ Stdout, 1
.equ SWI_PrStr, 0x69   @ Write a null-ending string 


.text
.global main

main:
	ldr r10, =Board
	mov r9, #1
	bl print_board
			; mov r7, #1	@testing start
			; mov r8, #6
			; bl check_one 	@testing null-ending
			; b end 	@remove later if needed


loop:
	; mov r11, #1
	; cmp r9, #1
	; bleq check_one
	; 	@turn skip CONDITION
	; 	@turn skip + game end
	; mov r11, #1
	; blne check_zero
		@check moves   (put 1 in r11 if but initially 0)
		@ in check_one see if r11 contains 1 or 0 then decide if move is to be done or is it just needed to check if move is available
		@ mem to check if moves are present
	bl read
	cmp r9, #1
	mov r11, #0
	bleq check_one
	blne check_zero
	cmp r4, #1
	rsbeq r9, r9, #1		@check reverse sub
	b loop

read:
	mov r0, #0
	str lr, [sp, #-4]!	@push 
L:  swi 0x203
	cmp r0, #0
	beq L
	mov r1, #0
	tst r0, #255
	addeq r1, r1, #8
	moveq r0, r0, LSR #8
	tst r0, #15
	addeq r1, r1, #4
	moveq r0, r0, LSR #4
	tst r0, #3
	addeq r1, r1, #2
	moveq r0, r0, LSR #2
	tst r0, #1
	addeq r1, r1, #1
	moveq r0, r0, LSR #1
	mov r8, r1
	mov r0, #0
L2:  swi 0x203
	cmp r0, #0
	beq L2
	mov r1, #0
	tst r0, #255
	addeq r1, r1, #8
	moveq r0, r0, LSR #8
	tst r0, #15
	addeq r1, r1, #4
	moveq r0, r0, LSR #4
	tst r0, #3
	addeq r1, r1, #2
	moveq r0, r0, LSR #2
	tst r0, #1
	addeq r1, r1, #1
	moveq r0, r0, LSR #1
	mov r7, r1
	ldr lr, [sp], #4	@pop
	mov pc, lr



; game:


@ r7 - outer loop counter  (its temp in r5)
@ r8 -> inner loop counter  (its temp in r6)
@ r5, r6 (see above)
; one_avail:
	; str lr, [sp, #-4]!	@push 
	; mov r7, #0
	; mov r8, #0
; 	bl my_outer
; 	ldr lr, [sp], #4	@pop
; 	mov pc, lr

; my_outer:
; 	str lr, [sp, #-4]!	@push 
; 	cmp r7, #9
; 	ldreq lr, [sp], #4	@pop
; 	moveq pc, lr
	

; my_inner:
; 	cmp r8, #9
; 	moveq r8, #0
; 	addeq r7, r7, #1
; 	beq my_outer
; 		mov r5, r7		@LEFT DIRECTION
; 		mov r6, r8
; 		cmp r6, #0
; 		blgt left

; sdhajbsjahb
; 	add r8, r8, #1
; 	b my_inner


; left:
; 	str lr, [sp, #-4]!	@push 
; 	sub r6, r6, #1
; 	add r1, r6, r5, LSL #3
; 	ldrb r2, [r10, r1]
; 	cmp r2, #1
; 	ldrlt lr, [sp], #4	@pop
; 	movlt pc, lr



; zero_avail:
; 	mov pc, lr


@ r7, r8  (coordinates which are requested as next move)
@ r5, r6 (copy of r7, r8)
@ r4 -- finally 0 -> invalid move
@				1 -> valid move has been completed	
check_zero:
	mov r4, #0
	str lr, [sp, #-4]!	@push 
	mov r5, r7
	mov r6, r8
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #2
	blt AA
	; ldrgt lr, [sp], #4	@pop
	; movgt pc, lr
		cmp r6, #1
		subgt r6, r6, #1
		blgt check_zero_left
		mov r6, r8
		cmp r6, #6
		addlt r6, r6, #1
		bllt check_zero_right
		mov r6, r8
		cmp r5, #1
		subgt r5, r5, #1
		blgt check_zero_up
		mov r5, r7
		cmp r5, #6
		addlt r5, r5, #1
		bllt check_zero_down
		mov r5, r7
		cmp r6, #1
		cmpgt r5, #1
		subgt r5, r5, #1
		subgt r6, r6, #1
		blgt check_zero_left_up
		mov r5, r7
		mov r6, r8
		cmp r6, #6
		cmplt r5, #6
		addlt r5, r5, #1
		addlt r6, r6, #1
		bllt check_zero_right_down
		mov r5, r7
		mov r6, r8
		cmp r5, #1
		cmpgt r6, #6	@ up right
		sublt r5, r5, #1
		addlt r6, r6, #1
		bllt check_zero_right_up
		mov r5, r7
		mov r6, r8
		cmp r5, #6	@what if this gives gt????????????????
		cmplt r6, #1	@down left
		subgt r6, r6, #1
		addgt r5, r5, #1
		blgt check_zero_left_down
		mov r5, r7
		mov r6, r8
	cmp r4, #1		@edit r7, r8 if a vaild move
	addeq r0, r8, r7, LSL #3
	mov r2, #0
	streqb r2, [r10, r0]
	bl print_board
AA:	ldr lr, [sp], #4	@pop
	mov pc, lr

check_zero_left_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addeq r5, r5, #1
	subeq r6, r6, #1
	bleq check_zero_left_down
	bllt set_zero_left_down	@set zero on indexes from r7+1,r6+1 to r5-1,r8-1
							@also set r4 for deciding validity
							@i.e. if r7+1,r6+1 to r5-1,r8-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_zero_left_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	subgt r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq jj
	sub r5, r5, #1
	add r6, r6, #1
	cmp r7, r5 		@will it suffice to compare only zero out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_left_down
jj:	ldr lr, [sp], #4	@pop
	mov pc, lr					 



check_zero_right_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	subeq r5, r5, #1
	addeq r6, r6, #1
	bleq check_zero_right_up
	bllt set_zero_right_up	@set zero on indexes from r5+1,r8+1 to r7-1,r6-1
							@also set r4 for deciding validity
							@i.e. if r5+1,r8+1 to r7-1,r6-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_zero_right_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	subgt r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq kk
	add r5, r5, #1
	sub r6, r6, #1
	cmp r5, r7 		@will it suffice to compare only zero out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_right_up
kk:	ldr lr, [sp], #4	@pop
	mov pc, lr					 


check_zero_right_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addeq r5, r5, #1
	addeq r6, r6, #1
	bleq check_zero_right_down
	bllt set_zero_right_down	@set zero on indexes from r7-1,r8-1 to r5+1,r6+1
							@also set r4 for deciding validity
							@i.e. if r7-1,r8-1 to r5+1,r6+1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_zero_right_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	subgt r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq ll
	sub r5, r5, #1
	sub r6, r6, #1
	cmp r7, r5 		@will it suffice to compare only zero out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_right_down
ll:	ldr lr, [sp], #4	@pop
	mov pc, lr					 



check_zero_left_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	subeq r5, r5, #1
	subeq r6, r6, #1
	bleq check_zero_left_up
	bllt set_zero_left_up	@set zero on indexes from r5+1,r6+1 to r7-1,r8-1
							@also set r4 for deciding validity
							@i.e. if r5+1,r6+1 to r7-1,r8-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_zero_left_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	subgt r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq mm
	add r5, r5, #1
	add r6, r6, #1
	cmp r5, r7 		@will it suffice to compare only zero out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_left_up
mm:	ldr lr, [sp], #4	@pop
	mov pc, lr					 

	
check_zero_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addeq r5, r5, #1
	bleq check_zero_down
	bllt set_zero_down	@set zero on indexes from r7+1 to r5-1
						@also set r4 for deciding validity
						@i.e. if r7+1 to r5-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_zero_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq nn
	sub r5, r5, #1
	cmp r7, r5
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_down
nn:	ldr lr, [sp], #4	@pop
	mov pc, lr					 

	
check_zero_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	subeq r5, r5, #1
	bleq check_zero_up
	bllt set_zero_up		@set zero on indexes from r5+1 to r7-1
						@also set r4 for deciding validity
						@i.e. if r5+1 to r7-1 contains any bits b/w them or not
	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_zero_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	movgt r4, #1
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq bb
	add r5, r5, #1
	cmp r5, r7
	@moved next 3 lines
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_up
bb:	ldr lr, [sp], #4	@pop
	mov pc, lr					 
	

check_zero_right:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addeq r6, r6, #1
	bleq check_zero_right
	bllt set_zero_right	@set zero on indexes from r8+1 to r6-1
						@also set r4 for deciding validity
						@i.e. if r8+1 to r6-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_zero_right:
	str lr, [sp, #-4]!	@push 
	sub r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq vv
	sub r6, r6, #1
	cmp r8, r6
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_right
vv:	ldr lr, [sp], #4	@pop
	mov pc, lr


check_zero_left:
	str lr, [sp, #-4]!	@push 
	@if u go too left and the grid ends (next 3 lines)
	cmp r6, #0
	ldrlt lr, [sp], #4	@pop
	movlt pc, lr
	@if u go too left and the grid ends (previous 3 lines)
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	subeq r6, r6, #1
	bleq check_zero_left
	bllt set_zero_left 	@set zero on indexes from r6+1 to r8-1
						@also set r4 for deciding validity
						@i.e. if r6+1 to r8-1 contains any bits b/w them or not
	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_zero_left:
	str lr, [sp, #-4]!	@push 
	sub r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =W_check
	streqb  r4, [r12]
	beq cc
	add r6, r6, #1
	cmp r6, r8
	@ moved next 3 lines in convert_to_zero:
	movlt r2, #0
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_zero_left 
cc:	ldr lr, [sp], #4	@pop
	mov pc, lr

















@ r7, r8  (coordinates which are requested as next move)
@ r5, r6 (copy of r7, r8)
@ r4 -- finally 0 -> invalid move
@				1 -> valid move has been completed	
check_one:
	mov r4, #0
	str lr, [sp, #-4]!	@push 
	mov r5, r7
	mov r6, r8
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #2
	blt A
	; ldrgt lr, [sp], #4	@pop
	; movgt pc, lr
		cmp r6, #1
		subgt r6, r6, #1
		blgt check_one_left
		mov r6, r8
		cmp r6, #6
		addlt r6, r6, #1
		bllt check_one_right
		mov r6, r8
		cmp r5, #1
		subgt r5, r5, #1
		blgt check_one_up
		mov r5, r7
		cmp r5, #6
		addlt r5, r5, #1
		bllt check_one_down
		mov r5, r7
		cmp r6, #1
		cmpgt r5, #1
		subgt r5, r5, #1
		subgt r6, r6, #1
		blgt check_one_left_up
		mov r5, r7
		mov r6, r8
		cmp r6, #6
		cmplt r5, #6
		addlt r5, r5, #1
		addlt r6, r6, #1
		bllt check_one_right_down
		mov r5, r7
		mov r6, r8
		cmp r5, #1
		cmpgt r6, #6	@ up right
		sublt r5, r5, #1
		addlt r6, r6, #1
		bllt check_one_right_up
		mov r5, r7
		mov r6, r8
		cmp r5, #6	@what if this gives gt????????????????
		cmplt r6, #1	@down left
		subgt r6, r6, #1
		addgt r5, r5, #1
		blgt check_one_left_down
		mov r5, r7
		mov r6, r8
	cmp r4, #1		@edit r7, r8 if a vaild move
	addeq r0, r8, r7, LSL #3
	streqb r4, [r10, r0]
	bl print_board
A:	ldr lr, [sp], #4	@pop
	mov pc, lr

check_one_left_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addlt r5, r5, #1
	sublt r6, r6, #1
	bllt check_one_left_down
	bleq set_one_left_down	@set one on indexes from r7+1,r6+1 to r5-1,r8-1
							@also set r4 for deciding validity
							@i.e. if r7+1,r6+1 to r5-1,r8-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_one_left_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	subgt r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq ii
	sub r5, r5, #1
	add r6, r6, #1
	cmp r7, r5 		@will it suffice to compare only one out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_left_down
ii:	ldr lr, [sp], #4	@pop
	mov pc, lr					 



check_one_right_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	sublt r5, r5, #1
	addlt r6, r6, #1
	bllt check_one_right_up
	bleq set_one_right_up	@set one on indexes from r5+1,r8+1 to r7-1,r6-1
							@also set r4 for deciding validity
							@i.e. if r5+1,r8+1 to r7-1,r6-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_one_right_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	subgt r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq oo
	add r5, r5, #1
	sub r6, r6, #1
	cmp r5, r7 		@will it suffice to compare only one out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_right_up
oo:	ldr lr, [sp], #4	@pop
	mov pc, lr					 


check_one_right_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addlt r5, r5, #1
	addlt r6, r6, #1
	bllt check_one_right_down
	bleq set_one_right_down	@set one on indexes from r7-1,r8-1 to r5+1,r6+1
							@also set r4 for deciding validity
							@i.e. if r7-1,r8-1 to r5+1,r6+1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_one_right_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	subgt r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq pp
	sub r5, r5, #1
	sub r6, r6, #1
	cmp r7, r5 		@will it suffice to compare only one out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_right_down
pp:	ldr lr, [sp], #4	@pop
	mov pc, lr					 



check_one_left_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	sublt r5, r5, #1
	sublt r6, r6, #1
	bllt check_one_left_up
	bleq set_one_left_up	@set one on indexes from r5+1,r6+1 to r7-1,r8-1
							@also set r4 for deciding validity
							@i.e. if r5+1,r6+1 to r7-1,r8-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_one_left_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	subgt r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq ss
	add r5, r5, #1
	add r6, r6, #1
	cmp r5, r7 		@will it suffice to compare only one out of X and Y????????????????????????????????????????????????????
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_left_up
ss:	ldr lr, [sp], #4	@pop
	mov pc, lr					 

	
check_one_down:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addlt r5, r5, #1
	bllt check_one_down
	bleq set_one_down	@set one on indexes from r7+1 to r5-1
						@also set r4 for deciding validity
						@i.e. if r7+1 to r5-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr

set_one_down:
	str lr, [sp, #-4]!	@push 
	sub r3, r5, r7
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq dd
	sub r5, r5, #1
	cmp r7, r5
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_down
dd:	ldr lr, [sp], #4	@pop
	mov pc, lr					 

	
check_one_up:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	sublt r5, r5, #1
	bllt check_one_up
	bleq set_one_up		@set one on indexes from r5+1 to r7-1
						@also set r4 for deciding validity
						@i.e. if r5+1 to r7-1 contains any bits b/w them or not
	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_one_up:
	str lr, [sp, #-4]!	@push 
	sub r3, r7, r5
	cmp r3, #1
	movgt r4, #1
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq ff
	add r5, r5, #1
	cmp r5, r7
	@moved next 3 lines
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_up
ff:	ldr lr, [sp], #4	@pop
	mov pc, lr					 
	

check_one_right:
	str lr, [sp, #-4]!	@push 
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	addlt r6, r6, #1
	bllt check_one_right
	bleq set_one_right	@set one on indexes from r8+1 to r6-1
						@also set r4 for deciding validity
						@i.e. if r8+1 to r6-1 contains any bits b/w them or not 
	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_one_right:
	str lr, [sp, #-4]!	@push 
	sub r3, r6, r8
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq gg
	sub r6, r6, #1
	cmp r8, r6
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_right
gg:	ldr lr, [sp], #4	@pop
	mov pc, lr


check_one_left:
	str lr, [sp, #-4]!	@push 
	@if u go too left and the grid ends (next 3 lines)
	cmp r6, #0
	blt zx
	; ldrlt lr, [sp], #4	@pop
	; movlt pc, lr
	@if u go too left and the grid ends (previous 3 lines)
	add r0, r6, r5, LSL #3
	ldrb r1, [r10, r0]
	cmp r1, #1
	sublt r6, r6, #1
	bllt check_one_left
	bleq set_one_left 	@set one on indexes from r6+1 to r8-1
						@also set r4 for deciding validity
						@i.e. if r6+1 to r8-1 contains any bits b/w them or not
zx:	ldr lr, [sp], #4	@pop
	mov pc, lr					 

set_one_left:
	str lr, [sp, #-4]!	@push 
	sub r3, r8, r6
	cmp r3, #1
	movgt r4, #1	@validate the move
	cmp r11, #1
	ldr r12, =B_check
	streqb  r4, [r12]
	beq hh
	add r6, r6, #1
	cmp r6, r8
	@ moved next 3 lines in convert_to_one:
	movlt r2, #1
	addlt r1, r6, r5, LSL #3
	strltb r2, [r10, r1]
	bllt set_one_left 
hh:	ldr lr, [sp], #4	@pop
	mov pc, lr



print_board:	@stores offset in r7  and  data from mem in r8
	str lr, [sp, #-4]!	@push 
	mov r1, #0	@counter for outer loop (Y)
	mov r0, #0	@counter for inner loop (X)

print_outer_loop:
	cmp r1, #8
	beq	print_done	@SEE !!!

print_inner_loop:	
	cmp r0, #16
	movge r0, #0
	addge r1, r1, #1
	bge print_outer_loop
	; moveq r0, #0
	; addeq r1, r1, #1
	; beq print_outer_loop
	add r7, r0, r1, LSL #3	@offset for accesing board
	sub r7, r7, r0, LSR #1
	ldrb r8, [r10, r7] 
	cmp r8, #1
	ldreq r2, =B
	ldrlt r2, =W
	ldrgt r2, =U
	swi 0x204	@print on embest board LCD
	add r0, r0, #2
	b print_inner_loop

print_done:
	ldr lr, [sp], #4	@pop
	mov pc, lr

end:
	mov r0, #99

.data
	Board: .byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,0,2,2,2,2,2,2,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
@	Board: .byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,2,2,2,2,2,2,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
@	Board: .byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,0,2,2,2,2,0,1,0,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

@	Board: .byte 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,2,1,0,2,2,2,2,2,2,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
@	Board: .byte 64	@space for the 8X8 board
	W: .asciz "W"   @0
	B: .asciz "B"	@1
	U: .asciz "-"	@2
	W_check: .byte 0
	B_check: .byte 0
.end	