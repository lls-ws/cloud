#!/bin/sh
# Script para configurar o LLS WebService no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

lls_create()
{
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	tar -cvzf ${ARQ_LLS} -C ${DIR_TOMCAT} ${DIR_LLS}
	
	tar -tf ${ARQ_LLS}
	
	du -hsc ${ARQ_LLS}
	
}

lls_install()
{
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	tar -xvzf ${ARQ_LLS} -C ${DIR_TOMCAT}
	
	chmow -R tomcat.tomcat ${DIR_TOMCAT}/${DIR_LLS}
	
	la -al ${DIR_TOMCAT}/${DIR_LLS}
	
	du -hsc ${DIR_TOMCAT}/${DIR_LLS}
	
}

HOSTNAME=`hostname`
DIR_LLS="lls"
ARQ_LLS="${DIR_LLS}-${HOSTNAME}.tar.gz"
DIR_TOMCAT="/usr/share/tomcat/webapps"

case "$1" in
	create)
		lls_create
		;;
	install)
		lls_install
		;;
	*)
		echo "Use: $0 {create|install}"
		exit 1
		;;
esac
