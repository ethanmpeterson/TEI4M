;
; directives.asm
;
; Created: 2017-12-13 2:06:01 PM
; Author : Ethan Peterson
;

.org 0x0000
	rjmp reset 
.org 0x0001
	rjmp exInt0
; Replace with your application code
reset:
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16
