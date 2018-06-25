.cseg                                          ;load into Program Memory
.org   0x0000                          ;start of Interrupt Vector (Jump) Table
        rjmp    reset                           ;address  of start of code
startTable:    
        .DB    200, 10, 30
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
sum:
	lpm r19,z+                          ;Load the first instance of the test data from Program Memory
	//add r22, r19
    cp zl,yl                           ;have we reached the end of the table?  (Z==Y?)
    brne sum                                            ; if not, repeat with next byte...
    movw z,x
	rjmp wait                                          ; if so, reset Z pointer to start address of table and repeat  


wait:
	rjmp wait
