# Answer Task Week 3

## [Struktur Folder]
```
Automation/
│
├── Terraform/
│    └── idcloudhost/
│        └── main.tf
│        └── outpus.tf
│        └── providers.tf
│        └── storage.tf
│        └── variables.tf
│
├── Ansible/
│   ├── group_vars/
│   │   └── all
│   ├── playbooks/
│   │   └── docker.yml
│   │   └── frontend.yml
│   │   └── monitoring.yml
│   │   └── nginx.yml
│   │   └── ssl.yml
│   │   └── user.yml
│   ├── ansible.cfg
│   └── inventory
│
└── .gitignore
```

## [Terraform]
1. open the local server
## [Ansible]
1. Open the local server (I use WSL)
2. Install ansible `sudo apt install ansible -y`
3. In folder Automation/, Create folder Ansible/
4. Create folder group_vars/, and playbooks/ 
5. Create file ansible.cfg and copy this program [ansible.cfg](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/ansible.cfg)
6. Create file inventory and copy this program [inventory](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/inventory)
7. Go to folder group_vars, create file all and copy this program [all](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/group_vars/all)
8. Go to folder playbooks, Create file user.yml and copy this program [user.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/user.yml)
  - Run this program in folder Ansible/ `ansible-playbook playbooks/user.yml` 
  - 
6.  

## [Monitoring]
