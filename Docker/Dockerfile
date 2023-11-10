FROM nvidia/cudagl:11.4.2-devel-ubuntu18.04

# NVIDIA environment variables
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :99

# Install required utilities first
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    lsb-release \
    curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup ROS repositories
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    less \
    emacs \
    tmux \
    bash-completion \
    command-not-found \
    software-properties-common \
    xsel \
    xdg-user-dirs \
    python-pip \
    python-protobuf \
    python-pexpect \
    pcl-tools \
    libomp5 \
    vulkan-utils \
    ros-melodic-desktop-full \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    ros-melodic-mavros \
    ros-melodic-mavros-extras \
    # Specify exact package names instead of using wildcards
    ros-melodic-rtabmap \
    ros-melodic-octomap \
    ros-melodic-velodyne-gazebo-plugins \
    ros-melodic-octomap-rviz-plugins \
    ros-melodic-turtlebot3 \
    gnome-terminal \
    python3-pip \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    ubuntu-desktop \
    x11vnc \
    xvfb \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# Initialize rosdep
RUN rosdep init && \
    rosdep update

# Install GeographicLib datasets
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh

# Set up the VNC server to run as a daemon
RUN mkdir /root/.vnc && \
    x11vnc -storepasswd "root" /root/.vnc/passwd && \
    echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1024x768x16 &\n\
sleep 5\n\
gnome-session &\n\
x11vnc -display :99 -usepw -forever -shared' > /usr/local/bin/start-vnc-server.sh && \
    chmod +x /usr/local/bin/start-vnc-server.sh

# Expose VNC port
EXPOSE 5900

# Set the working directory
WORKDIR /root

# Make sure the script is executed when the container starts
CMD ["/usr/local/bin/start-vnc-server.sh"]
