
.global main

main: 	mov r1, #1
		str r1, [sp, #-4]! @ pre decrement storing in stack
		mov r1, #0
		ldr r1, [sp], #4 @ post increment