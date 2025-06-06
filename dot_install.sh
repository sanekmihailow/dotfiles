#!/usr/bin/env bash
#set -x
#set -e

#user=$(find /home/ -name "vim_update.sh" 2>/dev/null |awk -F"/" '{print $3}' |head -n1)
#check=$(find /home/ -name "vim_update.sh" |awk -F"/" '{$NF=""; print $0}' |sed "s/ /\//g")
vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | cut -d ' ' -f 5 | sed -e 's/\.//g')"
vimver_first="$(echo ${vim_ver:0:1})"
vimver_first=$((vimver_first))
vim_path="/usr/share/vim/vim${vim_ver}"
vimless="/usr/share/vim/vim$vim_ver/macros/less.sh"
current_user="$USER"
home_dir="$HOME"
curr_dir="$(pwd)"
os_family="$(cat /etc/os-release |grep -w 'ID_LIKE')"
next='yes'
sudo_used=''


conf_files=".bashrc .screenrc .tmux.conf .vimrc .source-user .bash_profile .profile"
backup_user=".bashrc .screenrc .tmux.conf .vimrc .bash_history .grc .local .vim .bash_profile .profile"

if [[ $EUID -ne 0 ]]; then
    if $(sudo -v); then
        sudo_used='sudo'
    fi
fi

if [ -z $vim_ver ]; then
    echo -e "\033[0;31m try's of install package vim \033[0m"
    rhel="$(echo $os_family   |grep 'rhel')"
    debian="$(echo $os_family |grep 'debian')"

    if [ -z $rhel ]; then
        sudo yum install vim || sudo dnf install vim
    elif [ -z $debian ]; then
        sudo apt install vim || sudo apt-get install vim
    else
        echo -e "\033[0;31m - unsuccessfully try \033[0m \n"
        echo -e "\033[0;31m Please install vim first \033[0m \n"
        exit 1
    fi

else
    mkdir -p ./backup_dir/{user,root}
    if [ -d ${home_dir}/.config/mc ]; then
        ${sudo_used} sh -c "cp -rpf ${home_dir}/.config/mc ${curr_dir}/backup_dir/"
    fi

    if [ -d ${home_dir}/.config/nvim ]; then
        ${sudo_used} sh -c "cp -rpf ${home_dir}/.config/nvim ${curr_dir}/backup_dir/"
    fi
    $sudo_used chown -R $current_user: ${home_dir}/.config/{mc,nvim}/ 2> /dev/null

    if [ -n "$1" ]; then
        if [ "$1" == 'local' ]; then
            choose=1
            next='no'
        elif [ "$1" == 'all' ]; then
            choose=2
            next='no'
        elif [ "$1" == 'update' ]; then
            choose=3
            next='no'
        else
            echo -e "not found correct parameter \n"
        fi
    fi

    if [ "$next" == 'yes' ]; then
        echo -e "\n \033[0;32m please choose how you want to install it (1 or 2) :\033[0m \n 1) locally for the current user \n 2) for the entire current system \n 3) update configuration \n  Please choose in 1 min and push enter\n"
        if read -t 60 -sp "" choose; then
            echo -e "you choose $choose\n"
        fi
    fi

    source ${curr_dir}/functions.sh
#C---- create backup dir and copy
    if [[ $choose == 1 ]]; then
        backupHome
        copyHome
        copyHomeRoot
        setPathSudo
    elif [[ $choose == 2 ]]; then
        backupRoot
        copyRoot
        setPathSudo
    elif [[ $choose == 3 ]]; then
        check_source_root="$($sudo_used cat /root/.source-user 2>&1 |egrep -v 'No such file or directory|Permission denied')"
        if [ -n "$check_source_root" ]; then
            backupRoot
            copyRoot
        else
            backupHome
            copyHome
            # if use $(function_name), an example: $(backupHome)
            # the bash processes any echo string as a command
        fi
    else
        echo -e "you choose not found, please try again start script"
        exit 1
    fi

    echo -e "\n \033[1;32mCongratulations, you updated dot_files \n \033[0m"
    bashversion=$(bash -version |head -n1 | cut -d '.' -f 1 | egrep -o '[[:digit:]]')

    if [[ $((bashversion)) -le 4 ]]; then
        sed -i 's/^shopt -s complete_fullquote/#&/' ${home_dir}/.shell_source/defaults
        sed -i 's/^shopt -s globasciiranges/#&/' ${home_dir}/.shell_source/defaults
    fi

fi


#if [ "$current_user" = "root" ]; then
#    source ${home_dir}/.source-root; else
    . ${home_dir}/.source-user
#fi

echo -e "\n USE:\n
\033[1;36m source ~/.source-user\n \033[0m"
echo -e "\n \033[1;36m EXIT\n \033[0m"exit 0
