#!/bin/bash
# Script to configre Ssmtp on cloud Ubuntu Server
# Change this Google settings:
# IMAP enabled
# Allow less secure apps is ON
# Turn on 2-Step Verification
# Set an app-password for ssmtp
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Library Path
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

ssmtp_install()
{
	
	echo "Installing ssmtp..."
	apt-get -y install ssmtp sharutils zip unzip mc
	
}

ssmtp_config()
{
	
	echo "root:${EMAIL}:smtp.gmail.com:587" 			> ${FILE_REVALIASES}
	
	echo "Changing permissions for revaliases..."
	ssmtp_change ${FILE_REVALIASES}
	
	echo "root=${EMAIL}"		  				> ${FILE_SSMTP}
	echo "hostname=${HOSTNAME}"					>> ${FILE_SSMTP}
	echo "AuthUser=${EMAIL}"					>> ${FILE_SSMTP}
	echo "AuthPass=${SSMTP_APP_PASSWORD}"				>> ${FILE_SSMTP}
	echo "FromLineOverride=YES"					>> ${FILE_SSMTP}
	echo "Mailhub=smtp.gmail.com:587"				>> ${FILE_SSMTP}
	echo "UseSTARTTLS=YES"						>> ${FILE_SSMTP}
	echo "AuthMethod=LOGIN"						>> ${FILE_SSMTP}
	
	echo "Changing permissions for ssmtp conf..."
	ssmtp_change ${FILE_SSMTP}

	ssmtp_show
  
}

ssmtp_change()
{

	ARQ_CONFIG="$1"
 
	chown -v root:mail ${ARQ_CONFIG}
	
	chmod -v 640 ${ARQ_CONFIG}
	
}

ssmtp_show()
{
	
 	echo "Show revaliases ${FILE_REVALIASES}:"
	cat ${FILE_REVALIASES}

 	echo "Show revaliases ${FILE_SSMTP}:"
	cat ${FILE_SSMTP}
	
}

FILE_REVALIASES="/etc/ssmtp/revaliases"
FILE_SSMTP="/etc/ssmtp/ssmtp.conf"
SSMTP_APP_PASSWORD=`git config user.ssmtp`

if [ -z "${SSMTP_APP_PASSWORD}" ]; then
	
	echo "Not found a ssmtp app password!"
	echo "Use: git_conf.sh ssmtp {SSMTP_APP_PASSWORD}"
	exit 1
	
fi

case "$1" in
	install)
		ssmtp_install
		;;
	config)
		ssmtp_config
		;;
	show)
		ssmtp_show
		;;
	all)
		ssmtp_install
		ssmtp_config
		;;
	*)
		echo "Use: $0 {all|install|config|show}"
		exit 1
		;;
esac
