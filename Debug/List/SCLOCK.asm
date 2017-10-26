
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _hour=R4
	.DEF _minn=R3
	.DEF _sec=R6
	.DEF _day=R5
	.DEF _date=R8
	.DEF _month=R7
	.DEF _year=R10
	.DEF _No_date=R9
	.DEF _mode=R12
	.DEF _time=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x4,0x4,0x4,0x4
	.DB  0x0,0x4,0xA,0xA,0xA,0x0,0x0,0x0
	.DB  0x0,0xA,0xA,0x1F,0xA,0x1F,0xA,0xA
	.DB  0x4,0x1E,0x5,0xE,0x14,0xF,0x4,0x3
	.DB  0x13,0x8,0x4,0x2,0x19,0x18,0x6,0x9
	.DB  0x5,0x2,0x15,0x9,0x16,0x6,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x8,0x4,0x2,0x2
	.DB  0x2,0x4,0x8,0x2,0x4,0x8,0x8,0x8
	.DB  0x4,0x2,0x0,0xA,0x4,0x1F,0x4,0xA
	.DB  0x0,0x0,0x4,0x4,0x1F,0x4,0x4,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x4,0x2,0x0
	.DB  0x0,0x0,0x1F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x6,0x0,0x0,0x10,0x8
	.DB  0x4,0x2,0x1,0x0,0xE,0x11,0x19,0x15
	.DB  0x13,0x11,0xE,0x4,0x6,0x4,0x4,0x4
	.DB  0x4,0xE,0xE,0x11,0x10,0x8,0x4,0x2
	.DB  0x1F,0x1F,0x8,0x4,0x8,0x10,0x11,0xE
	.DB  0x8,0xC,0xA,0x9,0x1F,0x8,0x8,0x1F
	.DB  0x1,0xF,0x10,0x10,0x11,0xE,0xC,0x2
	.DB  0x1,0xF,0x11,0x11,0xE,0x1F,0x10,0x8
	.DB  0x4,0x2,0x2,0x2,0xE,0x11,0x11,0xE
	.DB  0x11,0x11,0xE,0xE,0x11,0x11,0x1E,0x10
	.DB  0x8,0x6,0x0,0x6,0x6,0x0,0x6,0x6
	.DB  0x0,0x0,0x6,0x6,0x0,0x6,0x4,0x2
	.DB  0x10,0x8,0x4,0x2,0x4,0x8,0x10,0x0
	.DB  0x0,0x1F,0x0,0x1F,0x0,0x0,0x1,0x2
	.DB  0x4,0x8,0x4,0x2,0x1,0xE,0x11,0x10
	.DB  0x8,0x4,0x0,0x4,0xE,0x11,0x10,0x16
	.DB  0x15,0x15,0xE,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0xF,0x11,0x11,0xF,0x11,0x11
	.DB  0xF,0xE,0x11,0x1,0x1,0x1,0x11,0xE
	.DB  0x7,0x9,0x11,0x11,0x11,0x9,0x7,0x1F
	.DB  0x1,0x1,0xF,0x1,0x1,0x1F,0x1F,0x1
	.DB  0x1,0x7,0x1,0x1,0x1,0xE,0x11,0x1
	.DB  0x1,0x19,0x11,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0x11,0xE,0x4,0x4,0x4,0x4
	.DB  0x4,0xE,0x1C,0x8,0x8,0x8,0x8,0x9
	.DB  0x6,0x11,0x9,0x5,0x3,0x5,0x9,0x11
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1F,0x11
	.DB  0x1B,0x15,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x13,0x15,0x19,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xE,0xF,0x11,0x11,0xF
	.DB  0x1,0x1,0x1,0xE,0x11,0x11,0x11,0x15
	.DB  0x9,0x16,0xF,0x11,0x11,0xF,0x5,0x9
	.DB  0x11,0x1E,0x1,0x1,0xE,0x10,0x10,0xF
	.DB  0x1F,0x4,0x4,0x4,0x4,0x4,0x4,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xA,0x4,0x11,0x11,0x11
	.DB  0x15,0x15,0x1B,0x11,0x11,0x11,0xA,0x4
	.DB  0xA,0x11,0x11,0x11,0x11,0xA,0x4,0x4
	.DB  0x4,0x4,0x1F,0x10,0x8,0x4,0x2,0x1
	.DB  0x1F,0x1C,0x4,0x4,0x4,0x4,0x4,0x1C
	.DB  0x0,0x1,0x2,0x4,0x8,0x10,0x0,0x7
	.DB  0x4,0x4,0x4,0x4,0x4,0x7,0x4,0xA
	.DB  0x11,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1F,0x2,0x4,0x8,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE,0x10,0x1E
	.DB  0x11,0x1E,0x1,0x1,0xD,0x13,0x11,0x11
	.DB  0xF,0x0,0x0,0xE,0x1,0x1,0x11,0xE
	.DB  0x10,0x10,0x16,0x19,0x11,0x11,0x1E,0x0
	.DB  0x0,0xE,0x11,0x1F,0x1,0xE,0xC,0x12
	.DB  0x2,0x7,0x2,0x2,0x2,0x0,0x0,0x1E
	.DB  0x11,0x1E,0x10,0xC,0x1,0x1,0xD,0x13
	.DB  0x11,0x11,0x11,0x4,0x0,0x6,0x4,0x4
	.DB  0x4,0xE,0x8,0x0,0xC,0x8,0x8,0x9
	.DB  0x6,0x2,0x2,0x12,0xA,0x6,0xA,0x12
	.DB  0x6,0x4,0x4,0x4,0x4,0x4,0xE,0x0
	.DB  0x0,0xB,0x15,0x15,0x11,0x11,0x0,0x0
	.DB  0xD,0x13,0x11,0x11,0x11,0x0,0x0,0xE
	.DB  0x11,0x11,0x11,0xE,0x0,0x0,0xF,0x11
	.DB  0xF,0x1,0x1,0x0,0x0,0x16,0x19,0x1E
	.DB  0x10,0x10,0x0,0x0,0xD,0x13,0x1,0x1
	.DB  0x1,0x0,0x0,0xE,0x1,0xE,0x10,0xF
	.DB  0x2,0x2,0x7,0x2,0x2,0x12,0xC,0x0
	.DB  0x0,0x11,0x11,0x11,0x19,0x16,0x0,0x0
	.DB  0x11,0x11,0x11,0xA,0x4,0x0,0x0,0x11
	.DB  0x11,0x15,0x15,0xA,0x0,0x0,0x11,0xA
	.DB  0x4,0xA,0x11,0x0,0x0,0x11,0x11,0x1E
	.DB  0x10,0xE,0x0,0x0,0x1F,0x8,0x4,0x2
	.DB  0x1F,0x8,0x4,0x4,0x2,0x4,0x4,0x8
	.DB  0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x2
	.DB  0x4,0x4,0x8,0x4,0x4,0x2,0x2,0x15
	.DB  0x8,0x0,0x0,0x0,0x0,0x1F,0x11,0x11
	.DB  0x11,0x11,0x11,0x1F
_fontNumber:
	.DB  0x8,0xD,0x2E,0xD,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x40,0x40,0x20,0x20,0x10,0x10
	.DB  0x8,0x8,0x4,0x4,0x2,0x2,0x0,0x7F
	.DB  0x7F,0x63,0x63,0x63,0x63,0x63,0x63,0x63
	.DB  0x63,0x7F,0x7F,0x0,0x1C,0x1C,0x18,0x18
	.DB  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0x0,0x7F,0x7F,0x60,0x60,0x60,0x7F,0x7F
	.DB  0x3,0x3,0x3,0x7F,0x7F,0x0,0x7F,0x7F
	.DB  0x60,0x60,0x60,0x7F,0x7F,0x60,0x60,0x60
	.DB  0x7F,0x7F,0x0,0x63,0x63,0x63,0x63,0x63
	.DB  0x7F,0x7F,0x60,0x60,0x60,0x60,0x60,0x0
	.DB  0x7F,0x7F,0x3,0x3,0x3,0x7F,0x7F,0x60
	.DB  0x60,0x60,0x7F,0x7F,0x0,0x7F,0x7F,0x3
	.DB  0x3,0x3,0x7F,0x7F,0x63,0x63,0x63,0x7F
	.DB  0x7F,0x0,0x7F,0x7F,0x60,0x60,0x60,0x60
	.DB  0x60,0x60,0x60,0x60,0x60,0x60,0x0,0x7F
	.DB  0x7F,0x63,0x63,0x63,0x7F,0x7F,0x63,0x63
	.DB  0x63,0x7F,0x7F,0x0,0x7F,0x7F,0x63,0x63
	.DB  0x63,0x7F,0x7F,0x60,0x60,0x60,0x7F,0x7F
	.DB  0x0,0x0,0x0,0x0,0x18,0x18,0x0,0x0
	.DB  0x18,0x18,0x0,0x0,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G100:
	.DB  0x3,0x3,0x2,0x0,0x2,0x0
_st7920_base_y_G100:
	.DB  0x80,0x90,0x88,0x98

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x25,0x32,0x2E,0x30,0x66,0x0,0x6F,0x0
	.DB  0x43,0x0,0x25,0x0,0x3A,0x0,0x2E,0x2E
	.DB  0x0,0x2F,0x0,0x20,0x20,0x0,0x43,0x4E
	.DB  0x2D,0x0,0x54,0x32,0x2D,0x0,0x54,0x33
	.DB  0x2D,0x0,0x54,0x34,0x2D,0x0,0x54,0x35
	.DB  0x2D,0x0,0x54,0x36,0x2D,0x0,0x54,0x37
	.DB  0x2D,0x0
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20E0003:
	.DB  0xD,0x0,0xD,0x0,0x0,0x0,0xC0,0x1
	.DB  0xF0,0x2,0x78,0x0,0x78,0x0,0x3C,0x0
	.DB  0x3C,0x0,0x78,0x0,0x78,0x0,0xF0,0x2
	.DB  0xC0,0x1
_0x2100003:
	.DB  0xD,0x0,0xD,0x0,0x40,0x0,0x42,0x8
	.DB  0x4,0x4,0xE0,0x0,0xF0,0x1,0xF8,0x3
	.DB  0xFB,0x1B,0xF8,0x3,0xF0,0x1,0xE0,0x0
	.DB  0x4,0x4,0x42,0x8,0x40
_0x2120003:
	.DB  0x8,0x0,0x8,0x0,0xD,0x1E,0x3F,0xFF
	.DB  0x7E,0x1C,0xD8,0x48
_0x2140003:
	.DB  0x8,0x0,0x8,0x0,0x8D,0x52,0x21,0xD1
	.DB  0x6A,0x14,0xDA,0x49
_0x2200060:
	.DB  0x1
_0x2200000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  _0x5
	.DW  _0x0*2+6

	.DW  0x02
	.DW  _0x5+2
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x5+4
	.DW  _0x0*2+10

	.DW  0x02
	.DW  _0x6
	.DW  _0x0*2+12

	.DW  0x03
	.DW  _0x6+2
	.DW  _0x0*2+14

	.DW  0x03
	.DW  _0x6+5
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x6+8
	.DW  _0x0*2+15

	.DW  0x02
	.DW  _0x10
	.DW  _0x0*2+17

	.DW  0x02
	.DW  _0x10+2
	.DW  _0x0*2+17

	.DW  0x03
	.DW  _0x10+4
	.DW  _0x0*2+19

	.DW  0x03
	.DW  _0x10+7
	.DW  _0x0*2+19

	.DW  0x03
	.DW  _0x10+10
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0x42
	.DW  _0x0*2+22

	.DW  0x04
	.DW  _0x42+4
	.DW  _0x0*2+26

	.DW  0x04
	.DW  _0x42+8
	.DW  _0x0*2+30

	.DW  0x04
	.DW  _0x42+12
	.DW  _0x0*2+34

	.DW  0x04
	.DW  _0x42+16
	.DW  _0x0*2+38

	.DW  0x04
	.DW  _0x42+20
	.DW  _0x0*2+42

	.DW  0x04
	.DW  _0x42+24
	.DW  _0x0*2+46

	.DW  0x02
	.DW  _0x4A
	.DW  _0x0*2+12

	.DW  0x03
	.DW  _0x4A+2
	.DW  _0x0*2+19

	.DW  0x03
	.DW  _0x4A+5
	.DW  _0x0*2+19

	.DW  0x03
	.DW  _0x4A+8
	.DW  _0x0*2+19

	.DW  0x1A
	.DW  _moon
	.DW  _0x20E0003*2

	.DW  0x1D
	.DW  _sun
	.DW  _0x2100003*2

	.DW  0x0C
	.DW  _alarm_on
	.DW  _0x2120003*2

	.DW  0x0C
	.DW  _alarm_off
	.DW  _0x2140003*2

	.DW  0x01
	.DW  __seed_G110
	.DW  _0x2200060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Project :  Clock Dispaly Glcd
;Version :  00
;Date    : 10/19/2017
;Author  : Hoang Tam
;Company :
;Comments:
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <i2c.h>
;#include <delay.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <ds1307.h>
;#include <DHT.h>
;#include <fontnumber8x13.h>
;#include <stdio.h>
;#include "LCD/moon.h"
;#include "LCD/sun.h"
;#include "LCD/alarm_on.h"
;#include "LCD/alarm_off.h"
;
;#define UP      PIND.1
;#define DOWN    PIND.0
;
;bit blink,flash_sec;
;char hour,minn,sec,day,date,month,year,No_date;
;unsigned char mode,time;
;eeprom unsigned char min_set,hour_set,alarm;
;
;void setDisplay();
;
;void timer0_init()
; 0000 002A {

	.CSEG
_timer0_init:
; .FSTART _timer0_init
; 0000 002B TCCR0=(0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 002C TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 002D TIMSK=1<<TOIE0;
	LDI  R30,LOW(1)
	RJMP _0x222000C
; 0000 002E }
; .FEND
;void timer0_stop()
; 0000 0030 {
_timer0_stop:
; .FSTART _timer0_stop
; 0000 0031   TCCR0=0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0032   TIMSK=0<<TOIE0;
_0x222000C:
	OUT  0x39,R30
; 0000 0033 }
	RET
; .FEND
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0036 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x0
; 0000 0037      //MODE
; 0000 0038     mode++;
	INC  R12
; 0000 0039     if(mode>8) mode=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRSH _0x3
	CLR  R12
; 0000 003A 
; 0000 003B }
_0x3:
	RJMP _0xE3
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 003F {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0040     //OK
; 0000 0041     rtc_set_time(hour,minn,sec);
	ST   -Y,R4
	ST   -Y,R3
	MOV  R26,R6
	RCALL _rtc_set_time
; 0000 0042     rtc_set_date(day,date,month,year);
	ST   -Y,R5
	ST   -Y,R8
	ST   -Y,R7
	MOV  R26,R10
	RCALL _rtc_set_date
; 0000 0043     setDisplay();
	RCALL _setDisplay
; 0000 0044     timer0_stop();
	RCALL _timer0_stop
; 0000 0045     mode=0;
	CLR  R12
; 0000 0046 
; 0000 0047 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004B {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x0
; 0000 004C     //0.256ms
; 0000 004D     time++;
	INC  R11
; 0000 004E     if(time>80)
	LDI  R30,LOW(80)
	CP   R30,R11
	BRSH _0x4
; 0000 004F     {
; 0000 0050       blink=~blink;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 0051       time=0;
	CLR  R11
; 0000 0052     }
; 0000 0053 
; 0000 0054 }
_0x4:
	RJMP _0xE3
; .FEND
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0057 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x0
; 0000 0058     flash_sec=~flash_sec;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 0059 }
_0xE3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;void dayDisplay(unsigned char x, unsigned char y);
;
;void tempDisplay(unsigned char T_x, unsigned char T_y, unsigned char H_x, unsigned char H_y)
; 0000 005D {
; 0000 005E   float temp,humi;
; 0000 005F   char lcdBuff[5];
; 0000 0060   #asm("cli");
;	T_x -> Y+16
;	T_y -> Y+15
;	H_x -> Y+14
;	H_y -> Y+13
;	temp -> Y+9
;	humi -> Y+5
;	lcdBuff -> Y+0
; 0000 0061   temp=DHT_GetTemHumi(DHT_ND);
; 0000 0062   humi=DHT_GetTemHumi(DHT_DA);
; 0000 0063   #asm("sei");
; 0000 0064   sprintf(lcdBuff,"%2.0f",temp);
; 0000 0065   glcd_setfont(font5x7);
; 0000 0066   glcd_outtextxy(T_x,T_y+3,lcdBuff);
; 0000 0067   glcd_outtextxy(T_x+12,T_y,"o");
; 0000 0068   glcd_outtextxy(T_x+18,T_y+3,"C");
; 0000 0069 
; 0000 006A   sprintf(lcdBuff,"%2.0f",humi);
; 0000 006B   glcd_setfont(font5x7);
; 0000 006C   glcd_outtextxy(H_x,H_y+3,lcdBuff);
; 0000 006D   glcd_outtextxy(H_x+12,H_y+3,"%");
; 0000 006E }

	.DSEG
_0x5:
	.BYTE 0x6
;void getTime()
; 0000 0070 {

	.CSEG
_getTime:
; .FSTART _getTime
; 0000 0071     rtc_get_time(&hour,&minn,&sec);
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	RCALL _rtc_get_time
; 0000 0072     rtc_get_date(&day,&date,&month,&year);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL _rtc_get_date
; 0000 0073 }
	RET
; .FEND
;void timeDisplay(unsigned char x, unsigned char y)
; 0000 0075 {
_timeDisplay:
; .FSTART _timeDisplay
; 0000 0076   glcd_setfont(fontNumber);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	RCALL SUBOPT_0x3
; 0000 0077   glcd_putcharxy(x,y,48+(hour/10));
	MOV  R26,R4
	RCALL SUBOPT_0x4
	RCALL _glcd_putcharxy
; 0000 0078   glcd_putchar(48+(hour%10));
	MOV  R26,R4
	RCALL SUBOPT_0x5
; 0000 0079   glcd_outtext(":");
	__POINTW2MN _0x6,0
	RCALL _glcd_outtext
; 0000 007A   glcd_putchar(48+(minn/10));
	MOV  R26,R3
	RCALL SUBOPT_0x4
	RCALL _glcd_putchar
; 0000 007B   glcd_putchar(48+(minn%10));
	MOV  R26,R3
	RCALL SUBOPT_0x5
; 0000 007C   if(mode==2 && blink%2==0)
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x8
	RCALL SUBOPT_0x6
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 007D   {
; 0000 007E     glcd_setfont(fontNumber);
	RCALL SUBOPT_0x3
; 0000 007F     glcd_outtextxy(x,y,"..");
	__POINTW2MN _0x6,2
	RCALL _glcd_outtextxy
; 0000 0080   }
; 0000 0081   if(mode==1 && blink%2==0)
_0x7:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xB
	RCALL SUBOPT_0x6
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0082   {
; 0000 0083     glcd_setfont(fontNumber);
	RCALL SUBOPT_0x7
; 0000 0084     glcd_outtextxy(x+27,y,"..");
	SUBI R30,-LOW(27)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x6,5
	RCALL _glcd_outtextxy
; 0000 0085   }
; 0000 0086   if(mode==0 && flash_sec%2==0)
_0xA:
	TST  R12
	BRNE _0xE
	LDI  R30,0
	SBRC R2,1
	LDI  R30,1
	RCALL SUBOPT_0x9
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xA
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 0087   {
; 0000 0088     glcd_setfont(fontNumber);
	RCALL SUBOPT_0x7
; 0000 0089     glcd_outtextxy(x+18,y,".");
	SUBI R30,-LOW(18)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x6,8
	RCALL _glcd_outtextxy
; 0000 008A   }
; 0000 008B }
_0xD:
	RJMP _0x2220003
; .FEND

	.DSEG
_0x6:
	.BYTE 0xA
;void dateDisplay(unsigned char x, unsigned char y)
; 0000 008D {

	.CSEG
_dateDisplay:
; .FSTART _dateDisplay
; 0000 008E   glcd_setfont(font5x7);
	RCALL SUBOPT_0xB
;	x -> Y+1
;	y -> Y+0
; 0000 008F   dayDisplay(x,y);
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _dayDisplay
; 0000 0090   glcd_putcharxy(x+18,y,48+(date/10));
	LDD  R30,Y+1
	SUBI R30,-LOW(18)
	RCALL SUBOPT_0x8
	MOV  R26,R8
	RCALL SUBOPT_0x4
	RCALL _glcd_putcharxy
; 0000 0091   glcd_putchar(48+(date%10));
	MOV  R26,R8
	RCALL SUBOPT_0x5
; 0000 0092   glcd_outtext("/");
	__POINTW2MN _0x10,0
	RCALL _glcd_outtext
; 0000 0093   glcd_putchar(48+(month/10));
	MOV  R26,R7
	RCALL SUBOPT_0x4
	RCALL _glcd_putchar
; 0000 0094   glcd_putchar(48+(month%10));
	MOV  R26,R7
	RCALL SUBOPT_0x5
; 0000 0095   glcd_outtext("/");
	__POINTW2MN _0x10,2
	RCALL _glcd_outtext
; 0000 0096   glcd_putchar(48+(year/10));
	MOV  R26,R10
	RCALL SUBOPT_0x4
	RCALL _glcd_putchar
; 0000 0097   glcd_putchar(48+(year%10));
	MOV  R26,R10
	RCALL SUBOPT_0x5
; 0000 0098 
; 0000 0099   if(blink%2==0 && mode==3)
	RCALL SUBOPT_0x6
	BRNE _0x12
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ _0x13
_0x12:
	RJMP _0x11
_0x13:
; 0000 009A   {
; 0000 009B     glcd_outtextxy(x+18,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(18)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x10,4
	RCALL _glcd_outtextxy
; 0000 009C   }
; 0000 009D   if(blink%2==0 && mode==4)
_0x11:
	RCALL SUBOPT_0x6
	BRNE _0x15
	LDI  R30,LOW(4)
	CP   R30,R12
	BREQ _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 009E   {
; 0000 009F     glcd_outtextxy(x+36,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(36)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x10,7
	RCALL _glcd_outtextxy
; 0000 00A0   }
; 0000 00A1   if(blink%2==0 && mode==5)
_0x14:
	RCALL SUBOPT_0x6
	BRNE _0x18
	LDI  R30,LOW(5)
	CP   R30,R12
	BREQ _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 00A2   {
; 0000 00A3     glcd_outtextxy(x+54,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(54)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x10,10
	RCALL _glcd_outtextxy
; 0000 00A4   }
; 0000 00A5 }
_0x17:
	RJMP _0x2220003
; .FEND

	.DSEG
_0x10:
	.BYTE 0xD
;
;void dayDisplay(unsigned char x, unsigned char y)
; 0000 00A8 { int C;

	.CSEG
_dayDisplay:
; .FSTART _dayDisplay
; 0000 00A9 switch (month)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	x -> Y+3
;	y -> Y+2
;	C -> R16,R17
	MOV  R30,R7
	LDI  R31,0
; 0000 00AA              {
; 0000 00AB              case 1: C=date;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
	MOV  R16,R8
	CLR  R17
; 0000 00AC                      break;
	RJMP _0x1C
; 0000 00AD              case 2: C=31+date;
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E
	RCALL SUBOPT_0xC
	ADIW R30,31
	MOVW R16,R30
; 0000 00AE                      break;
	RJMP _0x1C
; 0000 00AF              case 3: if(year%4==0) C=60+date;
_0x1E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1F
	RCALL SUBOPT_0xD
	BRNE _0x20
	RCALL SUBOPT_0xC
	ADIW R30,60
	RJMP _0xD0
; 0000 00B0                      else C=59+date;
_0x20:
	RCALL SUBOPT_0xC
	ADIW R30,59
_0xD0:
	MOVW R16,R30
; 0000 00B1                      break;
	RJMP _0x1C
; 0000 00B2              case 4: if((year%4)==0) C=91+date;
_0x1F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22
	RCALL SUBOPT_0xD
	BRNE _0x23
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-91)
	SBCI R31,HIGH(-91)
	RJMP _0xD1
; 0000 00B3                      else C=90+date;
_0x23:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-90)
	SBCI R31,HIGH(-90)
_0xD1:
	MOVW R16,R30
; 0000 00B4                      break;
	RJMP _0x1C
; 0000 00B5              case 5: if((year%4)==0) C=121+date;
_0x22:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x25
	RCALL SUBOPT_0xD
	BRNE _0x26
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-121)
	SBCI R31,HIGH(-121)
	RJMP _0xD2
; 0000 00B6                      else C=120+date;
_0x26:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-120)
	SBCI R31,HIGH(-120)
_0xD2:
	MOVW R16,R30
; 0000 00B7                      break;
	RJMP _0x1C
; 0000 00B8              case 6: if((year%4)==0) C=152+date;
_0x25:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x28
	RCALL SUBOPT_0xD
	BRNE _0x29
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-152)
	SBCI R31,HIGH(-152)
	RJMP _0xD3
; 0000 00B9                      else C=151+date;
_0x29:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-151)
	SBCI R31,HIGH(-151)
_0xD3:
	MOVW R16,R30
; 0000 00BA                      break;
	RJMP _0x1C
; 0000 00BB              case 7: if((year%4)==0) C=182+date;
_0x28:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2B
	RCALL SUBOPT_0xD
	BRNE _0x2C
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-182)
	SBCI R31,HIGH(-182)
	RJMP _0xD4
; 0000 00BC                      else C=181+date;
_0x2C:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-181)
	SBCI R31,HIGH(-181)
_0xD4:
	MOVW R16,R30
; 0000 00BD                      break;
	RJMP _0x1C
; 0000 00BE              case 8: if((year%4)==0) C=213+date;
_0x2B:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2E
	RCALL SUBOPT_0xD
	BRNE _0x2F
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-213)
	SBCI R31,HIGH(-213)
	RJMP _0xD5
; 0000 00BF                      else C=212+date;
_0x2F:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-212)
	SBCI R31,HIGH(-212)
_0xD5:
	MOVW R16,R30
; 0000 00C0                      break;
	RJMP _0x1C
; 0000 00C1              case 9: if((year%4)==0) C=244+date;
_0x2E:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x31
	RCALL SUBOPT_0xD
	BRNE _0x32
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-244)
	SBCI R31,HIGH(-244)
	RJMP _0xD6
; 0000 00C2                      else C=243+date;
_0x32:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-243)
	SBCI R31,HIGH(-243)
_0xD6:
	MOVW R16,R30
; 0000 00C3                      break;
	RJMP _0x1C
; 0000 00C4              case 10:if((year%4)==0) C=274+date;
_0x31:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x34
	RCALL SUBOPT_0xD
	BRNE _0x35
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-274)
	SBCI R31,HIGH(-274)
	RJMP _0xD7
; 0000 00C5                      else C=273+date;
_0x35:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-273)
	SBCI R31,HIGH(-273)
_0xD7:
	MOVW R16,R30
; 0000 00C6                      break;
	RJMP _0x1C
; 0000 00C7              case 11:if((year%4)==0) C=305+date;
_0x34:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x37
	RCALL SUBOPT_0xD
	BRNE _0x38
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-305)
	SBCI R31,HIGH(-305)
	RJMP _0xD8
; 0000 00C8                      else C=304+date;
_0x38:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-304)
	SBCI R31,HIGH(-304)
_0xD8:
	MOVW R16,R30
; 0000 00C9                      break;
	RJMP _0x1C
; 0000 00CA              case 12:if((year%4)==0) C=335+date;
_0x37:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x3D
	RCALL SUBOPT_0xD
	BRNE _0x3B
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-335)
	SBCI R31,HIGH(-335)
	RJMP _0xD9
; 0000 00CB                      else C=334+date;
_0x3B:
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-334)
	SBCI R31,HIGH(-334)
_0xD9:
	MOVW R16,R30
; 0000 00CC                      break;
; 0000 00CD              default:
_0x3D:
; 0000 00CE              }
_0x1C:
; 0000 00CF              //glcd_setfont(font5x7);
; 0000 00D0              //cong thuc tinh thu:
; 0000 00D1             // n=((years-1)+((years-1)/4)-((years-1)/100)+((years-1)/400)+C)%7
; 0000 00D2             // n: thu trong tuan (0=CN;1=T2.....6=t7)
; 0000 00D3             // C: ngay thu bao nhieu tu dau nam den hien tai
; 0000 00D4  switch(((2000+year-1)+((2000+year-1)/4)-((2000+year-1)/100)+((2000+year-1)/400)+C)%7)
	RCALL SUBOPT_0xE
	MOVW R22,R30
	MOVW R26,R30
	RCALL SUBOPT_0x1
	RCALL __DIVW21
	__ADDWRR 22,23,30,31
	RCALL SUBOPT_0xE
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	__SUBWRR 22,23,30,31
	RCALL SUBOPT_0xE
	MOVW R26,R30
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL __DIVW21
	ADD  R30,R22
	ADC  R31,R23
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0xA
; 0000 00D5             {
; 0000 00D6                 case 0: glcd_outtextxy(x,y,"CN-"); break;
	BRNE _0x41
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,0
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00D7                 case 1: glcd_outtextxy(x,y,"T2-"); break;
_0x41:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x43
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,4
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00D8                 case 2: glcd_outtextxy(x,y,"T3-"); break;
_0x43:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x44
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,8
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00D9                 case 3: glcd_outtextxy(x,y,"T4-"); break;
_0x44:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x45
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,12
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00DA                 case 4: glcd_outtextxy(x,y,"T5-"); break;
_0x45:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x46
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,16
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00DB                 case 5: glcd_outtextxy(x,y,"T6-"); break;
_0x46:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x47
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,20
	RCALL _glcd_outtextxy
	RJMP _0x40
; 0000 00DC                 case 6: glcd_outtextxy(x,y,"T7-"); break;
_0x47:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x49
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	__POINTW2MN _0x42,24
	RCALL _glcd_outtextxy
; 0000 00DD                 default:
_0x49:
; 0000 00DE             }
_0x40:
; 0000 00DF }
	RCALL __LOADLOCR2
	RJMP _0x2220001
; .FEND

	.DSEG
_0x42:
	.BYTE 0x1C
;
;void alarmDisplay(unsigned char x, unsigned char y)
; 0000 00E2 {

	.CSEG
_alarmDisplay:
; .FSTART _alarmDisplay
; 0000 00E3    glcd_setfont(font5x7);
	RCALL SUBOPT_0xB
;	x -> Y+1
;	y -> Y+0
; 0000 00E4    glcd_putcharxy(x+10,y+1,48+hour_set/10);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL __DIVW21
	RCALL SUBOPT_0x13
	RCALL _glcd_putcharxy
; 0000 00E5    glcd_putchar(48+hour_set%10);
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL __MODW21
	RCALL SUBOPT_0x13
	RCALL _glcd_putchar
; 0000 00E6    glcd_outtext(":");
	__POINTW2MN _0x4A,0
	RCALL _glcd_outtext
; 0000 00E7    glcd_putchar(48+min_set/10);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	RCALL __DIVW21
	RCALL SUBOPT_0x13
	RCALL _glcd_putchar
; 0000 00E8    glcd_putchar(48+min_set%10);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	RCALL __MODW21
	RCALL SUBOPT_0x13
	RCALL _glcd_putchar
; 0000 00E9 
; 0000 00EA    if(mode==6 && blink==1)
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x4C
	SBRC R2,0
	RJMP _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 00EB    {
; 0000 00EC      glcd_setfont(font5x7);
	RCALL SUBOPT_0x15
; 0000 00ED      glcd_outtextxy(x+28,y+1,"  ");
	SUBI R30,-LOW(28)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	ST   -Y,R30
	__POINTW2MN _0x4A,2
	RCALL _glcd_outtextxy
; 0000 00EE    }
; 0000 00EF    if(mode==7 && blink==1)
_0x4B:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x4F
	SBRC R2,0
	RJMP _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 00F0    {
; 0000 00F1      glcd_setfont(font5x7);
	RCALL SUBOPT_0x15
; 0000 00F2      glcd_outtextxy(x+10,y+1,"  ");
	RCALL SUBOPT_0x10
	__POINTW2MN _0x4A,5
	RCALL _glcd_outtextxy
; 0000 00F3    }
; 0000 00F4    if(mode==8 && blink==1)
_0x4E:
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x52
	SBRC R2,0
	RJMP _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 00F5    {
; 0000 00F6      glcd_setfont(font5x7);
	RCALL SUBOPT_0x15
; 0000 00F7      glcd_outtextxy(x-3,y,"  ");
	SUBI R30,LOW(3)
	RCALL SUBOPT_0x8
	__POINTW2MN _0x4A,8
	RCALL _glcd_outtextxy
; 0000 00F8    }
; 0000 00F9 }
_0x51:
	RJMP _0x2220003
; .FEND

	.DSEG
_0x4A:
	.BYTE 0xB
;void so_ngay(void)
; 0000 00FB {

	.CSEG
_so_ngay:
; .FSTART _so_ngay
; 0000 00FC   if(month==2)     // thang 2 nam nhuan co 29 ngay, nam thuong co 28 ngay
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x54
; 0000 00FD   {
; 0000 00FE    if(year%4==0)   //&&year%100!=0||year%400==0)
	RCALL SUBOPT_0xD
	BRNE _0x55
; 0000 00FF    {
; 0000 0100     No_date=29;
	LDI  R30,LOW(29)
	RJMP _0xDA
; 0000 0101    }
; 0000 0102    else
_0x55:
; 0000 0103    {
; 0000 0104     No_date=28;
	LDI  R30,LOW(28)
_0xDA:
	MOV  R9,R30
; 0000 0105    };
; 0000 0106   }
; 0000 0107 
; 0000 0108   else
	RJMP _0x57
_0x54:
; 0000 0109   {
; 0000 010A    if(month==4||month==6||month==9||month==11)
	LDI  R30,LOW(4)
	CP   R30,R7
	BREQ _0x59
	LDI  R30,LOW(6)
	CP   R30,R7
	BREQ _0x59
	LDI  R30,LOW(9)
	CP   R30,R7
	BREQ _0x59
	LDI  R30,LOW(11)
	CP   R30,R7
	BRNE _0x58
_0x59:
; 0000 010B    {
; 0000 010C     No_date=30;
	LDI  R30,LOW(30)
	RJMP _0xDB
; 0000 010D    }
; 0000 010E 
; 0000 010F    else
_0x58:
; 0000 0110    {
; 0000 0111     if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(3)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(5)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(7)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(8)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(10)
	CP   R30,R7
	BREQ _0x5D
	LDI  R30,LOW(12)
	CP   R30,R7
	BRNE _0x5C
_0x5D:
; 0000 0112     {
; 0000 0113      No_date=31;
	LDI  R30,LOW(31)
_0xDB:
	MOV  R9,R30
; 0000 0114     }
; 0000 0115    };
_0x5C:
; 0000 0116   };
_0x57:
; 0000 0117 
; 0000 0118 }
	RET
; .FEND
;void setting(void)
; 0000 011A {
_setting:
; .FSTART _setting
; 0000 011B  so_ngay();
	RCALL _so_ngay
; 0000 011C //================================================
; 0000 011D  if(mode==1)   //chinh phut
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x5F
; 0000 011E  {
; 0000 011F    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x60
; 0000 0120         {
; 0000 0121         if(minn==59)
	LDI  R30,LOW(59)
	CP   R30,R3
	BRNE _0x61
; 0000 0122             {
; 0000 0123             minn=0;
	CLR  R3
; 0000 0124             }
; 0000 0125         else
	RJMP _0x62
_0x61:
; 0000 0126             {
; 0000 0127             minn++;
	INC  R3
; 0000 0128             };
_0x62:
; 0000 0129         while(!UP); // doi nha phim
_0x63:
	SBIS 0x10,1
	RJMP _0x63
; 0000 012A         }
; 0000 012B    //==============
; 0000 012C    if(DOWN==0)        // phim "DOWN" nhan
_0x60:
	SBIC 0x10,0
	RJMP _0x66
; 0000 012D         {
; 0000 012E         if(minn==0)
	TST  R3
	BRNE _0x67
; 0000 012F             {
; 0000 0130             minn=59;
	LDI  R30,LOW(59)
	MOV  R3,R30
; 0000 0131             }
; 0000 0132         else
	RJMP _0x68
_0x67:
; 0000 0133             {
; 0000 0134             minn--;
	DEC  R3
; 0000 0135             };
_0x68:
; 0000 0136         while(!DOWN);
_0x69:
	SBIS 0x10,0
	RJMP _0x69
; 0000 0137         }
; 0000 0138  }
_0x66:
; 0000 0139  //===============================
; 0000 013A   if(mode==2)   //chinh gio
_0x5F:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x6C
; 0000 013B     {
; 0000 013C    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x6D
; 0000 013D         {
; 0000 013E         if(hour==23)
	LDI  R30,LOW(23)
	CP   R30,R4
	BRNE _0x6E
; 0000 013F             {
; 0000 0140             hour=0;
	CLR  R4
; 0000 0141             }
; 0000 0142         else
	RJMP _0x6F
_0x6E:
; 0000 0143             {
; 0000 0144             hour++;
	INC  R4
; 0000 0145             };
_0x6F:
; 0000 0146         while(!UP); // doi nha phim
_0x70:
	SBIS 0x10,1
	RJMP _0x70
; 0000 0147         }
; 0000 0148    //==============
; 0000 0149    if(DOWN==0)        // phim "DOWN" nhan
_0x6D:
	SBIC 0x10,0
	RJMP _0x73
; 0000 014A         {
; 0000 014B         if(hour==0)
	TST  R4
	BRNE _0x74
; 0000 014C             {
; 0000 014D             hour=23;
	LDI  R30,LOW(23)
	MOV  R4,R30
; 0000 014E             }
; 0000 014F         else
	RJMP _0x75
_0x74:
; 0000 0150             {
; 0000 0151             hour--;
	DEC  R4
; 0000 0152             };
_0x75:
; 0000 0153         while(!DOWN);
_0x76:
	SBIS 0x10,0
	RJMP _0x76
; 0000 0154         }
; 0000 0155     }
_0x73:
; 0000 0156  //===============================
; 0000 0157  if(mode==3) //chinh ngay
_0x6C:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x79
; 0000 0158     {
; 0000 0159         so_ngay();
	RCALL _so_ngay
; 0000 015A     //================================
; 0000 015B     if(UP==0) // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x7A
; 0000 015C         {
; 0000 015D         if(date==No_date)
	CP   R9,R8
	BRNE _0x7B
; 0000 015E             {
; 0000 015F             date=1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0160             }
; 0000 0161         else
	RJMP _0x7C
_0x7B:
; 0000 0162             {
; 0000 0163             date++;
	INC  R8
; 0000 0164             };
_0x7C:
; 0000 0165         while(!UP);
_0x7D:
	SBIS 0x10,1
	RJMP _0x7D
; 0000 0166         }
; 0000 0167     //=========================================
; 0000 0168     if(DOWN==0)        // phim "DOWN" nhan
_0x7A:
	SBIC 0x10,0
	RJMP _0x80
; 0000 0169         {
; 0000 016A 
; 0000 016B         if(date==1)
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x81
; 0000 016C             {
; 0000 016D             date=No_date;
	MOV  R8,R9
; 0000 016E             }
; 0000 016F         else
	RJMP _0x82
_0x81:
; 0000 0170             {
; 0000 0171             date--;
	DEC  R8
; 0000 0172             };
_0x82:
; 0000 0173         while(!DOWN);
_0x83:
	SBIS 0x10,0
	RJMP _0x83
; 0000 0174         }
; 0000 0175     }
_0x80:
; 0000 0176  //================================================
; 0000 0177     if(mode==4)  //chinh thang
_0x79:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x86
; 0000 0178     {
; 0000 0179         //==================================
; 0000 017A     if(UP==0)
	SBIC 0x10,1
	RJMP _0x87
; 0000 017B         {
; 0000 017C         if(month==12)
	LDI  R30,LOW(12)
	CP   R30,R7
	BRNE _0x88
; 0000 017D             {
; 0000 017E             month=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 017F             }
; 0000 0180         else
	RJMP _0x89
_0x88:
; 0000 0181             {
; 0000 0182             month++;
	INC  R7
; 0000 0183             };
_0x89:
; 0000 0184         while(!UP);                                       // bao co phim nhan
_0x8A:
	SBIS 0x10,1
	RJMP _0x8A
; 0000 0185         }
; 0000 0186 /////////////////////////////////////////////////////////////
; 0000 0187     if(DOWN==0)
_0x87:
	SBIC 0x10,0
	RJMP _0x8D
; 0000 0188         {
; 0000 0189         if(month==1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x8E
; 0000 018A             {
; 0000 018B             month=12;
	LDI  R30,LOW(12)
	MOV  R7,R30
; 0000 018C             }
; 0000 018D         else
	RJMP _0x8F
_0x8E:
; 0000 018E             {
; 0000 018F             month--;
	DEC  R7
; 0000 0190             };
_0x8F:
; 0000 0191         while(!DOWN);
_0x90:
	SBIS 0x10,0
	RJMP _0x90
; 0000 0192         }
; 0000 0193     }
_0x8D:
; 0000 0194     //=================================
; 0000 0195     if(mode==5) //chinh nam
_0x86:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x93
; 0000 0196     {
; 0000 0197     if(UP==0)
	SBIC 0x10,1
	RJMP _0x94
; 0000 0198         {
; 0000 0199         if(year==99)
	LDI  R30,LOW(99)
	CP   R30,R10
	BRNE _0x95
; 0000 019A             {
; 0000 019B             year=0;
	CLR  R10
; 0000 019C             }
; 0000 019D         else
	RJMP _0x96
_0x95:
; 0000 019E             {
; 0000 019F             year++;
	INC  R10
; 0000 01A0             };
_0x96:
; 0000 01A1         while(!UP);
_0x97:
	SBIS 0x10,1
	RJMP _0x97
; 0000 01A2         }
; 0000 01A3 ///////////////////////////////////////////////////////////////
; 0000 01A4     if(DOWN==0)
_0x94:
	SBIC 0x10,0
	RJMP _0x9A
; 0000 01A5         {
; 0000 01A6         if(year==00)
	TST  R10
	BRNE _0x9B
; 0000 01A7             {
; 0000 01A8             year=99;
	LDI  R30,LOW(99)
	MOV  R10,R30
; 0000 01A9             }
; 0000 01AA         else
	RJMP _0x9C
_0x9B:
; 0000 01AB             {
; 0000 01AC             year--;
	DEC  R10
; 0000 01AD             };
_0x9C:
; 0000 01AE         while(!DOWN);
_0x9D:
	SBIS 0x10,0
	RJMP _0x9D
; 0000 01AF         }
; 0000 01B0     }
_0x9A:
; 0000 01B1 //====================
; 0000 01B2 if(mode==6)   //chinh phut bao thuc
_0x93:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0xA0
; 0000 01B3  {
; 0000 01B4    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0xA1
; 0000 01B5         {
; 0000 01B6         if(min_set==59)
	RCALL SUBOPT_0x16
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x3B)
	BRNE _0xA2
; 0000 01B7             {
; 0000 01B8             min_set=0;
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	RJMP _0xDC
; 0000 01B9             }
; 0000 01BA         else
_0xA2:
; 0000 01BB             {
; 0000 01BC             min_set++;
	RCALL SUBOPT_0x16
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
_0xDC:
	RCALL __EEPROMWRB
; 0000 01BD             };
; 0000 01BE         while(!UP); // doi nha phim
_0xA4:
	SBIS 0x10,1
	RJMP _0xA4
; 0000 01BF         }
; 0000 01C0    //==============
; 0000 01C1    if(DOWN==0)        // phim "DOWN" nhan
_0xA1:
	SBIC 0x10,0
	RJMP _0xA7
; 0000 01C2         {
; 0000 01C3         if(min_set==0)
	RCALL SUBOPT_0x16
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0xA8
; 0000 01C4             {
; 0000 01C5             min_set=59;
	RCALL SUBOPT_0x16
	LDI  R30,LOW(59)
	RJMP _0xDD
; 0000 01C6             }
; 0000 01C7         else
_0xA8:
; 0000 01C8             {
; 0000 01C9             min_set--;
	RCALL SUBOPT_0x16
	RCALL __EEPROMRDB
	SUBI R30,LOW(1)
_0xDD:
	RCALL __EEPROMWRB
; 0000 01CA             };
; 0000 01CB         while(!DOWN);
_0xAA:
	SBIS 0x10,0
	RJMP _0xAA
; 0000 01CC         }
; 0000 01CD  }
_0xA7:
; 0000 01CE  //===============================
; 0000 01CF   if(mode==7)   //chinh gio bao thuc
_0xA0:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0xAD
; 0000 01D0     {
; 0000 01D1    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0xAE
; 0000 01D2         {
; 0000 01D3         if(hour_set==23)
	RCALL SUBOPT_0x17
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x17)
	BRNE _0xAF
; 0000 01D4             {
; 0000 01D5             hour_set=0;
	RCALL SUBOPT_0x17
	LDI  R30,LOW(0)
	RJMP _0xDE
; 0000 01D6             }
; 0000 01D7         else
_0xAF:
; 0000 01D8             {
; 0000 01D9             hour_set++;
	RCALL SUBOPT_0x17
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
_0xDE:
	RCALL __EEPROMWRB
; 0000 01DA             };
; 0000 01DB         while(!UP); // doi nha phim
_0xB1:
	SBIS 0x10,1
	RJMP _0xB1
; 0000 01DC         }
; 0000 01DD    //==============
; 0000 01DE    if(DOWN==0)        // phim "DOWN" nhan
_0xAE:
	SBIC 0x10,0
	RJMP _0xB4
; 0000 01DF         {
; 0000 01E0         if(hour_set==0)
	RCALL SUBOPT_0x17
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0xB5
; 0000 01E1             {
; 0000 01E2             hour_set=23;
	RCALL SUBOPT_0x17
	LDI  R30,LOW(23)
	RJMP _0xDF
; 0000 01E3             }
; 0000 01E4         else
_0xB5:
; 0000 01E5             {
; 0000 01E6             hour_set--;
	RCALL SUBOPT_0x17
	RCALL __EEPROMRDB
	SUBI R30,LOW(1)
_0xDF:
	RCALL __EEPROMWRB
; 0000 01E7             };
; 0000 01E8         while(!DOWN);
_0xB7:
	SBIS 0x10,0
	RJMP _0xB7
; 0000 01E9         }
; 0000 01EA     }
_0xB4:
; 0000 01EB   //===================
; 0000 01EC   if(mode==8)   //chon on/off bao thuc
_0xAD:
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0xBA
; 0000 01ED   {
; 0000 01EE     if(alarm==1) glcd_putimage(43,52,alarm_on,GLCD_PUTCOPY);
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0x1)
	BRNE _0xBB
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_alarm_on)
	LDI  R31,HIGH(_alarm_on)
	RJMP _0xE0
; 0000 01EF     else glcd_putimage(43,52,alarm_off,GLCD_PUTCOPY);
_0xBB:
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_alarm_off)
	LDI  R31,HIGH(_alarm_off)
_0xE0:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1A
; 0000 01F0     if(UP==0)
	SBIC 0x10,1
	RJMP _0xBD
; 0000 01F1     {
; 0000 01F2      alarm++;
	RCALL SUBOPT_0x18
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
; 0000 01F3      if(alarm==2) alarm=0;
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0x2)
	BRNE _0xBE
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL SUBOPT_0x1B
; 0000 01F4     }
_0xBE:
; 0000 01F5     if(DOWN==0)
_0xBD:
	SBIC 0x10,0
	RJMP _0xBF
; 0000 01F6     {
; 0000 01F7      alarm--;
	RCALL SUBOPT_0x18
	SUBI R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01F8      if(alarm==0) alarm=1;
	RCALL SUBOPT_0x18
	CPI  R30,0
	BRNE _0xC0
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01F9     }
_0xC0:
; 0000 01FA   }
_0xBF:
; 0000 01FB 
; 0000 01FC }
_0xBA:
	RET
; .FEND
;
;void setDisplay()
; 0000 01FF {
_setDisplay:
; .FSTART _setDisplay
; 0000 0200 getTime();
	RCALL _getTime
; 0000 0201 if(hour>17 || hour<6) glcd_putimage(57,2,moon,GLCD_PUTCOPY);
	LDI  R30,LOW(17)
	CP   R30,R4
	BRLO _0xC2
	LDI  R30,LOW(6)
	CP   R4,R30
	BRSH _0xC1
_0xC2:
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(_moon)
	LDI  R31,HIGH(_moon)
	RJMP _0xE1
; 0000 0202 else glcd_putimage(57,2,sun,GLCD_PUTCOPY);
_0xC1:
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(_sun)
	LDI  R31,HIGH(_sun)
_0xE1:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1A
; 0000 0203 
; 0000 0204 if(alarm==1) glcd_putimage(43,52,alarm_on,GLCD_PUTCOPY);
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0x1)
	BRNE _0xC5
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_alarm_on)
	LDI  R31,HIGH(_alarm_on)
	RJMP _0xE2
; 0000 0205 else glcd_putimage(43,52,alarm_off,GLCD_PUTCOPY);
_0xC5:
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_alarm_off)
	LDI  R31,HIGH(_alarm_off)
_0xE2:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1A
; 0000 0206 }
	RET
; .FEND
;void main(void)
; 0000 0208 {
_main:
; .FSTART _main
; 0000 0209 
; 0000 020A GLCDINIT_t glcd_init_data;
; 0000 020B 
; 0000 020C // Input/Output Ports initialization
; 0000 020D // Port B initialization
; 0000 020E // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 020F DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(63)
	OUT  0x17,R30
; 0000 0210 // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0211 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0212 
; 0000 0213 // Port C initialization
; 0000 0214 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0215 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(2)
	OUT  0x14,R30
; 0000 0216 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=T
; 0000 0217 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0218 
; 0000 0219 // Port D initialization
; 0000 021A // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 021B DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 021C // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 021D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 021E 
; 0000 021F // Timer/Counter 0 initialization
; 0000 0220 // Clock source: System Clock
; 0000 0221 // Clock value: 1000.000 kHz
; 0000 0222 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0223 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0224 
; 0000 0225 // Timer/Counter 1 initialization
; 0000 0226 // Clock source: System Clock
; 0000 0227 // Clock value: 125.000 kHz
; 0000 0228 // Mode: Normal top=0xFFFF
; 0000 0229 // OC1A output: Disconnected
; 0000 022A // OC1B output: Disconnected
; 0000 022B // Noise Canceler: Off
; 0000 022C // Input Capture on Falling Edge
; 0000 022D // Timer Period: 0.52429 s
; 0000 022E // Timer1 Overflow Interrupt: On
; 0000 022F // Input Capture Interrupt: Off
; 0000 0230 // Compare A Match Interrupt: Off
; 0000 0231 // Compare B Match Interrupt: Off
; 0000 0232 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0233 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0234 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0235 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0236 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0237 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0238 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0239 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 023A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 023B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 023C 
; 0000 023D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 023E TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 023F 
; 0000 0240 // External Interrupt(s) initialization
; 0000 0241 // INT0: On
; 0000 0242 // INT0 Mode: Falling Edge
; 0000 0243 // INT1: On
; 0000 0244 // INT1 Mode: Falling Edge
; 0000 0245 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0246 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0247 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0248 
; 0000 0249 // Bit-Banged I2C Bus initialization
; 0000 024A // I2C Port: PORTC
; 0000 024B // I2C SDA bit: 4
; 0000 024C // I2C SCL bit: 5
; 0000 024D // Bit Rate: 100 kHz
; 0000 024E // Note: I2C settings are specified in the
; 0000 024F // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0250 i2c_init();
	RCALL _i2c_init
; 0000 0251 
; 0000 0252 // DS1307 Real Time Clock initialization
; 0000 0253 // Square wave output on pin SQW/OUT: Off
; 0000 0254 // SQW/OUT pin state: 0
; 0000 0255 rtc_init(0,0,0);
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0256 
; 0000 0257 // Graphic Display Controller initialization
; 0000 0258 // The ST7920 connections are specified in the
; 0000 0259 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 025A // E - PORTD Bit 7
; 0000 025B // R /W - PORTD Bit 6
; 0000 025C // RS - PORTD Bit 5
; 0000 025D // /RST - PORTB Bit 4
; 0000 025E // DB4 - PORTB Bit 0
; 0000 025F // DB5 - PORTB Bit 1
; 0000 0260 // DB6 - PORTB Bit 2
; 0000 0261 // DB7 - PORTB Bit 3
; 0000 0262 
; 0000 0263 // Specify the current font for displaying text
; 0000 0264 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0265 // No function is used for reading
; 0000 0266 // image data from external memory
; 0000 0267 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0268 // No function is used for writing
; 0000 0269 // image data to external memory
; 0000 026A glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 026B 
; 0000 026C glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 026D 
; 0000 026E // Global enable interrupts
; 0000 026F #asm("sei")
	sei
; 0000 0270 //glcd_rectangle(0,0,127,63);
; 0000 0271 //glcd_line(5,17,122,17);
; 0000 0272 //glcd_line(8,18,119,18);
; 0000 0273 //glcd_line(5,47,122,47);
; 0000 0274 //glcd_line(8,48,119,48);
; 0000 0275 if(alarm==255)
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0xFF)
	BRNE _0xC7
; 0000 0276 {
; 0000 0277   alarm=0;
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL SUBOPT_0x1B
; 0000 0278   min_set=0;
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1B
; 0000 0279   hour_set=0;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1B
; 0000 027A }
; 0000 027B 
; 0000 027C setDisplay();
_0xC7:
	RCALL _setDisplay
; 0000 027D while (1)
_0xC8:
; 0000 027E       {
; 0000 027F         timeDisplay(42,20);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(20)
	RCALL _timeDisplay
; 0000 0280         dateDisplay(31,37);
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R26,LOW(37)
	RCALL _dateDisplay
; 0000 0281         alarmDisplay(43,52);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(52)
	RCALL _alarmDisplay
; 0000 0282         if(mode==0)
	TST  R12
	BRNE _0xCB
; 0000 0283         {
; 0000 0284         getTime();
	RCALL _getTime
; 0000 0285         //tempDisplay(88,2,15,2);
; 0000 0286          if(hour==6) glcd_putimage(57,2,sun,GLCD_PUTCOPY);
	LDI  R30,LOW(6)
	CP   R30,R4
	BRNE _0xCC
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(_sun)
	LDI  R31,HIGH(_sun)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1A
; 0000 0287 
; 0000 0288          if(hour==18) glcd_putimage(57,2,moon,GLCD_PUTCOPY);
_0xCC:
	LDI  R30,LOW(18)
	CP   R30,R4
	BRNE _0xCD
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(_moon)
	LDI  R31,HIGH(_moon)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1A
; 0000 0289         }
_0xCD:
; 0000 028A         else
	RJMP _0xCE
_0xCB:
; 0000 028B         {
; 0000 028C           timer0_init();
	RCALL _timer0_init
; 0000 028D           setting();
	RCALL _setting
; 0000 028E         }
_0xCE:
; 0000 028F 
; 0000 0290       }
	RJMP _0xC8
; 0000 0291 }
_0xCF:
	RJMP _0xCF
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_st7920_delay_G100:
; .FSTART _st7920_delay_G100
    nop
    nop
    nop
	RET
; .FEND
_st7920_wrbus_G100:
; .FSTART _st7920_wrbus_G100
	ST   -Y,R26
	CBI  0x12,6
	SBI  0x12,7
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	RCALL SUBOPT_0x1E
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x18,R30
	RCALL _st7920_delay_G100
	CBI  0x12,7
	RCALL SUBOPT_0x1E
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0x1F
	CBI  0x12,7
	RJMP _0x222000A
; .FEND
_st7920_rdbus_G100:
; .FSTART _st7920_rdbus_G100
	ST   -Y,R17
	RCALL SUBOPT_0x20
	SBI  0x12,7
	RCALL _st7920_delay_G100
	IN   R30,0x16
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0x1F
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	OR   R17,R30
	CBI  0x12,7
	MOV  R30,R17
	RJMP _0x222000B
; .FEND
_st7920_busy_G100:
; .FSTART _st7920_busy_G100
	ST   -Y,R17
	CBI  0x12,5
	RCALL SUBOPT_0x20
_0x2000004:
	SBI  0x12,7
	RCALL _st7920_delay_G100
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	LDI  R26,LOW(0)
	RCALL __NEB12
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0x1F
	CBI  0x12,7
	RCALL _st7920_delay_G100
	CPI  R17,0
	BRNE _0x2000004
_0x222000B:
	LD   R17,Y+
	RET
; .FEND
_st7920_wrdata:
; .FSTART _st7920_wrdata
	ST   -Y,R26
	RCALL _st7920_busy_G100
	SBI  0x12,5
	LD   R26,Y
	RCALL _st7920_wrbus_G100
	RJMP _0x222000A
; .FEND
_st7920_rddata:
; .FSTART _st7920_rddata
	RCALL _st7920_busy_G100
	SBI  0x12,5
	RCALL _st7920_rdbus_G100
	RET
; .FEND
_st7920_wrcmd:
; .FSTART _st7920_wrcmd
	ST   -Y,R26
	RCALL _st7920_busy_G100
	LD   R26,Y
	RCALL _st7920_wrbus_G100
	RJMP _0x222000A
; .FEND
_st7920_setxy_G100:
; .FSTART _st7920_setxy_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	RCALL SUBOPT_0x21
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x2000006
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
_0x2000006:
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x80
	RCALL SUBOPT_0x21
	RJMP _0x2220003
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	RCALL SUBOPT_0x22
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000007
	LDI  R30,LOW(12)
	RJMP _0x2000008
_0x2000007:
	LDI  R30,LOW(8)
_0x2000008:
	RCALL SUBOPT_0x21
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(2)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(0)
_0x200000B:
	STS  _st7920_graphics_on_G100,R30
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
_0x222000A:
	ADIW R28,1
	RET
; .FEND
_glcd_cleargraphics:
; .FSTART _glcd_cleargraphics
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	RCALL SUBOPT_0x23
	LDI  R16,LOW(0)
_0x200000E:
	CPI  R16,64
	BRSH _0x2000010
	RCALL SUBOPT_0x1D
	MOV  R26,R16
	SUBI R16,-1
	RCALL _st7920_setxy_G100
	LDI  R17,LOW(16)
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	MOV  R26,R19
	RCALL _st7920_wrdata
	RJMP _0x2000011
_0x2000013:
	RJMP _0x200000E
_0x2000010:
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2220001
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x24
	ST   -Y,R17
	SBI  0x11,7
	CBI  0x12,7
	SBI  0x11,6
	SBI  0x12,6
	SBI  0x11,5
	CBI  0x12,5
	SBI  0x17,4
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x25
	CBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x25
	SBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x25
	CBI  0x12,6
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	LDI  R17,LOW(0)
_0x2000015:
	CPI  R17,6
	BRSH _0x2000016
	SBI  0x12,7
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_st7920_init_4bit_G100*2)
	SBCI R31,HIGH(-_st7920_init_4bit_G100*2)
	LPM  R30,Z
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 2
	CBI  0x12,7
	__DELAY_USB 67
	SUBI R17,-1
	RJMP _0x2000015
_0x2000016:
	LDI  R26,LOW(8)
	RCALL _st7920_wrbus_G100
	__DELAY_USB 67
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(15)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(0)
	STS  _yt_G100,R30
	STS  _xt_G100,R30
	LDI  R26,LOW(6)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(36)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(64)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(2)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _st7920_graphics_on_G100,R30
	RCALL _glcd_cleargraphics
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2000017
	RCALL SUBOPT_0x26
	RCALL __GETW1P
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x26
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x26
	ADIW R26,4
	RCALL __GETW1P
	RJMP _0x20000A6
_0x2000017:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
_0x20000A6:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x2
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2220002
; .FEND
_st7920_rdbyte_G100:
; .FSTART _st7920_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _st7920_setxy_G100
	RCALL _st7920_rddata
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x2000019
	RCALL _st7920_rddata
	STS  _st7920_bits8_15_G100,R30
_0x2000019:
	RCALL _st7920_rddata
	RJMP _0x2220003
; .FEND
_st7920_wrbyte_G100:
; .FSTART _st7920_wrbyte_G100
	RCALL SUBOPT_0x2A
	RCALL _st7920_setxy_G100
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x200001A
	LDS  R26,_st7920_bits8_15_G100
	RCALL _st7920_wrdata
_0x200001A:
	LD   R26,Y
	RCALL _st7920_wrdata
	RJMP _0x2220002
; .FEND
_st7920_wrmasked_G100:
; .FSTART _st7920_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	RCALL SUBOPT_0x23
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL SUBOPT_0x2B
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002A
	CPI  R30,LOW(0x8)
	BRNE _0x200002B
_0x200002A:
	RCALL SUBOPT_0xF
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002C
_0x200002B:
	CPI  R30,LOW(0x3)
	BRNE _0x200002E
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x200002F
_0x200002E:
	CPI  R30,0
	BRNE _0x2000030
_0x200002F:
	RJMP _0x2000031
_0x2000030:
	CPI  R30,LOW(0x9)
	BRNE _0x2000032
_0x2000031:
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0xA)
	BRNE _0x2000034
_0x2000033:
_0x200002C:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000035
_0x2000034:
	CPI  R30,LOW(0x2)
	BRNE _0x2000036
_0x2000035:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000028
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000037
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000028
_0x2000037:
	CPI  R30,LOW(0x4)
	BRNE _0x2000028
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000028:
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	MOV  R26,R17
	RCALL _glcd_revbits
	MOV  R26,R30
	RCALL _st7920_wrbyte_G100
	LDD  R17,Y+0
	RJMP _0x2220006
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,7
	RCALL __SAVELOCR6
	LDD  R26,Y+20
	CPI  R26,LOW(0x80)
	BRSH _0x200003A
	LDD  R26,Y+19
	CPI  R26,LOW(0x40)
	BRSH _0x200003A
	LDD  R26,Y+18
	CPI  R26,LOW(0x0)
	BREQ _0x200003A
	LDD  R26,Y+17
	CPI  R26,LOW(0x0)
	BRNE _0x2000039
_0x200003A:
	RJMP _0x2220009
_0x2000039:
	LDD  R30,Y+18
	RCALL SUBOPT_0x2C
	MOV  R18,R30
	__PUTBSR 18,8
	LDD  R30,Y+18
	ANDI R30,LOW(0x7)
	STD  Y+11,R30
	CPI  R30,0
	BREQ _0x200003C
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
_0x200003C:
	LDD  R16,Y+18
	LDD  R26,Y+20
	CLR  R27
	LDD  R30,Y+18
	RCALL SUBOPT_0x2D
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x200003D
	LDD  R26,Y+20
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+18,R30
_0x200003D:
	LDD  R30,Y+17
	STD  Y+10,R30
	LDD  R26,Y+19
	CLR  R27
	LDD  R30,Y+17
	RCALL SUBOPT_0x2D
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003E
	LDD  R26,Y+19
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+17,R30
_0x200003E:
	LDD  R30,Y+13
	CPI  R30,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000042
	LDD  R30,Y+16
	CPI  R30,LOW(0x1)
	BRNE _0x2000046
	RJMP _0x2220009
_0x2000046:
	CPI  R30,LOW(0x3)
	BRNE _0x2000049
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000048
	RJMP _0x2220009
_0x2000048:
_0x2000049:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x200004B
	LDD  R26,Y+18
	CP   R16,R26
	BREQ _0x200004A
_0x200004B:
	MOV  R30,R18
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL SUBOPT_0x2E
	LDD  R17,Y+17
_0x200004D:
	CPI  R17,0
	BREQ _0x200004F
	MOV  R19,R18
_0x2000050:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2000052
	RCALL SUBOPT_0x2F
	RJMP _0x2000050
_0x2000052:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x2E
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004F:
_0x200004A:
	LDD  R18,Y+17
	LDD  R30,Y+10
	CP   R30,R18
	BREQ _0x2000053
	MOV  R26,R18
	CLR  R27
	LDD  R30,Y+8
	RCALL SUBOPT_0x30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000054:
	PUSH R18
	SUBI R18,-1
	LDD  R30,Y+10
	POP  R26
	CP   R26,R30
	BRSH _0x2000056
	LDI  R19,LOW(0)
_0x2000057:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2000059
	RCALL SUBOPT_0x2F
	RJMP _0x2000057
_0x2000059:
	RJMP _0x2000054
_0x2000056:
_0x2000053:
	RJMP _0x2000041
_0x2000042:
	CPI  R30,LOW(0x9)
	BRNE _0x200005A
	LDI  R30,LOW(0)
	RJMP _0x20000A7
_0x200005A:
	CPI  R30,LOW(0xA)
	BRNE _0x2000041
	LDI  R30,LOW(255)
_0x20000A7:
	STD  Y+10,R30
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _glcd_mappixcolor1bit
	STD  Y+10,R30
_0x2000041:
	LDD  R30,Y+20
	ANDI R30,LOW(0x7)
	MOV  R19,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	MOV  R21,R18
	LDD  R26,Y+18
	CP   R18,R26
	BRLO _0x200005E
	LDD  R21,Y+18
	RJMP _0x200005F
_0x200005E:
	CPI  R19,0
	BREQ _0x2000060
	MOV  R20,R19
	LDD  R26,Y+18
	CPI  R26,LOW(0x9)
	BRSH _0x2000061
	LDD  R30,Y+18
	SUB  R30,R18
	MOV  R20,R30
_0x2000061:
	MOV  R30,R20
	RCALL SUBOPT_0x31
	LPM  R20,Z
_0x2000060:
_0x200005F:
	ST   -Y,R19
	MOV  R26,R21
	RCALL _glcd_getmask
	MOV  R21,R30
	LDD  R26,Y+11
	CP   R18,R26
	BRSH _0x2000062
	LDD  R30,Y+11
	SUB  R30,R18
	STD  Y+11,R30
_0x2000062:
	LDD  R30,Y+11
	RCALL SUBOPT_0x31
	LPM  R0,Z
	STD  Y+12,R0
	RCALL SUBOPT_0x23
_0x2000063:
	LDD  R30,Y+17
	SUBI R30,LOW(1)
	STD  Y+17,R30
	SUBI R30,-LOW(1)
	BRNE PC+2
	RJMP _0x2000065
	LDI  R17,LOW(0)
	LDD  R16,Y+20
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2000066
	__PUTBSR 20,11
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000067
_0x2000068:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x200006A
	ST   -Y,R16
	LDD  R26,Y+20
	RCALL SUBOPT_0x2B
	AND  R30,R21
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	STD  Y+9,R30
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	MOV  R1,R30
	MOV  R30,R19
	MOV  R26,R21
	RCALL __LSRB12
	COM  R30
	AND  R30,R1
	LDD  R26,Y+9
	OR   R30,R26
	STD  Y+9,R30
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x200006C
	MOV  R30,R16
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0xF)
	BRLO _0x200006B
_0x200006C:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x2
	LDD  R26,Y+12
	RCALL _glcd_writemem
	RJMP _0x200006A
_0x200006B:
	RCALL SUBOPT_0x35
	BRSH _0x200006E
	LDD  R30,Y+12
	STD  Y+11,R30
_0x200006E:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R26,Y+20
	RCALL SUBOPT_0x2B
	LDD  R26,Y+11
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	STD  Y+10,R30
	MOV  R30,R18
	LDD  R26,Y+11
	RCALL __LSLB12
	COM  R30
	LDD  R26,Y+9
	AND  R30,R26
	LDD  R26,Y+10
	OR   R30,R26
	STD  Y+10,R30
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x2
	LDD  R26,Y+13
	RCALL _glcd_writemem
	SUBI R17,-LOW(8)
	RJMP _0x2000068
_0x200006A:
	RJMP _0x200006F
_0x2000067:
_0x2000070:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2000072
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2000077
	CPI  R30,LOW(0xA)
	BRNE _0x2000079
_0x2000077:
	RJMP _0x2000075
_0x2000079:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RCALL _glcd_readmem
	STD  Y+10,R30
_0x2000075:
	RCALL SUBOPT_0x37
	MOV  R30,R19
	LDD  R26,Y+12
	RCALL __LSLB12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R26,Y+17
	RCALL _st7920_wrmasked_G100
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x2000072
	MOV  R30,R16
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0xF)
	BRSH _0x2000072
	RCALL SUBOPT_0x35
	BRSH _0x200007C
	LDD  R30,Y+12
	STD  Y+11,R30
_0x200007C:
	SUBI R16,-LOW(8)
	RCALL SUBOPT_0x37
	MOV  R30,R18
	LDD  R26,Y+12
	RCALL __LSRB12
	RCALL SUBOPT_0x38
	SUBI R17,-LOW(8)
	RJMP _0x2000070
_0x2000072:
_0x200006F:
	RJMP _0x200007D
_0x2000066:
	__PUTBSR 21,11
_0x200007E:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2000080
	RCALL SUBOPT_0x35
	BRSH _0x2000081
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2000081:
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2000086
	CPI  R30,LOW(0xA)
	BRNE _0x2000088
_0x2000086:
	RJMP _0x2000084
_0x2000088:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x200008A
	LDD  R26,Y+11
	CPI  R26,LOW(0xFF)
	BREQ _0x2000089
_0x200008A:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	STD  Y+10,R30
_0x2000089:
_0x2000084:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x200008C
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x2
	ST   -Y,R16
	LDD  R26,Y+23
	RCALL SUBOPT_0x2B
	LDD  R26,Y+14
	AND  R30,R26
	MOV  R0,R30
	LDD  R30,Y+14
	COM  R30
	LDD  R26,Y+13
	AND  R30,R26
	OR   R30,R0
	MOV  R26,R30
	RCALL _glcd_writemem
	RJMP _0x200008D
_0x200008C:
	RCALL SUBOPT_0x37
	LDD  R30,Y+12
	RCALL SUBOPT_0x38
_0x200008D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SUBI R16,-LOW(8)
	SUBI R17,-LOW(8)
	RJMP _0x200007E
_0x2000080:
_0x200007D:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+8
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x2000063
_0x2000065:
_0x2220009:
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRLO _0x2000090
	LDI  R30,LOW(15)
	STD  Y+4,R30
_0x2000090:
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRLO _0x2000091
	LDI  R30,LOW(3)
	STD  Y+3,R30
_0x2000091:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G100*2)
	SBCI R31,HIGH(-_st7920_base_y_G100*2)
	LPM  R26,Z
	LDD  R30,Y+4
	LSR  R30
	OR   R30,R26
	MOV  R17,R30
	RCALL SUBOPT_0x22
	MOV  R26,R17
	RCALL _st7920_wrcmd
	RCALL _st7920_rddata
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2000092
	RCALL _st7920_rddata
	MOV  R16,R30
_0x2000092:
	MOV  R26,R17
	RCALL _st7920_wrcmd
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2000093
	MOV  R26,R16
	RCALL _st7920_wrdata
_0x2000093:
	LDD  R26,Y+2
	RCALL _st7920_wrdata
	RCALL __LOADLOCR2
	RJMP _0x2220004
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x39
	BRLT _0x2020003
	RCALL SUBOPT_0x29
	RJMP _0x2220003
_0x2020003:
	RCALL SUBOPT_0x3A
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2220003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2220003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x39
	BRLT _0x2020005
	RCALL SUBOPT_0x29
	RJMP _0x2220003
_0x2020005:
	RCALL SUBOPT_0x3A
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2220003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2220003
; .FEND
_glcd_imagesize:
; .FSTART _glcd_imagesize
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x80)
	BRSH _0x2020008
	LDD  R26,Y+1
	CPI  R26,LOW(0x40)
	BRLO _0x2020007
_0x2020008:
	RCALL SUBOPT_0x3B
	LDD  R17,Y+0
	RJMP _0x2220002
_0x2020007:
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	MOV  R17,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x2C
	STD  Y+2,R30
	CPI  R17,0
	BREQ _0x202000A
	SUBI R30,-LOW(1)
	STD  Y+2,R30
_0x202000A:
	LDD  R26,Y+2
	CLR  R27
	CLR  R24
	CLR  R25
	LDD  R30,Y+1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __MULD12U
	__ADDD1N 4
	LDD  R17,Y+0
	RJMP _0x2220002
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	RCALL SUBOPT_0x24
	SBIW R28,3
	RCALL SUBOPT_0x3C
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	RCALL SUBOPT_0x29
	RJMP _0x2220008
_0x202000B:
	RCALL SUBOPT_0x3D
	STD  Y+7,R0
	RCALL SUBOPT_0x3D
	STD  Y+6,R0
	RCALL SUBOPT_0x3D
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	RCALL SUBOPT_0x29
	RJMP _0x2220008
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	RCALL SUBOPT_0x29
	RJMP _0x2220008
_0x202000D:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000E
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	RCALL SUBOPT_0x2C
	MOV  R20,R30
	LDD  R30,Y+7
	ANDI R30,LOW(0x7)
	BREQ _0x202000F
	SUBI R20,-LOW(1)
_0x202000F:
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+6
	RCALL SUBOPT_0x30
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x30
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2220008
_0x202000E:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	LPM  R30,Z
	RCALL SUBOPT_0x2C
	MOV  R20,R30
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	ANDI R30,LOW(0x7)
	BREQ _0x2020013
	SUBI R20,-LOW(1)
_0x2020013:
	LDD  R26,Y+6
	CLR  R27
	MOV  R30,R20
	RCALL SUBOPT_0x30
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2220008:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2D
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x3F
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x3C
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2020020
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020021
	RJMP _0x2020022
_0x2020021:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020023
	RCALL __LOADLOCR6
	RJMP _0x2220005
_0x2020023:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020024
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020024:
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x3E
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	RCALL SUBOPT_0x40
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x41
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x3E
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x40
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x3E
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x42
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020025
_0x2020022:
	RCALL _glcd_new_line_G101
	RCALL __LOADLOCR6
	RJMP _0x2220005
_0x2020025:
	RJMP _0x2020026
_0x2020020:
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BREQ _0x2020028
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x2C
	MOV  R19,R30
	__GETB1MN _glcd_state,3
	SWAP R30
	ANDI R30,0xF
	MOV  R18,R30
	ST   -Y,R19
	ST   -Y,R18
	LDD  R26,Y+9
	RCALL _glcd_putcharcg
	MOV  R30,R19
	LSL  R30
	LSL  R30
	LSL  R30
	__PUTB1MN _glcd_state,2
	LDI  R26,LOW(16)
	MUL  R18,R26
	MOVW R30,R0
	__PUTB1MN _glcd_state,3
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x40
	LDI  R31,0
	ADIW R30,8
	MOVW R16,R30
	__CPWRN 16,17,128
	BRLO _0x2020029
_0x2020028:
	__GETWRN 16,17,0
	__GETB1MN _glcd_state,3
	LDI  R31,0
	ADIW R30,16
	MOVW R26,R30
	RCALL SUBOPT_0x3F
_0x2020029:
_0x2020026:
	__PUTBMRN _glcd_state,2,16
	RCALL __LOADLOCR6
	RJMP _0x2220005
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	RCALL SUBOPT_0x2A
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x2220002
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0x24
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x202002A:
	RCALL SUBOPT_0x43
	BREQ _0x202002C
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x202002A
_0x202002C:
	LDD  R17,Y+0
	RJMP _0x2220004
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	RCALL SUBOPT_0x24
	ST   -Y,R17
_0x2020033:
	RCALL SUBOPT_0x43
	BREQ _0x2020035
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020033
_0x2020035:
	LDD  R17,Y+0
	RJMP _0x2220002
; .FEND
_glcd_putimage:
; .FSTART _glcd_putimage
	ST   -Y,R26
	RCALL __SAVELOCR4
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRSH _0x202003C
	RCALL SUBOPT_0x44
	LD   R16,X+
	RCALL SUBOPT_0x45
	LD   R17,X+
	RCALL SUBOPT_0x45
	LD   R18,X+
	RCALL SUBOPT_0x45
	LD   R19,X+
	STD  Y+5,R26
	STD  Y+5+1,R27
	LDD  R30,Y+8
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R16
	ST   -Y,R18
	RCALL SUBOPT_0x1D
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x2
	LDD  R26,Y+11
	RCALL _glcd_block
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_imagesize
	RJMP _0x2220007
_0x202003C:
	RCALL SUBOPT_0x3B
_0x2220007:
	RCALL __LOADLOCR4
	ADIW R28,9
	RET
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0x3F
	RJMP _0x2220003
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2060003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2060003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2060004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2060004:
	RCALL SUBOPT_0x46
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x47
	RJMP _0x2220002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x46
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
_0x2220006:
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	RCALL SUBOPT_0x46
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x47
	RJMP _0x2220002
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x46
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x4A
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x3A
	ST   X,R30
	RCALL _i2c_stop
_0x2220005:
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	RCALL SUBOPT_0x46
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x47
	RJMP _0x2220001
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.DSEG

	.DSEG

	.DSEG

	.DSEG

	.CSEG
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x24
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2220004:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x31
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2220003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x21A0007
	CPI  R30,LOW(0xA)
	BRNE _0x21A0008
_0x21A0007:
	LDS  R17,_glcd_state
	RJMP _0x21A0009
_0x21A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x21A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x21A0009
_0x21A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x21A0005
	__GETBRMN 17,_glcd_state,16
_0x21A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x21A000E
	CPI  R17,0
	BREQ _0x21A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2220002
_0x21A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2220002
_0x21A000E:
	CPI  R17,0
	BRNE _0x21A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2220002
_0x21A0011:
_0x21A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2220002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x24
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x21A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2220002
_0x21A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x21A0016
	RCALL SUBOPT_0x3A
	RCALL __EEPROMRDB
	RJMP _0x2220002
_0x21A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x21A0018
	RCALL SUBOPT_0x3A
	__CALL1MN _glcd_state,25
	RJMP _0x2220002
_0x21A0018:
	RCALL SUBOPT_0x3A
	LD   R30,X
_0x2220002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x21A001C
	LD   R30,Y
	RCALL SUBOPT_0x26
	ST   X,R30
	RJMP _0x21A001B
_0x21A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x21A001D
	LD   R30,Y
	RCALL SUBOPT_0x26
	RCALL __EEPROMWRB
	RJMP _0x21A001B
_0x21A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x21A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x2
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x21A001B:
_0x2220001:
	ADIW R28,4
	RET
; .FEND
_glcd_revbits:
; .FSTART _glcd_revbits
	ST   -Y,R26
    ld  r26,y+
    bst r26,0
    bld r30,7

    bst r26,1
    bld r30,6

    bst r26,2
    bld r30,5

    bst r26,3
    bld r30,4

    bst r26,4
    bld r30,3

    bst r26,5
    bld r30,2

    bst r26,6
    bld r30,1

    bst r26,7
    bld r30,0
    ret
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_moon:
	.BYTE 0x1E
_sun:
	.BYTE 0x1E
_alarm_on:
	.BYTE 0xC
_alarm_off:
	.BYTE 0xC

	.ESEG
_min_set:
	.BYTE 0x1
_hour_set:
	.BYTE 0x1
_alarm:
	.BYTE 0x1

	.DSEG
_st7920_graphics_on_G100:
	.BYTE 0x1
_st7920_bits8_15_G100:
	.BYTE 0x1
_xt_G100:
	.BYTE 0x1
_yt_G100:
	.BYTE 0x1
__seed_G110:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(_fontNumber*2)
	LDI  R31,HIGH(_fontNumber*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x5:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _glcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x6:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_fontNumber*2)
	LDI  R31,HIGH(_fontNumber*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	ST   -Y,R26
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xC:
	MOV  R30,R8
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xD:
	MOV  R26,R10
	CLR  R27
	RCALL SUBOPT_0x1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	LDD  R30,Y+3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	SUBI R30,-LOW(10)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_hour_set)
	LDI  R27,HIGH(_hour_set)
	RCALL __EEPROMRDB
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_min_set)
	LDI  R27,HIGH(_min_set)
	RCALL __EEPROMRDB
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_min_set)
	LDI  R27,HIGH(_min_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_hour_set)
	LDI  R27,HIGH(_hour_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(52)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(0)
	RJMP _glcd_putimage

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(57)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	RCALL _st7920_delay_G100
	SBI  0x12,7
	RJMP _st7920_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	SBI  0x12,6
	IN   R30,0x17
	ANDI R30,LOW(0xF0)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	MOV  R26,R30
	RJMP _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDS  R30,_st7920_graphics_on_G100
	ORI  R30,0x20
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	LDS  R30,_st7920_graphics_on_G100
	ORI  R30,LOW(0x24)
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	RCALL _st7920_rdbyte_G100
	MOV  R26,R30
	RJMP _glcd_revbits

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2C:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x2
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDD  R30,Y+16
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x34
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R26,Y+17
	RJMP _st7920_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x24
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3A:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x26
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	STD  Y+5,R26
	STD  Y+5+1,R27
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x46:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4A:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET


	.CSEG
	.equ __sda_bit=4
	.equ __scl_bit=5
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,2
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,3
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
