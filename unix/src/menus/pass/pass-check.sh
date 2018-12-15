#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# ANSI Espace Sequences - https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
# Regular Expressions - http://tldp.org/LDP/abs/html/x17129.html
# Regular Expressions - http://tldp.org/LDP/abs/html/x17129.html
# Valid Password Characters - https://www.ibm.com/support/knowledgecenter/en/SSFPJS_8.5.7/com.ibm.wbpm.imuc.doc/topics/rsec_characters.html


##################
#Get Title Screen#
##################

title_screen() {
	# Title files are loaded with the title.sh script.
	# The title.sh script takes the ASCII title path as a parameter.
	eval "$TITLE_PATH/title.sh $TITLE_PATH/pass-check"
}

#################
#Build Interface#
#################

# The script must be executed from the menu.sh script; its relative path to this script being
# "../../../menu.sh".
# The "TITLE_PATH" constant is used to point to the path relative to the "src" folder.
TITLE_PATH="./titles"

# Loading the title screen by calling the title_screen function.
title_screen

# Displaying the disclaimer and prompt. 
# No specific validation required, as the code uses REGEX to check complexity.
printf "\n\e[37mIMPORTANT: \e[0mYour password will \e[1;31mNOT\e[0m be displayed or saved anywhere!\n"
printf "\nEnter a password to check: "
read -s password
printf "\n"

# The "complexity" variable is used to keep track of the password "score".
complexity="0"
if [ "${#password}" -le 7 ] ; then
	complexity="-1"
else
	if [ "${#password}" -ge 10 ] ; then
		complexity=$((complexity+1))
	fi
	if [[ $password =~ [0-9] ]] ; then
		complexity=$((complexity+1))
	fi
	if [[ $password =~ [a-z] ]] ; then
		complexity=$((complexity+1))
	fi
	if [[ $password =~ [A-Z] ]] ; then
		complexity=$((complexity+1))
	fi
	if [[ $password =~ [^a-zA-Z0-9] ]] ; then
		complexity=$((complexity+1))
	fi
fi


# Based on the complexity "score", the user is presented  with different answers.
# Results are coloured using ANSI Escape Sequences (following \e).
case "$complexity" in
	"-1")
		printf "\nYour password is \e[1;31mweak!\e[0m\n"
		printf "You should make it longer!\n"
		;;
	"0"|"1")
		printf "\nYour password is \e[1;31mweak!\e[0m\n"
		printf "You should add more variation!\n"
		;;
	"2")
		printf "\nYour password is \e[1;33mmedium!\e[0m\n"
		printf "It might work for a while, but you should increase the complexity!\n"
		;;
	"3")
		printf "\nYour password is \e[1;32mstrong!\e[0m\n"
		printf "You might be good, but you should still increase the complexity!\n"
		;;
	"4")
		printf "\nYour password is \e[1;34mvery strong!\e[0m\n"
		printf "Well done! Perhaps you could still add more complexity?\n"
		;;
	"5")
		printf "\nYour password is \e[1;36multra strong!\e[0m\n"
		printf "Epic job! There shouldn\'t be more to it other than making it longer!\n"
		;;
	*)
		printf "\nOops! Something went wrong!\n"
esac
