;
; SHIFTREGTEST.asm
;
; Created: 2018-03-31 11:49:10 AM
; Author : Ethan Peterson
;


; Replace with your application code
/*.equ data = PB3
.equ clk = PB5
.equ latch = PB4
.MACRO shiftData
// set control pins to output
sbi DDRB, 5
sbi DDRB, 4
sbi DDRB, 3

cbi PORTB, latch 
	sbrc @0, 0 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 1 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 2 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 3 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 4 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 5 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 6 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	sbrc @0, 7 // test bit of data reg and turn on ds pin if not clear
	sbi PORTB, data // turn on DS
	sbi PORTB, clk // pulse clock
	cbi PORTB, data // turn off DS
	cbi PORTB, clk // turn off clk

	// pulse latch to assert changes
	sbi PORTB, latch
.ENDMACRO*/

.equ data = PB3
.equ latch = PB5
.equ clk = PB4

start:
	//rcall initPorts
	sbi DDRB, PB3
	sbi DDRB, PB4
	sbi DDRB, PB5
	ldi r16, 4
	rjmp loop

.MACRO shiftOut // MSBFIRST Shiftout
	cbi PORTB, latch
	// handle shifting data
	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 7 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 6 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 5 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 4 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 3 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 2 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 1 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	cbi PORTB, clk
	cbi PORTB, data
	sbrc r16, 0 // skip if bit in register passed to macro is cleared
	sbi PORTB, data
	sbi PORTB, clk

	sbi PORTB, latch
.ENDMACRO

loop:
	shiftOut r16
	rjmp wait

wait:
	rjmp wait


initPorts:
        ldi  r16, 1<<data | 1<<clk | 1<<latch
        out  DDRB,r16                                   ;declare three control lines for output
        ret


/*.cseg                                          ;load into Program Memory
.org   0x0000                          ;start of Interrupt Vector (Jump) Table
        rjmp    reset                           ;address  of start of code
startTable:                                    ;data tables can be loaded into Program Memory, too!
        .DB     1,2,3,15,31,63,127,255  ;byte values for bargraph animation
        ;.DB    "Hello, World!"         ;for some future exercise :)
endTable:
.org    0x100                                   ;abitrary address for start of code
 reset:
        ldi             r16, low(RAMEND)        ;ALL assembly code should start by
        out             spl,r16                 ; setting the Stack Pointer to
        ldi             r16, high(RAMEND)       ; the end of SRAM to support
        out             sph,r16                 ; function calls, etc.

        rcall   initPorts               ;set I/O Direction

        ldi             xl,low(startTable<<1)   ;position X and Y pointers to the
        ldi             xh,high(startTable<<1)  ; start and end addresses of
        ldi             yl,low(endTable<<1)     ; our data table, respectively
        ldi             yh,high(endTable<<1)    ;
        movw    z,x                                             ;start Z pointer off at the start address of the table.

more:
        lpm             r19,z+                          ;Load the first instance of the test data from Program Memory
        rcall   shiftOut                                ;shiftout the data
        rcall   myDelay                         ;admire...
        cp              zl,yl                           ;have we reached the end of the table?  (Z==Y?)
        brne    more                                            ; if not, repeat with next byte...
        movw    z,x                                             ; if so, reset Z pointer to start address of table and repeat  
		//rjmp more

initPorts:
        ldi  r16, 1<<data | 1<<clk | 1<<latch
        out  DDRB,r16                                   ;declare three control lines for output
        ret

shiftOut:
        cbi PORTB,latch         ;set latch low
        ldi r17,mask                    ;set the mask
nextBit:
        mov r18,r19                     ;reload test data for later masking
        cbi PORTB,clk                   ;set clock low
        cbi PORTB,data          ;assume data bit is clear
        and r18,r17                     ;execute the mask
        breq clkIt                      ;if not set, bypass next instruction
        sbi  PORTB,data         ;our assumption was wrong, the bit was high!
clkIt:                          ;
        sbi PORTB,clk                   ;clock the bit into the internal flip flops...
        clc                                     ;prepare to rotate the mask
        rol  r17                                ;shift the mask to the left one position
        brne nextBit                    ;are we done?
        sbi PORTB,latch         ;if so, latch the internal storage to the output pins
        ret                                     ;return from function (subroutine)


myDelay:
; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
; Delay 4 000 000 cycles
; 250ms at 16 MHz

   ldi  r20, 21
   ldi  r21, 75
   ldi  r22, 191
L1: dec  r22
   brne L1
   dec  r21
   brne L1
   dec  r20
   brne L1
   nop
ret

*/