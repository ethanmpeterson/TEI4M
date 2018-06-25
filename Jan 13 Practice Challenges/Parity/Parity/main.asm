;
; Parity.asm
;
; Created: 2018-01-13 1:13:14 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def bitCount = r18
.def working = r22
.def times = r19
start:
    ldi r16, 67
	mov r17, r16
	clr bitCount
	//ldi times, 8
	rcall countBits
	mov working, bitCount
	lsr working
	brcs isOdd
	rjmp isEven
	

countBits:
	sbrc r17, 0
	inc bitCount
	
	sbrc r17, 1
	inc bitCount

	sbrc r17, 2
	inc bitCount

	sbrc r17, 3
	inc bitCount

	sbrc r17, 4
	inc bitCount

	sbrc r17, 5
	inc bitCount

	sbrc r17, 6
	inc bitCount

	sbrc r17, 7
	inc bitCount
	ret

isOdd:
	sbr r16, 1 << 7
	rjmp wait

isEven:
	rjmp wait

wait:
	rjmp wait


