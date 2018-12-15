#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# ANSI Escape Sequences - https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
# cURL - https://curl.haxx.se/docs/manpage.html
# Incrementing Variables - https://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
# IP Route - http://linux-ip.net/html/tools-ip-route.html


##################
#Get Title Screen#
##################

title_screen() {
	# Title files are loaded with the title.sh script.
	# The title.sh script takes the ASCII title path as a parameter.
	eval "$TITLE_PATH/title.sh $TITLE_PATH/ip-block"
}

####################
#Check Dependencies#
####################

checkCurlInstalled() {
	# Using ldconfig to print the list the libraries stored the in the cache.
	# The standard output is piped to grep, which curl for entries with "curl" in them.
	# If the standard output is empty, cURL is clearly not installed. 
	# The runnable variable is used to keep track of the missing dependencies.
	printf "\n"
	printf "Checking for dependencies...\n"
	if [ "$(ldconfig -p | grep curl)" == "" ] ; then
		printf "Error: cURL library is missing! Please install!\n"
	else
		printf "Done!\n"
		runnable=$((runable+1))
	fi
}

##################
#Update Blacklist#
##################

updateBlacklist() {
	# The blacklist is simply downloaded using cURL. 
	# The user's IP address is gathered from ipinfo.io and is used in the log.
	# The standard output of cURL command, used to download the blacklist is appended to the log file.
	printf "Updating blacklist...\n"
	printf "\n"
	{
		printf "IP: "
		curl -s https://ipinfo.io/ip
		printf " - USER: $USER\n"

	} | paste -d" " -s >> ./logs/blacklist.log
	curl -O "http://myip.ms/files/blacklist/htaccess/latest_blacklist.txt" >> "$LOG_PATH/blacklist.log" 2>&1 
	printf "\nDone!\n"
}

#######################
#Block Blacklisted IPs#
#######################

blockFromBlacklist() {
	# A while loop is used to read the latest_blacklist.txt file.
	# The lines are split, using the " " delimiter and, therefore, each word is put into
	# the "f1", "f2" and "f3" variables, of which "f3" is the IPv4/IPv6 address.
	# Based on the output of "ip route", the file shown to either be "already blocked" or "blocked
	# successfully".
	# The phrases "already blocked" and "blocked successfully" are colors used ANSI Escape Sequences.
	file="latest_blacklist.txt"
	while IFS=" " read -r f1 f2 f3 ; do
		if [ "$f1" == "deny" ]; then
			printf "\n\eBlocking IP \e[1;37m$f3\n"
			if [ "$(ip route add prohibit $f3 2>&1)" == "RTNETLINK answers: File exists" ] ; then
				printf "IP \e[1;37m$f3 \e[1;34malready blocked\e[0m\n"
			else
				printf "IP \e[1;37m$f3 \e[1;32mblocked successfully\e[0m\n"
			fi
		fi
	done < "$file"
}

#################
#Build Interface#
#################

# The script must be executed from the menu.sh script, its relative path to this script being 
# "../../../menu.sh". 
# The "IP_PATH" constant is used to point to the path relative to the "src" folder.
# The other constants point to the paths relative to this script.
IP_PATH="./menus/ip"
TITLE_PATH="./titles"
LOG_PATH="./logs"

# Runnable is used as tracker for missing dependencies.
runnable=0

# Loading the title screen by calling the title_screen function
title_screen

# Changing the directory to that of this script, in order to be able to use relative rather than
# absolute paths.
cd $IP_PATH

# Checking for dependencies and using the "runnable" variable to make sure that the script doesn't run
# unless they are installed.
checkCurlInstalled
if [ "$runnable" -gt "0" ] ; then
	updateBlacklist
	blockFromBlacklist
fi
