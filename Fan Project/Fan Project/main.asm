;
; Fan Project.asm
;
; Created: 2018-04-11 12:38:48 PM
; Author : Ethan Peterson
;

; Replace with your application code
#include "prescalers.h"

#define F_CPU 16000000 ; cpu freq 16 Mhz
#define PRESCALE 8
#define F_FAN 25000
#define FREQ F_CPU/PRESCALE/F_FAN ; (OCR2A) = 80
#define DUTY 40 ; start with a 50% duty cycle

; UART Defines
#define BAUDRATE 103
#define newLine 13
#define offset 'A'

.def duty = r19
.def pulseCount = r20 ; count of fan pulses used to determine RPM / RPS
.def rps = r21 ; revolutions per second register
.def txByte = r22 ; byte of data that is sent out via UART interface
.def empirical = r23
.def setPoint = r24
.def difference = r25


.cseg
	.org 0x0000
		rjmp reset
	.org 0x0020
		rjmp TIM0_OVF
	.org 0x002A
		rjmp ADC_Complete
	.org 0x0014
		rjmp TIM1_CAPT
	.org 0x001A
		rjmp TIM1_OVF

.org	0x0050

RPMStart:
;.db 900, 900, 900, 900, 1200, 2000, 2700, 3400, 4050, 4500, 4800, 0 datasheet RPMs
.db 30, 30, 30, 30, 40, 66, 90, 113, 135, 150, 160, 0 ; datasheet RPS 
RPMEnd:

Greeting:
	.db "Hello, World!",newLine ; test string that has a newline character attached ASCII 13


.org 0x0100 ; start past interrupt vector table

reset:
	cli

	rcall RPMInit
	rcall PWMInit
	rcall ADCInit
	rcall T0Init
	rcall T1Init ; sense wire interrupt to capture falling edge of the sense wire signal and calculate RPS
	rcall UARTInit
	rcall display ; will show our greeting string hello world in terminal window

	sei

wait:
	rjmp wait

UARTInit:
	ldi r16, BAUDRATE >> 8
	sts UBRR0H, r16
	ldi r16, BAUDRATE
	sts UBRR0L, r16
	ldi r16, 1 << TXEN0 ;| (1 << RXEN0) ; enable transmission and reception bits and store to 
	sts UCSR0B, r16 ; store to UART Character size register
	ldi r16, (1 << UCSZ01) | (1 << UCSZ00) ; set character size to 8 bits in UCSR0C register
	sts UCSR0C, r16
	ret

display:
	ldi xl, low(Greeting << 1)
	ldi xh, high(Greeting << 1) ; start address of the greeting string

	movw z, x

nextChar:
	lpm txByte, z+ ; use z+ to incriment to next index
	
	rcall transmit
	cpi txByte, newLine ; check if the newLine character has been reached if so exit with ret otherwise continue looping and transmitting each character individually
	brne nextChar
	ret

transmit:
	lds r16, UCSR0A ; load UART status reg into r16
	sbrs r16, UDRE0 ; skip the line below if the UDRE0 bit in r16 is set indicating that the system is ready for another character to print
	rjmp transmit
	sts UDR0, txByte ; transmit the next character in the string
	ret
	

ADCInit:
	ser r16 ; set all bits in r16
	sts DIDR0, r16 ; reduce power consumption by disabling digital fucntionality of the ADC pins
	ldi r16, (1 << REFS0) | (1 << ADLAR)
	sts ADMUX, r16
	; Enable, start dummy conversion, enable timer as trigger, prescaler
	ldi r16, (1 << ADEN) | (1 << ADSC) | (1 << ADATE) | (1 << ADIE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0)
	sts ADCSRA, r16
	ldi r16, 1 << ADTS2
	sts ADCSRB, r16
dummy:
	lds r16, ADCSRA
	andi r16,  1 << ADIF
	breq dummy
	ret

RPMInit:
	ldi xl, low(RPMStart << 1) ; position x and y registers at the start and end of RPM value table
	ldi xh, low(RPMStart << 1)
	ldi yl, low(RPMEnd << 1)
	ldi yh, low(RPMEnd << 1)
	movw z, x
	ret

PWMInit:
	ldi r16, 1 << PORTD3
	out DDRD, r16
	ldi r16, (1 << COM2B1) | (1 << WGM21) | (1 << WGM20) ; OC2A disconnected, OC2B connected, MODE 7 (OCR2A as TOP)
	sts TCCR2A, r16
	ldi r16, (1 << WGM22) | (1 << T2ps8) ; complete WGM definition and prescaler
	sts TCCR2B, r16
	ldi r16, FREQ
	sts OCR2A, r16
	ldi r16, DUTY
	sts OCR2B, r16
	ret

T1Init: ; T1 interrupt which runs every second to calculate RPS
	eor r16, r16 ; clear by exclusive or on the register with itself
	sts TCCR1A, r16
	ldi r16, T1ps256 | (1 << ICES1) ; without prescalers.h use 1 << CS12 : 2^24/2^16/2^8 = 1 Hz
	sts TCCR1B, r16
	ldi r16, (1 << ICIE1) | (1 << TOIE1) ; set input capture enable and overflow interrupt enable bits
	sts TIMSK1, r16
	clr pulseCount
	ret

T0Init: ; initialize T0 interrupt to schedule ADC conversions
	clr r16
	out TCCR0A, r16 ; normal mode OC0A/B disconnected
	ldi r16, T0ps1024 ; 2^24/2^10/2^8 = 2^6 = 64 ADC conversions per second
	out TCCR0B, r16
	ldi r16, 1 << TOIE0 ; Timer interrupt enable
	sts TIMSK0, r16 ; output to mask register
	ret

TIM0_OVF:
	reti ; required to have the ADIF cleared

ADC_Complete:
	lds duty, ADCH ; load reading into duty cycle register
	ldi r16, FREQ
	mul r16, duty
	sts OCR2B, r1 ; load mapped value between 0 and 80 into OCR2B to change RPM in reponse to potentiometer reading
	reti

TIM1_CAPT:
	inc pulseCount
	reti

TIM1_OVF:
	mov empirical, pulseCount ; get the number of pulses
	clr pulseCount ; clear the number of pulses so it can start counting up again 
	ldi difference, offset ; set difference to offset value to prevent negative values in the data visualizer
	add difference, empirical
	mov r16, duty ; get duty cycle value [0, 80]
	lsr r16 ; lsr 3 times to divide by 8
	lsr r16
	lsr r16
	movw z, x ; zero index of the rps array
	add zl, r16 ; set the index by adding r16
	lpm setPoint, z ; get array element using z index value 
	sub difference, setPoint ; get the difference between the set RPS of the fan and the actual RPS it spins at
	mov txByte, difference ; load difference into the txByte register. The numerical data will be used to form a graph in the data visualizer
	rcall transmit ; call transmit to send txByte out via serial communication
	reti

	