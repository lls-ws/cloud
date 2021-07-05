#!/bin/sh
# Script para configurar o Crontab no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

crontab_config()
{
	
	ARQ_CONFIG="/var/spool/cron/crontabs/root"
	
	chmod -v 0600 ${ARQ_CONFIG}
	
	echo "0 12 * * * bash ${FILE_BIN} send > /dev/null 2>&1" 	> ${ARQ_CONFIG}
	echo "30 18 * * * bash ${FILE_BIN} send > /dev/null 2>&1" 	>> ${ARQ_CONFIG}
	echo "0 5 * * * /usr/sbin/reboot" 							>> ${ARQ_CONFIG}
	
	crontab_show
	
	echo "Restarting crontab..."
	service cron restart
	
}

crontab_show()
{
	
	echo "Show crontab jobs..."
	crontab -l
	
}

case "$1" in
	config)
		crontab_config
		;;
	show)
		crontab_show
		;;
	*)
		echo "Use: $0 {config|show}"
		exit 1
		;;
esac
