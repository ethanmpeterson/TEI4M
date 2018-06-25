;
; binary palindrome.asm
;
; Created: 2017-11-28 8:57:14 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def mask = r18
start:
	ldi r16, 0xFF
	out 0x17, r16
	ldi r16, 0 // change val for testing purposes
	cpi r16, 0
	breq isPalindrome ; grab base case all 0s
	cpi r16, 0xFF
	breq isPalindrome ; grab base case 255
	mov r17, r16 ; copy r16 to r17
	ldi r18, 0b1000000
	mov r17, r16
	//clr r19 ; clear r19 to store reversed byte

	sbrc r17, 0
	ori r17, 1 << 7

	sbrc r17, 1
	ori r17, 1 << 6

	sbrc r17, 2
	ori r17, 1 << 5

	sbrc r17, 3
	ori r17, 1 << 4

	sbrc r17, 4
	ori r17, 1 << 3

	sbrc r17, 5
	ori r17, 1 << 2

	sbrc r17, 6
	ori r17, 1 << 1

	sbrc r17, 7
	ori r17, 1 << 0

	cp r17, r16
	breq isPalindrome
	rcall red
	rjmp wait


isPalindrome:
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