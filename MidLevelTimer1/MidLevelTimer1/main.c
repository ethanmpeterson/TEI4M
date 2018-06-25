/*
 * MidLevelTimer1.c
 *
 * Created: 2018-02-02 1:37:15 PM
 * Author : Ethan Peterson
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
// prescale constants
uint8_t clkDiv1 = 1 << CS10;
uint8_t clkDiv8 = 1 << CS11;
uint8_t clkDiv64 = 1 << CS11 | 1 << CS10;
uint8_t clkDiv256 = 1 << CS12;
uint8_t clkDiv1024 = 1 << CS12 | 1 << CS10;
uint8_t ovfCount;

// Timer 1 Interrupt Service Routine
ISR(TIMER1_OVF_vect) {
  //ovfCount++;
  //if (!ovfCount)
	PORTB ^= (1 << PB5);
}

int main() {
	DDRB |= (1 << PB5);
	//Serial.begin(9600);
	ovfCount = 0;
	cli();
	// Normal Mode
	TCCR1A = 0;
	// set up timer with (no) prescaler
	TCCR1B = clkDiv8;
	// initialize counter
	TCNT1 = 0;
	// Enable Timer1 interrupt ability
	TIMSK1 = 1 << TOIE1;
	// Enable global interrupt ability...
	sei();
	// stand down and let ISR respond to interrupts
	while (1);
}

