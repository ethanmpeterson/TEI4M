;
; DoubleDabbleInClass.asm
;
; Created: 2018-01-11 2:28:36 PM
; Author : Ethan Peterson
;


.cseg
.def times = r24
.equ BYTE = 0xF3
.def temp = r25
.def three = r22

.org 0x00

	rjmp reset

reset:
	ldi r16, 243
	ldi times, 8
	ldi three, 3
	clr r17
	clr r18

repeat:
	lsl r16
	rol r17
	rol r18
	dec times
	breq convert

convert:
	mov temp, r17
	andi temp, 0x0F
	cpi temp, 0x05 // cpi a,b = a - b
	brlo tens //branch if lower
	add r17, three
tens:
	cpi r17,0x50
	brlo repeat
	add r17, threeZero
	rjmp repeat

