
purpose:
-----------------------------------
          display attic temp/humi/dew point, and remotly set a physical knob that determins when 
          an exhaust fan turns on. The knob is attached to a stock humidity sensor that controls 
          power to the 120v fan. We just use a low powered 5v servo to set its position from a
          more convient location downstairs. (as going into the attic involves a ladder, dealing 
          with cold/hot temps, putting on boots, walking through open insulation, tracking said
          insulation back down into the house with me, old bat crap and maybe even actual bats)
          
hardware:
-----------------------------------
          * OLED screen Amazon part number: b00o2llt30: $15  ( 128x64 pixels, I2c , SSD1306 driver )
          * DHT22 temp/humidity sensor                : $10
          * micro hobby servo amazon part B001CFUBN8  : $5 
          * arduino uno clone amazon part B00E5WJSHK  : $13
          * potentiometer, wire, etc..                ------
                                                    ~ $45
          
          you could shrink this down allot cost wise if you eliminate the dht22 and oled screen, then
          you can use an attiny + servo + pot (3+5+1). I probably will in time, but first I want the feedback
          of knowing what the actual temp/humidity is to watch when house ices then I can just draw lines on
          where it should be set for winter. and downsize.

wiring:
-----------------------------------
         * servo on pin 9
         * dht22 on pin 2
         * OLED  on I2C (address 0x3c)
         * pot   on pin A0

notes:   
-----------------------------------
          oleds can burn in, do not leave on, I am just going to battery 
          power and turn on to take spot checks.
         
![screenshot](https://raw.githubusercontent.com/dzzie/home_automation/master/attic_fan/wiring.png)


