#!/bin/bash

echo "Starting shutdown."

source /opt/autoware/services/autoware-launch/setup.sh

echo "Sending message to Web.Auto Agent."
timeout 5 ros2 service call /webauto/shutdown std_srvs/srv/SetBool 'data: true'

echo "Sending message to Autoware."
timeout 5 ros2 service call /autoware/shutdown std_srvs/srv/Trigger

echo "Waiting for autoware-launch.service to be closed."
pkill ros2
kill -9 $(pgrep -f __node)
kill -9 $(pgrep -f ros-args)

n=0
max=3
while true; do
  result=$(systemctl is-active autoware-launch.service)
  echo "autoware-launch.service $result"
  if [ "$result" = "inactive" ] || [ "$result" = "failed" ]; then
    echo "Succeeded."
    break
  fi
  n=$((n+1))
  if [ $n -lt $max ]; then
    echo "Waiting."
    sleep 1
  else
    echo "Failed."
    break
  fi
done

echo "Done."
