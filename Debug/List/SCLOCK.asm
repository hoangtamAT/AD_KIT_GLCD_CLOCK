
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 1.000000 MHz
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
	.DEF _index=R10
	.DEF _No_date=R13

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
	RJMP 0x00
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
	.DB  0x8,0xD,0x2F,0xC,0x0,0x40,0x40,0x20
	.DB  0x20,0x10,0x10,0x8,0x8,0x4,0x4,0x2
	.DB  0x2,0x0,0x7F,0x7F,0x63,0x63,0x63,0x63
	.DB  0x63,0x63,0x63,0x63,0x7F,0x7F,0x0,0x1C
	.DB  0x1C,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0x18,0x18,0x18,0x0,0x7F,0x7F,0x60,0x60
	.DB  0x60,0x7F,0x7F,0x3,0x3,0x3,0x7F,0x7F
	.DB  0x0,0x7F,0x7F,0x60,0x60,0x60,0x7F,0x7F
	.DB  0x60,0x60,0x60,0x7F,0x7F,0x0,0x63,0x63
	.DB  0x63,0x63,0x63,0x7F,0x7F,0x60,0x60,0x60
	.DB  0x60,0x60,0x0,0x7F,0x7F,0x3,0x3,0x3
	.DB  0x7F,0x7F,0x60,0x60,0x60,0x7F,0x7F,0x0
	.DB  0x7F,0x7F,0x3,0x3,0x3,0x7F,0x7F,0x63
	.DB  0x63,0x63,0x7F,0x7F,0x0,0x7F,0x7F,0x60
	.DB  0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60
	.DB  0x60,0x0,0x7F,0x7F,0x63,0x63,0x63,0x7F
	.DB  0x7F,0x63,0x63,0x63,0x7F,0x7F,0x0,0x7F
	.DB  0x7F,0x63,0x63,0x63,0x7F,0x7F,0x60,0x60
	.DB  0x60,0x7F,0x7F,0x0,0x0,0x0,0x0,0x18
	.DB  0x18,0x0,0x0,0x18,0x18,0x0,0x0,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G100:
	.DB  0x3,0x3,0x2,0x0,0x2,0x0
_st7920_base_y_G100:
	.DB  0x80,0x90,0x88,0x98
_tbl10_G106:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G106:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x54,0x3A,0x25,0x32,0x2E,0x30,0x66,0x0
	.DB  0x6F,0x0,0x43,0x0,0x48,0x3A,0x25,0x32
	.DB  0x2E,0x30,0x66,0x0,0x25,0x0,0x3A,0x0
	.DB  0x2F,0x0
_0x2180060:
	.DB  0x1
_0x2180000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _0x3
	.DW  _0x0*2+22

	.DW  0x02
	.DW  _0x3+2
	.DW  _0x0*2+22

	.DW  0x02
	.DW  _0x4
	.DW  _0x0*2+24

	.DW  0x02
	.DW  _0x4+2
	.DW  _0x0*2+24

	.DW  0x01
	.DW  __seed_G10C
	.DW  _0x2180060*2

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
;Date    : 10/19/2017
;Author  :
;Company :
;Comments:
;
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
;#include <glcd.h>
;#include <font5x7.h>
;#include <ds1307.h>
;#include <DHT.h>
;#include <fontnumber8x13.h>
;#include <stdio.h>
;char hour,minn,sec,day,date,month,year,index,No_date;
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0023 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 0024 // Place your code here
; 0000 0025 
; 0000 0026 }
	RETI
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 002A {
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 002B // Place your code here
; 0000 002C 
; 0000 002D }
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0031 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
; 0000 0032 // Place your code here
; 0000 0033 
; 0000 0034 }
	RETI
; .FEND
;void tempDisplay(unsigned char x, unsigned char y)
; 0000 0036 {
_tempDisplay:
; .FSTART _tempDisplay
; 0000 0037   float temp,humi;
; 0000 0038   char lcdBuff[30];
; 0000 0039   #asm("cli");
	ST   -Y,R26
	SBIW R28,38
;	x -> Y+39
;	y -> Y+38
;	temp -> Y+34
;	humi -> Y+30
;	lcdBuff -> Y+0
	cli
; 0000 003A   temp=DHT_GetTemHumi(DHT_ND);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x0
	__PUTD1S 34
; 0000 003B   humi=DHT_GetTemHumi(DHT_DA);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x0
	__PUTD1S 30
; 0000 003C   #asm("sei");
	sei
; 0000 003D   sprintf(lcdBuff,"T:%2.0f",temp);
	RCALL SUBOPT_0x1
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x2
	__GETD1S 38
	RCALL SUBOPT_0x3
; 0000 003E   glcd_setfont(font5x7);
; 0000 003F   glcd_outtextxy(x,y+3,lcdBuff);
	SUBI R30,-LOW(3)
	RCALL SUBOPT_0x4
; 0000 0040   glcd_outtextxyf(x+25,y,"o");
	ST   -Y,R30
	__POINTW2FN _0x0,8
	RCALL _glcd_outtextxyf
; 0000 0041   glcd_outtextxyf(x+32,y+3,"C");
	LDD  R30,Y+39
	SUBI R30,-LOW(32)
	ST   -Y,R30
	LDD  R30,Y+39
	SUBI R30,-LOW(3)
	ST   -Y,R30
	__POINTW2FN _0x0,10
	RCALL _glcd_outtextxyf
; 0000 0042 
; 0000 0043   sprintf(lcdBuff,"H:%2.0f",humi);
	RCALL SUBOPT_0x1
	__POINTW1FN _0x0,12
	RCALL SUBOPT_0x2
	__GETD1S 34
	RCALL SUBOPT_0x3
; 0000 0044   glcd_setfont(font5x7);
; 0000 0045   glcd_outtextxy(x,y+13,lcdBuff);
	SUBI R30,-LOW(13)
	RCALL SUBOPT_0x4
; 0000 0046   glcd_outtextxyf(x+25,y+13,"%");
	SUBI R30,-LOW(13)
	ST   -Y,R30
	__POINTW2FN _0x0,20
	RCALL _glcd_outtextxyf
; 0000 0047 }
	ADIW R28,40
	RET
; .FEND
;void getTime()
; 0000 0049 {
_getTime:
; .FSTART _getTime
; 0000 004A     rtc_get_time(&hour,&minn,&sec);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _rtc_get_time
; 0000 004B     rtc_get_date(&day,&date,&month,&year);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	RCALL _rtc_get_date
; 0000 004C }
	RET
; .FEND
;void timeDisplay(unsigned char x, unsigned char y)
; 0000 004E {
_timeDisplay:
; .FSTART _timeDisplay
; 0000 004F   glcd_setfont(fontNumber);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDI  R30,LOW(_fontNumber*2)
	LDI  R31,HIGH(_fontNumber*2)
	RCALL SUBOPT_0x5
; 0000 0050   glcd_putcharxy(x,y,48+(hour/10));
	MOV  R26,R5
	RCALL SUBOPT_0x6
	RCALL _glcd_putcharxy
; 0000 0051   glcd_putchar(48+(hour%10));
	MOV  R26,R5
	RCALL SUBOPT_0x7
; 0000 0052   glcd_outtext(":");
	__POINTW2MN _0x3,0
	RCALL _glcd_outtext
; 0000 0053   glcd_putchar(48+(minn/10));
	MOV  R26,R4
	RCALL SUBOPT_0x6
	RCALL _glcd_putchar
; 0000 0054   glcd_putchar(48+(minn%10));
	MOV  R26,R4
	RCALL SUBOPT_0x7
; 0000 0055   glcd_outtext(":");
	__POINTW2MN _0x3,2
	RCALL _glcd_outtext
; 0000 0056   glcd_putchar(48+(sec/10));
	MOV  R26,R7
	RCALL SUBOPT_0x6
	RCALL _glcd_putchar
; 0000 0057   glcd_putchar(48+(sec%10));
	MOV  R26,R7
	RCALL SUBOPT_0x7
; 0000 0058 }
	RJMP _0x21A0003
; .FEND

	.DSEG
_0x3:
	.BYTE 0x4
;void dateDisplay(unsigned char x, unsigned char y)
; 0000 005A {

	.CSEG
_dateDisplay:
; .FSTART _dateDisplay
; 0000 005B   glcd_setfont(font5x7);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	RCALL SUBOPT_0x5
; 0000 005C   glcd_putcharxy(x,y,48+(date/10));
	MOV  R26,R9
	RCALL SUBOPT_0x6
	RCALL _glcd_putcharxy
; 0000 005D   glcd_putchar(48+(date%10));
	MOV  R26,R9
	RCALL SUBOPT_0x7
; 0000 005E   glcd_outtext("/");
	__POINTW2MN _0x4,0
	RCALL _glcd_outtext
; 0000 005F   glcd_putchar(48+(month/10));
	MOV  R26,R8
	RCALL SUBOPT_0x6
	RCALL _glcd_putchar
; 0000 0060   glcd_putchar(48+(month%10));
	MOV  R26,R8
	RCALL SUBOPT_0x7
; 0000 0061   glcd_outtext("/");
	__POINTW2MN _0x4,2
	RCALL _glcd_outtext
; 0000 0062   glcd_putchar(48+(year/10));
	MOV  R26,R11
	RCALL SUBOPT_0x6
	RCALL _glcd_putchar
; 0000 0063   glcd_putchar(48+(year%10));
	MOV  R26,R11
	RCALL SUBOPT_0x7
; 0000 0064 }
	RJMP _0x21A0003
; .FEND

	.DSEG
_0x4:
	.BYTE 0x4
;
;void main(void)
; 0000 0067 {

	.CSEG
_main:
; .FSTART _main
; 0000 0068 // Declare your local variables here
; 0000 0069 // Variable used to store graphic display
; 0000 006A // controller initialization data
; 0000 006B GLCDINIT_t glcd_init_data;
; 0000 006C 
; 0000 006D // Input/Output Ports initialization
; 0000 006E // Port B initialization
; 0000 006F // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0070 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(63)
	OUT  0x17,R30
; 0000 0071 // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0072 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0073 
; 0000 0074 // Port C initialization
; 0000 0075 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 0076 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(2)
	OUT  0x14,R30
; 0000 0077 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=T
; 0000 0078 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0079 
; 0000 007A // Port D initialization
; 0000 007B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007C DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 007D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 007E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 007F 
; 0000 0080 // Timer/Counter 0 initialization
; 0000 0081 // Clock source: System Clock
; 0000 0082 // Clock value: 1000.000 kHz
; 0000 0083 TCCR0=(0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 0084 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0085 
; 0000 0086 // Timer/Counter 1 initialization
; 0000 0087 // Clock source: System Clock
; 0000 0088 // Clock value: Timer1 Stopped
; 0000 0089 // Mode: Normal top=0xFFFF
; 0000 008A // OC1A output: Disconnected
; 0000 008B // OC1B output: Disconnected
; 0000 008C // Noise Canceler: Off
; 0000 008D // Input Capture on Falling Edge
; 0000 008E // Timer1 Overflow Interrupt: Off
; 0000 008F // Input Capture Interrupt: Off
; 0000 0090 // Compare A Match Interrupt: Off
; 0000 0091 // Compare B Match Interrupt: Off
; 0000 0092 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0093 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0094 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0095 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0096 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0097 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0098 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0099 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 009A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 009B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 009C 
; 0000 009D // Timer/Counter 2 initialization
; 0000 009E // Clock source: System Clock
; 0000 009F // Clock value: Timer2 Stopped
; 0000 00A0 // Mode: Normal top=0xFF
; 0000 00A1 // OC2 output: Disconnected
; 0000 00A2 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00A3 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00A4 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00A5 OCR2=0x00;
	OUT  0x23,R30
; 0000 00A6 
; 0000 00A7 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A8 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00A9 
; 0000 00AA // External Interrupt(s) initialization
; 0000 00AB // INT0: On
; 0000 00AC // INT0 Mode: Falling Edge
; 0000 00AD // INT1: On
; 0000 00AE // INT1 Mode: Falling Edge
; 0000 00AF GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00B0 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 00B1 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00B2 
; 0000 00B3 // USART initialization
; 0000 00B4 // USART disabled
; 0000 00B5 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00B6 
; 0000 00B7 // Analog Comparator initialization
; 0000 00B8 // Analog Comparator: Off
; 0000 00B9 // The Analog Comparator's positive input is
; 0000 00BA // connected to the AIN0 pin
; 0000 00BB // The Analog Comparator's negative input is
; 0000 00BC // connected to the AIN1 pin
; 0000 00BD ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00BE SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00BF 
; 0000 00C0 // ADC initialization
; 0000 00C1 // ADC disabled
; 0000 00C2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00C3 
; 0000 00C4 // SPI initialization
; 0000 00C5 // SPI disabled
; 0000 00C6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00C7 
; 0000 00C8 // TWI initialization
; 0000 00C9 // TWI disabled
; 0000 00CA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00CB 
; 0000 00CC // Bit-Banged I2C Bus initialization
; 0000 00CD // I2C Port: PORTC
; 0000 00CE // I2C SDA bit: 4
; 0000 00CF // I2C SCL bit: 5
; 0000 00D0 // Bit Rate: 100 kHz
; 0000 00D1 // Note: I2C settings are specified in the
; 0000 00D2 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00D3 i2c_init();
	RCALL _i2c_init
; 0000 00D4 
; 0000 00D5 // DS1307 Real Time Clock initialization
; 0000 00D6 // Square wave output on pin SQW/OUT: Off
; 0000 00D7 // SQW/OUT pin state: 0
; 0000 00D8 rtc_init(0,0,0);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 00D9 
; 0000 00DA // Graphic Display Controller initialization
; 0000 00DB // The ST7920 connections are specified in the
; 0000 00DC // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00DD // E - PORTD Bit 7
; 0000 00DE // R /W - PORTD Bit 6
; 0000 00DF // RS - PORTD Bit 5
; 0000 00E0 // /RST - PORTB Bit 4
; 0000 00E1 // DB4 - PORTB Bit 0
; 0000 00E2 // DB5 - PORTB Bit 1
; 0000 00E3 // DB6 - PORTB Bit 2
; 0000 00E4 // DB7 - PORTB Bit 3
; 0000 00E5 
; 0000 00E6 // Specify the current font for displaying text
; 0000 00E7 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E8 // No function is used for reading
; 0000 00E9 // image data from external memory
; 0000 00EA glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00EB // No function is used for writing
; 0000 00EC // image data to external memory
; 0000 00ED glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00EE 
; 0000 00EF glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00F0 
; 0000 00F1 // Global enable interrupts
; 0000 00F2 #asm("sei")
	sei
; 0000 00F3 
; 0000 00F4 while (1)
_0x5:
; 0000 00F5       {
; 0000 00F6         getTime();
	RCALL _getTime
; 0000 00F7         timeDisplay(31,0);
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _timeDisplay
; 0000 00F8         tempDisplay(0,50);
	RCALL SUBOPT_0x8
	LDI  R26,LOW(50)
	RCALL _tempDisplay
; 0000 00F9         dateDisplay(42,17);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RCALL _dateDisplay
; 0000 00FA 
; 0000 00FB       }
	RJMP _0x5
; 0000 00FC }
_0x8:
	RJMP _0x8
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
	RCALL SUBOPT_0x9
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x18,R30
	RCALL _st7920_delay_G100
	CBI  0x12,7
	RCALL SUBOPT_0x9
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0xA
	CBI  0x12,7
	RJMP _0x21A000B
; .FEND
_st7920_rdbus_G100:
; .FSTART _st7920_rdbus_G100
	ST   -Y,R17
	RCALL SUBOPT_0xB
	SBI  0x12,7
	RCALL _st7920_delay_G100
	IN   R30,0x16
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0xA
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	OR   R17,R30
	CBI  0x12,7
	MOV  R30,R17
	RJMP _0x21A000C
; .FEND
_st7920_busy_G100:
; .FSTART _st7920_busy_G100
	ST   -Y,R17
	CBI  0x12,5
	RCALL SUBOPT_0xB
_0x2000004:
	SBI  0x12,7
	RCALL _st7920_delay_G100
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	LDI  R26,LOW(0)
	RCALL __NEB12
	MOV  R17,R30
	CBI  0x12,7
	RCALL SUBOPT_0xA
	CBI  0x12,7
	RCALL _st7920_delay_G100
	CPI  R17,0
	BRNE _0x2000004
_0x21A000C:
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
	RJMP _0x21A000B
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
	RJMP _0x21A000B
; .FEND
_st7920_setxy_G100:
; .FSTART _st7920_setxy_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	RCALL SUBOPT_0xC
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
	RCALL SUBOPT_0xC
	RJMP _0x21A0003
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	RCALL SUBOPT_0xD
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000007
	LDI  R30,LOW(12)
	RJMP _0x2000008
_0x2000007:
	LDI  R30,LOW(8)
_0x2000008:
	RCALL SUBOPT_0xC
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(2)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(0)
_0x200000B:
	STS  _st7920_graphics_on_G100,R30
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
_0x21A000B:
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
	RCALL SUBOPT_0xE
	LDI  R16,LOW(0)
_0x200000E:
	CPI  R16,64
	BRSH _0x2000010
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x21A0001
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0xF
	ST   -Y,R17
	SBI  0x11,7
	CBI  0x12,7
	SBI  0x11,6
	SBI  0x12,6
	SBI  0x11,5
	CBI  0x12,5
	SBI  0x17,4
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x10
	CBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x10
	SBI  0x18,4
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x10
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
	RCALL SUBOPT_0x10
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
	RCALL SUBOPT_0x11
	RCALL __GETW1P
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x14
	RJMP _0x20000A6
_0x2000017:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
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
	RJMP _0x21A0002
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
	RJMP _0x21A0003
; .FEND
_st7920_wrbyte_G100:
; .FSTART _st7920_wrbyte_G100
	RCALL SUBOPT_0x16
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
	RJMP _0x21A0002
; .FEND
_st7920_wrmasked_G100:
; .FSTART _st7920_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	RCALL SUBOPT_0xE
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL SUBOPT_0x17
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002A
	CPI  R30,LOW(0x8)
	BRNE _0x200002B
_0x200002A:
	LDD  R30,Y+3
	ST   -Y,R30
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
	RJMP _0x21A0008
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
	RJMP _0x21A000A
_0x2000039:
	LDD  R30,Y+18
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x19
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
	RCALL SUBOPT_0x19
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
	RJMP _0x21A000A
_0x2000046:
	CPI  R30,LOW(0x3)
	BRNE _0x2000049
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000048
	RJMP _0x21A000A
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
	RCALL SUBOPT_0x1A
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
	RCALL SUBOPT_0x1B
	RJMP _0x2000050
_0x2000052:
	MOV  R30,R18
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1A
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
	RCALL SUBOPT_0x1D
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x1B
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
	RCALL SUBOPT_0x20
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
	RCALL SUBOPT_0x20
	LPM  R0,Z
	STD  Y+12,R0
	RCALL SUBOPT_0xE
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
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x17
	AND  R30,R21
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	STD  Y+9,R30
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
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
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0xF)
	BRLO _0x200006B
_0x200006C:
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2
	LDD  R26,Y+12
	RCALL _glcd_writemem
	RJMP _0x200006A
_0x200006B:
	RCALL SUBOPT_0x24
	BRSH _0x200006E
	LDD  R30,Y+12
	STD  Y+11,R30
_0x200006E:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R26,Y+20
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x25
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
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x25
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RCALL _glcd_readmem
	STD  Y+10,R30
_0x2000075:
	RCALL SUBOPT_0x26
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
	RCALL SUBOPT_0x18
	CPI  R30,LOW(0xF)
	BRSH _0x2000072
	RCALL SUBOPT_0x24
	BRSH _0x200007C
	LDD  R30,Y+12
	STD  Y+11,R30
_0x200007C:
	SUBI R16,-LOW(8)
	RCALL SUBOPT_0x26
	MOV  R30,R18
	LDD  R26,Y+12
	RCALL __LSRB12
	RCALL SUBOPT_0x27
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
	RCALL SUBOPT_0x24
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
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	STD  Y+10,R30
_0x2000089:
_0x2000084:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x200008C
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x2
	ST   -Y,R16
	LDD  R26,Y+23
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x26
	LDD  R30,Y+12
	RCALL SUBOPT_0x27
_0x200008D:
	RCALL SUBOPT_0x28
	ADIW R30,1
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x1E
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x2000063
_0x2000065:
_0x21A000A:
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
	RCALL SUBOPT_0xD
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
	RJMP _0x21A0004
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x29
	BRLT _0x2020003
	RCALL SUBOPT_0x15
	RJMP _0x21A0003
_0x2020003:
	RCALL SUBOPT_0x2A
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x21A0003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x21A0003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x29
	BRLT _0x2020005
	RCALL SUBOPT_0x15
	RJMP _0x21A0003
_0x2020005:
	RCALL SUBOPT_0x2A
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x21A0003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x21A0003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	RCALL SUBOPT_0xF
	SBIW R28,3
	RCALL SUBOPT_0x2B
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	RCALL SUBOPT_0x15
	RJMP _0x21A0009
_0x202000B:
	RCALL SUBOPT_0x2C
	STD  Y+7,R0
	RCALL SUBOPT_0x2C
	STD  Y+6,R0
	RCALL SUBOPT_0x2C
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	RCALL SUBOPT_0x15
	RJMP _0x21A0009
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
	RCALL SUBOPT_0x15
	RJMP _0x21A0009
_0x202000D:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000E
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x1D
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x1D
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x21A0009
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
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x1D
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x21A0009:
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
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x19
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x2E
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x2B
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
	RJMP _0x21A0007
_0x2020023:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	RCALL SUBOPT_0x1E
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020024
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020024:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x2D
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	RCALL SUBOPT_0x2F
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x2D
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x2F
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x2D
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x31
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020025
_0x2020022:
	RCALL _glcd_new_line_G101
	RCALL __LOADLOCR6
	RJMP _0x21A0007
_0x2020025:
	RJMP _0x2020026
_0x2020020:
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BREQ _0x2020028
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x2F
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
	RCALL SUBOPT_0x2E
_0x2020029:
_0x2020026:
	__PUTBMRN _glcd_state,2,16
	RCALL __LOADLOCR6
	RJMP _0x21A0007
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	RCALL SUBOPT_0x16
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x21A0002
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0x32
_0x202002A:
	RCALL SUBOPT_0x33
	BREQ _0x202002C
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x202002A
_0x202002C:
	LDD  R17,Y+0
	RJMP _0x21A0004
; .FEND
_glcd_outtextxyf:
; .FSTART _glcd_outtextxyf
	RCALL SUBOPT_0x32
_0x202002D:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202002F
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x202002D
_0x202002F:
	LDD  R17,Y+0
	RJMP _0x21A0004
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	RCALL SUBOPT_0xF
	ST   -Y,R17
_0x2020033:
	RCALL SUBOPT_0x33
	BREQ _0x2020035
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020033
_0x2020035:
	LDD  R17,Y+0
	RJMP _0x21A0002
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
	RCALL SUBOPT_0x2E
	RJMP _0x21A0003
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
	RCALL SUBOPT_0x34
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _i2c_write
	RCALL _i2c_stop
	RJMP _0x21A0002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x34
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
_0x21A0008:
	ADIW R28,6
	RET
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x34
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x37
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x2A
	ST   X,R30
	RCALL _i2c_stop
_0x21A0007:
	ADIW R28,8
	RET
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
_DHT_GetTemHumi:
; .FSTART _DHT_GetTemHumi
	ST   -Y,R26
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	RCALL __SAVELOCR4
	SBI  0x14,3
	SBI  0x15,3
	RCALL SUBOPT_0x39
	CBI  0x15,3
	LDI  R26,LOW(18)
	RCALL SUBOPT_0x10
	SBI  0x15,3
	CBI  0x14,3
	RCALL SUBOPT_0x39
	SBIS 0x13,3
	RJMP _0x208000D
	LDI  R30,LOW(0)
	RJMP _0x21A0006
_0x208000D:
_0x208000F:
	SBIS 0x13,3
	RJMP _0x208000F
	RCALL SUBOPT_0x39
	SBIC 0x13,3
	RJMP _0x2080012
	LDI  R30,LOW(0)
	RJMP _0x21A0006
_0x2080012:
_0x2080014:
	SBIC 0x13,3
	RJMP _0x2080014
	LDI  R17,LOW(0)
_0x2080018:
	CPI  R17,5
	BRSH _0x2080019
	LDI  R16,LOW(0)
_0x208001B:
	CPI  R16,8
	BRSH _0x208001C
_0x208001D:
	SBIS 0x13,3
	RJMP _0x208001D
	__DELAY_USB 17
	SBIS 0x13,3
	RJMP _0x2080020
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x1E
	MOVW R22,R30
	LD   R1,Z
	LDI  R30,LOW(7)
	SUB  R30,R16
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
_0x2080021:
	SBIC 0x13,3
	RJMP _0x2080021
_0x2080020:
	SUBI R16,-1
	RJMP _0x208001B
_0x208001C:
	SUBI R17,-1
	RJMP _0x2080018
_0x2080019:
	LDD  R30,Y+5
	LDD  R26,Y+4
	ADD  R30,R26
	LDD  R26,Y+6
	ADD  R30,R26
	LDD  R26,Y+7
	ADD  R30,R26
	MOV  R19,R30
	LDD  R30,Y+8
	CP   R30,R19
	BREQ _0x2080024
	LDI  R30,LOW(0)
	RJMP _0x21A0006
_0x2080024:
	LDD  R26,Y+9
	CPI  R26,LOW(0x2)
	BRNE _0x2080025
	LDD  R30,Y+6
	RJMP _0x21A0006
_0x2080025:
	LDD  R26,Y+9
	CPI  R26,LOW(0x3)
	BRNE _0x2080027
	LDD  R30,Y+7
	RJMP _0x21A0006
_0x2080027:
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x2080029
	LDD  R30,Y+4
	RJMP _0x21A0006
_0x2080029:
	LDD  R26,Y+9
	CPI  R26,LOW(0x1)
	BRNE _0x208002B
	LDD  R30,Y+5
	RJMP _0x21A0006
_0x208002B:
	LDI  R30,LOW(1)
_0x21A0006:
	RCALL __LOADLOCR4
	ADIW R28,10
	RET
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
_put_buff_G106:
; .FSTART _put_buff_G106
	RCALL SUBOPT_0xF
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x3A
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x20C0010
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x14
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x20C0012
	__CPWRN 16,17,2
	BRLO _0x20C0013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x20C0012:
	RCALL SUBOPT_0x3A
	ADIW R26,2
	RCALL SUBOPT_0x3B
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x20C0013:
	RCALL SUBOPT_0x3A
	RCALL __GETW1P
	TST  R31
	BRMI _0x20C0014
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
_0x20C0014:
	RJMP _0x20C0015
_0x20C0010:
	RCALL SUBOPT_0x3A
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x20C0015:
	RCALL __LOADLOCR2
	RJMP _0x21A0004
; .FEND
__print_G106:
; .FSTART __print_G106
	RCALL SUBOPT_0xF
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x15
	ST   X+,R30
	ST   X,R31
_0x20C0016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20C0018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x20C001C
	CPI  R18,37
	BRNE _0x20C001D
	LDI  R17,LOW(1)
	RJMP _0x20C001E
_0x20C001D:
	RCALL SUBOPT_0x3C
_0x20C001E:
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x1)
	BRNE _0x20C001F
	CPI  R18,37
	BRNE _0x20C0020
	RCALL SUBOPT_0x3C
	RJMP _0x20C00CC
_0x20C0020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x20C0021
	LDI  R16,LOW(1)
	RJMP _0x20C001B
_0x20C0021:
	CPI  R18,43
	BRNE _0x20C0022
	LDI  R20,LOW(43)
	RJMP _0x20C001B
_0x20C0022:
	CPI  R18,32
	BRNE _0x20C0023
	LDI  R20,LOW(32)
	RJMP _0x20C001B
_0x20C0023:
	RJMP _0x20C0024
_0x20C001F:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0025
_0x20C0024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x20C0026
	ORI  R16,LOW(128)
	RJMP _0x20C001B
_0x20C0026:
	RJMP _0x20C0027
_0x20C0025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x20C001B
_0x20C0027:
	CPI  R18,48
	BRLO _0x20C002A
	CPI  R18,58
	BRLO _0x20C002B
_0x20C002A:
	RJMP _0x20C0029
_0x20C002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20C001B
_0x20C0029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x20C002F
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3D
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x3F
	RJMP _0x20C0030
_0x20C002F:
	CPI  R30,LOW(0x73)
	BRNE _0x20C0032
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x20C0033
_0x20C0032:
	CPI  R30,LOW(0x70)
	BRNE _0x20C0035
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x20C0033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x20C0036
_0x20C0035:
	CPI  R30,LOW(0x64)
	BREQ _0x20C0039
	CPI  R30,LOW(0x69)
	BRNE _0x20C003A
_0x20C0039:
	ORI  R16,LOW(4)
	RJMP _0x20C003B
_0x20C003A:
	CPI  R30,LOW(0x75)
	BRNE _0x20C003C
_0x20C003B:
	LDI  R30,LOW(_tbl10_G106*2)
	LDI  R31,HIGH(_tbl10_G106*2)
	RCALL SUBOPT_0x1F
	LDI  R17,LOW(5)
	RJMP _0x20C003D
_0x20C003C:
	CPI  R30,LOW(0x58)
	BRNE _0x20C003F
	ORI  R16,LOW(8)
	RJMP _0x20C0040
_0x20C003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20C0071
_0x20C0040:
	LDI  R30,LOW(_tbl16_G106*2)
	LDI  R31,HIGH(_tbl16_G106*2)
	RCALL SUBOPT_0x1F
	LDI  R17,LOW(4)
_0x20C003D:
	SBRS R16,2
	RJMP _0x20C0042
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	LDD  R26,Y+11
	TST  R26
	BRPL _0x20C0043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x42
	LDI  R20,LOW(45)
_0x20C0043:
	CPI  R20,0
	BREQ _0x20C0044
	SUBI R17,-LOW(1)
	RJMP _0x20C0045
_0x20C0044:
	ANDI R16,LOW(251)
_0x20C0045:
	RJMP _0x20C0046
_0x20C0042:
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
_0x20C0046:
_0x20C0036:
	SBRC R16,0
	RJMP _0x20C0047
_0x20C0048:
	CP   R17,R21
	BRSH _0x20C004A
	SBRS R16,7
	RJMP _0x20C004B
	SBRS R16,2
	RJMP _0x20C004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x20C004D
_0x20C004C:
	LDI  R18,LOW(48)
_0x20C004D:
	RJMP _0x20C004E
_0x20C004B:
	LDI  R18,LOW(32)
_0x20C004E:
	RCALL SUBOPT_0x3C
	SUBI R21,LOW(1)
	RJMP _0x20C0048
_0x20C004A:
_0x20C0047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x20C004F
_0x20C0050:
	CPI  R19,0
	BREQ _0x20C0052
	SBRS R16,3
	RJMP _0x20C0053
	RCALL SUBOPT_0x28
	LPM  R18,Z+
	RCALL SUBOPT_0x1F
	RJMP _0x20C0054
_0x20C0053:
	RCALL SUBOPT_0x1C
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20C0054:
	RCALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x20C0055
	SUBI R21,LOW(1)
_0x20C0055:
	SUBI R19,LOW(1)
	RJMP _0x20C0050
_0x20C0052:
	RJMP _0x20C0056
_0x20C004F:
_0x20C0058:
	LDI  R18,LOW(48)
	RCALL SUBOPT_0x28
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	RCALL SUBOPT_0x28
	ADIW R30,2
	RCALL SUBOPT_0x1F
_0x20C005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x20C005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x42
	RJMP _0x20C005A
_0x20C005C:
	CPI  R18,58
	BRLO _0x20C005D
	SBRS R16,3
	RJMP _0x20C005E
	SUBI R18,-LOW(7)
	RJMP _0x20C005F
_0x20C005E:
	SUBI R18,-LOW(39)
_0x20C005F:
_0x20C005D:
	SBRC R16,4
	RJMP _0x20C0061
	CPI  R18,49
	BRSH _0x20C0063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x20C0062
_0x20C0063:
	RJMP _0x20C00CD
_0x20C0062:
	CP   R21,R19
	BRLO _0x20C0067
	SBRS R16,0
	RJMP _0x20C0068
_0x20C0067:
	RJMP _0x20C0066
_0x20C0068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20C0069
	LDI  R18,LOW(48)
_0x20C00CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20C006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x3F
	CPI  R21,0
	BREQ _0x20C006B
	SUBI R21,LOW(1)
_0x20C006B:
_0x20C006A:
_0x20C0069:
_0x20C0061:
	RCALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x20C006C
	SUBI R21,LOW(1)
_0x20C006C:
_0x20C0066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x20C0059
	RJMP _0x20C0058
_0x20C0059:
_0x20C0056:
	SBRS R16,0
	RJMP _0x20C006D
_0x20C006E:
	CPI  R21,0
	BREQ _0x20C0070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x3F
	RJMP _0x20C006E
_0x20C0070:
_0x20C006D:
_0x20C0071:
_0x20C0030:
_0x20C00CC:
	LDI  R17,LOW(0)
_0x20C001B:
	RJMP _0x20C0016
_0x20C0018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x43
	SBIW R30,0
	BRNE _0x20C0072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x21A0005
_0x20C0072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x2
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G106)
	LDI  R31,HIGH(_put_buff_G106)
	RCALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G106
	MOVW R18,R30
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x21A0005:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	RCALL SUBOPT_0xF
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
_0x21A0004:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0xF
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0xF
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x20
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x21A0003:
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
	RJMP _0x21A0002
_0x212000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x21A0002
_0x212000E:
	CPI  R17,0
	BRNE _0x2120011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x21A0002
_0x2120011:
_0x2120005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x21A0002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0xF
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2120015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x21A0002
_0x2120015:
	CPI  R30,LOW(0x2)
	BRNE _0x2120016
	RCALL SUBOPT_0x2A
	RCALL __EEPROMRDB
	RJMP _0x21A0002
_0x2120016:
	CPI  R30,LOW(0x3)
	BRNE _0x2120018
	RCALL SUBOPT_0x2A
	__CALL1MN _glcd_state,25
	RJMP _0x21A0002
_0x2120018:
	RCALL SUBOPT_0x2A
	LD   R30,X
_0x21A0002:
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
	RCALL SUBOPT_0x11
	ST   X,R30
	RJMP _0x212001B
_0x212001C:
	CPI  R30,LOW(0x2)
	BRNE _0x212001D
	LD   R30,Y
	RCALL SUBOPT_0x11
	RCALL __EEPROMWRB
	RJMP _0x212001B
_0x212001D:
	CPI  R30,LOW(0x3)
	BRNE _0x212001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x2
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x212001B:
_0x21A0001:
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_st7920_graphics_on_G100:
	.BYTE 0x1
_st7920_bits8_15_G100:
	.BYTE 0x1
_xt_G100:
	.BYTE 0x1
_yt_G100:
	.BYTE 0x1
__seed_G10C:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	RCALL _DHT_GetTemHumi
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+39
	ST   -Y,R30
	LDD  R30,Y+39
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _glcd_outtextxy
	LDD  R30,Y+39
	SUBI R30,-LOW(25)
	ST   -Y,R30
	LDD  R30,Y+39
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	__PUTW1MN _glcd_state,4
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x6:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x7:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _glcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	RCALL _st7920_delay_G100
	SBI  0x12,7
	RJMP _st7920_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	SBI  0x12,6
	IN   R30,0x17
	ANDI R30,LOW(0xF0)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	MOV  R26,R30
	RJMP _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDS  R30,_st7920_graphics_on_G100
	ORI  R30,0x20
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_st7920_graphics_on_G100
	ORI  R30,LOW(0x24)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	RCALL _st7920_rdbyte_G100
	MOV  R26,R30
	RJMP _glcd_revbits

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R30,Y+16
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x23
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R26,Y+17
	RJMP _st7920_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0xF
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2D:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	__GETB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x2
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0xF
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RJMP _glcd_moveto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x11
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	RCALL _i2c_write
	RCALL _i2c_stop
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RJMP _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	__DELAY_USB 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3C:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3D
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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
