#include <Servo.h>

Servo myservo;  
int servoPin = 9;
int potPin = A0;
int lastPos=0;

void setup() {
  Serial.begin(9600);
  myservo.attach(servoPin);   
  pinMode(potPin, INPUT);
}

void loop() {
  
    int raw = analogRead(potPin);
    int pos = map(raw, 0, 1023, 0, 180);
    
    Serial.print("Raw: ");
    Serial.print(raw);
    Serial.print(" Mapped: ");    
    Serial.println(pos);
    
    //this helps remove jitter due to analog reads of pot..
    if(abs(pos - lastPos) < 5) return; 
    
    lastPos = pos;    
    myservo.write(pos);               
    delay(100);
  
  
}
