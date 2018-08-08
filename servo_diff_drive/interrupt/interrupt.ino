//http://rcarduino.blogspot.com/2012/11/how-to-read-rc-channels-rcarduinofastlib.html

/*+++++++++++++++++++++++++++++++++++++++++++++++++++
CalDiffDrive by:
Author      : Fahmi Ghani
Date        : 11 July 2015 
Project     : Joystick control differential drive dc motor robot
Component   : Analog Joystick
              2Amp motor driver shield
              DC Motor
Description : Control DC motor direction using Joystick
Video :https://www.youtube.com/watch?v=kfT3eoNAM-Q
+++++++++++++++++++++++++++++++++++++++++++++++++++*/

#include "RCArduinoFastLib.h"
#include <string.h>

 // MultiChannels
//
// rcarduino.blogspot.com
//
// A simple approach for reading three RC Channels using pin change interrupts
//
// See related posts -
// http://rcarduino.blogspot.co.uk/2012/01/how-to-read-rc-receiver-with.html
// http://rcarduino.blogspot.co.uk/2012/03/need-more-interrupts-to-read-more.html
// http://rcarduino.blogspot.co.uk/2012/01/can-i-control-more-than-x-servos-with.html
//
// rcarduino.blogspot.com
//

// include the pinchangeint library - see the links in the related topics section above for details
#include "PinChangeInt.h"

int servoMax = 2000; //deg = 180;
int servoMin = 1000; //deg = 0
int servoCenter = 1500;

bool debug = true;
int deadZone = 40;

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

// These bit flags are set in bUpdateFlagsShared to indicate which
// channels have new signals
#define X_FLAG 1
#define Y_FLAG 2


// holds the update flags defined above
volatile uint8_t bUpdateFlagsShared;

// shared variables are updated by the ISR and read by loop.
// In loop we immediatley take local copies so that the ISR can keep ownership of the
// shared ones. To access these in loop
// we first turn interrupts off with noInterrupts
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

  //Serial.println("multiChannels");

  // attach servo objects, these will generate the correct
  // pulses for driving Electronic speed controllers, servos or other devices
  // designed to interface directly with RC Receivers
  CRCArduinoFastServos::attach(SERVO_LEFT,LEFT_OUT_PIN);
  CRCArduinoFastServos::attach(SERVO_RIGHT,RIGHT_OUT_PIN);
 
  // lets set a standard rate of 50 Hz by setting a frame space of 10 * 2000 = 3 Servos + 7 times 2000
  CRCArduinoFastServos::setFrameSpaceA(SERVO_FRAME_SPACE,7*2000);

  CRCArduinoFastServos::begin();
 
  // using the PinChangeInt library, attach the interrupts
  // used to read the channels
  PCintPort::attachInterrupt(X_IN_PIN, calc_X,CHANGE);
  PCintPort::attachInterrupt(Y_IN_PIN, calc_Y,CHANGE);
}

int stickDir(int rcVal, const char* name){
  int rv = 0;
  //const char* d[] = {"centered\n","right/up\n","left/down\n"};
  if(rcVal > (1500+deadZone)) rv = 1; //up/right stick  
  if(rcVal < (1500-deadZone)) rv = -1; //down/left stick   
  //if(debug) Serial.print(name); Serial.print("="); Serial.print(rcVal); Serial.print("\t"); Serial.print(d[rv]);     
  return rv; 
}

/*
//http://savagemakers.com/differential-drive-tank-drive-in-arduino/http://savagemakers.com/differential-drive-tank-drive-in-arduino/
void differentialDrive(float x, float y)
{
  #define DDRIVE_MIN -100 //The minimum value x or y can be.
  #define DDRIVE_MAX 100  //The maximum value x or y can be.
  #define MOTOR_MIN_PWM -255 //The minimum value the motor output can be.
  #define MOTOR_MAX_PWM 255 //The maximum value the motor output can be.
  
  int LeftMotorOutput; //will hold the calculated output for the left motor
  int RightMotorOutput; //will hold the calculated output for the right motor

   float rawLeft;
   float rawRight;
   float RawLeft;
   float RawRight;

   int dirX = stickDir(x, "right/left");
   int dirY = stickDir(y, "up/down");
   
   // first Compute the angle in deg
   // First hypotenuse
   float z = sqrt(x * x + y * y);
  
   // angle in radians
   float rad = acos(abs(x) / z);
  
   // Cataer for NaN values
   if (isnan(rad) == true) {
     rad = 0;
   }
  
   // and in degrees
   float angle = rad * 180 / PI;
  
   // Now angle indicates the measure of turn
   // Along a straight line, with an angle o, the turn co-efficient is same
   // this applies for angles between 0-90, with angle 0 the co-eff is -1
   // with angle 45, the co-efficient is 0 and with angle 90, it is 1
  
   float tcoeff = -1 + (angle / 90) * 2;
   float turn = tcoeff * abs(abs(y) - abs(x));
   turn = round(turn * 100) / 100;
  
   // And max of y or x is the movement
   float mov = max(abs(y), abs(x));
  
   // First and third quadrant
   if ((x >= 0 && y >= 0) || (x < 0 && y < 0))
   {
     rawLeft = mov; rawRight = turn;
   }
   else
   {
     rawRight = mov; rawLeft = turn;
   }
  
   // Reverse polarity
   if (y < 0) {
     rawLeft = 0 - rawLeft;
     rawRight = 0 - rawRight;
   }
  
  // Update the values
   RawLeft = rawLeft;
   RawRight = rawRight;
  
  // Map the values onto the defined rang
   LeftMotorOutput = map(rawLeft, DDRIVE_MIN, DDRIVE_MAX, MOTOR_MIN_PWM, MOTOR_MAX_PWM);
   RightMotorOutput = map(rawRight, DDRIVE_MIN, DDRIVE_MAX, MOTOR_MIN_PWM, MOTOR_MAX_PWM);
   
   //CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, RightMotorOutput);
   //CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT,  LeftMotorOutput);
  
    if(debug){
      Serial.print(RawLeft);  Serial.print("\t" );
      Serial.print(RawRight); Serial.print("\t" );
      Serial.print(RightMotorOutput); Serial.print("\t" );
      Serial.print(LeftMotorOutput);Serial.print("\n" );
    }
    
    delay(1500);
  
}
*/

/*
void differentialDrive(int rcX, int rcY){
  
  int speedFwd = 0; 
  int speedTurn = 0; 
  
  int dirX = stickDir(rcX, "right/left");
  int dirY = stickDir(rcY, "up/down");
  
  speedFwd = rcY - 1500;          // forward/back  range -500 to 500  
  speedTurn = rcX - 1500;         // right/left    range -500 to 500  
  
  if(dirY == 1)        speedFwd = rcY - 1500;          // forward  range 0 to 500  
    else if(dirY == 2) speedFwd = rcY - 1500;          // backward range -500 to 0  

  if(dirX == 1)        speedTurn = rcX - 1500;         // right  
    else if(dirX == 2) speedTurn = rcX - 1500;         // left   

  int speedLeft  = constrain(1500 + speedFwd + speedTurn, 1000, 2000);
  int speedRight = constrain(1500 + speedFwd - speedTurn, 1000, 2000);
  
  CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, speedRight);
  CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT,  speedLeft);

  if(debug){
    Serial.print(speedFwd);  Serial.print("," );
    Serial.print(speedTurn); Serial.print("," );
    Serial.print(speedLeft); Serial.print("," );
    Serial.print(speedRight);Serial.print("\n" );
  }
    
  delay(1500);
  
}
*/



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

    if(dirY == 1)//forward
    {
        speedFwd = map(y, 0, 500, 0, 500);
    }
    else if(dirY == -1) //backward
    {
        speedFwd = map(y, 0, -500, -0, -500);
    }
    
    
    if(dirX == 1) //right
    {
        speedTurn = map(x, 0, 500, 0, 500);
    }
    else if(dirX == -1) //left
    {
        speedTurn = map(x, 0, -500, -0, -500);
    }

    int speedLeft = speedFwd + speedTurn;
    int speedRight = speedFwd - speedTurn;

    speedLeft = constrain(speedLeft, -500, 500);
    speedRight = constrain(speedRight, -500, 500);

    CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, speedRight + 1500);
    CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT,  speedLeft + 1500);
  	 
    if(debug){
	    char buf[256];
	    sprintf(buf,"%d,%d,%d,%d,%d,%d\n", x, y, speedFwd, speedTurn, speedLeft, speedRight);
	    Serial.print(buf);
	}
}

void loop()
{
  // create local variables to hold a local copies of the channel inputs
  // these are declared static so that thier values will be retained
  // between calls to loop.
  static uint16_t X_In;
  static uint16_t Y_In;
  // local copy of update flags
  static uint8_t bUpdateFlags;

  // check shared update flags to see if any channels have a new signal
  if(bUpdateFlagsShared)
  {
    noInterrupts(); // turn interrupts off quickly while we take local copies of the shared variables

    // take a local copy of which channels were updated in case we need to use this in the rest of loop
    bUpdateFlags = bUpdateFlagsShared;
  
    // in the current code, the shared values are always populated
    // so we could copy them without testing the flags
    // however in the future this could change, so lets
    // only copy when the flags tell us we can.
  
    if(bUpdateFlags & X_FLAG)  X_In = X_InShared;  
    if(bUpdateFlags & Y_FLAG)  Y_In = Y_InShared;
   
    // clear shared copy of updated flags as we have already taken the updates
    // we still have a local copy if we need to use it in bUpdateFlags
    bUpdateFlagsShared = 0;
  
    interrupts(); // we have local copies of the inputs, so now we can turn interrupts back on
    // as soon as interrupts are back on, we can no longer use the shared copies, the interrupt
    // service routines own these and could update them at any time. During the update, the
    // shared copies may contain junk. Luckily we have our local copies to work with :-)
  }

  // do any processing from here onwards
  // only use the local values unAuxIn, unThrottleIn and unSteeringIn, the shared
  // variables unAuxInShared, unThrottleInShared, unSteeringInShared are always owned by
  // the interrupt routines and should not be used in loop

  // the following code provides simple pass through
  // this is a good initial test, the Arduino will pass through
  // receiver input as if the Arduino is not there.
  // This should be used to confirm the circuit and power
  // before attempting any custom processing in a project.

  // we are checking to see if the channel value has changed, this is indicated
  // by the flags. For the simple pass through we don't really need this check,
  // but for a more complex project where a new signal requires significant processing
  // this allows us to only calculate new values when we have new inputs, rather than
  // on every cycle.
  
  calcDiffDrive(X_In, Y_In);
  
  //if(bUpdateFlags & X_FLAG) CRCArduinoFastServos::writeMicroseconds(SERVO_RIGHT, X_In);
  //if(bUpdateFlags & Y_FLAG) CRCArduinoFastServos::writeMicroseconds(SERVO_LEFT, Y_In);
  
  bUpdateFlags = 0;
  
}


// simple interrupt service routine
void calc_X()
{
  if(PCintPort::pinState)
  {
    X_InStart = TCNT1;
  }
  else
  {
    X_InShared = (TCNT1 - X_InStart)>>1;
    bUpdateFlagsShared |= X_FLAG;
  }
}

void calc_Y()
{
  if(PCintPort::pinState)
  {
    Y_InStart = TCNT1;
  }
  else
  {
    Y_InShared = (TCNT1 - Y_InStart)>>1;
    bUpdateFlagsShared |= Y_FLAG;
  }
}


