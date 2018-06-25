.cseg
.def times = r24
.def temp = r25
.def three = r22
.def threeZero = r23
.org 0x00
	rcall reset
.org 0x2
table:
	.db 0, 1, 3, 2, 7, 6, 4, 5, 15, 14, 12, 13, 8, 9, 11, 10
reset:
	ldi ZL, LOW (table << 1)
	ldi ZH, HIGH (table << 1)
	ldi three, 3
	ldi threeZero, 48
	ldi r16,0
	out DDRD, r16
	ldi r16,7
	out DDRC,r16
	ldi r16,15
	out DDRB,r16

loadValue:
	in r16,PIND		;taking in the value from the encoder
	lsr r16			;shifts the data right because the data is taken from pin 1-4 from PORTD
	mov r30,r16		;moves the value from r16 into the Z stack pointer
	adiw ZH:ZL,4	;adds 4 to the Z stack pointer because the data in the table is offset by 4
	lpm r16,Z		;loads the value that the Z stack pointer is pointing to back into r16
	clr r17			;preparing register 17 for the double dabble
	ldi times,8		;preparing the cycle counter for the double dabble

repeat:
	lsl r16			;shifts the data left
	rol r17			;shifts r17 left and rolls in the carry bit
	dec times		;decrease the number of times
	breq pov		;if times == 0 then the double dabble is done and the data can be displayed
	
convert:
	mov temp,r17	;move register 17 to the temporary register
	andi temp,0x0F	;gets rid of the upper nibble
	cpi temp,0x05	;compare the lower nibble to 5
	brlo repeat		;if the lower nibble was not equal to or greater than 5 jump back to the start of the algorithm
	add r17,three
	rjmp repeat

pov:
	cbi PORTB,1		;clear the previously set bit for displaying tens
	
	out PORTC,r17	;
	sbi PORTB,0
	rcall wait

	cbi PORTB,0
	
	swap r17
	out PORTC,r17
	sbi PORTB,1
	rcall wait

	rjmp loadValue
	
wait:
	ldi  r26, 208
    ldi  r27, 202
L1: dec  r27
    brne L1
    dec  r26
    brne L1
	ret
    
