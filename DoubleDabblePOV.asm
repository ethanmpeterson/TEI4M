;
; Double Dabble Improved.asm
;
; Created: 2018-01-05 8:12:24 PM
; Author : Ethan Peterson
;


; Replace with your application code
	.def original = r16
	.def onesTens = r17
	.def hundreds = r18
	.def working = r19
	.def addReg = r20
start:
    ldi original, 243
	ldi addReg, 3
	//ldi lowerMask, 0b00001111
	//ldi upperMask, 0b11110000
	clr onesTens
	clr hundreds

decideStep:

checkOnes:
	mov working, onesTens
	andi working, 0b00001111
	cpi working, 5
	brsh addThreeOnes
checkTens:
	mov working, onesTens
	andi working, 0b11110000
	cpi working, 80
	brsh addThreeTens
checkHundreds:
	cpi hundreds, 5
	brsh addThreeHundreds

shift:
	lsl original
	rol onesTens
	rol hundreds
	cpi original, 0
	breq display
	rjmp decideStep

addThreeOnes:
	add onesTens, addReg
	rjmp checkTens

addThreeTens:
	swap onesTens
	add onesTens, addReg
	swap onesTens
	rjmp checkHundreds

addThreeHundreds:
	add hundreds, addReg
	rjmp shift

display:
// TEMP
//TEMP
	ldi r16, 1 << PB2 | 1 << PB1
	out 0x04, r16 // set all transistor manipulation pins to output
	ldi r16, 1 << 1 | 1 << 2
	out 0x05, r16 // enable only hundreds display
	ldi r16, 0xFF
	out 0x07, r16 // set 4511 outputs
	mov r16, hundreds
	out 0x08, r16
	rcall delay
	// switch to tens display
	ldi r16, 1 << PB2 | 1 << PB0
	out 0x05, r16
	mov working, onesTens
	andi working, 0b11110000
	swap working
	out 0x08, working // display tens
	rcall delay
	// switch to ones Display
	ldi r16, 1 << PB0 | 1 << PB1
	out 0x05, r16
	mov working, onesTens
	andi working, 0b00001111
	out 0x08, working
	rcall delay // admire (delay needs to be made shorter for proper POV)

	rjmp display

delay:
ldi  r18, 6
    ldi  r19, 19
    ldi  r20, 174
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
ret
wait:
	rjmp wait
