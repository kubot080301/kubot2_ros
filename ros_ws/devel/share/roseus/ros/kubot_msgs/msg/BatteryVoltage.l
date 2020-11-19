;; Auto-generated. Do not edit!


(when (boundp 'kubot_msgs::BatteryVoltage)
  (if (not (find-package "KUBOT_MSGS"))
    (make-package "KUBOT_MSGS"))
  (shadow 'BatteryVoltage (find-package "KUBOT_MSGS")))
(unless (find-package "KUBOT_MSGS::BATTERYVOLTAGE")
  (make-package "KUBOT_MSGS::BATTERYVOLTAGE"))

(in-package "ROS")
;;//! \htmlinclude BatteryVoltage.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass kubot_msgs::BatteryVoltage
  :super ros::object
  :slots (_header _batterymeter _battery_voltage ))

(defmethod kubot_msgs::BatteryVoltage
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:batterymeter __batterymeter) nil)
    ((:battery_voltage __battery_voltage) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _batterymeter __batterymeter)
   (setq _battery_voltage (float __battery_voltage))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:batterymeter
   (&optional __batterymeter)
   (if __batterymeter (setq _batterymeter __batterymeter)) _batterymeter)
  (:battery_voltage
   (&optional __battery_voltage)
   (if __battery_voltage (setq _battery_voltage __battery_voltage)) _battery_voltage)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; bool _batterymeter
    1
    ;; float32 _battery_voltage
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; bool _batterymeter
       (if _batterymeter (write-byte -1 s) (write-byte 0 s))
     ;; float32 _battery_voltage
       (sys::poke _battery_voltage (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; bool _batterymeter
     (setq _batterymeter (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; float32 _battery_voltage
     (setq _battery_voltage (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get kubot_msgs::BatteryVoltage :md5sum-) "d70f523bb615ef811f67251c32690e21")
(setf (get kubot_msgs::BatteryVoltage :datatype-) "kubot_msgs/BatteryVoltage")
(setf (get kubot_msgs::BatteryVoltage :definition-)
      "Header header
bool batterymeter
float32  battery_voltage

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :kubot_msgs/BatteryVoltage "d70f523bb615ef811f67251c32690e21")


