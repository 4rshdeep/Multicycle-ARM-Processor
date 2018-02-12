.equ seg_A, 0x80  
.equ seg_B, 0x40  
.equ seg_C, 0x20  
.equ seg_D, 0x08  
.equ seg_E, 0x04  
.equ seg_F, 0x02  
.equ seg_G, 0x01  
.equ seg_P, 0x10 
.equ SET_SETSEG8, 0x200


.global main


@prints the number in r0 in Embest Board Plugin
main:	mov r0, #2
		ldr r2, = Digits
		ldr r0, [r2, r0, LSL #2] 
		swi SET_SETSEG8




















Digits: 
.word seg_A | seg_B | seg_C | seg_D | seg_E|seg_G       @0 
.word seg_B | seg_C 									@1 
.word seg_A | seg_B | seg_F | seg_E | seg_D 			@2 
.word seg_A | seg_B | seg_F | seg_C | seg_D             @3 
.word seg_G | seg_F | seg_B | seg_C                     @4 
.word seg_A | seg_G | seg_F | seg_C | seg_D             @5 
.word seg_A | seg_G | seg_F | seg_E | seg_D | seg_C     @6 
.word seg_A | seg_B | seg_C                             @7 
.word seg_A|seg_B|seg_C|seg_D|seg_E|seg_F|seg_G 		@8  
.word seg_A | seg_B | seg_F | seg_G | seg_C		        @9 
.word 0                                                             @Blank displ 