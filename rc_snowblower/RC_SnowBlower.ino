
#include "RCMotor.h"

/*
    the sabertooth automatically handles the main motors signals direct from receiver
    
    this code will handle the chute and actuator motor signals by reading the receiver
    and then controlling the motors through an L298N driver board. This is handled simply
    through the RCMotor class. We do not use speed control on either of these aux DC motors. 
    
    A two relay board (both controlled by same pin) controls two additional things. 
       1) a large solid state relay that gives power to the sabertooth as a backup safety measure, and 
       2) the gas engine kill switch. 
       
    Both of these will be shut off instantly if the arduino can not detect any RC signal 
    (ie Transmittor is off or signal has been lost)
*/

int relayPin = 4;
RCMotor chute(12,13,6,0);
RCMotor actuator(7,8,3,0);

void activateRelay(bool on){
    digitalWrite(relayPin, (on ? LOW : HIGH) );
    if(chute.debug){ Serial.print(" relayOn: "); Serial.println(on); }  
}

void setup() {
  Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
  activateRelay(false); 
  chute.debug = true;
  actuator.debug = true;
  actuator.deadZone = 100; 
}

void loop(){
      
      if( chute.receivingSignal() ){
            chute.process();
	    actuator.process();
            activateRelay(true); 
      }else{
          chute.motorOff();
          actuator.motorOff();
          activateRelay(false); 
      }
      
      if(chute.debug) delay(500);
      
      
}
