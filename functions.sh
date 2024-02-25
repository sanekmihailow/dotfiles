#!/usr/bin/env bash
date_time="$(date +%Y-%m-%d_%H-%M-%S)"

backupHome(){

    for conf in $backup_user; do
        cp -rf ${home_dir}/$conf ./backup_dir/user/
    done

    if $(sudo -v); then
        sudo sh -c "cp /root/{.bash_profile,.profile} ./backup_dir/root/"
    fi

    tar -cf "backcup_dir_${date_time}.tar" ${curr_dir}/backup_dir
        echo -e "\n\033[32m $current_user  You old setting bacuped to dotfiles/backup_dir \033[0m"
}

backupRoot(){
    mkdir -p ./backup_dir/{vim_tar,grc_tar}

    for conf in $backup_user; do
        cp -fr /root/$conf ./backup_dir/root/
    done

    cp -f /etc/vim/vimrc   ./backup_dir/vimrc || cp /etc/vimrc ./backup_dir/vimrc
    cp -f /etc/bash.bashrc ./backup_dir/
    cp -f /etc/grc.conf    ./backup_dir/
    cp -rf ${vim_path}/{colors,syntax,plugin} ./backup_dir/vim_tar/
    cp -rf /usr/share/grc ./backup_dir/grc_tar/
    cp -rf /usr/local/bin ./backup_dir

    tar -cf "bakcup_dir_${date_time}.tar" ${curr_dir}/backup_dir
        echo -e "\n\033[32m $current_user  You old setting bacuped to dotfiles/backup_dir \033[0m"
}

copyHome(){
    mkdir -p ${home_dir}/{.local,.vim,.grc}
    mkdir ${home_dir}/.local/bin
    mkdir ${home_dir}/.local/share/fonts

    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    cp -fr ${curr_dir}/.shell_source ${home_dir}/
    cp -fr ${curr_dir}/.config/mc ${home_dir}/.config/
    cp -f ${curr_dir}/usr/bin/{vimcat,colorex,grc,grcat,tmux-sessions} ${home_dir}/.local/bin/
    chmod +x ${home_dir}/.local/bin/{vimcat,colorex,grc,grcat,tmux-sessions}
    ln -ns $vimless ${home_dir}/.local/bin/vmless
    cp -rf ${curr_dir}/usr/share/grc ${home_dir}/.local/share/
    cp -rf ${curr_dir}/etc/grc.conf  ${home_dir}/.grc/grc.conf
#    if $(sudo -v); then sudo cp -rf ${curr_dir}/usr/share/grc /usr/local/share; fi
    cp -rf ${curr_dir}/usr/local/share/fonts ${home_dir}/.local/share/
    cp -rf ${curr_dir}/usr/share/vim/vimXX/{colors,plugin,syntax} ${home_dir}/.vim/
    fc-cache -f -v

#    if [ -z $(which mc) ]; then
#        cp -rf /.config/mc ./config/
#    fi
}

copyHomeRoot(){
    if $(sudo -v); then
        sudo sh -c "cp -f ${curr_dir}/{.source-root,.bash_profile,.profile} /root/"
        sudo sh -c "echo 'source ~/.source-root' >> /root/.bashrc"
        sudo sh -c "cp -f ${curr_dir}/.source-root /root/"
    fi
}

copyRoot(){
    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    cp -fr ${curr_dir}/.shell_source /root
    cp -f ${curr_dir}/usr/bin/{vimcat,colorex,grc,grcat,tmux-sessions} /usr/local/bin/
    chmod +x /usr/local/bin/{vimcat,colorex,grc,grcat,tmux-sessions}
    ln -ns $vimless /usr/local/bin/vmless

    cp -f ${curr_dir}/usr/share/vim/vimXX/colors/* ${vim_path}/colors/ || echo -e "not vim colors"
    cp -f ${curr_dir}/usr/share/vim/vimXX/plugin/* ${vim_path}/plugin/ || echo -e "not vim plugins"
    cp -f ${curr_dir}/usr/share/vim/vimXX/syntax/* ${vim_path}/syntax/ || echo -e "not vim syntax"
    cp -rf ${curr_dir}/usr/share/grc /usr/local/share/
    cp -f ${curr_dir}/etc/grc.conf /etc/grc.conf

    if [ -d /usr/local/share/fonts ]; then
        cp -f ${curr_dir}/usr/local/share/fonts/* /usr/local/share/fonts/
    else
        mkdir -p /usr/local/share/fonts &&
        cp -f ${curr_dir}/usrl/local/share/fonts/* /usr/local/share/fonts/
        fc-cache -f -v
    fi

}

setPathSudo(){
    sudopath="/etc/sudoers"
    
    if $(sudo -v); then
        securepath=$(sudo grep -n 'secure_path' ${sudopath} |grep -v '#')
        num=$(echo $securepath |cut -d ':' -f1)

            if [ -n "$num" ]; then
                content=$(echo $securepath |awk -F "\"" '{print $2}')
                change=false
        
                check_sbin=$(echo $content |grep '\/usr\/local\/sbin')
                if [[ $? != 0 ]]; then content="${content}:/usr/local/sbin"; change=true; fi

                check_bin=$(echo $content |grep '\/usr\/local\/bin')
                if [[ $? != 0 ]]; then content="${content}:/usr/local/bin"; change=true; fi

                check_homebin=$(echo $content |grep "${home_dir}/.local/bin")
                if [[ $? != 0 ]]; then content="${content}:${HOME}/.local/bin"; change=true; fi
                
                #content="${content}:${HOME}/.local/bin"
                if [ "$change" = true ]; then    
                    sudo sed -i "${num}s/^/#/" $sudopath
                    sudo sed -i "${num}i Defaults       secure_path=\"${content}\"" $sudopath
                fi    
            fi
    fi
}
