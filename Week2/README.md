# TASK 2 - WEEK 2

## [Docker]

1. Create a new user with your team name.
    - add new user: `$ sudo adduser kelompok-1`
    - Add to the sudo group (so you have admin access): `$ sudo usermod -aG sudo kelompok-1`
    - To use Docker without sudo: `$ sudo usermod -aG docker kelompok-1`
    - Enable group changes without needing to log out/re-login `$ newgrp docker`
    - login to user: `$ sudo su - kelompok-1`
2. membuat bash script untuk melakukan installasi docker.
    - create file `$ nano docker-install.sh` and copy this file → [script install docker](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-install.sh)
    - add permission: `$ chmod +x docker-install.sh`
    - run file docker-install.sh: `$ sudo ./docker-install.sh`
    
- Deploy aplikasi Web Server, Frontend, Backend, serta Database on top docker compose (**STAGING**)

    **FOLDER STRUCTURE**
    ```
    dumbways-app/
    │
    ├── docker-compose.yml
    │
    ├── mysql (mysql volume)/
    │   └── (mysql configuration)
    │
    ├── wayshub-backend/
    │   ├── Dockerfile
    │   └── (source code backend)
    │
    ├── wayshub-frontend/
    │   ├── Dockerfile
    │   └── (source code frontend)
    │
    └── nginx (nginx volume)/
        └── (nginx configuration)
    ```

1. Creat file: `nano docker.compos.yml` and copy this file → [docker-compose.yml](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-compose.yml)
2. Make sure database and migration on docker-compose.yml are successful
3. Create Dockerfiles in the wayshub-backend and wayshub-frontend folders
   - Dockerfile backend
     ```
     FROM node:12-alpine
     WORKDIR /home/app
     COPY . .
     RUN npm install
     EXPOSE 5000
     CMD ["npm", "start"]
     ```
   - Dockerfile frontend
     ```
     FROM node:12-alpine as build
     WORKDIR /home/app
     COPY . .
     RUN npm install
     EXPOSE 3000
     CMD ["npm", "start"]
     ```
4. Set config to connect frontend to backend, and the backend to database
   - Config backend on folder `wayshub-backend/config/config.json`
     - _make sure the db is the same_   
       ![gambar](/Week2/Image/backend-config-staging.png)

     - config frontend on folder `wayshub-frontend/src/config/api.js`
       ![gambar](/Week2/Image/frontend-config-staging.png)
       
5. Create nginx configuration
   - Create folder nginx/
   - Create file default.conf
   - Add program    
   ![gambar](/Week2/Image/nginx-config-staging.png)
6. Build file docker-compose.yml: `$ docker compose up -d`
7. try the application on the web using DNS


- Deploy aplikasi Web Server, Frontend, Backend, serta Database on top docker compose (**PRODUCTION**)

1. create SERVER for deploy database     
   ![gambar](/Week2/Image/ServerCICD.png)  

   1. install docker with file `docker-install.sh` [script install docker](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-install.sh)
      - add permission: `$ chmod +x docker-install.sh`
      - run file docker-install.sh: `$ sudo ./docker-install.sh`
      - create user kelompok1 and allow docker without sudo
    2. Add new user: `$ sudo adduser kelompok-1`
       - Add to the sudo group (so you have admin access): `$ sudo usermod -aG sudo kelompok-1`
       - To use Docker without sudo: `$ sudo usermod -aG docker kelompok-1`
       - login to user: `$ sudo su - kelompok-1`
    3. create folder `$ mkdir wayshub`
    4. create file on wayhshub `$ nano docker-compose.yml`

```
services:
  db:
    image: mysql:5.7
    container_name: db-production
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: kelompk@1
      MYSQL_DATABASE: wayshub
      MYSQL_USER: k1
      MYSQL_PASSWORD: k1
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - team1-network

volumes:
  db_data:

networks:
  team1-network:
    driver: bridge
```
   - allow ufw on port 3306 and 22
   - run docker compose `docker compose up -d`


2. create SERVER for deploy wayshub-backend, wayshub-frontend and nginx     
   ![gambar](/Week2/Image/ServerApp.png)   

   1. install docker with file `docker-install.sh` [script install docker](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-install.sh)
      - add permission: `$ chmod +x docker-install.sh`
      - run file docker-install.sh: `$ sudo ./docker-install.sh`
      - create user kelompok1 and allow docker without sudo
    2. Add new user: `$ sudo adduser kelompok-1`
       - Add to the sudo group (so you have admin access): `$ sudo usermod -aG sudo kelompok-1`
       - To use Docker without sudo: `$ sudo usermod -aG docker kelompok-1`
       - login to user: `$ sudo su - kelompok-1`
    3. Make a new directory `mkdir wayshub` for the app, then clone the wayshub-backend and the wayshub-frontend`
    4. Create Dockerfiles in the wayshub-backend and wayshub-frontend folders
       - Dockerfile backend
       ```
       FROM node:12-alpine
       WORKDIR /home/app
       COPY . .
       RUN npm install
       EXPOSE 5000
       CMD ["npm", "start"]
       ```
       - Dockerfile frontend
       ```
        FROM node:12-alpine as build
        WORKDIR /home/app
        COPY . .
        RUN npm install
        EXPOSE 3000
        CMD ["npm", "start"]
       ```
    5. Set config to connect frontend to backend, and the backend to database
       - Config backend on folder `wayshub-backend/config/config.json`
         - _make sure the db is the same and host fill with IP server deploy database_
         ![gambar](/Week2/Image/backend-config.png)

       - config frontend on folder `wayshub-frontend/src/config/api.js`
       ![gambar](/Week2/Image/frontend-config.png)
   
    6. Make .conf file for the web server /nginx     
       ![gambar](/Week2/Image/nginx-config.png)

    7. create file on wayhshub `$ nano docker-compose.yml` and copy this file → [docker-compose.yml](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-compose.yml)
        - *`make sure to delete the db service and volumes db`*
        - *`you can rename staging to production`*
    8. Run docker compose `$ docker compose up -d`
    9. The app can be accessed with a domain with all its functions
       - frontend     
         ![gambar](/Week2/Image/test-frontend.png)
       - backend     
         ![gambar](/Week2/Image/test-backend.png) 
    11. Try to register and login     
        ![gambar](/Week2/Image/login.png)

## [Jenkins]

- **Install Jenkins on top Docker with docker-compose.yaml**
  1. Create folder `wayshub-app`: `$ mkdir wayshub-app`
  2. Go to folder `$ cd wayshub-app` and create file `$ nano docker-compose.yml`
```
nano docker-compose.yaml

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: always
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - ./jenkins_home:/var/jenkins_home
```
  3. Run docker `$ docker compose up -d`        
  4. Get admin password `$ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword` copy password    
  5. Open `http:ipserver:8080` and paste password admin        
  ![gambar](/Week2/Jenkins_Image/unlock-jenkins.png)     
  6. Select *plugins to install*       
  ![gambar](/Week2/Jenkins_Image/costumize-jenkins.png)     
  7. Choose plugins you want install, Make sure SSH Agent is selected and proceed by clicking install      
  ![gambar](/Week2/Jenkins_Image/plugin-jenkins.png)        
  ![gambar](/Week2/Jenkins_Image/install-plugin-jenkins.png)         
  9. Create user
  ![gambar](/Week2/Jenkins_Image/createuser-jenkins.png)
  10. For the setup URL, I'll just leave it at the IP address and setup the reverse proxy later.
  ![gambar](/Week2/Jenkins_Image/intance-conf-jenkins.png)
  11. Start using jenkins     
  ![gambar](/Week2/Jenkins_Image/start-jenkins.png)

- **Setup SSH-KEY on your local Jenkins server, so you can log in to the server using SSH-KEY**

1. Create ssh-key on jenkins server generet to server 1: 
  ```
  docker exec - wayshub-jenkins bash
  ssh-keygen -t rsa -b 4096 -C "jenkins"
  
  # COPY id_rsa.pub to server app
  ssh-copy-id -i ~/.ssh/id_rsa.pub kelompok-1@103.55.37.38
  exit
  ```
  2. Generet id_rsa private to jenkins
     - Open `http:ipserver:8080`
     - Manage -> credential -> system -> globall -> add -> Add SSH Username with private key    
       ![gambar](/Week2/Jenkins_Image/privatessh-jenkins.png)


- **Setup reverse proxy**
 1. Copy docker compose [Script docker compose server 2](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/Jenkins_Image/docker-compose.yml)
 
 2. Config nginx/default.conf     
![gambar](/Week2/Jenkins_Image/config-nginx.png)

 3. Run `docker compose up -d --build`
 4. try opening jenkins with dns      
 ![gambar](/Week2/Jenkins_Image/Interface-jenkins.png)

 
- **Create job jenkins wayshub-frontend and wayshub-backend, Pull from repository, Push to Docker Hub, Auto trigger every time there is a change in SCM, and Create a job notification to Discord**

1. on the server 2(jenkins server) 
    - `cd wayshub-app/wayshub-fronend/` create `nano Jenkinsfile` Copy this script [Script Jenkinsfile](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/Jenkins_Image/Jenkinsfile-frontend)
    - `cd wayshub-app/wayshub-backend/` create `nano Jenkinsfile` Copy this script [Script Jenkinsfile](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/Jenkins_Image/Jenkinsfile-backend)
2. Push to github   
    - Make sure server 1 connect to github, you can connect with SSH pub   
```
# Folder wayshub-frontend/
git remote add origin git@github.com:kelompok1-dumbways/wayshub-frontend
git add .
git commit -m "first commit"
git branch -M main
git push -u origin main

# Folder wayshub-backend
git remote add origin git@github.com:kelompok1-dumbways/wayshub-backend
git add .
git commit -m "first commit"
git branch -M main
git push -u origin main
```

3. on the web jenkins install additional plugins
    - Go to web `http://jenkins.kelompok1.studentdumbways.my.id/` and login
    - manage -> plugins -> available plugins -> search additional plugins
    ![gambar](/Week2/Jenkins_Image/install-plugin-tambahan.png)

4. Add Credentials
    - Manage -> credential -> system -> globall -> add credential ->
    - github, dockerhub, discord
    ![gambar](/Week2/Jenkins_Image/credential.png)

5. Create New job
    - New Item -> Enter name "wayshub-backend" -> Select pipeline -> make sure trigger select *GitHub hook trigger for GITScm polling* -> Repository fill with github wayshub-backend -> save   
   ![gambar](/Week2/Jenkins_Image/creatjob.png)
   ![gambar](/Week2/Jenkins_Image/trigger-autoscm.png)    
   ![gambar](/Week2/Jenkins_Image/config-pipeline-frontend.png)     
    - New Item -> Enter name "wayshub-frontend" -> Select pipeline -> make sure trigger select *GitHub hook trigger for GITScm polling* -> Repository fill with github wayshub-frontend-> save   

6. You can build now
![gambar](/Week2/Jenkins_Image/build-pipeline-frontend.png)      
![gambar](/Week2/Jenkins_Image/build-pipeline-backend.png)       
![gambar](/Week2/Jenkins_Image/Hasilbuild-backend-frontend.png)

7. Auto triger SCM
    - Go to github -> repo wayshub-frontend -> settings -> Webhook -> Add webhook -> Enter the password github ->     
    ![gambar](/Week2/Jenkins_Image/autotriger-github.png)     
    ![gambar](/Week2/Jenkins_Image/hasilwebhook-frontend.png)
    - do the same for the backend         
    ![gambar](/Week2/Jenkins_Image/hasilwebhook-backend.png)
    
8. Check Dockerhub     
![gambar](/Week2/Jenkins_Image/push-dockerhub.png)

9. Notification discord
    - Login discord -> Add server -> Create my own -> For me and my friend -> Enter the name Server and Create     
    - Right click in the #general -> Edut Channel -> integrations -> Webhooks -> New Webhook -> Give it a name and Copy URL
    ![gambar](/Week2/Jenkins_Image/config-discord.png)
    - **This URL is stored in discord credentials**       
![gambar](/Week2/Jenkins_Image/notification-discord.png)

10. keep building until you get a table
![gambar]


## [Github Action]

1. Setup Actions secret and variable Github Action
    - Open Github repository wayshub-frontend -> settings -> Secrets and variables -> actions -> new repository secret   
    Add:     
    ![gambar](/Week2/Jenkins_Image/step-action-secrets-variable.png)

    `DOCKERHUB_USERNAME` = ramdhanifauzi 
        - Name: DOCKERHUB_USERNAME
        - Secret: ramdhanifauzi
        - Add secret
    `DOCKERHUB_TOKEN` = token Docker Hub
        - Name: DOCKERHUB_TOKEN
        - Secret: paste token Docker Hub 
        - Add secret
    `SSH_PRIVATE_KEY` = private key server 2
        - Name: SSH_PRIVATE_KEY
        - Secret: paste private key server 2
        - Add secret
    `DISCORD_WEBHOOK` = URL webhook Discord
        - Name: DISCORD_WEBHOOK
        - Secret: paste URL webhook Discord 
        - Add secret       
    ![gambar](/Week2/Jenkins_Image/action-secrets-variable.png)
    
2. Create folder and file on the server 2
    ```bash
    cd ~/wayshub-app/wayshub-frontend
    mkdir -p .github/workflows
    nano .github/workflows/ci.yml
    ```
    [Script .github/workflows/ci.yml]()
3. Push to github
    ``` bash
    git add .github/workflows/ci.yml
    git commit -m "add github actions workflow"
    git push origin production
    ```
4. Creat pipline github actions runner
    - GitHub repository wayshub-frontend -> settings -> Actions -> runners -> New self-hosted runner -> Select Lunux        
      ![gambar](/Week2/Jenkins_Image/step-runners.png)    
      ![gambar](/Week2/Jenkins_Image/hasil-runners.png)
    - Open server 2 and run this command    
    ``` bash
    # Create a folder
    mkdir actions-runner && cd actions-runner

    # Download
    curl -o actions-runner-linux-x64-2.333.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-linux-x64-2.333.1.tar.gz

    # Extract
    tar xzf ./actions-runner-linux-x64-2.333.1.tar.gz

    # Configure
    ./config.sh --url https://github.com/kelompok1-dumbways/wayshub-frontend --token CBVZQVVBQI74HFRLOHRDAPDJ3TV2K

    # Run
    ./run.sh
    ```
5. Open `https://github.com/kelompok1-dumbways/wayshub-frontend/actions` for the progress pipeline
![gambar](/Week2/Jenkins_Image/hasil-githubaction.png)     
  
6. Notification discord
    - Setting discord    
    ![gambar](/Week2/Jenkins_Image/setting-discord-githubaction.png)
    - Notification    
    ![gambar](/Week2/Jenkins_Image/notification-discord-githubaction.png)
  
