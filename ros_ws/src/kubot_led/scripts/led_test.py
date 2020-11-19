#!/usr/bin/env python
from led_control import Strip
if __name__ == '__main__':
    port='/dev/kubot_led' ## Port for the Arduino Board
    num=30 ## The number of LED units
    s=Strip(port,num) ## Initialize the strip.
    
    s.clear() ## Turn all LED units off.
    s.delay(1000) ## Wait 1000 ms to let the strip have enough time to execute the command.
                  ## Feel free to change the delay time.  
    s.setPixelColor(1,180,0,0) ## Define NO.1 LED unit be red with intensity 100.
                               ## We only define the LED unit, but the light is still off.
    s.show() ## Turn on strip.
    s.delay(1000)
    s.demo() ## Display all basic function in class Strip.
    s.close() ## Disconnect the serial port object.