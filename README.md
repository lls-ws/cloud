<h1 align="center">
  Cloud
</h1>

<h4 align="center">
  Scripts to configure a Cloud AWS EC2 with Ubuntu 22.04.3 LTS.
</h4>


## Usage

### From Command Line

```bash
git clone https://github.com/lls-ws/cloud.git

cd cloud

```

### Configure GitHub:

```bash
sudo bin/git_conf.sh name [NAME]

sudo bin/git_conf.sh email [EMAIL]

sudo bin/git_conf.sh password [PASSWORD]

```

### Configure User:

```bash
## Run on a local machine
bash bin/user_conf.sh ping [HOSTNAME]

bash bin/user_conf.sh ssh-local [HOSTNAME] [KEYNAME]

bash bin/user_conf.sh connect [HOSTNAME] [KEYNAME]

## Run on a cloud
bash bin/user_conf.sh hostname [HOSTNAME]

bash bin/user_conf.sh user [USER]

bash bin/user_conf.sh ssh-remote [USER]

```

### Configure Ubuntu:

```bash
sudo bin/ubuntu_conf.sh upgrade

sudo bin/ubuntu_conf.sh profile

sudo bin/ubuntu_conf.sh fonts

```

### Configure Ssmtp:

```bash
sudo bin/git_conf.sh ssmtp [SSMTP-PASSWORD]

sudo bin/ssmtp_conf.sh install

sudo bin/ssmtp_conf.sh config

```

### Configure MariaDB:

```bash
sudo bin/mariadb_conf.sh install

sudo bin/mariadb_conf.sh secure

sudo bin/mariadb_conf.sh conf

sudo bin/mariadb_conf.sh create

```

### Configure Tomcat:

```bash
sudo bash bin/java_conf.sh install

sudo bash bin/tomcat_conf.sh install

sudo bash bin/tomcat_conf.sh setenv

sudo bash bin/tomcat_conf.sh users

```

### Configure IpTables:

```bash
sudo bash bin/iptables_conf.sh install

sudo bash bin/iptables_conf.sh config

sudo bash bin/iptables_conf.sh rules

```

### Configure LLS-WS:

```bash
## Run on a local machine
sudo bash bin/lls_conf.sh local [HOSTNAME_OLD]

## Run on old cloud
sudo bash bin/lls_conf.sh create [HOSTNAME]

## Run on new cloud
sudo bash bin/lls_conf.sh install [HOSTNAME_OLD]

sudo bash bin/lls_conf.sh server

sudo bash bin/lls_conf.sh update

```

### Configure SSL:

```bash
sudo bash bin/ssl_conf.sh install

sudo bash bin/ssl_conf.sh create

```

### Configure Cron:

```bash
sudo bash bin/crontab_conf.sh config

sudo bash bin/crontab_conf.sh show

```


## License

See [LICENSE](LICENSE).
