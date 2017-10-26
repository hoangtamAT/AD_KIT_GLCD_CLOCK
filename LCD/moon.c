/****************************************************************************
Image data created by the LCD Vision V1.05 font & image editor/converter
(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Graphic LCD controller: KS0108 128x64 CS1,CS2
Image width: 15 pixels
Image height: 15 pixels
Color depth: 1 bits/pixel
Imported image file name: moon.bmp

Exported monochrome image data size:
30 bytes for displays organized as horizontal rows of bytes
30 bytes for displays organized as rows of vertical bytes.
****************************************************************************/

unsigned char moon[]=
{
/* Image width: 13 pixels */
0x0D, 0x00,
/* Image height: 13 pixels */
0x0D, 0x00,
#ifndef _GLCD_DATA_BYTEY_
/* Image data for monochrome displays organized
   as horizontal rows of bytes */
0x00, 0x00, 0xC0, 0x01, 0xF0, 0x02, 0x78, 0x00, 
0x78, 0x00, 0x3C, 0x00, 0x3C, 0x00, 0x78, 0x00, 
0x78, 0x00, 0xF0, 0x02, 0xC0, 0x01, 0x00, 0x00, 
0x00, 0x00, 
#else
/* Image data for monochrome displays organized
   as rows of vertical bytes */
0x00, 0x00, 0x60, 0xF8, 0xFC, 0xFC, 0x9E, 0x06, 
0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
0x01, 0x03, 0x03, 0x07, 0x06, 0x04, 0x02, 0x00, 
0x00, 0x00, 
#endif
};

