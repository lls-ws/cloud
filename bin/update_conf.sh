# Passos para configurar o cloud Ubuntu Server 22.04 LTS 64 bits
AGOSTO(2023){

(06/08/2023){

(OK) Criar novo Cloud na Amazon {
 (ok) GoogleDrive: user_aws_2023.doc
 (OK) Criar novo Email no Google {
  (ok) GoogleDrive: 01_Google_Conta_2023.png
 }
 (OK) Criar nova Conta na Amazon {
  (ok) GoogleDrive: 02_Amazon_Conta_2023.png
 }
 }

(OK) Configurar Amazon Web Service {
 (OK) Configurar Instância EC2 {
  (ok) GoogleDrive: lls-funchal-2023.pem
  (ok) GoogleDrive: 03_Instâncias_2023.png
 }
 (OK) Editar Regras de Entrada {
  (ok) GoogleDrive: 04_Regras_2023.png
 }
 (OK) Adicionar Zona no Registro.br {
  (ok) GoogleDrive: 05_Registro.br_2023.png
 }
 }

}

(07/08/2023){

(OK) Configurar Usuário {
 (ok) user_conf.sh ping <HOSTNAME>
 (ok) user_conf.sh ssh-local <HOSTNAME> <KEYNAME>
 (ok) user_conf.sh connect <HOSTNAME> <KEYNAME>
 (ok) user_conf.sh hostname <HOSTNAME>
 (ok) user_conf.sh user <USER>
 (ok) user_conf.sh ssh-remote <USER>
 }

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

(OK) Configurar Ssmtp {
 (ok) GoogleDrive: ssmtp_app_password.doc
 (ok) git_conf.sh ssmtp <SSMTP-PASSWORD>
 (ok) ssmtp_conf.sh install
 (ok) ssmtp_conf.sh config
 }

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

(OK) Configurar Iptables {
 (ok) iptables_conf.sh install
 (ok) iptables_conf.sh config
 (ok) iptables_conf.sh rules
 (ok) iptables_conf.sh show
 }

}

(18/08/2023){

(OK) Configurar LLS-WS {
 (ok) lls_conf.sh local <HOSTNAME_OLD>
 (ok) lls_conf.sh create <HOSTNAME>
 (ok) lls_conf.sh install <HOSTNAME_OLD>
 (ok) lls_conf.sh server
 (ok) lls_conf.sh update
 }

}

(20/08/2023){

(OK) Configurar SSL {
 (ok) ssl_conf.sh install
 (ok) ssl_conf.sh create
 }

(OK) Configurar BackUp {
 (ok) lls_backup.sh restore
 (ok) lls_backup.sh create
 (ok) lls_backup.sh send
 (ok) lls_backup.sh show
 }

(OK) Configurar Cron {
 (ok) crontab_conf.sh config
 (ok) crontab_conf.sh show
 }

}

}

SETEMBRO(2023){

(01/09/2023){

(OK) Desligar Instância 2022 na AWS {}
() Deletar Conta AWS 2022 {}
() Deletar Email Google 2022 {
 () GoogleDrive: Google_2022.png
 }
() Criar novo Log no GitHub {
 () cp -fv bin/update_conf.sh log/update_2023.log
 () git_upload_cloud
 }

}

}
