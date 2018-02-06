#!/bin/bash

vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver/"
echo "\n $path"

user=$(find /home/ -name "vim_update.sh" |awk -F"/" '{print $3}' |head -n1)
echo "\n $user"

#check=$(find /home/ -name "vim_update.sh" |awk -F"/" '{$NF=""; print $0}' |sed "s/ /\//g")

mv ./shell_source .shell_source

if [ -z $vim_ver ]; then
	echo -e "\033[32m Install vim first \033[0m"
else
		#create backup dir
	mkdir ./backup_dir
		#move backup dir
	mv /etc/bash.bashrc ./backup_dir/.bash.bashrc
	mv /etc/vim/vimrc ./backup_dir/vimrc & mv /home/$user/.vimrc ./backup_dir/.vimrc || mv /etc/vimrc ./backup_dir/vimrc 
	mv /root/.bashrc ./backup_dir/.bashrc_root
	mv /home/$user/.bashrc ./bakup_dir/.bashrc_user
	mv /home/$user/.bash_profile ./backup_dir/.bash_profile_user
	tar -czf old_vim_bak.tar.gz /usr/share/vim/$vim_ver/colors /usr/share/vim/$vim_ver/syntax /usr/share/vim/$vim_ver/syntax
	mv old_vim_bak.tar.gz ./backup_dir
		#copy dot files from this folder	
		#---------------------copy root
	cp ./etc/bash.bashrc /etc/
	cp .{bashrc_root,screenrc,tmux.conf,vimrc} /root 
	#cp .bashrc_root /root
	#cp .screenrc /root
	#cp .tmux.conf /root
	#cp .vimrc /root
	cp -r .shell_source /root
		#----------------------copy user
	cp .{bashrc,bash_profile,screenrc,tmux.conf,vimrc} /home/$user/
	cp -r .shell_source /home/$user/ 
		# COPY vim files
	cp ./usr/share/vim/vimXX/colors/* $path/colors/
	cp ./usr/share/vim/vimXX/plugin/* $path/plugin/
	cp ./usr/share/vim/vimXX/syntax/* $path/syntax/	
fi
