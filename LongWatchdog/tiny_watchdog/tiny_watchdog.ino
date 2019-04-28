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
      
      if it detects the pot value has changed (potChangeDetect var) then it will
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
                30 = 9     -> 90sec  (1.5 min) <--
      internal pull up resistors on inputs 
      
      Note: i removed the external jumper for time multipler. I rather use the pin
            as an enable/disable line..see old commits if you prefer.
   
*/

int potPin = 3;    
int bitePin = 2;   
int enablePin = 4;
int patPin = 1;
int ledPin = 0;
int potChangeDetect = 60; //amount of change required to trigger pot changed blink code (0-1023)
int lastJumper;
unsigned long lastRawVal=0;

void setup() {
  
  pinMode(ledPin, OUTPUT);
  pinMode(bitePin, OUTPUT);
  digitalWrite(bitePin, HIGH);     //avoid reset
  digitalWrite(ledPin, LOW);       
  
  pinMode(enablePin, INPUT_PULLUP); 
  pinMode(patPin, INPUT_PULLUP); 
  
  lastRawVal = analogRead(potPin);
  delay(400); //time for main arduino to power up..
}

void loop() {

  digitalWrite(bitePin, HIGH);     //avoid reset
  
  //do nothing until enable goes HIGH (default due to pullup if unused)
  //should I show a blink code when entering or while in this hang mode?
  //in my use it will be here most of the time actually...
  while( digitalRead(enablePin) == LOW ) delay(500); 
  
  unsigned long i=0;
  unsigned long multiplier = 30;
  unsigned long val = analogRead(potPin);    // read the value from the sensor
  
  uint8_t changed = (abs(lastRawVal - val) > potChangeDetect) ? 1 : 0; //did they change the pot value since last time?
  if(changed) lastRawVal = val ;
  
  val += 300;                              //skew to put in our desired time slot range (and avoid 0)
  val *= multiplier;
     
  if(changed){
      delay(500);
      for(uint8_t j=0; j<5; j++){ blinkFor(50); delay(50); }
      delay(300);
      blinkFor(val);
      delay(500);
      //since we ate up a bunch of time..should we hang here until next pat to sync?
  } 
  
  for(i=0; i <= val; i++){
     
     if( digitalRead(enablePin) == LOW ) break;
     
     if( digitalRead(patPin) == LOW ){  //pat received - seems to work with both both digitalWrite(LOW) and pinMode(OUTPUT) type pats
         blinkFor(100); 
         break;
     }else if(i==val){
        digitalWrite(bitePin, LOW);     //reset time!, goes high next loop start..
        for(uint8_t j=1; j<=2; j++){ blinkFor(400); delay(400); } 
        break;
     }
     
     delay(1);
  } 
  
    
}

void blinkFor(unsigned int x){
      digitalWrite(ledPin, HIGH);
      delay(x);
      digitalWrite(ledPin, LOW);  
}
