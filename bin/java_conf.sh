#!/bin/sh
# Script to configure Java on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Library Path
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

java_install()
{
	
	echo "Install java-openjdk..."
	apt-get -y install default-jre
	
	java -version
	
	java_path
	
}

java_path()
{	
	
	DIR_ENVIRONMENT="/etc/environment"
	
	echo "Set the Java home path..."
	echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ${DIR_ENVIRONMENT}
	
	echo "Now reload this file to apply the changes to your current session:"
	source ${DIR_ENVIRONMENT}
	
	echo "Verify that the environment variable is set:"
	echo ${JAVA_HOME}
	
}

case "$1" in
	install)
		java_install
		;;
	path)
		java_path
		;;
	all)
		java_install
		java_path
		;;
	*)
		echo "Use: $0 {all|install|path}"
		exit 1
		;;
esac
