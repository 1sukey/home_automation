/* 
   Author:      David Zimmer 
   Date:        1.9.16 
   Description: ATTiny85 external long watchdog timer
   License:     BSD License
   Binary size: 1,584 bytes (of a 8,192 byte maximum)
   
   behavior:
      you adjust the watchdog timeout with the onboard pot.
      default time range is 3 -> 30 seconds.
      
      if you connect physical pin 3 to ground, this acts as a time multiplier 
      extending its range to now be 15 sec -> 2.5 minutes
      
      if it detects the pot value has changed (by at least 20) then it will
      flash the led 4 times quickly, followed by an led on duration of the real
      time value it will use before it resets the parent arduino.
      
      everytime it receives a pat, the led will give a brief flicker
      if it has to reset the arduino it will do so then give two slow flashs to led

   ATTiny Programming:
     how to wire an Arduino as an ISP programmer for ATTiny   
       http://highlowtech.org/?p=1706
     
         (note setup two areas on your breakboard, one for programming, 
          and one for the test circuit. move the chip between the two)
     
     how to install ATTiny85 board support in Arduino IDE:
       http://highlowtech.org/?p=1695

   misc:
      reading pot between 0 and 1024
      (x+300) * 10 = 3sec  -> 30sec  default multiplier
      (x+300) * 50 = 15sec -> 150sec (2.5min)
      internal pull up resistors on inputs 
   
*/

int potPin = 3;    // select the input pin for the potentiometer
int bitePin = 2;   
int multPin = 4;
int patPin = 1;
int ledPin = 0;
uint8_t lastJumper;
unsigned long lastRawVal=0;

void setup() {
  
  pinMode(ledPin, OUTPUT);
  pinMode(bitePin, OUTPUT);
  digitalWrite(bitePin, HIGH);     //avoid reset
  digitalWrite(ledPin, LOW);       
  
  pinMode(multPin, INPUT_PULLUP); 
  pinMode(patPin, INPUT_PULLUP); 
  
  lastJumper = digitalRead(multPin); //initial readings 
  lastRawVal = analogRead(potPin);
  delay(400); //time for main arduino to power up..
}

void loop() {

  digitalWrite(bitePin, HIGH);     //avoid reset
  
  unsigned long i=0;
  unsigned long multiplier = 10;
  unsigned long val = analogRead(potPin);    // read the value from the sensor
  
  uint8_t changed = (abs(lastRawVal - val) > 20) ? 1 : 0; //did they change the pot value since last time?
  if(changed) lastRawVal = val ;
  
  val += 300;                              //skew to put in our desired time slot range (and avoid 0)

  uint8_t curJumper = digitalRead(multPin);
  if( curJumper == LOW ) multiplier = 50;
  
  if(curJumper != lastJumper){             //they changed the jumper time delay since we last checked..
      changed = true;
      lastJumper = curJumper;
  }
      
  val *= multiplier;
  
  if(changed){
      delay(300);
      for(uint8_t j=0; j<5; j++){ blinkFor(50); delay(50); }
      delay(300);
      blinkFor(val);
      delay(300);
  } 
  
  for(i=0; i <= val; i++){
     if( digitalRead(patPin) == LOW ){  //pat received
         blinkFor(100); 
         break;
     }else if(i==val){
        digitalWrite(bitePin, LOW);     //reset time!
        delay(10);
        digitalWrite(bitePin, HIGH);
        for(uint8_t j=1; j<=2; j++){ blinkFor(400); delay(400); } 
     }
     delay(1);
  } 
  
    
}

void blinkFor(unsigned int x){
      digitalWrite(ledPin, HIGH);
      delay(x);
      digitalWrite(ledPin, LOW);  
}
