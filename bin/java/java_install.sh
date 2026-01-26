#!/bin/sh
# Script to Install Java
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_install()
{
	
	echo "Installing Java:"
	apt -y install default-jre
	
	java_path
	
	java_version
	
}

java_path()
{	
	
	JAVA_VERSION=`cat ${JVM_HOME}/default-java/release | grep "JAVA_VERSION=" | cut -d '"' -f 2 | cut -d '.' -f 1`
	
	if [ -z ${JAVA_VERSION} ]; then
	
		echo "Java Version not found!"
		exit 1
	
	fi
	
	JAVA_HOME="${JVM_HOME}/java-${JAVA_VERSION}-openjdk-amd64"
	
	path_remove
	
	echo "Setting Java Home Path..."
	echo 'JAVA_HOME="'${JAVA_HOME}'"' >> ${FILE_ENVIRONMENT}
	
	echo "Reloading Environment File..."
	source ${FILE_ENVIRONMENT}
	
	show_env
	
}
