#!/bin/sh
# Script para configurar o SSL no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/tomcat.lib		|| exit 1

create_pfx()
{
	
	if [ -f ${KEYSTORE} ]; then
	
		rm -fv ${KEYSTORE}
	
	fi
	
	echo "Unpackge certificate..."
	mkdir -v ${DIR_SSLFORFREE}
	unzip ${ARQ_ZIP} -d ${DIR_SSLFORFREE}
	
	echo "Creating PFX key..."
	openssl pkcs12 -export \
		-out ${KEYSTORE} \
		-inkey ${PRIVATE_KEY} \
		-in ${CERTIFICATE} \
		-certfile ${CA_BUNDLE} \
		-passout pass:${PASSWORD} \
		-name ${ALIAS}
	
	rm -rf ${DIR_SSLFORFREE}
	
	show_pfx
	
}

show_pfx()
{
	
	chown -v tomcat.tomcat ${KEYSTORE}
	
	echo "Showing private key..."
	keytool -list -v -keystore ${KEYSTORE} -storepass ${PASSWORD} | less
	
}

copy_zip()
{
	
	if [ -f "${DNAME}.zip" ]; then

		mv -v "${DNAME}.zip" ${DIR_CURRENT}

	fi
	
}

case "$1" in
	create)
		create_pfx
		;; 
	show)
		show_pfx
		;;
	zip)
		copy_zip
		;;
	*)
		echo "Use: $0 {create|show|zip}"
		exit 1
		;;
esac
