#!/usr/bin/env sh

echo $$ > "$UNIBLOCKS_PID"

trap 'canberra-gtk-play -i audio-volume-change && pipeStatic v	"volume"' RTMIN+1

. dynamicModules
. staticModules

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# pipeDynamic 	b 	"battery" 		5m
pipeDynamic 	d 	"dateTime" 	    1m
pipeDynamic 	w 	"wifi" 			30
# pipeDynamic 	s 	"storage" 		1h
# pipeDynamic 	p 	"performance" 	3s

pipeStatic 		v 	"volume"
# pipeStatic 		n 	"notification"

bspc subscribe report > "$PANEL_FIFO" &
# tail -f > "$PANEL_FIFO" &

