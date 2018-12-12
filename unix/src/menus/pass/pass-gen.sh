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
	cat titles/pass-gen
	printf "\n"
	progress_bar
}
validate() {
	array=($1 $2 $3 $4)
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] ; then
		printf "Invalid value!\n"
	else
		for i in "${array[@]}" ; do
			if [ ! "${i^^}" = "Y" ] && [ ! "${i^^}" = "N" ] ; then
				printf "!"
				break
			fi
		done
	fi
}
generate() {
	filter=""
	if [ ${upperAz^^} = "Y" ] ; then
		filter="${filter}A-Z"
	fi
	if [ ${lowerAz^^} = "Y" ] ; then
		filter="${filter}a-z"
	fi
	if [ ${numbers^^} = "Y" ] ; then
		filter="${filter}0-9"
	fi
	if [ ${nonAlpha^^} = "Y" ] ; then
		printf ""
		filter="${filter}[!()-.?[]_\`~;:@#$%^&+=]"
	fi
	</dev/urandom tr -dc $filter | head -c $length ; echo ""
}

title_screen

isValid="1"
while [ "$isValid" = 1 ] ; do
	while : ; do
		printf "\n"
		printf "Include lowercase a-z (Y/N)? "
		read lowerAz
		printf "Include uppercase A-Z (Y/N)? "
		read upperAz
		printf "Include numbers 0-9 (Y/N)? "
		read numbers
		printf "Include non-alphanumeric (Y/N)? "
		read nonAlpha
		values=$(validate "$lowerAz" "$upperAz" "$numbers" "$nonAlpha")
		if [ ! -z "$values" ] ; then
			printf "Invalid values!\n"
			printf "\nTry again!"
		elif [ "${lowerAz^^}" == "N" ] && [ "${upperAz^}" == "N" ] && [ "${numbers^^}" == "N" ] && [ "${nonAlpha^^}" == "N" ] ; then
			printf "Invalid values!\n"
			printf "\nTry again!"
		else
			break
		fi	
	done

	while : ; do
		printf "\nYour options: \n"
		printf "Lowercase a-z: \e[1;34m${lowerAz^^}\e[0m\n"
		printf "Uppercase A-Z: \e[1;34m${upperAz^^}\e[0m\n"
		printf "Numbers 0-9: \e[1;34m${numbers^^}\e[0m\n"
		printf "Non-alphanumber: \e[1;34m${nonAlpha^^}\e[0m\n"
		printf "\nIs that correct (Y/N)? "
		read correct
		case "${correct^^}" in
			"Y")
				isValid=$((isValid-1))
				break
				;;
			"N")
				break
				;;
			*)
				printf "Invalid value!\n"
				printf "\nTry again!"
		esac
	done
done
while : ; do
	printf "\nEnter length (MAX 2048): "
	read length
	if [[ $length =~ ^[0-9]+$ ]] && [ $length -ge 1 ] && [ $length -le 2048 ] ; then
		printf "Your password is:\n"
		generate
		break
	else
		printf "Invalid value!\n"
		printf "\nTry again!"
	fi
done
#TODO: check if all are N
