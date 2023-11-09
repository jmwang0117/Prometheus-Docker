FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
LABEL maintainer="Tiryoh<tiryoh@gmail.com>"

RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq apt-utils && \
    apt-get install -yq wget curl git build-essential vim sudo lsb-release locales bash-completion tzdata gosu && \
    rm -rf /var/lib/apt/lists/*


RUN useradd --create-home --home-dir /home/ubuntu --shell /bin/bash --user-group --groups adm,sudo ubuntu && \
    echo ubuntu:ubuntu | chpasswd && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add ROS source and install required dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
    rm -rf /var/lib/apt/lists/*

# Initialize rosdep and update
# Initialize rosdep and update
RUN rosdep init && \
    gosu ubuntu rosdep update


# Install ROS Melodic
RUN git clone https://github.com/Tiryoh/ros_setup_scripts_ubuntu.git /tmp/ros_setup_scripts_ubuntu && \
    gosu ubuntu /tmp/ros_setup_scripts_ubuntu/ros-melodic-desktop.sh && \
    rm -rf /var/lib/apt/lists/*

ENV USER ubuntu

# Install additional packages and dependencies
RUN apt-get update && \
    apt-get install -y \
    ros-melodic-mavros \
    ros-melodic-mavros-extras \
    ros-melodic-rtabmap* \
    ros-melodic-octomap-* \
    ros-melodic-velodyne-gazebo-plugins \
    ros-melodic-octomap-rviz-plugins \
    ros-melodic-turtlebot3-* \
    gnome-terminal \
    python3-pip \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev && \
    rm -rf /var/lib/apt/lists/*

# Install GeographicLib
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh

# Install required dependencies and update CMake
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*


# Install NLopt
RUN git clone https://github.com/stevengj/nlopt.git && \
    cd nlopt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install

# Download Gazebo model library
RUN mkdir -p /root/.gazebo/models && \
    cd /root/.gazebo/models && \
    git clone https://gitee.com/potato77/gazebo_model
