
<pre>

this is code to do rc control mixing so that channel 1 and 2
work as a differential drive.

https://www.youtube.com/watch?v=dldzr-zOr-Q

the original code is in original_motor_pwm
it is from 

/*+++++++++++++++++++++++++++++++++++++++++++++++++++
Author      : Fahmi Ghani
Date        : 11 July 2015 
Project     : Joystick control differential drive dc motor robot
Component   : Analog Joystick
              2Amp motor driver shield
              DC Motor
Description : Control DC motor direction using Joystick
Video :https://www.youtube.com/watch?v=kfT3eoNAM-Q
+++++++++++++++++++++++++++++++++++++++++++++++++++*/

The code I am working with is in the /interrupt folder
and uses additional code from rcarduino.blogspot.com

The rc interrupt code additionally uses the PinChangeInt library v2.402
Apache License, Version 2.0

https://github.com/GreyGnome/PinChangeInt

Copyright 2008 Chris J. Kiick
Copyright 2009-2011 Lex Talionis
Copyright 2010-2014 Michael Schwager (aka, "GreyGnome")

The original diff drive code was to control a motor driver shield with pwm 
speed control.

I have modified it so that it controls two rc servos, which are hooked up
to the hydraulic control valves of a zero turn mowers hydrostatic transmissions.

There is also a vc_test folder which outputs different key joystick translations
to the windows console. not that helpful but easier to test and debug than serial output.
Fahmi's debug output to a small lcd screen was the best debugging setup see the end of his video.

below is a graphic I found on the web that describes diff drive mixing by stick position.

thanks to all of the authors involved for making your work public it was a great help in
my project.

</pre>

![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/servo_diff_drive/Cartesian-Mapping.jpg)