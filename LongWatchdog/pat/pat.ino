
//you dont need to use the dogEnablePin, its optional, 
//by default the dog will operate without this input hooked up.
//set your pot to timeout before 30sec and you will see a reset if not hooked up.

int patPin = A2;
int dogEnablePin = A5; 
int dTime = 10 * 1000; //time delay = 10 seconds..

void setup() {
     Serial.begin(9600);
     pinMode(patPin, OUTPUT); 
     digitalWrite(patPin, HIGH);
     pinMode(dogEnablePin, OUTPUT);
     Serial.println("I am starting up!");
}

void dogEnable(bool enable){
   digitalWrite(dogEnablePin, (enable ? HIGH : LOW) ); 
}

void patDog(){
     digitalWrite(patPin, LOW);
     delay(200);
     digitalWrite(patPin, HIGH);
}

void loop() {
 
     dogEnable(true);
     patDog(); 
     
     Serial.print("Good doggy! now wait for (secs): ");
     Serial.println(dTime/1000);  
     delay(dTime);

     Serial.println("Dog disabled, lets wait 20secs..");
     dogEnable(false);    
     delay(20*1000);
     
     
}
