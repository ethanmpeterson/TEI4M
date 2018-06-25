;
; PowerOfTwo.asm
;
; Created: 2017-11-27 2:18:01 PM
; Author : Ethan Peterson
;
start:
	ldi r16, 0xFF
	out 0x17, r16
	ldi r16, 8 // change val for testing purposes
	tst r16
	breq isNot 
	mov r17, r16
	dec r17
	and r17, r16
	brne isNot
	rcall green ; its a power
	rjmp wait
isNot:
	rcall red
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
