;
; upper lower nibbles equal.asm
;
; Created: 2017-11-30 6:23:20 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def upperNibble = r17
.def lowerNibble = r18


start:
	ldi r16, 0xFF
	clr r17 ; remainder
	inc r17
	clr r19 ; loop count max 3
	out 0x17, r16
	ldi r16, 0b11001100 // change val for testing purposes
	clc
	mov upperNibble, r16
	mov lowerNibble, r16

	andi upperNibble, 0b11110000
	swap upperNibble
	andi lowerNibble, 0b00001111
	cp lowerNibble, upperNibble
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


