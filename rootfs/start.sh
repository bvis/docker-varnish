#!/bin/bash -e

export JOINED_VCL_FILE=$VCL_CONFIG

if [ -d "$VCL_CONFIG" ]; then
    source /varnish-join-vcl.sh
fi

# Allows to replace placeholders in the VLC prepended by *VARNISH_PARAM_*
set +e
params=$(printenv | grep VARNISH_PARAM_)
set -e

if [ "$params" ]; then
  while read -r line
  do
    var_name=$(echo ${line%=*})
    var_value=$(echo ${line#*=})
    sed -i -e "s/#$var_name#/$var_value/g" $JOINED_VCL_FILE
  done < <(echo "$params")
fi

# if command starts with an option, prepend varnishd
if [ "${1:0:1}" = '-' ]; then
	set -- varnishd "$@"
fi

if [[ "$@" = 'varnishd' ]]; then
	set -- varnishd -F \
      -f $JOINED_VCL_FILE \
      -s malloc,$CACHE_SIZE \
      $VARNISHD_PARAMS
fi

if [ -n "${DEBUG+x}" ]; then
    echo "Show VCL";
    cat -n $JOINED_VCL_FILE
fi

exec "$@"
