//example program to control a 6 axis servo based robotic arm 
//using 6 potentiomenters and an arduino uno. In my build the pots
//arm built into a 1:1 scale model of the arm, so the arm moves exactly
//as i move the model.
//
//Author:  David Zimmer <dzzie@yahoo.com> 
//Site:    http://sandsprite.com
//license: BSD

#include <Servo.h>

Servo s1;  //base rotation
Servo s2;  //lower arm joint
Servo s3;  //upper arm joint
Servo s4;  //upper arm rotation
Servo s5;  //wrist
Servo s6;  //hand rotation

//servo pins
int sp1 = 3;
int sp2 = 5;
int sp3 = 6;
int sp4 = 9;
int sp5 = 10;
int sp6 = 11;

//pot pins
int pp1 = A0;
int pp2 = A1;
int pp3 = A2;
int pp4 = A3;
int pp5 = A4;
int pp6 = A5;

int lastPos1=0;
int lastPos2=0;
int lastPos3=0;
int lastPos4=0;
int lastPos5=0;
int lastPos6=0;

//                    x, 1,  2,   3,  4, 5, 6
int calibration[7] = {0, 0, -20, -12, 0, 0, 0};
bool moved = false;

void setup() {
  Serial.begin(9600);
  s1.attach(sp1);
  s2.attach(sp2);
  s3.attach(sp3);
  //s4.attach(sp4);
  s5.attach(sp5);
  //s6.attach(sp6);

  pinMode(pp1, INPUT);
  pinMode(pp2, INPUT);
  pinMode(pp3, INPUT);
  //pinMode(pp4, INPUT);
  pinMode(pp5, INPUT);
  //pinMode(pp6, INPUT);

}

void loop() {
    
	moved = false;
	int raw1 = analogRead(pp1);
    int raw2 = analogRead(pp2);
    int raw3 = analogRead(pp3);
	//int raw4 = analogRead(pp4);
    int raw5 = analogRead(pp5);
	//int raw6 = analogRead(pp6);
    
	int pos1 = map(raw1, 0, 1023, 0, 180);
    int pos2 = map(raw2, 0, 1023, 180, 0); //note i accidently swapped which side my +/- were on so I have to swap the mapping..(arm was acting in reverse of my motion)
    int pos3 = map(raw3, 0, 1023, 0, 180);
	//int pos4 = map(raw4, 0, 1023, 0, 180);
    int pos5 = map(raw5, 0, 1023, 0, 180);
	//int pos6 = map(raw6, 0, 1023, 0, 180);
    
	if(abs(pos1 - lastPos1) > 2) doMove(1, &s1, pos1, raw1, &lastPos1);
    if(abs(pos2 - lastPos2) > 2) doMove(2, &s2, pos2, raw2, &lastPos2);
    if(abs(pos3 - lastPos3) > 2) doMove(3, &s3, pos3, raw3, &lastPos3);
	//if(abs(pos4 - lastPos4) > 2) doMove(4, &s4, pos4, raw4, &lastPos4);
    if(abs(pos5 - lastPos5) > 2) doMove(5, &s5, pos5, raw5, &lastPos5);
	//if(abs(pos6 - lastPos6) > 2) doMove(6, &s6, pos6, raw6, &lastPos6);

    if(moved) Serial.println();
      
    //delay(800);
  
  
}

void doMove(int index, Servo *s, int pos, int raw, int *lastPos){
	
	dbg(index,raw,pos);
	*lastPos = pos;
	s->write(pos + calibration[index]);
	moved = true;
}


void dbg(int index, int raw, int pos){
    
    Serial.print(index);
    Serial.print(") ");
    Serial.print("Raw: ");
    Serial.print(raw);
    Serial.print(" Mapped: ");    
    Serial.println(pos); 
  
}
