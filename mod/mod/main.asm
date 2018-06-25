;
; mod.asm
;
; Created: 2017-11-29 6:51:34 PM
; Author : Ethan Peterson
;


; Replace with your application code
start:
	ldi r16, 0xFF
	clr r17 ; remainder
	clr r19 ; loop count max 3
	out 0x17, r16
	ldi r16, 23 // change val for testing purposes
	clc
	

again:
	lsr r16
	brbs 0, remainder
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

remainder:
	inc r17
	lsl r17
	inc r19
	cpi r19, 2
	breq result
	rjmp again

result:
	cpi r17, 7 - 1
	breq isValue
	rcall red
	rjmp wait

wait:
	rjmp wait
