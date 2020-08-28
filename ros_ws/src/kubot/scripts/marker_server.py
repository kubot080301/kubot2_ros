#!/usr/bin/env python
import rospy
from geometry_msgs.msg import Twist, Pose
from interactive_markers.interactive_marker_server import *
from visualization_msgs.msg import *
import tf
from tf.transformations import euler_from_quaternion
import copy

def processFeedback(feedback):
    _,_,yaw = euler_from_quaternion((feedback.pose.orientation.x, feedback.pose.orientation.y, feedback.pose.orientation.z, feedback.pose.orientation.w))

    twist = Twist()
    twist.angular.z = 2.2 * yaw
    twist.linear.x = 1.0 * feedback.pose.position.x

    vel_pub.publish(twist)

    server.setPose("kubot_marker", Pose())
    server.applyChanges()

if __name__ == "__main__":
    rospy.init_node("interactive_marker_server")
    server = InteractiveMarkerServer("kubot_marker_server")
    vel_pub = rospy.Publisher("cmd_vel", Twist, queue_size = 5)
    int_marker = InteractiveMarker()
    int_marker.header.frame_id = "base_link"
    int_marker.name = "kubot_marker"


    control = InteractiveMarkerControl()
    control.orientation_mode = InteractiveMarkerControl.FIXED
    control.orientation.w = 1
    control.orientation.x = 1
    control.orientation.y = 0
    control.orientation.z = 0
    control.name = "move_x"
    control.interaction_mode = InteractiveMarkerControl.MOVE_AXIS
    control.always_visible = True
    int_marker.controls.append(copy.deepcopy(control))

    control.orientation.w = 1
    control.orientation.x = 0
    control.orientation.y = 1
    control.orientation.z = 0
    control.name = "rotate_z"

    control.interaction_mode = InteractiveMarkerControl.MOVE_ROTATE
    int_marker.controls.append(copy.deepcopy(control))

    server.insert(int_marker, processFeedback)

    server.applyChanges()

    rospy.spin()
