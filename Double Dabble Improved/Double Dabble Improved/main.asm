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
	breq wait
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

wait:
	rjmp wait