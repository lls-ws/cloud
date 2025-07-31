#!/bin/bash
# Script to configure a cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Library Path
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

remove_packages()
{
	
	dpkg --list | grep ^rc
	
	PACKAGE_LIST=$(dpkg --list | grep ^rc| awk '{ print $2}')
	
	echo "${PACKAGE_LIST}"
	
	apt-get -y --purge remove ${PACKAGE_LIST}
	
	apt -y autoremove
	
	remove_snap
	
}

remove_snap()
{
	
	df -h /
	
	snap list --all |
	awk '/disabled/{print $1, $3}' |
	while read snapname revision; do
        
        sudo snap remove "$snapname" --revision="$revision"
        
    done
    
    snap set system refresh.retain=2
    
    rm -rfv /var/lib/snapd/cache/
	
	df -h /
	
}

ubuntu_upgrade()
{
	
	apt update
	apt list --upgradable
	apt -y upgrade
	apt -y autoremove
	
	check_version
	
	echo "Type: sudo reboot"
	
}

profile_pt_BR()
{
	
	echo "Showing locale..."
	locale
	
	echo "Installing pt_BR..."
	apt-get -y install language-pack-pt-base
	
	echo "Setting pt_BR..."
	dpkg-reconfigure locales
	
	echo "Changing profile to pt_BR..."
	update-locale LC_ALL=pt_BR.UTF-8 LANG=pt_BR.UTF-8 LANGUAGE=pt_BR
	
	echo "Changing timezone..."
	timedatectl set-timezone America/Sao_Paulo
	
	echo "Showing new locale and new date..."
	cat /etc/default/locale
	date
	
}

fonts_install()
{
	
	echo "Installing fonts..."
	apt-get -y install fonts-dejavu-core ttf-mscorefonts-installer
	
}

check_version()
{
	
	echo "Show OS versions"
	uname -mrs
	lsb_release -a
	
}

case "$1" in
	upgrade)
		ubuntu_upgrade
		;;
	profile)
		profile_pt_BR
		;;
	fonts)
		fonts_install
		;;
	version)
		check_version
		;;
	remove)
		remove_packages
		;;
	all)
		upgrade
		profile_pt_BR
		fonts_install
		check_version
		;;
	*)
		echo "Use: $0 {all|remove|upgrade|profile|fonts|version}"
		exit 1
		;;
esac
