
/*
    
    Example code to add a servo interface to a standard linear actuator
    using a linear pot, L298N driver board, Arduino, and a typical RC Controller
    
    driver board: $7
        https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=L298N
    
    flysky rc controller transmitter and receiver: $50
        https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=fs-t6&rh=i%3Aaps%2Ck%3Afs-t6
    
    linear pot: $10
        https://www.amazon.com/gp/product/B019W8J1XC/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1

    linear actuator: $35
        https://www.amazon.com/gp/product/B00SAXKYPA/ref=oh_aui_detailpage_o07_s03?ie=UTF8&psc=1

*/

#include <stdio.h>

int in1 = 12;
int in2 = 13;
int linearPot = A0;

//the following are ~PWM capable ports 
int enable1 = 11;
int rc_channel3 = 6;


void setup() {
  pinMode(rc_channel3, INPUT);
  pinMode(linearPot, INPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(enable1, OUTPUT);
  Serial.begin(9600);
}

void motorOff(){
    Serial.print("motor OFF");
    digitalWrite(in1, LOW);
    digitalWrite(in2, LOW);
    analogWrite(enable1, 0);
}

/*
    so the rc stick will give us the following: (center range is for dead stick, 0 is controller off)
        rc   |  min  |  max
        -------------------
        up   | 1530  | 2000
        down | 1460  | 1000

    our linear pot will give us readings from 0-1023, since we travel both ways, center pot must be
    center travel. note that we dont go all the way to 0 or 1023 because we could damage the pot with 340lbs of force..
         pot  |  min  |  max
        -------------------
        up   | 513   | 1000
        down | 20    | 512
  

*/

//if we overshoot we just shutoff, we dont try to hone in by reversing 
//direction until perfect..oscillations are worse this isnt exact..
void moveLinearActuatorUntil(int targetPotPos, int rawRCPos){
    
    char buf[255];
    int curPotPos, v1, v2, speed = 255; //full speed 
    int delta = 0;
    bool moveIn;

    curPotPos = analogRead(linearPot);

    if( abs(targetPotPos - curPotPos) <= 40 ){
         Serial.println("position obtained!"); 
         motorOff();  
         return;
    }

    moveIn =  curPotPos > targetPotPos ? true : false;
    v1 = moveIn ? LOW : HIGH;
    v2 = moveIn ? HIGH : LOW;

    while(1){

        int rc3 = pulseIn(rc_channel3, HIGH, 25000);
        curPotPos = analogRead(linearPot);    
        
        //if we lost connection to controller or if user moved joystick > 30 then abort this seek of position..
        if(rc3 == 0 || abs(rawRCPos - rc3) > 30){
            motorOff();
            break;
        }
                
        if(moveIn){
            if( curPotPos <= targetPotPos){
                motorOff();
                break;
            }
        }
        else{
            if( curPotPos >= targetPotPos){
                motorOff();
                break;
            }
        }

        //speed of 50 is to small to move motor just makes it buzz..disabled for now..
        //if( abs(curPotPos - targetPotPos) < 30 ) speed = 125; //drop to 1/4 speed for last bit

        sprintf(buf, "curPos:%d  targetPos: %d  speed:%d   %s", curPotPos, targetPotPos, speed, moveIn ? "moving IN" : "moving OUT"); 
        Serial.println(buf);
  
        digitalWrite(in1, v1);
        digitalWrite(in2, v2);
        analogWrite(enable1, speed);
    }


}

void loop() {
  
  char buf[255];
  int curPotPos = analogRead(linearPot);
  int rc3 = pulseIn(rc_channel3, HIGH, 25000);
  int targetPotPos;

  sprintf(buf, "rc3:%d  curPos:%d  ", rc3, curPotPos); 
  Serial.print(buf);
  
  if(rc3==0){
     motorOff();  
     Serial.println(" no signal");   
  }
  else if(rc3 > 1500){ //stick up
      targetPotPos = map(rc3, 1530, 2000, 513, 1000); //map rc up position to where our slide pot needs to be
      sprintf(buf, "stick up: curPos:%d  targetPos: %d ", curPotPos, targetPotPos); 
      Serial.print(buf);
      moveLinearActuatorUntil(targetPotPos, rc3);
  }
  else{
      targetPotPos = map(rc3, 1460, 1000, 512, 20); //map rc up position to where our slide pot needs to be
      sprintf(buf, "stick down: curPos:%d  targetPos: %d ", curPotPos, targetPotPos); 
      Serial.print(buf);
      moveLinearActuatorUntil(targetPotPos, rc3);
  }
    
  delay(10);
}
