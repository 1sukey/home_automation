#include "RCArduinoFastLib.h"
//#include <string.h>

// MultiChannels
//
// http://rcarduino.blogspot.com/2012/11/how-to-read-rc-channels-rcarduinofastlib.html
//
// A simple approach for reading three RC Channels using pin change interrupts
//
// See related posts -
// http://rcarduino.blogspot.co.uk/2012/01/how-to-read-rc-receiver-with.html
// http://rcarduino.blogspot.co.uk/2012/03/need-more-interrupts-to-read-more.html
// http://rcarduino.blogspot.co.uk/2012/01/can-i-control-more-than-x-servos-with.html
//
// rcarduino.blogspot.com

/*
CalDiffDrive by:
  Author      : Fahmi Ghani
  Date        : 11 July 2015 
  Project     : Joystick control differential drive dc motor robot
  Component   : Analog Joystick
                2Amp motor driver shield
                DC Motor
  Description : Control DC motor direction using Joystick
  Video :https://www.youtube.com/watch?v=kfT3eoNAM-Q

FS-16 Tx note: 
when the transmitter gets turned off it keeps sending the last signal it received (failsafe mode off), 
The value sent can be changed to a default you specify in the transmitter on loss of signal: 
  setup -> System -> Rx Setup -> Failsafe 

Failsafe triggers after about 1 second. 

Betaflight has a trick on how to detect failsafe mode from code. 
link: https://www.propwashed.com/ibus-betaflight-guide/﻿
  set throttle stick min to -102% in adjust endpoints, 
  set failsafe for -102, 
  trim up so lowest stick can manually go is -100%. 

*/

// include the pinchangeint library - see the links in the related topics section above for details
#include "PinChangeInt.h"

int servoMax = 2000; //deg = 180;
int servoMin = 1000; //deg = 0
int servoCenter = 1500;

bool debug = false;
int deadZone = 40;

//#define LED_PIN 2

// Assign your channel in pins
#define Y_IN_PIN 5
#define X_IN_PIN 6

// Assign your channel out pins
#define RIGHT_OUT_PIN 8
#define LEFT_OUT_PIN 9

// Assign servo indexes
#define SERVO_LEFT 0
#define SERVO_RIGHT 1
#define SERVO_FRAME_SPACE 3

// These bit flags are set in bUpdateFlagsShared to indicate which channels have new signals
#define X_FLAG 1
#define Y_FLAG 2


// holds the update flags defined above
volatile uint8_t bUpdateFlagsShared;

// shared variables are updated by the ISR and read by loop.
// In loop we immediatley take local copies so that the ISR can keep ownership of the
// shared ones. To access these in loop we first turn interrupts off with noInterrupts
// we take a copy to use in loop and the turn interrupts back on
// as quickly as possible, this ensures that we are always able to receive new signals
volatile uint16_t X_InShared;
volatile uint16_t Y_InShared;

// These are used to record the rising edge of a pulse in the calcInput functions
// They do not need to be volatile as they are only used in the ISR. If we wanted
// to refer to these in loop and the ISR then they would need to be declared volatile
uint16_t Y_InStart;
uint16_t X_InStart;

uint16_t unLastAuxIn = 0;
uint32_t ulVariance = 0;
uint32_t ulGetNextSampleMillis = 0;
uint16_t unMaxDifference = 0;

void setup()
{
  Serial.begin(9600);
  //pinMode(LED_PIN, OUTPUT);

  // attach servo objects, these will generate the correct pulses for driving Electronic 
  // speed controllers, servos or other devices designed to interface directly with RC Receivers
  CRCArduinoFastServos::attach(SERVO_LEFT,LEFT_OUT_PIN);
  CRCArduinoFastServos::attach(SERVO_RIGHT,RIGHT_OUT_PIN);
 
  // lets set a standard rate of 50 Hz by setting a frame space of 10 * 2000 = 3 Servos + 7 times 2000
  CRCArduinoFastServos::setFrameSpaceA(SERVO_FRAME_SPACE,7*2000);

  CRCArduinoFastServos::begin();
 
  // using the PinChangeInt library, attach the interrupts used to read the channels
  PCintPort::attachInterrupt(X_IN_PIN, calc_X,CHANGE);
  PCintPort::attachInterrupt(Y_IN_PIN, calc_Y,CHANGE);
}

int stickDir(int rcVal, const char* name){
  int rv = 0;
  if(rcVal > (1500+deadZone)) rv = 1;  //up/right stick  
  if(rcVal < (1500-deadZone)) rv = -1; //down/left stick   
  return rv; 
}

void calcDiffDrive(int x, int y){
	
	//input RC signal range 1000-2000 center neutral 1500 
	//for simplicity we receive normalized values here from -500 to 500, center stick = 0
	//x represents turn speed from right left stick (RC channel 1)
	//y represents forward/back speed from RC channel 2

   int dirX = stickDir(x, "x");
   int dirY = stickDir(y, "y");
    
    x = x - 1500; //now based at -500 to 500
    y = y - 1500;
    
    //if((x > 0 && x < deadZone) || (x < 0 && x > deadZone)) x = 0;
    //if((y > 0 && y < deadZone) || (y < 0 && y > deadZone))  y = 0;
    
    int speedFwd = 0; 
    int speedTurn = 0; 

    if(dirY == 1) speedFwd = map(y, 0, 500, 0, 500);            //forward
     else if(dirY == -1) speedFwd = map(y, 0, -500, -0, -500);  //backward  
    
    if(dirX == 1) speedTurn = map(x, 0, 500, 0, 500);           //right
     else if(dirX == -1) speedTurn = map(x, 0, -500, -0, -500); //left

    int speedLeft = speedFwd + speedTurn;
    int speedRight = speedFwd - speedTurn;

    speedLeft = constrain(speedLeft, -500, 500);
    speedRight = constrain(speedRight, -500, 500);

    CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, speedRight + 1500);
    CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT,  speedLeft + 1500);
   
    /*	 
    if(debug){
	    char buf[256];
	    sprintf(buf,"%d,%d,%d,%d,%d,%d\n", x, y, speedFwd, speedTurn, speedLeft, speedRight);
	    Serial.print(buf);
    }*/
    
}

void loop()
{
  // create local variables to hold a local copies of the channel inputs these are declared static 
  // so that thier values will be retained between calls to loop.
  static uint16_t X_In;
  static uint16_t Y_In;
  static uint8_t bUpdateFlags;

  // check shared update flags to see if any channels have a new signal
  if(bUpdateFlagsShared)
  {
    noInterrupts(); // turn interrupts off quickly while we take local copies of the shared variables

    // take a local copy of which channels were updated in case we need to use this in the rest of loop
    bUpdateFlags = bUpdateFlagsShared;
  
    // in the current code, the shared values are always populated so we could copy them without testing the flags
    // however in the future this could change, so lets only copy when the flags tell us we can.
  
    if(bUpdateFlags & X_FLAG)  X_In = X_InShared;  
    if(bUpdateFlags & Y_FLAG)  Y_In = Y_InShared;
   
    // clear shared copy of updated flags as we have already taken the updates
    // we still have a local copy if we need to use it in bUpdateFlags
    bUpdateFlagsShared = 0;
    
    interrupts(); // we have local copies of the inputs, so now we can turn interrupts back on
    // as soon as interrupts are back on, we can no longer use the shared copies, the interrupt
    // service routines own these and could update them at any time. During the update, the
    // shared copies may contain junk. Luckily we have our local copies to work with :-)
    
    calcDiffDrive(X_In, Y_In);
    
  }
  
    
  // do any processing from here onwards only use the local values unAuxIn, unThrottleIn and unSteeringIn, 
  // the shared variables unAuxInShared, unThrottleInShared, unSteeringInShared are always owned by
  // the interrupt routines and should not be used in loop

  // the following code provides simple pass through this is a good initial test, the Arduino will pass through
  // receiver input as if the Arduino is not there.  This should be used to confirm the circuit and power
  // before attempting any custom processing in a project.

  // we are checking to see if the channel value has changed, this is indicated
  // by the flags. For the simple pass through we don't really need this check,
  // but for a more complex project where a new signal requires significant processing
  // this allows us to only calculate new values when we have new inputs, rather than
  // on every cycle.

  //if(bUpdateFlags & X_FLAG) CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, X_In);
  //if(bUpdateFlags & Y_FLAG) CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT, Y_In);
  
  bUpdateFlags = 0;
  
}


// simple interrupt service routine
void calc_X()
{
    if(PCintPort::pinState){ X_InStart = TCNT1; }
    else{
      X_InShared = (TCNT1 - X_InStart)>>1;
      bUpdateFlagsShared |= X_FLAG;
    }
}

void calc_Y()
{
    if(PCintPort::pinState){ Y_InStart = TCNT1;}
    else{
      Y_InShared = (TCNT1 - Y_InStart)>>1;
      bUpdateFlagsShared |= Y_FLAG;
    } 
}


