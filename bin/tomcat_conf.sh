#!/bin/sh
# Script para configurar o Tomcat no cloud Ubuntu Server 22.04 LTS 64 bits
# Note: Find the required Apache Tomcat package
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

tomcat_search()
{
	
	echo "Check the availability of Apache Tomcat package..."
	apt-cache search tomcat
	
}

tomcat_install()
{
	
	echo "Install Apache Tomcat Server on Ubuntu..."
	apt-get -y install tomcat9 tomcat9-admin
	
}

case "$1" in
	search)
		tomcat_search
		;;
	install)
		tomcat_install
		;;
	all)
		tomcat_search
		tomcat_install
		;;
	*)
		echo "Use: $0 {all|search|install}"
		exit 1
		;;
esac
