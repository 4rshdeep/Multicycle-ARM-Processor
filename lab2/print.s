.equ SWI_Exit, 0x11
.equ SWI_PrStr, 0x69
.equ SWI_Open, 0x66
.equ SWI_Close, 0x68

; NOT WORKING COMPLETED
.text

.global main

; swap:	mov r10, r3
; 		mov r3, r2
; 		mov r2, r10
; 		mov pc, lr
; do not give 
; space between labels and :

main:	ldr r0,=OutFileName
		mov r1, #1
		swi SWI_Open
		bcs OutFileError
		ldr r1,=OutFileHandle  @ Address where we want to 
		str r0, [r1]		   @ save the OutFileHandle
		

		ldr r1,=TextString
		swi SWI_PrStr


; after execution file should be closed else is left unusable
		ldr r0,=OutFileHandle
		ldr r0, [r0]
		swi SWI_Close

end: 	swi SWI_Exit
	OutFileError: .asciz "Unable to open output file \n"
.data
	P: .word 4, 10
	OutFileName: .asciz "output.txt"
		.align
	OutFileHandle: .word 0

	TextString: .asciz "hello world"
      
.end

