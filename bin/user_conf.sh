#!/bin/sh
# Script to configure a user on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

change_hostname()
{
	
	if [ -z "${HOSTNAME}" ]; then
		
		echo "Use: $0 hostname {HOSTNAME}"
		exit 1
	
	fi
	
	echo "Changing hostname..."
	sudo tee /etc/hostname <<< ${HOSTNAME}
	
	echo "Show hostname..."
	sudo cat /etc/hostname
	
	echo "Restarting hostname..."
	sudo systemctl restart systemd-hostnamed
	
	exit
	
}

add_user()
{
	
	echo "Adding user ${USER}"
	sudo adduser ${USER}
	
	echo "Changing password..."
	sudo passwd ${USER}
	
}

ssh_create_local()
{
	
	if [ -z "${HOSTNAME}" -o -z "${KEYNAME}" ]; then
		
		echo "Use: $0 {HOSTNAME} {KEYNAME}"
		exit 1
	
	fi
	
	if [ "${HOSTNAME}" != "${USER}" ]; then

		HOST="${HOSTNAME}.${HOST}"

	fi
	
	KEY="${DIR_SSH}/${USER}-${KEYNAME}-${YEAR}.pem"
	USER="ubuntu"
	
	echo "Creating old key pair backup on user local..."
	cp -fv ${DIR_SSH}/id_rsa ${DIR_SSH}/id_rsa.old 2> /dev/null
	cp -fv ${DIR_SSH}/id_rsa.pub ${DIR_SSH}/id_rsa.pub.old 2> /dev/null
	
	if [ ! -f ${DIR_SSH}/id_rsa.pub ]; then
	
		echo "Creating key pair on user local..."
		ssh-keygen -t rsa
	
		chmod -v 400 ${KEY}
		
	fi
	
	echo "Copy key pair to cloud: ${HOST}"
	scp -i ${KEY} ${DIR_SSH}/id_rsa.pub ${USER}@${HOST}:~
	
}

ssh_create_remote()
{
	
	echo "Creating ssh dir for user ${USER}"
	sudo mkdir -v ${DIR_SSH}
	
	echo "Changing group for user ssh dir..."
	sudo chown -Rv ${USER}.${USER} ${DIR_SSH}/
	
	echo "Creating ssh authorized keys..."
	sudo touch ${ARQ_AUTHORIZED_KEYS}
	
	echo "Setting public key to authorized keys..."
	sudo bash -c "cat id_rsa.pub >> ${ARQ_AUTHORIZED_KEYS}"
	
	echo "Changing ssh dir permissions..."
	sudo chmod -v 700 ${DIR_SSH}
	sudo chmod -v 600 ${ARQ_AUTHORIZED_KEYS}
	
	echo "Changing group for user ssh authorized keys..."
	sudo chown -v ${USER}.${USER} ${ARQ_AUTHORIZED_KEYS}
	
	echo "show authorized keys file permissions..."
	sudo ls -al ${ARQ_AUTHORIZED_KEYS}
	
	echo "Show authorized keys file content..."
	sudo cat ${ARQ_AUTHORIZED_KEYS}
	
	echo "Deleting public key file..."
	sudo rm -rf cloud/ id_rsa.pub
	
	echo "Type to exit: logout"
	
}

if [ "$EUID" -eq 0 ]; then
	
	echo "Root user not permited!"
	
	exit 1
  
fi

USER=`sudo git config user.name`

DIR_SSH="/home/${USER}/.ssh"
ARQ_AUTHORIZED_KEYS="${DIR_SSH}/authorized_keys"
HOST="${USER}.net.br"
YEAR=`date +%Y`
HOSTNAME="$2"
KEYNAME="$3"

case "$1" in
	hostname)
		change_hostname
		;;
	user)
		add_user
		;;
	ssh-local)
		ssh_create_local
		;;
	ssh-remote)
		ssh_create_remote
		;; 
	*)
		echo "Use: $0 {hostname|user|ssh-local|ssh-remote}"
		exit 1
		;;
esac
