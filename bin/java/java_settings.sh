#!/bin/sh
# Script to Settings Java
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_list()
{
	
	echo "Listing all Java installed versions:"
	update-java-alternatives -l
	
}

java_version()
{

	echo "Showing Java version:"

	java -version
	
}

show_env()
{

	echo "Showing Environment Variable:"
	cat ${FILE_ENVIRONMENT} | grep "JAVA_HOME"

}

FILE_ENVIRONMENT="/etc/environment"

JVM_HOME="/usr/lib/jvm"
