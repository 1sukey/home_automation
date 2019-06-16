
This is a quick project to add automatic indexing to a manual rotary table or dividing head.

For this task we use the following components:

* Arduino Uno 
* SainSmart CNC Router Single 1 Axis 3.5A TB6560 Stepper Stepping Motor Driver Board WL  
     https://www.amazon.com/gp/product/B008BGLOTQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B008BGLOTQ&linkCode=as2&tag=dzzie-20&linkId=3df57e78fae38175d4a5cd1f7b2e1682
     
* a small 12-24 DC power supply 
* a small stepper motor 

A video of the build can be found at the following URL: 
    rotary table: http://youtu.be/m4VFPw1MFgo
    dividing head: https://www.youtube.com/watch?v=Fuq_NjAvOsY

Inside the Arduino folder is the source code for the microcontroller. The VB controller folder
contains a Visual Basic six Windows application that talks to the Arduino over the serial port
to configure it. (You can use windows tablets for this.)

The computer will need to be plugged in at least once to configure it each time,
if you power the Arduino off of the power source as well then you could potentially 
unplug the computer after that. 

The arduino code supports the following options:
             * forwards and back buttons to index position
	* switch so buttons operate as a jog mode
	* home button
	* external trigger pin (to say fire a drill cycle in another arduino)
             * feature to jump to specific index from GUI input
             * GUI will display which index you are currently at
             * if not configured by pc it will operate in jog mode

This program is released free for personal home use. 
If you use it commercially please offer a donation for my time.

here is another open source one by Shane Loucks to look at if interested:
(uses keypad+lcd to configure)

   https://www.youtube.com/watch?v=7p66ACCX1Do
   http://www.cnczone.com/forums/arduino/215402-cnc.html#post1457414

