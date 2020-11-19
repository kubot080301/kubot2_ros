; Auto-generated. Do not edit!


(cl:in-package kubot_msgs-msg)


;//! \htmlinclude BatteryVoltage.msg.html

(cl:defclass <BatteryVoltage> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (batterymeter
    :reader batterymeter
    :initarg :batterymeter
    :type cl:boolean
    :initform cl:nil)
   (battery_voltage
    :reader battery_voltage
    :initarg :battery_voltage
    :type cl:float
    :initform 0.0))
)

(cl:defclass BatteryVoltage (<BatteryVoltage>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <BatteryVoltage>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'BatteryVoltage)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name kubot_msgs-msg:<BatteryVoltage> is deprecated: use kubot_msgs-msg:BatteryVoltage instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <BatteryVoltage>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader kubot_msgs-msg:header-val is deprecated.  Use kubot_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'batterymeter-val :lambda-list '(m))
(cl:defmethod batterymeter-val ((m <BatteryVoltage>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader kubot_msgs-msg:batterymeter-val is deprecated.  Use kubot_msgs-msg:batterymeter instead.")
  (batterymeter m))

(cl:ensure-generic-function 'battery_voltage-val :lambda-list '(m))
(cl:defmethod battery_voltage-val ((m <BatteryVoltage>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader kubot_msgs-msg:battery_voltage-val is deprecated.  Use kubot_msgs-msg:battery_voltage instead.")
  (battery_voltage m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <BatteryVoltage>) ostream)
  "Serializes a message object of type '<BatteryVoltage>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'batterymeter) 1 0)) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'battery_voltage))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <BatteryVoltage>) istream)
  "Deserializes a message object of type '<BatteryVoltage>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:setf (cl:slot-value msg 'batterymeter) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'battery_voltage) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<BatteryVoltage>)))
  "Returns string type for a message object of type '<BatteryVoltage>"
  "kubot_msgs/BatteryVoltage")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'BatteryVoltage)))
  "Returns string type for a message object of type 'BatteryVoltage"
  "kubot_msgs/BatteryVoltage")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<BatteryVoltage>)))
  "Returns md5sum for a message object of type '<BatteryVoltage>"
  "d70f523bb615ef811f67251c32690e21")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'BatteryVoltage)))
  "Returns md5sum for a message object of type 'BatteryVoltage"
  "d70f523bb615ef811f67251c32690e21")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<BatteryVoltage>)))
  "Returns full string definition for message of type '<BatteryVoltage>"
  (cl:format cl:nil "Header header~%bool batterymeter~%float32  battery_voltage~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'BatteryVoltage)))
  "Returns full string definition for message of type 'BatteryVoltage"
  (cl:format cl:nil "Header header~%bool batterymeter~%float32  battery_voltage~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <BatteryVoltage>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     1
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <BatteryVoltage>))
  "Converts a ROS message object to a list"
  (cl:list 'BatteryVoltage
    (cl:cons ':header (header msg))
    (cl:cons ':batterymeter (batterymeter msg))
    (cl:cons ':battery_voltage (battery_voltage msg))
))
