# Passos para configurar o cloud Ubuntu Server 22.04 LTS 64 bits
JUNHO(2022){
(26/06/2022){
(OK) Criar novo Log no GitHub {
 (ok) GoogleDrive: token.doc
 (ok) git_conf.sh token <TOKEN>
 (ok) update_2021.log
 }
(OK) Criar novo Cloud na Amazon {
 (ok) GoogleDrive: user_aws_2022.doc
 (ok) Criar novo Email no Google
 (ok) Criar nova Conta na Amazon
 }
}

(27/06/2022){
(OK) Configurar Amazon Web Service {
 (ok) GoogleDrive: user_aws_2022.doc
 (ok) Configurar Instância EC2
 (ok) Editar Regras de Entrada
 (ok) Adicionar Zona no Registro.br
 (ok) GoogleDrive: user_registro.br.doc
 }
(OK) Configurar Usuário {
 (ok) user_conf.sh root <HOSTNAME>
 (ok) user_conf.sh user
 (ok) user_conf.sh ssh-local <HOSTNAME> <KEYNAME>
 (ok) user_conf.sh ssh-remote
 }
}

(28/06/2022){
(OK) Configurar GitHub {
 (ok) GoogleDrive: token.doc
 (ok) git_conf.sh name <NAME>
 (ok) git_conf.sh email <EMAIL>
 (ok) git_conf.sh password <PASSWORD>
 (ok) git_conf.sh show
 }
(OK) Configurar Ubuntu {
 (ok) ubuntu_conf.sh upgrade
 (ok) ubuntu_conf.sh profile
 (ok) ubuntu_conf.sh fonts
 (ok) ubuntu_conf.sh version
 }
(OK) Configurar Iptables {
 (ok) iptables_conf.sh install
 (ok) iptables_conf.sh config
 (ok) iptables_conf.sh rules
 (ok) iptables_conf.sh show
 }
(OK) Configurar Ssmtp {
 (ok) GoogleDrive: ssmtp_app_password.doc
 (ok) git_conf.sh ssmtp <SSMTP-PASSWORD>
 (ok) ssmtp_config.sh install
 (ok) ssmtp_config.sh config
 }
}

(29/06/2022){
(OK) Configurar MariaDB {
 (ok) mariadb_conf.sh install
 (ok) mariadb_conf.sh secure
 (ok) mariadb_conf.sh conf
 (ok) mariadb_conf.sh create
 (ok) mariadb_conf.sh show
 (ok) mariadb_conf.sh version
 }
(OK) Configurar Java {
 (ok) java_conf.sh install
 }
(OK) Configurar Tomcat {
 (ok) tomcat_conf.sh search
 (ok) tomcat_conf.sh install
 (ok) tomcat_conf.sh check
 (ok) tomcat_conf.sh setenv
 (ok) tomcat_conf.sh users
 (ok) tomcat_conf.sh show
 (ok) tomcat_conf.sh memory
 }
( ) Configurar LLS-WS {
 (ok) lls_conf.sh local <HOSTNAME>
 (ok) lls_conf.sh create <HOSTNAME>
 ( ) lls_conf.sh install <HOSTNAME>
 ( ) lls_conf.sh server
 ( ) lls_conf.sh update
 }
}

}

JULHO(2022){
(01/07/2022){
( ) Configurar SSL {
 ( ) ssl_conf.sh
 }
( ) Configurar BackUp {
 ( ) lls_backup.sh
 ( ) crontab_conf.sh
 }
( ) Desligar Instância 2021 na AWS {}
}
(02/07/2022){
( ) Deletar Conta AWS 2021 {}
( ) Deletar Email Google 2021 {}
}
}
