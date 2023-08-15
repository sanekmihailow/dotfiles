#!/usr/bin/env bash
home_path=$(whoami)
local_path="/usr/local/MY_LOCAL"

list_dir='
LOCAL
InstalleD
INSTALLED_path
INSTALLED_path/GPG
INSTALLED_path/Src
INSTALLED_path/OSgrade
INSTALLED_path/OSup
INSTALL/src
INSTALL/builded
INSTALL/repo
INSTALL/script
INSTALL/docker
BACKUP/conf   
BACKUP/file   
BACKUP/lib    
BACKUP/script 
SCRIPTS/RESULT-scripts
SCRIPTS/Script
'

list_dirs='
LOCAL
INSTALLED_path
INSTALL
BACKUP
SCRIPTS
'

for directory in $list_dir; do
    mkdir -p "$local_path"/"${directory}" || echo "not create ${directory}"
done

mkdir -p "$local_path"/INSTALLED_path/Package/{dpkg,apt,yaourt,yum,snap,dnf,pacman} || echo 'not crate Installed_path/Package'
mkdir -p "$local_path"/INSTALL/package/{dpkg,apt,yaourt,yum,snap,dnf,pacman}        || echo 'not crate Install/package'


for dir in $list_dirs; do
    ln -s "$local_path"/"${dir}" /usr/
done

ln -s "$local_path"/SCRIPTS/Script /etc/Scripts
ln -s "$local_path"/SCRIPTS/RESULT-scripts /var/log/Result-scripts

if [[ "$home_path" = 'root' ]]; then
    mkdir -p /root/HOME_root/{_Scripts,_Result,_Install}; else
    mkdir -p /home/"$home_path"/HOME/{_Scripts,_Result,_Install}
fi    

echo 'Install , Istall_path, scripts and Backup dirs created'
exit 0
