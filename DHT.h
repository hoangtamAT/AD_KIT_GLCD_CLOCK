#ifndef _DHT_
#define _DHT_INCLUDED_

#define DHT_ER      0 
#define DHT_OK      1 
#define DHT_ND      2 
#define DHT_ND1     3
#define DHT_DA      0
#define DHT_DA1     1

#define DATA_DDR    DDRC.2
#define DATA_PORT   PORTC.2
#define DATA_PIN    PINC.2

unsigned char DHT_GetTemHumi (unsigned char select);

#pragma library DHT.c
#endif