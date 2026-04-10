# TASK 2 - WEEK 2

## *[Docker]*

1. membuat user baru dengan nama team kalian
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

1. Creat file: `nano docker.compos.yml` and copy this file
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

1. create SERVER for deploy database gambar
2. install docker
3. create user kelompok2 and allow docker without sudo
4. create folder mkdir wayshub
5. create file on wayhshub sudo nano docker-compose.yaml
```
services:
database:
    image: mysql
    container_name: db_production
    restart: always
    MYSQL_ROOT_PASSWORD: Kelompok@1
    MYSQL_USER: k1
    MYSQL_PASSWORD: k1
    MYSQL_DATABASE: wayshub
    ports:
    - "3306:3306"
    volumes:
    - ./db_data:/var/lib/mysql
```
6. allow ufw on port 3306 and 22
run docker compose up -d
create SERVER for deploy wayshub-backend, wayshub-frontend and nginx gambar
install docker
create user kelompok2 and allow docker without sudo
Make a new directory mkdir wayshub for the app, then clone the wayshub-backend and the wayshub-frontend
Make Dockerfile for both the wayshub-backend and the wayshub-frontend
Set config to connect frontend to backend, and the backend to database.
Build the frontend and the backend
Make .conf file for the web server/nginx
Make docker-compose.yml file, and the .env for the backend 
Run docker compose up 
The app can be accessed with a domain with all its functions
