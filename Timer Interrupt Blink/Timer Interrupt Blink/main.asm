;
; Timer Interrupt Blink.asm
;
; Created: 2018-01-31 9:13:39 AM
; Author : Ethan Peterson
;
.equ clkDiv256 = 1 << CS12
.equ clkDiv64 = 1 << CS11 | 1 << CS10
.equ clkDiv8 = 1 << CS11
.org 0x0000
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16
rjmp start
.org 0x0040
start:
	sbi DDRB, PB5
	cli
	clr r17
	sts TCCR1A, r17
	ldi r17, clkDiv64
	sts TCCR1B, r17
	clr r17
	sts TCNT1H, r17
	sts TCNT1L, r17
	ldi r17, 1 << TOIE1
	sts TIMSK1, r17
	sei
	ldi r17, 1 << PB5
	rjmp wait

.org 0x001A 
rjmp ISR
ISR:
	com r17
	out PORTB, r17
	reti
wait:
	rjmp wait

