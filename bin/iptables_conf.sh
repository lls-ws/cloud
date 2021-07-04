#!/bin/bash
# Script para configurar o Iptables no cloud Ubuntu Server 20.04 LTS 64 bits
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

iptables_rules()
{
	
	RULES="/etc/iptables/rules.v4"
	
	echo "*filter"																	> ${RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${RULES}
	echo ":FORWARD ACCEPT [0:0]"													>> ${RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${RULES}
	echo "COMMIT"																	>> ${RULES}
	echo "*nat"																		>> ${RULES}
	echo ":PREROUTING ACCEPT [0:0]"													>> ${RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${RULES}
	echo ":POSTROUTING ACCEPT [0:0]"												>> ${RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080"		>> ${RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443"		>> ${RULES}
	echo "COMMIT"																	>> ${RULES}
	
	iptables-restore -n < ${RULES}
	
	cat ${RULES}
	
	RULES="/etc/sysctl.conf"
	
	echo "net.ipv4.ip_forward=1"													>> ${RULES}
	
	cat ${RULES} | tail -2
	
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
	rules)
		iptables_rules
		;;
	show)
		iptables_show
		;;
	all)
		iptables_install
		iptables_rules
		iptables_show
		;;
	*)
		echo "Use: $0 {all|install|rules|show}"
		exit 1
		;;
esac
