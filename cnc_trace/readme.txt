
this project is an experiment to use a cnc machine with
rotary encoders, to be able to trace paths and record points
like a digitizer or corridinate measure machine.

the path/points are recorded and gcode is produced which the
cnc machine can then replay.

1) readEncoder folder is the arduino sketch to read the encoders
and output the positions to the serial port.

2) readpos is the vb6 app to watch the serial port output from arduino
and record it to produce gcode. (note the encoder output is calibrated to 
my machine)

3) Encoder_library.zip is the encoder arduino library to install
from pjrc.com

you can find a blog post which goes in more depth and includes a video
here:

 http://sandsprite.com/blogs/index.php?uid=13&pid=377
