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
	
	echo "Stopping tomcat..."
	service tomcat stop
	
	echo "Restore backup file: ${FILE_SQL}"
	
	${CMD_BASE} < "${FILE_SQL}"
	
	show_tables
	
	echo "Starting tomcat..."
	service tomcat start
	
}

backup_send()
{
	
	criar_backup
	
	echo "Enviando backup por email..."
	
	echo -e "to: ${DESTINATARIO}\nsubject: Backup LLS-WS\n" |
	
	(cat - && uuencode ${ARQ_ZIP} ${ARQ_ZIP}) |
	
	/usr/sbin/ssmtp ${DESTINATARIO}
	
	RESPONSE="$?"
	
	if [ "${RESPONSE}" == "0" ]; then
	
		echo "Backup enviado para: ${DESTINATARIO} ${DATA_EMAIL}-${HORA_EMAIL}" >> ${ARQ_LOG}
	
	else
	
		echo "Erro ao enviar email!" >> ${ARQ_LOG}
	
	fi
	
	tail -1 ${ARQ_LOG}
	
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

PASSWORD=`git config user.password`

if [ -z "${PASSWORD}" ]; then
	
	echo "Not found a user password!"
	echo "Use: git_conf.sh password {PASSWORD}"
	exit 1
	
fi

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
