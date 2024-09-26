#!/bin/sh
# Script to configure SSL on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

ssl_install()
{

	echo "Installing snap core..."
	snap install core
	snap refresh core
	
	echo "Installing certbot..."
	snap install --classic certbot
	ln -sv /snap/bin/certbot /usr/bin/certbot
	
}

ssl_create()
{
	
	ssl_clean

	echo " -- Stop Services -- "
	iptables -F -t nat
	service tomcat${TOMCAT_VERSION} stop

	echo " -- Delete Keystore -- "
	rm -fv ${KEYSTORE}

	echo " -- Recreate Keystore -- "
	keytool -genkey -noprompt -alias ${ALIAS} -dname "CN=${DNAME}, OU=${USER}, O=${USER}, L=Uberlandia, S=MG, C=BR" -keystore ${KEYSTORE} -storepass "${PASSWORD}" -KeySize 2048 -keypass "${PASSWORD}" -keyalg RSA

	echo " -- Build CSR -- "
	keytool -certreq -alias ${ALIAS} -file request.csr -keystore ${KEYSTORE} -storepass "${PASSWORD}"

	echo " -- Request Certificate -- "
	certbot certonly --csr ./request.csr --standalone --agree-tos -n -m "${EMAIL}"

	echo " -- import Certificate -- "
	keytool -import -trustcacerts -alias ${ALIAS} -file 0001_chain.pem -keystore ${KEYSTORE} -storepass "${PASSWORD}"

	echo " -- Restart services -- "
	service tomcat${TOMCAT_VERSION} start
	iptables-restore -n < ${FILE_RULES}

	ssl_clean
	ssl_show
	
}

ssl_clean()
{

	echo " -- Cleaning SSL -- "
	rm -fv request.csr
	rm -fv *.pem
	
}

ssl_show()
{
	
	chown -v tomcat:tomcat ${KEYSTORE}
	
	echo "Showing private key..."
	keytool -list -v -keystore ${KEYSTORE} -storepass ${PASSWORD} | less
	
}

ssl_localhost()
{

	echo " -- Delete Keystore -- "
	rm -fv ${DIR_KEYSTORE}/*.pfx

	echo " -- Recreate Keystore -- "
	keytool -genkey -noprompt -alias ${ALIAS} -dname "CN=${DNAME}, OU=${USER}, O=${USER}, L=Uberlandia, S=MG, C=BR" -keystore ${KEYSTORE} -storepass "${PASSWORD}" -KeySize 2048 -keypass "${PASSWORD}" -keyalg RSA -validity 360
	
	ssl_show
	
}

case "$1" in
	install)
		ssl_install
		;;
	create)
		ssl_create
		;;
	show)
		ssl_show
		;;
	localhost)
		ssl_localhost
		;;
	*)
		echo "Use: $0 {install|create|show|localhost}"
		exit 1
		;;
esac
