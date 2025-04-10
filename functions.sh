#!/usr/bin/env bash
date_time="$(date +%Y-%m-%d_%H-%M-%S)"

backupHome(){
    local sudo_used=''

    for conf in $backup_user; do
        cp -rpf ${home_dir}/$conf ./backup_dir/user/ 2> /dev/null
    done

    if [[ $EUID -ne 0 ]]; then
        if $(sudo -v); then
           sudo_used='sudo' 
        fi
        $sudo_used sh -c "cp -p /root/{.bash_profile,.profile} ./backup_dir/root/ 2> /dev/null"
    fi        

    tar -cf "backcup_dir_${date_time}.tar" ${curr_dir}/backup_dir
    echo -e "\n\033[0;32m $current_user  You old setting bacuped to dotfiles/backup_dir \033[0m"
}

backupRoot(){
    mkdir -p ./backup_dir/{vim_tar,grc_tar} > /dev/null
    cp -f /etc/vim/vimrc   ./backup_dir/vimrc || cp /etc/vimrc ./backup_dir/vimrc
    cp -f /etc/bash.bashrc ./backup_dir/
    cp -f /etc/grc.conf    ./backup_dir/
    cp -rf ${vim_path}/{colors,syntax,plugin} ./backup_dir/vim_tar/
    cp -rf /usr/share/grc ./backup_dir/grc_tar/
    cp -rf /usr/local/bin ./backup_dir

    tar -cf "bakcup_dir_${date_time}.tar" ${curr_dir}/backup_dir
    echo -e "\n\033[0;32m $current_user  You old setting bacuped to dotfiles/backup_dir \033[0m"
}

copyHome(){
    mkdir -p ${home_dir}/{.local,.vim,.grc} > /dev/null
    if [ ! -d ${home_dir}/.lcoal/bin ];         then mkdir -p ${home_dir}/.local/bin; fi
    if [ ! -d ${home_dir}/.local/share/fonts ]; then mkdir -p ${home_dir}/.local/share/fonts; fi

    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    cp -fr ${curr_dir}/.shell_source ${home_dir}/
    if [ ! -d ${home_dir}/.config/mc ]; then mkdir -p ${home_dir}/.config/mc; fi
    cp -fr ${curr_dir}/.config/mc/* ${home_dir}/.config/mc/
    check_nvim=$(type -P nvim)
    if [[ $? == 0 ]]; then cp -fr ${curr_dir}/.config/nvim ${home_dir}/.config/; fi

    cp -fp ${curr_dir}/usr/bin/{vimcat,colorex,grc,grcat,tmux-sessions} ${home_dir}/.local/bin/
    chmod +x ${home_dir}/.local/bin/{vimcat,colorex,grc,grcat,tmux-sessions}
    ln -ns $vimless ${home_dir}/.local/bin/vimless

    if [ ! -d ${home_dir}/.local/share/grc ]; then mkdir -p ${home_dir}/.local/share/grc; fi
    cp -rfp ${curr_dir}/usr/share/grc/* ${home_dir}/.local/share/grc/
    cp -rfp ${curr_dir}/etc/grc.conf  ${home_dir}/.grc/grc.conf
#    if $(sudo -v); then sudo cp -rf ${curr_dir}/usr/share/grc /usr/local/share; fi
    cp -rfp ${curr_dir}/usr/local/share/fonts ${home_dir}/.local/share/
    cp -rfp ${curr_dir}/usr/share/vim/vimXX/{colors,plugin,syntax,swap} ${home_dir}/.vim/
    if [ -n "$(which fc-cache 2> /dev/null)" ]; then fc-cache -f -v > /dev/null; fi
    chown -R $current_user: ${home_dir}/.config/{mc,vim,nvim}/
    chown -R $current_user: ${home_dir}/{.shell_source,.grc,.local}/
}

copyHomeRoot(){
    if $(sudo -v); then
        sudo sh -c "cp -f ${curr_dir}/{.source-root,.bash_profile,.profile} /root/"

        if [ -z "$(sudo grep 'source ~/.source-root' /root/.bashrc)" ]; then
            sudo sh -c "echo 'source ~/.source-root' >> /root/.bashrc"
        fi

        sudo sh -c "cp -f ${curr_dir}/.source-root /root/"
        sudo sh -c "ln -s ${home_dir}/.local/bin /usr/local/local_bin"
    fi
}

copyRoot(){
    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    cp -fr ${curr_dir}/.shell_source /root
    cp -f ${curr_dir}/usr/bin/{vimcat,colorex,grc,grcat,tmux-sessions} /usr/local/bin/
    chmod +x /usr/local/bin/{vimcat,colorex,grc,grcat,tmux-sessions}
    ln -ns $vimless /usr/local/bin/vimless

    cp -f ${curr_dir}/usr/share/vim/vimXX/colors/* ${vim_path}/colors/ || echo -e "not vim colors"
    cp -f ${curr_dir}/usr/share/vim/vimXX/plugin/* ${vim_path}/plugin/ || echo -e "not vim plugins"
    cp -f ${curr_dir}/usr/share/vim/vimXX/syntax/* ${vim_path}/syntax/ || echo -e "not vim syntax"
    cp -rf ${curr_dir}/usr/share/grc/ /usr/local/share/
    cp -f ${curr_dir}/etc/grc.conf /etc/grc.conf

    if [ ! -d /usr/local/share/fonts ]; then mkdir -p /usr/local/share/fonts; fi
    cp -f ${curr_dir}/usrl/local/share/fonts/* /usr/local/share/fonts/
    if [ -n "$(which fc-cache 2> /dev/null)" ]; then fc-cache -f -v; fi
}

setPathSudo(){
    local sudopath="/etc/sudoers"
    local sudo_used=''

    if [[ $EUID -ne 0 ]]; then 
        if $(sudo -v); 
            then sudo_used='sudo'
            else sudo_used='no'
        fi
    fi    
    

    if [ "$sudo_used" != 'no' ] ; then
        local securepath=$(${sudo_used} grep -n 'secure_path' ${sudopath} |grep -v '#')
        local num=$(echo $securepath |cut -d ':' -f1)
        local sudo_user=$(${sudo_used} sh -c 'echo $SUDO_USER')
        
        if [ -n "$num" ]; then
            content=$(echo $securepath |awk -F "\"" '{print $2}')

            if [ -z "$content" ]; then
                content=$(echo $securepath |awk -F "=" '{print $2}' |tr -d ' ')
            fi

            if [ -n "$content" ]; then 
                change=false
                check_sbin=$(echo $content |grep '\/usr\/local\/sbin')
                if [[ $? != 0 ]]; then content="${content}:/usr/local/sbin"; change=true; fi

                check_bin=$(echo $content |grep '\/usr\/local\/bin')
                if [[ $? != 0 ]]; then content="${content}:/usr/local/bin"; change=true; fi

                if [ -n "$sudo_user" ]; then
                    check_homebin=$(echo $content |grep "${home_dir}/.local/bin")
                    if [[ $? != 0 ]]; then content="${content}:/usr/local/local_bin"; change=true; fi
                fi

                #content="${content}:${HOME}/.local/bin"
                if [ "$change" = true ]; then
                    if [ -z "$(${sudo_used} grep 'secure_path.*\/usr\/local\/local_bin' $sudopath)" ]; then
                        ${sudo_used} sed -i "${num}s/^/#/" $sudopath
                        ${sudo_used} sed -i "${num}i Defaults       secure_path=\"${content}\"" $sudopath
                    fi
                fi
            else 
                echo -e "\n\033[0;31m Secure_path not found \033[0m" 
            fi
        fi
    fi
}
