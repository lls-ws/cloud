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
	
	tar -cvzf ${ARQ_LLS} -C ${DIR_WEBAPPS} ${USER}
	
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
	
	chown -R tomcat.tomcat ${DIR_LLS}
	
	ls -al ${DIR_LLS}
	
	du -hsc ${DIR_LLS}
	
}

lls_server()
{
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	ARQ_CONFIG="${DIR_TOMCAT_CONF}/server.xml"
	
	sed -i '/connectionTimeout/a \	\	\	\	enableLookups="false"' ${ARQ_CONFIG}
	sed -i '/Connector port="8443"/i \	--\>' ${ARQ_CONFIG}
	
	sed -i '/sslProtocol="TLS"/i \	\	\	\	keystoreFile="'${KEYSTORE}'"' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/i \	\	\	\	keystorePass="'${PASSWORD}'"' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/i \	\	\	\	keyAlias="'${ALIAS}'"' ${ARQ_CONFIG}
	
	sed -i '/sslProtocol="TLS"/a \	\<!--' ${ARQ_CONFIG}
	
	sed -i '/sslProtocol="TLS"/a \\n\	\<Connector protocol="AJP\/1.3" address="::1" port="8009" redirectPort="8443" \/\>' ${ARQ_CONFIG}
	
	sed -i '/\/Host/i \	\	\<Context path="" docBase="'${DIR_LLS}'" debug="0"\/\>' ${ARQ_CONFIG}
	
	cat ${ARQ_CONFIG}
	
	echo "Starting tomcat..."
	service tomcat start
	
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

ARQ_LLS="${USER}-${HOSTNAME}.tar.gz"

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
