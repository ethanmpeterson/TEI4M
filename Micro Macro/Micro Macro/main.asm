;
; Micro Macro.asm
;
; Created: 2018-01-01 7:03:37 PM
; Author : Ethan Peterson
;


; Replace with your application code
.def a = r16
.def b = r17
.macro addition
        add a, b
.endmacro
.macro subtraction
        sub a, b
.endmacro
        ldi a, 4
        ldi b, 10
.macro exchange
		eor a, b
		eor b, a
		eor a , b
.endmacro
start:
	exchange

wait:
	rjmp wait