#!/bin/bash
# Script para gerenciar os repositorios no Github
#
# email: lls.homeoffice@gmail.com

git_update()
{
	
	echo "Updating a local repository with changes from a GitHub repository..."
	git config pull.ff only
	git pull origin master
	
}

git_clone()
{
	
	USER=`git config user.name`
	
	if [ -z "${USER}" ]; then
		
		echo "Use: $(basename $0) name {NAME}"
		exit 1
		
	fi
	
	echo "Cloning a repository from a GitHub..."
	git clone ${URL}/${REPOSITORY}.git
	
	chown -R ${USER}.${USER} ${REPOSITORY}
	
}

git_remote()
{
	
	TOKEN=`git config user.token`
	
	if [ -z "${TOKEN}" ]; then
		
		echo "Use: $(basename $0) token {TOKEN}"
		exit 1
		
	fi
	
	echo "Updating a GitHub repository with changes from a local repository..."
	git add .
	git commit -m "Add files remotely"
	git remote set-url origin ${URL:0:6}//${TOKEN}@${URL:8:17}/${REPOSITORY}.git
	git push -u origin master
	
}

git_conf()
{
	
	CONFIG="$1"
	DATA="$2"
	
	if [ -z "${DATA}" ]; then
		
		DATA="`echo ${CONFIG} | tr '[:lower:]' '[:upper:]'`"
		
		echo "Use: $(basename $0) ${CONFIG} {${DATA}}"
		exit 1
		
	fi
	
	if [ "${CONFIG}" = "remote" -o "${CONFIG}" = "clone" ]; then
		
		REPOSITORY="${DATA}"
		
		git_${CONFIG}
		
	else
	
		# Removing data to config file if exist
		git config --global --unset user.${CONFIG}
		
		echo "Adding data to config file..."
		git config --global --add user.${CONFIG} ${DATA}
		
		echo "Showing the new config..."
		git config user.${CONFIG}
		
	fi
	
}

git_show()
{
	
	echo "Showing a config file..."
	git config --list
	
}

URL="https://github.com/lls-ws"

if [ "$EUID" -ne 0 ]; then
	echo "Rodar script como root"
	exit 1
  
fi

case "$1" in
	show)    	
		git_show
		;;
	local)    	
		git_update
		;;
	clone)    	
		git_conf "clone" "$2"
		;; 
	remote)    	
		git_conf "remote" "$2"
		;;
	name)    	
		git_conf "name" "$2"
		;;
	email)    	
		git_conf "email" "$2"
		;;
	password)    	
		git_conf "password" "$2"
		;;
	token)    	
		git_conf "token" "$2"
		;;
	*)
		echo "Use: $(basename $0) {name|email|password|token|show|local|clone|remote}"
		exit 1
		;;
esac
