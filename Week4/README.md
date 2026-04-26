# Answer Task Week 4

## [Kubernetes]
#### Setup

- create 2 VM
    - VM-1 for Master (fauzi-app)
    - VM-2 for Worker(fauzi-gateway)
---

### Folder Structure on the Master Server
```
~/kubernetes/
├── app/
│   ├── frontend.yaml           # Frontend Deployment and Service configuration
│   └── backend.yaml            # Backend API Deployment and Service configuration
├── db/
│   ├── mysql-secret.yaml       # MySQL credentials stored as Secret
│   ├── mysql-pvc.yaml          # Persistent Volume Claim for MySQL storage
│   ├── mysql-statefulset.yaml  # MySQL StatefulSet deployment
│   └── backend-config.yaml     # Backend environment variables / database connection config
├── ingress/
│   └── app-ingress.yaml        # Ingress routing for frontend and backend domains
└── cert/
    ├── cluster-issuer.yaml     # cert-manager ClusterIssuer for Let's Encrypt
    └── wildcard-cert.yaml      # Wildcard SSL certificate configuration
```
--------------------------------------------------

### Architecture Summary

| Component | Namespace | URL / Access |
|-----------|-----------|--------------|
| Frontend | production | https://fauzi.kubernetes.studentdumbways.my.id |
| Backend API | production | https://api.fauzi.kubernetes.studentdumbways.my.id |
| MySQL | production | `mysql-svc:3306` (internal) |
| Ingress Nginx | ingress-nginx | `WORKER_IP:80/443` |
| cert-manager | cert-manager | Auto-renewal of wildcard SSL certificates |

------------------------------------------------------------------------------
#### Server Preparation

Before starting, prepare the folder structure on the master server:

```bash
mkdir -p ~/kubernetes/app
mkdir -p ~/kubernetes/db
mkdir -p ~/kubernetes/ingress
mkdir -p ~/kubernetes/cert
```
---
#### Creating a Kubernetes Cluster (K3s) consisting of 2 nodes: one master `(fauzi-app)` and one worker `(fauzi-gateway)`

- Master (fauzi-app)
```sh
# log in as root
sudo su

# Set hostname
hostnamectl set-hostname master
echo master > /etc/hostname

# Install K3s full or install K3s
curl -sfL https://get.k3s.io | sh -

# Cek status
systemctl status k3s

# Konfigurasi K3s (Disable Traefik & ServiceLB)
  # Edit/create config for disable traefik
  sudo nano /etc/rancher/k3s/config.yaml
  
  #Paste the script
  cluster-init: true
  disable:
    - servicelb
    - traefik

# Configure kubectl Access
  # Make sure to have the /usr/local/bin directory in the path to directly access the installed binary files
    export PATH=/usr/local/bin:$PATH
    k3s kubectl get nodes
    
    kubectl get nodes
    kubectl get pods -A
  
  # Configure kubectl access for the current user
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $USER:$USER ~/.kube/config
    export KUBECONFIG=~/.kube/config

# Restart
systemctl restart k3s 

# log out as root
exit

# Verify on home
$ kubectl get nodes
$ kubectl get pods -A

# get token (MASTER)
$ sudo cat /var/lib/rancher/k3s/server/token
```

- Worker (fauzi-gateway)

```bash
# log in as root
sudo su

# set hostname
hostnamectl set-hostname worker
echo app > /etc/hostname

# Join the master
curl -sfL https://get.k3s.io | \
  K3S_URL=https://MASTER_IP:6443 \
  K3S_TOKEN=NODE_TOKEN_FROM_MASTER \
  sh -

- # Edit/create config for disable traefik
  - nano /etc/rancher/k3s/config.yaml
  
  #Paste the script
  disable:
    - servicelb
    - traefik

# Restart
systemctl restart k3s-agent
```

- Verify on the master server
```
kubectl get nodes
```
---

#### Install Ingress Nginx (With helm)

- Install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
```

- Install Ingress Nginx
```sh
# Add the Ingress Nginx Helm repository and update it
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Create namespace for Ingress Nginx
kubectl create namespace ingress-nginx

# Replace MASTER_IP or WORKER_IP with the node IP where Ingress will run
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalIPs[0]=WORKER_IP

# Verification
  # Check running pods in the ingress-nginx namespace
    kubectl get pods -n ingress-nginx

  # Check services in the ingress-nginx namespace
    kubectl get svc -n ingress-nginx

  # Check which node the Ingress controller is running on
    kubectl get pods -n ingress-nginx -o wide
```
---

#### Setup Persistent Volume for Database
- Check default k3s storageclass: `kubectl get storageclass`
- Create namespace: `kubectl create namespace production`
- Create file `~/kubernetes/db/mysql-pvc.yaml` and copy this program [mysql-pvc.yaml]()
- Apply configuration and verify PVC
  ```bash
  kubectl apply -f ~/kubernetes/db/mysql-pvc.yaml
  kubectl get pvc -n production
  ```
---
#### Deploy MySQL with StatefulSet & Secrets

##### Create Kubernetes Secret
- Generate base64 values
  ```
  echo -n 'your_pw' | base64               # Password
  echo -n 'your_username' | base64         # Username
  echo -n 'your_databasename' | base64     # Database
  ```
- Create file: `~/kubernetes/db/mysql-secret.yaml` and copy this program[mysql-secret.yaml]()
- Apply configuration and verify secret
  ```
  kubectl apply -f ~/kubernetes/db/mysql-secret.yaml
  kubectl get secret -n production
  ```

##### Create Mysql statefulset
- Create file `~/kubernetes/db/mysql-statefulset.yaml` and copy this program[mysql-statefulset.yaml]()
- Apply configuration and verify
  ```
  kubectl apply -f ~/kubernetes/db/mysql-statefulset.yaml
  kubectl get pods -n production
  kubectl get pvc -n production
  ```
- Grant database access
  ```
  # Access the MySQL container
  kubectl exec -it -n production mysql-0 -- bash

  # Login to MySQL
  mysql -u root -pFauzi123!

  #SQL
  GRANT ALL PRIVILEGES ON dumbways.* TO 'dumbways'@'%';
  FLUSH PRIVILEGES;
  EXIT;
  ```
---
#### Config ingress ruless
- Create file `~/kubernetes/ingress/app-ingress.yaml ` and copy this program
- Apply and verify 
  ```
  kubectl apply -f ~/kubernetes/ingress/app-ingress.yaml
  kubectl get ingress -n production
  ```
---
#### Deploy application (Frontend & backend)

##### Deploy frontend
- Create file `~/kubernetes/app/frontend.yaml` and copy this program
##### Deploy backend
- Create file: ~/kubernetes/db/backend-config.yaml and copy this program
- Create file `~/kubernetes/app/backend.yaml` and copy this program

##### Apply configuration and verify pods
```
kubectl apply -f ~/kubernetes/db/backend-config.yaml
kubectl apply -f ~/kubernetes/app/frontend.yaml
kubectl apply -f ~/kubernetes/app/backend.yaml
kubectl get pods -n production
```

##### Run database migration
```
kubectl exec -it -n production deployment/backend -- sh

npx sequelize-cli db:migrate

exit
```
---

#### Create wildcard certificate
- Create file: `~/kubernetes/cert/wildcard-cert.yaml` and copy this program
- Apply configuration and cerify certificate
  ```
  kubectl apply -f ~/kubernetes/cert/cluster-issuer.yaml
  kubectl apply -f ~/kubernetes/cert/wildcard-cert.yaml

  # Monitor certificate status until READY = True
  kubectl get certificate -n production -w
  ```


