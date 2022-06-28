#!/bin/bash
# Script para configurar o cloud Ubuntu Server 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

ubuntu_upgrade()
{
	
	apt update
	apt list --upgradable
	apt -y upgrade
	apt autoremove
	
	echo "Type: reboot"
	
}

profile_pt_BR()
{
	
	echo "Showing locale..."
	locale
	
	echo "Installing pt_BR..."
	apt-get -y install language-pack-pt-base
	
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
	
	echo "Mostrando a versão dos Apps"
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
	all)
		upgrade
		profile_pt_BR
		fonts_install
		check_version
		;;
	*)
		echo "Use: $0 {all|upgrade|profile|fonts|version}"
		exit 1
		;;
esac
