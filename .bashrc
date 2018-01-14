

############### source
if [ -d ~/.shell_source ]; then
     source .shell_source/defaults
     source .shell_source /functions
     source .shell _source /exports
     source .shell _source /alias
     source .shell _source /prompt
     #source .shell _source /git
fi

############ welcome mesage
echo "Hardware Information:"
sensors # Needs: 'sudo apt-get install lm-sensors'
uptime # Needs: 'sudo apt-get install lsscsi'
lsscsi
free -m

if [ -x "`which inxi 2>&1`" ]; then
    inxi -IpRS -v0 -c5
fi

#comment ------------------------------
#if [[ $- != *i* ]] ; then
#       return
#fi

#if [ -z "$PS1" ]; then
#	return
#fi
