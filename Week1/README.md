# ANSWARE TASK1 WEEK1

## MANAGEMENT DATABASE

##### Prerequisite

- Ubuntu Server
- Mysql-server
- Mysql-client
- UFW
- Sequalize

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
    - restart mysql → `sudo systemctl restart mysql`
2. I use WSL for remote database
    - make sure you have installed WSL in the terminal
    - Login WSL with terminal
    - Install
3. 



