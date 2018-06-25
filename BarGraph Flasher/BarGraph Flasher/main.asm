;
; BarGraph Flasher.asm
;
; Created: 2017-11-30 10:00:56 PM
; Author : Ethan Peterson
;


; Replace with your application code
start:
	ldi r16, 0xFF
	out 0x0A, r16
	out 0x04, r16
	ldi r16, 0b10101010
	

loop:
	out 0x0B, r16
	lsl r16
	rol r17
	out 0x05, r17

	rcall delay

	ldi r16, 0b10101010
	lsl r17
	lsr r16
	out 0x0B, r16
	out 0x05, r17

	rcall delay

	clr r17
	ldi r16, 0b10101010
	rjmp loop

delay:
	ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret
	
    
