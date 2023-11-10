FROM nvidia/cudagl:11.4.2-devel-ubuntu18.04

# NVIDIA environment variables
ENV GID 1000
ENV UID 1000
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ENV DEBIAN_FRONTEND noninteractive

# Install required utilities first
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    lsb-release \
    curl \
    apt-utils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# add new sudo user
ENV USERNAME ubuntu
ENV PASSWORD ubuntu
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
    numpy \
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
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep init

USER $USERNAME
WORKDIR /home/$USERNAME
RUN rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
SHELL ["/bin/bash", "-c"]

# Vulkan
# Vulkan
USER root
RUN mkdir -p /etc/vulkan/icd.d && \
    echo '{ "file_format_version" : "1.0.0", "ICD" : { "library_path" : "libGLX_nvidia.so.0", "api_version" : "1.1.99" } }' > /etc/vulkan/icd.d/nvidia_icd.json
RUN echo > /etc/ld.so.preload
USER $USERNAME

# Set display environment variable
ENV DISPLAY :99

# Switch back to user
USER $USERNAME

# Set the working directory
WORKDIR /home/$USERNAME

# Upgrade CMake to version 3.27.7
RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.tar.gz && \
    tar xf cmake-3.27.7-linux-x86_64.tar.gz && \
    rm cmake-3.27.7-linux-x86_64.tar.gz && \
    sudo cp -r cmake-3.27.7-linux-x86_64/* /usr && \
    rm -rf cmake-3.27.7-linux-x86_64

# Install geographiclib datasets
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && \
    sudo chmod +x install_geographiclib_datasets.sh && \
    sudo ./install_geographiclib_datasets.sh

# Install additional packages
RUN sudo apt-get update && \
    sudo apt-get install -y ros-melodic-rtabmap* && \
    sudo apt-get install -y ros-melodic-octomap-* && \
    sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev


# Install NLopt
RUN git clone https://github.com/stevengj/nlopt.git && \
    cd nlopt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install

# Clone Prometheus repository
RUN git clone -b v1.1 https://gitee.com/amovlab/Prometheus.git && \
    cd Prometheus && \
    git branch

# Install Python dependencies
RUN pip install --user toml empy jinja2 packaging
RUN apt-get install libpthread-stubs0-dev

RUN echo 'export LC_ALL=C.UTF-8' >> ~/.bashrc
RUN echo 'export LANG=C.UTF-8' >> ~/.bashrc
RUN echo 'source ~/.bashrc' >> ~/.bashrc


# Clone prometheus_px4 repository
RUN git clone -b Prometheus_PX4_1.11.1 https://gitee.com/amovlab/prometheus_px4.git && \
    cd prometheus_px4 && \
    git branch && \
    git submodule update --init --recursive &&\
    pip3 install --user toml empy jinja2 packaging pyyaml numpy &&\
    make amovlab_sitl_default gazebo &&\
    cd Tools/setup &&\
    source ./ubuntu.sh

# Set up ROS environment
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
USER root
RUN apt-get install -y xorg openbox
RUN apt install -y xfce4 xfce4-goodies vim
RUN apt install -y tightvncserver

# Switch back to user
USER $USERNAME

# Set the working directory
WORKDIR /home/$USERNAME
