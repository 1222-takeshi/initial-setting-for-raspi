#!/bin/bash

DEVICE_NAME=`findmnt / -o SOURCE | tail -n 1`
SID=`sudo /lib/udev/ata_id ${DEVICE_NAME}`

RULES_BODY="KERNEL==\"sd*\", ENV{ID_BUS}==\"ata\", ENV{ID_SERIAL}==\"${SID}\", SYMLINK+=\"sd.%n\""
RULES_FILE="/etc/udev/rules.d/70-persistent-disk.rules"
echo "${RULES_BODY}" | sudo tee ${RULES_FILE} 1>/dev/null

echo "internal SSD name is \"${DEVICE_NAME}\""
echo "internal SSD Serial ID is \"${SID}\""
echo "Complete to register \"${RULES_FILE}\""

udevadm control --reload-rules
