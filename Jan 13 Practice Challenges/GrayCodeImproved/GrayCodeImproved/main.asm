;
; GrayCodeChallenge.asm
;
; Created: 2018-01-15 8:52:32 AM
; Author : Ethan Peterson
;


; Replace with your application code

.cseg                                          ;load into Program Memory
.org   0x0000                          ;start of Interrupt Vector (Jump) Table
        rjmp    reset                           ;address  of start of code
startTable:    
		// graycode conversion lookup table binary value matching index of the graycode
        .DB    0, 1, 3, 7, 6, 4, 5, 15, 14, 12, 13, 11, 10
        ;.DB    "Hello, World!"         ;for some future exercise :)
endTable:
.org    0x100                                   ;abitrary address for start of code
 reset:
	clr r22
    ldi             r16, low(RAMEND)        ;ALL assembly code should start by
    out             spl,r16                 ; setting the Stack Pointer to
    ldi             r16, high(RAMEND)       ; the end of SRAM to support
    out             sph,r16                 ; function calls, etc.

        //rcall   initPorts               ;set I/O Direction

   ldi             xl,low(startTable<<1)   ;position X and Y pointers to the
   ldi             xh,high(startTable<<1)  ; start and end addresses of
   ldi             yl,low(endTable<<1)     ; our data table, respectively
   ldi             yh,high(endTable<<1)    ;
   movw    z,x

	.def original = r16
	.def onesTens = r17
	.def hundreds = r22
	.def working = r24
	.def addReg = r20
	.def times = r25
	.def input = r21
start:
    ldi original, 243
	ldi addReg, 3
	ldi times, 8
	//ldi lowerMask, 0b00001111
	//ldi upperMask, 0b11110000
	clr onesTens
	clr hundreds
	//configure input pins
	ldi input, 0
	out 0x0A, input
	ldi r26, 2
	rjmp display

getInput:
	//ldi times, 8
	in input, 0x09 // load PIND into input register
	lsr input // fix off by one bit issue due to wiring config
	dec input
    adc zl, input
	lpm original, z+
	//mov original, input                                    
    movw z,x
	// grayCode now stored in original move onto display component and double dabble
	//rjmp decideStep
	ret
	
	


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
	dec times
	cpi times, 0
	breq retPoint
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
	rcall getInput // continuously grab input
// TEMP
//TEMP
	ldi r16, 1 << PB2 | 1 << PB1 | 1 << PB0
	out 0x04, r16 // set all transistor manipulation pins to output
	ldi r16, 1 << PB2 //1 << PB0 | 1 << PB1
	out 0x05, r16 // enable only hundreds display
	ldi r16, 0xFF
	out 0x07, r16 // set 4511 outputs
	mov r16, hundreds
	out 0x08, r16
	rcall delay
	// switch to tens display
	ldi r16, 1 << PB1 //1 << PB2 | 1 << PB0
	out 0x05, r16
	mov working, onesTens
	andi working, 0b11110000
	swap working
	out 0x08, working // display tens
	rcall delay
	// switch to ones Display
	ldi r16, 1 << PB0 //1 << PB1 | 1 << PB2
	out 0x05, r16
	mov working, onesTens
	andi working, 0b00001111
	out 0x08, working
	rcall delay // admire (delay needs to be made shorter for proper POV)
startPoint:
	//ldi times, 8
	mov r26, original
	rcall getInput
	cp r26, original
	brne decideStep
	//ldi original, 15
	//rjmp decideStep
retPoint:
	//rjmp res
	rjmp display

delay:
ldi  r18, 21
    ldi  r19, 199
L1: dec  r19
    brne L1
    dec  r18
    brne L1
	ret
wait:
	rjmp wait

