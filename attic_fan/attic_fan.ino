/*
author: david zimmer
site: http://sandsprite.com
license: free

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
          potentiometer, wire, NPN transistor, etc ------
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
         NPN transistor base on pin 11
         
notes:   oleds can burn in, do not leave on, I am just going to battery 
         power and turn on to take spot checks.
         
version: 
         added NPN transistor to explicitly power on servo so it wont jitter randomly on startup
         also allows for servo power down when idle to conserve battery power

output:
        Sketch uses 16,308 bytes (50%) of program storage space. Maximum is 32,256 bytes.
        Global variables use 1,730 bytes (84%) of dynamic memory, leaving 318 bytes for local variables. Maximum is 2,048 bytes.
        Low memory available, stability problems may occur.

todo:
        trim out libraries to try to free up global memory?

*/

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <dht22.h>
#include <Servo.h>

#define firmware_ver  "v0.1 " __DATE__ 

int potPin = A0;  // analog pin used to connect the potentiometer
int tranPin = 11;  //Transistor base pin
                   //thanks Gary! - http://www.modsbyus.com/how-to-properly-detachturn-off-a-servo-with-arduino/

dht22 DHT22;
Servo myservo; 

#define OLED_RESET 4
Adafruit_SSD1306 display(OLED_RESET);

#if (SSD1306_LCDHEIGHT != 64)
#error("Height incorrect, please fix Adafruit_SSD1306.h!");
#endif

int temp=0;
int humi=0;
int dewpt=0;
int lastVal=0;
bool powerOn = false;
unsigned long ticks=0;
unsigned long lastMove = 0;
unsigned int dhtFailed = 0;

void setup()   {   
  
  Serial.begin(9600);
  
  pinMode(potPin, INPUT);
  pinMode(tranPin, OUTPUT); 
  
  DHT22.attach(2);
  myservo.attach(9); 
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); 
  
  setupScreen(1);
  display.println(firmware_ver);
  display.println();
  display.println("Sandsprite.com");
  display.println("Attic Monitor");
  display.println("Fan Knob Remote");  
  display.display();

  myservo.write( servoPos() );   //set servo startup position..wont jump if still at last pos set on pot on power down..
  powerDevices(true);            //now turn on the servo and dht22
  
  delay(2000);                   //pause to display splash screen ..
  
}

void setupScreen(int textSz){
  display.clearDisplay(); 
  display.setTextColor(WHITE);
  display.setTextSize(textSz);
  display.setCursor(0,0);
}
      
double toFahrenheit(double dCelsius){
  return 1.8 * dCelsius + 32; 
}

void ReadDHT22(){
  
  int maxticks = 60 * 100; //10ms tick * 100 = 1sec * 60 = 1 minute
  int chk=0;
  
  //handle case of no dht22 connected or it is dead..
  //if we dont do this the servo is super jumpy because of the delays 
  if(dhtFailed >= 3){
      display.println("dht Err");
      display.println("Gave Up");
      return; 
  }
  
  if(ticks >= maxticks) ticks = 0;
  
  if( ticks == 0 || temp == 0){
      
      for(int i=0; i < 4; i++){
          chk = DHT22.read();
          if(chk==0) break; else delay(250);
      }
      
      if(chk !=0){    
        dhtFailed++;  
        display.println("dht Err");
        if(chk == -1) display.println("Checksum");
         else if(chk == -2) display.println("Timeout");
          else display.println("Unknown");  
        return;
      }
      
      if(dhtFailed > 0) dhtFailed--;
      humi = DHT22.humidity;
      temp = DHT22.fahrenheit();
      dewpt = toFahrenheit((double)DHT22.dewPoint());
  }
    
  display.print("Humi: ");
  display.println(humi);

  display.print("Temp: ");
  display.println(temp);

  display.print("DwPt: ");
  display.println(dewpt);
  
}

void powerDevices(bool on){
  digitalWrite(tranPin, on ? HIGH : LOW); 
  powerOn  = on;
}

int servoPos(){
      int val = analogRead(potPin);        // reads the value of the potentiometer (value between 0 and 1023) 
      return map(val, 0, 1023, 0, 180);     // scale it to use it with the servo (value between 0 and 180) 
}

void loop() {
      
   int val = servoPos();                                      // todo: map servos pos to actual temp setting on dial for display and ignore invalid positions

   if( abs(val - lastVal) > 2){ //pot changed refresh display..
       lastVal = val;
       if(!powerOn) powerDevices(true);
       lastMove = millis();
       setupScreen(2);
       display.print("Pos: ");
       display.println(val);
       ReadDHT22(); //only actually read once per min max..
       display.display();
       myservo.write(val); 
       delay(2);
   }

   //conserve battery power when idle otherwise servo will keep drawing power to hold pos..
   if( millis() - lastMove  > 1200 )  powerDevices(false); 
   
   ticks++;
   delay(10);

}




