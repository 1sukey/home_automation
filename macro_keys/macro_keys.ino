/*
 * dzzie@yahoo.com
 * http://sandsprite.com
 * free for any use
 * 
 * video here:  https://youtu.be/68TlArt3PbY
 *
 * this sketch is for a leonardo board, it gives you a bank of external buttons that will do
 * common tasks such as cut, copy, paste, select all with single button clicks. only 5 wires
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
 
   todo: 3 position switch to select between mouse and keyboard mode, (2 digital inputs) 
         and one potentiometer to select speed (1 analog input): 
         this will either scroll mouse wheel on interval, or click left mouse button on interval
         
   todo: potentiometer and screen to select which a password to type in to current field? 
        (numeric id corrolated with paper site/user/id list?)
        
   todo: programmable key mappings (or password programming) over serial? 
 */

#include <Keyboard.h>
#include <Mouse.h>

const int copy = 2;
const int paste = 3;
const int cut = 4;
const int selall = 5;
const int scroll_selected = 6;
const int click_selected = 7;
const int potPin = A0;

void setup() { 
  
  pinMode(cut, INPUT_PULLUP);
  pinMode(copy, INPUT_PULLUP);
  pinMode(paste, INPUT_PULLUP);
  pinMode(selall, INPUT_PULLUP);
  pinMode(scroll_selected, INPUT_PULLUP);
  pinMode(click_selected, INPUT_PULLUP);
  pinMode(potPin, INPUT);
  
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
      //Serial.print("pot pin:");
      //Serial.println(val);
      return map(val, 0, 1023, 10, 3000);   // scale it to use it as a ms time delay (value between 10 and 3000) 
}

void loop() {

    int ms = 0;
    
    if (digitalRead(cut) == LOW)    SendCmd('x');
    if (digitalRead(copy) == LOW)   SendCmd('c');
    if (digitalRead(paste) == LOW)  SendCmd('v');
    if (digitalRead(selall) == LOW) SendCmd('a');
    
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


