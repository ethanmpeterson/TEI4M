;
; Counting Bits.asm
;
; Created: 2017-11-27 1:32:37 PM
; Author : Ethan Peterson
;

start:
	ldi r16, 0xFF
	out 0x17, r16
	ldi r16, 6 // change val for testing purposes
	clr r19 ; clear the register to store count of set bits
	rcall again
	//rjmp wait

again:
	mov r18, r16
	ldi r17,1	; mask
	and r18, r17 ; test
	sbrc  r18, 0 ; skip next line if first bit is 0 checking index 0
	inc r19 ; incriment r19 number of set bits 
	asr r16 ; right shift r16 to change bit 0 to the next bit since sbrc only takes a constant.
	brne again
	; Test the bit count for even or odd
	sbrc r19, 0
	rjmp isOdd

isEven:
	rcall green
	rjmp wait

isOdd:
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