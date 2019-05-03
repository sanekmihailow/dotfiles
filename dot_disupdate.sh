#!/bin/bash
user="$(who | cut -d' ' -f1 | grep "$current_user" |head -n1)"
vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver"
user_dot=".vimrc .bashrc .bash_profile .screenrc .tmux.conf .source-home .source-root .start-screen"
other_dor="bash.bashrc grc.conf"

echo -e "\n \033[0;32m Are you shure? It's script delete dot files in /etc/ /home/user and /root and restore old dot files.\nAnswer "Yes" or "No" \n \033[0m"
read answer &&
if [ "$answer" = 'Yes' ]; then
    #C---- Remove current
    echo -e "\nRemoved current dot files"
    for i in $user_dot; do
        rm -f /home/${user}/${i}
        rm -f /root/${i}
    done
    
    for a in $other_dot; do
        rm -f /etc/${a}
    done
    
    colors="/usr/share/vim/vim${vim_ver}/colors"
    plugin="/usr/share/vim/vim${vim_ver}/plugin"
    syntax="/usr/share/vim/vim${vim_ver}/syntax"
    inside_colors="fairyloss.vim noctu.vim sm.vim sm.vim.tar wombat.vim xoria256.vim"
    inside_plugin="head.vim vim-translate.vim"
    inside_syntax="httplog.vim log.vim nginx.vim sm.vim"
    local_files="colorex grc grcat vimcat"
    
    rm /etc/vim/vimrc || rm /etc/vimrc
    
    for col in $inside_colors; do
        rm -f "$colors"/"$col"
    done
    
    for plug in $inside_plugin; do
        rm -f "$plugin"/"$plug"
    done    
    
    for syn in $inside_syntax; do
        rm -f "$syntax"/"$syn"
    done
    
    rm -f /usr/share/grc/*
    for local in $local_files; do
        rm -f /usr/local/bin/"$local"
    done
    rm -rf /usr/local/share/grc
    
    #C---- Copy old
    echo -e "\nCopied old dot files"
    for b in $other_dot; do
        cp ./backup_dir/${b} /etc/
    done

    cp ./backup_dir/vimrc /etc/vimrc || cp ./bachkup_dir/vimrc /etc/vim/vimrc
    cp -rf ./backup_dir/vim_tar/colors /usr/share/vim/vim$vim_ver/
    cp -rf ./backup_dir/vim_tar/syntax /usr/share/vim/vim$vim_ver/
    cp -rf ./backup_dir/grc_tar/grc /usr/share/

    for c in $user_dot; do
        cp ./backup_dir/user/${c} /home/${user}/
        cp ./backup_dir/root/${c} /root/
    done
    echo -e "\n \033[0;32m Dot files restored \033[0m"
    exit 0; else
    echo -e "\n \033[0;36m please answer\033[0m \033[0;31m Yes\033[0m \033[0;36m if you change your mind\033[0m"
    exit 1
fi
