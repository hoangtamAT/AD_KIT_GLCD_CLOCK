#include <DHT.h> 
#include <delay.h> 
#include <mega8.h>

unsigned char DHT_GetTemHumi (unsigned char select)
{   unsigned char i,ii,checksum;
    unsigned char buffer[5]={0,0,0,0,0};              
        DATA_DDR=1;
        DATA_PORT=1;
        delay_us(60);
        DATA_PORT=0;
        delay_ms(18);
        DATA_PORT=1;
        DATA_DDR=0;
        delay_us(60);
        if(DATA_PIN==1)return DHT_ER ; 
        else while(DATA_PIN==0);    //Doi DaTa len 1 
        delay_us(60);       //60
        if(DATA_PIN==0)return DHT_ER; 
        else while((DATA_PIN==1));
         
        // doc du lieu
        for(i=0;i<5;i++)
    {
        for(ii=0;ii<8;ii++)
        {    
        while(DATA_PIN==0);//Doi Data len 1
        delay_us(50);
        if(DATA_PIN==1)
            {
            buffer[i]|=(1<<(7-ii));
            while(DATA_PIN==1);//Doi Data xuong 0
            }
        }
    }
    //Tinh toan check sum 
    checksum=buffer[0]+buffer[1]+buffer[2]+buffer[3]; 
    //Kiem tra check sum 
    if((checksum)!=buffer[4])return DHT_ER;  
    if(select==DHT_ND)
        {
         return(buffer[2]);
        }

      else if(select==DHT_DA) 
      { 
            return(buffer[0]); 
      } 
 
    return DHT_OK;
}