#!/usr/bin/env sh

del="  |  "
# del=`echo '!Y BG 0x00F0000 fg0xFF00ff00 U0xFFAC739 Y! meow'`

while read -r line; do
   case $line in
      # c*) clk="${line#?}" ;;
      # C*) cal="${line#?}" ;;
      # b*) bat="${line#?}" ;;
      d*) dt="${line#?}" ;;
      # n*) not="${line#?}" ;;
      # p*) per="${line#?}" ;;
      r*) rec="${line#?}" ;;
      # s*) sto="${line#?}" ;;
      w*) wif="${line#?}" ;;
      v*) vol="${line#?}" ;;

      W*)
         wm=
         IFS=':'
         set -- ${line#?}
         while [ "$#" -gt 0 ]; do
            item="$1"
            name="${item#?}"
            case "$item" in
               [mMfFoOuULG]*)
                  case "$item" in
                     [FOU]*) name=" 🏚 " ;;
                     f*) name=" 🕳 " ;;
                     o*) name=" 🌴 " ;;
                     LM | G*?) name="" ;;
                     *) name="" ;;
                  esac
                  wm="${wm} ${name}"
                  ;;
            esac
            shift
         done
         ;;

   esac

   # echo "$wif $del $vol $del $not $del $sto $del $per $del $wm $del $dt $rec"
   # echo "$bat $del $wif $del $vol $del $not $del $sto $del $wm $del $dt $rec"
   # echo "$bat $del $wif $del $vol $del $not $del $wm $del $dt $rec"
   # echo "$bat $del $wif $del $vol $del $wm $del $dt $rec"

   # echo "$wif $del $vol $del $wm $del $dt $rec"

   printf "%s\r" "$wif $del $vol $del $wm $del $dt $rec"

done < "$PANEL_FIFO" &
