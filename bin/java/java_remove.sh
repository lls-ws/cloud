#!/bin/sh
# Script to Remove Java
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

java_remove()
{
	
	echo "Remove Java from Ubuntu..."
	
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
	
	show_env
	
}
