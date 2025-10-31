#!/bin/bash
# Script to manager backup file on DataBase bd_lls in MariaDB
#
# email: lls.homeoffice@gmail.com

backup_create()
{
	
	if [ ! -d ${DIR_SQL} ]; then
	
		mkdir -pv ${DIR_SQL}
	
	fi
	
	echo "Create backup file: ${FILE_SQL}"
	mysqldump -u root --password="${PASSWORD}" "bd_${USER}" > "${FILE_SQL}"
	
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
	service tomcat${TOMCAT_VERSION} stop
	
	du -hsc ${FILE_SQL}
	
	echo "Restore backup file: ${FILE_SQL}"
	${CMD_BASE} < "${FILE_SQL}"
	
	show_tables
	
	echo "Starting tomcat..."
	service tomcat${TOMCAT_VERSION} start
	
}

backup_send()
{
	
	backup_create
	
	HOSTNAME=`hostname`
	DOMAIN=`echo ${EMAIL} | cut -d @ -f2`
	
	DESTINATARIO="${USER}.${HOSTNAME}.${YEAR}@${DOMAIN}"
	
	echo "Send backup to email: ${DESTINATARIO}"
	
	echo -e "to: ${DESTINATARIO}\nsubject: Backup LLS-WS\nBackup efetuado automaticamente!" |
	
	(cat - && uuencode ${FILE_ZIP} ${NAME_ZIP}) |
	
	/usr/sbin/ssmtp -f"LLS-WS" -F"LLS Tecnologia" ${DESTINATARIO}
	
	RESPONSE="$?"
	
	if [ "${RESPONSE}" == "0" ]; then
	
		echo "Backup send to: ${DESTINATARIO}"
	
	else
	
		echo "Send email error!"
	
	fi
	
}

backup_copy()
{
	
	HOST="$1"
	
	if [ -z "${HOST}" ]; then
	
		echo "Not found a hostname!"
		echo "Use: $0 transfer {HOSTNAME}"
		exit 1
	
	fi
	
	URL="${HOST}.${USER}.net.br"
	
	backup_create
	
	echo "Coping ${NAME_ZIP} to cloud: ${URL}"
	scp -i ~/.ssh/id_rsa ${FILE_ZIP} ${USER}@${URL}:~
	
	RESPONSE="$?"
	
	if [ "${RESPONSE}" == "0" ]; then
	
		echo "File: ${NAME_ZIP} send to: ${URL}"
	
	else
	
		echo "Send file error!"
	
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
	echo "Run script as root!"
	exit 1
  
fi

USER=`git config user.name`

if [ -z "${USER}" ]; then
		
	echo "Not found a user name!"
	echo "Use: git_conf.sh name {NAME}"
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

# Change year for the correct email adress account
MONTH=`date +%-m`

if [ ${MONTH} -gt 6 ]; then

	YEAR=`date +%Y`
	
else
	
	YEAR=`date --date="1 year ago" +%Y`

fi

TOMCAT_VERSION="9"

DIR_TOMCAT="/var/lib/tomcat${TOMCAT_VERSION}"
DIR_WEBAPPS="${DIR_TOMCAT}/webapps"
DIR_LLS="${DIR_WEBAPPS}/${USER}"
DIR_SQL="${DIR_LLS}/sql"
FILE_SQL="${DIR_SQL}/${USER}_backup.sql"
NAME_ZIP="${USER}_backup.zip"
FILE_ZIP="${DIR_SQL}/${NAME_ZIP}"

CMD_BASE="mysql -u root --password=${PASSWORD} -D bd_${USER}"

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
	copy)
		backup_copy "$2"
		;;
	show)
		show_tables
		;;
	*)
		echo "Use: $(basename $0) {create|restore|send|copy|show}"
		exit 1
		;;
esac
