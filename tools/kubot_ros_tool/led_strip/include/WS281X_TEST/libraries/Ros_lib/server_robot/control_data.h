#ifndef _ROS_server_robot_control_data_h
#define _ROS_server_robot_control_data_h

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "ros/msg.h"

namespace server_robot
{

  class control_data : public ros::Msg
  {
    public:
      typedef float _distance_x_type;
      _distance_x_type distance_x;
      typedef float _distance_y_type;
      _distance_y_type distance_y;
      typedef float _angular_th_type;
      _angular_th_type angular_th;

    control_data():
      distance_x(0),
      distance_y(0),
      angular_th(0)
    {
    }

    virtual int serialize(unsigned char *outbuffer) const
    {
      int offset = 0;
      offset += serializeAvrFloat64(outbuffer + offset, this->distance_x);
      offset += serializeAvrFloat64(outbuffer + offset, this->distance_y);
      offset += serializeAvrFloat64(outbuffer + offset, this->angular_th);
      return offset;
    }

    virtual int deserialize(unsigned char *inbuffer)
    {
      int offset = 0;
      offset += deserializeAvrFloat64(inbuffer + offset, &(this->distance_x));
      offset += deserializeAvrFloat64(inbuffer + offset, &(this->distance_y));
      offset += deserializeAvrFloat64(inbuffer + offset, &(this->angular_th));
     return offset;
    }

    const char * getType(){ return "server_robot/control_data"; };
    const char * getMD5(){ return "1fbdebb153fae5f7e70aecdb7e6d85d3"; };

  };

}
#endif