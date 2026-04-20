# Answer Task Week 3

## [Struktur Folder]
```
Automation/                                   
│
├── Terraform/                                
│    └── idcloudhost/                  
│        └── main.tf                   # Main resources (VM, network, etc.)
│        └── outputs.tf                # Outputs after deployment (IP, instance info)
│        └── providers.tf              # Provider configuration (IDCloudHost)
│        └── storage.tf                # Storage resources (volumes/disks)
│        └── variables.tf              # Input variables (VM name, size, region, etc.)
│
├── Ansible/
│   ├── ansible.cfg           # Ansible configuration
│   ├── inventory             # Server list & IP addresses
│   ├── group_vars/
│   │   └── all               # Global variables
│   └── playbooks/
│       ├── user.yml              # Create new user + SSH key
│       ├── docker.yml            # Install Docker
│       ├── frontend.yml          # Deploy wayshub-frontend
│       ├── node-exporter.yml     # Install Node Exporter
│       ├── start-monitoring.yml  # Install Prometheus & Grafana
│       ├── nginx.yml             # Setup Nginx reverse proxy
│       ├── ssl.yml               # Generate SSL certificate
│       ├── config/
│       │   └── prometheus.yml    # Prometheus configuration
│       └── dockerstuff/
│           ├── node-exporter.yml      # Node Exporter Docker Compose
│           └── compose-monitoring.yml # Prometheus & Grafana Docker Compose
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
    ![gambar](/Week3/Image/run-docker.png)    

10. Deploy aplication frontend
    - create a frontend.yml file in the playbooks folder and copy this program [frontend.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/frontend.yml)
    - Run Ansible with `ansible-playbook playbooks/frontend.yml`
    - This file is intended to clone the wayshub-frontend application from the repo and run it with docker.
    - In the program there is a `repo: "{{ frontend_repo }}"` this is adjusted to the variables you saved in `group_vars/all`
    - Run this program in folder Ansible/ `ansible-playbook playbooks/frontend.yml`
    ![gambar](/Week3/Image/run-frontend.png)    
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
  
13. Generated SSL certificate
## [Monitoring Server]

#### Arsitektur
```
Internet
    │
    ▼
[fauzi-gateway]
  Nginx (80/443)
    │
    ├──► Grafana (3000) ──► Prometheus (9090)
    │                              │
    │                    ┌─────────┴──────────┐
    │                    ▼                    ▼
    │          node-exporter            node-exporter
    │          fauzi-gateway            fauzi-app
    │
    └──► wayshub-frontend (fauzi-app:3000)
```
    
1. Installasi Monitoring
    - Install Node-exporter
        - Create a `dockerstuff/` folder inside `Ansible/playbooks/`
        - Create a file `node-exporter.yml` in `Ansible/playbooks/dockerstuff/`, then copy the content from [dockerstuff/node-exporter.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/dockerstuff/node-exporter.yml) (*This file serves as a Docker Compose for Node Exporter*)
        - In `Ansible/playbooks/` create `node-exporter.yml` and copy the content from [playbooks/node-exporter.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/node-exporter.yml) (*This file is used to install Node Exporter on all servers.*)
    - Install Prometeus & Grafana
      - Create a file `compose-monitoring.yml` in `Ansible/playbooks/dockerstuff/`, then copy the content from [compose-monitoring.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/dockerstuff/compose-monitoring.yml) (This file serves as a Docker Compose configuration for Prometheus and Grafana)
      - Create a `config/` folder inside `Ansible/playbooks/`, then create prometheus.yml inside it and copy the content from [prometheus.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/config/prometheus.yml) (*This file is used for prometheus configuration*)
      - Create a file `start-monitoring.yml` in `Ansible/playbooks/`, then copy the content from [start-monitoring.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/config/prometheus.yml) (This file is used to install prometheus and grafana)
    - Run the playbook: `ansible-playbook playbooks/node-exporter.yml`    
    ![gambar]()            
    - Run the playbook: `ansible-playbooks playbooks/start-monitoring.yml`    
    ![ganbar]()
    - Test Node Exporter in the browser `IP_server_app:9100`
    - Test prometheus in the browser `IP_server_monitoring:9090`
    - Test grafana in the browser `IP_server_monitoring:3000`
    
2. Grafana Daskboard monitoring (CPU, RAM & Disk Usage) 
    - Open `IP-Server-gateway:9090`
    - 
3. Alert discord
4. Reverse Proxy

## PromQL yang Digunakan

| Metric              | Rumus |
|--------------------|-------|
| CPU Usage          | `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` |
| RAM Usage          | `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` |
| Disk Usage         | `(1 - (node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"})) * 100` |
| Frontend Container | `absent(container_last_seen{name="wayshub-frontend"})` |
