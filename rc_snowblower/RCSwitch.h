/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

        This is a small class that will read a switch signal from an RC receiver.
*/

#import <Arduino.h>

class RCSwitch {

    private:
         int rcPin = 0;
         const int quarterSecond = 250000; //250ms in micro seconds 
         
    public:
         bool debug = false;
    	 uint32_t lastReadTime = 0;
         int lastSignal = -1;
         int readInterval = 300;
         
        //must be a PWM capable pin..
      	RCSwitch(int rc_pin){
    	    rcPin = rc_pin;
    	    pinMode(rcPin, INPUT);
    	}
        
        //experimenting with a slight cache since pulseIn can cause a delay and we may read it 2x in quick succession..
        //i rather use two bool functions instead of return an enum value of isOn, isOff, isDown
        int readSignal(){
             uint32_t now = millis();
             bool tookReading = false;
             if(lastReadTime == 0 || (now - lastReadTime) > readInterval){ 
                 lastSignal = pulseIn(rcPin, HIGH, quarterSecond); 
                 tookReading = true;
             }
             if(debug){ 
                  if(lastReadTime == 0) Serial.print("*");
                  Serial.print("RCSwitch_"); Serial.print(rcPin); 
                  Serial.print(" Val: "); Serial.print(lastSignal); 
                  Serial.print(" Time: "); Serial.println(lastReadTime);
             }
             if(tookReading) lastReadTime  = millis();
             return lastSignal;
         }
         
        bool receivingSignal(){
           if( readSignal() == 0) return false;
           return true;
        }
        
        bool isOn(){
            if(!receivingSignal()) return false;
            return (lastSignal > 1300) ? true : false; 
        }

};
