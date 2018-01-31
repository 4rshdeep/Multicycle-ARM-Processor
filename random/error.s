.equ SWI_Exit, 0x11
.equ displaystring, 0x204
.text
display:
mov r0,#0
mov r1,#0
ldr r2,=board
mov r4,#'X
str r4,[r2,#21]
disp:
swi displaystring
add r1,r1,#1
add r2,r2,#18
cmp r1,#9
blt disp

swi SWI_Exit
.data
board:
.asciiz "0 1 2 3 4 5 6 7 8"
.asciiz "1 _ _ _ _ _ _ _ _"
.asciiz "2 _ _ _ _ _ _ _ _"
.asciiz "3 _ _ _ _ _ _ _ _"
.asciiz "4 _ _ _ _ _ _ _ _"
.asciiz "5 _ _ _ _ _ _ _ _"
.asciiz "6 _ _ _ _ _ _ _ _"
.asciiz "7 _ _ _ _ _ _ _ _"
.asciiz "8 _ _ _ _ _ _ _ _"
.end