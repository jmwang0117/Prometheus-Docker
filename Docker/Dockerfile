FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
LABEL maintainer="Tiryoh<tiryoh@gmail.com>"

RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq wget curl git build-essential vim sudo lsb-release locales bash-completion tzdata gosu && \
    rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --home-dir /home/ubuntu --shell /bin/bash --user-group --groups adm,sudo ubuntu && \
    echo ubuntu:ubuntu | chpasswd && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN git clone https://github.com/Tiryoh/ros_setup_scripts_ubuntu.git /tmp/ros_setup_scripts_ubuntu && \
    gosu ubuntu /tmp/ros_setup_scripts_ubuntu/ros-melodic-desktop.sh && \
    rm -rf /var/lib/apt/lists/*
ENV USER ubuntu

# Install Mavros package
RUN apt-get update && \
    apt-get install -y ros-melodic-mavros ros-melodic-mavros-extras && \
    rm -rf /var/lib/apt/lists/*

# Install GeographicLib
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh

# Install rtabmap
RUN apt-get update && \
    apt-get install -y ros-melodic-rtabmap* && \
    rm -rf /var/lib/apt/lists/*

# Install Octomap
RUN apt-get update && \
    apt-get install -y ros-melodic-octomap-* && \
    rm -rf /var/lib/apt/lists/*

# Install NLopt
RUN git clone https://github.com/stevengj/nlopt.git && \
    cd nlopt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install

# Download Prometheus project (V1.1)
RUN git clone -b v1.1 https://gitee.com/amovlab/Prometheus.git && \
    cd Prometheus && \
    git branch

RUN apt-get install python3-pip

# PX4 build environment setup and firmware installation (for V1.1)
RUN apt-get update && \
    apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev && \
    git clone -b Prometheus_PX4_1.11.1 https://gitee.com/amovlab/prometheus_px4.git && \
    cd prometheus_px4/ && \
    git branch && \
    git submodule update --init --recursive && \
    pip3 install --user toml empy jinja2 packaging && \
    make amovlab_sitl_default gazebo && \
    cd Tools/setup && \
    source ./ubuntu.sh && \
    rm -rf /var/lib/apt/lists/*

# Install simulation plugins
RUN apt-get update && \
    apt-get install -y ros-melodic-velodyne-gazebo-plugins && \
    apt-get install -y ros-melodic-octomap-rviz-plugins && \
    apt-get install -y ros-melodic-turtlebot3-* && \
    rm -rf /var/lib/apt/lists/*

# Download Gazebo model library
RUN mkdir -p /root/.gazebo/models && \
    cd /root/.gazebo/models && \
    git clone https://gitee.com/potato77/gazebo_model
