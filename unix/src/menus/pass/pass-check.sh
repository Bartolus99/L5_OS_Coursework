#!/bin/bash

title_screen() {
	eval "$TITLE_PATH/title.sh $TITLE_PATH/pass-check"
}

TITLE_PATH="./titles"

title_screen

printf "\n\e[37mIMPORTANT: \e[0mYour password will \e[1;31mNOT\e[0m be displayed or saved anywhere!\n"
printf "\nEnter a password to check: "
read -s password
printf "\n"

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
