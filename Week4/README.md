# Answer Task Week 4

## [Kubernetes]
#### Setup

- create 2 VM
    - VM-1 for Master (fauzi-app)
    - VM-2 for Worker(fauzi-gateway)

![gambar](/Week4/Image/setup-server.png)

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
### 1. Creating a Kubernetes Cluster (K3s) consisting of 2 nodes: one master `(fauzi-app)` and one worker `(fauzi-gateway)`

- Master (fauzi-app)
```sh
# login as root
sudo su

# Set hostname
hostnamectl set-hostname master
echo master > /etc/hostname

# Install K3s
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
```
  ![gambar](/Week4/Image/kubectl-access.png)
```sh                
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
![gambar](/Week4/Image/instal-k3s-master.png)            

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
![gambar](/Week4/Image/worker-join.png)                

- Verify nodes on the master server
```
kubectl get nodes
```                
![gambar](/Week4/Image/verify-nodes-master.png)                            

---                 
### 2. Install Ingress Nginx (With helm)

- Install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
```                
![gambar](/Week4/Image/instal-helm.png)  

- Configure Helm to use the k3s cluster
    - navigate to the k3s configuration directory `cd /etc/rancher/k3s`, Make sure the `k3s.yaml` file is exists                   cd         
    ![gambar]()             
    - Export the kubeconfig export KUBECONFIG=/etc/rancher/k3s/k3s.yaml                    
    ![gambar]()
    - Helm ready to use                    
    ![gambar]()

- Remove default traefik from k3s
    - Navigate to the k3s Manifests Directory `cd /var/lib/rancher/k3s/server/manifests`, Make sure the traefik.yaml file is present
    - Remove traefik and traefik CRD fron cluster: `rm -rf traefik.yaml`
    - Uninstall traefik and traefik CRD from the cluster: `helm uninstall traefik traefik-crd -n kube-system`            
    ![gambar]()


- Install Ingress Nginx with helm
    - Add the Ingress Nginx Helm repository and update it
    ```sh
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update

    # Create namespace for Ingress Nginx
    kubectl create namespace ingress-nginx
    ```                    
    ![gambar](/Week4/Image/install-ingress-1.png)
    - Install ingress nginx
    ```sh
    # Replace MASTER_IP or WORKER_IP with the node IP where Ingress will run (I use WORKER_IP)
    helm install ingress-nginx ingress-nginx/ingress-nginx \
      --namespace ingress-nginx \
      --set controller.service.type=LoadBalancer \
      --set controller.service.externalIPs[0]=WORKER_IP
    ```            
    ![gambar](/Week4/Image/install-ingress-2.png)
    
    - Verification ingress nginx
    ```sh
    # Check running pods in the ingress-nginx namespace
    kubectl get pods -n ingress-nginx

    # Check services in the ingress-nginx namespace
    kubectl get svc -n ingress-nginx

    # Check which node the Ingress controller is running on
    kubectl get pods -n ingress-nginx -o wide
    ```
    ![gambar]()

    - run nginx on the web                
    ![gambar](/Week4/Image/test-nginx-1.png)                
    ![gambar](/Week4/Image/test-nginx-2.png)
  
---

### 3. Setup Persistent Volume for Database
- Check default k3s storageclass: `kubectl get storageclass`
- Create namespace: `kubectl create namespace production`            
![gambar](/Week4/Image/create-namespace-production.png)
- Create file `~/kubernetes/db/mysql-pvc.yaml` and copy this program [mysql-pvc.yaml](https://github.com/ramdhanifauzi21/devops26-dumbways-fauzi/blob/main/Week4/lib/mysql-pvc.yaml)
- Apply configuration and verify PVC
  ```bash
  kubectl apply -f ~/kubernetes/db/mysql-pvc.yaml
  kubectl get pvc -n production
  ```
  ![gambar](/Week4/Image/verify-pvc.png)
---
### 4. Deploy MySQL with StatefulSet & Secrets

###### Create Kubernetes Secret
- Generate base64 values
  ```
  echo -n 'your_pw' | base64               # Password
  echo -n 'your_username' | base64         # Username
  echo -n 'your_databasename' | base64     # Database
  ```
- Create file: `~/kubernetes/db/mysql-secret.yaml` 
```sh
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: production
type: Opaque
data:
  mysql-root-password: root_pw   
  mysql-password:      database_pw   
  mysql-database:      ZHVtYndheXM=   # Database name
  mysql-user:          ZHVtYndheXM=   # Username
```
- Apply configuration and verify secret
  ```
  kubectl apply -f ~/kubernetes/db/mysql-secret.yaml
  kubectl get secret -n production
  ```
![gambar](/Week4/Image/verify-secret.png)

##### Create Mysql statefulset
- Create file `~/kubernetes/db/mysql-statefulset.yaml` and copy this program[mysql-statefulset.yaml]([mysql-statefulset.yaml](https://github.com/ramdhanifauzi21/devops26-dumbways-fauzi/blob/main/Week4/lib/mysql-statefulset.yaml))
- Apply configuration and verify
  ```
  kubectl apply -f ~/kubernetes/db/mysql-statefulset.yaml
  kubectl get pods -n production
  kubectl get pvc -n production
  ```
  ![gambar]()

---

### 5. Deploy application (Frontend & backend)

##### Deploy frontend
- Create file `~/kubernetes/app/frontend.yaml` and copy this program            
![gambar]()
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
![gambar]()

---
### 6. Config ingress ruless
- Create file `~/kubernetes/ingress/app-ingress.yaml ` and copy this program
- Apply and verify 
  ```
  kubectl apply -f ~/kubernetes/ingress/app-ingress.yaml
  kubectl get ingress -n production
  ```
![gambar]()
---



