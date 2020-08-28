# KUBOT ROS1 WORKSPACE V2.1

![](https://img.onl/ZLiQM0)

>KUBOT ROS package is developed by Taiwan ShaYangYe Co.Ltd RD400.
>Thanks to ROS wiki, Turtlebot, Pibot, Neuronbot and a large number of ROS users. This package includes the functions to bring up the kubot robot, to make it SLAM, to Navigation, and to simulate it with your own computer. 

# Install KUBOT ROS
###### Currently supports Kinetic and Melodic ROS versions
# 
1.[Install ROS](http://wiki.ros.org/ROS/Installation)
2.Download KUBOT package   
```sh
git clone https://github.com/kubot080301/kubot2_ros.git
```
3.Install KUBOT ROS dependency package
```sh
./kubot2_ros/tools/kubot_install_ros.sh
```
4.Initialization environment
```sh
./kubot2_ros/kubot_init_env.sh
```
After starting the script, you will encounter several options: 
 - please specify kubot model
 - please specify kubot driver board type
 - please specify your kubot lidar
 - please specify the current machine
    - Enter 0 for ROS master, Enter 1 and keyin ip for ROS slave 
```sh
source ~/.zshrc
```
This script uses zsh shell by default. If you use other shells, please modify all [zshrc]() and [zsh]() words in the script.

5.Create ROS workspace
```sh
cd ~/kubot2_ros/ros_ws
catkin_make
source ~/.zshrc
```
##### Then you can enjoy KUBOT ROS !!
try roslaunch or keyin kubot_ *TAB* *TAB*, You can see many of the features command
```sh
roslaunch kubot_bringup bringup.launch
roslaunch kubot_navigation gmapping.launch
```
# KUBOT2_ROS

![](https://img.onl/s7yqkE)
