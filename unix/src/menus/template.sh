#!/bin/bash

progress_bar()
{
	printf "Loading... | "
	for x in {1..53}; do
		printf "#"
		sleep .02
	done ; echo
}
title_screen()
{
	clear
	echo
	echo " ____                       _ _           __  __                  "
	echo "/ ___|  ___  ___ _   _ _ __(_) |_ _   _  |  \/  | ___ _ __  _   _ "
	echo "\___ \ / _ \/ __| | | | '__| | __| | | | | |\/| |/ _ \ '_ \| | | |"
	echo " ___) |  __/ (__| |_| | |  | | |_| |_| | | |  | |  __/ | | | |_| |"
	echo "|____/ \___|\___|\__,_|_|  |_|\__|\__, | |_|  |_|\___|_| |_|\__,_|"
	echo "                                  |___/                           "
	echo
	progress_bar
}
menu_screen()
{
	echo
	echo "1. Block blacklisted IP addresses"
	echo "2. Password generator"
	echo "3. Create new users"
	echo "4. Package manager"
	echo
	echo -n "Enter number (1-4): "
	read menuIn
}

title_screen
sleep 0.5
menu_screen

MENU_PATH="./menus"

case "$menuIn" in
"1")
	eval "$MENU_PATH/ip-block.sh"
	;;
"2")
	eval "$MENU_PATH/pass-gen.sh"
	;;
"3")
	eval "$MENU_PATH/new-users.sh"
	;;
"4")
	eval "$MENU_PATH/pkg-mgr.sh"
	;;
*)
	echo "Invalid value!"
esac
