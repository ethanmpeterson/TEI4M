;
; SumTechnique2.asm
;
; Created: 2018-01-13 6:52:39 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def n = r16
.def addReg = r17
.def result = r25
start:
    ldi n, 3 // getting sum of first 3 natural numbers
	ldi addReg, 1
	clr result
	rcall loop
	rjmp wait


loop:
	add result, addReg
	inc addReg
	dec n
	cpi n, 0
	brne loop
	ret

wait:
	rjmp wait
