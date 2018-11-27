#!/bin/bash

progress_bar()
{
	printf "Loading... | "
	for x in {1..53}; do
		printf "#"
		sleep .01
	done ; echo
}
title_screen()
{
	clear
	printf "\n"
	cat titles/security-menu
	printf "\n"
	progress_bar
}
done_screen()
{
	while : ; do
		printf "\nWould you like to exit (Y/N)? "
		read exitChoice
		printf "${exitChoice^^}"
		if [ "${exitChoice^^}" = "Y" ] || [ "${exitChoice^^}" = "N" ] ; then
			break
		else
			printf "Invalid value!\n"
			printf "\nTry Again!"
		fi
	done
}
menu_screen()
{
	printf "\n"
	printf "1. Block blacklisted IP addresses\n"
	printf "2. Password generator\n"
	printf "3. Create new users\n"
	printf "4. Package manager\n"
	printf "\n"

	while : ; do
		printf "Enter a number (1-4): "
		read menuChoice
		case "$menuChoice" in
		"1")
			eval "$IP_BLOCK_PATH/ip-block.sh"
			break
			;;
		"2")
			eval "$MENU_PATH/pass-gen.sh"
			break
			;;
		"3")
			eval "$MENU_PATH/new-users.sh"
			break
			;;
		"4")
			eval "$MENU_PATH/pkg-mgr.sh"
			break
			;;
		*)
			printf "Invalid value!\n"
			printf "\nTry again!"
		esac
	done
}

MENU_PATH="./menus"
IP_BLOCK_PATH="$MENU_PATH/ip-block"

title_screen
sleep 0.5

while : ; do
	menu_screen
	done_screen
	case "${exitChoice^^}" in
	"Y")
		break
		;;
	"N")
		;;
	esac
done
