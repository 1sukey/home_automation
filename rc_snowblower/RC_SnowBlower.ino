
/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

    the sabertooth automatically handles the main motors signals direct from receiver
    
    this code will handle the chute and actuator motor signals by reading the receiver
    and then controlling the motors. If you are using a L298N driver board use RCMotor.h
	I upgraded to a 15a driver board amazon part number B01GHKO5O8.

	This is handled simply through the RCMotor class. We do not use speed control on 
	either of these aux DC motors and just set the const speed.
    
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

#include "RCMotor2.h"
#include "RCSwitch.h"

int relayPin = 4;
bool debugMode = false;
RCMotor2 chute(12,11,6);    //chute rotation rc channel 4
RCMotor2 actuator(8,9,3); //blower cutting edge height rc channel 3
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
      
      if(debugMode) delay(1500);
      
      
}
