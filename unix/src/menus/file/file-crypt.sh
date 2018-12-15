#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# ANSI Escape Sequences - https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
# Bash Select - http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_06.html
# GNU Privacy Guard - https://www.gnupg.org/
# GnuPG Manual - https://www.gnupg.org/gph/en/manual/x110.html
# If Statement Expressions - http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
# Passing Parameters - https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function
# Unix Exit Codes - https://shapeshed.com/unix-exit-codes/ 


##################
#Get Title Screen#
##################

title_screen() {
	# Title files are loaded with the title.sh script.
	# The title.sh script takes the ASCII title path as a parameter.
	eval "$TITLE_PATH/title.sh $TITLE_PATH/$TYPE"
}

##############
#Encrypt File#
##############

encrypt() {
	# The selected file is encrypted using "gpg" - specifically using symmetric
	# encryption.
	# The exit code of the "gpg" command is checked and the user is informed of
	# a failed or successful encryption process.
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

##############
#Decrypt File#
##############

decrypt() {
	# The selected file is decrypted using "gpg" and the standard output is
	# saved in a new file.
	# The exit code of the "gpg" command is checked and the user is informed of
	# a failed or successfull decryption process.
	# If the decryption process was successfull, the newly created file overwrites
	# the original.
	# If unsuccessful, the newly created file is removed.
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

#################
#Get Target File#
#################

crypt_file() {
	# The files and folders are shown using the select statements.
	# The user input is validated for invalid values, based on the existence of a file or 
	# folder.
	# If user chooses a folder, the function is called recursively until a file is
	# selected.
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

#################
#Build Interface#
#################

# The script must be executed from the menu.sh script; its relative path to this script being
# "../../../menu.sh".
# The "TITLE_PATH" constant is used to point to the path relative to the "src" folder.
# The "TYPE" constant is used to later check if the selected file is to be encrypted or
# decrypted.
TITLE_PATH="./titles"
TYPE="$1"

# Loading the title screen by calling the title_screen function.
title_screen

# The user is given an option to enter the absolute path, in which the target file is located.
# If the full path isn't known, the user can browse the directories, thanks to the 
# "crypt_tile" function.
# User input is of course validated, to make sure the path actually exists.
final_path=""
while : ; do
	printf "\nEnter the absolute folder path: "
	read path

	if [ -d "$path" ] && [[ ! "$path" = \.* ]] ; then
		final_path="$path"
		break
	else
		printf "The specified folder/path does not exist!\n"
		printf "\nTry again!"
	fi
done

# The "crypt_file" function, described above, is called with the absolute file path as
# a parameter.
crypt_file "$final_path"
