#!/bin/bash

update_blacklist() {
	printf "Updating blacklist...\n"
	printf "\n"
	{
		printf "IP: "
		curl -s https://ipinfo.io/ip
		printf " - USER: $USER\n"

	} | paste -d" " -s >> logs/blacklist.log
	wget "http://myip.ms/files/blacklist/htaccess/latest_blacklist.txt" >> logs/blacklist.log 2>&1 
	printf "\nDone!\n"
}

file="./menus/ip-block/latest_blacklist.txt"
while IFS=" " read -r f1 f2 f3 f4 f5 f6
do
	if [ "$f1" == "deny" ]; then
		ip route add prohibit $f3
	fi
done < "$file"
