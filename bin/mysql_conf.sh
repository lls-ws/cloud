#!/bin/bash
# Script para configurar o Mysql no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/update.lib		|| exit 1
. lib/tomcat.lib		|| exit 1

mysql_install()
{
	
	echo "Install mariadb..."
	apt-get -y install mariadb-server
	
	echo "Show status..."
	systemctl status mariadb
	
}

mysql_secure()
{
	
	( echo ; echo "N" ; echo "Y" ; echo "Y" ; echo "Y" ; echo "Y" ) |
	/usr/bin/mysql_secure_installation
	
	mysql -e "GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY '${PASSWORD}' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	
	mysql -u admin --password=${PASSWORD} -e "SHOW databases";
	
}

mysql_conf()
{	
	
	echo "Stopping mariadb..."
	service mariadb stop
	
	FILE_CONF="50-server.cnf"
	DIR_CONF="etc/mysql/mariadb.conf.d"
	
	lib_update
	
	FILE_CONF="50-client.cnf"
	DIR_CONF="etc/mysql/mariadb.conf.d"
	
	lib_update
	
	FILE_CONF="50-mysql-clients.cnf"
	DIR_CONF="etc/mysql/mariadb.conf.d"
	
	lib_update
	
	echo "Starting mariadb..."
	service mariadb start
	
	mysql -e "SHOW VARIABLES LIKE 'char%'"
	
}

mysql_database()
{
	
	#echo "Deleting lls database..."
	#mysql -u root --password=${PASSWORD} -e "DROP DATABASE bd_lls; SHOW DATABASES"
	#mysql -u root --password=${PASSWORD} -e "SHOW DATABASES"
	
	echo "Creating lls database..."
	mysql -u admin --password=${PASSWORD} -e "CREATE DATABASE bd_lls; \
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${PASSWORD}' WITH GRANT OPTION;"
	
	echo "Show lls database..."
	mysql -u admin --password=${PASSWORD} -D bd_lls -e "SELECT @@character_set_database; \
													 SHOW VARIABLES LIKE 'character_set_%'; \
													 SHOW DATABASES; \
													 SHOW TABLE STATUS;"
	
}

mysql_show()
{
	clear &&
	mysql -u admin --password=${PASSWORD} -e "show variables; show status" | awk '  
{
VAR[$1]=$2  
}
END {  
MAX_CONN = VAR["max_connections"]  
MAX_USED_CONN = VAR["Max_used_connections"]  
BASE_MEM=VAR["key_buffer_size"] + VAR["query_cache_size"] + VAR["innodb_buffer_pool_size"] + VAR["innodb_additional_mem_pool_size"] + VAR["innodb_log_buffer_size"]  
MEM_PER_CONN=VAR["read_buffer_size"] + VAR["read_rnd_buffer_size"] + VAR["sort_buffer_size"] + VAR["join_buffer_size"] + VAR["binlog_cache_size"] + VAR["thread_stack"] + VAR["tmp_table_size"]  
MEM_TOTAL_MIN=BASE_MEM + MEM_PER_CONN*MAX_USED_CONN  
MEM_TOTAL_MAX=BASE_MEM + MEM_PER_CONN*MAX_CONN
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %15.3f MB |\n", "key_buffer_size", VAR["key_buffer_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "query_cache_size", VAR["query_cache_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "innodb_buffer_pool_size", VAR["innodb_buffer_pool_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "innodb_additional_mem_pool_size", VAR["innodb_additional_mem_pool_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "innodb_log_buffer_size", VAR["innodb_log_buffer_size"]/1048576  
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %15.3f MB |\n", "BASE MEMORY", BASE_MEM/1048576  
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %15.3f MB |\n", "sort_buffer_size", VAR["sort_buffer_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "read_buffer_size", VAR["read_buffer_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "read_rnd_buffer_size", VAR["read_rnd_buffer_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "join_buffer_size", VAR["join_buffer_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "thread_stack", VAR["thread_stack"]/1048576  
printf "| %40s | %15.3f MB |\n", "binlog_cache_size", VAR["binlog_cache_size"]/1048576  
printf "| %40s | %15.3f MB |\n", "tmp_table_size", VAR["tmp_table_size"]/1048576  
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %15.3f MB |\n", "MEMORY PER CONNECTION", MEM_PER_CONN/1048576  
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %18d |\n", "Max_used_connections", MAX_USED_CONN  
printf "| %40s | %18d |\n", "max_connections", MAX_CONN  
printf "+------------------------------------------+--------------------+\n"  
printf "| %40s | %15.3f MB |\n", "TOTAL (MIN)", MEM_TOTAL_MIN/1048576  
printf "| %40s | %15.3f MB |\n", "TOTAL (MAX)", MEM_TOTAL_MAX/1048576  
printf "+------------------------------------------+--------------------+\n"  
}'  && ps aux | grep mysqld | head -1 &&
	echo "" &&
	free -m &&
	echo "" &&
	systemctl status mariadb
}

mysql_atualizar()
{
	mysql_upgrade -u admin --password="${PASSWORD}" --force
}

case "$1" in
	install)
		mysql_install
		;;
	secure)
		mysql_secure
		;;	
	conf)
		mysql_conf
		;;
	database)
		mysql_database
		;;
	show)
		mysql_show
		;;	
	upgrade)
		mysql_atualizar
		;;
	all)
		mysql_install
		mysql_secure
		mysql_conf
		mysql_database
		mysql_show
		;;
	*)
		echo "Use: $0 {all|install|conf|database|show|upgrade}"
		exit 1
		;;
esac
