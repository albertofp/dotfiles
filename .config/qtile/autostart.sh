#!/bin/bash

picom -b &
playerctld &
flameshot &
nm-applet &
pgrep -u "$USER" -x redshift-gtk || redshift-gtk -l 52.52:13.405 -t 6500:4500 &
setxkbmap -option "caps:escape_shifted_capslock"
# pasystray &
thunar --daemon &
dunst &
