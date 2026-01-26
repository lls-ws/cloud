#!/bin/sh
# Script to configure Java on cloud Ubuntu Server
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

PATH=.:$(dirname $0):$PATH
. bin/java/java_settings.sh		|| exit 1
. bin/java/java_remove.sh		|| exit 1
. bin/java/java_install.sh		|| exit 1

clear

case "$1" in
	list)
		java_list
		;;
	remove)
		java_remove
		;;
	install)
		java_install
		;;
	path)
		java_path
		;;
	version)
		java_version
		;;
	show)
		show_env
		;;
	*)
		echo "Use: $0 {list|remove|install|path|version|show}"
		exit 1
		;;
esac
