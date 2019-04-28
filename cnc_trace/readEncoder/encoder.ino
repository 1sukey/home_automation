/* built upon the Encoder Library - Basic Example
 * http://www.pjrc.com/teensy/td_libs_Encoder.html
 *
 * This example code is in the public domain.
 */

#include <Encoder.h>

// Change these two numbers to the pins connected to your encoder.
//   Best Performance: both pins have interrupt capability
//   Good Performance: only the first pin has interrupt capability
//   Low Performance:  neither pin has interrupt capability
Encoder EncX(2, 5);
Encoder EncY(3, 6);
//   avoid using pins with LEDs attached

void setup() {
  Serial.begin(9600);
  Serial.println("# Basic Encoder Test:");
}

long oldX  = -999;
long oldY  = -999;

void loop() {
  
  bool changed = false;
  
  if (Serial.available() > 0) {
       String cmd = Serial.readStringUntil('\n');
       if(cmd=="zero"){EncX.write(0); EncY.write(0);}
  }
  
  long newX = EncX.read();
  if (newX != oldX) {
      oldX = newX;
      changed = true;
  }
  
  long newY = EncY.read();
  if (newY != oldY) {
      oldY = newY;
      changed = true;
  }
  
  if(changed){
      Serial.print(newX * -1);
      Serial.print(',');
      Serial.print(newY * -1);
      Serial.println();
  }
  
  
  
  
}
