#!/bin/bash

picom -b &
playerctld &
flameshot &
nm-applet &
gummy start &
setxkbmap -option "caps:escape_shifted_capslock"
pasystray &
thunar --daemon &
dunst &
