# TASK 2 - WEEK 2

## [Docker]

1. Create a new user with your team name.
    - add new user: `$ sudo adduser kelompok-1`
    - Add to the sudo group (so you have admin access): `$ sudo usermod -aG sudo kelompok-1`
    - To use Docker without sudo: `$ sudo usermod -aG docker kelompok-1`
    - login to user: `$ sudo su - kelompok-1`
2. membuat bash script untuk melakukan installasi docker.
    - create file `$ nano docker-install.sh` and copy this file → [script install docker](https://github.com/ramdhanifauzi21/devops21-dumbways-muhammadramdhanifauzi/blob/main/Week2/docker-install.sh)
    - add permission: `$ chmod +x docker-install.sh`
    - run file docker-install.sh: `$ sudo ./docker-install.sh`
    
- Deploy aplikasi Web Server, Frontend, Backend, serta Database on top docker compose (**STAGING**)

    *FOLDER STRUCTURE*
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
2. Make sure database and migration on docker-compose.yml is valid
3. Create Dockerfile in folder `wayshub-backend`
   - Configuration in `wayshub-backend/config/config.json` and adjust it to the database
4. Create Dockerfile in folder `wayshub-frontend` configuration in config/config.json and change 'http://' to `http://api.kumpul1.staging.studentdumbways.my.id/api/v1`
   - Configuration file `wayshub-frontend/src/config/api.js` and adjust
5. Create nginx configuration
   - Create folder nginx/
   - Create file default.conf
   - Add program 
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
        database:
            image: mysql
            container_name: db_production
            restart: always
            MYSQL_ROOT_PASSWORD: Kelompk@1
            MYSQL_USER: k1
            MYSQL_PASSWORD: k1
            MYSQL_DATABASE: wayshub
            ports:
                - "3306:3306"
            volumes:
                - ./db_data:/var/lib/mysql
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
    4. Make Dockerfile for both the wayshub-backend and the wayshub-frontend
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
    12. Run docker compose `$ docker compose up -d`
    13. The app can be accessed with a domain with all its functions
       ![gambar](/Week2/Image/test-frontend.png)
       ![gambar](/Week2/Image/test-backend.png) 
    15. Try to register and login
        ![gambar](/Week2/Image/login.png)

## [Jenkins]

1. Install jenkins on top docker with `docker-compose.yml`
2. 
