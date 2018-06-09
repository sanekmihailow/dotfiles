#
# /etc/bash.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


[[ $DISPLAY ]] && shopt -s checkwinsize

PS1='[\u@\h \W]\$ '
#PS1="\`if [ \$? = 0 ]; then echo \[\e[32m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi\`${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\[\e[1;92m\]\\n#------------------------------------------------------------------------------------------------------------\[\e[0m\]\[\e[37m\](\H)\[\e[0m\] \[\e[1m\]\#-[\d]\[\e[0m\] \n \[\e[22;33m\]\t\[\e[0m\] \[\e[0;93m\]j=\j\[\e[0m\] \[\e[1;101m\]\u\[\e[0m\]\[\e[1;91m\]@\[\e[0m\]\[\e[1;36m\]\h\[\e[0m\]: \[\e[1;94m\]\w\[\e[0m\] \n \n \[\e[1;91m\]\\$\[\e[0m\] "

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

#source /root/.bashrc_root
source $HOME/.bashrc

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

if [ -f /etc/bash_complation ]; then
	. /etc/bash_complation
fi

#setterm blength 0



