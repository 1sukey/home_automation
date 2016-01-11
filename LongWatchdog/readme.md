
Long watchdog timer

<pre>
This project is to create a software-based long watchdog.

Materials:
	*ATTiny85
	*200k linear pot
	*400 Ohm resistor
	*misc: perf board, header strip, wire, LED, etc..
	
Notes: the diode between the tiny and reset line allows you to upload sketches to the
arduino without having to remove the reset connection wire. 

older versions had an optional time multiplier jumper. I have removed this so I could use
the pin as an optional disable line. The circuit itself is still fine, no rewiring, just 
use the old jumper header with a female connector.

An onboard pot allows you to adjust the time delay for the timeout. 
By default this is set between 9 and 90 seconds. you can scale this differently 
by altering the math.

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

* if it detects the pot value has changed then it will flash the led 4 times 
quickly, followed by an led on duration of the real time value it will use 
before it resets the parent arduino.
      
* everytime it receives a pat, the led will give a brief flicker

* if it has to reset the arduino it will do so then give two slow flashs to led

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

