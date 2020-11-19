#!/bin/bash

log_file=/tmp/kubot-upstart.log
echo "$DATE: kubot-start" >> $log_file
kubotenv=/etc/kubotenv
. $kubotenv

code_name=$(lsb_release -sc)

if [ "$code_name" = "trusty" ]; then
    ros_version="indigo"
elif [ "$code_name" = "xenial" ]; then
    ros_version="kinetic"
elif [ "$code_name" = "bionic" ]; then
    ros_version="melodic"
else
    echo "KUBOT not support $code_name" >> $log_file
    exit
fi

echo "SYS_DIST:                $code_name" >> $log_file
echo "ROS_DIST:                $ros_version" >> $log_file
echo "LOCAL_IP:                $LOCAL_IP" >> $log_file
echo "ROS_MASTER_URI:          $ROS_MASTER_URI" >> $log_file
echo "ROS_IP:                  $ROS_IP" >> $log_file
echo "HOSTNAME:                $ROS_HOSTNAME" >> $log_file
echo "KUBOT_MODEL:             $KUBOT_MODEL" >> $log_file
echo "KUBOT_LIDAR:             $KUBOT_LIDAR" >> $log_file
echo "KUBOT_BOARD:             $KUBOT_BOARD" >> $log_file

# ws281x
sudo chown root:root $(catkin_find ws281x ws281x_node)
sudo chmod +s $(catkin_find ws281x ws281x_node)
sudo pigpiod
# add launch file
roslaunch kubot_navigation gmapping_with_imu_with_cam.launch
# python

# KUBOT2
