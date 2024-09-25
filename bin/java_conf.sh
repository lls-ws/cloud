#!/bin/sh
# Script to configure Java on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_install()
{
	
	echo "Install Java: openjdk-${JAVA_VERSION}-${JAVA_OPT}"
	apt-get -y install openjdk-${JAVA_VERSION}-${JAVA_OPT}
	
	java_version
	
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

java_version()
{

	echo "Show Java ${JAVA_OPT} version:"

	if [ "${JAVA_OPT}" = "jre" ]; then
	
		java -version
	
	else
	
		javac -version
	
	fi
	
}

java_choice()
{
	
	if [ "${JAVA_OPT}" = "jre" ]; then
	
		update-alternatives --config java
	
	else
	
		update-alternatives --config javac
	
	fi
	
}

java_remove()
{
	
	echo "Remove Java ${JAVA_OPT} from Ubuntu..."
	apt -y purge openjdk-${JAVA_VERSION}-${JAVA_OPT}
	apt -y autoremove
	
}

JAVA_VERSION="11"

echo "Java version: ${JAVA_VERSION}"

case "$2" in
	jre)
		JAVA_OPT="jre"
		;;
	jdk)
		JAVA_OPT="jdk"
		;;
	*)
		echo "Use: $0 $1 {jre|jdk}"
		exit 1
		;;
esac

case "$1" in
	install)
		java_install
		;;
	path)
		java_path
		;;
	version)
		java_version
		;;
	choice)
		java_choice
		;;
	remove)
		java_remove
		;;
	all)
		java_install
		;;
	*)
		echo "Use: $0 {all|install|path|version|choice|remove}"
		exit 1
		;;
esac
