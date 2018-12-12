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
	cat titles/pass-check
	printf "\n"
	progress_bar
}

title_screen

printf "\nEnter a password to check: "
read -s password
printf "\n"

complexity="0"
if [ "${#password}" -le 7 ] ; then
	complexity="0"
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
	"0"|"1")
		printf "\nYour password is \e[1;31mweak!\e[0m\n"
		printf "You should add more variation!\n"
		;;
	"2")
		printf "\nYour password is \e[208mmedium!\e[0m\n"
		printf "It might work for a while, but you should increase the complexity!\n"
		;;
	"3")
		printf "\nYour password is \e[1;33mstrong!\e[0m\n"
		printf "You might be good, but you should still increase the complexity!\n"
		;;
	"4")
		printf "\nYour password is \e[1;32mvery strong!\e[0m\n"
		printf "Well done! Perhaps you could still add more complexity?\n"
		;;
	"5")
		printf "\nYour password is \e[1;34multra strong!\e[0m\n"
		printf "Epic job! There shouldn\'t be more to it other than making it longer!\n"
		;;
	*)
		printf "\nOops! Something went wrong!\n"
esac
