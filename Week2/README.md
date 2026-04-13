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

- Install Jenkins on top Docker with docker-compose.yaml
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
  ![gambar](/Week2/Jenkins_Image/start-jenkins.pn)

- Setup SSH-KEY on your local Jenkins server, so you can log in to the server using SSH-KEY
  1. Create ssh-key on jenkins server: 
  ```
  docker exec - wayshub-jenkins bash
  ssh-keygen -t rsa -b 4096 -C "jenkins"
  
  # COPY rsa.pub to server app
  ssh-copy-id -i ~/.ssh/id_rsa.pub kelompok-1@103.55.37.38
  exit
  ```

- Setup Reverse Proxy Jenkins
  1. Add program in `docker-compose.yml`
  
  2. Config nginx/default.conf
  
  3. Run `docker compose up -d`
  4. try opening jenkins with dns
 
- Create job jenkins wayshub-frontend and wayshub-backend, Pull from repository, Push to Docker Hub, Auto trigger every time there is a change in SCM, and Create a job notification to Discord
  1. 

  
