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

# add new sudo user
ENV USERNAME jmwang
ENV PASSWORD wjm
ENV HOME /home/$USERNAME
RUN groupadd -f -g ${GID} ${USERNAME}
RUN useradd -m $USERNAME -u ${UID} -g ${GID} && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    mkdir /etc/sudoers.d && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME
    
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



RUN rosdep init

USER $USERNAME
WORKDIR /home/$USERNAME
RUN rosdep update

SHELL ["/bin/bash", "-c"]

# Vulkan
RUN mkdir -p /etc/vulkan/icd.d && \
    echo '{ "file_format_version" : "1.0.0", "ICD" : { "library_path" : "libGLX_nvidia.so.0", "api_version" : "1.1.99" } }' > /etc/vulkan/icd.d/nvidia_icd.json
RUN echo > /etc/ld.so.preload

# Install Ubuntu desktop and VNC server
RUN apt-get update && apt-get install -y --no-install-recommends \
    ubuntu-desktop \
    x11vnc \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up VNC server
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd $PASSWORD ~/.vnc/passwd

# Set up the VNC server to run as a daemon
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1024x768x16 &\n\
sleep 5\n\
startxfce4 &\n\
x11vnc -display :99 -usepw -forever -shared' > /usr/local/bin/start-vnc-server.sh && \
    chmod +x /usr/local/bin/start-vnc-server.sh

# Expose VNC port
EXPOSE 5900

# Set display environment variable
ENV DISPLAY :99

# Switch back to user
USER $USERNAME

# Make sure the script is executed when the container starts
CMD ["/usr/local/bin/start-vnc-server.sh"]
