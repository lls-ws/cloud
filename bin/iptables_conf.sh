#!/bin/bash
# Script para configurar o Iptables no cloud Ubuntu Server 22.04 LTS 64 bits
#
# Autor: Leandro Luiz
# email: lls.homeoffice@gmail.com

# Caminho das bibliotecas
PATH=.:$(dirname $0):$PATH
. lib/cloud.lib		|| exit 1

iptables_install()
{

	echo "Removing ufw..."
	apt-get -y remove ufw
	
	systemctl mask ufw
	systemctl disable ufw
	
	apt-get -y install iptables iptables-persistent net-tools
	
	systemctl enable netfilter-persistent
	
	systemctl status netfilter-persistent
	
}

iptables_config()
{
	
	FILE_CONF="/etc/sysctl.conf"
	
	echo "net.ipv4.ip_forward=1"	>> ${FILE_CONF}
	
	cat ${FILE_CONF} | tail -2
	
	systemctl restart netfilter-persistent
	
}

iptables_rules()
{
	
	echo "*filter"																	> ${FILE_RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo ":FORWARD ACCEPT [0:0]"													>> ${FILE_RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo "COMMIT"																	>> ${FILE_RULES}
	echo "*nat"																		>> ${FILE_RULES}
	echo ":PREROUTING ACCEPT [0:0]"													>> ${FILE_RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo ":POSTROUTING ACCEPT [0:0]"												>> ${FILE_RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080"		>> ${FILE_RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443"		>> ${FILE_RULES}
	echo "COMMIT"																	>> ${FILE_RULES}
	
	cat ${FILE_RULES}
	
	iptables -F -t nat
	
	iptables-restore -n < ${FILE_RULES}
	
	/usr/sbin/netfilter-persistent save
	/usr/sbin/netfilter-persistent reload
	
	systemctl restart netfilter-persistent
	
}

iptables_show()
{
	
	iptables -L
	
	nc -z -w5 -v localhost 8080
	
	netstat -tulpn
	
	# Check ip address
	#ip addr show

	# Check state
	#ss -t4 state all

	# Watch state
	#watch -n 1 "ss -t4 state established"

	# Check open ports
	#netstat -tulpn

	echo "Check ports to listening..."
	netstat -tanp | grep -i tcp
	
}

case "$1" in
	install)
		iptables_install
		;;
	config)
		iptables_config
		;;
	rules)
		iptables_rules
		;;
	show)
		iptables_show
		;;
	all)
		iptables_install
		iptables_config
		iptables_rules
		iptables_show
		;;
	*)
		echo "Use: $0 {all|install|config|rules|show}"
		exit 1
		;;
esac
