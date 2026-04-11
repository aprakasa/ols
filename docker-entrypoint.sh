#!/bin/sh

WATCHER_PID=""

_term() {
    kill "$WATCHER_PID" 2>/dev/null || true
    /usr/local/lsws/bin/lswsctrl stop 2>/dev/null || true
    exit 0
}
trap _term TERM INT HUP

if [ -e /dev/random ] && [ -e /dev/urandom ]; then
    mv /dev/random /dev/random.bak 2>/dev/null || true
    ln -s /dev/urandom /dev/random 2>/dev/null || true
fi

hostname ols 2>/dev/null || true

/usr/local/lsws/bin/lswsctrl start

/watch-htaccess.sh &
WATCHER_PID=$!

sleep infinity
