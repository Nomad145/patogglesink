#!/bin/sh

# Hacked together script to change the default sink in PulseAudio and moves the
# current inputs to the new default sink.

INPUTS=$(pacmd list-sink-inputs | grep 'index' | awk '{print $2}')
SINKS=$(pacmd list-sinks | grep index | awk -F":" '{print $2}')
ACTIVE=$(pacmd list-sinks | grep "* index" | awk '{print $3}')
INACTIVE=$(pacmd list-sinks | grep "^ \{4,6\}index" | awk '{print $2}')

query() {
	if [ $ACTIVE -eq "0" ]; then
		echo "Headphones"
	elif [ $ACTIVE -eq "1" ]; then
		echo "Speakers"
	fi
}

toggle() {
	pacmd set-default-sink $INACTIVE > /dev/null

	for i in $INPUTS; do
		pacmd move-sink-input $i $INACTIVE > /dev/null
	done
}

case "$1" in
	query)
		query
		;;
	-q)
		query
		;;
	toggle)
		toggle
		;;
	-t)
		toggle
		;;
esac
