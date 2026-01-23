#!/bin/bash
# Script to Update on LLS WS Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

show_version()
{
	
	echo "Show OS versions"
	uname -mrs
	lsb_release -a
	
}

os_upgrade()
{
	
	apt update
	apt list --upgradable
	apt -y upgrade
	apt -y autoremove
	
	show_version
	
	echo "Type: sudo reboot"
	
}

remove_packages()
{
	
	clear
	
	dpkg --list | grep ^rc
	
	PACKAGE_LIST=$(dpkg --list | grep ^rc| awk '{ print $2}')
	
	echo "${PACKAGE_LIST}"
	
	apt-get -y --purge remove ${PACKAGE_LIST}
	
	apt -y autoremove

    rm -fv ${LOG_TOMCAT}/*
 
	remove_snap
	
}

remove_snap()
{
	
	df -h /
	
	echo "Remove Unused Dependencies..."
	
	LANG=C snap list --all | 
	while read snapname ver rev trk pub notes; do
		if [[ $notes = disabled ]]; then
			sudo snap remove "$snapname" --revision="$rev";
		fi;
	done
	
	echo "Remove Unused Packages..."
	
	snap list --all |
	awk '/disabled/{print $1, $3}' |
	while read snapname revision; do
        
        sudo snap remove "$snapname" --revision="$revision"
        
    done
    
    snap set system refresh.retain=2
    
    rm -rfv ${CACHE_SNAPD}
	
	df -h /
	
}

clear

LOG_TOMCAT="/var/log/tomcat9"
CACHE_SNAPD="/var/lib/snapd/cache"

if [ "$EUID" -ne 0 ]; then
	echo "Run: sudo $(basename $0) $1"
	exit 1
  
fi

case "$1" in
	version)
		show_version
		;;
	upgrade)
		os_upgrade
		;;
	remove)
		remove_packages
		;;
	all)
		upgrade
		remove_packages
		show_version
		;;
	*)
		echo "Use: $0 {all|version|upgrade|remove}"
		exit 1
		;;
esac
