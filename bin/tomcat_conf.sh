#!/bin/sh
# Script para configurar o Tomcat no cloud Ubuntu Server 22.04 LTS 64 bits
# Note: Find the required Apache Tomcat package and replace the variable VERSION
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

tomcat_search()
{
	
	echo "Check the availability of Apache Tomcat package..."
	apt-cache search tomcat
	
}

tomcat_install()
{
	
	echo "Install Apache Tomcat Server on Ubuntu..."
	apt-get -y install tomcat${VERSION} tomcat${VERSION}-admin
	
}

tomcat_check()
{
	
	echo "Check ports for Apache Tomcat Server..."
	ss -ltn
	
}

tomcat_users()
{	
	
	ARQ_CONFIG="/etc/tomcat${VERSION}/tomcat-users.xml"
	
	file_backup
	
	sed -i '/<\/tomcat-users>/i <role rolename="admin-gui"\/>' ${ARQ_CONFIG}
	sed -i '/<\/tomcat-users>/i <role rolename="manager-gui"\/>' ${ARQ_CONFIG}
	sed -i '/<\/tomcat-users>/i <user username="admin" password="'${PASSWORD}'" fullName="Administrator" roles="admin-gui,manager-gui"\/>' ${ARQ_CONFIG}
	
	cat ${ARQ_CONFIG}
	
	systemctl restart tomcat${VERSION}
	
}

tomcat_setenv()
{	
	
	ln -sv "usr/share/tomcat${VERSION}" "usr/share/tomcat"
	
	FILE_CONF="setenv.sh"
	DIR_CONF="usr/share/tomcat/bin"
	
	lib_update
	
	chmod -v 755 /${DIR_CONF}/${FILE_CONF}
	
	systemctl restart tomcat${VERSION}
	
}

tomcat_show()
{
	
	clear &&
	ps aux | grep tomcat | head -1 &&
	echo "" &&
	free -m &&
	echo "" &&
	
	echo "Check service status..."
	systemctl status tomcat${VERSION}
	
}

memory_show()
{
	echo "Memory Statistics:"
	vmstat -s
	
	echo "Memory Info:"
	cat /proc/meminfo
}

VERSION="9"

case "$1" in
	search)
		tomcat_search
		;;
	install)
		tomcat_install
		;;
	check)
		tomcat_check
		;;
	setenv)
		tomcat_setenv
		;;
	users)
		tomcat_users
		;;
	show)
		tomcat_show
		;;
	memory)
		memory_show
		;;
	all)
		tomcat_search
		tomcat_install
		tomcat_check
		tomcat_setenv
		tomcat_users
		tomcat_show
		memory_show
		;;
	*)
		echo "Use: $0 {all|search|install|check|setenv|users|show|memory}"
		exit 1
		;;
esac
