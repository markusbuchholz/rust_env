#!/usr/bin/env bash

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist $DISPLAY)
    xauth_list=$(sed -e 's/^..../ffff/' <<< "$xauth_list")
    if [ ! -z "$xauth_list" ]
    then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

local_rust="/home/markus/SOFTWARE_DEVELOPMENT/software/rust_env/tests"

docker run -it \
    --rm \
    --name rust_env \
    -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=$XAUTH \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -v "$XAUTH:$XAUTH" \
    -v "$local_rust:/workspace/tests" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix" \
    -v "/etc/localtime:/etc/localtime:ro" \
    -v "/dev/input:/dev/input" \
    --device /dev/dri/card1:/dev/dri/card1 \
    --device /dev/dri/card1:/dev/dri/card2 \
    --privileged \
    --security-opt seccomp=unconfined \
    --network host \
    --gpus all \
    rust_env:latest





