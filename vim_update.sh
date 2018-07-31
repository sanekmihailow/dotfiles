#!/bin/bash

vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver"
vimless="/usr/share/vim/vim$vim_ver/macros/less.sh"
user=$(find /home/ -name "vim_update.sh" 2>/dev/null |awk -F"/" '{print $3}' |head -n1)
#check=$(find /home/ -name "vim_update.sh" |awk -F"/" '{$NF=""; print $0}' |sed "s/ /\//g")

echo -e "\n \033[0;32m please enter the username in your home directory (root or admin or ....)\n \033[0m"
read current_user &&

root_root=".bashrc .screenrc .tmux.conf .vimrc .source-root .start-screen"
home_root=".bashrc .screenrc .tmux.conf .vimrc"
home_user=".bashrc .screenrc .tmux.conf .vimrc .source-home .start-screen"
	
mv ./shell_source ./.shell_source;

	if [ -z $vim_ver ]; then
		echo -e "\033[32m Install vim first \033[0m" &&
		exit 1
		
	else
			#create backup dir
		mkdir -p ./backup_dir/root/ ./backup_dir/user/ &&
			#move backup dir
	
		cp /etc/bash.bashrc ./backup_dir/bash.bashrc
		cp /etc/vim/vimrc ./backup_dir/vimrc || cp /etc/vimrc ./backup_dir/vimrc
		cp /home/$user/.vimrc ./backup_dir/user/.vimrc
		cp /home/$user/.bashrc ./backup_dir/user/.bashrc
		cp /home/$user/.bash_profile ./backup_dir/user/.bash_profile
		cp /home/$user/.screenrc ./backup_dir/user/.screenrc
		cp /home/$user/.tmux.conf ./backup_dir/user/.tmux.conf
		cp /root/.bashrc ./backup_dir/root/.bashrc
		cp /root/.screenrc ./backup_dir/root/.screenrc
		cp /root/.tmux.conf ./backup_dir/root/.tmux.conf
		tar -czf  old_vim_bak.tar.gz /usr/share/vim/vim$vim_ver/colors /usr/share/vim/vim$vim_ver/syntax /usr/share/vim/vim$vim_ver/syntax
		mv old_vim_bak.tar.gz ./backup_dir
		chown -R $user ./backup_dir &&
		cp ./etc/bash.bashrc /etc/bash.bashrc
	fi
	
	
	if [ "$current_user" = "root" ]; then
			#---------------------copy root_only
		for i in $root_root; do
			cp ./$i /root
		done
			cp ./.bashrc_only_root /root/.bashrc
			cp -r ./.shell_source /root
	else
			#---------------------copy root
		for a in $home_root; do
			cp ./$a /root
		done
			cp ./bashrc_root /root/.bashrc
			
			#----------------------copy user
		for b in $home_user; do
			cp ./$b /home/$user/
			chmod g=rX,o=rX /home/$user/$b
			chown root:$user /home/$user/$b
		done
			cp -r ./.shell_source /home/$user
			chown -R root:$user /home/$user/.shell_source
			chmod -R g=rX,o=rX /home/$user/.shell_source
						
			# COPY vim files
		cp ./usr/share/vim/vimXX/colors/* $path/colors/
		cp ./usr/share/vim/vimXX/plugin/* $path/plugin/
		cp ./usr/share/vim/vimXX/syntax/* $path/syntax/
		ln -ns $vimless /usr/bin/vless
			
			# COPY files in /usr/bin
			
		chmod a+rx ./usr/bin/{colorex,vimcat,tmux-sessions} &&
			if [ -z $(which vimcat) ]; then
				cp ./usr/bin/vimcat /usr/bin
			else
				echo 'vimcat exist     '
			fi
			
			if [ -z $(which colorex) ]; then
				cp ./usr/bin/colorex /usr/bin
			else
				echo 'colorex exist    '
			fi
		echo -e "\n \033[1;32m Congratulations , you installed vim-bashrc \n \033[0m"
	
	fi
exit 0
