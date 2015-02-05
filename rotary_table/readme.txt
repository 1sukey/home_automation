
This is a quick project to add automatic indexing to a manual rotary table.

For this task we use the following components:

* Arduino Uno - $25
* SainSmart CNC Router Single 1 Axis 3.5A TB6560 Stepper Stepping Motor Driver Board WL ($20)
    http://www.amazon.com/gp/product/B008BGLOTQ/ref=oh_aui_detailpage_o09_s00?ie=UTF8&psc=1
* a small 12-24 DC power supply $6
* a small stepper motor $10

Total cost for the electronics is about $60

A video of the build can be found at the following URL: 
    http://youtu.be/m4VFPw1MFgo

Inside the Arduino folder is the source code for the microcontroller. The VB controller folder
contains a Visual Basic six Windows application that talks to the Arduino over the serial port
to configure it. 

The computer will need to be plugged in at least once to configure it each time,
if you power the Arduino off of the power source as well then you could potentially 
unplug the computer after that. 

The arduino code supports the following options:
             * forwards and back buttons to index position
	* switch so buttons operate as a jog mode
	* home button
	* external trigger pin (to say fire a drill cycle in another arduino)

This program is released free for personal home use. 
If you use it commercially please offer a donation for my time.

here is another open source one by Shane Loucks to look at if interested:
(uses keypad+lcd to configure)

   https://www.youtube.com/watch?v=7p66ACCX1Do
   http://www.cnczone.com/forums/arduino/215402-cnc.html#post1457414

