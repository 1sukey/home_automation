/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

        This is a small class that will read a signal from an RC receiver and then control
	a DC motor through an HBridge driver board. Supports forward and reverse and optional
	speed control. See amazon listing B01GHKO5O8 for the board this was designed for:
	3-36v, 15amp - 30amp peak

	pulseIn 250ms timeout is suitable for out needs no need for the complexity of interrupts.
	
	http://rcarduino.blogspot.com/2012/01/how-to-read-rc-receiver-with.html
	
	driver board: $25
	    https://www.amazon.com/gp/product/B01GHKO5O8/ref=oh_aui_search_detailpage?ie=UTF8&psc=1

*/

#import <Arduino.h>

class RCMotor2 {

    private:
        int p1;      //digital pin
        int rcPin=0; //must be a PWM capable pin
        int speedPin = 0;  //speed control, must be a pwm pin
        const int centerStick = 1300;
        const int quarterSecond = 250000; //250ms in micro seconds 
    
    public:
        bool debug = false;
        uint8_t deadZone = 35;     //how much of a dead zone to give centered stick
	uint8_t constSpeed = 0;    //value 0-255
 	uint32_t lastReadTime = 0;
        int lastSignal = -1;
        int readInterval = 300;    //the caching mechanism might just be bloat..remove?

    	//dir_pin1 is the direction control pin, must be digital pins
    	//rc_pin is the pin to read the rc control signal from, MUST be a PWM capable pin
    	//speed_pin MUST be a PWM capable pin
    	//to reverse the motor relative to joystick swap +/- wires to motor
    	RCMotor2(int dir_pin1, int speed_pin, int rc_pin){
    	    p1   = dir_pin1;
    	    rcPin = rc_pin;
            speedPin = speed_pin;
    	    pinMode(rcPin, INPUT);
    	    pinMode(p1, OUTPUT);
    	    pinMode(speedPin, OUTPUT);
    	}
        
        int readSignal(){
             uint32_t now = millis();
             bool tookReading = false;
             if(lastReadTime == 0 || (now - lastReadTime) > readInterval){ 
                 lastSignal = pulseIn(rcPin, HIGH, quarterSecond); 
                 tookReading = true;
                 if(debug) Serial.print("Read! ");
             }
             if(debug){ 
                  if(lastReadTime == 0) Serial.print("*");
                  Serial.print("RCMotor_"); Serial.print(rcPin); 
                  Serial.print(" Val: "); Serial.print(lastSignal); 
                  Serial.print(" Time: "); Serial.println(lastReadTime);
             }
             if(tookReading) lastReadTime  = millis();
             return lastSignal;
         }
         
    	void motorOff(){ //cache motor state to avoid needless writes?
	    if(debug){ Serial.print(" motor OFF rcPin: "); Serial.print(rcPin); }
            analogWrite(speedPin, 0);
    	}
    
    	~RCMotor2(){motorOff();}
    
        bool receivingSignal(){
           if( readSignal() == 0) return false;
           return true;
        }
                
    	void process(){
    
    		  int rv = readSignal();
    		  
    		  int pwm = 0;
    		  int minRight = centerStick + deadZone;
    		  int minLeft = centerStick - deadZone;
    
    		  if(debug){
    			  Serial.print(" rcPin: "); Serial.print(rcPin); Serial.print(" rawVal: "); Serial.print(rv);
    		  }
    		  
    		  if(rv==0){
    			  if(debug) Serial.print(" no signal ");
    			  motorOff();
    		  }
    		  else if(rv > minRight){
    			  digitalWrite(p1, LOW);
		          if(debug) Serial.print(" stick Up|Right ");
		          if(constSpeed != 0) pwm = constSpeed; else pwm = map(rv, minRight, 1800, 0, 254); //map our speed to 0-255 range
			  analogWrite(speedPin, pwm);
			  if(debug){ Serial.print(" speed: "); Serial.println(pwm);}
			   
    		  }
    		  else if(rv < minLeft){
    			  digitalWrite(p1, HIGH);
			  if(debug) Serial.print(" stick Down|Left ");
			  if(constSpeed != 0) pwm = constSpeed; else pwm = map(rv, minLeft, 800, 0, 254); //map our speed to 0-255 range
			  analogWrite(speedPin, pwm);
			  if(debug){ Serial.print(" speed: "); Serial.println(pwm);}
    		  }else{
    			  if(debug) Serial.print(" stick centered ");
    			  motorOff();
    		  }
    
              if(debug) Serial.print("\n");
    		  
    	}

};
