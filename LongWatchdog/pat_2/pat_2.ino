
//this is for code compatiability with 555 based watchdogs such as switchdoc labs
//(I already have projects using this board..)

int EXT_WATCHDOG_PIN = A2;
int dTime = 10 * 1000; //time delay = 10 seconds..

void setup() {
     Serial.begin(9600);
     Serial.println("I am starting up!");
}

void watchdogReset()
{
  pinMode(EXT_WATCHDOG_PIN, OUTPUT);  //analogRead will drop to ~16
  delay(200);
  pinMode(EXT_WATCHDOG_PIN, INPUT);   //analogRead will be ~1000
}

void watchdogDisable()
{
  pinMode(EXT_WATCHDOG_PIN, OUTPUT);
}

void loop() {
     watchdogReset();
     Serial.print("Good doggy! now wait for - Pat meth 2 - (secs): ");
     Serial.println(dTime/1000);  
     delay(dTime);     
}
