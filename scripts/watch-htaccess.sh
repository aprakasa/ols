#!/bin/sh
set -e

WATCH_ENABLED="${HTACCESS_WATCH_ENABLED:-true}"
WATCH_PATH="${HTACCESS_WATCH_PATH:-/var/www/vhosts/localhost/html/}"
DEBOUNCE_SECONDS="${HTACCESS_WATCH_DEBOUNCE:-1}"

if [ "$WATCH_ENABLED" = "false" ]; then
    echo "[htaccess-watcher] Disabled via HTACCESS_WATCH_ENABLED=false"
    exit 0
fi

if ! command -v inotifywait > /dev/null 2>&1; then
    echo "[htaccess-watcher] inotifywait not found, exiting"
    exit 1
fi

echo "[htaccess-watcher] Watching ${WATCH_PATH} for .htaccess changes"

LAST_RELOAD=0

inotifywait -r -q -m -e close_write -e moved_to -e create --format '%w%f' "$WATCH_PATH" 2>/dev/null | while read -r filepath; do
    case "$filepath" in
        */.htaccess*)
            NOW=$(date +%s)
            ELAPSED=$((NOW - LAST_RELOAD))
            if [ "$ELAPSED" -ge "$DEBOUNCE_SECONDS" ]; then
                LAST_RELOAD=$NOW
                echo "[htaccess-watcher] Detected change: ${filepath} — reloading OLS"
                lswsctrl reload 2>/dev/null || true
            fi
            ;;
    esac
done
