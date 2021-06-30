#!/bin/sh
# Script para configurar Java no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_install()
{
	
	echo "Install java-openjdk..."
	apt-get -y install default-jre
	
	java -version
	
	java_path
	
}

java_path()
{	
	
	echo "Set the Java home path..."
	echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment
	
	echo "Source the file to start using it without logging out..."
	source /etc/environment
	
	echo $JAVA_HOME
	
}

case "$1" in
	install)
		java_install
		;;
	path)
		java_path
		;;
	*)
		echo "Use: $0 {install|path}"
		exit 1
		;;
esac
