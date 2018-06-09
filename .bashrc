color_prompt=yes
homeuser="$(find /home/ -name ".bash_history" 2>/dev/null |awk -F"/" '{print $3}' |head -n1)"

############### source

if [ -d ~/.shell_source ]; then

	if [ "$USER" = "root" ]; then
        	source /home/$homeuser/.shell_source/prompt_root
     		source /home/$homeuser/.shell_source/defaults
     		source /home/$homeuser/.shell_source/functions
     		source /home/$homeuser/.shell_source/exports
     		source /home/$homeuser/.shell_source/alias
	else
        	source $HOME/.shell_source/prompt
		source $HOME/.shell_source/defaults
     		source $HOME/.shell_source/functions
     		source $HOME/.shell_source/exports
     		source $HOME/.shell_source/alias
	fi

     #source .shell _source /git
fi



############ welcome mesage
echo "Hardware Information:"
echo -e "\033[32m sensors \033[0m"
sensors # Needs: 'sudo apt-get install lm-sensors'

echo -e "\033[32m uptime \033[0m"
uptime # Needs: 'sudo apt-get install lsscsi'


echo -e "\033[32m lsscsi \033[0m"
lsscsi

echo -e "\033[32m free \033[0m"
free -m


if [ -x "`which inxi 2>&1`" ]; then
    inxi -IpRS -v0 -c5
fi

#eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/keys/1_id $HOME/.ssh/keys/05_id $HOME/.ssh/keys/123_id)
#source $HOME/.keychain/$HOSTNAME-sh

#comment ------------------------------
#if [[ $- != *i* ]] ; then
#       return
#fi

#if [ -z "$PS1" ]; then
#	return
#fi
