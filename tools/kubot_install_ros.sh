#!/bin/bash

# http://wiki.ros.org/ROS/Installation/UbuntuMirrors
#sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update

code_name=$(lsb_release -sc)

if [ "$code_name" = "trusty" ]; then
    ros_version="indigo"
elif [ "$code_name" = "xenial" ]; then
    ros_version="kinetic"
elif [ "$code_name" = "bionic" ]; then
    ros_version="melodic"
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
    git clone https://github.com/ros-perception/slam_gmapping.git
    #git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam.git
    #git clone https://github.com/orbbec/ros_astra_launch.git
    #git clone https://github.com/orbbec/ros_astra_camera.git
    #git clone https://github.com/ros-drivers/openni2_camera.git
    #git clone https://github.com/ros-drivers/freenect_stack.git
    cd ..
    echo "ln -sf $PWD/ros_package ros_ws/src/ros_package"
    ln -snf $PWD/ros_package ros_ws/src/ros_package
    sudo apt-get -y --allow-unauthenticated  install ros-${ros_version}-ros-base ros-${ros_version}-navigation ros-${ros_version}-xacro ros-${ros_version}-yocs-velocity-smoother ros-${ros_version}-robot-state-publisher ros-${ros_version}-joint-state-publisher ros-${ros_version}-teleop-twist-* ros-${ros_version}-control-msgs ros-${ros_version}-kdl-parser-py ros-${ros_version}-tf2-geometry-msgs ros-${ros_version}-slam-karto ros-${ros_version}-usb-cam ros-${ros_version}-image-transport ros-${ros_version}-image-transport-plugins ros-${ros_version}-depthimage-to-laserscan ros-${ros_version}-tf-conversions ros-${ros_version}-orocos-kdl 
else
    sudo apt-get -y --allow-unauthenticated  install ros-${ros_version}-ros-base ros-${ros_version}-slam-gmapping ros-${ros_version}-navigation ros-${ros_version}-xacro ros-${ros_version}-yocs-velocity-smoother ros-${ros_version}-robot-state-publisher ros-${ros_version}-joint-state-publisher ros-${ros_version}-teleop-twist-* ros-${ros_version}-control-msgs ros-${ros_version}-kdl-parser-py ros-${ros_version}-tf2-geometry-msgs ros-${ros_version}-hector-mapping ros-${ros_version}-slam-karto ros-${ros_version}-hector-geotiff ros-${ros_version}-hector-trajectory-server ros-${ros_version}-usb-cam ros-${ros_version}-image-transport ros-${ros_version}-image-transport-plugins ros-${ros_version}-astra-launch ros-${ros_version}-astra-camera ros-${ros_version}-depthimage-to-laserscan ros-${ros_version}-openni2* ros-${ros_version}-freenect-* ros-${ros_version}-tf-conversions ros-${ros_version}-robot-upstart ros-${ros_version}-frontier-exploration ros-${ros_version}-orocos-kdl 
fi

read -s -n1 -p "install ros gui tools?(y/N)" 

if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
    sudo apt-get -y --allow-unauthenticated  install ros-${ros_version}-rviz ros-${ros_version}-rqt-reconfigure
fi
# KUBOT2
