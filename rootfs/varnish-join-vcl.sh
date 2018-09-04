#!/bin/bash -e

export JOINED_VCL_FILE=/tmp/all.vcl
echo "Joining configuration files"

for file in $VCL_CONFIG/*.vcl; do echo "# $file"; cat "$file"; done | tee $JOINED_VCL_FILE

if [ -n "${VARNISH_DEBUG_SECRET}" ]; then
    sed -i "s/u0AJAlRWN4/${VARNISH_DEBUG_SECRET}/g" $JOINED_VCL_FILE
fi
