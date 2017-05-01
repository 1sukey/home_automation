/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

        This is a small class that will read a signal from an RC receiver and then control
	a DC motor through an L298N driver board. Supports forward and reverse and optional
	speed control.

	driver board: $7
	    https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=L298N
	
	flysky rc controller transmitter and receiver: $50
	    https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=fs-t6&rh=i%3Aaps%2Ck%3Afs-t6
	
	video overview:
	    https://www.youtube.com/watch?v=v_N5HmXmDyk&feature=youtu.be

	example usage:
	
		#include <RCMotor.h>

		RCMotor rc1(12,13,3,11);

		void setup() {
		  //rc1.debug = true;
		  //rc1.deadZone = 100; //default of 35 is fine..
		  Serial.begin(9600);
		}

		void loop(){
			rc1.process();
		}


*/

#import <Arduino.h>

class RCMotor {

    private:
        int p1;      //digital pin
        int p2;      //digital pin
        int rcPin=0; //must be a PWM capable pin
        int speedPin = 0;  //speed control optional, must be a pwm pin
    
    public:
        int deadZone = 35; //how much of a dead zone to give centered stick
        bool debug = false;
    	
    	//dir_pin1/2 is the direction control pins, must be digital pins
    	//rc_pin is the pin to read the rc control signal from, MUST be a PWM capable pin
    	//speed_pin is optional, MUST be a PWM capable pin, set to 0 if unused.
    	//to reverse the motor relative to joystick either swap wires on board, or dir1/2 pins in code.
    	RCMotor(int dir_pin1, int dir_pin2, int rc_pin, int speed_pin){
    		p1   = dir_pin1;
    		p2   = dir_pin2;
    		rcPin = rc_pin;
                speedPin = speed_pin;
    
    		pinMode(rc_pin, INPUT);
    	        pinMode(p1, OUTPUT);
    	        pinMode(p2, OUTPUT);
    		if(speedPin != 0) pinMode(speedPin, OUTPUT);
    	}
      
    	void motorOff(){
    		if(debug) Serial.print(" motor OFF ");
    		digitalWrite(p1, LOW);
                digitalWrite(p2, LOW);
    		if(speedPin != 0) analogWrite(speedPin, 0);
    
    	}
    
    	~RCMotor(){motorOff();}
    
        bool receivingSignal(){
           int rv = pulseIn(rcPin, HIGH, 25000);
           if(rv == 0) return false;
           return true;
        }
          
    	void process(){
    
    		  int rv = pulseIn(rcPin, HIGH, 25000);
    		  
    		  int pwm = 0;
    		  int centerStick = 1300; //range goes from about 850-1750
    		  int minRight = centerStick + deadZone;
    		  int minLeft = centerStick - deadZone;
    
    		  if(debug){
    			  Serial.print(" rcPin: "); Serial.print(rcPin); Serial.print(" rawVal: "); Serial.print(rv);
    		  }
    		  
    		  if(rv==0){
    			  if(debug) Serial.print(" no signal ");
    			  motorOff();
    		  }
    		  else if(rv > minRight){ //right stick
    			  digitalWrite(p1, LOW);
    			  digitalWrite(p2, HIGH);
    			  if(speedPin != 0){
    				  pwm = map(rv, minRight, 2000, 0, 255); //map our speed to 0-255 range
    				  analogWrite(speedPin, pwm);
    				  if(debug){ Serial.print(" right/up stick speed: "); Serial.println(pwm);}
    			  }else{
    				  if(debug) Serial.print(" right/up stick ");
    			  }
    		  }
    		  else if(rv < minLeft){
    			  digitalWrite(p1, HIGH);
    			  digitalWrite(p2, LOW);
    			  if(speedPin != 0){
    				  pwm = map(rv, minLeft, 1000, 0, 255); //map our speed to 0-255 range
    				  analogWrite(speedPin, pwm);
    				  if(debug){ Serial.print(" left/down stick speed: "); Serial.println(pwm);}
    			  }else{
    				  if(debug) Serial.print(" left/down stick "); 
    			  }
    		  }else{
    			  if(debug) Serial.print(" stick centered ");
    			  motorOff();
    		  }
    
                  if(debug) Serial.print("\n");
    		  
    	}

};
