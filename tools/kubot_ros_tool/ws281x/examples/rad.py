import rospy
from led_msgs.srv import SetLEDs
from led_msgs.msg import LEDStateArray, LEDState

led_count = rospy.get_param('led/led_count')
set_leds = rospy.ServiceProxy('led/set_leds', SetLEDs, persistent=True)

def fill_strip(red, green, blue):
    print set_leds(leds=[LEDState(i, red, green, blue) for i in range(led_count)])

fill_strip(255,0,0)

