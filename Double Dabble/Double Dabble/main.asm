;
; Double Dabble.asm
;
; Created: 2017-12-31 5:25:49 PM
; Author : Ethan Peterson
;


; Replace with your application code
	.def original = r16
	.def ones = r17
	.def tens = r18
	.def hundreds = r19
	.def addReg = r20
start:
    ldi original, 243
	ldi addReg, 3
	//ldi lowerMask, 0b00001111
	//ldi upperMask, 0b11110000
	clr ones
	clr tens
	clr hundreds


decideStep:
	// check for completion by checking if original value is 0
	//cpi original, 0
	//breq wait
	// check if ones tens etc reg is greater or equal to 5 add 3 if not shift
checkOnes:
	cpi ones, 5
	brsh addThreeOnes
checkTens:
	cpi tens, 5
	brsh addThreeTens
checkHundreds:
	cpi hundreds, 5
	brsh addThreeHundreds
shifting:
	//lsl original
	swap ones
	lsl ones
	swap ones
	andi ones, 0b00001111
	rol tens
	sbrc tens, 4
	bset 0
	andi tens, 0b00001111
	rol hundreds

	lsl original
	brcs originalToOnes

completionCheck:
	//rcall shiftFromOnes
	//rcall shiftFromTens

	cpi original, 0
	breq wait

	rjmp decideStep
originalToOnes:
	 sbr ones, 1 // set bit 0 in ones
	 rjmp completionCheck

addThreeOnes:
	add ones, addReg
	rjmp checkTens

addThreeTens:
	add tens, addReg
	rjmp checkHundreds

addThreeHundreds:
	add hundreds, addReg
	rjmp shifting

wait:
	rjmp wait
