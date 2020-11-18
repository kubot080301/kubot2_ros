#!/usr/bin/env python

import rospy
from std_msgs.msg import Byte
from std_msgs.msg import UInt16

#-------------------------Program Initial-------------------------#
rospy.init_node('up_box_node')
pub1 = rospy.Publisher('table_command', Byte, queue_size = 10)
r = rospy.Rate(30)

#-------------------------Variable Declare------------------------#
#button
command=0

#------------------------------Main-------------------------------#
while not rospy.is_shutdown():
	
	command=4
	pub1.publish(command)
	r.sleep()
if __name__ == '__main__':
    rospy.spin()

#----run----
#1.roscore
#2.rosrun rosserial_python serial_node.py _port:=/dev/ttyUSB0
#3.rosrun LED_Strip up_box.py
