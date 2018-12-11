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
	printf "\e[H\e[J\n"
	cat titles/security-menu
	printf "\n"
	progress_bar
}
done_screen()
{
	while : ; do
		printf "\nWould you like to exit? (Y/N): "
		read exitChoice
		
		if [ "${exitChoice^^}" = "Y" ] || [ "${exitChoice^^}" = "N" ] ; then
			break
		else3
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
	printf "3. Password checker\n"
	printf "\n9. Quit\n"
	printf "\n"

	while : ; do
		printf "Enter a number (1-4): "
		read menuChoice
		case "$menuChoice" in
		"1")
			eval "$IP_PATH/ip-block.sh"
			break
			;;
		"2")
			eval "$PASS_PATH/pass-gen.sh"
			break
			;;
		"3")
			eval "$PASS_PATH/pass-check.sh"
			break
			;;
		"9")
			break
			;;
		*)
			printf "Invalid value!\n"
			printf "\nTry again!"
		esac
	done
}

if [ "$EUID" -ne 0 ] ; then
	printf "\nPlease run as root!\n"
	exit
fi

cd ./src

MENU_PATH="./menus"
IP_PATH="$MENU_PATH/ip"
PASS_PATH="$MENU_PATH/pass"

title_screen
sleep 0.5

while : ; do
	menu_screen
	done_screen
	case "${exitChoice^^}" in
	"Y")
		exit
		;;
	"N")
		title_screen
		;;
	esac
done
