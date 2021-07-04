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
	
	tar -cvzf ${ARQ_LLS} -C ${DIR_WEBAPPS} ${DIR_LLS}
	
	tar -tf ${ARQ_LLS}
	
	du -hsc ${ARQ_LLS}
	
	echo "Starting tomcat..."
	service tomcat start
	
}

lls_install()
{
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	tar -xvzf ${ARQ_LLS} -C ${DIR_WEBAPPS}
	
	chown -R tomcat.tomcat ${DIR_WEBAPPS}/${DIR_LLS}
	
	ls -al ${DIR_WEBAPPS}/${DIR_LLS}
	
	du -hsc ${DIR_WEBAPPS}/${DIR_LLS}
	
}

lls_server()
{
	
	#ARQ_CONFIG="${DIR_CONF}/server.xml"
	
	ARQ_CONFIG="server.xml"
	
	sed -i '/connectionTimeout/a \	\	\	\	enableLookups="false"' ${ARQ_CONFIG}
	sed -i '/Connector port="8443"/i \	--\>' ${ARQ_CONFIG}
	
	keystoreFile="/usr/share/tomcat/webapps/lls/keystore/homeoffice_lls_net_br.pfx"
	keystorePass="Uber#739200"
	keyAlias="llsKey"
	
	sed -i '/sslProtocol="TLS"/a \	\<!--' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/a \	\<!--' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/a \	\<!--' ${ARQ_CONFIG}
	
	sed -i '/sslProtocol="TLS"/a \	\<!--' ${ARQ_CONFIG}
	
	cat ${ARQ_CONFIG}
	
	#echo "Starting tomcat..."
	#service tomcat start
	
}

lls_crontab()
{
	
	ARQ_CONFIG="/var/spool/cron/crontabs/root"
	
	chmod -v 0600 ${ARQ_CONFIG}
	
	echo "20 18 * * * bash /home/lls/addons/bin/backup_bd_lls.sh send > /dev/null 2>&1" > ${ARQ_CONFIG}
	echo "0 5 * * * /usr/sbin/reboot" >> ${ARQ_CONFIG}
	
	echo "Show crontab jobs..."
	crontab -l
	
	echo "Restarting crontab..."
	service cron restart
	
}

HOSTNAME=`hostname`
DIR_LLS="lls"
ARQ_LLS="${DIR_LLS}-${HOSTNAME}.tar.gz"
DIR_TOMCAT="/usr/share/tomcat"
DIR_CONF="${DIR_TOMCAT}/conf"
DIR_WEBAPPS="${DIR_TOMCAT}/webapps"

case "$1" in
	create)
		lls_create
		;;
	install)
		lls_install
		;;
	server)
		lls_server
		;;
	*)
		echo "Use: $0 {create|install|server}"
		exit 1
		;;
esac
