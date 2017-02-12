
/*
    
    Example code to add a servo interface to a standard linear actuator
    using a linear pot, L298N driver board, Arduino, and a typical RC Controller
    
    two things to verify before you run this..
      1) that stick up makes the actuator travel out
      2) that the pot increases in resistance (higher number) as it travels out
    
    these can be easily reversed if your wires are flipped. you will destroy your pot 
    if the readings are backwards.
    
    materials:
    ---------------------------------------------------------------------------------------
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

//if we overshoot we just shutoff, we dont try to hone in by reversing 
//direction until perfect..oscillations are worse this isnt exact..
void moveLinearActuatorUntil(int targetPotPos, int rawRCPos){
    
    char buf[255];
    int speed = 255; //full speed 

    if(rawRCPos == 0){
       motorOff();  
       Serial.println(" no signal");   
       return;
    }
  
    int curPotPos = analogRead(linearPot);

    if( abs(targetPotPos - curPotPos) <= 25 ){  //any less and we can get seeking
         Serial.println("position obtained!"); 
         motorOff();  
         return;
    }

    bool moveIn =  curPotPos > targetPotPos ? true : false;
    int v1 = moveIn ? LOW : HIGH;
    int v2 = moveIn ? HIGH : LOW;

    while(1){

        int rc3 = pulseIn(rc_channel3, HIGH, 25000);
        curPotPos = analogRead(linearPot);    
        
        //if we lost connection to controller or if user moved joystick then abort this seek of position..
        if(rc3 == 0 || abs(rawRCPos - rc3) > 10){ //how sensitive do you want it to changes in stick position?
            motorOff();
            break;
        }
                
        if(moveIn){
            if( curPotPos <= targetPotPos){ motorOff(); break; }
        }
        else{
            if( curPotPos >= targetPotPos){ motorOff(); break; }
        }

        //try to slow speed for last bit to increase precision without overshoot/seeking
        //if speed is to small motor will just buzz and not move :-\
        //150 has a buzz..not sure if this extra complexity really helps precision...
        if( abs(curPotPos - targetPotPos) < 25 ) speed = 180; 

        sprintf(buf, "curPos:%d  targetPos: %d  speed:%d   %s", curPotPos, targetPotPos, speed, moveIn ? "moving IN" : "moving OUT"); 
        Serial.println(buf);
  
        digitalWrite(in1, v1);
        digitalWrite(in2, v2);
        analogWrite(enable1, speed);
    }

    motorOff(); 

}

void loop() {
  
  char buf[255]; 
  int curPotPos = analogRead(linearPot);
  int rc3 = pulseIn(rc_channel3, HIGH, 25000);
  int targetPotPos = map(rc3, 1000, 2000, 20, 1000); //map rc stick position to target slide pot value
  
  sprintf(buf, "rc3:%d  curPos:%d  targetPos: %d  stick: %s", rc3, curPotPos, targetPotPos, rc3 > 1500 ? "UP" : "DOWN"); 
  Serial.print(buf);

  moveLinearActuatorUntil(targetPotPos, rc3);
 
  delay(10);
}
