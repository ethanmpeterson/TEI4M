;
; Challenge1.asm
;
; Created: 2017-12-01 1:41:07 PM
; Author : Ethan Peterson
;
.def setBits = r17 ; setBits will hold the # of set bits in the PINB I/O register. I will check whether the value in setBits is odd or even to determine whether the number of set bits is odd or even on the switch.
start:
    ldi r16, 1 << 3 | 1 << 4 ; set bits 3 and 4 in r16
	out 0x17, r16 ; Set led pins to output by copying r16 to direction register

loop:
	
	clr setBits ; start at 0 for # of set bits by clearing the register

	; collect # of set bits
	; 0x16 is the address for the PINB I/O register we are checking
	sbic 0x16, 0 ; skip next line if bit given is cleared. We are checking the PINB I/O register and incrimenting the # of set bits if one of the BCD's outputs is high since the inc command wont be skipped if the bit being checked is set.
	inc setBits

	; repeat the step above for all 3 bits we must check to read values from 0 - 7 inclusive
	sbic 0x16, 1 
	inc setBits

	sbic 0x16, 2
	inc setBits

	; test if the register holding the number of set bits by dividing by two. If there is a remainder then the number of set bits is Odd
	lsr setBits ; use lsr to divide by two (logical shift right)
	brbc 0, isEven ; if the least significant bit was set meaning the number was not divisible by two a 1 is placed in the C flag SREG So branch off only if the C flag is clear which means the division had no remainder and was divisible by two
	rcall red ; if the result was odd than turn on the red LED and continue to loop
	rjmp loop

isEven:
	rcall green // turn on the green LED and go back to the loop for continuous monitoring
	rjmp loop

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
