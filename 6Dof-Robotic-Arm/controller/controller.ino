#include <Servo.h>

Servo s2;
Servo s3;
Servo s5;

int sp2 = 9;
int sp3 = 10;
int sp5 = 11;

int pp2 = A0;
int pp3 = A1;
int pp5 = A2;

int lastPos2=0;
int lastPos3=0;
int lastPos5=0;

int bias[7] = {0,0,-20,0,0,0,0};


void setup() {
  Serial.begin(9600);
  s2.attach(sp2);
  s3.attach(sp3);
  s5.attach(sp5);
  pinMode(pp2, INPUT);
  pinMode(pp3, INPUT);
  pinMode(pp5, INPUT);
}

void loop() {
  
    int raw2 = analogRead(pp2);
    int raw3 = analogRead(pp3);
    int raw5 = analogRead(pp5);
    
    int pos2 = map(raw2, 0, 1023, 180, 0);
    int pos3 = map(raw3, 0, 1023, 0, 180);
    int pos5 = map(raw5, 0, 1023, 0, 180);
    
    bool moveit = false;
    //this helps remove jitter due to analog reads of pot..
    if(abs(pos2 - lastPos2) > 2) moveit = true;
    if(abs(pos3 - lastPos3) > 2) moveit = true;
    if(abs(pos5 - lastPos5) > 2) moveit = true; 
    
    if(!moveit) return;
    
    dbg(2,raw2,pos2);
    dbg(3,raw3,pos3);
    dbg(5,raw5,pos5);
    Serial.println();
    
    lastPos2 = pos2;
    lastPos3 = pos3;
    lastPos5 = pos5;
    
    s2.write(pos2-20); 
    s3.write(pos3-12); 
    s5.write(pos5); 
    
    //delay(800);
  
  
}


void dbg(int index, int raw, int pos){
    
    Serial.print(index);
    Serial.print(") ");
    Serial.print("Raw: ");
    Serial.print(raw);
    Serial.print(" Mapped: ");    
    Serial.println(pos); 
  
}
