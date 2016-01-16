#include "SPI.h"    
#include "Mirf.h"
#include "nRF24L01.h"
#include "MirfHardwareSpiDriver.h"
#include <Servo.h>

long Joystick_1_X;
long Joystick_1_Y;
long Joystick_2_X;
long Joystick_2_Y;
long Joystick_1;
long Joystick_2;
long data;

Servo servo1;
Servo servo2;
Servo servo3;
Servo servo4;

float k_1;
float k_2;
float k_3;
float k_4;

float speed_1;
float speed_2;
float speed_3;
float speed_4;

void setup(){
  Serial.begin(115200);
  
  servo1.attach(5);
  servo2.attach(6);
  servo3.attach(9);
  servo4.attach(10);
  
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  Mirf.setTADDR((byte *)"serv1");
  Mirf.payload = sizeof(long);
  Mirf.config();
}

void loop(){
  if(Mirf.dataReady()){
    Mirf.getData((byte *)&data);
    //Serial.print("data="); Serial.print(data);
    Mirf.rxFifoEmpty();
    
    if(data > 0){
      Joystick_1 = data - 1;
      Joystick_1_X = Joystick_1 >> 16;
      Joystick_1_Y = Joystick_1 & 0x0000ffff;
    }
    else{
      Joystick_2 = - data;
      Joystick_2_X = Joystick_2 >> 16;
      Joystick_2_Y = Joystick_2 & 0x0000ffff;
    }
    //Serial.print("  Joystick_1_X="); Serial.print(Joystick_1_X);Serial.print("  Joystick_1_Y="); Serial.print(Joystick_1_Y);Serial.print("  Joystick_2_X="); Serial.print(Joystick_2_X);Serial.print("  Joystick_2_Y="); Serial.println(Joystick_2_Y);
  }
  
  if(Joystick_1_X > 530){
    k_1 = map(Joystick_1_X, 531, 1023, 0, 100) / 2000.00;
  }
  else if(Joystick_1_X < 470){
    k_1 = map(Joystick_1_X, 0, 469, -100, 0) / 2000.00;
  }
  else{
    k_1 = 0;
  }
  
  if(Joystick_1_Y > 530){
    k_2 = map(Joystick_1_Y, 531, 1023, 0, 100) / 2000.00;
  }
  else if(Joystick_1_Y < 470){
    k_2 = map(Joystick_1_Y, 0, 469, -100, 0) / 2000.00;
  }
  else{
    k_2 = 0;
  }
  
  if(Joystick_2_X > 530){
    k_3 = map(Joystick_2_X, 531, 1023, 0, 100) / 2000.00;
  }
  else if(Joystick_2_X < 470){
    k_3 = map(Joystick_2_X, 0, 469, -100, 0) / 2000.00;
  }
  else{
    k_3 = 0;
  }
  
  if(Joystick_2_Y > 530){
    k_4 = map(Joystick_2_Y, 531, 1023, 0, 100) / 2000.00;
  }
  else if(Joystick_2_Y < 470){
    k_4 = map(Joystick_2_Y, 0, 469, -100, 0) / 2000.00;
  }
  else{
    k_4 = 0;
  }
  
  speed_1 = min(60, max(-60, speed_1 += k_1));
  speed_2 = min(35, max(-35, speed_2 += k_2));
  speed_3 = min(35, max(-35, speed_3 += k_3));
  speed_4 = min(35, max(-35, speed_4 += k_4));
  
  Serial.print("  k_1="); Serial.print(k_1);Serial.print("  k_2="); Serial.print(k_2);Serial.print("  k_3="); Serial.print(k_3);Serial.print("  k_4="); Serial.println(k_4);
  
  servo1.write(speed_1 + 90);
  servo2.write(speed_2 + 90);
  servo3.write(speed_3 + 90);
  servo4.write(speed_4 + 90);
}

