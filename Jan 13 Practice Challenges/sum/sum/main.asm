;
; sum.asm
;
; Created: 2018-01-13 5:59:42 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def n = r16
.def nPlusOne = r17
.def addReg = r18
.def result = r25
.def times = r22
start:
	ldi n, 3 // we will find the sum of the first n natural numbers
	ldi addReg, 1
	mov nPlusOne, n
	inc nPlusOne
	mov result, n
	mov times, nPlusOne
	rcall multiply
	lsr result // divide by two
	rjmp wait

multiply:
	add result, n
	dec times
	cpi times, 1
	brne multiply
	ret


wait:
	rjmp wait
