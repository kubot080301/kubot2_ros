
(cl:in-package :asdf)

(defsystem "kubot_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "BatteryVoltage" :depends-on ("_package_BatteryVoltage"))
    (:file "_package_BatteryVoltage" :depends-on ("_package"))
    (:file "RawImu" :depends-on ("_package_RawImu"))
    (:file "_package_RawImu" :depends-on ("_package"))
  ))