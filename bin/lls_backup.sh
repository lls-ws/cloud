#!/bin/bash
# Script para gerenciar o arquivo de backup do banco de dados bd_lls no mariadb
#
# email: lls.homeoffice@gmail.com

backup_create()
{
	
	if [ ! -d ${DIR_SQL} ]; then
	
		mkdir -pv ${DIR_SQL}
	
	fi
	
	echo "Create backup file: ${FILE_SQL}"
	mysqldump -u root --password="${PASSWORD}" "bd_lls" > "${FILE_SQL}"
	
	echo "Compact backup file: ${FILE_ZIP}"
	zip -j ${FILE_ZIP} ${FILE_SQL}
	
	du -hsc ${FILE_ZIP} ${FILE_SQL}
	
}

backup_restore()
{
	
	if [ ! -f ${FILE_SQL} ]; then
	
		echo "File ${FILE_SQL} not found!"
		exit 1
	
	fi
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	du -hsc ${FILE_SQL}
	
	echo "Restore backup file: ${FILE_SQL}"
	${CMD_BASE} < "${FILE_SQL}"
	
	show_tables
	
	echo "Starting tomcat..."
	service tomcat start
	
}

backup_send()
{
	
	backup_create
	
	DOMAIN=`echo ${EMAIL} | cut -d @ -f2`
	
	DESTINATARIO="${USER}.${HOSTNAME}.${YEAR}@${DOMAIN}"
	
	echo "Send backup to email: ${DESTINATARIO}"
	
	echo -e "to: ${DESTINATARIO}\nsubject: Backup LLS-WS\n" |
	
	(cat - && uuencode ${FILE_ZIP}) |
	
	/usr/sbin/ssmtp ${DESTINATARIO}
	
	RESPONSE="$?"
	
	if [ "${RESPONSE}" == "0" ]; then
	
		echo "Backup send to: ${DESTINATARIO}"
	
	else
	
		echo "Send email error!"
	
	fi
	
}

loop_tables()
{
	
	OPT="$1"
	
	echo "Loop all tables..."
	
	${CMD_BASE} -Nse 'SHOW TABLES' | 
	
	while read table;
	do 
		
		echo "${OPT} $table..."
		
		${CMD_BASE} -e "SET FOREIGN_KEY_CHECKS=0;${OPT} ${table};SET FOREIGN_KEY_CHECKS=1;";
	
	done
	
}

show_tables()
{
	
	loop_tables "SELECT COUNT(*) as Total FROM"
	
}

if [ "$EUID" -ne 0 ]; then
	echo "Rodar script como root"
	exit 1
  
fi

EMAIL=`git config user.email`

if [ -z "${EMAIL}" ]; then
		
	echo "Not found a user email!"
	echo "Use: git_conf.sh email {EMAIL}"
	exit 1
	
fi

PASSWORD=`git config user.password`

if [ -z "${PASSWORD}" ]; then
	
	echo "Not found a user password!"
	echo "Use: git_conf.sh password {PASSWORD}"
	exit 1
	
fi

YEAR=`date +%Y`
DIR_SQL="/usr/share/tomcat/webapps/lls/sql"
FILE_SQL="${DIR_SQL}/lls_backup.sql"
FILE_ZIP="${DIR_SQL}/lls_backup.zip"

CMD_BASE="mysql -u root --password=${PASSWORD} -D bd_lls"

case "$1" in
	create)    	
		backup_create
		;; 
	restore)
		backup_restore
		;;
	send)
		backup_send
		;;
	show)
		show_tables
		;;
	*)
		echo "Use: $(basename $0) {create|restore|send|show}"
		exit 1
		;;
esac
