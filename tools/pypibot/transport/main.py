import platform
import sys
sys.path.append("..")
import pypibot
from pypibot import log
from transport import Transport
from dataholder import MessageID
import params

#for linux
port="/dev/pibot"

#for windows
#port="com3"
TEST_SET_PARAM = False

pypibot.enableGlobalExcept()
#log.enableFileLog(log_dir + "ros_$(Date8)_$(filenumber2).log")
log.setLevel("i")

if __name__ == '__main__':
    mboard = Transport(port, params.pibotBaud)
    if not mboard.start():
        log.error("can not open %s"%port)
        sys.exit()
    
    import time
    time.sleep(3)
    DataHolder = mboard.getDataHolder()

    log.info("****************get robot version*****************")
    boardVersion = DataHolder[MessageID.ID_GET_VERSION]
    p = mboard.request(MessageID.ID_GET_VERSION)
    if p:
        log.info("firmware version:%s buildtime:%s\r\n"%(boardVersion.version.decode(), boardVersion.build_time.decode()))
    else:
        log.error('request firmware version err\r\n')
        quit(1)

    # get robot parameter
    robotParam = DataHolder[MessageID.ID_GET_ROBOT_PARAMETER]
    p = mboard.request(MessageID.ID_GET_ROBOT_PARAMETER)
    if p:
        log.info("wheel_diameter:%d wheel_track:%d encoder_resolution:%d" \
                 %(robotParam.param.wheel_diameter, \
                   robotParam.param.wheel_track, \
                   robotParam.param.encoder_resolution
                   ))

        log.info("do_pid_interval:%d kp:%d ki:%d kd:%d ko:%d" \
                 %(robotParam.param.do_pid_interval, \
                   robotParam.param.kp, \
                   robotParam.param.ki, \
                   robotParam.param.kd, \
                   robotParam.param.ko))

        log.info("cmd_last_time:%d imu_type:%d" \
                 %(robotParam.param.cmd_last_time,\
                   robotParam.param.imu_type
                   ))

        log.info("max_v:%d %d %d\r\n" \
                 %(robotParam.param.max_v_liner_x,\
                   robotParam.param.max_v_liner_y, \
                   robotParam.param.max_v_angular_z
                   ))
    else:
        log.error('request get param err\r\n')
        quit(1)


    if TEST_SET_PARAM:
        log.info("****************set robot parameter*****************")
        
        DataHolder[MessageID.ID_SET_ROBOT_PARAMETER].param = params.pibotParam

        p = mboard.request(MessageID.ID_SET_ROBOT_PARAMETER)
        if p:
            log.info('request set parameter success')
        else:
            log.error('request set parameter err')
            quit(1)

    log.info("****************get odom&imu*****************")
    while True:
        robotOdom = DataHolder[MessageID.ID_GET_ODOM]
        p = mboard.request(MessageID.ID_GET_ODOM)
        if p:
            log.info('request get odom success vx=%d vy=%d vangular=%d x=%d y=%d yaw=%d'%(robotOdom.v_liner_x, \
                                                        robotOdom.v_liner_y, \
                                                        robotOdom.v_angular_z, \
                                                        robotOdom.x, \
                                                        robotOdom.y, \
                                                        robotOdom.yaw))
        else:
            log.error('request get odom err')
            quit(1)
        
        robotIMU = DataHolder[MessageID.ID_GET_IMU].imu
        p = mboard.request(MessageID.ID_GET_IMU)
        if p:
            log.info('request get imu success \nimu=[%f %f %f\n    %f %f %f\n    %f %f %f]\n'%(robotIMU[0], robotIMU[1], robotIMU[2], \
                                                                                        robotIMU[3], robotIMU[4], robotIMU[5], \
                                                                                        robotIMU[6], robotIMU[7], robotIMU[8]))
        else:
            log.error('request get imu err')
            quit(1)
       
	import time
        time.sleep(1) 
