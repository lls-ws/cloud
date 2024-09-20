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
	JAVA_HOME="/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64"
 
	echo "Set the Java home path..."
	echo 'JAVA_HOME="'${JAVA_HOME}'"' >> ${DIR_ENVIRONMENT}
	
	echo "Now reload this file to apply the changes to your current session:"
	source ${DIR_ENVIRONMENT}
	
	echo "Verify that the environment variable is set:"
	cat ${DIR_ENVIRONMENT} | tail -1
	
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
