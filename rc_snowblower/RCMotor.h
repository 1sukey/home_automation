/*
	Author: David Zimmer <dzzie@yahoo.com>
	site:   http://sandsprite.com
	License: GPL

        This is a small class that will read a signal from an RC receiver and then control
	a DC motor through an L298N driver board. Supports forward and reverse and optional
	speed control.

	pulseIn 250ms timeout is suitable for out needs no need for the complexity of interrupts.
	
	http://rcarduino.blogspot.com/2012/01/how-to-read-rc-receiver-with.html
	
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
        const int centerStick = 1500;
        const int quarterSecond = 250000; //250ms in micro seconds 
    
    public:
        bool debug = false;
        uint8_t deadZone = 35;     //how much of a dead zone to give centered stick
	uint8_t constSpeed = 0;    //value 0-255
 	uint32_t lastReadTime = 0;
        int lastSignal = -1;
        int readInterval = 300;    //the caching mechanism might just be bloat..remove?

    	//dir_pin1/2 is the direction control pins, must be digital pins
    	//rc_pin is the pin to read the rc control signal from, MUST be a PWM capable pin
    	//speed_pin is optional, MUST be a PWM capable pin, set to 0 if unused.
    	//to reverse the motor relative to joystick either swap wires on board, or dir1/2 pins in code.
    	RCMotor(int dir_pin1, int dir_pin2, int rc_pin, int speed_pin){
    	    p1   = dir_pin1;
    	    p2   = dir_pin2;
    	    rcPin = rc_pin;
            speedPin = speed_pin;
    
    	    pinMode(rcPin, INPUT);
    	    pinMode(p1, OUTPUT);
    	    pinMode(p2, OUTPUT);
    	    if(speedPin != 0) pinMode(speedPin, OUTPUT);
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
    	    digitalWrite(p1, LOW);
            digitalWrite(p2, LOW);
    	    if(speedPin != 0) analogWrite(speedPin, 0);
    
    	}
    
    	~RCMotor(){motorOff();}
    
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
    			  digitalWrite(p2, HIGH);
		          if(debug) Serial.print(" stick Up|Right ");
    			  if(speedPin != 0){
    				  if(constSpeed != 0) pwm = constSpeed; else pwm = map(rv, minRight, 2000, 0, 255); //map our speed to 0-255 range
    				  analogWrite(speedPin, pwm);
    				  if(debug){ Serial.print(" speed: "); Serial.println(pwm);}
			  }
    		  }
    		  else if(rv < minLeft){
    			  digitalWrite(p1, HIGH);
    			  digitalWrite(p2, LOW);
			  if(debug) Serial.print(" stick Down|Left ");
    			  if(speedPin != 0){
    				  if(constSpeed != 0) pwm = constSpeed; else pwm = map(rv, minLeft, 1000, 0, 255); //map our speed to 0-255 range
    				  analogWrite(speedPin, pwm);
    				  if(debug){ Serial.print(" speed: "); Serial.println(pwm);}
    			  }
    		  }else{
    			  if(debug) Serial.print(" stick centered ");
    			  motorOff();
    		  }
    
                  if(debug) Serial.print("\n");
    		  
    	}

};
