#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# Passing Paramters to Bash Functions - https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function


##################
#Get Title Screen#
##################

title_screen() {
	# Title files are loaded with the title.sh script.
	# The title.sh script takes the ASCII title path as a parameter.
	eval "$TITLE_PATH/title.sh $TITLE_PATH/security-menu"
}

##################
#Load Quit Prompt#
##################

done_screen() {
	# The prompt provides validation to accept "Y" or "N" as an input.
	# If the input is lowercase it is made uppercase regardless.
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

##################
#Show Menu Screen#
##################

menu_screen() {
	# The prompt provides validation to accept only the numbers listed in the menu.
	# If an option other than "quit" is chosen, the correct script, relating to the chosen option is executed.
	# The file encryption/decryption scripts require either "file-encrypt" or "file-decrypt" as a parameter.
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

#################
#Build Interface#
#################

# Check if script is run as root or sudo.
# Some scripts in this menu require root/sudo permissions.
if [ "$EUID" -ne 0 ] ; then
	printf "\nPlease run as root!\n"
	exit
fi

# Changing to "./src" directory prevents duplicate code for relative paths.
cd ./src

# Initialising file paths, relative to the "./src" directory.
MENU_PATH="./menus"
TITLE_PATH="./titles"
IP_PATH="$MENU_PATH/ip"
PASS_PATH="$MENU_PATH/pass"
FILE_PATH="$MENU_PATH/file"

# Loading the title screen by calling the title_screen function.
title_screen

sleep 0.5

# The prompt uses function calls to display the correct menu options.
# Once a menu option is chosen a script has finished working, the "done screen" is shown,
# which allows the user to pick if they want to quit. 
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
