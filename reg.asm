;
; day1.asm
;
; Created: 2017-11-15 10:26:13 AM
; Author : Ethan Peterson
;


; Replace with your application code
start:
	ldi r16, 0b00001100
	out 0x04, r16
	ldi r16, 125 // change val for testing purposes
	clc
	sbci r16, 127
	brpl greater
	//brlt greater
	rcall red
   rjmp wait
   //ldi r16, 15
   ///ldi r17, 0x01
  // and r17, r16
   //lds r18, r17 

greater:
	rcall green
	rjmp wait

green:
	ldi r16, 1 << 3
	out 0x05, r16
	ret
red:
	ldi r16, 1 << 2
	out 0x05, r16
	ret

wait:
	rjmp wait