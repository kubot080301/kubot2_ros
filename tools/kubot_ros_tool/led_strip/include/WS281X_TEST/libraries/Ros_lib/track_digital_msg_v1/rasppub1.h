#ifndef _ROS_track_digital_msg_v1_rasppub1_h
#define _ROS_track_digital_msg_v1_rasppub1_h

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "ros/msg.h"

namespace track_digital_msg_v1
{

  class rasppub1 : public ros::Msg
  {
    public:
      float rasppub_data[16];

    rasppub1():
      rasppub_data()
    {
    }

    virtual int serialize(unsigned char *outbuffer) const
    {
      int offset = 0;
      for( uint32_t i = 0; i < 16; i++){
      union {
        float real;
        uint32_t base;
      } u_rasppub_datai;
      u_rasppub_datai.real = this->rasppub_data[i];
      *(outbuffer + offset + 0) = (u_rasppub_datai.base >> (8 * 0)) & 0xFF;
      *(outbuffer + offset + 1) = (u_rasppub_datai.base >> (8 * 1)) & 0xFF;
      *(outbuffer + offset + 2) = (u_rasppub_datai.base >> (8 * 2)) & 0xFF;
      *(outbuffer + offset + 3) = (u_rasppub_datai.base >> (8 * 3)) & 0xFF;
      offset += sizeof(this->rasppub_data[i]);
      }
      return offset;
    }

    virtual int deserialize(unsigned char *inbuffer)
    {
      int offset = 0;
      for( uint32_t i = 0; i < 16; i++){
      union {
        float real;
        uint32_t base;
      } u_rasppub_datai;
      u_rasppub_datai.base = 0;
      u_rasppub_datai.base |= ((uint32_t) (*(inbuffer + offset + 0))) << (8 * 0);
      u_rasppub_datai.base |= ((uint32_t) (*(inbuffer + offset + 1))) << (8 * 1);
      u_rasppub_datai.base |= ((uint32_t) (*(inbuffer + offset + 2))) << (8 * 2);
      u_rasppub_datai.base |= ((uint32_t) (*(inbuffer + offset + 3))) << (8 * 3);
      this->rasppub_data[i] = u_rasppub_datai.real;
      offset += sizeof(this->rasppub_data[i]);
      }
     return offset;
    }

    const char * getType(){ return "track_digital_msg_v1/rasppub1"; };
    const char * getMD5(){ return "2a81d54017a4c965271ef9df7cfccd41"; };

  };

}
#endif