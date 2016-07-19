#!/bin/sh

set -e

export JOINED_VCL_FILE=/tmp/merged.vcl
echo "Joining configuration files"
cat $VCL_CONFIG/*.vcl > $JOINED_VCL_FILE
awk '{print NR, $0}' $JOINED_VCL_FILE
