#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

# Remove service files
for service_file in $(find $SCRIPT_DIR -name "*.service"); do
  service_name=$(basename $service_file)
  installed_service_file=/etc/systemd/system/$service_name

  if [ -e $installed_service_file ]; then
    echo "Remove $installed_service_file"
    sudo systemctl disable $service_name
    rm $installed_service_file
  fi
done

# Remove directories
rm -rf /opt/autoware/services
