/*
 * dzzie@yahoo.com
 * http://sandsprite.com
 * free for any use
 * 
 * this sketch is for a leonardo board, it gives you a bank of external buttons that will do
 * common tasks such as cut copy paste, select all and undo with single button clicks. only 5 wires
 * very simple, no resistors needed since we use the internal pullups on the arduino. debounce handled
 * by software delay.
 * 
 * if it says keyboard.h not found, make sure you set the board to leanardo. You may also have to use a 
 * newer IDE (ex 1.6.9+)
 * 
 * if you have problems uploading, press the reset button down until it gets to the uploading phase
 */

#include <Keyboard.h>

const int copy = 2;
const int paste = 3;
const int cut = 4;
const int selall = 5;
const int undo = 6;

void setup() { 
  pinMode(cut, INPUT_PULLUP);
  pinMode(copy, INPUT_PULLUP);
  pinMode(paste, INPUT_PULLUP);
  pinMode(selall, INPUT_PULLUP);
  pinMode(undo, INPUT_PULLUP);

  Serial.begin(9600);
  //Mouse.begin();
  Keyboard.begin();
}

void SendCmd(char c){
    Keyboard.press(KEY_LEFT_CTRL);
    Keyboard.press(c);
    delay(100);
    Keyboard.releaseAll(); 
    delay(150);
}

void loop() {

    if (digitalRead(cut) == LOW)    SendCmd('x');
    if (digitalRead(copy) == LOW)   SendCmd('c');
    if (digitalRead(paste) == LOW)  SendCmd('v');
    if (digitalRead(selall) == LOW) SendCmd('a');
    if (digitalRead(undo) == LOW)   SendCmd('z');

}


