
  /*
	Copyright David Zimmer <dzzie@yahoo.com> All rights reserved
	this software is free for personal use.
	If you would like to to use this commercially, please consider a paypal donation
	in respect for my time creating it.
  */
 
  //using one of these to control stepper:
  //  SainSmart CNC Router Single 1 Axis 3.5A TB6560 Stepper Stepping Motor Driver Board WL ($20)
  //  http://www.amazon.com/gp/product/B008BGLOTQ/ref=oh_aui_detailpage_o09_s00?ie=UTF8&psc=1
 
  int dirPin = 8;
  int pulsePin = 9;                            
  int nextButtonPin = 10; //we support pendependent with two buttons, a forward and reverse
  int backButtonPin = 11;
  int externalTriggerPin = 12; //in case you want to integrate another device to run every time a cycle completes.
                              //this pin is normally low, and will go high once a cycle completes.
  
  int steps = 0;
  int delay_ms = 0;
  int dirVal = 0;

  void setup()
  {
        pinMode(pulsePin, OUTPUT);
        pinMode(dirPin, OUTPUT);
        pinMode(externalTriggerPin, OUTPUT);
        pinMode(nextButtonPin, INPUT_PULLUP);
        pinMode(backButtonPin, INPUT_PULLUP);
        
        digitalWrite(pulsePin, 0);
        digitalWrite(externalTriggerPin, 0);
        
        Serial.begin(9600);
 }
     
 void loop()
 {

      if (Serial.available())
      {       
          //expected input format: 200,1,1\n
          //must configure the Arduino at least once from the PC app before using the physical "next" button
          
          steps = Serial.parseInt();
          delay_ms = Serial.parseInt();
          dirVal = Serial.parseInt();    //clockwise = 0
          
          dirVal = constrain(dirVal, 0, 1);
          digitalWrite(dirPin, dirVal);
          
          //if (Serial.read() == '\n') runCycle();
          while( Serial.available() ) Serial.read(); //clear any remaining chars from buffer...
          Serial.print("[configured!]\n");
          
      }
      else
      {
        //normally high with internal pullup. no need to debounce because of built in delay
         
         if(digitalRead(nextButtonPin) == LOW){ 
             runCycle();
             delay(100);  
         } 
         
         if(digitalRead(backButtonPin) == LOW){ 
             int backDir = dirVal == 0 ? 1 : 0;
             digitalWrite(dirPin, backDir);
             runCycle();
             digitalWrite(dirPin, dirVal);
             delay(100);  
         } 
      }
      
        
 }
 
 void runCycle()
 {
   
       if(steps == 0){
          Serial.print("[not configured!]\n");
          return;
       }
       
       for(int i = 0; i < steps; i++){
           digitalWrite(pulsePin, 1);
           delay(1); 
           digitalWrite(pulsePin, 0);
           delay(delay_ms); 
        }
        
        digitalWrite(externalTriggerPin, 1);
        delay(400); 
        digitalWrite(externalTriggerPin, 0);
        
        Serial.print("[complete]\n");
   
 }
