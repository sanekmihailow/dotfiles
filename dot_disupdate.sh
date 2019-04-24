#!/bin/bash
user="$(who | cut -d' ' -f1 | grep "$current_user" |head -n1)"
vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver"
user_dot=".vimrc .bashrc .bash_profile .screenrc .tmux.conf .source-home .source-root .start-screen"
other_dor="bash.bashrc grc.conf"

echo -e "\n \033[0;32m Are you shure? It's script delete dot files in /etc/ /home/user and /root and restore old dot files.\nAnswer "Ye
s" or "No" \n \033[0m"

read answer &&
if [ "$answer" = 'Yes' ]; then

    #---- Remove current
    echo -e "\nRemoved current dot files"
    for i in $user_dot; do
        rm /home/${user}/${i}
        rm /root/${i}
    done
    
    for a in $other_dot; do
        rm /etc/${a}
    done

    rm /etc/vim/vimrc || rm /etc/vimrc
    rm -rf /usr/share/vim/vim$vim_ver/colors
    rm -rf /usr/share/vim/vim$vim_ver/syntax
    rm -rf /usr/share/grc

    #---- Copy old
    echo -e "\nCopied old dot files"
    for b in $other_dot; do
        cp ./backup_dir/${b} /etc/
    done

    cp ./backup_dir/vimrc /etc/vimrc || cp ./bachkup_dir/vimrc /etc/vim/vimrc
    cp -r ./backup_dir/vim_tar/colors /usr/share/vim/vim$vim_ver/
    cp -r ./backup_dir/vim_tar/syntax /usr/share/vim/vim$vim_ver/
    cp -r ./backup_dir/grc_tar/grc /usr/share/

    for c in $user_dot; do
        cp ./backup_dir/user/${c} /home/${user}/
        cp ./backup_dir/root/${c} /root/
    done
    echo -e "\n \033[0;32m Dot files restored \033[0m"
    exit 0; else
    echo -e "\n \033[0;36m please answer\033[0m \033[0;31m Yes\033[0m \033[0;36m if you change your mind\033[0m"
    exit 1
fi
