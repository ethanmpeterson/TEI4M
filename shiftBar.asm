;
; in Class shift reg.asm
;
; Created: 2017-12-11 8:46:56 AM
; Author : Ethan Peterson
;


; Replace with your application code

.def data = r18
.def loopCount = r19
start:
	ldi r16, 1 << 5 | 1 << 4 | 1 << 3 // 5 = clk 4 = latch 3 = DS
	out 0x04, r16 // set control pins to output
	// 0x05 is port b address
	// add test data for shift label / function
	ldi r17, 0b11111110
	clr r19
	clr data
	rjmp loop

	

shiftData: // loads data register into 595 shift register
	sbrc data, 0 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 1 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 2 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 3 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 4 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 5 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 6 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	sbrc data, 7 // test bit of data reg and turn on ds pin if not clear
	sbi 0x05, 3 // turn on DS
	sbi 0x05, 5 // pulse clock
	cbi 0x05, 3 // turn off DS
	cbi 0x05, 5 // turn off clk

	// pulse latch to assert changes
	sbi 0x05, 4
	cbi 0x05, 4 
	ret

loop:
	mov data, r17
	com data
	rcall shiftData
	lsl r17
	rcall delay
	inc loopCount
	cpi data, 255
	breq reset
	rjmp loop

reset:
	ldi r17, 0b11111110
	rjmp loop

delay:
	ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret

wait:
	rjmp wait