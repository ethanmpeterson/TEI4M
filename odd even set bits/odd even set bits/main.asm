;
; odd even set bits.asm
;
; Created: 2017-11-30 6:51:36 PM
; Author : Ethan Peterson
;

.def setBitNum = r17
.def loopCount = r19
start:
	ldi r16, 0xFF
	clr setBitNum
	clr loopCount
	out 0x17, r16
	ldi r16, 30 // change val for testing purposes
	clc

again:
	lsr r16
	inc loopCount
	brbs 0, setBit
	cpi loopCount, 8
	breq loopComplete
	rjmp again


setBit:
	inc setBitNum
	rjmp again

loopComplete:
	lsr setBitNum
	brbc 0, isValue
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


