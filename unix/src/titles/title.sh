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
	cat "$1"
	printf "\n"
	progress_bar
}

title_screen $1
