#!/bin/sh
# Script para configurar o Tomcat no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1
. lib/tomcat.lib		|| exit 1

tomcat_download()
{
	
	echo "Install tomcat version ${RELEASE}"
	wget https://www-us.apache.org/dist/tomcat/tomcat-${VERSAO}/v${RELEASE}/bin/${ARQ_TOMCAT}
	
}

tomcat_config()
{
	
	echo "Create tomcat user and group..."
	groupadd --system tomcat
	cat /etc/group | tail -1
	useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
	cat /etc/passwd | tail -1
	
}

tomcat_install()
{
	
	if [ ! -f ${ARQ_TOMCAT} ]; then
	
		tomcat_download
	
	fi
	
	echo "Extract downloaded file with tar..."
	tar xvf ${ARQ_TOMCAT} -C /usr/share/
	
	echo "Remove tomcat tar..."
	rm -fv ${ARQ_TOMCAT}
	rm -fv /usr/share/tomcat 2> /dev/null
	
	echo "Create symlink to extracted tomcat data..."
	ln -s /usr/share/apache-tomcat-${RELEASE}/ /usr/share/tomcat
	
	ls -al /usr/share/tomcat
	
	echo "Set proper directory permissions..."
	chown -R tomcat:tomcat /usr/share/tomcat
	chown -R tomcat:tomcat /usr/share/apache-tomcat-${RELEASE}/
	
	ls -al /usr/share/apache-tomcat-${RELEASE}/
	
}

tomcat_service()
{
	
	FILE_CONF="tomcat.service"
	DIR_CONF="etc/systemd/system"
	
	lib_update
	
}

tomcat_enable()
{
	
	echo "Reload daemon..."
	systemctl daemon-reload
	
	echo "Enable tomcat on boot..."
	systemctl enable tomcat
	
	echo "Start tomcat"
	systemctl start tomcat
	
	sleep 5
	
	tomcat_show
	
}

tomcat_users()
{	
	
	FILE_CONF="tomcat-users.xml"
	DIR_CONF="usr/share/tomcat/conf"
	
	lib_update
	
}

tomcat_setenv()
{	
	
	FILE_CONF="setenv.sh"
	DIR_CONF="usr/share/tomcat/bin"
	
	lib_update
	
	chmod -v 755 /${DIR_CONF}/${FILE_CONF}
	
}

tomcat_show()
{
	
	clear &&
	ps aux | grep tomcat | head -1 &&
	echo "" &&
	free -m &&
	echo "" &&
	
	echo "Check service status..."
	systemctl status tomcat
	
}

memory_show()
{
	echo "Memory Statistics:"
	vmstat -s
	
	echo "Memory Info:"
	cat /proc/meminfo
}

case "$1" in
	download)
		tomcat_download
		;;
	config)
		tomcat_config
		;;
	install)
		tomcat_install
		;;
	service)
		tomcat_service
		;;
	enable)
		tomcat_enable
		;;
	users)
		tomcat_users
		;;
	setenv)
		tomcat_setenv
		;;
	show)
		tomcat_show
		;;
	memory)
		memory_show
		;;
	all)
		tomcat_download
		tomcat_config
		tomcat_install
		tomcat_users
		tomcat_setenv
		tomcat_service
		tomcat_enable
		;;
	*)
		echo "Use: $0 {all|download|config|install|service|enable|users|setenv|show|memory}"
		exit 1
		;;
esac
