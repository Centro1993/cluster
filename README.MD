# Quick K3s

Made with https://github.com/k3s-io/k3s-ansible

## Prerequirements
- Ansible 2.9.27
- Terraform 1.1.12
- Flux CLI 0.24.1
- An read/write API-Key for Hetzner Cloud
- An SSH-Key to connect with GitHub

### add API-Key to .bashrc or equivalent
'''
export TF_VAR_hcloud_token='##########' HCLOUD_TOKEN='##########'
'''

### install hcloud plugin for ansible
'''
ansible-galaxy collection install hetzner.hcloud
DIR=$(pwd)
cd /tmp
git clone git@github.com:hetznercloud/hcloud-python.git
cd hcloud-python && pip install -e .
cd $DIR
'''

## Deployment
### create servers
'''
terraform init
terraform plan
terraform apply
'''

### display ansible inventory
'''
cd ansible
ansible-inventory -i inventory/hcloud/hcloud.yaml --graph
'''

### deploy k3s
#### WARNING: this will overwrite your kubeconfig (fetch task in roles/master/tasks/main.yml)
'''
ansible-playbook site.yml -i inventory/hcloud
'''

### deploy flux
First, fork this repo so you can use it to configure your own cluster.
'''
flux check --pre
flux bootstrap git \
  --url=ssh://git@github.com/Centro1993/cluster \
  --branch=main \
  --path=clusters/hcloud
'''