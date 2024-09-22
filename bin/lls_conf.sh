#!/bin/sh
# Script to configure LLS WebService on cloud Ubuntu Server
# Note: Change SSH rules on new AWS site, add the old cloud IP
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

lls_local()
{
	
	HOST="$1"
	
	if [ -z "${HOST}" ]; then
		
		echo "Use: $0 {HOST}"
		exit 1
	
	fi
	
	echo "Coping SSH key to cloud: ${HOST}.${USER}.net.br"
	scp -i ${DIR_SSH}/id_rsa ${DIR_SSH}/id_rsa ${USER}@${HOST}.${USER}.net.br:${DIR_SSH}
	
}

lls_create()
{
	
	HOST="$1"
	
	if [ -z "${HOST}" ]; then
		
		echo "Use: $0 {HOST}"
		exit 1
	
	fi
	
	echo "Stopping tomcat..."
	service tomcat${TOMCAT_VERSION} stop
	
	tar -cvzf ${ARQ_LLS} -C ${DIR_WEBAPPS} ${USER}
	
	tar -tf ${ARQ_LLS}
	
	du -hsc ${ARQ_LLS}
	
	echo "Coping ${ARQ_LLS} to cloud: ${HOST}.${USER}.net.br"
	scp -i ${DIR_SSH}/id_rsa ${ARQ_LLS} ${USER}@${HOST}.${USER}.net.br:~
	
	rm -fv ${ARQ_LLS}
	
	echo "Starting tomcat..."
	service tomcat${TOMCAT_VERSION} start
	
}

lls_install()
{
	
	HOST="$1"
	
	if [ -z "${HOST}" ]; then
		
		echo "Use: $0 {HOST}"
		exit 1
	
	fi
	
	ARQ_LLS="${USER}-${HOST}.tar.gz"
	
	echo "Stopping tomcat..."
	service tomcat${TOMCAT_VERSION} stop
	
	tar -xvzf /home/${USER}/${ARQ_LLS} -C ${DIR_WEBAPPS}
	
	chown -R tomcat:tomcat ${DIR_LLS}
	
	ls -al ${DIR_LLS}
	
	du -hsc ${DIR_LLS}
	
	ln -sfv ${DIR_LLS} /home/${USER}/lls-ws
	
	ls -al /home/${USER}/lls-ws
	
	ls /home/${USER}
	
}

lls_server()
{
	
	echo "Stopping tomcat..."
	service tomcat${TOMCAT_VERSION} stop
	
	FILE_CONF="server.xml"
	DIR_CONF="etc/tomcat${TOMCAT_VERSION}"
	
	ARQ_CONFIG=/${DIR_CONF}/${FILE_CONF}
	
	file_backup
	
	lib_update
	
	chmod -v 755 ${ARQ_CONFIG}
	
	sed -i '/sslProtocol="TLS"/i \	\	\keystoreFile="'${KEYSTORE}'"' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/i \	\	\keystorePass="'${PASSWORD}'"' ${ARQ_CONFIG}
	sed -i '/sslProtocol="TLS"/i \	\	\keyAlias="'${ALIAS}'"' ${ARQ_CONFIG}
	
	sed -i '/\/Host/i \	\	\<Context path="" docBase="'${DIR_LLS}'" debug="0"\/\>' ${ARQ_CONFIG}
	
	cat ${ARQ_CONFIG}
	
	echo "Starting tomcat..."
	service tomcat${TOMCAT_VERSION} start
	
}

lls_update()
{
	
	ARQ_BACKUP="lls_backup.sh"
	
	if [ ! -f "bin/${ARQ_BACKUP}" ]; then
	
		echo "File ${ARQ_BACKUP} not found!"
		exit 1
	
	fi
	
	if [ ! -d "${DIR_LLS}/bin" ]; then
	
		mkdir -pv "${DIR_LLS}/bin"
	
	fi
	
	cp -fv "bin/${ARQ_BACKUP}" "${DIR_LLS}/bin"
	
	if [ ! -d "${DIR_LLS}/sql" ]; then
	
		mkdir -pv "${DIR_LLS}/sql"
	
	fi
	
	if [ -L "${ARQ_BIN}" ]; then
	
		rm -fv ${FILE_BIN}
	
	fi
	
	ln -sfv "${DIR_LLS}/bin/${ARQ_BACKUP}" ${FILE_BIN}
	
	du -hsc "${DIR_LLS}/sql" "${DIR_LLS}/bin/${ARQ_BACKUP}"
	
	ls -al  ${FILE_BIN}
	
}

ARQ_LLS="${USER}-${HOSTNAME}.tar.gz"
DIR_SSH="/home/${USER}/.ssh"

case "$1" in
	local)
		lls_local "$2"
		;;
	create)
		lls_create "$2"
		;;
	install)
		lls_install "$2"
		;;
	server)
		lls_server
		;;
	update)
		lls_update
		;;
	*)
		echo "Use: $0 {local|create|install|server|update}"
		exit 1
		;;
esac
