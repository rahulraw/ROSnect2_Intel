#!/bin/bash

clear
echo "Kinect Driver and ROS Installion"
echo "The following script will install:
	beignet
	libfreenect2 (Kinect2 Driver)
	iai_kinect2  (ROS Driver for Kinect2)"
read -p "Do you wish to continue [Enter]?"

# Install Libfreenect2
cd
git clone https://github.com/OpenKinect/libfreenect2.git
sudo apt-get install build-essential libturbojpeg libjpeg-turbo8-dev libtool autoconf libudev-dev cmake mesa-common-dev freeglut3-dev libxrandr-dev doxygen libxi-dev automake
cd libfreenect2/depends
sh install_ubuntu.sh
sudo dpkg -i libglfw3*_3.0.4-1_*.deb #Ubuntu 14.04 only

# Install Beignet
sudo add-apt-repository ppa:pmjdebruijn/beignet-testing
sudo apt-get install beignet-dev

# Make Libfreenect2
cd ~/libfreenect2
mkdir build && cd build
cmake .. -DENABLE_CXX11=ON
make
sudo make install

# Make UDEV rules for Kinect
cd
sudo cp libfreenect2/rules/90-kinect2.rules /etc/udev/rules.d/

# Install Iai_kinect2
mkdir catkin_ws && cd catkin_ws
mkdir src && cd src
catkin_init_workspace
git clone https://github.com/code-iai/iai_kinect2.git
cd iai_kinect2
rosdep install -r --from-paths .
cd ~/catkin_ws
catkin_make -DCMAKE_BUILD_TYPE="Release"

# Source Files for rosrun iai_kinect
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
. ~/.bashrc 	
