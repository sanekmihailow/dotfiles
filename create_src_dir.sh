#!/usr/bin/env bash
home_path=$(whoami)
local_path="/usr/local/MY_LOCAL"
mkdir -p "$local_path"/LOCAL &
mkdir -p "$local_path"/InstalleD
mkdir -p "$local_path"/INSTALLED_path         || echo 'not create Installed path'
mkdir -p "$local_path"/INSTALLED_path/GPG     || echo 'not crate Installed_path/GPG'
mkdir -p "$local_path"/INSTALLED_path/Package/{dpkg,apt,yaourt,yum,snap,dnf,pacman} || echo 'not crate Installed_path/Package'
mkdir -p "$local_path"/INSTALLED_path/Src     || echo 'not crate Installed_path/Src'
mkdir -p "$local_path"/INSTALLED_path/OSgrade || echo 'not crate Installed_path/Src'
mkdir -p "$local_path"/INSTALLED_path/OSup    || echo 'not crate Installed_path/Src'
mkdir -p "$local_path"/INSTALL/src            || echo 'not crate Install/src'
mkdir -p "$local_path"/INSTALL/builded        || echo 'not crate Install/builded'
mkdir -p "$local_path"/INSTALL/package/{dpkg,apt,yaourt,yum,snap,dnf,pacman}        || echo 'not crate Install/package'
mkdir -p "$local_path"/INSTALL/repo           || echo 'not crate Install/repo'
mkdir -p "$local_path"/INSTALL/script         || echo 'not crate Install/script'
mkdir -p "$local_path"/INSTALL/docker         || echo 'not crate Install/docker'
mkdir -p "$local_path"/BACKUP/conf            || echo 'not crate Backup/conf'
mkdir -p "$local_path"/BACKUP/file            || echo 'not crate Backup/file'
mkdir -p "$local_path"/BACKUP/lib             || echo 'not crate Backup/lib'
mkdir -p "$local_path"/BACKUP/script          || echo 'not crate Backup/script'
mkdir -p "$local_path"/SCRIPTS/RESULT-scripts || echo 'not crate Result-script'
mkdir -p "$local_path"/SCRIPTS/Script         || echo 'not crate script'

ln -s "$local_path"/LOCAL /usr/
ln -s "$local_path"/INSTALLED_path /usr/
ln -s "$local_path"/INSTALL /usr/
ln -s "$local_path"/BACKUP /usr/
ln -s "$local_path"/SCRIPTS /usr/

if [[ "$home_path" = 'root' ]]; then
    mkdir -p /root/HOME_root/{Script,Result-scripts,Install,Local}; else
    mkdir -p /home/"$home_path"/HOME/{Script,Result-scripts,Install,Local}
fi    

echo 'Install , Istall_path, scripts and Backup dirs created'
exit 0
