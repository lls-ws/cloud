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

bash bin/git_config.sh name [NAME]

bash bin/git_config.sh email [EMAIL]

bash bin/git_config.sh password [PASSWORD]

```

### Configure a user:

```bash
bash bin/user_config.sh hostname [HOSTNAME]

bash bin/user_config.sh user

# Only this line is run on a local machine
bash bin/user_config.sh ssh-local [HOSTNAME] [KEYNAME]

# Run again on a cloud
bash bin/user_config.sh ssh-remote

```


## License

See [LICENSE](LICENSE).
