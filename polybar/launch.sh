#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# polybar bar1 >>/tmp/polybar1.log 2>&1 &
polybar top >>/tmp/polybar_top.log 2>&1 &

echo "Polybar launched..."
