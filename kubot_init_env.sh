#!/bin/bash

sudo ln -sf ~/kubot2_ros/kubot_init_env.sh /usr/bin/kubot_init_env
sudo ln -sf ~/kubot2_ros/tools/kubot_view_env.sh /usr/bin/kubot_view_env
sudo ln -sf ~/kubot2_ros/tools/kubot_install_ros.sh /usr/bin/kubot_install_ros

if ! [ $KUBOT_ENV_INITIALIZED ]; then
    echo "export KUBOT_ENV_INITIALIZED=1" >> ~/.bashrc
    echo "source ~/.kubotrc" >> ~/.bashrc

    #rules
    echo -e "\033[1;32m setup kubot modules"
    echo " "
    sudo cp rules/kubot.rules  /etc/udev/rules.d
    sudo cp rules/rplidar.rules  /etc/udev/rules.d
    sudo cp rules/ydlidar.rules  /etc/udev/rules.d
    sudo cp rules/orbbec.rules  /etc/udev/rules.d
    echo " "
    echo "Restarting udev"
    echo ""

    sudo udevadm control --reload-rules
    sudo udevadm trigger
    #sudo service udev reload
    #sudo service udev restart
fi

code_name=$(lsb_release -sc)

if [ "$code_name" = "trusty" ]; then
    ros_version="indigo"
elif [ "$code_name" = "xenial" ]; then
    ros_version="kinetic"
elif [ "$code_name" = "bionic" ]; then
    ros_version="melodic"
else
    echo -e "\033[1;31m KUBOT not support "$code_name"\033[0m"
    exit
fi 


content="#source ros

if [ ! -f /opt/ros/${ros_version}/setup.bash ]; then 
    echo \"please run cd ~/kubot2_ros/tools && ./kubot_install_ros.sh to install ros sdk\"
else
    source /opt/ros/${ros_version}/setup.bash
fi
"
echo "${content}" > ~/.kubotrc

#LOCAL_IP=`ifconfig eth0|grep "inet addr:"|awk -F":" '{print $2}'|awk '{print $1}'`
#LOCAL_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'`

#if [ ! ${LOCAL_IP} ]; then
#    echo "please check network"
#    exit
#fi

LOCAL_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'`
echo "LOCAL_IP=\`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print \$2}' | awk -F"/" '{print \$1}'\`" >> ~/.kubotrc

if [ ! ${LOCAL_IP} ]; then
    echo -e "\033[1;31m please check network\033[0m"
    exit
fi

echo -e "\033[1;34m Please specify kubot robot model:\033[1;32m
    1:kubot
    2:kubot2
\033[1;34m (or other for user defined) \033[1;33m"

read -p "" KUBOT_MODEL_INPUT

if [ "$KUBOT_MODEL_INPUT" = "1" ]; then
    KUBOT_MODEL='apollo'
elif [ "$KUBOT_MODEL_INPUT" = "2" ]; then
    KUBOT_MODEL='apolloX'
else
    KUBOT_MODEL=$KUBOT_MODEL_INPUT 
fi

echo -e "\033[1;34m Please specify kubot driver board type:\033[1;32m
	1:arduino(mega2560) 
	2:stm32(f103C8) 
	3:stm32(f407ZG)
	4:stm32(f429) 
\033[1;34m (or other for user defined)\033[1;33m"

read -p "" KUBOT_DIRVER_BOARD_INPUT

if [ "$KUBOT_DIRVER_BOARD_INPUT" = "1" ]; then
    KUBOT_DRIVER_BAUD=115200
    KUBOT_BOARD='arduino'
elif [ "$KUBOT_DIRVER_BOARD_INPUT" = "2" ]; then
    KUBOT_DRIVER_BAUD=115200
    KUBOT_BOARD='stm32f1'
elif [ "$KUBOT_DIRVER_BOARD_INPUT" = "3" ]; then
    KUBOT_DRIVER_BAUD=921600
    KUBOT_BOARD='stm32f4'
else
    KUBOT_DRIVER_BAUD=115200
    KUBOT_BOARD=$KUBOT_DIRVER_BOARD_INPUT
fi

python ~/kubot2_ros/ros_ws/src/kubot_bringup/scripts/set_baud.py $KUBOT_DRIVER_BAUD

echo -e "\033[1;34m Please specify  kubot lidar:\033[1;32m
	0:not config
	1:rplidar(a1,a2)
	2:rplidar(a3)
	3:eai(x4)
	4:eai(g4)
	5:xtion
	6:astra
	7:kinectV1
	8:kinectV2
	9:rplidar(s1) 
	10:eai(x4)
	11:realsense(d435i)
\033[1;34m (or other for user defined)\033[1;33m"

read -p "" KUBOT_LIDAR_INPUT

KUBOT_DEEP_CAM=0

if [ "$KUBOT_LIDAR_INPUT" = "0" ]; then
    KUBOT_LIDAR='non-lidar'
elif [ "$KUBOT_LIDAR_INPUT" = "1" ]; then
    KUBOT_LIDAR='rplidar'
elif [ "$KUBOT_LIDAR_INPUT" = "2" ]; then
    KUBOT_LIDAR='rplidar-a3'
elif [ "$KUBOT_LIDAR_INPUT" = "3" ]; then
    KUBOT_LIDAR='eai-x4'
elif [ "$KUBOT_LIDAR_INPUT" = "4" ]; then
    KUBOT_LIDAR='eai-g4'
elif [ "$KUBOT_LIDAR_INPUT" = "5" ]; then
    KUBOT_LIDAR='xtion'
    KUBOT_DEEP_CAM=1
elif [ "$KUBOT_LIDAR_INPUT" = "6" ]; then
    KUBOT_LIDAR='astra'
    KUBOT_DEEP_CAM=1
elif [ "$KUBOT_LIDAR_INPUT" = "7" ]; then
    KUBOT_LIDAR='kinectV1'
    KUBOT_DEEP_CAM=1
elif [ "$KUBOT_LIDAR_INPUT" = "8" ]; then
    KUBOT_LIDAR='kinectV2'
    KUBOT_DEEP_CAM=1
elif [ "$KUBOT_LIDAR_INPUT" = "9" ]; then
    KUBOT_LIDAR='rplidar-s1'
elif [ "$KUBOT_LIDAR_INPUT" = "10" ]; then
    KUBOT_LIDAR='eai-x4'
elif [ "$KUBOT_LIDAR_INPUT" = "11" ]; then
    KUBOT_LIDAR='d435i'
    KUBOT_DEEP_CAM=1
else
    KUBOT_LIDAR=$KUBOT_LIDAR_INPUT
fi

if [ "$KUBOT_LIDAR" = "kinectV2" ]; then
    ln -s $PWD/third_party/iai_kinect2 $PWD/ros_ws/src/
else
    if [ -f $PWD/ros_ws/src/iai_kinect2 ]; then
        rm $PWD/ros_ws/src/iai_kinect2
    fi
fi


if [ $KUBOT_DEEP_CAM = 1 ]; then
    echo "deep_cam: $KUBOT_LIDAR"
    KUBOT_3DSENSOR='non-3dsensor'
else
echo -e "\033[1;34m Please specify  kubot 3dsensor:\033[1;32m
	0:not config
	1:xtion
	2:astra
	3:kinectV1
	4:kinectV2
	5:realsense(d435i)
\033[1;34m (or other for user defined) \033[1;33m"

    read -p "" KUBOT_INPUT

    if [ "$KUBOT_INPUT" = "0" ]; then
        KUBOT_3DSENSOR='non-3dsensor'
    elif [ "$KUBOT_INPUT" = "1" ]; then
        KUBOT_3DSENSOR='xtion'
    elif [ "$KUBOT_INPUT" = "2" ]; then
        KUBOT_3DSENSOR='astra'
    elif [ "$KUBOT_INPUT" = "3" ]; then
        KUBOT_3DSENSOR='kinectV1'
    elif [ "$KUBOT_INPUT" = "4" ]; then
        KUBOT_3DSENSOR='kinectV2'
    elif [ "$KUBOT_INPUT" = "5" ]; then
        KUBOT_3DSENSOR='d435i'
    else
        KUBOT_3DSENSOR=$KUBOT_INPUT
    fi
fi

echo "export ROS_IP=\`echo \$LOCAL_IP\`" >> ~/.kubotrc
echo "export ROS_HOSTNAME=\`echo \$LOCAL_IP\`" >> ~/.kubotrc
echo "export KUBOT_MODEL=${KUBOT_MODEL}" >> ~/.kubotrc
echo "export KUBOT_LIDAR=${KUBOT_LIDAR}" >> ~/.kubotrc
echo "export KUBOT_BOARD=${KUBOT_BOARD}" >> ~/.kubotrc
echo "export KUBOT_3DSENSOR=${KUBOT_3DSENSOR}" >> ~/.kubotrc

echo -e "\033[1;34m Please specify the current machine(ip:$LOCAL_IP) type\033[1;32m
    0:kubot robot
    1:control PC
\033[1;34m (or other for user defined) \033[1;33m"

read -p "" KUBOT_MACHINE_VALUE

if [ "$KUBOT_MACHINE_VALUE" = "0" ]; then
    ROS_MASTER_IP_STR="\`echo \$LOCAL_IP\`"
    ROS_MASTER_IP=`echo $LOCAL_IP`
else
    echo -e "\033[1;34mplase specify the kubot board ip for commnication:\033[1;33m" 
    read -p "" KUBOT_ONBOARD_MACHINE_IP
    ROS_MASTER_IP_STR=`echo $KUBOT_ONBOARD_MACHINE_IP`
    ROS_MASTER_IP=`echo $KUBOT_ONBOARD_MACHINE_IP`
fi

echo "export ROS_MASTER_URI=`echo http://${ROS_MASTER_IP_STR}:11311`" >> ~/.kubotrc

echo -e "\033[1;35m*****************************************************************"
echo "model:" $KUBOT_MODEL 
echo "lidar:" $KUBOT_LIDAR  
echo "3dsenser:" $KUBOT_3DSENSOR
echo "local_ip:" ${LOCAL_IP} 
echo "robot_ip:" ${ROS_MASTER_IP}
echo ""
echo -e "please execute \033[1;36;4msource ~/.bashrc\033[1;35m to make the configure effective\033[0m"
echo -e "\033[1;35m*****************************************************************\033[0m"

#echo "source ~/kubot2_ros/ros_ws/devel/setup.bash" >> ~/.kubotrc 
content="#source kubot

if [ ! -f ~/kubot2_ros/ros_ws/devel/setup.bash ]; then 
    echo \"please run cd ~/kubot2_ros/ros_ws && catkin_make to compile kubot sdk\"
else
    source ~/kubot2_ros/ros_ws/devel/setup.bash
fi
"

#alias
echo "${content}" >> ~/.kubotrc

echo "alias kubot_bri='roslaunch kubot_bringup bringup.launch'" >> ~/.kubotrc 
echo "alias kubot_bri_imu='roslaunch kubot_bringup bringup_with_imu.launch'" >> ~/.kubotrc 

echo "alias kubot_lidar='roslaunch kubot_bringup ${kubot_LIDAR}.launch'" >> ~/.kubotrc 
 
echo "alias kubot_key='roslaunch kubot keyboard_teleop.launch'" >> ~/.kubotrc 
echo "alias kubot_rqt='rosrun rqt_reconfigure rqt_reconfigure'" >> ~/.kubotrc 

echo "alias kubot_gmp='roslaunch kubot_navigation gmapping.launch'" >> ~/.kubotrc 
echo "alias kubot_gmp_imu='roslaunch kubot_navigation gmapping_with_imu.launch'" >> ~/.kubotrc 
echo "alias kubot_save_map='roslaunch kubot_navigation save_map.launch'" >> ~/.kubotrc 
echo "alias kubot_nav='roslaunch kubot_navigation nav.launch'" >> ~/.kubotrc
echo "alias kubot_nav_imu='roslaunch kubot_navigation nav_with_imu.launch'" >> ~/.kubotrc  

echo "alias kubot_save_map001='roslaunch kubot_navigation save_map.launch map_name:==001'" >> ~/.kubotrc 
echo "alias kubot_nav001_imu='roslaunch kubot_navigation nav_with_imu.launch map_name:==001.yaml'" >> ~/.kubotrc

echo "alias kubot_set_a='sudo vim kubot2_ros/ros_ws/src/kubot/launch/navigation_multi_a.launch'" >> ~/.kubotrc
echo "alias kubot_nav_a='roslaunch kubot navigation_multi_a.launch'" >> ~/.kubotrc
echo "alias kubot_set_b='sudo vim kubot2_ros/ros_ws/src/kubot/launch/navigation_multi_b.launch'" >> ~/.kubotrc
echo "alias kubot_nav_b='roslaunch kubot navigation_multi_b.launch'" >> ~/.kubotrc

echo "alias kubot_view='roslaunch kubot_navigation view_nav.launch'" >> ~/.kubotrc 

echo "alias kubot_linear='rosrun kubot calibrate_linear.py'" >> ~/.kubotrc
echo "alias kubot_angular='rosrun kubot calibrate_angular.py'" >> ~/.kubotrc
echo "alias kubot_motor1='rosrun rqt_plot rqt_plot /motor1_input /motor1_output'" >> ~/.kubotrc
echo "alias kubot_motor2='rosrun rqt_plot rqt_plot /motor2_input /motor2_output'" >> ~/.kubotrc
echo "alias kubot_motor_run='rostopic pub cmd_vel linear x:0.2 y:0.0 z:0.0 angular x:0.0 y:0.0 z:0.0 -r 20'" >> ~/.kubotrc

echo "alias kubot_one='roslaunch kubot_navigation gmapping_with_imu_with_cam.launch'" >> ~/.kubotrc
# KUBOT2
# KUBOT_INIT_ENV_SH_
