 #!/bin/bash

progress_bar()
{
	progress="Loading... | "
	for x in {1..53}; do
		printf "\r$progress"
		progress="${progress}#"
		sleep .02
	done ; echo
}

update_list()
{
	printf
	wget "http://myip.ms/files/blacklist/htaccess/latest_blacklist.txt"
}




spinning(){
i=1
sp="/-\|"
echo -n ' '
while true
do
	printf "\r${sp:i++%${#sp}:1}"
	sleep 0.1
done
}


spinning & progress_bar
