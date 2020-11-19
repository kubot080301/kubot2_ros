
sudo apt-get install build-essential cmake pkg-config libusb-1.0-0-dev libturbojpeg libjpeg-turbo8-dev libglfw3-dev libopenni2-dev

cd ~/pibot_ros/third_party/libfreenect2/build
cmake .. -DENABLE_CXX11=ON
make 
sudo make install
sudo cp ../platform/linux/udev/90-kinect2.rules /etc/udev/rules.d/
