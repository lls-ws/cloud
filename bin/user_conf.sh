#!/bin/sh
# Script para configurar o usuario no cloud Ubuntu Server 20.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

root_new_password()
{
	
	echo "Change root password..."
	sudo passwd root
	
	echo "Show root password..."
	sudo cat /etc/shadow | grep root
	
	change_hostname
	
}

change_hostname()
{
	
	echo "Changing hostname..."
	sudo tee /etc/hostname <<< ${HOSTNAME}
	
	echo "Show hostname..."
	sudo cat /etc/hostname
	
	echo "Restarting hostname..."
	sudo systemctl restart systemd-hostnamed
	
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
	
	if [ "${HOSTNAME}" != "lls" ]; then

		HOST="${HOSTNAME}.${HOST}"

	fi
	
	KEY="/home/lls/.ssh/${USER}-${HOSTNAME}-${YEAR}.pem"
	USER="ubuntu"
	
	echo "Creating key pair on user local..."
	#ssh-keygen -t rsa
	
	chmod -v 400 ${KEY}
	
	echo "Copy key pair to cloud..."
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
	sudo rm -fv id_rsa.pub *.sh
	
}

USER="lls"
DIR_SSH="/home/${USER}/.ssh"
ARQ_AUTHORIZED_KEYS="${DIR_SSH}/authorized_keys"

HOST="lls.net.br"
HOSTNAME="$2"

YEAR=`date +%Y`

echo "${YEAR}"

case "$1" in
	root)
		root_new_password
		;; 
	hostname)
		
		if [ -z "${HOSTNAME}" ]; then
		
			echo "Use: $0 hostname {name}"
			exit 1
		
		else
		
			change_hostname
		
		fi
		
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
		echo "Use: $0 {root|hostname|user|ssh-local|ssh-remote}"
		exit 1
		;;
esac
