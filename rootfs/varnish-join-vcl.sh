#!/bin/sh

set -e

export JOINED_VCL_FILE=/tmp/merged.vcl
export JOINED_VCL_FILE=/tmp/all.vcl
echo "Joining configuration files"
cat $VCL_CONFIG/*.vcl > $JOINED_VCL_FILE

[ -n "${VARNISH_DEBUG_SECRET}" ] && sed -i "s/u0AJAlRWN4/${VARNISH_DEBUG_SECRET}/g" $JOINED_VCL_FILE

