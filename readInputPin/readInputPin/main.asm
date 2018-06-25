;
; readInputPin.asm
;
; Created: 2017-12-01 12:02:57 PM
; Author : Ethan Peterson
;


; Replace with your application code
start:
    ldi r16, 1 << 3 | 1 << 4
	out 0x17, r16

loop:
	sbic 0x16, 0
	rcall green
	sbis 0x16, 0
	rcall red
	rjmp loop

green:
	ldi r16, 1 << 3
	out 0x18, r16
	ret
red:
	ldi r16, 1 << 4
	out 0x18, r16
	ret
