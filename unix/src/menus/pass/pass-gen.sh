#!/bin/bash

# Author Bartosz Stasik - U1730148
# Co-Author Joshua Button - U1628860 - www.JoshuaButton.co.uk


############
#References#
############

# ANSI Escape Sequences - https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
# Bash Glossary (including /dev/urandom) - https://www.tldp.org/LDP/abs/html/xrefindex.html
# IBM's Valid Password Character List - https://www.ibm.com/support/knowledgecenter/en/SSFPJS_8.5.7/com.ibm.wbpm.imuc.doc/topics/rsec_characters.html
# If Statement Expressions - http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
# Regular Expressions - http://tldp.org/LDP/abs/html/x17129.html
# Regular Expressions - http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_04_01.html


##################
#Get Title Screen#
##################

title_screen() {
	# The tiles are loaded with the title.sh script.
	# The title.sh script takes the ASCII title path as a parameter.
	eval "$TITLE_PATH/title.sh $TITLE_PATH/pass-gen"
}

#####################
#Validate Complexity#
#####################

validate() {
	# The function takes 4 parameters and uses them to make sure that they are valid.
	# The first if statment makes sure that none of the values are empty and the second makes sure
	# the only accepted values are "Y" or "N". 
	# If the user inputs lowercase letters, they are made uppercase anyway.
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

###################
#Generate Password#
###################

generate() {
	# Uses /dev/urandom to generate a random string, which includes the selected characters.
	# A Regular Expression is made, depending on the complexity the user selected and length
	# depends on the variable "length".
	# The special characters follow IBM's accepted password character list.
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

#################
#Build Interface#
#################

# The script must be executed from menu.sh script; its relative path to this script being
# "../../../menu.sh".
# The "TITLE_PATH" constant is used to point to the path relative to the "src" folder.
TITLE_PATH="./titles"

# Loading the title screen by calling the title_screen function.
title_screen

# The user is given the option to choose the complexity level and length. 
# The complexity is dependent on the first four prompts, all of which are validated.
# The validation also prevents the user from choosing "N" for all four options.
# Once the user decides on the complexity level, they are asked to confirm.
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

# The user is asked to choose the length of the password, which is limited to 2048.
# The field is validated using both REGEX and regular comparison.
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
