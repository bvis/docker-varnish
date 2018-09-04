#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until curl -sf -o /dev/null http://$host; do
  >&2 echo "Varnish is unavailable - sleeping"
  sleep 1
done

>&2 echo "Varnish is up - executing command: $cmd"
exec $cmd
