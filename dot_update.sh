#!/bin/bash

vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver"
vimless="/usr/share/vim/vim$vim_ver/macros/less.sh"
#user=$(find /home/ -name "vim_update.sh" 2>/dev/null |awk -F"/" '{print $3}' |head -n1)
#check=$(find /home/ -name "vim_update.sh" |awk -F"/" '{$NF=""; print $0}' |sed "s/ /\//g")

echo -e "\n \033[0;32m please enter the username in your home directory (root or admin or ....)\n \033[0m"
read current_user &&
user="$(who | cut -d' ' -f1 | grep "$current_user" |head -n1)"

if [ "$user" = "$current_user" ]; then
        echo "$user found"
else    echo "$current_user not found" && exit 1
fi

other_home="bash.bashrc grc.conf"
root_root=".screenrc .tmux.conf .vimrc .source-root .start-screen"
home_root=".bashrc .screenrc .tmux.conf .vimrc"
home_user=".bashrc .screenrc .tmux.conf .vimrc .source-home .start-screen"
	
mv ./shell_source ./.shell_source;

if [ -z $vim_ver ]; then
    echo -e "\033[31m Install vim first \033[0m" &&
    exit 1	
else
    #C---- create backup dir
    mkdir -p ./backup_dir/root/ ./backup_dir/user/ &&
	
    #C---- move backup dir
    for h in $home_user; do
        cp -f /home/${user}/${h} ./backup_dir/user/
	cp -f /home/${user}/.bash_history ./backup_dir/user/
    done

    for r in $home_root; do
        cp -f /root/${r} ./backup_dir/root/
	cp -f /root/.bash_history ./backup_dir/root/
    done

    for e in $other_home; do
        cp -f /etc/${e} ./backup_dir/
    done
		
    cp -f /etc/vim/vimrc ./backup_dir/vimrc || cp /etc/vimrc ./backup_dir/vimrc
    cp -f ./etc/bash.bashrc /etc/bash.bashrc
		
    vim_tar="./backup_dir/vim_tar/"
    grc_tar="./backup_dir/grc_tar/"
    vim_fpath="/usr/share/vim/vim${vim_ver}"
    grc_fpath="/usr/share/grc"
        	
    tar -czf  ./backup_dir/old_vim_bak.tar.gz "$vim_fpath"/colors "$vim_fpath"/syntax
    tar -czf  ./backup_dir/old_grc_bak.tar.gz "$grc_fpath"
    mv old_vim_bak.tar.gz ./backup_dir
#M        mv old_grc_bak.tar.gz ./backup_dir
#M        mkdir ./backup_dir/{vim_tar,grc_tar}
    cp -Rf "$vim_fpath"/colors "$vim_tar"
    cp -rf "$vim_fpath"/syntax "$vim_tar"
    cp -rf "$vim_fpath"/plugin "$vim_tar"
    cp -rf "$grc_fpath" "$grc_tar"
    chown -R $user ./backup_dir &&
    echo -e "\n\033[32m You old setting (dot_files) moved to home-dir-dot_update.sh/backup_dir \033[0m" &&

    if [ "$current_user" = "root" ]; then
        #C---- copy root_only
        for i in $root_root; do
	    cp ./$i /root
	done
	    cp ./.bashrc_only_root /root/.bashrc
	    cp -r ./.shell_source /root 
    else
        #C---- copy root
        for a in $home_root; do
            cp ./$a /root
        done
        cp ./bashrc_root /root/.bashrc
			
        #C---- copy user
        for b in $home_user; do
            cp ./$b /home/$user/
            chmod g=rX,o=rX /home/$user/$b
            chown root:$user /home/$user/$b
	done
        cp -r ./.shell_source /home/$user
        chown -R root:$user /home/$user/.shell_source
        chmod -R g=rX,o=rX /home/$user/.shell_source
    fi
    echo -e "\n\033[32m Dot files changed \033[0m"
    
    if [ -z $vim_ver ]; then
         echo -e "\033[31m Install vim first \033[0m" &&
         exit 1	
    else						
         #---- COPY vim files
         cp -f ./usr/share/vim/vimXX/colors/* $path/colors/ || echo -e "not vim colors"
         cp -f ./usr/share/vim/vimXX/plugin/* $path/plugin/ || echo -e "not vim plugins"
         cp -f ./usr/share/vim/vimXX/syntax/* $path/syntax/ || echo -e "not vim syntax"
         ln -ns $vimless /usr/bin/vless
			
         #---- COPY files in /usr/bin	
         #Er chmod a+rx ./usr/bin/{colorex,vimcat,tmux-sessions} &&
	 list_ex="colorex vimcat grc grcat tmux-sessions"
	 
	 for list in $list_ex; do
	     chmod a+rx ./usr/bin/${list} 
	     #&& echo -e "executable ${list}"
	 done
 	
         if [ -z $(which vimcat) ]; then
             cp ./usr/bin/vimcat /usr/local/bin/
             echo -e "\n\033[32m Copied vimcat \033[0m"; else
             echo 'vimcat exist     '
         fi
			
         if [ -z $(which colorex) ]; then
             cp ./usr/bin/colorex /usr/local/bin/
             echo -e "\n\033[32m Copied colorex \033[0m"; else
             echo 'colorex exist    '
         fi
			
         if [ -z $(which grc) ]; then
             cp ./usr/bin/grc /usr/local/bin/
             cp ./usr/bin/grcat /usr/local/bin/
             cp -r ./usr/share/grc /usr/local/share/
             cp ./etc/grc.conf /etc/grc.conf
             echo -e "\n\033[32m Create grc /usr/loca/bin \033[0m"
         else
	     if [[ $(which grc) == '/usr/bin/grc' ]]; then
             cp -r ./usr/share/grc/* /usr/share/grc/
             cp ./etc/grc.conf /etc/grc.conf
             echo -e "\n\033[32m Copied files grc /usr/share/grc \033[0m"
	     fi
	     echo '2' > /dev/null
         fi
		
    echo -e "\n \033[1;32m Congratulations , you updated dot_files \n \033[0m"
    fi
fi
echo -e "\n \033[1;36m EXIT\n \033[0m"
exit 0
