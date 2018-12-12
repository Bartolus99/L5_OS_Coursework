#!/bin/bash

title_screen() {
	eval "$TITLE_PATH/title.sh $TITLE_PATH/security-menu"
}
done_screen() {
	while : ; do
		printf "\nWould you like to exit the menu? (Y/N): "
		read exitChoice
		
		if [ "${exitChoice^^}" = "Y" ] || [ "${exitChoice^^}" = "N" ] ; then
			break
		else
			printf "Invalid value!\n"
			printf "\nTry Again!"
		fi
	done
}
menu_screen() {
	printf "\n"
	printf "1. Block blacklisted IP addresses\n"
	printf "2. Password generator\n"
	printf "3. Password checker\n"
	printf "4. File encrypter\n"
	printf "5. File decrypter\n"
	printf "\n9. Quit\n"

	while : ; do
		printf "\nEnter a number (1-5): "
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
		"4")
			eval "$FILE_PATH/file-crypt.sh file-encrypt"
			break
			;;
		"5")
			eval "$FILE_PATH/file-crypt.sh file-decrypt"
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
TITLE_PATH="./titles"
IP_PATH="$MENU_PATH/ip"
PASS_PATH="$MENU_PATH/pass"
FILE_PATH="$MENU_PATH/file"

title_screen

sleep 0.5

printf "\nChoose which security option you would like to use:\n"
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
