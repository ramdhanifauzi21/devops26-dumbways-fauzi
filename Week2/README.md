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
3. Deploy aplikasi Web Server, Frontend, Backend, serta Database on top docker compose (**STAGING**)

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
    4. Creat file: `nano docker.compos.yml` and copy this file
    5. Make sure database and migration on docker-compose.yml is valid
    6. Create Dockerfile in folder `wayshub-backend`
       - Configuration in `wayshub-backend/config/config.json` and adjust it to the database
    7. Create Dockerfile in folder `wayshub-frontend` configuration in config/config.json and change 'http://' to `http://api.kumpul1.staging.studentdumbways.my.id/api/v1`
       - Configuration file `wayshub-frontend/src/config/api.js` and adjust 
    8. Create nginx configuration
       - Create folder nginx/
       - Create file default.conf
       - Add program 
    9. Build file docker-compose.yml: `$ docker compose up -d`
    10. try the application on the web using DNS
