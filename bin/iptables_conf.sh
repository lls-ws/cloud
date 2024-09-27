#!/bin/bash
# Script to configure IpTables on cloud Ubuntu Server
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
	
	echo "net.ipv4.ip_forward=1"	>> ${FILE_CONF}
	
	show_config
	
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
	
	if [ "${RULES_OPT}" = "cloud" ]; then
	
		echo "-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080"		>> ${FILE_RULES}
		echo "-A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443"		>> ${FILE_RULES}
	
	fi
		
	echo "COMMIT"																	>> ${FILE_RULES}
	
	show_rules
	
	iptables -F -t nat
	
	iptables-restore -n < ${FILE_RULES}
	
	/usr/sbin/netfilter-persistent save
	/usr/sbin/netfilter-persistent reload
	
	systemctl restart netfilter-persistent
	
	show_rules
	
}

show_config()
{
	
	echo -e "\nShowing file config ${FILE_CONF}"
	cat ${FILE_CONF} | tail -2
	
}

show_rules()
{
	
	echo -e "\nShowing file rules ${FILE_RULES}"
	cat ${FILE_RULES}
	
}

iptables_show()
{
	
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
	
	show_config
	
	show_rules
	
	echo -e "\nShowing iptables rules:"
	iptables -L
	
}

FILE_CONF="/etc/sysctl.conf"

case "$1" in
	install)
		iptables_install
		;;
	config)
		iptables_config
		;;
	rules)
		case "$2" in
			cloud)
				RULES_OPT="cloud"
				;;
			localhost)
				RULES_OPT="localhost"
				;;
			*)
				echo "Use: $0 $1 {cloud|localhost}"
				exit 1
				;;
		esac
		
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
