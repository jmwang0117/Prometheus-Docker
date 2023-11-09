xhost local:root
docker create -t --name ros_gui --runtime nvidia  -e NVIDIA_VISIBLE_DEVICES=all \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -e CYCLONEDDS_URI=$CYCLONEDDS_URI \
    -e XAUTHORITY=$XAUTHORITY \
    --network host \
    --restart=on-failure \
    --cap-add=SYS_PTRACE \
    --ipc host \
    --privileged \
    --shm-size 8G \
    -v /dev:/dev \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:$XAUTHORITY \
    2d059149e4d8 bash
