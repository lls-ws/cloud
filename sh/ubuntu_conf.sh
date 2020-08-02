#!/bin/sh
# Script para configurar o cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

ubuntu_upgrade()
{
	
	apt update
	apt list --upgradable
	apt -y upgrade
	apt autoremove
	reboot
	
}

profile_pt_BR()
{
	
	echo "Showing locale..."
	locale
	
	echo "Installing pt_BR..."
	apt-get -y install language-pack-pt-base
	
	echo "Changing profile to pt_BR..."
	update-locale LC_ALL=pt_BR.UTF-8 LANG=pt_BR.UTF-8 LANGUAGE=pt_BR
	
	echo "Changing timezone..."
	timedatectl set-timezone America/Sao_Paulo
	
	echo "Showing new locale and new date..."
	cat /etc/default/locale
	date
	
}

fonts_install()
{
	
	echo "Installing fonts..."
	apt-get -y install fonts-dejavu-core ttf-mscorefonts-installer
	
}

crontab_jobs()
{
	
	ARQ_CONFIG="/var/spool/cron/crontabs/root"
	
	echo "20 18 * * * sh /home/lls/funchal/sh/backup_bd_lls.sh send > /dev/null 2>&1" > ${ARQ_CONFIG}
	echo "0 5 * * * /usr/sbin/reboot" >> ${ARQ_CONFIG}
	
	echo "Show crontab jobs..."
	crontab -l
	
	echo "Restarting crontab..."
	service cron restart
	
}

ssmtp_install()
{
	
	echo "Installing ssmtp..."
	apt-get -y install ssmtp unzip mc
	
	ssmtp_config
	
}

ssmtp_config()
{
	
	ARQ_CONFIG="/etc/ssmtp/revaliases"
	
	echo "root:lls.homeoffice@gmail.com:smtp.gmail.com:587" >> ${ARQ_CONFIG}
	
	echo "Changing permissions for revaliases..."
	chown -v root.mail ${ARQ_CONFIG}
	chmod -v 640 ${ARQ_CONFIG}
	cat ${ARQ_CONFIG}
	
	ARQ_CONFIG="/etc/ssmtp/ssmtp.conf"
	
	echo "root=lls.homeoffice@gmail.com"  				> ${ARQ_CONFIG}
	echo "hostname=localhost"							>> ${ARQ_CONFIG}
	echo "rewriteDomain="								>> ${ARQ_CONFIG}
	echo "AuthUser=lls.homeoffice"						>> ${ARQ_CONFIG}
	echo "AuthPass=lls739200"							>> ${ARQ_CONFIG}
	echo "AuthMetod=plain"								>> ${ARQ_CONFIG}
	echo "FromLineOverride=YES"							>> ${ARQ_CONFIG}
	echo "Mailhub=smtp.gmail.com:587"					>> ${ARQ_CONFIG}
	echo "UseTLS=YES"									>> ${ARQ_CONFIG}
	echo "UseSTARTTLS=YES"								>> ${ARQ_CONFIG}
	echo "AuthMethod=LOGIN"								>> ${ARQ_CONFIG}
	echo "TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt"	>> ${ARQ_CONFIG}
	
	echo "Changing permissions for ssmtp conf..."
	chown -v root.mail ${ARQ_CONFIG}
	chmod -v 640 ${ARQ_CONFIG}
	cat ${ARQ_CONFIG}
	
}

check_version()
{
	
	echo "Mostrando a versão dos Apps"
	uname -mrs
	lsb_release -a
	
	#dpkg -l mariadb* java*s
	apt-cache show mariadb
	
}

if [ "$EUID" -ne 0 ]; then
	echo "Rodar script como root"
	exit 1
  
fi

case "$1" in
	upgrade)
		ubuntu_upgrade
		;;
	profile)
		profile_pt_BR
		;;
	fonts)
		fonts_install
		;;
	crontab)
		crontab_jobs
		;;
	ssmtp)
		ssmtp_install
		;;
	version)
		check_version
		;;
	all)
		upgrade
		profile_pt_BR
		fonts_install
		crontab_config
		ssmtp_install
		;;
	*)
		echo "Use: $0 {all|upgrade|profile|fonts|crontab|ssmtp|version}"
		exit 1
		;;
esac
