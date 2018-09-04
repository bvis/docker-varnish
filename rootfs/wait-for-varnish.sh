#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until curl -f http://$host; do
  >&2 echo "Varnish is unavailable - sleeping"
  sleep 1
done

>&2 echo "Varnish is up - executing command: $cmd"
exec $cmd
