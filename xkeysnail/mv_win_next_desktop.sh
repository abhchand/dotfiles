#!/bin/bash

# Moves current active window to the next desktop,
# Wraps around to the first desktop if needed.
#
# Ensure the number of workspaces/desktops is static and fixed,
# not "dynamic". Otherwise moving to the next workspace will further create
# a new additional empty workspace, infinitely.

# Determine current, next, and last desktop *index* (starts at 0)
MAX_DESKTOP=$(($(wmctrl -d | wc -l)-1))
CUR_DESKTOP=$(wmctrl -d | grep '*' | cut -d' ' -f1)
NEW_DESKTOP=$((CUR_DESKTOP+1))

# Wrap around if needed
if [ "$NEW_DESKTOP" -gt "$MAX_DESKTOP" ]; then
  NEW_DESKTOP=0
fi

# Move active window and move the current view
wmctrl -r :ACTIVE: -t $NEW_DESKTOP && wmctrl -s $NEW_DESKTOP
