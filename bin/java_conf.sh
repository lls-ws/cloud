#!/bin/sh
# Script to configure Java on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_search()
{
	
	echo "Check the availability of Java OpenJDK-${JAVA_VERSION}-${JAVA_OPT} packages..."
	apt-cache search openjdk | grep -i openjdk-${JAVA_VERSION}-${JAVA_OPT}
	
}

java_install()
{
	
	echo "Install Java: openjdk-${JAVA_VERSION}-${JAVA_OPT}"
	apt-get -y install openjdk-${JAVA_VERSION}-${JAVA_OPT}
	
	java_version
	
	java_path
	
}

java_path()
{	
	
	JAVA_HOME="${JVM_HOME}/java-${JAVA_VERSION}-openjdk-amd64"
	
	path_remove
	
	echo "Set Java Home Path:"
	echo 'JAVA_HOME="'${JAVA_HOME}'"' >> ${FILE_ENVIRONMENT}
	
	echo "Now reload this file to apply the changes to your current session:"
	source ${FILE_ENVIRONMENT}
	
	echo "Verify that the environment variable is set:"
	cat ${FILE_ENVIRONMENT}
	
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
	
	dpkg-query -W -f='${binary:Package}\n' | grep -E -e '^(ia32-)?(sun|oracle)-java' -e '^openjdk-' -e '^icedtea' -e '^(default|gcj)-j(re|dk)' -e '^gcj-(.*)-j(re|dk)' -e '^java-common' | xargs sudo apt-get -y remove
	
	apt-get -y autoremove
	
	dpkg -l | grep ^rc | awk '{print($2)}' | xargs sudo apt-get -y purge
	
	rm -rfv /usr/lib/jvm/*
	
	path_remove
	
}

path_remove()
{
	
	echo "Remove Java Home Path:"
	sed -i '/JAVA_HOME/d' ${FILE_ENVIRONMENT}
	
}

JAVA_VERSION="11"

JVM_HOME="/usr/lib/jvm"

FILE_ENVIRONMENT="/etc/environment"

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
	search)
		java_search
		;;
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
		echo "Use: $0 {all|search|install|path|version|choice|remove}"
		exit 1
		;;
esac
