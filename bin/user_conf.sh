#!/bin/sh
# Script to configure a user on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

aliases_conf()
{
	
	FILE_ALIASES=~/.bash_aliases
	
	FILE_CLOUD=~/.cloud_aliases
	
	cp -fv config/bash_aliases_cloud ${FILE_CLOUD}
	
	echo ". ~/.bash_aliases_*" > ${FILE_ALIASES}
	
	cat ${FILE_CLOUD} ${FILE_ALIASES}
	
}

change_hostname()
{
	
	check_host
	
	echo "Changing hostname..."
	sudo tee /etc/hostname <<< ${HOSTNAME}
	
	echo "Show hostname..."
	sudo cat /etc/hostname
	
	echo "Restarting hostname..."
	sudo systemctl restart systemd-hostnamed
	
	sudo reboot
	
}

add_user()
{
	
	check_user "$1"
	
	echo "Adding user ${USER}"
	sudo adduser ${USER}
	
	echo "Changing password..."
	sudo passwd ${USER}
	
	echo "Adding user to sudo group..."
	sudo usermod -a -G sudo ${USER}
	
}

ssh_create_local()
{
	
	check_key

	if [ ! -f ${DIR_SSH}/id_rsa.pub ]; then
	
		echo "Creating key pair on user local..."
		ssh-keygen -t rsa
	
	fi
 
	if [ ! -f ${KEY} ]; then
	
		KEY_DOWNLOAD="/home/${USER}/Downloads/${USER}-${KEYNAME}-${YEAR}.pem"
	
		if [ -f ${KEY_DOWNLOAD} ]; then
	
			echo "Coping KEY PEM to SSH Path..."
			mv -v ${KEY_DOWNLOAD} ${DIR_SSH}
			
			chmod -v 400 ${KEY}
			chown -v lls:lls ${KEY}
			
			ssh-keygen -f "${DIR_SSH}/known_hosts" -R ${HOST}
			
		else
		
			echo "KEY ${KEY_DOWNLOAD} not found!"
			exit 1;
			
		fi
	
	fi
	
	echo "Creating old key pair backup on user local..."
	cp -fv ${DIR_SSH}/id_rsa ${DIR_SSH}/id_rsa.old 2> /dev/null
	cp -fv ${DIR_SSH}/id_rsa.pub ${DIR_SSH}/id_rsa.pub.old 2> /dev/null
	
	echo "Copy key pair to cloud: ${HOST}"
	scp -i ${KEY} ${DIR_SSH}/id_rsa.pub ${USER_CLOUD}@${HOST}:~
	
}

ssh_create_remote()
{
	
	check_user "$1"
	
	KEY_PUB="/home/${USER_CLOUD}/id_rsa.pub"
	
	if [ ! -f ${KEY_PUB} ]; then
	
		echo "KEY not found: ${KEY_PUB}"
		exit 1;
	
	fi
	
	echo "Creating ssh dir for user ${USER}"
	sudo mkdir -v ${DIR_SSH}
	
	echo "Changing group for user ssh dir..."
	sudo chown -Rv ${USER}:${USER} ${DIR_SSH}/
	
	echo "Creating ssh authorized keys..."
	sudo touch ${ARQ_AUTHORIZED_KEYS}
	
	echo "Setting public key to authorized keys..."
	sudo bash -c "cat ${KEY_PUB} >> ${ARQ_AUTHORIZED_KEYS}"
	
	echo "Changing ssh dir permissions..."
	sudo chmod -v 700 ${DIR_SSH}
	sudo chmod -v 600 ${ARQ_AUTHORIZED_KEYS}
	
	echo "Changing group for user ssh authorized keys..."
	sudo chown -v ${USER}:${USER} ${ARQ_AUTHORIZED_KEYS}
	
	echo "show authorized keys file permissions..."
	sudo ls -al ${ARQ_AUTHORIZED_KEYS}
	
	echo "Show authorized keys file content..."
	sudo cat ${ARQ_AUTHORIZED_KEYS}
	
	echo "Deleting public key file..."
 	cd ~
	sudo rm -rf cloud/ ${KEY_PUB}
	
	echo "Type to exit: logout"
	
}

ssh_connect()
{
	
	check_key
	
	echo "Connecting on cloud: ${HOST}"
	ssh -i ${KEY} ${USER_CLOUD}@${HOST}
	
}

check_user()
{
	
	OPT="$1"
	
	if [ -z "${HOSTNAME}" ]; then
		
		echo "Use: $0 ${OPT} {USER}"
		exit 1
	
	fi
	
	USER="${HOSTNAME}"
		
	set_user
	
}

set_user()
{
	
	DIR_SSH="/home/${USER}/.ssh"
	ARQ_AUTHORIZED_KEYS="${DIR_SSH}/authorized_keys"
	HOST="${USER}.net.br"
	
}

check_host()
{
	
	if [ -z "${HOSTNAME}" ]; then
		
		echo "Use: $0 hostname {HOSTNAME}"
		exit 1
	
	fi
	
}

check_key()
{
	
	check_host
	
	if [ -z "${KEYNAME}" ]; then
		
		echo "Use: $0 {HOSTNAME} {KEYNAME}"
		exit 1
	
	fi
	
	KEY="${DIR_SSH}/${USER}-${KEYNAME}-${YEAR}.pem"
	
}

ping_host()
{
	
	ping ${HOST}
	
}

if [ "$EUID" -eq 0 ]; then
	
	echo "Root user not permited!"
	
	exit 1
  
fi

USER=`sudo git config user.name`

set_user

YEAR=`date +%Y`
HOSTNAME="$2"
KEYNAME="$3"

USER_CLOUD="ubuntu"

if [ "${HOSTNAME}" != "${USER}" ]; then

	HOST="${HOSTNAME}.${HOST}"

fi

case "$1" in
	aliases)
		aliases_conf
		;;
	hostname)
		change_hostname
		;;
	user)
		add_user "$1"
		;;
	ssh-local)
		ssh_create_local
		;;
	ssh-remote)
		ssh_create_remote "$1"
		;;
	ping)
		ping_host
		;; 	
	connect)
		ssh_connect
		;; 
	*)
		echo "Use: $0 {aliases|hostname|user|ssh-local|ssh-remote|ping|connect}"
		exit 1
		;;
esac
