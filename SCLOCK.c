/*******************************************************
Project :  Clock Dispaly Glcd 
Version :  00
Date    : 10/19/2017
Author  : Hoang Tam
Company : 
Comments: 

Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <i2c.h>
#include <glcd.h>
#include <font5x7.h>
#include <ds1307.h>
#include <DHT.h>
#include <fontnumber8x13.h>
#include <stdio.h>
char hour,minn,sec,day,date,month,year,index,No_date;

interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here

}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}
void tempDisplay(unsigned char x, unsigned char y)
{
  float temp,humi; 
  char lcdBuff[30];  
  #asm("cli");
  temp=DHT_GetTemHumi(DHT_ND);
  humi=DHT_GetTemHumi(DHT_DA);
  #asm("sei"); 
  sprintf(lcdBuff,"T:%2.0f",temp);
  glcd_setfont(font5x7);
  glcd_outtextxy(x,y+3,lcdBuff);
  glcd_outtextxyf(x+25,y,"o");
  glcd_outtextxyf(x+32,y+3,"C");
  
  sprintf(lcdBuff,"H:%2.0f",humi);
  glcd_setfont(font5x7);
  glcd_outtextxy(x,y+13,lcdBuff);
  glcd_outtextxyf(x+25,y+13,"%");
}
void getTime()
{
    rtc_get_time(&hour,&minn,&sec);
    rtc_get_date(&day,&date,&month,&year);
}
void timeDisplay(unsigned char x, unsigned char y)
{
  glcd_setfont(fontNumber);
  glcd_putcharxy(x,y,48+(hour/10)); 
  glcd_putchar(48+(hour%10)); 
  glcd_outtext(":");
  glcd_putchar(48+(minn/10)); 
  glcd_putchar(48+(minn%10)); 
  glcd_outtext(":");
  glcd_putchar(48+(sec/10)); 
  glcd_putchar(48+(sec%10)); 
}
void dateDisplay(unsigned char x, unsigned char y)
{
  glcd_setfont(font5x7);
  glcd_putcharxy(x,y,48+(date/10)); 
  glcd_putchar(48+(date%10)); 
  glcd_outtext("/");
  glcd_putchar(48+(month/10)); 
  glcd_putchar(48+(month%10)); 
  glcd_outtext("/");
  glcd_putchar(48+(year/10)); 
  glcd_putchar(48+(year%10));
}

void main(void)
{

GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
TCCR0=(0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
GIFR=(1<<INTF1) | (1<<INTF0);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 4
// I2C SCL bit: 5
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

// Graphic Display Controller initialization
// The ST7920 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// E - PORTD Bit 7
// R /W - PORTD Bit 6
// RS - PORTD Bit 5
// /RST - PORTB Bit 4
// DB4 - PORTB Bit 0
// DB5 - PORTB Bit 1
// DB6 - PORTB Bit 2
// DB7 - PORTB Bit 3

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;

glcd_init(&glcd_init_data);

// Global enable interrupts
#asm("sei")

while (1)
      {
        getTime();
        timeDisplay(31,0);
        tempDisplay(0,50);
        dateDisplay(42,17);

      }
}
