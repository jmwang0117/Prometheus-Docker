# Promehteus-Docker

执行 `docker build . -t prometheus -f Docker/Dockerfile`

```
sudo apt-get install -y ros-melodic-mavros ros-melodic-mavros-extras
```

```
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh
```

```
sudo apt-get install -y ros-melodic-rtabmap*
sudo apt-get install -y ros-melodic-octomap-*

git clone https://github.com/stevengj/nlopt.git
cd nlopt
mkdir build
cd build
cmake ..
make
sudo make install
```

```
git clone -b v1.1 https://gitee.com/amovlab/Prometheus.git
cd Prometheus
git branch
```

```
sudo apt-get update
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
git clone -b Prometheus_PX4_1.11.1 https://gitee.com/amovlab/prometheus_px4.git
cd prometheus_px4/
git branch
git submodule update --init --recursive
pip3 install --user toml empy jinja2 packaging
make amovlab_sitl_default gazebo
cd Tools/setup
source ./ubuntu.sh
```



