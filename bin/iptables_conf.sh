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
	apt-get -y purge ufw
	
	systemctl mask ufw
	systemctl disable ufw
	
	apt-get -y install iptables iptables-persistent net-tools
	
	systemctl enable netfilter-persistent
	
	systemctl status netfilter-persistent
	
}

iptables_config()
{
	
	rm -fv ${FILE_CONF}
	
	echo "# Enable packet forwarding for IPv4"	> ${FILE_CONF}
	echo "net.ipv4.ip_forward=1"				>> ${FILE_CONF}
	
	show_config
	
	systemctl restart netfilter-persistent
	
}

iptables_rules()
{
	
	systemctl stop netfilter-persistent
	
	rm -fv ${FILE_RULES}
	
	echo "*filter"																	> ${FILE_RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo ":FORWARD ACCEPT [0:0]"													>> ${FILE_RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo "COMMIT"																	>> ${FILE_RULES}
	echo "*nat"																		>> ${FILE_RULES}
	echo ":PREROUTING ACCEPT [0:0]"													>> ${FILE_RULES}
	echo ":INPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo ":OUTPUT ACCEPT [0:0]"														>> ${FILE_RULES}
	echo ":POSTROUTING ACCEPT [0:0]"												>> ${FILE_RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080"		>> ${FILE_RULES}
	echo "-A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443"		>> ${FILE_RULES}
	echo "COMMIT"																	>> ${FILE_RULES}
	
	show_rules
	
	echo "Removing all rules:"
	iptables -F -t nat -v
	
	iptables-restore -n < ${FILE_RULES}
	
	netfilter-persistent save
	
	netfilter-persistent reload
	
	systemctl start netfilter-persistent
	
	iptables_show
	
}

show_config()
{
	
	echo -e "\nShowing file config ${FILE_CONF}"
	cat ${FILE_CONF}
	
}

show_rules()
{
	
	echo -e "\nShowing file rules ${FILE_RULES}"
	cat ${FILE_RULES}
	
}

iptables_show()
{
	
	echo -e "\nCheck connection to localhost:"
	nc -z -w5 -v localhost 8080
	
	echo -e "\nCheck open ports:"
	netstat -tulpn
	
	echo -e "\nCheck state:"
	ss -t4 state all

	echo -e "\nCheck ports to listening..."
	netstat -tanp | grep -i tcp
	
	show_config
	
	show_rules
	
	echo -e "\nShowing iptables rules:"
	iptables -t nat -v -L -n --line-number
	
}

iptables_watch()
{
	
	tcpdump -i any -n port 80
	
}

iptables_remove()
{
	
	echo "Removing iptables..."
	apt-get -y purge iptables iptables-persistent net-tools
	apt -y autoremove
	
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
		iptables_rules
		;;
	show)
		iptables_show
		;;
	watch)
		iptables_watch
		;;
	remove)
		iptables_remove
		;;
	all)
		iptables_install
		iptables_config
		iptables_rules
		iptables_show
		;;
	*)
		echo "Use: $0 {all|install|config|rules|show|watch|remove}"
		exit 1
		;;
esac
