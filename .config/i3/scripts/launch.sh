#!/usr/bin/env bash

# 1. Terminate already running bar instances
killall -q polybar

# 2. Wait until the processes have been fully shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Detect monitors and launch a bar on each one
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Passes the monitor name to the config and logs output to /tmp/
    MONITOR=$m polybar --reload main 2>&1 | tee -a /tmp/polybar_$m.log &
    disown
  done
else
  # Fallback if xrandr is somehow not installed
  polybar --reload main 2>&1 | tee -a /tmp/polybar.log &
  disown
fi

echo "Polybar launched on all screens."
