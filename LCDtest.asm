ORG 0

	acall	CONFIGURE_LCD
	clr a
	mov dptr,#MYSTRING

DATA_LOOP:
	movc a,@a+dptr
	jz DATA_FINISHED
	acall SEND_DATA
	clr a
	inc dptr
	sjmp DATA_LOOP

DATA_FINISHED:
	sjmp $


CONFIGURE_LCD:	;THIS SUBROUTINE SENDS THE INITIALIZATION COMMANDS TO THE LCD
	mov a,#38H	;TWO LINES, 5X7 MATRIX
	acall SEND_COMMAND
	mov a,#0FH	;DISPLAY ON, CURSOR BLINKING
	acall SEND_COMMAND
	mov a,#06H	;INCREMENT CURSOR (SHIFT CURSOR TO RIGHT)
	acall SEND_COMMAND
	mov a,#01H	;CLEAR DISPLAY SCREEN
	acall SEND_COMMAND
	mov a,#80H	;FORCE CURSOR TO BEGINNING OF THE FIRST LINE
	acall SEND_COMMAND
	ret


;P1.0-P1.7 ARE CONNECTED TO LCD DATA PINS D0-D7
;P3.5 IS CONNECTED TO RS
;P3.6 IS CONNECTED TO R/W
;P3.7 IS CONNECTED TO E

SEND_COMMAND:	;THIS  SUBROUTINE IS FOR SENDING THE COMMANDS TO LCD
	mov p1,a		;THE COMMAND IS STORED IN A, SEND IT TO LCD
	clr p3.5		;RS=0 BEFORE SENDING COMMAND
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	;acall DELAY
	clr p3.7
	ret


SEND_DATA:	;THIS  SUBROUTINE IS FOR SENDING THE DATA TO BE DISPLAYED
	mov p1,a		;SEND THE DATA STORED IN A TO LCD
	setb p3.5	;RS=1 BEFORE SENDING DATA
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	;acall DELAY
	clr p3.7
	ret


DELAY:	;A SHORT DELAY SUBROUTINE
	push 0
	push 1
	mov r0,#50
DELAY_OUTER_LOOP:
	mov r1,#255
	djnz r1,$
	djnz r0,DELAY_OUTER_LOOP
	pop 1
	pop 0
	ret

MYSTRING: DB 'LCD IS OK!',0

END
