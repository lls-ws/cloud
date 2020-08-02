#!/bin/sh
# Script para configurar Apache no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/tomcat.lib		|| exit 1

apache_install()
{
	
	echo "Install apache..."
	apt-get -y install apache2
	
	echo "Create validation dir..."
	mkdir -pv ${DIR_SSL_VALIDATION}
	
	echo "Start apache..."
	service apache2 start
	
	echo "Disable apache..."
	systemctl disable apache2
	
	echo "Check status..."
	service apache2 status
	
}

case "$1" in
	install)
		apache_install
		;;
	*)
		echo "Use: $0 {install}"
		exit 1
		;;
esac
