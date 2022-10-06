# Xtrabackup S3

Creates and uploads MySQL backups to S3 bucket.

## How to Setup

### Install required packages
```shell
sudo apt install mydumper xtrabackup rclone
```

### Configure /home/user/.my.cnf
```text
[client]
user=user
password=root-password

[mysqldump]
user=user
password=root-password
```

### Configure Rclone
You can do it through the command-line interface or create or edit rclone.conf
> **WARNING**: You must use the same name for your Rclone profile as your project name!

#### 1. Command-line interface
```shell
rclone config
```

#### 2. Config file /home/user/.config/rclone/rclone.conf
```text
[project-name]
type = s3
provider = Other
endpoint = 
access_key_id = 
secret_access_key = 
acl = bucket-owner-full-control
```

## How to use
```
xtrabackup-s3.sh -n <project-name> -p <backet-path>
```