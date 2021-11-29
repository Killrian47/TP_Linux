# TP 5 Petit cloud perso 

## I. Setup DB

### 1. Installation de MariaDB

Pour installer MariaDB, on fait `sudo dnf install mariadb`

On lance le service avec : 
```
[killian@db ~]$ sudo systemctl start mariadb
[killian@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.

[killian@db ~]$ systemctl status mariadb.service
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 11:51:14 CET; 6s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 8903 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 8768 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
  Process: 8744 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 8871 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 4956)
   Memory: 80.9M
   CGroup: /system.slice/mariadb.service
           └─8871 /usr/libexec/mysqld --basedir=/usr
```

Pour voir le port d'écoute on fait : 
```
[killian@db ~]$ sudo ss -latnp |grep mysql
LISTEN 0      80                 *:3306            *:*     users:(("mysqld",pid=8871,fd=21))
```

On regarde qui a lancé le processus avec : 
```
[killian@db ~]$ ps -ef | grep mysql
mysql       8871       1  0 11:51 ?        00:00:00 /usr/libexec/mysqld --basedir=/usr
```

Configuration du firewall : 
```
[toto@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[toto@db ~]$ sudo firewall-cmd --reload
success
```

### 2. Conf de MariaDB

On fait la commande ``mysql_secure_installation``

Questions : 
```
Enter current password for root (enter for none):
OK, successfully used password, moving on...
```
Il n'y a pas de mot de passe sur root alors on fait entrer. 

```
Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!
```
On met un mot de passe à root pour ne pas avoir de problème de sécurité. 

```
By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!
```
On enlève les utilisateurs anonymes. 

```
Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!
```


```
By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
```
On enlève la database car on décide d'en créer une nouvelle.

```
Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
```
*Y*pour que nos changements s'appliquent. 

```
[killian@db ~]$ sudo mysql -u root -p
[sudo] password for killian :
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 18
Server version: 10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.5.1.11';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)
```

### 3. Test

```
[killian@web ~]$sudo dnf provides mysql
Last metadata expiration check: 0:16:35 ago on Thu 25 Nov 2021 11:44:40 AM CET.
mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
Repo        : appstream
Matched from:
Provide    : mysql = 8.0.26-1.module+el8.4.0+652+6de068a7
[killian@web ~]$ sudo dnf install mysql
```

```
[killian@web ~]$ mysql -h 10.5.1.12 -P 3306 -u 'nextcloud' -p nextcloud
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 5.5.5-10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW TABLES;
Empty set (0.00 sec)
```

## 2. Setup web 

### 1. Install Apache

On installe Apache sur notre VM web : 
```
sudo dnf install httpd 
sudo systemctl start httpd
sudo systemctl enable httpd
```

Le port d'écoute : 
```
[killian@web ~]$ sudo ss -lanpt | grep httpd
LISTEN 0      128                *:80              *:*     users:(("httpd",pid=3671,fd=4),("httpd",pid=3591,fd=4),("httpd",pid=3357,fd=4),("httpd",pid=3355,fd=4),("httpd",pid=3352,fd=4))
```

Firewall : 
``sudo firewall-cmd --add-port=80/tcp --permanent`` ainsi que ``sudo firewall-cmd --reload``

On teste avec la commande curl : ``curl http://10.5.1.11``

### 2. Configuration Apache

```
[killian@web ~]$ cat mon_site.conf 
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/html/  # on précise ici le dossier qui contiendra le site : la racine Web
  ServerName  web.tp5.linux  # ici le nom qui sera utilisé pour accéder à l'application

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```
#### Changer la racine web 

```
[killian@web ~]$ sudo mkdir -p /var/www/nextcloud/html/
[killian@web ~]$ sudo chown -R apache:apache /var/www
```

#### Conf Php

```
[killian@web ~]$ cat /etc/opt/remi/php74/php.ini | grep date
;date.timezone = "Europe/Paris"
```

## 3. Installer Nextcloud

```
[killian@web ~]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  148M  100  148M    0     0  12.0M      0  0:00:12  0:00:12 --:--:-- 13.3M
[tomfox@web ~]$ ls
nextcloud-21.0.1.zip
[tomfox@web ~]$ file nextcloud-21.0.1.zip 
nextcloud-21.0.1.zip: Zip archive data, at least v1.0 to extract
```

#### Ranger la chambre 

```
[killian@web ~]$ unzip nextcloud-21.0.1.zip
[killian@web ~]$ mv nextcloud /var/www/nextcloud/html/
[killian@web ~]$ sudo chown -R apache:apache /var/www/nextcloud
[sudo] password for killian:
[killian@web ~]$ sudo systemctl restart httpd
[killian@web ~]$ rm nextcloud-21.0.1.zip
```

On édit notre fichier hosts de notre PC : 
```
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
	10.5.1.11	web.tp5.linux
```

On teste cela sur notre pc et cela fonctionne ! 
