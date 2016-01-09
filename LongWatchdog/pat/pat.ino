
int patPin = A2;
int dTime = 10 * 1000; //time delay = 10 seconds..

void setup() {
     Serial.begin(9600);
     pinMode(patPin, OUTPUT); 
     digitalWrite(patPin, HIGH);
     Serial.println("I am starting up!");
}

void patDog(){
     digitalWrite(patPin, LOW);
     delay(10);
     digitalWrite(patPin, HIGH);
}

void loop() {
 
     patDog(); 
     Serial.print("Good doggy! now wait for (secs): ");
     Serial.println(dTime/1000);  
    
     delay(dTime);
     
     
}
