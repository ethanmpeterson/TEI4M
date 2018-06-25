#include "prescalers.h"
.def toggle = r17
.org 0x0000
	rjmp reset
.org 0x000E
	rjmp TIM2_COMPA
reset:
	ldi toggle, 1 << PB3
	cli
	ldi r16, T2ps1024 ; set the prescaler
	sts TCCR2B, r16 ; store to appropriate register
	ldi r16, 0x02 ; set timer mode 2
	sts TCCR2A, r16 ; store
	ldi r16, 124 ; set output compare number to get 63hz freq
	sts OCR2A, r16 ; store to output compare reg

	; prep the port
	sbi DDRB, PB3 ; pin set to output

	ldi r16, 1 << OCIE2A ; set timer interrupt enable bit
	sts TIMSK2, r16 ; enable the interrupt
	; add 2.5s delay
	sei


wait:
	rjmp wait

TIM2_COMPA:
	in r16, PORTB
	eor r16, r17
	out r16, PORTB
	reti
	