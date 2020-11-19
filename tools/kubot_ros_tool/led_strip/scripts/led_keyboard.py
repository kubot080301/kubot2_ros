#!/usr/bin/env python
import roslib; roslib.load_manifest('teleop_twist_keyboard')
import rospy
import sys, select, termios, tty

from geometry_msgs.msg import Twist
from std_msgs.msg import Byte
from std_msgs.msg import UInt16

msg = """
Reading from the keyboard  and Publishing to light!
---------------------------

1 : //one color light//
2 : //star light//
3 : //rainbow light//
4 : //breathe rainbow light//
5 : //breathe light//

CTRL-C to quit
"""

#-------------------------Program Initial-------------------------#
rospy.init_node('led_key_node')
pub1 = rospy.Publisher('table_command', Byte, queue_size = 10)
r = rospy.Rate(30)

#-------------------------Variable Declare------------------------#
#button
command=0

moveBindings = {
		'1':(1),
		'2':(2),
		'3':(3),
		'4':(4),
		'5':(5),
	       }

def getKey():
	tty.setraw(sys.stdin.fileno())
	select.select([sys.stdin], [], [], 0)
	key = sys.stdin.read(1)
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
	return key

	
while(1):
	key = getKey()
	if key in moveBindings.keys():
		i = moveBindings[key][0]
	elif key :
		i = 0
	print i
	command=i
	pub1.publish(command)
	r.sleep()



