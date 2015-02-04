
This is a quick project to add automatic indexing to a manual rotary table.

For this task we use the following components:

* Arduino Uno - $25
* SainSmart CNC Router Single 1 Axis 3.5A TB6560 Stepper Stepping Motor Driver Board WL ($20)
    http://www.amazon.com/gp/product/B008BGLOTQ/ref=oh_aui_detailpage_o09_s00?ie=UTF8&psc=1
* a small 12-24 DC power supply
* a small stepper motor
* a 3 inch rotary table 

Total cost for the project including a small three jaw chuck was about $160
with only a few simple parts needed to be machined to put it together.

A video of the build can be found at the following URL: 
    http://youtu.be/m4VFPw1MFgo

Inside the Arduino folder is the source code for the microcontroller. The VB controller folder
contains a Visual Basic six Windows application that talks to the Arduino over the serial port
to configure it. The computer will need to be plugged in at least once to configure it each time,
if you power the Arduino off of the power source as well then you could potentially unplug the computer
after that. From there on you use the back and forward buttons on the pendant that you create
to move the rotary table either forward or backwards to the next position.

The Arduino code also includes an external trigger pin capability, so that the rotary table can notify an external component
such as another machine that would trigger say a drilling cycle once it has reached the next index position. Between
the button inputs, and the external trigger you could easily automate automatic drilling cycles or similar operations.

This program is released free for personal home use. If you use it commercially please offer a donation for my time.
