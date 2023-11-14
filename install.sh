#!/bin/bash


# 捕捉 Ctrl + C 信号并执行指定的命令
# trap 'handle_ctrl_c' INT

# handle_ctrl_c() {
#     echo -e "\033[36m*********************************************************\033[0m"
#     echo -e "\033[36m*               Successfully Installed!                 *\033[0m"
#     echo -e "\033[36m*                                                       *\033[0m"
#     echo -e "\033[36m*               PLease run the Simulation               *\033[0m"
#     echo -e "\033[36m*         Using command ---- source run.sh ----         *\033[0m"
#     echo -e "\033[36m*********************************************************\033[0m"
#   exit 0
# }


echo -e "\033[36m*********************************************************\033[0m"
echo -e "\033[36m*                                                       *\033[0m"
echo -e "\033[36m*            Installing the required dependence         *\033[0m"
echo -e "\033[36m*               This may take a while...                *\033[0m"
echo -e "\033[36m*                                                       *\033[0m"
echo -e "\033[36m*********************************************************\033[0m"

cd

sudo apt-get install ros-${ROS_DISTRO}-mavros ros-${ROS_DISTRO}-mavros-extras ros-${ROS_DISTRO}-mavros-msgs

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

sudo bash ./install_geographiclib_datasets.sh


cd

git clone https://github.com/PX4/PX4-Autopilot.git --recursive

cd PX4-Autopilot && git submodule update --init --recursive

bash Tools/setup/ubuntu.sh

touch run.sh

echo '#! /bin/bash' > run.sh && echo 'source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default' >> run.sh && echo 'export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)' >> run.sh && echo 'export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic' >> run.sh && echo 'roslaunch px4 myBoat.launch' >> run.sh

chmod a+x run.sh

git clone https://github.com/HETONGAPP/custom_boat.git

cp -r custom_boat/myboat Tools/simulation/gazebo-classic/sitl_gazebo-classic/models/

cp custom_boat/1071_gazebo-classic_myboat ROMFS/px4fmu_common/init.d-posix/airframes/

cp custom_boat/myBoat.launch launch/

cp -rf custom_boat/CMakeLists.txt ROMFS/px4fmu_common/init.d-posix/airframes/

sudo rm -rf custom_boat

echo -e "\033[36m*********************************************************\033[0m"
echo -e "\033[36m*                                                       *\033[0m"
echo -e "\033[36m*                 Building the px4                       \033[0m"
echo -e "\033[36m*               This may take a while...                *\033[0m"
echo -e "\033[36m*                                                       *\033[0m"
echo -e "\033[36m*********************************************************\033[0m"

HEADLESS=1 make px4_sitl gazebo &


# wait

# 等待用户按下任意键
echo "Press any key to continue..."
read -n 1 -s
    echo -e "\033[36m*********************************************************\033[0m"
    echo -e "\033[36m*               Successfully Installed!                 *\033[0m"
    echo -e "\033[36m*                                                       *\033[0m"
    echo -e "\033[36m*               PLease run the Simulation               *\033[0m"
    echo -e "\033[36m*         Using command ---- source run.sh ----         *\033[0m"
    echo -e "\033[36m*********************************************************\033[0m"





