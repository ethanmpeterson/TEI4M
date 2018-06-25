;
; day1.asm
;
; Created: 2017-11-15 10:26:13 AM
; Author : Ethan Peterson
;


; Replace with your application code
start:
	ldi r16, 0xFF
	out 0x17, r16
	ldi r16, 32 // change val for testing purposes
	clc
	andi r16, 0b00000111
	breq green
	
	//sbci r16, 127
	//brpl greater
	////rcall red
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
	out 0x18, r16
	ret
red:
	ldi r16, 1 << 4
	out 0x18, r16
	ret

wait:
	rjmp wait