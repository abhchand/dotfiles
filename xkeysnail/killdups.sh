#!/bin/bash

# Kill any duplicate `xkeysnail` instances.
# Adapted from https://github.com/rbreaves/kinto/blob/master/linux/killdups.sh

XKEYCOUNT=$(pgrep 'xkeysnail' | wc -l)

if [[ $XKEYCOUNT -le 1 ]]; then
	# No duplicates found found
	exit 0
fi

# Prompt user to enter sudo password
while ! zenity --entry --title="Kinto Duplicates" --text="Type Password to end duplicates:" --hide-text | sudo -S cat /dev/null > /dev/null; do
if ! $(zenity --question --text="Wrong password, try again?"); then
	# User refused to try again, and duplicates still exist. Exit.
	exit 1
fi
done

pgrep 'xkeysnail' | xargs -r -n1 sudo kill

# Remove privilege
sudo -K

exit 0
