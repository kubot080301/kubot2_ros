#include <ros/ros.h>
#include "kubot_bringup/base_driver.h"

int main(int argc, char *argv[])
{
    ros::init(argc, argv, "kubot_driver");
    
    BaseDriver::Instance()->work_loop();

    ros::spin();

    return 0;
}