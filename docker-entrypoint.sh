#!/bin/sh
set -e

/watch-htaccess.sh &

exec "$@"
