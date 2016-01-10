
Long watchdog timer

<pre>
This project is to create a software-based long watchdog.

Materials:
	*ATTiny85
	*200k linear pot
	*400 Ohm resistor
	*misc: perf board, header strip, wire, LED, etc..
	
Note: if you use to small of a pot then it may think the value was changed
due to read variance. The pot size doesnt really matter other than that since its
a relative reading always between 0 and 1023. Its just a matter of sensitivity and
wether its a linear or taper pot. Likewise the resistor value isnt really critical 
either, see what makes your LED have a comfortable glow.

Note2: there are two techniques available for patting the dog. The first one is 
using a digital write. The second one is used with the 555 watchdog circuits. 
These ones set the watchdog pin to a high impedence state when not in use (or to 
pat the dog) to drain the capicator and reset the timeout. Current code using digitalRead
appears to be compatiable with this technique as well. (Even if I have to switch 
to analogRead our existing AtTiny circuit is still ok just a a change to analogRead
and pin swap in the code)


</pre>

![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/LongWatchdog/final_board.jpg)

<pre>
For initial debugging I used two Arduino Uno's. 
</pre>

![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/LongWatchdog/uno_watchdog_bb.png)

<pre>
The final version is designed to run on a $2.50 ATTiny85.
</pre>

![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/LongWatchdog/tiny_watchdog_bb.png)

<pre>
An onboard pot allows you to adjust the time delay for the timeout. 
By default this is set between 3 and 30 seconds. you can scale this differently 
by altering the math.

If in a jumper pin is brought to ground, then the time delay range
is now set between 15 seconds and 2 1/2 minutes. You can calibrate a scale
based on the serial output and draw time markers on a dial around the pot.

The watchdog is powered from the parent device and has four exposed header pins
in line, it is easily breadboardable and very easy to wire. 

It has an onboard pot for time delay settings and an LED that gives you blink 
codes so you can accurately determine its timeout interval. You can adjust the 
time interval on the fly without having to reprogram anything or tear down the 
circuit.

The code impact on your project to pat the dog is extremely small to use the device.
</pre>

![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/LongWatchdog/tiny_circuit.png)

<pre>
The blink code behaviors are as follows for the ATTiny build:

if it detects the pot value has changed (by at least 20) then it will
flash the led 4 times quickly, followed by an led on duration of the real
time value it will use before it resets the parent arduino.
      
everytime it receives a pat, the led will give a brief flicker
if it has to reset the arduino it will do so then give two slow flashs to led

Currently I've been using a 555 timer-based external watchdog, that works well
but is rather expensive at $16. 
  http://www.switchdoc.com/dual-watchdog-timer/

An open source circuit diagram can be found here for another 555 timer-based watchdog:
  https://github.com/mattbornski/Arduino-Watchdog-Circuit
or
  http://www.playwitharduino.com/?p=291&lang=en

A software configurable watchdog can be found here:
  https://github.com/WickedDevice/TinyWatchDog
</pre>

