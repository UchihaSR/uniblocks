#!/bin/sh
#
# Wraps all of your status bar modules into a single string
#     that updates only the part that has changed.
# Dependencies: mkfifo, sleep
# Usage: uniblocks -[g,u]

PANEL_FIFO=/tmp/panel_fifo2
CONFIG=~/.config/uniblocksrc
DELIMITER=" | "

parse() { # Used for parsing modules into the fifo
   while IFS= read -r line; do
      TEMP=${line#*,}
      SCRIPT=${TEMP%,*}
      TAG=${line%%,*}
      INTERVAL=${line##*,}
      if [ "$TAG" = W ]; then # BSPWM specific
         $SCRIPT > $PANEL_FIFO &
      elif [ "$INTERVAL" = 0 ]; then # Static modules
         echo "$TAG$($SCRIPT)" > $PANEL_FIFO &
      else
         while :; do # Dynamic modules
            echo "$TAG$($SCRIPT)"
            sleep "$INTERVAL"
         done > $PANEL_FIFO &
      fi
   done
}

get_module() {
   while IFS= read -r line; do
      case $line in
         "$1"*) echo "$line" && break ;;
      esac
   done < $CONFIG
}

get_tags() {
   while IFS= read -r line; do
      case $line in
         [[:alnum:]]*) echo "${line%%,*}" ;;
      esac
   done < $CONFIG
}

get_config() {
   while IFS= read -r line; do
      case $line in
         [[:alnum:]]*) echo "$line" ;;
      esac
   done < $CONFIG
}

generate() {
   mkfifo $PANEL_FIFO 2> /dev/null # Create fifo if it doesn't exist
   get_config | parse              # Parse the modules into the fifo
   sleep 1                         # Give the fifo a little time to process all the module

   trap 'kill 0' INT TERM QUIT EXIT # Setup up trap for cleanup
   while IFS= read -r line; do      # Parse moudles out from the fifo
      TAGS=$(get_tags)              # Get tag lists from the config
      status=
      for tag in $TAGS; do
         case $line in
            # Match the correct tag with the fifo line
            $tag*) echo "${line#$tag}" > /tmp/"$tag" ;;
         esac
         # These lines are to do with the presenation
         [ -z "$status" ] && read -r status < /tmp/"$tag" && continue
         read -r newstatus < /tmp/"$tag"
         status="$status $DELIMITER $newstatus"
      done
      printf "\r%s" "$status" # Print the result
   done < $PANEL_FIFO
}

case $1 in
   --gen | -g) generate ;;
   --update | -u) [ -e $PANEL_FIFO ] && get_module "$2" | parse ;;
esac
