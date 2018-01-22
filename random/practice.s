.equ SWI_Exit, 0x11

.global main

main:	mov r0,#0x02
		swi 0x201        @ left LED on
		mov r0,#0x01
		swi 0x201        @ right LED on
		mov r0,#0x03
		swi 0x201    


end:	swi SWI_Exit

.data
	Hello: .asciz "hello world!"