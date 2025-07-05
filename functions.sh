date_time="$(date +%Y-%m-%d_%H-%M-%S)"

backupHome(){
    for conf in $backup_user; do
        cp -rpf ${home_dir}/$conf ./backup_dir/user/ 2> /dev/null
    done
    $sudo_used sh -c "cp -p /root/{.bash_profile,.profile} ./backup_dir/root/ 2> /dev/null"

    tar -cf "backcup_dir_${date_time}.tar" ${curr_dir}/backup_dir
    echo -e "\n\033[0;32m $current_user  You old setting backuped to dotfiles/backup_dir \033[0m"
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
    echo -e "\n\033[0;32m $current_user  You old setting backuped to dotfiles/backup_dir \033[0m"
}

copyHome(){
    local check_fc_cache=$(type -P fc-cache)
    local check_nvim=$(type -P nvim)
    local list_dotdir='.shell_source .config .local .grc .vim .nvim'

    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    for dot in ${list_dotdir}; do
        cp -frp ${curr_dir}/${dot} ${home_dir}/
    done

    chmod +x ${home_dir}/.local/bin/*              2> /dev/null
    ln -ns $vimless ${home_dir}/.local/bin/vimless 2> /dev/null

    if [ -n "${check_fc_cache}" ]; then fc-cache -f -v > /dev/null; fi
    $sudo_used ochown -R $current_user: ${home_dir}/.config/{mc,nvim}/                      2> /dev/null
    $sudo_used chown -R $curredt_user: ${home_dir}/{.shell_source,.grc,.local,.cache,.vim}/ 2> /dev/null

    if [ 7 -eq "${vimver_first}" ]; then
        cp -frp ${curr_dir}/usr/share/vimOLD/plugin ${home_dir}/.vim/
        sed -i 's/let .t_SR =/"&/' ${home_dir}/.vimrc
        sed -i 's/set completeopt=/"&/' ${home_dir}/.vimrc
        sed -i 's/set termguicolors/"&/' ${home_dir}/.vimrc
    elif [ "${vimver_first}" -gt 7 ]; then
        cp -frp ${curr_dir}/usr/share/vimXX/plugin ${home_dir}/.vim/
        cp -frp ${curr_dir}/usr/share/vimXX/autoload ${home_dir}/.vim/
        cp -frp ${curr_dir}/usr/share/vimXX/doc ${home_dir}/.vim/
    else
        echo 'not used vimchar'
    fi

    if [ -z "$check_nvim" ]; then
        rm -rf ${home_dir}/.config/nvim
        rm -rf ${home_dir}/.nvim
    fi
}

copyHomeRoot(){
    $sudo_used sh -c "cp -f ${curr_dir}/{.source-root,.bash_profile,.profile} /root/" 2> /dev/null
    if [ -z "$($sudo_used grep 'source ~/.source-root' /root/.bashrc)" ]; then
        $sudo_used sh -c "echo 'source ~/.source-root' >> /root/.bashrc"
    fi

    $sudo_used chown -R $current_user: ${home_dir}/.config/{mc,vim,nvim}/              2> /dev/null
    $sudo_used chown -R $current_user: ${home_dir}/{.shell_source,.grc,.local,.cache}/ 2> /dev/null
    $sudo_used sh -c "cp -f ${curr_dir}/.source-root /root/"
    $sudo_used sh -c "ln -s ${home_dir}/.local/bin /usr/local/local_bin" 2> /dev/null
}

copyRoot(){
    local check_fc_cache=$(type -P fc-cache)

    for conf in $conf_files; do
        cp -fr ${curr_dir}/$conf ${home_dir}/
    done

    cp -fr ${curr_dir}/.shell_source /root/
    cp -f ${curr_dir}/.local/bin/{vimcat,colorex,grc,grcat,tmux-sessions} /usr/local/bin/
    chmod +x /usr/local/bin/{vimcat,colorex,grc,grcat,tmux-sessions}
    ln -ns $vimless /usr/local/bin/vimless

    cp -f ${curr_dir}/.vim/colors/* ${vim_path}/colors/ || echo -e "not vim colors"
    cp -f ${curr_dir}/.vim/plugin/* ${vim_path}/plugin/ || echo -e "not vim plugins"
    cp -f ${curr_dir}/.vim/syntax/* ${vim_path}/syntax/ || echo -e "not vim syntax"
    cp -rf ${curr_dir}/.local/share/grc /usr/local/share/
    cp -f ${curr_dir}/.grc/grc.conf /etc/grc.conf

    if [ ! -d /usr/local/share/fonts ]; then mkdir -p /usr/local/share/fonts; fi
    cp -f ${curr_dir}/.local/share/fonts/* /usr/local/share/fonts/
    if [ -n "${check_fc_cache}" ]; then fc-cache -f -v > /dev/null; fi
}

setPathSudo(){
    local sudopath="/etc/sudoers"

    if [ -n "$sudo_used" ] ; then
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
