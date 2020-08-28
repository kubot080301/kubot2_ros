#!/bin/bash

# http://wiki.ros.org/ROS/Installation/UbuntuMirrors
#sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
# for robot_pose_ekf
sudo apt install liborocos-bfl-dev

code_name=$(lsb_release -sc)

if [ "$code_name" = "trusty" ]; then
    ros_version="indigo"
elif [ "$code_name" = "xenial" ]; then
    ros_version="kinetic"
elif [ "$code_name" = "bionic" ]; then
    ros_version="melodic"
elif [ "$code_name" = "focal" ]; then
    ros_version="noetic"
else
    echo "KUBOT not support "$code_name
    exit
fi

echo "ros:" $ros_version

if [ "$ros_version" = "melodic" ]; then
    cd ~/kubot2_ros/
    mkdir ros_package
    cd ros_package
    git clone https://github.com/ros-perception/openslam_gmapping.git
    #git clone httliborocos-bfl-devps:liborocos-bfl-dev
read -s -n1 -p "install ros gui tools?(y/N)" 

if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
    sudo apt-get -y --allow-unauthenticated  install ros-${ros_version}-rviz ros-${ros_version}-rqt-reconfigure
fi
# KUBOT2
