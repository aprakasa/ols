#!/bin/sh

MAIN_PID=""
WATCHER_PID=""

_term() {
    kill "$WATCHER_PID" "$MAIN_PID" 2>/dev/null || true
    wait
    exit 0
}
trap _term TERM INT HUP

/watch-htaccess.sh &
WATCHER_PID=$!

"$@" &
MAIN_PID=$!

wait "$MAIN_PID"
