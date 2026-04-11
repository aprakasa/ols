#!/bin/sh

WATCHER_PID=""

_term() {
    kill "$WATCHER_PID" 2>/dev/null || true
    /usr/local/lsws/bin/lswsctrl stop 2>/dev/null || true
    exit 0
}
trap _term TERM INT HUP

/usr/local/lsws/bin/lswsctrl start

/watch-htaccess.sh &
WATCHER_PID=$!

sleep infinity
