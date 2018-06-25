;
; powerOf2.asm
;
; Created: 2017-11-30 9:20:33 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def setBitNum = r17
.def loopCount = r19
start:
	ldi r16, 0xFF
	clr setBitNum
	clr loopCount
	out 0x17, r16
	ldi r16, 32 // change val for testing purposes
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
	cpi setBitNum, 1
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



