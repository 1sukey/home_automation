
/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

    the sabertooth automatically handles the main motors signals direct from receiver
    
    this code will handle the chute and actuator motor signals by reading the receiver
    and then controlling the motors through an L298N driver board. This is handled simply
    through the RCMotor class. We do not use speed control on either of these aux DC motors. 
    
    A two relay board (both controlled by same pin) controls two additional things. 
       1) a large solid state relay that gives power to the sabertooth as a backup safety measure, and 
       2) the gas engine kill switch. 
       
    Both of these will be shut off instantly if the arduino can not detect any RC signal 
    (ie Transmittor is off or signal has been lost)

    Note: I am also thinking of adding an xbee module which controls a relay that connects the power
	  to the main relay board as an out of band emergency shutoff. We could also require it to receive
	  a heart beat message. A 280lb robot with a gas powered auger on the front of it is a fairly dangerous
	  contraption if something went haywire.
    
    Note2: right now we are using one of the rc switches on channel 5/pin 5 to enable/disable the
          actuator joystick so we dont accidently tweak it while running..in the future if we add
          a motor to the chute end deflector, this switch will then toggle that joysticks function
          between the two.
          
*/

#include "RCMotor.h"
#include "RCSwitch.h"

int relayPin = 4;
bool debugMode = false;
RCMotor chute(12,13,6,0);  //chute rotation rc channel 4
RCMotor actuator(7,8,3,0); //blower cutting edge height rc channel 3
RCSwitch rc_switch(5);     //rc channel 5

void activateRelay(bool on){
    digitalWrite(relayPin, (on ? LOW : HIGH) );
    if(debugMode){ Serial.print(" relayOn: "); Serial.println(on); }  
}

void setup() {
  Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
  activateRelay(false); 
  chute.debug = debugMode;
  actuator.debug = debugMode;
  rc_switch.debug = debugMode;
  actuator.deadZone = 100; 
}

void loop(){
      
      if( chute.receivingSignal() ){
            chute.process();
	    rc_switch.isOn() ? actuator.process() : actuator.motorOff();
            activateRelay(true); 
      }else{
          chute.motorOff();
          actuator.motorOff();
          activateRelay(false); 
      }
      
      if(debugMode) delay(500);
      
      
}
