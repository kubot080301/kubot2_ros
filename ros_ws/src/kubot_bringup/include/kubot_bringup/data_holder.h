#ifndef DATA_HOLDER_H_
#define DATA_HOLDER_H_

#include <string.h>

#pragma pack(1)


typedef int int32;
typedef short int16;
typedef unsigned short uint16;

struct Robot_firmware{
    char version[16]; //控制板版本
    char time[16];    //建構時間
};

struct Robot_parameter{
    union{
        char buff[64];
        struct{   
            unsigned short wheel_diameter;      // 輪子直徑(mm)
            unsigned short wheel_track;         // 輪子中心距(mm)
            unsigned short encoder_resolution;  // 編碼器解析度
            unsigned char do_pid_interval;      // PID間隔 (ms)
            unsigned short kp;
            unsigned short ki;
            unsigned short kd;
            unsigned short ko;                  // PID比例
            unsigned short cmd_last_time;       // 命令維持時間(ms)，超過該時間會自動停止運動
            unsigned short max_v_liner_x;       // 最大X方向線速度
            unsigned short max_v_liner_y;       // 最大Y方向線速度 (差分輪為0)
            unsigned short max_v_angular_z;     // 最大旋轉速度
            unsigned char imu_type;
        };
    };
};

struct Robot_velocity{
    short v_liner_x;    // 線速度 前>0 cm/s
    short v_liner_y;    // 差分輪為0  cm/s
    short v_angular_z;  // 角速度 左>0 0.01rad/s  100 means 1 rad/s    
};

struct Robot_odom{
    short v_liner_x;      // 線速度 前>0 後<0  cm/s
    short v_liner_y;      // 差分輪 为0        cm/s
    short v_angular_z;    // 角速度 左>0 右<0  0.01rad/s   100 means 1 rad/s
    int32 x;              // 里程计座標x       cm (long 4個字節)
    int32 y;              // 里程计座標y       cm (long 4個字節)
    short yaw;            // 里程计航角        0.01rad     100 means 1 rad
};

struct Robot_pid_data{
    int32 input[4];       // 驅動輪子的輸入值
    int32 output[4];      // 輪子的輸出值
};

#pragma pack(0)

class Data_holder{
    public:
        static Data_holder* get(){
            static Data_holder dh;
            return &dh;
        }

        void load_parameter();

        void save_parameter();
    
    private:
        Data_holder(){
            memset(&firmware_info, 0, sizeof(struct Robot_firmware));
            memset(&parameter, 0, sizeof(struct Robot_parameter));
            memset(&velocity, 0, sizeof(struct Robot_velocity));
            memset(&odom, 0, sizeof(struct Robot_odom));
            memset(&pid_data, 0, sizeof(struct Robot_pid_data));
            memset(&imu_data, 0, sizeof(imu_data));
            memset(&battery_voltage, 0, sizeof(battery_voltage));
            }
    public:
        struct Robot_firmware  firmware_info;
        struct Robot_parameter  parameter;
        struct Robot_velocity  velocity;
        struct Robot_odom      odom;
        struct Robot_pid_data  pid_data;

        float imu_data[9];
        float battery_voltage[1] ;                //電池電壓
};
#endif
// KUBOT_DATA_HOLDER_H_