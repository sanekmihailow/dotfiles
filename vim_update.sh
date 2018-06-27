#!/bin/bash

vim_ver="$(/usr/bin/vim --version | grep "Vi IMproved" | awk '{print $5}' | sed -e 's/\.//g')"
path="/usr/share/vim/vim$vim_ver"
vimless="/usr/share/vim/vim$vim_ver/macros/less.sh"
user=$(find /home/ -name "vim_update.sh" 2>/dev/null |awk -F"/" '{print $3}' |head -n1)
#check=$(find /home/ -name "vim_update.sh" |awk -F"/" '{$NF=""; print $0}' |sed "s/ /\//g")

mv ./shell_source ./.shell_source;

if [ -z $vim_ver ]; then
	echo -e "\033[32m Install vim first \033[0m"
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
	chown -R $user ./backup_dir

		#copy dot files from this folder	
		#---------------------copy root
	cp ./etc/bash.bashrc /etc/bash.bashrc
	cp  ./.bashrc_root /root/.bashrc_root
	#mkdir /root/.shell_source
	#cp .{bashrc_root,screenrc,tmux.conf,vimrc} /root 
	#cp ./.bashrc_root /root/.bashrc_root
	#cp ./.screenrc /root/.screenrc
	#cp ./.tmux.conf /root/.tmux.conf
	#cp ./.vimrc /root/.vimrc
	#cp -r ./.shell_source/ /root
		#----------------------copy user
	#cp .{bashrc,bash_profile,screenrc,tmux.conf,vimrc} /home/$user/
	cp  ./.start-screen /home/$user/.start-screen
	cp  ./.bashrc /home/$user/.bashrc
	cp ./.bash_profile /home/$user/.bash_profile
	cp ./.screenrc /home/$user/.screenrc
	cp ./.tmux.conf /home/$user/.tmux.conf
	cp ./.vimrc /home/$user/.vimrc
	cp -r ./.shell_source/ /home/$user/;
	chown -R $user /home/$user/
		# COPY vim files
	cp ./usr/share/vim/vimXX/colors/* $path/colors/
	cp ./usr/share/vim/vimXX/plugin/* $path/plugin/
	cp ./usr/share/vim/vimXX/syntax/* $path/syntax/
	ln -ns $vimless /usr/bin/vless
fi
exit 0
