import struct

# main board
class MessageID:
    ID_GET_VERSION = 0
    ID_SET_ROBOT_PARAMETER = 1
    ID_GET_ROBOT_PARAMETER = 2
    ID_INIT_ODOM = 3
    ID_SET_VEL = 4
    ID_GET_ODOM = 5
    ID_GET_PID_DEBUG = 6
    ID_GET_IMU = 7

class RobotMessage:
    def pack(self):
        return b''

    def unpack(self):
        return True

class RobotFirmwareInfo(RobotMessage):
    def __init__(self):
        self.version = ''
        self.build_time = ''

    def unpack(self, data):
        try:
            upk = struct.unpack('16s16s', bytes(data))
        except:
            return False
        [self.version, self.build_time] = upk
        return True

class RobotParameters():
    def __init__(self, wheel_diameter=0, \
                wheel_track=0, \
                encoder_resolution=0, \
                do_pid_interval=0, \
                kp=0, \
                ki=0, \
                kd=0, \
                ko=0, \
                cmd_last_time=0, \
                max_v_liner_x=0, \
                max_v_liner_y=0, \
                max_v_angular_z=0, \
                imu_type=0, \
                ):
        self.wheel_diameter = wheel_diameter
        self.wheel_track = wheel_track
        self.encoder_resolution = encoder_resolution
        self.do_pid_interval = do_pid_interval
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.ko = ko
        self.cmd_last_time = cmd_last_time
        self.max_v_liner_x = max_v_liner_x
        self.max_v_liner_y = max_v_liner_y
        self.max_v_angular_z = max_v_angular_z
        self.imu_type = imu_type
        self.reserve = b"012345678901234567890123456789"

robotParam = RobotParameters()

class GetRobotParameters(RobotMessage):
    def __init__(self):
        self.param = robotParam

    def unpack(self, data):
        #print(bytes(data), len(bytes(data)))
        upk = struct.unpack('<3H1B8H1B%ds'%(64-(3*2+1+8*2+1)), bytes(data))

        [self.param.wheel_diameter,
         self.param.wheel_track,
         self.param.encoder_resolution,
         self.param.do_pid_interval,
         self.param.kp,
         self.param.ki,
         self.param.kd,
         self.param.ko,
         self.param.cmd_last_time,
         self.param.max_v_liner_x,
         self.param.max_v_liner_y,
         self.param.max_v_angular_z,
         self.param.imu_type,
         self.param.reserve] = upk
        return True

class SetRobotParameters(RobotMessage):
    def __init__(self):
        self.param = robotParam

    def pack(self):
        data = [self.param.wheel_diameter,
                self.param.wheel_track,
                self.param.encoder_resolution,
                self.param.do_pid_interval,
                self.param.kp,
                self.param.ki,
                self.param.kd,
                self.param.ko,
                self.param.cmd_last_time,
                self.param.max_v_liner_x,
                self.param.max_v_liner_y,
                self.param.max_v_angular_z,
                self.param.imu_type,
                self.param.reserve]

        print data
        pk = struct.pack('<3H1B8H1B%ds'%(64-(3*2+1+8*2+1)), *data)
        return pk

    def unpack(self, data):
        return True

class RobotVel(RobotMessage):
    def __init__(self):
        self.v_liner_x = 0
        self.v_liner_y = 0
        self.v_angular_z = 0

    def pack(self):
        data = [self.v_liner_x,
                self.v_liner_y,
                self.v_angular_z]
        pk = struct.pack('3h', *data)
        return pk

    def unpack(self, data):
        return True

#todo the rest of the message classes
class RobotOdom(RobotMessage):
    def __init__(self):
        self.v_liner_x = 0
        self.v_liner_y = 0
        self.v_angular_z = 0
        self.x = 0
        self.y = 0
        self.yaw = 0

    def unpack(self, data):
        try:
            upk = struct.unpack('<3H2l1H', bytes(data))
        except:
            return False
        [self.v_liner_x,
                self.v_liner_y,
                self.v_angular_z,
                self.x,
                self.y,
                self.yaw] = upk
        return True

class RobotPIDData(RobotMessage):
    pass

class RobotIMU(RobotMessage):
    def __init__(self):
        self.imu = [0]*9

    def unpack(self, data):
        try:
            upk = struct.unpack('<9f', bytes(data))
        except:
            return False
        
        self.imu = upk
        return True

BoardDataDict = {MessageID.ID_GET_VERSION:RobotFirmwareInfo(),
            MessageID.ID_GET_ROBOT_PARAMETER:GetRobotParameters(),
            MessageID.ID_SET_ROBOT_PARAMETER:SetRobotParameters(),
            MessageID.ID_SET_VEL:RobotVel(),
            MessageID.ID_GET_ODOM:RobotOdom(),
            MessageID.ID_GET_PID_DEBUG: RobotPIDData(),
            MessageID.ID_GET_IMU: RobotIMU(),
            }

