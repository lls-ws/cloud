<h1 align="center">
  Cloud
</h1>

<h4 align="center">
  Scripts to configure a Cloud AWS EC2 with Ubuntu 22.04.2 LTS.
</h4>


## Usage

### From Command Line

```bash
git clone https://github.com/lls-ws/cloud.git

cd cloud

sudo bin/git_conf.sh name [NAME]

sudo bin/git_conf.sh email [EMAIL]

sudo bin/git_conf.sh password [PASSWORD]

```

### Configure User:

```bash
bash bin/user_conf.sh hostname [HOSTNAME]

bash bin/user_conf.sh user

# Only this line is run on a local machine
bash bin/user_conf.sh ssh-local [HOSTNAME] [KEYNAME]

# Run again on a cloud
bash bin/user_conf.sh ssh-remote

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

## License

See [LICENSE](LICENSE).
