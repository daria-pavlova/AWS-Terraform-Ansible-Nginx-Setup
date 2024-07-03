# Ansible scripts to configure MySQL on GCP VMs

## Preparation

1. Install Google Cloud SDK
2. Login to Google Cloud
> `gcloud auth login`
3. Config ssh-config file related to GCP vms
> `gcloud compute config-ssh`
4. Add ssh-key to ssh agent
> `ssh-add ~/.ssh/google_compute_engine`
5. Install Ansible
> `pip3 install ansible`
6. Check if you can ssh into step server
> `ssh -A stg-step-server-01.asia-northeast1-a.r-pay-1`

## Ansible vault password

> https://gitlab-payment.intra.rakuten-it.com/unbreakable-sec/wallet-api-sec/-/tree/feature/stg-gcp/gcp-infra


## List of PlayBooks used ( run these playbooks in the order listed below )

- 1_mysql-mount-datadisk.yml
- 2_mysql-install.yml
- 2_update_limit_nofile_value.yaml
- 3_google-opts-agent-playbook.yml
- ~~4_mysql-healthcheck do not use.yml~~
- 5_mysql-users.yml
- 6_cronjobs.yml

### 1_mysql-mount-datadisk.yml

This playbook mounts the data disk to the mysql data directory. This playbook is run only once when the VM is created. 
This Play book is distructive in nature. It will format the data disk and mount it to the mysql data directory.
ERASE_DISK variable is set to true in env variable in order for the playbook to erase the disk. this is enabled in the deploy script by default use it with caution.

### 2_mysql-install.yml

This playbook installs mysql on the VM. This playbook is run only once when the VM is created.

### 2_update_limit_nofile_value.yaml

This playbook updates the limit_nofile value in service start file. to reflect the value the mysql needs to be restarted. 

### 3_google-opts-agent-playbook.yml

This playbook installs the google-opts-agent on the VM. 

### 5_mysql-users.yml

This playbook creates the mysql users and grants the privileges to the users.

### 6_cronjobs.yml

This playbook creates the cronjobs for relay server and the backup to gcp bucket.



## To run the script for intial set up

1. Clone the repo
2. cd to the directory  gcp-unbrk3/ansible/gcp-mysql/stg
3. run the deploy script

```bash
bash 00_deploy.sh
```

## For advanced use cases

You can use the individual playbooks to run the tasks. 


```bash
ERASE_DISK=false ansible-playbook -i inventorystg ../playbooks/1_mysql-mount-datadisk.yml --check
```
> the above command is just a sample, it will not do any action.

