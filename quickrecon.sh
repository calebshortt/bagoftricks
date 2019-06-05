#!/bin/bash

#define RESET	"\033[0m"
#define BLACK	"\033[30m"
#define GREEN	"\033[32m"
#define RED	"\033[31m"

bhist_PATH=~/.bash_history 
msqlhist_PATH=~/.mysql_history


echo ----------------------------------------------------
echo                     QUICK-RECON
echo ----------------------------------------------------

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


# -----------------------------------------------------------------------
#






















