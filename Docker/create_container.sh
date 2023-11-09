docker run -d --restart=on-failure \
    --name ros_gui \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    --shm-size=8g \
    -p 10022:22  \
    -p 14000:4000  \
    gezp/ubuntu-desktop:18.04-cu11.2.2
