#!/bin/bash

PASSWORD=`git config user.password`

if [ -z "${PASSWORD}" ]; then
	
	echo "Not found a user password!"
	echo "Use: git_conf.sh password {PASSWORD}"
	exit 1
	
fi

DOMAIN="$HOSTNAME.$USER.net.br"
TARGET_DIR="/var/tomcat/ssl"

echo "Garante que o diretório de destino existe:"
mkdir -p $TARGET_DIR

echo "Converte arquivos PEM nativos do Certbot em keystore PKCS12 (.p12):"
openssl pkcs12 -export \
  -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
  -inkey /etc/letsencrypt/live/$DOMAIN/privkey.pem \
  -out $TARGET_DIR/tomcat_keystore.p12 \
  -name tomcat \
  -passout pass:$PASSWORD

echo "Ajusta as permissões para o usuário que roda o Tomcat:"
chown -R tomcat:tomcat $TARGET_DIR
chmod 600 $TARGET_DIR/tomcat_keystore.p12

ls -alh $TARGET_DIR/tomcat_keystore.p12

echo "Reinicia o Tomcat para ler o novo certificado convertido:"
systemctl restart tomcat9
