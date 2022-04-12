#!/bin/bash


# Help
################################################################################
function Help()
{
	# Display Help
	echo "Script adding user and set up ssh configurations"
	echo
	echo "Syntax: scriptname.sh -u username -g wheel -k ssh-key"
	echo "options:"
	echo "-u     set username"
	echo "-h     Print this Help."
	echo "-k     set public key for ssh access."
	echo "-g(optional)     set the group for adding if it's needed(such as wheel for sudo)"
}
################################################################################


#Catching cli args
################################################################################
if [ $# -eq 0 ]
	then
		echo "No arguments passed. For help use scriptname.sh -h"
		exit 1
fi

while getopts u:k:g:h flag
do
	case "${flag}" in
		u) username=${OPTARG};;
		k) public_key=${OPTARG};;
		g) group=${OPTARG};;
		h) # display Help
		 Help
		 exit 1;;
	esac
done
################################################################################


function GroupAdd()
{
	  usermod -a -G $group $username
}




function CreatingUser()
{
	if [$username = "jshoyusupov"]; then
		$public_key = $(curl https://raw.githubusercontent.com/f1reSong/scripts/master/j-pub-key)
	else
		$public_key = $(curl https://raw.githubusercontent.com/f1reSong/scripts/master/pub-key)
	fi
	useradd -m -s /bin/bash $username
	mkdir /home/$username/.ssh
	echo $public_key > /home/$username/.ssh/authorized_keys
	chown $username /home/$username/.ssh && chown $username /home/$username/.ssh/authorized_keys
	chmod 0700 /home/$username/.ssh && chmod 0400 /home/$username/.ssh/authorized_keys
	
	if [ $(getent group $group) ]; then
		GroupAdd
	else
		echo "group does not exist."
	fi
}



# Testing
################################################################################
function Test()
{
	if [ -z "$username" ]; 
	then
		echo "You need to add username of user"
		exit 1
	elif [ -z "$public_key" ]; 
	then
		echo "You need to add public ssh key file"
		exit 1
	elif id "$username" &>/dev/null; 
	then
		echo 'user already created'
		exit 1
	fi
	CreatingUser
}
################################################################################


function Main()
{
	Test
}

Main
