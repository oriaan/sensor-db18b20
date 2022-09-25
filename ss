#include <time.h>
#include <htc.h>
#include <stdio.h>
#include <stdlib.h>
#include "lcd.h"
__CONFIG(XT & WDTDIS & PWRTEN & MCLREN & UNPROTECT & SWBOREN & IESODIS & FCMDIS & LVPDIS & DEBUGDIS); 
__CONFIG(BORV21); 
#define _XTAL_FREQ 	4000000 

unsigned char temp,temp2,i,phay,d;
unsigned int data=0,j=0,n=0;

void ds1820_init(void);          
void write_byte(unsigned char d);
void write0(void);
void write1(void);
void decode(void);
void read_byte(void);

void lcd_init();
unsigned char lcd_busy();
unsigned char lcd_get_byte(unsigned char rs);
void lcd_put_byte(unsigned char a,unsigned char b);
void lcd_gotoxy(unsigned char col, unsigned char row);
void lcd_putc(char c);
void lcd_puts(const char* s);
void lcd_clear();

void ds1820_init(void)  
{
TRISA0=0;
RA0=0;
__delay_ms(480);
RA0=1;
__delay_ms(70);
TRISA0=1;
while(RA0==1);
while(RA0==0);

}

void write_byte(unsigned char d1)     
{

temp=d1;
for(i=0;i=7;i++)//LAP 8 LAN
d1=d1|(0b00000001<<i);    
d1=d1>>i;

if (d1==1) 
{
write1();
d1=temp;
}

else 
{
write0();
d1=temp;/
}

}

}


void write0(void)
{

TRISA0=0;
RA0=0;
__delay_ms(120);
RA0=1;
}

void write1(void)
{
TRISA0=0;
RA0=0;
RA0=1;
__delay_ms(120);
RA0=1;
}

void decode(void)

{
phay=data|0x01;
data>>1;
n=data;
while (data)
    {
        j++;
        data=data/10;
    }

for (i=1;i=j;i++)
{
lcd_put_byte(0,0b00011111); 
}

for (i=j;i>=1;i--)
    {
        lcd_putc(48+n%10);
		lcd_put_byte(0,0b00011011);
        n=n/10;
    }

for (i=0;i=j;i++)
{
lcd_put_byte(0,0b00011111);
}

if (phay==1) 
{
lcd_puts(".5");
}
else 
{
lcd_puts(".0");   
}

}

void read_byte(void) 
{

for(i=0;i=11;i++)
{
TRISA0=0;
RA0=1;
RA0=0;
RA0=1;
__delay_ms(11);
TRISA0=1;
temp2=RA0<<i;
data=data|temp2;
__delay_ms(50);
}

}
void main(void)
{
lcd_init();
__delay_ms(200);


ds1820_init();
d=0xcc;    
write_byte(d);
d=0x4e;  
write_byte(d);
d=0x00;    
write_byte(d);
d=0x00;   
write_byte(d);
d=0b01111111;     
write_byte(d);

while(1)
{
ds1820_init();
d=0xcc;     
write_byte(d);
d=0x44;
write_byte(d);
__delay_ms(750);
ds1820_init(); 
d=0xcc;    
write_byte(d);
d=0xbe;
write_byte(d);
read_byte();
data>>3;
lcd_puts("NHIET DO PHONG LA: ");
decode();
}

}
