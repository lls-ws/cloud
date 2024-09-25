<h1 align="center">
  Cloud
</h1>

<h4 align="center">
  Scripts to configure a Cloud AWS EC2 with Ubuntu 24.04.1 LTS
</h4>


## Usage

### From Command Line

```bash
git clone https://github.com/lls-ws/cloud.git && cd cloud

```

### Configure GitHub:

```bash
sudo bin/git_conf.sh name [NAME]
```
```bash
sudo bin/git_conf.sh email [EMAIL]
```
```bash
sudo bin/git_conf.sh password [PASSWORD]
```
```bash
sudo bin/git_conf.sh token [TOKEN]
```

### Configure User:


#### Run on a local machine
```bash
bash bin/user_conf.sh ping [HOSTNAME]
```
```bash
bash bin/user_conf.sh ssh-local [HOSTNAME] [KEYNAME]
```
```bash
bash bin/user_conf.sh connect [HOSTNAME] [KEYNAME]
```

#### Run on a cloud
```bash
bash bin/user_conf.sh hostname [HOSTNAME]
```
```bash
bash bin/user_conf.sh user [USER]
```
```bash
bash bin/user_conf.sh ssh-remote [USER]
```

### Configure Ubuntu:

```bash
sudo bin/ubuntu_conf.sh upgrade
```
```bash
sudo bin/ubuntu_conf.sh profile
```
```bash
sudo bin/ubuntu_conf.sh fonts
```

### Configure Ssmtp:

```bash
sudo bin/git_conf.sh ssmtp [SSMTP-PASSWORD]
```
```bash
sudo bin/ssmtp_conf.sh install
```
```bash
sudo bin/ssmtp_conf.sh config
```

### Configure MariaDB:

```bash
sudo bin/mariadb_conf.sh install
```
```bash
sudo bin/mariadb_conf.sh secure
```
```bash
sudo bin/mariadb_conf.sh conf
```
```bash
sudo bin/mariadb_conf.sh create
```

### Configure Tomcat:

```bash
sudo bash bin/java_conf.sh install
```
```bash
sudo bash bin/tomcat_conf.sh install
```
```bash
sudo bash bin/tomcat_conf.sh setenv
```
```bash
sudo bash bin/tomcat_conf.sh users
```

### Configure IpTables:

```bash
sudo bash bin/iptables_conf.sh install
```
```bash
sudo bash bin/iptables_conf.sh config
```
```bash
sudo bash bin/iptables_conf.sh rules
```

### Configure LLS-WS:

#### Run on a local machine
```bash
sudo bash bin/lls_conf.sh local [HOSTNAME_OLD]
```

#### Run on old cloud
```bash
sudo bash bin/lls_conf.sh create [HOSTNAME]
```

#### Run on new cloud
```bash
sudo bash bin/lls_conf.sh install [HOSTNAME_OLD]
```
```bash
sudo bash bin/lls_conf.sh server
```
```bash
sudo bash bin/lls_conf.sh update
```

### Configure SSL:

```bash
sudo bash bin/ssl_conf.sh install
```
```bash
sudo bash bin/ssl_conf.sh create
```

### Configure Cron:

```bash
sudo bash bin/crontab_conf.sh config
```


## License

See [LICENSE](LICENSE).
