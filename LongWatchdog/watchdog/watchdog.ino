//reading pot between 0 and 1024
//now we need multiplier jumpers
//(x+300) * 10 = 3sec  -> 30sec  default multiplier
//(x+300) * 50 = 15sec -> 150sec (2.5min)
//pull down resistors on both jumpers.. INPUT_PULLUP (looks supported on attiny85)

/*
   Sketch uses 3,258 bytes (10%) of program storage space. Maximum is 32,256 bytes.
   Global variables use 240 bytes (11%) of dynamic memory, leaving 1,808 bytes for local variables. Maximum is 2,048 bytes.
*/

int potPin = A0;    // select the input pin for the potentiometer
int bitePin = 13;   // select the pin for the LED / BITE
int multPin = 10;
int patPin = 4;

void setup() {
  
  pinMode(bitePin, OUTPUT);
  digitalWrite(bitePin, HIGH);     //avoid reset
  
  Serial.begin(9600);
  pinMode(multPin, INPUT_PULLUP); 
  pinMode(patPin, INPUT_PULLUP); 

  delay(400); //time for main arduino to power up..
}

void loop() {

  digitalWrite(bitePin, HIGH);     //avoid reset
  
  unsigned int val = analogRead(potPin);    // read the value from the sensor
  Serial.println(val);
  val += 300;                      //skew to put in our desired time slot range (and avoid 0)
  
  if( digitalRead(multPin) == LOW ) val*=50; else val*=10;
  
  Serial.print("delay this loop is secs: ");
  int secs = val/1000;
  Serial.println(secs);
  
  int i=0;
  for(i=0; i <= val; i++){
     if( digitalRead(patPin) == LOW ){
         Serial.println("Good boy!"); 
         break;
     }else if(i==val){
        Serial.println("Reset Time!");
        digitalWrite(bitePin, LOW);     //reset time! LED OFF
        delay(10);
        digitalWrite(bitePin, HIGH);
     }
     delay(1);
  } 
  
  delay(400); //debounce delay for the 10ms pat
  
}
