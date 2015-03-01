
  /*
    Copyright David Zimmer <dzzie@yahoo.com> All rights reserved
    this software is free for personal use.
    If you would like to to use this commercially, please consider a paypal donation
    in respect for my time creating it.
   
    Notes: 
       * stepper control board used: 
            SainSmart CNC Router Single 1 Axis 3.5A TB6560 Stepper Stepping Motor Driver Board WL ($20)
            http://www.amazon.com/gp/product/B008BGLOTQ/ref=oh_aui_detailpage_o09_s00?ie=UTF8&psc=1
    
       * the home button just reverses the number of cycles run. It does not know about full revolutions
       
       * I used to switches on the case, one for enable which just used an input on the stepper board, 
            and one for jog mode which toggles the functionality of the next and back buttons. there is
            also a momentary home button on the case.
            
       * the next and back buttons are on a hand control they are momentary. In normal mode they make it
            increment to the next position as configured in the VB app
            
       * you have to use the VB app to initially configure it every run. It does the math calculations
            based on your rotary table specifications and number of divisions you wish to use. It feeds
            this Arduino sketch the calculated step count and specified delay over the serial port.
            
       * there is the capability to trigger external automation once an index position is reached
            through the external trigger pin. It will go high when the table reaches the next position.
            This event will not be triggered in jog mode, or when the table is seeking home.
            
       * every time you position the table with the jog mode it will reset the home position automatically.
            
       * all buttons are normally high using the internal pull-up resistors. They do not need to be Debounced
            because internal delays in the code account for this. When they go to ground they are pressed.
                       
      2.24.15 - added gotoPos feature + curPos feedback in serialOut for gui
      3.02.15 - if not configured by pc it will operate in jog mode when buttons pushed 
      
      
  */
  
  
  int externalTriggerPin = 3; //in case you want to integrate another device to run every time a cycle completes.
                              //this pin is normally low, and will go high once a cycle completes.
 
  int pulsePin = 8;       //to advance stepper  
  int dirPin = 9;         //default = low                  
  int nextButtonPin = 10; //we support pendependent with two buttons, a forward and reverse
  int backButtonPin = 11; // if jog mode switch is on, then they act as jog instead of index
  int jogModePin = 12;    //switch 
  int HomePin = 13;       //button
  
  int steps = 0;          //the number of steps the VB app configures us to run per cycle
  int delay_ms = 0;       //the delay that the VB app figures us to wait per cycle
  int cycles = 0;         // the number of cycles that we have run, tracked internally, for home functionality.
  
  void setup()
  {
        pinMode(pulsePin, OUTPUT);
        pinMode(dirPin, OUTPUT);
        pinMode(externalTriggerPin, OUTPUT);
        
        pinMode(nextButtonPin, INPUT_PULLUP);
        pinMode(backButtonPin, INPUT_PULLUP);
        pinMode(jogModePin, INPUT_PULLUP);
        pinMode(HomePin, INPUT_PULLUP);
        
        digitalWrite(pulsePin, 0);
        digitalWrite(externalTriggerPin, 0);
        digitalWrite(dirPin, 0);
        
        Serial.begin(9600);
 }
     
 void loop()
 {
      
      int v1, v2;   
             
      if (Serial.available())
      {       
          //expected input format is steps,delayms  eg: 200,1
          //must configure the Arduino at least once from the PC app before using the physical "next" button
          
          v1 = Serial.parseInt();
          v2 = Serial.parseInt();
          while( Serial.available() ) Serial.read(); //clear any remaining chars from buffer...
          
          if(v1 == 32666){ //magic value telling us to go to position v2
              gotoPos(v2);
          }else{
              cycles = 0; //this is our new home position
              steps = v1;
              delay_ms = v2;
              msg("configured + zero!");
          }
          
      }
      else
      {

         if(digitalRead(HomePin) == LOW){ 
             if(cycles < 0){
                  cycles = cycles * -1;
             }else{
                  digitalWrite(dirPin, 1);
             }
             while(cycles--) runCycle(0); 
             digitalWrite(dirPin, 0);
             cycles = 0;
             msg("home");
             return;
         }
         
         if(digitalRead(nextButtonPin) == LOW){ 
             if(digitalRead(jogModePin) == LOW || steps == 0){
                 cycles = 0; //this is our new home position
                 msg("jog + zero");
                 while( digitalRead(nextButtonPin) == LOW )
                 {
                     digitalWrite(pulsePin, 1);
                     delay(1); 
                     digitalWrite(pulsePin, 0); 
                     delay(1);
                 }
                 return;
             }else{
               cycles++;
               runCycle(1);
               delay(100);  
             }
         } 
         
         if(digitalRead(backButtonPin) == LOW){ 
             digitalWrite(dirPin, 1);
             
             if(digitalRead(jogModePin) == LOW || steps == 0){
                 cycles = 0; //this is our new home position
                 msg("jog(R) + zero");
                 while( digitalRead(backButtonPin) == LOW )
                 {
                     digitalWrite(pulsePin, 1);
                     delay(1); 
                     digitalWrite(pulsePin, 0); 
                     delay(1);
                 }
             }else{ 
                 cycles--;
                 runCycle(1);
                 delay(100);  
             }
             
             digitalWrite(dirPin, 0);
         } 
      }
      
        
 }
 
 void gotoPos(int index){
   
       int delta = 0;
   
       if(steps == 0){
          msg("not configured!");
          return;
       }  
       
       if(cycles > index){ //already passed it...so reverse
             digitalWrite(dirPin, 1);
             delta = cycles - index; 
       }else{           
             delta = index - cycles;     
       }
       while(delta--) runCycle(0); 
       digitalWrite(dirPin, 0);
       cycles = index;
       msg("gotoPos");
            
 }
 
 void msg(char* x){ 
   char buf[200];
   sprintf(buf, "%s [pos:%d]\n", x, cycles);
   Serial.print(buf);
 }
 
 void runCycle(int extTrigger)
 {
   
       if(steps == 0){
          msg("not configured!");
          return;
       }
       
       for(int i = 0; i < steps; i++){
           digitalWrite(pulsePin, 1);
           delay(1); 
           digitalWrite(pulsePin, 0);
           delay(delay_ms); 
        }
        
        if(extTrigger == 1){
            digitalWrite(externalTriggerPin, 1);
            delay(400); 
            digitalWrite(externalTriggerPin, 0);
            msg("complete + trigger");
        }else{
            msg("complete");
        }
   
 }
