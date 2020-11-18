#include "kubot_imu/kubot_imu.h"

int main(int argc, char **argv)
{
  ros::init(argc, argv, "kubot_imu");
  ros::NodeHandle nh, pnh("~");
  KubotIMU kubot_imu(nh, pnh);

  ros::spin();

  return 0;
}
