/*
author: david zimmer
site: http://sandsprite.com
license: none

purpose:
          display attic temp/humi/dew point, and remotly set a physical knob that determins when 
          an exhaust fan turns on. The knob is attached to a stock humidity sensor that controls 
          power to the 120v fan. We just use a low powered 5v servo to set its position from a
          more convient location downstairs. (as going into the attic involves a ladder, dealing 
          with cold/hot temps, putting on boots, walking through open insulation, tracking said
          insulation back down into the house with me, old bat crap and maybe even actual bats)
          
hardware: OLED screen Amazon part number: b00o2llt30: $15  ( 128x64 pixels, I2c , SSD1306 driver )
          DHT22 temp/humidity sensor                : $10
          micro hobby servo amazon part B001CFUBN8  : $5 
          arduino uno clone amazon part B00E5WJSHK  : $13
          potentiometer, wire, etc..                ------
                                                    ~ $45
          
          you could shrink this down allot cost wise if you eliminate the dht22 and oled screen, then
          you can use an attiny + servo + pot (3+5+1). I probably will in time, but first I want the feedback
          of knowing what the actual temp/humidity is to watch when house ices then I can just draw lines on
          where it should be set for winter. and downsize.


wiring:
         servo on pin 9
         dht22 on pin 2
         OLED  on I2C (address 0x3c)
         pot   on pin A0
         
notes:   oleds can burn in, do not leave on, I am just going to battery 
         power and turn on to take spot checks.
*/

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <dht22.h>
#include <Servo.h>

int potPin = A0;  // analog pin used to connect the potentiometer

dht22 DHT22;
Servo myservo; 

#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);
 
//#define LOGO16_GLCD_HEIGHT 16 
//#define LOGO16_GLCD_WIDTH  16 

#if (SSD1306_LCDHEIGHT != 64)
#error("Height incorrect, please fix Adafruit_SSD1306.h!");
#endif

int temp=0;
int humi=0;
int dewpt=0;
int ticks=0;
int lastVal=0;

#define firmware_ver  "v1.3 " __DATE__  

void setup()   {                
  Serial.begin(9600);
  
  DHT22.attach(2);
  myservo.attach(9);  
  pinMode(potPin, INPUT);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); 
  
  display.clearDisplay(); 
  display.setTextColor(WHITE);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.println(firmware_ver);
  display.println();
  display.println("Sandsprite.com");
  display.println("Attic Monitor");
  display.println("Fan Knob Remote");  
  display.display();
  delay(2000);

}

double toFahrenheit(double dCelsius){ return 1.8 * dCelsius + 32; }

void ReadDHT22(){
  
  int maxticks = 60 * 100; //10ms tick * 100 = 1sec * 60 = 1 minute
  
  if(ticks >= maxticks) ticks = 0;
  
  if( ticks == 0 || ticks > maxticks || temp == 0){
      int chk = DHT22.read();
      
      switch (chk)
      {
        case 0: /*Serial.println("OK");*/ break;
        case -1: display.println("Checksum error"); return;
        case -2: display.println("Time out error"); return;
        default: display.println("Unknown error"); return;
      }
      
      humi = DHT22.humidity;
      temp = DHT22.fahrenheit();
      dewpt = toFahrenheit((double)DHT22.dewPoint());
  }
    
  display.print("Humi: ");
  display.println(humi);

  display.print("Temp: ");
  display.println(temp);

  display.print("DewPt: ");
  display.println(dewpt);
  
}

void loop() {
      
   int val = analogRead(potPin);        // reads the value of the potentiometer (value between 0 and 1023) 
   val = map(val, 0, 1023, 0, 180);     // scale it to use it with the servo (value between 0 and 180) 
   
   if( abs(val - lastVal) > 2){ //pot changed refresh display..
       display.clearDisplay(); 
       display.setTextColor(WHITE);
       display.setCursor(0,0);
       display.setTextSize(2);
       display.print("Pos: ");
       display.println(val);
       ReadDHT22(); //only actually read once per min max..
       display.display();
       myservo.write(val);               
   }

   ticks++;
   delay(10);

}




