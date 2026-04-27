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
2. Navigate to the `Ansible/` folder
    - Create providers.tf file [providers.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/providers.tf)
    - Create terraform.tfvars file (this file is filled with the billing ID and token and password)
      ```tf
      auth_token         = "Isi dengan Token"
      billing_account_id = Isi dengan billing ID IDCH

      password        = "Password Kamu"
      ```
    - Create variables.tf file [variables.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/variables.tf) (This file contains variables that will be used later)
    - Create main.tf file [main.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/main.tf)
    - Create output.tf file [output.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/outputs.tf)
    - Create storage.tf file [storage.tf](https://github.com/ramdhanifauzi21/Automation/blob/main/Terraform/idcloudhost/storage.tf)

3. Run Terraform initialization: `terraform init` 
    - Make sure it shows:  **"Successfully initialize"**            
    ![gambar](/Week3/Image/terraform-init.png)  

4. Validate the configuration: `terraform validate`
    - Make sure it shows: **"Success! The configuration is valid"**            
    ![gambar](/Week3/Image/terraform-validate.png)    

5. Run the execution plan: `terraform plan`              
![gambar](/Week3/Image/terraform-plan.png)

6. Apply the configuration: `terraform apply`


## [Ansible]
1. Open the local server (I use WSL)
2. Install ansible: `sudo apt install ansible -y`
3. In folder `Automation/`, Create folder `Ansible/`
4. Inside `Ansible/` create the following folders: 
    - `group_vars/`
    - `playbooks/` 
5. Create an `ansible.cfg` file and copy this program [ansible.cfg](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/ansible.cfg)
6. Create an `inventory` file and copy this program [inventory](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/inventory)
7. Go to the `group_vars/` folder, create a file named `all` and copy this program [all](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/group_vars/all)
    - This file contains variables that will be used later, such as port, username, and password
8. Create a user on the app server and gateway server:
    - create a `user.yml` file in the `playbooks/` folder and copy this program [user.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/user.yml)
    - *To change the username, edit it in `group_vars/all`*
    - Run this program in folder Ansible/ `ansible-playbook playbooks/user.yml`
    ![gambar](/Week3/Image/run-user.png)    
    
9. Install docker
    - create `docker.yml` file in the `playbooks/` folder and copy this program [docker.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/docker.yml)
    - This file installs Docker on all servers
    - To install only on the app server or gateway server, adjust the `hosts` section (based on `ansible.cfg`)
    - Run this program in folder Ansible/ `ansible-playbook playbooks/docker.yml`
    ![gambar](/Week3/Image/run-docker.png)    

10. Deploy aplication frontend
    - create `frontend.yml` file in the `playbooks/` folder and copy this program [frontend.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/frontend.yml)
    - This file clones the wayshub-frontend repository and runs it using Docker
    - In the program there is a `repo: "{{ frontend_repo }}"` this is adjusted to the variables you saved in `group_vars/all`
    - Run this program in folder Ansible/ `ansible-playbook playbooks/frontend.yml`
    ![gambar](/Week3/Image/run-frontend.png)    
    - Access the frontend via: `http://IP_Server:3000`
    ![gambar](/Week3/Image/try-frontend-ip.png)    
  
11. Setup Reverse Proxy
    - Create a domain in Cloudflare, fill in the IP with the gateway server IP 
    ![gambar](/Week3/Image/create-dns-cloudflare.png)    
    - create `nginx.yml` file in the `playbooks/` folder and copy this program [nginx.yml](https://github.com/ramdhanifauzi21/Automation/blob/main/Ansible/playbooks/nginx.yml)
    - Run Ansible with `ansible-playbook playbooks/nginx.yml`
    ![gambar](/Week3/Image/run-nginx.png)      
    - Access the application via your domain (DNS)
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
    ![gambar](/Week3/Image/run-node-exporter.png)                    
    - Run the playbook: `ansible-playbooks playbooks/start-monitoring.yml`                
    ![gambar](/Week3/Image/run-start-monitoring.png)            
    - Test Node Exporter in the browser `IP_server_app:9100`                    
    ![gambar](/Week3/Image/open-node-exporter.png)               
    ![gambar](/Week3/Image/node-exporter-matrix.png)                
    - Test prometheus in the browser `IP_server_monitoring:9090`                    
    ![gambar](/Week3/Image/open-prometheus.png)              
    ![gambar](/Week3/Image/prometheus-target-health.png)                            
    - Test grafana in the browser `IP_server_monitoring:3000`                        
    ![gambar](/Week3/Image/open-grafana.png)            
2. Grafana Dashboard monitoring (CPU, RAM & Disk Usage) 
    - Open `IP-Server-gateway:9090`
    - Login grafana with `user: admin password: admin` and then change the password after login                
    ![gambar](/Week3/Image/open-grafana-userpw.png)                
    - view after logging in to Grafana            
    ![gambar](/Week3/Image/after-loggin-grafana.png)                
    - Create Data source
        - Go to: `Connections -> Data source -> Add data source -> Select prometheus`
        - Fill in: 
            - name `prometheus`
            - Connection URL: `http://103.31.39.130:9090`
            - Click **save & test** (*make sure it shows success*)                
       ![gambar](/Week3/Image/data-source.png)            

    - Create new dashboard
        - **CPU Usage**
        - Go to: `Dashboard -> Create New Dashboard -> Add panel -> configure virtualization`            
        ![gambar](/Week3/Image/dashboard-add-panel.png)            

        - In data source select **prometheus** -> Click `code` (bottom right)
        - In the query column, fill in this promql: `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` -> Click **Run queries** -> Change panel name to **CPU Usage** -> back to dashboard                
        ![gambar](/Week3/Image/run-promql-cpuusage.png)            
        - Customize the appearance as needed             
        ![gambar](/Week3/Image/after-edit-cpuusage.png)                
         
        - **RAM Usage**
        - Click on new panel and do the same thing
        - In the query column, fill in this promql: `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` -> Run queries -> Change panel name to **RAM Usage** -> back to dasboard            
        ![gambar](/Week3/Image/run-promql-ramusage.png)            
        - Customize the appearance as needed                 
        ![gambar](/Week3/Image/after-edit-ramusage.png)            
     
        - **Disk Usage**
        - Click on new panel and do the same thing
        - In the query column, fill in this promql: `(1 - (node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"})) * 100` -> Run queries -> Change panel name to **Disk Usage** 
        - Customize the appearance as needed                     
        ![gambar](/Week3/Image/run-promql-diskusage.png)                         
        - Save dasboard                
        ![gambar](/Week3/Image/dashboard-save.png)            
 
3. Alert discord
    - Create notification configuration
        - Go to: `Alerting -> Notification configuration -> New contact point`            
        ![gambar](/Week3/Image/add-new-contackpoint.png)            
        - Enter the name -> select integration **Discord** -> Paste the **webhook URL** from Discord -> save contact point        
        ![gambar](/Week3/Image/configuration-contactpoint.png)                
        
    - Create Alert Rules
        - **Create alertin CPU >20%**
        - Go to: `alerting -> Alert rules -> New alert rules`            
        ![gambar](/Week3/Image/add-new-alertrules.png)                        
        - Fill in the Rule name -> In the query section, select the **Prometheus** data source -> Enter promql `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` -> Run queries -> In the alert condition IS ABOVE section, fill in `20`
        - In the Add foler and labels click new folder -> create a new folder and save -> Select the folder you just created
        - In the Set evaluation behavior click New evaluation group -> select interval 1m and create 
        ![gambar](/Week3/Image/alert-rule-cpuusage-1.png) 
        ![gambar](/Week3/Image/evaluation-group.png)            
        - In the configuration notification select Discord -> click add custom annotation -> select `CPU Usage` and confirm -> save          
        ![gambar](/Week3/Image/alert-rule-cpuusage-2.png)                    
        ![gambar](/Week3/Image/custom-annotation.png)                
        ![gambar](/Week3/Image/result-alert-cpuusage.png)                
       
        - **Create alerting RAM >75%**
        - Do the same thing as before
        - In the query section, select the Prometheus data source -> Enter promql  -> Run queries `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` -> In the alert condition IS ABOVE section, fill in `75`
        ![gambar](/Week3/Image/alert-rule-ramusage.png)            
        - In the configuration notification select Discord -> click add custom annotation -> select `RAM Usage` and confirm -> save
        ![gambar](/Week3/Image/custom-annotation-ramusage.png)            
        ![gambar](/Week3/Image/result-alert-ramusage.png)            
        
        - **Create alerting frontend**
        - Do the same thing as before
        - In the query section, select the Prometheus data source -> Enter promql  -> Run queries `absent(container_last_seen{name="wayshub-frontend"})` -> In the alert condition IS ABOVE section, fill in `0`            
        ![gambar](/Week3/Image/alert-rule-frontend.png)            
        - In the configuration notification select Discord -> save            
        ![gambar](/Week3/Image/result-alert-frontend.png)            
    - Result Alert Rules                
    ![gambar](/Week3/Image/result-alert-rules.png)                    
    - Cek in discord
        - CPU Usage            
        ![gmbar](/Week3/Image/notif-discord-cpuusage.png)            
        - RAM Usage            
        ![gmbar](/Week3/Image/notif-discord-ramusage.png)            
        - Frontend            
        ![gmbar](/Week3/Image/notif-discord-frontend.png)                
    
4. Reverse Proxy
5. SSL

## PromQL yang Digunakan

| Metric              | Rumus |
|--------------------|-------|
| CPU Usage          | `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` |
| RAM Usage          | `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` |
| Disk Usage         | `(1 - (node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"})) * 100` |
| Frontend Container | `absent(container_last_seen{name="wayshub-frontend"})` |
