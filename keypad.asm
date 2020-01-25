ORG 0
MAIN:
	ACALL SCANNER
	SJMP MAIN

SCANNER:
	ACALL SENSOR1
	ACALL SENSOR2

	MOV R0,31H
	MOV R1,34H
	
	CLR CY
	CJNE R0,#2,JMP1
JMP1:	JC DETECTED1

	CLR CY
	CJNE R1,#2,JMP2
JMP2:	JC DETECTED2
	RET ; No detection if it comes here

DETECTED1:  ;;;;;;;;;;;;;; First sensor is detected something;;;;;;;;;;;;;;;;;;;;;;
BACKK1:	ACALL SENSOR2
	MOV R1,34H 

	CLR CY
	CJNE R1,#2,JMP3
JMP3:	JC CONT1 ; JUMPS IF THE SECOND SENSOR DETECTS SOMETHING AFTER THE FIRST ONE
	SJMP BACKK1

CONT1:	INC 36H ; Second sensor triggered after the first one it means +1
BACKK2:	ACALL SENSOR2
	MOV R1,34H
	CLR CY		
	CJNE R1,#2,JMP4	
JMP4:	JC BACKK2 ;Stays here until the object leaves the second sensor aswell
	RET ; Object passed first sensor then the second one so that we incremented the count - We are done


DETECTED2:  ;;;;;;;;;;;;;; Second sensor is detected something;;;;;;;;;;;;;;;;;;;;;;
BACKK3:	ACALL SENSOR1
	MOV R0,31H

	CLR CY
	CJNE R0,#2,JMP5
JMP5:	JC CONT2
	SJMP BACKK3

CONT2: 	DEC 36H ; FIRST SENSOR IS DETECTED THE OBJECT AFTER THE SECOND ONE - DECREMENT THE COUNT
BACKK4:	ACALL SENSOR1
	MOV R0,31H

	CLR CY
	CJNE R0,#2,JMP6
JMP6:	JC BACKK4
	RET ; The object leaves first sensor aswell so that this part is finished			

END

