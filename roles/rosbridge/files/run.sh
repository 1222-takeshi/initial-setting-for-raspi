#!/bin/bash

source /opt/autoware/services/autoware-launch/setup.sh
ros2 run rosbridge_server rosbridge_websocket --ros-args -r __node:=rosbridge_server_node
