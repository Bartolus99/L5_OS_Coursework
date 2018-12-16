#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# ANSI Escape Sequences - http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html


###################
#Load Progress Bar#
###################

progress_bar() {
	# The progress bar adds the "#" character 53 times after the "Loading... | " string.
	# The ideal delay between every character append is 0.01 seconds.
	printf "Loading... | "
	for x in {1..53}; do
		printf "#"
		sleep .01
	done ; echo
}

###################
#Show Title Screen#
###################

title_screen() {
	# An escape sequence (after "\e") is used to clear the screen and move the cursor to the 
	# top of the screen.
	# The title files are separate ASCII text files, which are simply displayed using "cat".
	printf "\e[H\e[J\n"
	cat "$1"
	printf "\n"
	progress_bar
}

# The title screen is loaded with the file path as a parameter.
title_screen $1
