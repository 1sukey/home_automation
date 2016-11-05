/*
 * dzzie@yahoo.com
 * http://sandsprite.com
 * free for any use
 * 
 * v1 video here:  https://youtu.be/68TlArt3PbY
 * v2 video:       https://youtu.be/6gox5O4asF4
 
 * this sketch is for a leonardo board, it gives you a bank of external buttons that will do
 * common tasks such as cut, copy, paste, select all with single button clicks. 
 * very simple, no resistors needed since we use the internal pullups on the arduino. debounce handled
 * by software delay.
 * 
 * this code also supports sending an adjustable delay mouse clicks, or mouse scroll wheel events
 * I use a 3 position switch on pins 6/7 to select which (center is off). The time delay comes by
 * reading a potentiometer on analog pin 0. Delay is currently mapped between 10ms and 3 seconds.
 * this features requires 3 more inputs. 
 * 
 * if it says keyboard.h not found, make sure you set the board to leanardo. You may also have to use a 
 * newer IDE (ex 1.6.9+)
 * 
 * if you have problems uploading, press the reset button down until it gets to the uploading phase
 
version 2 button configuration

 4   1
 5   2
 6   3

7   8   9

 dpdt switch for scroll/click mode
 pot 1 for scroll/click frequency
 pot 2 for profile selection - 3 profiles included, only affects buttons 7,8,9

1 = copy
2 = paste
3 = cut
4 = left click
5 = double click
6 = right click

profile 1: ollydbg
  7 = f7 step in
  8 = f8 step over
  9 = ctrl-f9 = execute till return (step out)

profile 2: vb6
  7 = f8 step into
  8 = shift f8 step over
  9 = ctrl shift f8 - step out

profile 3: visual studio
  7 = f11 step into
  8 = f10 step over
  9 = shift f11 - step out
  

https://www.arduino.cc/en/Reference/KeyboardModifiers

 */

#include <Keyboard.h>
#include <Mouse.h>

const int copy = 3;
const int paste = 4;
const int cut = 5;
const int lClick = 11;
const int dblClick = 10;
const int rClick = 9;
const int button7 = 8;
const int button8 = 7;
const int button9 = 6;
const int scroll_selected = 13;
const int click_selected = 12;
const int potPin = A5;
const int profilePot = A1;

enum profiles{ olly = 1, vb6 = 2, vs = 3};

void setup() { 
  
  pinMode(cut, INPUT_PULLUP);
  pinMode(copy, INPUT_PULLUP);
  pinMode(paste, INPUT_PULLUP);
  pinMode(lClick, INPUT_PULLUP);
  pinMode(rClick, INPUT_PULLUP);
  pinMode(dblClick, INPUT_PULLUP);

  pinMode(button7, INPUT_PULLUP);
  pinMode(button8, INPUT_PULLUP);
  pinMode(button9, INPUT_PULLUP);
  
  pinMode(scroll_selected, INPUT_PULLUP);
  pinMode(click_selected, INPUT_PULLUP);
  pinMode(potPin, INPUT);
  pinMode(profilePot, INPUT);
  
  Serial.begin(9600);
  Mouse.begin();
  Keyboard.begin();
}

void SendCmd(char c){
    Keyboard.press(KEY_LEFT_CTRL);
    Keyboard.press(c);
    delay(100);
    Keyboard.releaseAll(); 
    delay(150);
}

int readPot(){
      int val = analogRead(potPin);         // reads the value of the potentiometer (value between 0 and 1023) 
      //Serial.print("pot pin:"); Serial.println(val);
      return map(val, 0, 1023, 10, 3000);   // scale it to use it as a ms time delay (value between 10 and 3000) 
}

void handleProfile(void){
    
    int val = analogRead(profilePot);
    //profiles profile = (profiles)map(val, 0, 1023, 1, 3); //this = dead 0, anywhere in between, dead max

    //now we give it 3 even ranges to work with..
    profiles profile = olly;
    if(val >= 340 && val < 680) profile = vb6;
    if(val >= 680) profile = vs;

    bool b7 = (digitalRead(button7) == LOW);
    bool b8 = (digitalRead(button8) == LOW);
    bool b9 = (digitalRead(button9) == LOW);
/*
    Serial.print("profile:"); Serial.print(profile);
    Serial.print(" b7: "); Serial.print(b7);
    Serial.print(" b8: "); Serial.print(b8);
    Serial.print(" b9: "); Serial.println(b9);
*/
    
/*
  profile 1: ollydbg
    7 = f7 step in
    8 = f8 step over
    9 = ctrl-f9 = execute till return (step out)

  profile 2: vb6
    7 = f8 step into
    8 = shift f8 step over
    9 = ctrl shift f8 - step out

  profile 3: visual studio
    7 = f11 step into
    8 = f10 step over
    9 = shift f11 - step out
*/
   if(b7){ //step into...
      switch(profile){
          case olly:
                      Keyboard.press(KEY_F7);
                      break;
          case vb6:
                      Keyboard.press(KEY_F8);
                      break;
          case vs:
                      Keyboard.press(KEY_F7);
                      break;
      }
   }

   if(b8){ //step over
      switch(profile){
          case olly:
                      Keyboard.press(KEY_F8);
                      break;
          case vb6:
                      Keyboard.press(KEY_RIGHT_SHIFT);
                      Keyboard.press(KEY_F8);
                      break;
          case vs:
                      Keyboard.press(KEY_F10);
                      break;
      }
   }

   if(b9){ //step out...
       switch(profile){
          case olly:
                      Keyboard.press(KEY_LEFT_CTRL);
                      Keyboard.press(KEY_F9);
                      break;
          case vb6:
                      Keyboard.press(KEY_LEFT_CTRL);
                      Keyboard.press(KEY_RIGHT_SHIFT);
                      Keyboard.press(KEY_F8);
                      break;
          case vs:
                      Keyboard.press(KEY_RIGHT_SHIFT);
                      Keyboard.press(KEY_F11);
                      break;
      }
   }

   delay(100);
   Keyboard.releaseAll(); 
   delay(150);
     
}

void loop() {

    int ms = 0;
     
    if (digitalRead(cut) == LOW)    SendCmd('x');
    if (digitalRead(copy) == LOW)   SendCmd('c');
    if (digitalRead(paste) == LOW)  SendCmd('v');
    
    if (digitalRead(lClick) == LOW){ 
        //Mouse.click(); delay(200);
        //this allows for holding the mouse down for selection operations as well instead of just clicks...
        Mouse.press(); delay(200);
        while((digitalRead(lClick) == LOW)){delay(200);}
        Mouse.release();
    }    
        
    
    if (digitalRead(dblClick) == LOW){ Mouse.click(); delay(200); Mouse.click();delay(200);}
    if (digitalRead(rClick) == LOW){ Mouse.click(MOUSE_RIGHT);  delay(200); }

    if (digitalRead(button7) == LOW || digitalRead(button8) == LOW || digitalRead(button9) == LOW) handleProfile();
    
    if (digitalRead(scroll_selected) == LOW){
        ms = readPot();
       // Serial.print("MouseScroll 1 delay:");
       // Serial.println(ms);
        Mouse.move(0, 0, -1);
        delay(ms);
    }

    if (digitalRead(click_selected) == LOW){
        ms = readPot();
        //Serial.print("Mouse Click delay:");
        //Serial.println(ms);
        Mouse.click();
        delay(ms);
    }
    

}


