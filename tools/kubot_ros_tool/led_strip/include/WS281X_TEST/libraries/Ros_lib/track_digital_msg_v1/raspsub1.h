#ifndef _ROS_track_digital_msg_v1_raspsub1_h
#define _ROS_track_digital_msg_v1_raspsub1_h

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "ros/msg.h"

namespace track_digital_msg_v1
{

  class raspsub1 : public ros::Msg
  {
    public:
      float raspsub_data[21];

    raspsub1():
      raspsub_data()
    {
    }

    virtual int serialize(unsigned char *outbuffer) const
    {
      int offset = 0;
      for( uint32_t i = 0; i < 21; i++){
      union {
        float real;
        uint32_t base;
      } u_raspsub_datai;
      u_raspsub_datai.real = this->raspsub_data[i];
      *(outbuffer + offset + 0) = (u_raspsub_datai.base >> (8 * 0)) & 0xFF;
      *(outbuffer + offset + 1) = (u_raspsub_datai.base >> (8 * 1)) & 0xFF;
      *(outbuffer + offset + 2) = (u_raspsub_datai.base >> (8 * 2)) & 0xFF;
      *(outbuffer + offset + 3) = (u_raspsub_datai.base >> (8 * 3)) & 0xFF;
      offset += sizeof(this->raspsub_data[i]);
      }
      return offset;
    }

    virtual int deserialize(unsigned char *inbuffer)
    {
      int offset = 0;
      for( uint32_t i = 0; i < 21; i++){
      union {
        float real;
        uint32_t base;
      } u_raspsub_datai;
      u_raspsub_datai.base = 0;
      u_raspsub_datai.base |= ((uint32_t) (*(inbuffer + offset + 0))) << (8 * 0);
      u_raspsub_datai.base |= ((uint32_t) (*(inbuffer + offset + 1))) << (8 * 1);
      u_raspsub_datai.base |= ((uint32_t) (*(inbuffer + offset + 2))) << (8 * 2);
      u_raspsub_datai.base |= ((uint32_t) (*(inbuffer + offset + 3))) << (8 * 3);
      this->raspsub_data[i] = u_raspsub_datai.real;
      offset += sizeof(this->raspsub_data[i]);
      }
     return offset;
    }

    const char * getType(){ return "track_digital_msg_v1/raspsub1"; };
    const char * getMD5(){ return "770acc2c8d9741e13ca6a325ee6c531b"; };

  };

}
#endif