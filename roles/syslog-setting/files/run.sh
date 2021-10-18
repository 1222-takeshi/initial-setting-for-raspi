#!/bin/bash

MAX_RETRY=15
INTERVAL_SEC=2

SYSLOG_SETTING_PATH=/media/autoware/ROSBAG/syslog/
SYSLOG_SETTING_FILE_NAME=syslog_setting_`date +%Y%m%d`_`date +%H%M%S`.txt
BAGPACKER_DIRECTORY=/media/autoware/LOG/
BAGPACKER_SETTING_FILE_PATH=""

for i in `/usr/bin/seq 1 ${MAX_RETRY}`; do
  BAGPACKER_SETTING_FILE_PATH=`find ${BAGPACKER_DIRECTORY} -name "*_bagpacker_setting.json"`
  if [ $? -eq 0 -a ${#BAGPACKER_SETTING_FILE_PATH} -ne 0 ]; then
    echo ${BAGPACKER_SETTING_FILE_PATH}
    break
  fi
  /usr/bin/sleep ${INTERVAL_SEC}
done

if [ -z "${BAGPACKER_SETTING_FILE_PATH}" ]; then
    exit 1
fi

FMS_PROJECT_ID=`/usr/bin/jq -r 'select(.project_id !=null) .project_id' ${BAGPACKER_SETTING_FILE_PATH}`
FMS_ENVIRONMENT_ID=`/usr/bin/jq -r 'select(.environment_id !=null) .environment_id' ${BAGPACKER_SETTING_FILE_PATH}`
FMS_VEHICLE_ID=`/usr/bin/jq -r 'select(.vehicle_id !=null) .vehicle_id' ${BAGPACKER_SETTING_FILE_PATH}`
REAL_VEHICLE_ID=`/usr/bin/cut -d '=' -f 2 /home/autoware/vehicle.env`

/usr/bin/echo "fms-project_id=${FMS_PROJECT_ID}" | tee -a ${SYSLOG_SETTING_PATH}${SYSLOG_SETTING_FILE_NAME} > /dev/null
/usr/bin/echo "fms-environment_id=${FMS_ENVIRONMENT_ID}" | tee -a ${SYSLOG_SETTING_PATH}${SYSLOG_SETTING_FILE_NAME} > /dev/null
/usr/bin/echo "fms-vehicle_id=${FMS_VEHICLE_ID}" | tee -a ${SYSLOG_SETTING_PATH}${SYSLOG_SETTING_FILE_NAME} > /dev/null
/usr/bin/echo "individual_params-vehicle_id=${REAL_VEHICLE_ID}" | tee -a ${SYSLOG_SETTING_PATH}${SYSLOG_SETTING_FILE_NAME} > /dev/null
