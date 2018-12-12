#!/bin/bash

title_screen() {
	eval "$TITLE_PATH/title.sh $TITLE_PATH/$TYPE"
}
encrypt() {
	printf "\nEncrypting file $1\n"
	gpg -c "$1"
	if [ "$?" = "0" ] ; then
		mv "$1.gpg" "$1"
		printf "\nFile \e[37m$1 \e[1;32msuccessfully \e[0mencrypted!\n"
	else
		rm "$1.gpg"
		printf "\nFile \e[37m$1 \e[1;31munsuccessfully \e[0mencrypted\n"
	fi
}
decrypt() {
	printf "\nDecrypting file $1\n"
	gpg --yes --decrypt "$1" > "$1~"
	if [ "$?" = "0" ] ; then
		mv "$1~" "$1"
		printf "\nFile \e[37m$1 \e[1;32msuccessfully \e[0mdecrypted!\n"
	else
		rm "$1~"
		printf "\nFile \e[37m$1 \e[1;31munsuccessfully \e[0mdecrypted\n"
	fi
}
crypt_file() {
	printf "\nPATH: $1\n"
	cd "$1"
	printf "\n"
	PS3="Select file number: "
	select FILENAME in $(ls) 'QUIT' ; do
		if [ -d "$FILENAME" ] ; then
			crypt_file "$1/$FILENAME"
			break
		elif [ -e "$FILENAME" ] ; then
			if [ "$TYPE" = "file-encrypt" ] ; then
				encrypt "$FILENAME"
			elif [ "$TYPE" = "file-decrypt" ] ; then
				decrypt "$FILENAME"
			else
				printf "\nSomething went wrong! Exiting...\n"
				exit
			fi
			break
		else
			case $FILENAME in
				"QUIT")
					break
					;;
				*)
					printf "Invalid value!\n"
					printf "\nTry again!\n"
			esac
		fi
	done
}

TITLE_PATH="./titles"
TYPE="$1"

title_screen

final_path=""
while : ; do
	printf "\nEnter the absolute folder path: "
	read path
	if [ -d "$path" ] ; then
		final_path="$path"
		break
	else
		printf "The specified folder/path does not exist!\n"
		printf "\nTry again!"
	fi
done

crypt_file "$final_path"
