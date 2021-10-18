#!/bin/bash

CONF_FILE=$1
OUTPUT_AT=$(sed -n 's/^output-at=\(.*\)$/\1/p' "${CONF_FILE}")

if [ -e "${OUTPUT_AT}" ];then
  if mountpoint -q "${OUTPUT_AT}"; then
    umount "${OUTPUT_AT}"
  fi
  rmdir ${OUTPUT_AT}*
fi
