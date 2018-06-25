;
; mod 8 = 6.asm
;
; Created: 2017-11-29 9:26:32 PM
; Author : Ethan Peterson
;
start:
	ldi r16, 0xFF
	clr r17 ; remainder
	inc r17
	clr r19 ; loop count max 3
	out 0x17, r16
	ldi r16, 30 // change val for testing purposes
	clc
	andi r16, 0b00000111
	cpi r16, 6
	breq isValue
	rcall red
	rjmp wait

isValue:
	rcall green
	rjmp wait

green:
	ldi r16, 1 << 3
	out 0x18, r16
	ret
red:
	ldi r16, 1 << 4
	out 0x18, r16
	ret

wait:
	rjmp wait

