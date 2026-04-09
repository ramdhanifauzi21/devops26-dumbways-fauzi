# ANSWARE TASK1 WEEK1

## MANAGEMENT DATABASE

##### Prerequisite

- Ubuntu Server
- Mysql-server
- Mysql-client
- UFW
- Sequalize
- Aktif port 3306

#### Step to Complite MANAGEMENT DATABASE

1. Login server
    - Open terminal
    - `ssh -i /path_directory/privatekey.pub hostname@iplocalserver`
2. Update package: `$sudo apt update`
3. Install mysql-server: `$sudo apt install mysql-server`
4. Setup secure installation :`$sudo mysql_secure_installation`
5. login mysql: `sudo mysql`
6. add password for root user: `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new-password';`
7. create new user: `CREATE USER 'eep'@'%' IDENTIFIED BY 'the-password';`
8. create new database: `CREATE DATABASE wayshub;`
9. Create privileges for your new user so they can access the database you created: `GRANT ALL PRIVILEGES ON *.* TO 'eep'@'%';`
10. reload: `FLUSH PRIVILEGES;`
11. Login mysql with root: `sudo mysql -u root -p` enter password

```sql
// Create new user and give that user access rights so they can access all the databases that have been created

CREATE USER 'user_name'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user_name'@'%';

// Create new database 'demo' and make some dummy table 'transaction'

CREATE DATABASE demo;
USE demo;

CREATE TABLE transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama DECIMAL(10,2),
    usia VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

// Create a 2 role with the name admin, and guest that will be used to see and manage the 'transaction' table.

CREATE ROLE 'admin';
CREATE ROLE 'guest';

// Give SELECT, INSERT, UPDATE, and DELETE access rights to the transaction table for the admin role you just created. and only give SELECT access to guest.

GRANT SELECT, INSERT, UPDATE, DELETE ON demo.transaction TO 'admin';
GRANT SELECT ON demo.transaction TO 'guest';

// Create a new user with the username your_name and password your_password. Add the user to the admin role.

CREATE USER 'your_name'@'localhost' IDENTIFIED BY 'your_password';
GRANT 'admin' TO 'your_name'@'localhost';
SET DEFAULT ROLE 'admin' TO 'your_name'@'localhost';

// Create a new user with the username guest and password guest. Add the user to the guest role.

CREATE USER 'guest'@'localhost' IDENTIFIED BY 'guest';
GRANT 'guest' TO 'guest'@'localhost';
SET DEFAULT ROLE 'guest' TO 'guest'@'localhost';

````

#### Test all of your user
```sql
// test admin
mysql -u your_name -p
USE demo;

INSERT INTO transaction (nama, usia) VALUES
('DANI', 21),
('FALAK', 25),
('MELKI', 30);

SELECT * FROM transaction;

UPDATE transaction SET usia = 50
WHERE nama = 'DANI';

DELETE FROM transaction
WHERE nama = 'MELKI';

// test guest
mysql -u guest -p
USE demo;

SELECT * FROM transaction;

INSERT INTO transaction (nama, usia) VALUES ('Basko', 43); // must fail (INSER command denied)
UPDATE transaction SET usia = 17 WHERE nama = 'DANI'; // must fail (UPDATE command denied)
DELETE FROM transaction WHERE nama = 'DANI'; // must fail (DELETE command denied)

````

#### Try to remote database from local computer with mysql-client
1. change the MySQL bind address on /etc/mysql/mysql.conf.d/mysqld.cnf
    - edit `bind-address = 127.0.0.1` to `bind-address = 0.0.0.0` on `/etc/mysql/mysql.conf.d/mysqld.cnf`
    - restart mysql: `sudo systemctl restart mysql`
2. I use WSL for remote database
    - make sure you have installed WSL in the terminal
    - Login WSL with terminal
    - Install mysql clinet: `$sudo apt install mysql-client`
3. login using user admin, try entering data
    - login mysql: `mysql -h ipserver -u admin -p`
    - Try entering data, and check the data on the server to see if it is in the database.
4. Open the MySQL port on the server firewall: `sudo ufw allow 3306`

## Deploy app wayshub

### Prerequisite
- Nodejs V10, 12, 14
- PM2
- Aktif port 3306, 5000, 3000, 40
### waysub-backend

1. install NVM and make sure version 10, 12 or 14  [NodeJS 12](https://nodejs.org/en/download)

``` bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 12

# Verify the Node.js version:
node -v # Should print "v12.22.12".

# Verify npm version:
npm -v # Should print "6.14.16".

```

2. Instal pm2: `$npm install -g pm2`
3. Creat new database name wayshub
    - login mysql: mysql -u username -p

      `CREATE DATABASE wayshub;`
4. clone wayshub backend application: `git clone https://github.com/dumbwaysdev/wayshub-backend.git`
5. in folder wayshub-backend instal modules: `$npm install`
6. Set configuration on `wayshub-backend/config/config.js` and then adjust it your database
    - adjust to the database that has been created
    - for the host, you make ip 127.0.0.1 or IP local
      <img width="624" height="182" alt="6" src="https://github.com/user-attachments/assets/ddb96b4a-9d1b-4174-9ac7-3874ed339609" />

7. Install sequalize: `$npm 1 -g sequalize-cli`
8. Migrate db: `$sequalize db:migrate`
9. run with pm2: `$pm2 start index.js`
<img width="624" height="134" alt="9" src="https://github.com/user-attachments/assets/c1d5ba3e-cfa7-41f9-99bd-f1490c41265d" />

### waysub-frontend
1. clone wayshub frontend application → git clone https://github.com/dumbwaysdev/wayshub-frontend
2. in the folder install modules: `$npm install`
3. Set configuration `src/config/api.js`
    - make sure baseURL ip server
      <img width="624" height="353" alt="14" src="https://github.com/user-attachments/assets/00b03825-f334-41d5-b4d2-816992c7ac84" />

4. run to pm2: `$pm2 start npm --name frontend -- start`
<img width="624" height="151" alt="15" src="https://github.com/user-attachments/assets/2af78f01-c156-46f8-b3f2-023d929cab6e" />

### test
1. login backend 'ip:5000'
   - make sure is comment in browser **cannot GET/**
     
     <img width="374" height="138" alt="11" src="https://github.com/user-attachments/assets/dcfe9d04-c614-4363-b7eb-32c1e46bce97" />

2. login frontend `ip:3000`
   - try to register
   - Login
     
     <img width="624" height="573" alt="16" src="https://github.com/user-attachments/assets/ea46b797-dc42-4b34-a37b-b7340dfd1799" />
 
### Setup Gateway server and Nginx
1. install nginx: `$sudo apt install nginx`
2. configurasi dns local 
    - open file host with notepade and run administrator -> open file -> C:/Windows/system32/drivers/etc/hosts
    - add ip server gateway and dns at the bottom
      <img width="608" height="539" alt="19" src="https://github.com/user-attachments/assets/81c359d7-4ebd-40c8-856a-016bdf1d7911" />

3. Go to the folder to create the configuration nginx: `cd /etc/nginx/sites-available`
   - Create a file wayshub.conf
   - make sure ip and dns must be the same
     <img width="624" height="374" alt="20" src="https://github.com/user-attachments/assets/9aebc1cb-e0fb-40cd-8127-d06618499bf9" />

   - apply nginx new conf `$sudo ln -s /etc/nginx/sites-available/wayshub-frontend.conf /etc/nginx/sites-enabled/ and sudo ln -s /etc/nginx/sites-available/wayshub-backend.conf /etc/nginx/sites-enabled/`
   - Check if the configuration is OK or NOT: `$sudo nginx -t`
   - restart nginx: `$sudo systemctl restart nginx`
4. configurasi wayshub-frontend/src/config/api.js
   - Make sure baseURL using dns
     
     <img width="624" height="406" alt="26" src="https://github.com/user-attachments/assets/b12fc7a3-bf13-4206-ba93-748adc06939e" />

5. delete previous pm2 and run again
6. Cek google with dns
<img width="624" height="549" alt="23" src="https://github.com/user-attachments/assets/8b2cc172-c98e-4c35-8478-7610e98a8955" />

7. Try to register and login
<img width="624" height="294" alt="25" src="https://github.com/user-attachments/assets/7795d42d-c204-4545-8311-19a46814d35c" />


