#!/bin/bash

# Determine current, next, and last desktop *index* (starts at 0)
MAX_DESKTOP=$(($(wmctrl -d | wc -l)-1))
CUR_DESKTOP=$(wmctrl -d | grep '*' | cut -d' ' -f1)
NEW_DESKTOP=$((CUR_DESKTOP+1))

# Wrap around if needed
if [ "$NEW_DESKTOP" -gt "$MAX_DESKTOP" ]; then
  NEW_DESKTOP=0
fi

# Find the process id of the application of the current window
ACTIVE_WINDOW_ID=$(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/')
PID=$(wmctrl -lp | grep $ACTIVE_WINDOW_ID | cut -d' ' -f4)

# Find all windows associated to this application process
wmctrl -lp | grep $PID | cut -d' ' -f1 | while read -r line ; do
  wmctrl -r $line -i -t $NEW_DESKTOP
done

# Move current view
wmctrl -s $NEW_DESKTOP
