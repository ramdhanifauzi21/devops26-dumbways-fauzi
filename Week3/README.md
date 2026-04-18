# Answer Task Week 3

## [Struktur Folder]
```
Automation/                                   
│
├── Terraform/                                
│    └── idcloudhost/                         # IDCloudHost provider configuration
│        └── main.tf          # Main resources (VM, network, etc.)
│        └── outputs.tf       # Outputs after deployment (IP, instance info)
│        └── providers.tf     # Provider configuration (IDCloudHost)
│        └── storage.tf       # Storage resources (volumes/disks)
│        └── variables.tf     # Input variables (VM name, size, region, etc.)
│
├── Ansible/                                  
│   ├── group_vars/
│   │   └── all              # Global variables (username, password, etc.) → should use Vault
│   ├── playbooks/
│   │   └── docker.yml       # Install and configure Docker
│   │   └── frontend.yml     # Deploy frontend application (container/build)
│   │   └── monitoring.yml   # Install monitoring (node exporter, prometheus, grafana)
│   │   └── nginx.yml        # Setup reverse proxy (nginx)
│   │   └── ssl.yml          # Generate and configure SSL (certbot/letsencrypt)
│   │   └── user.yml         # Create user + setup SSH key and permissions
│   ├── ansible.cfg          # Ansible configuration (SSH, timeout, etc.)
│   └── inventory            # List of servers (IP, user, groups)
│
└── .gitignore               # Files/folders excluded from repository (secrets, cache, etc.)
```

## [Terraform]
1. Open the local server (I use WSL)
2. On folder idcloudhost/
  - Create providers.tf file [providers.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/providers.tf)
  - Create terraform.tfvars file (this file is filled with the billing ID and token and password)
  ```
  auth_token         = "Isi dengan Token"
  billing_account_id = Isi dengan billing ID IDCH

  password        = "Password Kamu"
  ```
  - Create variables.tf file [variables.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/variables.tf)(This file contains variables that will be used later)
  - Create main.tf file [main.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/main.tf)
  - Create output.tf file [output.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/outputs.tf)
  - Create storage.tf file [storage.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/storage.tf)

3. Run Terraform `terraform init`
  - Make sure there is a comment  Successfully initialize
  ![gambar](/Week3/Image/terraform-init.png)  

4. Run `terraform validate`
  - Make sure there is a comment  *success! the configuration is valid*
  ![gambar](/Week3/Image/terraform-validate.png)    

5. Run `terraform plan`
![gambar](/Week3/Image/terraform-plan.png)

6. Run `terraform apply`


## [Ansible]
1. Open the local server (I use WSL)
2. Install ansible `sudo apt install ansible -y`
3. In folder Automation/, Create folder Ansible/
4. Create folder group_vars/, and playbooks/ 
5. Create file ansible.cfg and copy this program [ansible.cfg](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/ansible.cfg)
6. Create file inventory and copy this program [inventory](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/inventory)
7. Go to folder group_vars, create file all and copy this program [all](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/group_vars/all)
  - In this file, create several variables that will be used later, such as the port, username and password variables
8. Create user on the server app & gateway server
  - create a user.yml file in the playbooks folder and copy this program [user.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/user.yml)
  - If you want to change the username, you can do it in the `group_vars/all` section
  - Run this program in folder Ansible/ `ansible-playbook playbooks/user.yml`
  ![gambar](/Week3/Image/run-user.png)    
    
9. Install docker
  - create a docker.yml file in the playbooks folder and copy this program [docker.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/docker.yml)
  - This file is intended to install docker on all servers
  - If you want to install on the app server only, change the hosts section to app (adjust it to what is in ansible.cfg)
  - Run this program in folder Ansible/ `ansible-playbook playbooks/docker.yml`
  ![gambar](devops26-dumbways-fauzi/Week3/Image/run-docker.png)    

10. Deploy aplication frontend
  - create a frontend.yml file in the playbooks folder and copy this program [frontend.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/frontend.yml)
  - Run Ansible with `ansible-playbook playbooks/frontend.yml`
  - This file is intended to clone the wayshub-frontend application from the repo and run it with docker.
  - In the program there is a `repo: "{{ frontend_repo }}"` this is adjusted to the variables you saved in `group_vars/all`
  - Run this program in folder Ansible/ `ansible-playbook playbooks/frontend.yml`
  ![gambar](devops26-dumbways-fauzi/Week3/Image/run-frontend.png)    
  - try opening the frontend in the web using `IP Server:3000`
  ![gambar](/Week3/Image/try-frontend-ip.png)    
  
11. Setup Reverse Proxy
  - Create a domain in Cloudflare, fill in the IP with the gateway server IP 
  ![gambar](/Week3/Image/create-dns-cloudflare.png)    
  - create a nginx.yml file in the playbooks folder and copy this program [nginx.yml]
  - Run Ansible with `ansible-playbook playbooks/nginx.yml`
  ![gambar](/Week3/Image/run-nginx.png)      
  - Try opening the frontend in the web using DNS
  ![gambar]
  
12. Instalasi Monitoring Server
13. Generated SSL certificate
## [Monitoring Server]
