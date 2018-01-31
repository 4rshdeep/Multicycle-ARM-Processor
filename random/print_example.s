@@@ PRINT STRINGS, CHARACTERS, INTEGERS TO STDOUT
.equ SWI_PrChr,0x00   @ Write an ASCII char to Stdout
.equ SWI_PrStr, 0x69   @ Write a null-ending string 
.equ SWI_PrInt,0x6b   @ Write an Integer
.equ Stdout,  1        @ Set output mode to be Output View
.equ SWI_Exit, 0x11   @ Stop execution

.global _start
.text


 		@ print a string to Stdout
_start: mov r0,#Stdout       @ mode is Stdout
		ldr r1, =Message1    @ load address of Message1
		swi SWI_PrStr        @ display message to Stdout
		
		@ print a new line as a string to Stdout
		mov r0,#Stdout       @ mode is Stdout
		ldr r1, =EOL         @ end of line
		swi SWI_PrStr
		
		@ print a character to the screen
		mov r0, #'A          @ R0 = char to print 
		swi SWI_PrChr 
		@ print an integer to Stdout
		mov R0,#Stdout       @ mode is Output view
		mov r1, #42          @ integer to print
		swi SWI_PrInt

.data
Message1: .asciz"Hello World!"
EOL:     .asciz   "\n"
NewL:    .ascii   "\n"
Blank:   .ascii   " "
.end