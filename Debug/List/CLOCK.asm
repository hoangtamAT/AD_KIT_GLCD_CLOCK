
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 4.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _hour=R5
	.DEF _minn=R4
	.DEF _sec=R7
	.DEF _day=R6
	.DEF _date=R9
	.DEF _month=R8
	.DEF _year=R11
	.DEF _mode=R10
	.DEF _time=R13
	.DEF _time1=R12

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
_conv_delay_G101:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G101:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G102:
	.DB  0x3,0x3,0x2,0x0,0x2,0x0
_st7920_base_y_G102:
	.DB  0x80,0x90,0x88,0x98

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x2E,0x0,0x6F,0x0,0x43,0x0,0x3A,0x0
	.DB  0x2E,0x2E,0x0,0x2F,0x0,0x20,0x20,0x0
_0x2140060:
	.DB  0x1
_0x2140000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x6+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x6+4
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x7
	.DW  _0x0*2+6

	.DW  0x03
	.DW  _0x7+2
	.DW  _0x0*2+8

	.DW  0x03
	.DW  _0x7+5
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x7+8
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x11
	.DW  _0x0*2+11

	.DW  0x02
	.DW  _0x11+2
	.DW  _0x0*2+11

	.DW  0x03
	.DW  _0x11+4
	.DW  _0x0*2+13

	.DW  0x03
	.DW  _0x11+7
	.DW  _0x0*2+13

	.DW  0x03
	.DW  _0x11+10
	.DW  _0x0*2+13

	.DW  0x02
	.DW  _0x1B
	.DW  _0x0*2+6

	.DW  0x03
	.DW  _0x1B+2
	.DW  _0x0*2+13

	.DW  0x03
	.DW  _0x1B+5
	.DW  _0x0*2+13

	.DW  0x03
	.DW  _0x1B+8
	.DW  _0x0*2+13

	.DW  0x01
	.DW  __seed_G10A
	.DW  _0x2140060*2

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
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/26/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 4.000000 MHz
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
;#include <ds1307.h>
;#include <1wire.h>
;#include <ds18b20.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <fontnumber8x13.h>
;//#include <stdio.h>
;//#include "LCD/moon.h"
;//#include "LCD/sun.h"
;//#include "LCD/alarm_on.h"
;//#include "LCD/alarm_off.h"
;
;#define UP      PIND.1
;#define DOWN    PIND.0
;bit blink,flash_sec;
;char hour,minn,sec,day,date,month,year;
;unsigned char mode,time,time1;
;char *T=0;
;eeprom unsigned char min_set,hour_set,alarm;
;
;void timer0_init()
; 0000 002F {

	.CSEG
_timer0_init:
; .FSTART _timer0_init
; 0000 0030 TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0031 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0032 TIMSK=1<<TOIE0;
	LDI  R30,LOW(1)
	RJMP _0x218000C
; 0000 0033 }
; .FEND
;void timer0_stop()
; 0000 0035 {
_timer0_stop:
; .FSTART _timer0_stop
; 0000 0036   TCCR0=0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0037   TIMSK=0<<TOIE0;
_0x218000C:
	OUT  0x39,R30
; 0000 0038 }
	RET
; .FEND
;
;// Declare your global variables here
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003E {
_ext_int0_isr:
; .FSTART _ext_int0_isr
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
; 0000 003F     //OK
; 0000 0040     rtc_set_time(hour,minn,sec);
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R7
	RCALL _rtc_set_time
; 0000 0041     rtc_set_date(day,date,month,year);
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	MOV  R26,R11
	RCALL _rtc_set_date
; 0000 0042     timer0_stop();
	RCALL _timer0_stop
; 0000 0043     mode=0;
	CLR  R10
; 0000 0044 }
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
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0048 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 0049     //MODE
; 0000 004A     mode++;
	INC  R10
; 0000 004B     if(mode>8) mode=0;
	LDI  R30,LOW(8)
	CP   R30,R10
	BRSH _0x3
	CLR  R10
; 0000 004C }
_0x3:
	RJMP _0x90
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0050 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x0
; 0000 0051     //0.512ms
; 0000 0052     time++;
	INC  R13
; 0000 0053     if(time>50)
	LDI  R30,LOW(50)
	CP   R30,R13
	BRSH _0x4
; 0000 0054     {
; 0000 0055       blink=~blink;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 0056       time=0;
	CLR  R13
; 0000 0057     }
; 0000 0058 }
_0x4:
	RJMP _0x90
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 005C {   //0.13s
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x0
; 0000 005D     time1++;
	INC  R12
; 0000 005E     if(time>4)
	LDI  R30,LOW(4)
	CP   R30,R13
	BRSH _0x5
; 0000 005F     {
; 0000 0060         time1=0;
	CLR  R12
; 0000 0061         flash_sec=~flash_sec;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 0062     }
; 0000 0063 
; 0000 0064 }
_0x5:
_0x90:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;void tempDisplay(unsigned char x, unsigned char y)
; 0000 0066 {
_tempDisplay:
; .FSTART _tempDisplay
; 0000 0067   float temp;
; 0000 0068   unsigned int nhietdo;
; 0000 0069   temp=ds18b20_temperature(T);
	ST   -Y,R26
	SBIW R28,4
	RCALL __SAVELOCR2
;	x -> Y+7
;	y -> Y+6
;	temp -> Y+2
;	nhietdo -> R16,R17
	LDS  R26,_T
	LDS  R27,_T+1
	RCALL _ds18b20_temperature
	__PUTD1S 2
; 0000 006A   nhietdo=temp*10;
	__GETD2S 2
	__GETD1N 0x41200000
	RCALL __MULF12
	RCALL __CFD1U
	MOVW R16,R30
; 0000 006B   glcd_setfont(font5x7);
	RCALL SUBOPT_0x1
; 0000 006C   glcd_putcharxy(x,y,48+nhietdo/100);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	RCALL SUBOPT_0x3
	RCALL _glcd_putcharxy
; 0000 006D   glcd_putchar(48+(nhietdo/10)%10);
	MOVW R26,R16
	RCALL SUBOPT_0x4
	RCALL __DIVW21U
	RCALL SUBOPT_0x5
	RCALL _glcd_putchar
; 0000 006E   glcd_outtext(".");
	__POINTW2MN _0x6,0
	RCALL _glcd_outtext
; 0000 006F   glcd_putchar(48+(nhietdo%100)%10);
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21U
	RCALL SUBOPT_0x5
	RCALL _glcd_putchar
; 0000 0070   glcd_outtextxy(x+24,y,"o");
	LDD  R30,Y+7
	SUBI R30,-LOW(24)
	ST   -Y,R30
	RCALL SUBOPT_0x2
	__POINTW2MN _0x6,2
	RCALL _glcd_outtextxy
; 0000 0071   glcd_outtextxy(x+30,y+3,"C");
	LDD  R30,Y+7
	SUBI R30,-LOW(30)
	ST   -Y,R30
	LDD  R30,Y+7
	SUBI R30,-LOW(3)
	ST   -Y,R30
	__POINTW2MN _0x6,4
	RCALL _glcd_outtextxy
; 0000 0072 }
	RCALL __LOADLOCR2
	RJMP _0x2180007
; .FEND

	.DSEG
_0x6:
	.BYTE 0x6
;
;void getTime()
; 0000 0075 {

	.CSEG
_getTime:
; .FSTART _getTime
; 0000 0076     rtc_get_time(&hour,&minn,&sec);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _rtc_get_time
; 0000 0077     rtc_get_date(&day,&date,&month,&year);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	RCALL _rtc_get_date
; 0000 0078 }
	RET
; .FEND
;void timeDisplay(unsigned char x, unsigned char y)
; 0000 007A {
_timeDisplay:
; .FSTART _timeDisplay
; 0000 007B   glcd_setfont(fontNumber);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	RCALL SUBOPT_0x7
; 0000 007C   glcd_putcharxy(x,y,48+(hour/10));
	MOV  R26,R5
	RCALL SUBOPT_0x8
	RCALL _glcd_putcharxy
; 0000 007D   glcd_putchar(48+(hour%10));
	MOV  R26,R5
	RCALL SUBOPT_0x9
	RCALL _glcd_putchar
; 0000 007E   glcd_outtext(":");
	__POINTW2MN _0x7,0
	RCALL _glcd_outtext
; 0000 007F   glcd_putchar(48+(minn/10));
	MOV  R26,R4
	RCALL SUBOPT_0x8
	RCALL _glcd_putchar
; 0000 0080   glcd_putchar(48+(minn%10));
	MOV  R26,R4
	RCALL SUBOPT_0x9
	RCALL _glcd_putchar
; 0000 0081 
; 0000 0082   if(mode==2 && blink%2==0)
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x9
	RCALL SUBOPT_0xA
	BREQ _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 0083   {
; 0000 0084     glcd_setfont(fontNumber);
	RCALL SUBOPT_0x7
; 0000 0085     glcd_outtextxy(x,y,"..");
	__POINTW2MN _0x7,2
	RCALL _glcd_outtextxy
; 0000 0086   }
; 0000 0087   if(mode==1 && blink%2==0)
_0x8:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xC
	RCALL SUBOPT_0xA
	BREQ _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 0088   {
; 0000 0089     glcd_setfont(fontNumber);
	RCALL SUBOPT_0xB
; 0000 008A     glcd_outtextxy(x+27,y,"..");
	SUBI R30,-LOW(27)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x7,5
	RCALL _glcd_outtextxy
; 0000 008B   }
; 0000 008C   if(mode==0 && flash_sec%2==0)
_0xB:
	TST  R10
	BRNE _0xF
	LDI  R30,0
	SBRC R2,1
	LDI  R30,1
	RCALL SUBOPT_0xD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	SBIW R30,0
	BREQ _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 008D   {
; 0000 008E     glcd_setfont(fontNumber);
	RCALL SUBOPT_0xB
; 0000 008F     glcd_outtextxy(x+18,y,".");
	SUBI R30,-LOW(18)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x7,8
	RCALL _glcd_outtextxy
; 0000 0090   }
; 0000 0091 }
_0xE:
	RJMP _0x2180003
; .FEND

	.DSEG
_0x7:
	.BYTE 0xA
;/*
;void dayDisplay(unsigned char x, unsigned char y)
;{ int C;
;switch (month)
;             {
;             case 1: C=date;
;                     break;
;             case 2: C=31+date;
;                     break;
;             case 3: if(year%4==0) C=60+date;
;                     else C=59+date;
;                     break;
;             case 4: if((year%4)==0) C=91+date;
;                     else C=90+date;
;                     break;
;             case 5: if((year%4)==0) C=121+date;
;                     else C=120+date;
;                     break;
;             case 6: if((year%4)==0) C=152+date;
;                     else C=151+date;
;                     break;
;             case 7: if((year%4)==0) C=182+date;
;                     else C=181+date;
;                     break;
;             case 8: if((year%4)==0) C=213+date;
;                     else C=212+date;
;                     break;
;             case 9: if((year%4)==0) C=244+date;
;                     else C=243+date;
;                     break;
;             case 10:if((year%4)==0) C=274+date;
;                     else C=273+date;
;                     break;
;             case 11:if((year%4)==0) C=305+date;
;                     else C=304+date;
;                     break;
;             case 12:if((year%4)==0) C=335+date;
;                     else C=334+date;
;                     break;
;             default:
;             }
;             //glcd_setfont(font5x7);
;             //cong thuc tinh thu:
;            // n=((years-1)+((years-1)/4)-((years-1)/100)+((years-1)/400)+C)%7
;            // n: thu trong tuan (0=CN;1=T2.....6=t7)
;            // C: ngay thu bao nhieu tu dau nam den hien tai
; switch(((2000+year-1)+((2000+year-1)/4)-((2000+year-1)/100)+((2000+year-1)/400)+C)%7)
;            {
;                case 0: glcd_outtextxy(x,y,"CN-"); break;
;                case 1: glcd_outtextxy(x,y,"T2-"); break;
;                case 2: glcd_outtextxy(x,y,"T3-"); break;
;                case 3: glcd_outtextxy(x,y,"T4-"); break;
;                case 4: glcd_outtextxy(x,y,"T5-"); break;
;                case 5: glcd_outtextxy(x,y,"T6-"); break;
;                case 6: glcd_outtextxy(x,y,"T7-"); break;
;                default:
;            }
;}
;*/
;void dateDisplay(unsigned char x, unsigned char y)
; 0000 00CE {

	.CSEG
_dateDisplay:
; .FSTART _dateDisplay
; 0000 00CF   glcd_setfont(font5x7);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	RCALL SUBOPT_0x1
; 0000 00D0   //dayDisplay(x,y);
; 0000 00D1   glcd_putcharxy(x,y,48+(date/10));
	LDD  R30,Y+1
	RCALL SUBOPT_0xC
	MOV  R26,R9
	RCALL SUBOPT_0x8
	RCALL _glcd_putcharxy
; 0000 00D2   glcd_putchar(48+(date%10));
	MOV  R26,R9
	RCALL SUBOPT_0x9
	RCALL _glcd_putchar
; 0000 00D3   glcd_outtext("/");
	__POINTW2MN _0x11,0
	RCALL _glcd_outtext
; 0000 00D4   glcd_putchar(48+(month/10));
	MOV  R26,R8
	RCALL SUBOPT_0x8
	RCALL _glcd_putchar
; 0000 00D5   glcd_putchar(48+(month%10));
	MOV  R26,R8
	RCALL SUBOPT_0x9
	RCALL _glcd_putchar
; 0000 00D6   glcd_outtext("/");
	__POINTW2MN _0x11,2
	RCALL _glcd_outtext
; 0000 00D7   glcd_putchar(48+(year/10));
	MOV  R26,R11
	RCALL SUBOPT_0x8
	RCALL _glcd_putchar
; 0000 00D8   glcd_putchar(48+(year%10));
	MOV  R26,R11
	RCALL SUBOPT_0x9
	RCALL _glcd_putchar
; 0000 00D9 
; 0000 00DA   if(blink%2==0 && mode==3)
	RCALL SUBOPT_0xA
	BRNE _0x13
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 00DB   {
; 0000 00DC     glcd_outtextxy(x+18,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(18)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x11,4
	RCALL _glcd_outtextxy
; 0000 00DD   }
; 0000 00DE   if(blink%2==0 && mode==4)
_0x12:
	RCALL SUBOPT_0xA
	BRNE _0x16
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ _0x17
_0x16:
	RJMP _0x15
_0x17:
; 0000 00DF   {
; 0000 00E0     glcd_outtextxy(x+36,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(36)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x11,7
	RCALL _glcd_outtextxy
; 0000 00E1   }
; 0000 00E2   if(blink%2==0 && mode==5)
_0x15:
	RCALL SUBOPT_0xA
	BRNE _0x19
	LDI  R30,LOW(5)
	CP   R30,R10
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 00E3   {
; 0000 00E4     glcd_outtextxy(x+54,y,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(54)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x11,10
	RCALL _glcd_outtextxy
; 0000 00E5   }
; 0000 00E6 }
_0x18:
	RJMP _0x2180003
; .FEND

	.DSEG
_0x11:
	.BYTE 0xD
;void alarmDisplay(unsigned char x, unsigned char y)
; 0000 00E8 {

	.CSEG
_alarmDisplay:
; .FSTART _alarmDisplay
; 0000 00E9    glcd_setfont(font5x7);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	RCALL SUBOPT_0x1
; 0000 00EA    glcd_putcharxy(x+10,y+1,48+hour_set/10);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x4
	RCALL __DIVW21
	RCALL SUBOPT_0x3
	RCALL _glcd_putcharxy
; 0000 00EB    glcd_putchar(48+hour_set%10);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x4
	RCALL __MODW21
	RCALL SUBOPT_0x3
	RCALL _glcd_putchar
; 0000 00EC    glcd_outtext(":");
	__POINTW2MN _0x1B,0
	RCALL _glcd_outtext
; 0000 00ED    glcd_putchar(48+min_set/10);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
	RCALL __DIVW21
	RCALL SUBOPT_0x3
	RCALL _glcd_putchar
; 0000 00EE    glcd_putchar(48+min_set%10);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
	RCALL __MODW21
	RCALL SUBOPT_0x3
	RCALL _glcd_putchar
; 0000 00EF 
; 0000 00F0    if(mode==6 && blink==1)
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x1D
	SBRC R2,0
	RJMP _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 00F1    {
; 0000 00F2      glcd_setfont(font5x7);
	RCALL SUBOPT_0x1
; 0000 00F3      glcd_outtextxy(x+28,y+1,"  ");
	LDD  R30,Y+1
	SUBI R30,-LOW(28)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	ST   -Y,R30
	__POINTW2MN _0x1B,2
	RCALL _glcd_outtextxy
; 0000 00F4    }
; 0000 00F5    if(mode==7 && blink==1)
_0x1C:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x20
	SBRC R2,0
	RJMP _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 00F6    {
; 0000 00F7      glcd_setfont(font5x7);
	RCALL SUBOPT_0x1
; 0000 00F8      glcd_outtextxy(x+10,y+1,"  ");
	RCALL SUBOPT_0xE
	__POINTW2MN _0x1B,5
	RCALL _glcd_outtextxy
; 0000 00F9    }
; 0000 00FA    if(mode==8 && blink==1)
_0x1F:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x23
	SBRC R2,0
	RJMP _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00FB    {
; 0000 00FC      glcd_setfont(font5x7);
	RCALL SUBOPT_0x1
; 0000 00FD      glcd_outtextxy(x-3,y,"  ");
	LDD  R30,Y+1
	SUBI R30,LOW(3)
	RCALL SUBOPT_0xC
	__POINTW2MN _0x1B,8
	RCALL _glcd_outtextxy
; 0000 00FE    }
; 0000 00FF }
_0x22:
	RJMP _0x2180003
; .FEND

	.DSEG
_0x1B:
	.BYTE 0xB
;/*
;void so_ngay(void)
;{
;  if(month==2)     // thang 2 nam nhuan co 29 ngay, nam thuong co 28 ngay
;  {
;   if(year%4==0)   //&&year%100!=0||year%400==0)
;   {
;    No_date=29;
;   }
;   else
;   {
;    No_date=28;
;   };
;  }
;
;  else
;  {
;   if(month==4||month==6||month==9||month==11)
;   {
;    No_date=30;
;   }
;
;   else
;   {
;    if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
;    {
;     No_date=31;
;    }
;   };
;  };
;
;}
;*/
;void setting(void)
; 0000 0122 {

	.CSEG
_setting:
; .FSTART _setting
; 0000 0123  //so_ngay();
; 0000 0124 //================================================
; 0000 0125  if(mode==1)   //chinh phut
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x25
; 0000 0126  {
; 0000 0127    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x26
; 0000 0128         {
; 0000 0129         if(minn==59)
	LDI  R30,LOW(59)
	CP   R30,R4
	BRNE _0x27
; 0000 012A             {
; 0000 012B             minn=0;
	CLR  R4
; 0000 012C             }
; 0000 012D         else
	RJMP _0x28
_0x27:
; 0000 012E             {
; 0000 012F             minn++;
	INC  R4
; 0000 0130             };
_0x28:
; 0000 0131         while(!UP); // doi nha phim
_0x29:
	SBIS 0x10,1
	RJMP _0x29
; 0000 0132         }
; 0000 0133    //==============
; 0000 0134    if(DOWN==0)        // phim "DOWN" nhan
_0x26:
	SBIC 0x10,0
	RJMP _0x2C
; 0000 0135         {
; 0000 0136         if(minn==0)
	TST  R4
	BRNE _0x2D
; 0000 0137             {
; 0000 0138             minn=59;
	LDI  R30,LOW(59)
	MOV  R4,R30
; 0000 0139             }
; 0000 013A         else
	RJMP _0x2E
_0x2D:
; 0000 013B             {
; 0000 013C             minn--;
	DEC  R4
; 0000 013D             };
_0x2E:
; 0000 013E         while(!DOWN);
_0x2F:
	SBIS 0x10,0
	RJMP _0x2F
; 0000 013F         }
; 0000 0140  }
_0x2C:
; 0000 0141  //===============================
; 0000 0142   if(mode==2)   //chinh gio
_0x25:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x32
; 0000 0143     {
; 0000 0144    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x33
; 0000 0145         {
; 0000 0146         if(hour==23)
	LDI  R30,LOW(23)
	CP   R30,R5
	BRNE _0x34
; 0000 0147             {
; 0000 0148             hour=0;
	CLR  R5
; 0000 0149             }
; 0000 014A         else
	RJMP _0x35
_0x34:
; 0000 014B             {
; 0000 014C             hour++;
	INC  R5
; 0000 014D             };
_0x35:
; 0000 014E         while(!UP); // doi nha phim
_0x36:
	SBIS 0x10,1
	RJMP _0x36
; 0000 014F         }
; 0000 0150    //==============
; 0000 0151    if(DOWN==0)        // phim "DOWN" nhan
_0x33:
	SBIC 0x10,0
	RJMP _0x39
; 0000 0152         {
; 0000 0153         if(hour==0)
	TST  R5
	BRNE _0x3A
; 0000 0154             {
; 0000 0155             hour=23;
	LDI  R30,LOW(23)
	MOV  R5,R30
; 0000 0156             }
; 0000 0157         else
	RJMP _0x3B
_0x3A:
; 0000 0158             {
; 0000 0159             hour--;
	DEC  R5
; 0000 015A             };
_0x3B:
; 0000 015B         while(!DOWN);
_0x3C:
	SBIS 0x10,0
	RJMP _0x3C
; 0000 015C         }
; 0000 015D     }
_0x39:
; 0000 015E  //===============================
; 0000 015F  if(mode==3) //chinh ngay
_0x32:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x3F
; 0000 0160     {
; 0000 0161     //================================
; 0000 0162     if(UP==0) // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x40
; 0000 0163         {
; 0000 0164         if(date==31)
	LDI  R30,LOW(31)
	CP   R30,R9
	BRNE _0x41
; 0000 0165             {
; 0000 0166             date=1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0167             }
; 0000 0168         else
	RJMP _0x42
_0x41:
; 0000 0169             {
; 0000 016A             date++;
	INC  R9
; 0000 016B             };
_0x42:
; 0000 016C         while(!UP);
_0x43:
	SBIS 0x10,1
	RJMP _0x43
; 0000 016D         }
; 0000 016E     //=========================================
; 0000 016F     if(DOWN==0)        // phim "DOWN" nhan
_0x40:
	SBIC 0x10,0
	RJMP _0x46
; 0000 0170         {
; 0000 0171 
; 0000 0172         if(date==1)
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x47
; 0000 0173             {
; 0000 0174             date=31;
	LDI  R30,LOW(31)
	MOV  R9,R30
; 0000 0175             }
; 0000 0176         else
	RJMP _0x48
_0x47:
; 0000 0177             {
; 0000 0178             date--;
	DEC  R9
; 0000 0179             };
_0x48:
; 0000 017A         while(!DOWN);
_0x49:
	SBIS 0x10,0
	RJMP _0x49
; 0000 017B         }
; 0000 017C     }
_0x46:
; 0000 017D  //================================================
; 0000 017E     if(mode==4)  //chinh thang
_0x3F:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x4C
; 0000 017F     {
; 0000 0180         //==================================
; 0000 0181     if(UP==0)
	SBIC 0x10,1
	RJMP _0x4D
; 0000 0182         {
; 0000 0183         if(month==12)
	LDI  R30,LOW(12)
	CP   R30,R8
	BRNE _0x4E
; 0000 0184             {
; 0000 0185             month=1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0186             }
; 0000 0187         else
	RJMP _0x4F
_0x4E:
; 0000 0188             {
; 0000 0189             month++;
	INC  R8
; 0000 018A             };
_0x4F:
; 0000 018B         while(!UP);                                       // bao co phim nhan
_0x50:
	SBIS 0x10,1
	RJMP _0x50
; 0000 018C         }
; 0000 018D /////////////////////////////////////////////////////////////
; 0000 018E     if(DOWN==0)
_0x4D:
	SBIC 0x10,0
	RJMP _0x53
; 0000 018F         {
; 0000 0190         if(month==1)
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x54
; 0000 0191             {
; 0000 0192             month=12;
	LDI  R30,LOW(12)
	MOV  R8,R30
; 0000 0193             }
; 0000 0194         else
	RJMP _0x55
_0x54:
; 0000 0195             {
; 0000 0196             month--;
	DEC  R8
; 0000 0197             };
_0x55:
; 0000 0198         while(!DOWN);
_0x56:
	SBIS 0x10,0
	RJMP _0x56
; 0000 0199         }
; 0000 019A     }
_0x53:
; 0000 019B     //=================================
; 0000 019C     if(mode==5) //chinh nam
_0x4C:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x59
; 0000 019D     {
; 0000 019E     if(UP==0)
	SBIC 0x10,1
	RJMP _0x5A
; 0000 019F         {
; 0000 01A0         if(year==99)
	LDI  R30,LOW(99)
	CP   R30,R11
	BRNE _0x5B
; 0000 01A1             {
; 0000 01A2             year=0;
	CLR  R11
; 0000 01A3             }
; 0000 01A4         else
	RJMP _0x5C
_0x5B:
; 0000 01A5             {
; 0000 01A6             year++;
	INC  R11
; 0000 01A7             };
_0x5C:
; 0000 01A8         while(!UP);
_0x5D:
	SBIS 0x10,1
	RJMP _0x5D
; 0000 01A9         }
; 0000 01AA ///////////////////////////////////////////////////////////////
; 0000 01AB     if(DOWN==0)
_0x5A:
	SBIC 0x10,0
	RJMP _0x60
; 0000 01AC         {
; 0000 01AD         if(year==00)
	TST  R11
	BRNE _0x61
; 0000 01AE             {
; 0000 01AF             year=99;
	LDI  R30,LOW(99)
	MOV  R11,R30
; 0000 01B0             }
; 0000 01B1         else
	RJMP _0x62
_0x61:
; 0000 01B2             {
; 0000 01B3             year--;
	DEC  R11
; 0000 01B4             };
_0x62:
; 0000 01B5         while(!DOWN);
_0x63:
	SBIS 0x10,0
	RJMP _0x63
; 0000 01B6         }
; 0000 01B7     }
_0x60:
; 0000 01B8 //====================
; 0000 01B9 if(mode==6)   //chinh phut bao thuc
_0x59:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x66
; 0000 01BA  {
; 0000 01BB    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x67
; 0000 01BC         {
; 0000 01BD         if(min_set==59)
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x3B)
	BRNE _0x68
; 0000 01BE             {
; 0000 01BF             min_set=0;
	RCALL SUBOPT_0x11
	LDI  R30,LOW(0)
	RJMP _0x8C
; 0000 01C0             }
; 0000 01C1         else
_0x68:
; 0000 01C2             {
; 0000 01C3             min_set++;
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
_0x8C:
	RCALL __EEPROMWRB
; 0000 01C4             };
; 0000 01C5         while(!UP); // doi nha phim
_0x6A:
	SBIS 0x10,1
	RJMP _0x6A
; 0000 01C6         }
; 0000 01C7    //==============
; 0000 01C8    if(DOWN==0)        // phim "DOWN" nhan
_0x67:
	SBIC 0x10,0
	RJMP _0x6D
; 0000 01C9         {
; 0000 01CA         if(min_set==0)
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x6E
; 0000 01CB             {
; 0000 01CC             min_set=59;
	RCALL SUBOPT_0x11
	LDI  R30,LOW(59)
	RJMP _0x8D
; 0000 01CD             }
; 0000 01CE         else
_0x6E:
; 0000 01CF             {
; 0000 01D0             min_set--;
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDB
	SUBI R30,LOW(1)
_0x8D:
	RCALL __EEPROMWRB
; 0000 01D1             };
; 0000 01D2         while(!DOWN);
_0x70:
	SBIS 0x10,0
	RJMP _0x70
; 0000 01D3         }
; 0000 01D4  }
_0x6D:
; 0000 01D5  //===============================
; 0000 01D6   if(mode==7)   //chinh gio bao thuc
_0x66:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x73
; 0000 01D7     {
; 0000 01D8    if(UP==0)  // phim "UP" nhan
	SBIC 0x10,1
	RJMP _0x74
; 0000 01D9         {
; 0000 01DA         if(hour_set==23)
	RCALL SUBOPT_0x12
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x17)
	BRNE _0x75
; 0000 01DB             {
; 0000 01DC             hour_set=0;
	RCALL SUBOPT_0x12
	LDI  R30,LOW(0)
	RJMP _0x8E
; 0000 01DD             }
; 0000 01DE         else
_0x75:
; 0000 01DF             {
; 0000 01E0             hour_set++;
	RCALL SUBOPT_0x12
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
_0x8E:
	RCALL __EEPROMWRB
; 0000 01E1             };
; 0000 01E2         while(!UP); // doi nha phim
_0x77:
	SBIS 0x10,1
	RJMP _0x77
; 0000 01E3         }
; 0000 01E4    //==============
; 0000 01E5    if(DOWN==0)        // phim "DOWN" nhan
_0x74:
	SBIC 0x10,0
	RJMP _0x7A
; 0000 01E6         {
; 0000 01E7         if(hour_set==0)
	RCALL SUBOPT_0x12
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x7B
; 0000 01E8             {
; 0000 01E9             hour_set=23;
	RCALL SUBOPT_0x12
	LDI  R30,LOW(23)
	RJMP _0x8F
; 0000 01EA             }
; 0000 01EB         else
_0x7B:
; 0000 01EC             {
; 0000 01ED             hour_set--;
	RCALL SUBOPT_0x12
	RCALL __EEPROMRDB
	SUBI R30,LOW(1)
_0x8F:
	RCALL __EEPROMWRB
; 0000 01EE             };
; 0000 01EF         while(!DOWN);
_0x7D:
	SBIS 0x10,0
	RJMP _0x7D
; 0000 01F0         }
; 0000 01F1     }
_0x7A:
; 0000 01F2   //===================
; 0000 01F3   if(mode==8)   //chon on/off bao thuc
_0x73:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x80
; 0000 01F4   {
; 0000 01F5 //    if(alarm==1) glcd_putimage(43,52,alarm_on,GLCD_PUTCOPY);
; 0000 01F6 //    else glcd_putimage(43,52,alarm_off,GLCD_PUTCOPY);
; 0000 01F7     if(UP==0)
	SBIC 0x10,1
	RJMP _0x81
; 0000 01F8     {
; 0000 01F9      alarm++;
	RCALL SUBOPT_0x13
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
; 0000 01FA      if(alarm==2) alarm=0;
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x2)
	BRNE _0x82
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL SUBOPT_0x14
; 0000 01FB     }
_0x82:
; 0000 01FC     if(DOWN==0)
_0x81:
	SBIC 0x10,0
	RJMP _0x83
; 0000 01FD     {
; 0000 01FE      alarm--;
	RCALL SUBOPT_0x13
	SUBI R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 01FF      if(alarm==0) alarm=1;
	RCALL SUBOPT_0x13
	CPI  R30,0
	BRNE _0x84
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 0200     }
_0x84:
; 0000 0201   }
_0x83:
; 0000 0202 
; 0000 0203 }
_0x80:
	RET
; .FEND
;
;
;void main(void)
; 0000 0207 {
_main:
; .FSTART _main
; 0000 0208 // Declare your local variables here
; 0000 0209 // Variable used to store graphic display
; 0000 020A // controller initialization data
; 0000 020B GLCDINIT_t glcd_init_data;
; 0000 020C 
; 0000 020D // Input/Output Ports initialization
; 0000 020E // Port B initialization
; 0000 020F // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0210 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(63)
	OUT  0x17,R30
; 0000 0211 // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0212 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0213 
; 0000 0214 // Port C initialization
; 0000 0215 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0216 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(2)
	OUT  0x14,R30
; 0000 0217 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=T
; 0000 0218 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0219 
; 0000 021A // Port D initialization
; 0000 021B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 021C DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 021D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 021E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 021F 
; 0000 0220 // Timer/Counter 0 initialization
; 0000 0221 // Clock source: System Clock
; 0000 0222 // Clock value: 500.000 kHz
; 0000 0223 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0224 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0225 
; 0000 0226 // Timer/Counter 1 initialization
; 0000 0227 // Clock source: System Clock
; 0000 0228 // Clock value: 500.000 kHz
; 0000 0229 // Mode: Normal top=0xFFFF
; 0000 022A // OC1A output: Disconnected
; 0000 022B // OC1B output: Disconnected
; 0000 022C // Noise Canceler: Off
; 0000 022D // Input Capture on Falling Edge
; 0000 022E // Timer Period: 0.13107 s
; 0000 022F // Timer1 Overflow Interrupt: On
; 0000 0230 // Input Capture Interrupt: Off
; 0000 0231 // Compare A Match Interrupt: Off
; 0000 0232 // Compare B Match Interrupt: Off
; 0000 0233 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0234 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0235 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0236 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0237 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0238 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0239 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 023A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 023B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 023C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 023D 
; 0000 023E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 023F TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0240 
; 0000 0241 // External Interrupt(s) initialization
; 0000 0242 // INT0: On
; 0000 0243 // INT0 Mode: Falling Edge
; 0000 0244 // INT1: On
; 0000 0245 // INT1 Mode: Falling Edge
; 0000 0246 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0247 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0248 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0249 
; 0000 024A 
; 0000 024B // Bit-Banged I2C Bus initialization
; 0000 024C // I2C Port: PORTC
; 0000 024D // I2C SDA bit: 4
; 0000 024E // I2C SCL bit: 5
; 0000 024F // Bit Rate: 100 kHz
; 0000 0250 // Note: I2C settings are specified in the
; 0000 0251 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0252 i2c_init();
	RCALL _i2c_init
; 0000 0253 
; 0000 0254 // DS1307 Real Time Clock initialization
; 0000 0255 // Square wave output on pin SQW/OUT: Off
; 0000 0256 // SQW/OUT pin state: 0
; 0000 0257 rtc_init(0,0,0);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0258 
; 0000 0259 // 1 Wire Bus initialization
; 0000 025A // 1 Wire Data port: PORTC
; 0000 025B // 1 Wire Data bit: 2
; 0000 025C // Note: 1 Wire port settings are specified in the
; 0000 025D // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 025E w1_init();
	RCALL _w1_init
; 0000 025F 
; 0000 0260 // Graphic Display Controller initialization
; 0000 0261 // The ST7920 connections are specified in the
; 0000 0262 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0263 // E - PORTD Bit 7
; 0000 0264 // R /W - PORTD Bit 6
; 0000 0265 // RS - PORTD Bit 5
; 0000 0266 // /RST - PORTB Bit 4
; 0000 0267 // DB4 - PORTB Bit 0
; 0000 0268 // DB5 - PORTB Bit 1
; 0000 0269 // DB6 - PORTB Bit 2
; 0000 026A // DB7 - PORTB Bit 3
; 0000 026B 
; 0000 026C // Specify the current font for displaying text
; 0000 026D glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 026E // No function is used for reading
; 0000 026F // image data from external memory
; 0000 0270 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0271 // No function is used for writing
; 0000 0272 // image data to external memory
; 0000 0273 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0274 
; 0000 0275 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0276 
; 0000 0277 // Global enable interrupts
; 0000 0278 
; 0000 0279 #asm("sei")
	sei
; 0000 027A //glcd_rectangle(0,0,127,63);
; 0000 027B glcd_line(5,17,122,17);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(122)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RCALL _glcd_line
; 0000 027C glcd_line(5,47,122,47);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(47)
	ST   -Y,R30
	LDI  R30,LOW(122)
	ST   -Y,R30
	LDI  R26,LOW(47)
	RCALL _glcd_line
; 0000 027D if(alarm==255)
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0xFF)
	BRNE _0x85
; 0000 027E {
; 0000 027F   alarm=0;
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL SUBOPT_0x14
; 0000 0280   min_set=0;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x14
; 0000 0281   hour_set=0;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x14
; 0000 0282 }
; 0000 0283 ds18b20_init(T,0,0,DS18B20_10BIT_RES);
_0x85:
	LDS  R30,_T
	LDS  R31,_T+1
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	LDI  R26,LOW(1)
	RCALL _ds18b20_init
; 0000 0284 while (1)
_0x86:
; 0000 0285       {
; 0000 0286         timeDisplay(42,20);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(20)
	RCALL _timeDisplay
; 0000 0287         dateDisplay(31,37);
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R26,LOW(37)
	RCALL _dateDisplay
; 0000 0288         alarmDisplay(43,52);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(52)
	RCALL _alarmDisplay
; 0000 0289         if(mode==0)
	TST  R10
	BRNE _0x89
; 0000 028A         {
; 0000 028B         getTime();
	RCALL _getTime
; 0000 028C         tempDisplay(70,2);
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _tempDisplay
; 0000 028D         }
; 0000 028E         else
	RJMP _0x8A
_0x89:
; 0000 028F         {
; 0000 0290           timer0_init();
	RCALL _timer0_init
; 0000 0291           setting();
	RCALL _setting
; 0000 0292         }
_0x8A:
; 0000 0293 
; 0000 0294       }
	RJMP _0x86
; 0000 0295 }
_0x8B:
	RJMP _0x8B
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	RCALL SUBOPT_0x16
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	RCALL SUBOPT_0x17
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	RCALL SUBOPT_0x18
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x19
	RJMP _0x2180002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	RCALL SUBOPT_0x18
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	RJMP _0x2180009
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	RCALL SUBOPT_0x18
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x19
	RJMP _0x2180002
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x18
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x1C
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x22
	ST   X,R30
	RCALL _i2c_stop
	RJMP _0x2180007
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	RCALL SUBOPT_0x18
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x19
	RJMP _0x2180001
; .FEND

	.CSEG
_ds18b20_select:
; .FSTART _ds18b20_select
	RCALL SUBOPT_0x23
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x2020003
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2180002
_0x2020003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2020004
	LDI  R26,LOW(85)
	RCALL _w1_write
	LDI  R17,LOW(0)
_0x2020006:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	MOV  R26,R30
	RCALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2020006
	RJMP _0x2020008
_0x2020004:
	LDI  R26,LOW(204)
	RCALL _w1_write
_0x2020008:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_ds18b20_read_spd:
; .FSTART _ds18b20_read_spd
	RCALL SUBOPT_0x21
	RCALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x26
	BRNE _0x2020009
	LDI  R30,LOW(0)
	RCALL __LOADLOCR4
	RJMP _0x2180009
_0x2020009:
	LDI  R26,LOW(190)
	RCALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x202000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x202000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	RCALL SUBOPT_0x27
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
	RCALL __LOADLOCR4
	RJMP _0x2180009
; .FEND
_ds18b20_temperature:
; .FSTART _ds18b20_temperature
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000D
	RCALL SUBOPT_0x28
	RJMP _0x2180002
_0x202000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x26
	BRNE _0x202000E
	RCALL SUBOPT_0x28
	RJMP _0x2180002
_0x202000E:
	LDI  R26,LOW(68)
	RCALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G101*2)
	LDI  R27,HIGH(_conv_delay_G101*2)
	RCALL SUBOPT_0x29
	RCALL __GETW2PF
	RCALL _delay_ms
	RCALL SUBOPT_0x24
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000F
	RCALL SUBOPT_0x28
	RJMP _0x2180002
_0x202000F:
	RCALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G101*2)
	LDI  R27,HIGH(_bit_mask_G101*2)
	RCALL SUBOPT_0x29
	RCALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_ds18b20_init:
; .FSTART _ds18b20_init
	ST   -Y,R26
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x26
	BRNE _0x2020010
	LDI  R30,LOW(0)
	RJMP _0x2180004
_0x2020010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R26,LOW(78)
	RCALL _w1_write
	LDD  R26,Y+1
	RCALL _w1_write
	LDD  R26,Y+2
	RCALL _w1_write
	LD   R26,Y
	RCALL _w1_write
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2020011
	LDI  R30,LOW(0)
	RJMP _0x2180004
_0x2020011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2020012
_0x2020013:
	LDI  R30,LOW(0)
	RJMP _0x2180004
_0x2020012:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x26
	BRNE _0x2020015
	LDI  R30,LOW(0)
	RJMP _0x2180004
_0x2020015:
	LDI  R26,LOW(72)
	RCALL _w1_write
	LDI  R26,LOW(15)
	RCALL SUBOPT_0x2A
	RCALL _w1_init
	RJMP _0x2180004
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
_st7920_delay_G102:
; .FSTART _st7920_delay_G102
    nop
    nop
    nop
	RET
; .FEND
_st7920_wrbus_G102:
; .FSTART _st7920_wrbus_G102
	ST   -Y,R26
	CBI  0x12,6
	SBI  0x12,7
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	RCALL SUBOPT_0x2B
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x18,R30
	RCALL _st7920_delay_G102
	CBI  0x12,7
	RCALL SUBOPT_0x2B
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0x2C
	CBI  0x12,7
	RJMP _0x218000A
; .FEND
_st7920_rdbus_G102:
; .FSTART _st7920_rdbus_G102
	ST   -Y,R17
	RCALL SUBOPT_0x2D
	SBI  0x12,7
	RCALL _st7920_delay_G102
	IN   R30,0x16
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0x2C
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	OR   R17,R30
	CBI  0x12,7
	MOV  R30,R17
	RJMP _0x218000B
; .FEND
_st7920_busy_G102:
; .FSTART _st7920_busy_G102
	ST   -Y,R17
	CBI  0x12,5
	RCALL SUBOPT_0x2D
_0x2040004:
	SBI  0x12,7
	RCALL _st7920_delay_G102
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	LDI  R26,LOW(0)
	RCALL __NEB12
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0x2C
	CBI  0x12,7
	RCALL _st7920_delay_G102
	CPI  R17,0
	BRNE _0x2040004
	__DELAY_USB 1
_0x218000B:
	LD   R17,Y+
	RET
; .FEND
_st7920_wrdata:
; .FSTART _st7920_wrdata
	ST   -Y,R26
	RCALL _st7920_busy_G102
	SBI  0x12,5
	LD   R26,Y
	RCALL _st7920_wrbus_G102
	RJMP _0x218000A
; .FEND
_st7920_rddata:
; .FSTART _st7920_rddata
	RCALL _st7920_busy_G102
	SBI  0x12,5
	RCALL _st7920_rdbus_G102
	RET
; .FEND
_st7920_wrcmd:
; .FSTART _st7920_wrcmd
	ST   -Y,R26
	RCALL _st7920_busy_G102
	LD   R26,Y
	RCALL _st7920_wrbus_G102
	RJMP _0x218000A
; .FEND
_st7920_setxy_G102:
; .FSTART _st7920_setxy_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	RCALL SUBOPT_0x2E
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x2040006
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
_0x2040006:
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x80
	RCALL SUBOPT_0x2E
	RJMP _0x2180003
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x17
	BREQ _0x2040007
	LDI  R30,LOW(12)
	RJMP _0x2040008
_0x2040007:
	LDI  R30,LOW(8)
_0x2040008:
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x17
	BREQ _0x204000A
	LDI  R30,LOW(2)
	RJMP _0x204000B
_0x204000A:
	LDI  R30,LOW(0)
_0x204000B:
	STS  _st7920_graphics_on_G102,R30
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
_0x218000A:
	ADIW R28,1
	RET
; .FEND
_glcd_cleargraphics:
; .FSTART _glcd_cleargraphics
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x204000D
	LDI  R19,LOW(255)
_0x204000D:
	RCALL SUBOPT_0x30
	LDI  R16,LOW(0)
_0x204000E:
	CPI  R16,64
	BRSH _0x2040010
	RCALL SUBOPT_0x15
	MOV  R26,R16
	SUBI R16,-1
	RCALL _st7920_setxy_G102
	LDI  R17,LOW(16)
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	MOV  R26,R19
	RCALL _st7920_wrdata
	__DELAY_USB 1
	RJMP _0x2040011
_0x2040013:
	RJMP _0x204000E
_0x2040010:
	RCALL SUBOPT_0x15
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2180001
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x23
	SBI  0x11,7
	CBI  0x12,7
	SBI  0x11,6
	SBI  0x12,6
	SBI  0x11,5
	CBI  0x12,5
	SBI  0x17,4
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x2A
	CBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2A
	SBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2A
	CBI  0x12,6
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	LDI  R17,LOW(0)
_0x2040015:
	CPI  R17,6
	BRSH _0x2040016
	SBI  0x12,7
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_st7920_init_4bit_G102*2)
	SBCI R31,HIGH(-_st7920_init_4bit_G102*2)
	LPM  R30,Z
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 7
	CBI  0x12,7
	RCALL SUBOPT_0x31
	SUBI R17,-1
	RJMP _0x2040015
_0x2040016:
	LDI  R26,LOW(8)
	RCALL _st7920_wrbus_G102
	RCALL SUBOPT_0x31
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(15)
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	STS  _yt_G102,R30
	STS  _xt_G102,R30
	LDI  R26,LOW(6)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(36)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(64)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(2)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _st7920_graphics_on_G102,R30
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
	BREQ _0x2040017
	RCALL SUBOPT_0x24
	RCALL __GETW1P
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x24
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x24
	ADIW R26,4
	RCALL __GETW1P
	RJMP _0x20400A6
_0x2040017:
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
_0x20400A6:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x6
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_st7920_rdbyte_G102:
; .FSTART _st7920_rdbyte_G102
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _st7920_setxy_G102
	RCALL _st7920_rddata
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x2040019
	RCALL _st7920_rddata
	STS  _st7920_bits8_15_G102,R30
_0x2040019:
	RCALL _st7920_rddata
	RJMP _0x2180003
; .FEND
_st7920_wrbyte_G102:
; .FSTART _st7920_wrbyte_G102
	RCALL SUBOPT_0x16
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _st7920_setxy_G102
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x204001A
	LDS  R26,_st7920_bits8_15_G102
	RCALL _st7920_wrdata
_0x204001A:
	LD   R26,Y
	RCALL _st7920_wrdata
	RJMP _0x2180002
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x204001C
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x204001B
_0x204001C:
	RCALL __LOADLOCR2
	RJMP _0x2180004
_0x204001B:
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x35
	LDD  R26,Y+4
	RCALL _st7920_rdbyte_G102
	MOV  R17,R30
	LDD  R30,Y+4
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(7)
	RCALL __SWAPB12
	SUB  R30,R26
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x204001E
	OR   R17,R16
	RJMP _0x204001F
_0x204001E:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x204001F:
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x35
	MOV  R26,R17
	RCALL _st7920_wrbyte_G102
	RCALL __LOADLOCR2
	RJMP _0x2180004
; .FEND
_st7920_wrmasked_G102:
; .FSTART _st7920_wrmasked_G102
	ST   -Y,R26
	ST   -Y,R17
	RCALL SUBOPT_0x30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL SUBOPT_0x36
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x204002A
	CPI  R30,LOW(0x8)
	BRNE _0x204002B
_0x204002A:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x204002C
_0x204002B:
	CPI  R30,LOW(0x3)
	BRNE _0x204002E
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x204002F
_0x204002E:
	CPI  R30,0
	BRNE _0x2040030
_0x204002F:
	RJMP _0x2040031
_0x2040030:
	CPI  R30,LOW(0x9)
	BRNE _0x2040032
_0x2040031:
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0xA)
	BRNE _0x2040034
_0x2040033:
_0x204002C:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040035
_0x2040034:
	CPI  R30,LOW(0x2)
	BRNE _0x2040036
_0x2040035:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2040028
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040037
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2040028
_0x2040037:
	CPI  R30,LOW(0x4)
	BRNE _0x2040028
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2040028:
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	MOV  R26,R17
	RCALL _glcd_revbits
	MOV  R26,R30
	RCALL _st7920_wrbyte_G102
	LDD  R17,Y+0
_0x2180009:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,7
	RCALL __SAVELOCR6
	LDD  R26,Y+20
	CPI  R26,LOW(0x80)
	BRSH _0x204003A
	LDD  R26,Y+19
	CPI  R26,LOW(0x40)
	BRSH _0x204003A
	LDD  R26,Y+18
	CPI  R26,LOW(0x0)
	BREQ _0x204003A
	LDD  R26,Y+17
	CPI  R26,LOW(0x0)
	BRNE _0x2040039
_0x204003A:
	RJMP _0x2180005
_0x2040039:
	LDD  R30,Y+18
	RCALL SUBOPT_0x37
	MOV  R18,R30
	__PUTBSR 18,8
	LDD  R30,Y+18
	ANDI R30,LOW(0x7)
	STD  Y+11,R30
	CPI  R30,0
	BREQ _0x204003C
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
_0x204003C:
	LDD  R16,Y+18
	LDD  R26,Y+20
	CLR  R27
	LDD  R30,Y+18
	RCALL SUBOPT_0x38
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x204003D
	LDD  R26,Y+20
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+18,R30
_0x204003D:
	LDD  R30,Y+17
	STD  Y+10,R30
	LDD  R26,Y+19
	CLR  R27
	LDD  R30,Y+17
	RCALL SUBOPT_0x38
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x204003E
	LDD  R26,Y+19
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+17,R30
_0x204003E:
	LDD  R30,Y+13
	CPI  R30,LOW(0x6)
	BREQ PC+2
	RJMP _0x2040042
	LDD  R30,Y+16
	CPI  R30,LOW(0x1)
	BRNE _0x2040046
	RJMP _0x2180005
_0x2040046:
	CPI  R30,LOW(0x3)
	BRNE _0x2040049
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040048
	RJMP _0x2180005
_0x2040048:
_0x2040049:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x204004B
	LDD  R26,Y+18
	CP   R16,R26
	BREQ _0x204004A
_0x204004B:
	MOV  R30,R18
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL SUBOPT_0x39
	LDD  R17,Y+17
_0x204004D:
	CPI  R17,0
	BREQ _0x204004F
	MOV  R19,R18
_0x2040050:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2040052
	RCALL SUBOPT_0x3A
	RJMP _0x2040050
_0x2040052:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x39
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004F:
_0x204004A:
	LDD  R18,Y+17
	LDD  R30,Y+10
	CP   R30,R18
	BREQ _0x2040053
	MOV  R26,R18
	CLR  R27
	LDD  R30,Y+8
	RCALL SUBOPT_0x3B
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL SUBOPT_0x3C
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040054:
	PUSH R18
	SUBI R18,-1
	LDD  R30,Y+10
	POP  R26
	CP   R26,R30
	BRSH _0x2040056
	LDI  R19,LOW(0)
_0x2040057:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2040059
	RCALL SUBOPT_0x3A
	RJMP _0x2040057
_0x2040059:
	RJMP _0x2040054
_0x2040056:
_0x2040053:
	RJMP _0x2040041
_0x2040042:
	CPI  R30,LOW(0x9)
	BRNE _0x204005A
	LDI  R30,LOW(0)
	RJMP _0x20400A7
_0x204005A:
	CPI  R30,LOW(0xA)
	BRNE _0x2040041
	LDI  R30,LOW(255)
_0x20400A7:
	STD  Y+10,R30
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _glcd_mappixcolor1bit
	STD  Y+10,R30
_0x2040041:
	LDD  R30,Y+20
	ANDI R30,LOW(0x7)
	MOV  R19,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	MOV  R21,R18
	LDD  R26,Y+18
	CP   R18,R26
	BRLO _0x204005E
	LDD  R21,Y+18
	RJMP _0x204005F
_0x204005E:
	CPI  R19,0
	BREQ _0x2040060
	MOV  R20,R19
	LDD  R26,Y+18
	CPI  R26,LOW(0x9)
	BRSH _0x2040061
	LDD  R30,Y+18
	SUB  R30,R18
	MOV  R20,R30
_0x2040061:
	MOV  R30,R20
	RCALL SUBOPT_0x3D
	LPM  R20,Z
_0x2040060:
_0x204005F:
	ST   -Y,R19
	MOV  R26,R21
	RCALL _glcd_getmask
	MOV  R21,R30
	LDD  R26,Y+11
	CP   R18,R26
	BRSH _0x2040062
	LDD  R30,Y+11
	SUB  R30,R18
	STD  Y+11,R30
_0x2040062:
	LDD  R30,Y+11
	RCALL SUBOPT_0x3D
	LPM  R0,Z
	STD  Y+12,R0
	RCALL SUBOPT_0x30
_0x2040063:
	LDD  R30,Y+17
	SUBI R30,LOW(1)
	STD  Y+17,R30
	SUBI R30,-LOW(1)
	BRNE PC+2
	RJMP _0x2040065
	LDI  R17,LOW(0)
	LDD  R16,Y+20
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2040066
	__PUTBSR 20,11
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2040067
_0x2040068:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x204006A
	ST   -Y,R16
	LDD  R26,Y+20
	RCALL SUBOPT_0x36
	AND  R30,R21
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	STD  Y+9,R30
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
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
	BRSH _0x204006C
	MOV  R30,R16
	RCALL SUBOPT_0x37
	CPI  R30,LOW(0xF)
	BRLO _0x204006B
_0x204006C:
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x6
	LDD  R26,Y+12
	RCALL _glcd_writemem
	RJMP _0x204006A
_0x204006B:
	RCALL SUBOPT_0x41
	BRSH _0x204006E
	LDD  R30,Y+12
	STD  Y+11,R30
_0x204006E:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R26,Y+20
	RCALL SUBOPT_0x36
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
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x6
	LDD  R26,Y+13
	RCALL _glcd_writemem
	SUBI R17,-LOW(8)
	RJMP _0x2040068
_0x204006A:
	RJMP _0x204006F
_0x2040067:
_0x2040070:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2040072
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2040077
	CPI  R30,LOW(0xA)
	BRNE _0x2040079
_0x2040077:
	RJMP _0x2040075
_0x2040079:
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x42
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RCALL _glcd_readmem
	STD  Y+10,R30
_0x2040075:
	RCALL SUBOPT_0x43
	MOV  R30,R19
	LDD  R26,Y+12
	RCALL __LSLB12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R26,Y+17
	RCALL _st7920_wrmasked_G102
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x2040072
	MOV  R30,R16
	RCALL SUBOPT_0x37
	CPI  R30,LOW(0xF)
	BRSH _0x2040072
	RCALL SUBOPT_0x41
	BRSH _0x204007C
	LDD  R30,Y+12
	STD  Y+11,R30
_0x204007C:
	SUBI R16,-LOW(8)
	RCALL SUBOPT_0x43
	MOV  R30,R18
	LDD  R26,Y+12
	RCALL __LSRB12
	RCALL SUBOPT_0x44
	SUBI R17,-LOW(8)
	RJMP _0x2040070
_0x2040072:
_0x204006F:
	RJMP _0x204007D
_0x2040066:
	__PUTBSR 21,11
_0x204007E:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2040080
	RCALL SUBOPT_0x41
	BRSH _0x2040081
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2040081:
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2040086
	CPI  R30,LOW(0xA)
	BRNE _0x2040088
_0x2040086:
	RJMP _0x2040084
_0x2040088:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x204008A
	LDD  R26,Y+11
	CPI  R26,LOW(0xFF)
	BREQ _0x2040089
_0x204008A:
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	STD  Y+10,R30
_0x2040089:
_0x2040084:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x204008C
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x6
	ST   -Y,R16
	LDD  R26,Y+23
	RCALL SUBOPT_0x36
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
	RJMP _0x204008D
_0x204008C:
	RCALL SUBOPT_0x43
	LDD  R30,Y+12
	RCALL SUBOPT_0x44
_0x204008D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SUBI R16,-LOW(8)
	SUBI R17,-LOW(8)
	RJMP _0x204007E
_0x2040080:
_0x204007D:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+8
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	RCALL SUBOPT_0x3C
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x2040063
_0x2040065:
	RJMP _0x2180005
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRLO _0x2040090
	LDI  R30,LOW(15)
	STD  Y+4,R30
_0x2040090:
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRLO _0x2040091
	LDI  R30,LOW(3)
	STD  Y+3,R30
_0x2040091:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G102*2)
	SBCI R31,HIGH(-_st7920_base_y_G102*2)
	LPM  R26,Z
	LDD  R30,Y+4
	LSR  R30
	OR   R30,R26
	MOV  R17,R30
	RCALL SUBOPT_0x2F
	MOV  R26,R17
	RCALL _st7920_wrcmd
	RCALL _st7920_rddata
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2040092
	RCALL _st7920_rddata
	MOV  R16,R30
_0x2040092:
	MOV  R26,R17
	RCALL _st7920_wrcmd
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2040093
	MOV  R26,R16
	RCALL _st7920_wrdata
_0x2040093:
	LDD  R26,Y+2
	RCALL _st7920_wrdata
	RCALL __LOADLOCR2
	RJMP _0x2180004
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	RCALL __CPW02
	BRLT _0x2060003
	RCALL SUBOPT_0x34
	RJMP _0x2180003
_0x2060003:
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2180003
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	RCALL __CPW02
	BRLT _0x2060005
	RCALL SUBOPT_0x34
	RJMP _0x2180003
_0x2060005:
	RCALL SUBOPT_0x22
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2060006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2180003
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180003
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	RCALL SUBOPT_0x21
	SBIW R28,3
	RCALL SUBOPT_0x45
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	RCALL SUBOPT_0x34
	RJMP _0x2180008
_0x206000B:
	RCALL SUBOPT_0x46
	STD  Y+7,R0
	RCALL SUBOPT_0x46
	STD  Y+6,R0
	RCALL SUBOPT_0x46
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	RCALL SUBOPT_0x34
	RJMP _0x2180008
_0x206000C:
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
	BRLO _0x206000D
	RCALL SUBOPT_0x34
	RJMP _0x2180008
_0x206000D:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000E
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	RCALL SUBOPT_0x37
	MOV  R20,R30
	LDD  R30,Y+7
	ANDI R30,LOW(0x7)
	BREQ _0x206000F
	SUBI R20,-LOW(1)
_0x206000F:
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+6
	RCALL SUBOPT_0x3B
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x3B
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2180008
_0x206000E:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	LPM  R30,Z
	RCALL SUBOPT_0x37
	MOV  R20,R30
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	ANDI R30,LOW(0x7)
	BREQ _0x2060013
	SUBI R20,-LOW(1)
_0x2060013:
	LDD  R26,Y+6
	CLR  R27
	MOV  R30,R20
	RCALL SUBOPT_0x3B
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	RCALL SUBOPT_0x47
	ST   X,R30
	MOVW R30,R16
_0x2180008:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x48
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x38
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x4A
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x45
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2060020
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060021
	RJMP _0x2060022
_0x2060021:
	RCALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060023
	RJMP _0x2180006
_0x2060023:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	RCALL SUBOPT_0x3C
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2060024
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060024:
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x49
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	RCALL SUBOPT_0x4B
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x4C
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x49
	ST   -Y,R30
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x27
	RCALL _glcd_block
	RCALL SUBOPT_0x4B
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x49
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x27
	RCALL _glcd_block
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060025
_0x2060022:
	RCALL _glcd_new_line_G103
	RJMP _0x2180006
_0x2060025:
	RJMP _0x2060026
_0x2060020:
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BREQ _0x2060028
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x37
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
	RCALL SUBOPT_0x48
	LDI  R26,LOW(16)
	MUL  R18,R26
	MOVW R30,R0
	__PUTB1MN _glcd_state,3
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x27
	RCALL _glcd_block
	RCALL SUBOPT_0x4B
	LDI  R31,0
	ADIW R30,8
	MOVW R16,R30
	__CPWRN 16,17,128
	BRLO _0x2060029
_0x2060028:
	__GETWRN 16,17,0
	__GETB1MN _glcd_state,3
	LDI  R31,0
	ADIW R30,16
	MOVW R26,R30
	RCALL SUBOPT_0x4A
_0x2060029:
_0x2060026:
	__PUTBMRN _glcd_state,2,16
_0x2180006:
	RCALL __LOADLOCR6
_0x2180007:
	ADIW R28,8
	RET
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	RCALL SUBOPT_0x16
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x2180002
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x35
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x206002A:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206002C
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x206002A
_0x206002C:
	LDD  R17,Y+0
	RJMP _0x2180004
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	RCALL SUBOPT_0x23
_0x2060033:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060035
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2060033
_0x2060035:
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_glcd_putpixelm_G103:
; .FSTART _glcd_putpixelm_G103
	RCALL SUBOPT_0x16
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x2060043
	LDS  R30,_glcd_state
	RJMP _0x2060044
_0x2060043:
	__GETB1MN _glcd_state,1
_0x2060044:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	RCALL SUBOPT_0x17
	BRNE _0x2060046
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2060046:
	LD   R30,Y
	RJMP _0x2180002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	RCALL SUBOPT_0x48
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0x4A
	RJMP _0x2180003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	RCALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	RCALL SUBOPT_0x48
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2060047
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2060048
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	RJMP _0x2180005
_0x2060048:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2060049
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x206004A
_0x2060049:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x206004A:
_0x206004C:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x206004E:
	RCALL SUBOPT_0x4D
	BRSH _0x2060050
	RCALL SUBOPT_0x4E
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x206004E
_0x2060050:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x206004C
	RJMP _0x2060051
_0x2060047:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2060052
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x2060053
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2060120
_0x2060053:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x2060120:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2060056:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060058:
	RCALL SUBOPT_0x4D
	BRSH _0x206005A
	ST   -Y,R17
	INC  R17
	ST   -Y,R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x2060058
_0x206005A:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2060056
	RJMP _0x206005B
_0x2060052:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x206005C:
	RCALL SUBOPT_0x4D
	BRLO PC+2
	RJMP _0x206005E
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x206005F
	LDI  R16,LOW(255)
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
_0x206005F:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x2060060
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2060060:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	RCALL SUBOPT_0x4E
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x2060061
_0x2060063:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x47
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2060065
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	RCALL SUBOPT_0x50
_0x2060065:
	RCALL SUBOPT_0x4E
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x2060063
	RJMP _0x2060066
_0x2060061:
_0x2060068:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RCALL SUBOPT_0x4F
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x47
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x206006A
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x50
_0x206006A:
	RCALL SUBOPT_0x4E
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2060068
_0x2060066:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x206005C
_0x206005E:
_0x206005B:
_0x2060051:
_0x2180005:
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
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
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x21
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
_0x2180004:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x3D
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2180003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2120007
	CPI  R30,LOW(0xA)
	BRNE _0x2120008
_0x2120007:
	LDS  R17,_glcd_state
	RJMP _0x2120009
_0x2120008:
	CPI  R30,LOW(0x9)
	BRNE _0x212000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2120009
_0x212000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2120005
	__GETBRMN 17,_glcd_state,16
_0x2120009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x212000E
	CPI  R17,0
	BREQ _0x212000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2180002
_0x212000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2180002
_0x212000E:
	CPI  R17,0
	BRNE _0x2120011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2180002
_0x2120011:
_0x2120005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x21
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2120015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2180002
_0x2120015:
	CPI  R30,LOW(0x2)
	BRNE _0x2120016
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDB
	RJMP _0x2180002
_0x2120016:
	CPI  R30,LOW(0x3)
	BRNE _0x2120018
	RCALL SUBOPT_0x22
	__CALL1MN _glcd_state,25
	RJMP _0x2180002
_0x2120018:
	RCALL SUBOPT_0x22
	LD   R30,X
_0x2180002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x212001C
	LD   R30,Y
	RCALL SUBOPT_0x24
	ST   X,R30
	RJMP _0x212001B
_0x212001C:
	CPI  R30,LOW(0x2)
	BRNE _0x212001D
	LD   R30,Y
	RCALL SUBOPT_0x24
	RCALL __EEPROMWRB
	RJMP _0x212001B
_0x212001D:
	CPI  R30,LOW(0x3)
	BRNE _0x212001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x6
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x212001B:
_0x2180001:
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

	.DSEG

	.CSEG

	.CSEG

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_glcd_state:
	.BYTE 0x1D
_T:
	.BYTE 0x2

	.ESEG
_min_set:
	.BYTE 0x1
_hour_set:
	.BYTE 0x1
_alarm:
	.BYTE 0x1

	.DSEG
_st7920_graphics_on_G102:
	.BYTE 0x1
_st7920_bits8_15_G102:
	.BYTE 0x1
_xt_G102:
	.BYTE 0x1
_yt_G102:
	.BYTE 0x1
__seed_G10A:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R30,Y+7
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x3:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOVW R26,R30
	RCALL SUBOPT_0x4
	RCALL __MODW21U
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_fontNumber*2)
	LDI  R31,HIGH(_fontNumber*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	LDI  R27,0
	RCALL SUBOPT_0x4
	RCALL __DIVW21
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	CLR  R27
	RCALL SUBOPT_0x4
	RCALL __MODW21
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xA:
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
SUBOPT_0xB:
	LDI  R30,LOW(_fontNumber*2)
	LDI  R31,HIGH(_fontNumber*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R30,Y+1
	SUBI R30,-LOW(10)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_hour_set)
	LDI  R27,HIGH(_hour_set)
	RCALL __EEPROMRDB
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_min_set)
	LDI  R27,HIGH(_min_set)
	RCALL __EEPROMRDB
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_min_set)
	LDI  R27,HIGH(_min_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_hour_set)
	LDI  R27,HIGH(_hour_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R26
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LD   R30,Y
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x21
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x24:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL _ds18b20_select
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x6
	LDI  R26,LOW(9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	__GETD1N 0xC61C3C00
	LDD  R17,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	RCALL _st7920_delay_G102
	SBI  0x12,7
	RJMP _st7920_delay_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	SBI  0x12,6
	IN   R30,0x17
	ANDI R30,LOW(0xF0)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2E:
	MOV  R26,R30
	RJMP _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDS  R30,_st7920_graphics_on_G102
	ORI  R30,0x20
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x30:
	LDS  R30,_st7920_graphics_on_G102
	ORI  R30,LOW(0x24)
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R30,Y+4
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	RCALL _st7920_rdbyte_G102
	MOV  R26,R30
	RJMP _glcd_revbits

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x37:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3A:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x6
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+16
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x40
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x43:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x44:
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R26,Y+17
	RJMP _st7920_wrmasked_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x46:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	__PUTB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x49:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4A:
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__GETB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4D:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	ST   -Y,R17
	ST   -Y,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x3C
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
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
	ldi  r22,7
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,13
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
	__DELAY_USW 0x3E8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x02

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x1E0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x13
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0x65
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x186
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xF
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0x6B
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x11
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0x64
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x7
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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
