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

() Configurar Usuário {
 (ok) user_conf.sh ping <HOSTNAME>
 (ok) user_conf.sh ssh-local <HOSTNAME> <KEYNAME>
 (ok) user_conf.sh connect <HOSTNAME> <KEYNAME>
 () user_conf.sh hostname <HOSTNAME>
 () user_conf.sh user
 () user_conf.sh ssh-remote
 }
}

(08/08/2023){
() Configurar GitHub {
 () GoogleDrive: ten.doc
 () git_conf.sh name <NAME>
 () git_conf.sh email <EMAIL>
 () git_conf.sh password <PASSWORD>
 () git_conf.sh show
 }
() Configurar Ubuntu {
 () ubuntu_conf.sh upgrade
 () ubuntu_conf.sh profile
 () ubuntu_conf.sh fonts
 () ubuntu_conf.sh version
 }
() Configurar Ssmtp {
 () GoogleDrive: ssmtp_app_password.doc
 () git_conf.sh ssmtp <SSMTP-PASSWORD>
 () ssmtp_conf.sh install
 () ssmtp_conf.sh config
 }
}

(09/08/2023){
() Configurar MariaDB {
 () mariadb_conf.sh install
 () mariadb_conf.sh secure
 () mariadb_conf.sh conf
 () mariadb_conf.sh create
 () mariadb_conf.sh show
 () mariadb_conf.sh version
 }
() Configurar Java {
 () java_conf.sh install
 }
() Configurar Tomcat {
 () tomcat_conf.sh search
 () tomcat_conf.sh install
 () tomcat_conf.sh check
 () tomcat_conf.sh setenv
 () tomcat_conf.sh users
 () tomcat_conf.sh show
 () tomcat_conf.sh memory
 }
}

(10/08/2023){
() Configurar LLS-WS {
 () lls_conf.sh local <HOSTNAME>
 () lls_conf.sh create <HOSTNAME>
 () lls_conf.sh install <HOSTNAME>
 () lls_conf.sh server
 () lls_conf.sh update
 }
() Configurar SSL {
 () ssl_conf.sh install
 () ssl_conf.sh create
 }
() Configurar Iptables {
 () iptables_conf.sh install
 () iptables_conf.sh config
 () iptables_conf.sh rules
 () iptables_conf.sh show
 }
 
}

(11/08/2023){
() Configurar BackUp {
 () lls_backup.sh restore
 () lls_backup.sh create
 () lls_backup.sh send
 () lls_backup.sh show
 () crontab_conf.sh config
 () crontab_conf.sh show
 }

}

(12/08/2023){
() Desligar Instância 2022 na AWS {}
() Deletar Conta AWS 2022 {}
() Deletar Email Google 2022 {
 () GoogleDrive: Google_2022.png
 }
() Criar novo Log no GitHub {
 () cp -fv bin/update_conf.sh log/update_2022.log
 () git_upload_cloud
 }
}

}
