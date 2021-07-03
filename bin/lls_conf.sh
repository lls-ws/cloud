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
	
	tar -cvzf ${ARQ_LLS} ${DIR_LLS}
	
	du -hsc ${ARQ_LLS}
	
}

HOSTNAME=`hostname`
ARQ_LLS="lls-${HOSTNAME}.tar.gz"
DIR_LLS="/usr/share/tomcat/webapps/lls"

case "$1" in
	create)
		lls_create
		;;
	*)
		echo "Use: $0 {create}"
		exit 1
		;;
esac
