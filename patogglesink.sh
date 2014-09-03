#!/bin/sh

# Hacked together script to change the default sink in PulseAudio and moves the
# current inputs to the new default sink.

INPUTS=$(pacmd list-sink-inputs | grep 'index' | awk '{print $2}')
SINKS=$(pacmd list-sinks | grep index | awk -F":" '{print $2}')
ACTIVE=$(pacmd list-sinks | grep "* index" | awk '{print $3}')
INACTIVE=$(pacmd list-sinks | grep "^ \{4,6\}index" | awk '{print $2}')

pacmd set-default-sink $INACTIVE > /dev/null

if [ -n $INPUTS ]; then
	for i in $INPUTS; do
		pacmd move-sink-input $i $INACTIVE > /dev/null
	done
fi
