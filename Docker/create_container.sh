xhost local:root
docker create -t --name ros_gui \
    -e DISPLAY=$DISPLAY \
    -e CYCLONEDDS_URI=$CYCLONEDDS_URI \
    -e XAUTHORITY=$XAUTHORITY \
    --network host \
    --ipc host \
    --privileged \
    --shm-size 8G \
    -v /dev:/dev \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:$XAUTHORITY \
    ros_gui bash
