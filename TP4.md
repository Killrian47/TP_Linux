# TP 4 : Une distribution orientée serveur

## II. Checklist

### Contenu du fichier de conf

```
[root@localhost network-scripts]# cat ifcfg-enp0s8
NAME=enp0s8
DEVICE=enp0s8
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.56.100
NETMASK=255.255.255.0
```

### Résultat ip a 

```
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:85:ac:9f brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 77692sec preferred_lft 77692sec
    inet6 fe80::a00:27ff:fe85:ac9f/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:1b:c3:a8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.100/24 brd 192.168.56.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe1b:c3a8/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

### Connexion ssh fonctionnelle 

```
[root@localhost ~]# sudo systemctl status sshd
[sudo] password for toto:
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2021-11-24 10:27:35 CET; 2h 25min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 866 (sshd)
    Tasks: 1 (limit: 4943)
   Memory: 4.7M
   CGroup: /system.slice/sshd.service
           └─866 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc>
```
```
C:\Users\33695\.ssh>type id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFmbczEnKztz92NJhroWegIRYsyIxmBaejufJz5xMR/88shsi9zCUm0A5PKx4ZSqqHR97dnswlaKi0qUhjTtiOgQksBMs+miXRcnxE2sr0wVCIZ0Jjb6nNnUKZW1j6N929XCyhvgRX5xEy3n9q3abXhnyiDefEbcpV0MM3C1hYmk4hKTTCaTgDQQZX8n5HX2ESK5JPsvPy1VchareY5oPKp3MmDDtTJrlSHfpS4CGkAD2CZfogDDUTe6kef2etQH5QLG4a+9B8XGfMgGqkFLHp+Qnl76ar8dC1rAm8sMQpkQ3xTLHz41MX1LtPTLWHkjqDjNPRNdaXCwgQEK51WeneFptAUrHdFXQf7m+w+GvZhGXUkGmg2AACBYoV72fcpva+YHMBX7MTEubWCS4eHc7rSQxlX9Iai+lFU2BDG45GNlpGHlncUpCMmXZEeWHMolLxILGkmdfyBih8TfkoyfeA6XYkoiz2bQvi9hDjJ7nvWeIAVFXpS1B92M3GUwd7u6U= 33695@LAPTOP-GI2OCL15


```

### Accès internet 

```
[root@localhost ~]# ping google.com
64 bytes from lhr25s01-in-f14.1e100.net (216.58.213.78): icmp_seq=1 ttl=113 time=17.0 ms
64 bytes from lhr25s01-in-f14.1e100.net (216.58.213.78): icmp_seq=1 ttl=113 time=15.5 ms
64 bytes from lhr25s01-in-f14.1e100.net (216.58.213.78): icmp_seq=1 ttl=113 time=17.9 ms
```
Ou :
```
[root@localhost ~]# ping 1.1.1.1
64 bytes from 1.1.1.1: icmp_seq=1 ttl=56 time=14.1ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=56 time=13.5ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=56 time=15.4ms
64 bytes from 1.1.1.1: icmp_seq=4 ttl=56 time=14.5ms
```

### Nommage de la machine 

```
[root@node1 ~]# cat /etc/hostname
node1.tp4.linux
```
Ou 
```
[root@node1 ~]# hostname 
node1.tp4.linux
```


## Mettre en place un service 

Pour installer le service nginx on fait les commandes suivantes : 

```sudo dnf install nginx``` ou `dnf install nginx` si on est déjà en root, puis on lance le service `sudo systemctl start nginx` et enfin on vérifie qu'il est bien lancé avec `systemctl status nginx`. 

```
[killian@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-11-24 20:49:46 CET; 2min 31s ago
  Process: 882 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 870 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 864 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 887 (nginx)
    Tasks: 2 (limit: 4956)
   Memory: 12.4M
   CGroup: /system.slice/nginx.service
           ├─887 nginx: master process /usr/sbin/nginx
           └─888 nginx: worker process
```

### Analyser le service nginx 

Avec `ps -ef | grep nginx` on peut voir que le processus nginx tourne sur l'utilisateur **user nginx**.
```
nginx        888  0.0  0.9 151820  7980 ?        S    20:49   0:00 nginx: worker process
```

Avec `ss -ltanp` ou `sudo ss -ltanp` si non root nous pouvons voir que le service nginx tourne sur le port **80**.

Pour regarder le fichier de conf du service nginx on fait `nano /etc/nginx/nginx.conf` ou avec sudo si utilisateur non root. 
Dans ce fichier on peut voir que la racine web se trouve dans `/usr/share/nginx`. 

## Visite du service web 

### Configurez le firewall pour autoriser le trafic vers le service NGINX

```
[root@node1 ~]# sudo firewall-cmd --add-port=80/tcp --permanent
success
[root@node1 ~]# sudo firewall-cmd --reload
success
```


## Modifier la conf du serveur web 

Port d'écoute : 
```
[root@node1 ~]# cat /etc/nginx/nginx.conf | grep listen
        listen       8080 default_server;
        listen       [::]:8080 default_server;
[root@node1 ~]# sudo systemctl restart nginx        
[root@node1 ~]# sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2021-11-23 12:41:35 CET; 5s ago
  Process: 5545 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 5543 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 5541 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 5547 (nginx)
    Tasks: 2 (limit: 11397)
   Memory: 3.7M
   CGroup: /system.slice/nginx.service
           ├─5547 nginx: master process /usr/sbin/nginx
           └─5548 nginx: worker process


[root@node1 ~]# sudo ss -laptn |grep nginx
LISTEN 0      128           0.0.0.0:8080      0.0.0.0:*     users:(("nginx",pid=889,fd=8),("nginx",pid=888,fd=8))
LISTEN 0      128              [::]:8080         [::]:*     users:(("nginx",pid=889,fd=9),("nginx",pid=888,fd=9))
```

```
[root@node1 ~]# curl http://192.168.56.100:8080/
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
```


### Changer l'utilisateur qui lance le service

On décide de créer un nouvel utilisateur que l'on nomme " web " avec :
``[root@node1 ~]# sudo useradd web -m -s /bin/bash -u 2000``

Puis on change le mot de passe : 
``sudo passwd web``

```
[root@node1 ~]# cat /etc/passwd | grep web
web:x:2000:2000::/home/web:/bin/bash
```

On change le fichier `nginx.conf` avec `nano /etc/nginx/nginx.conf`

Voilà le changement : 
```
[root@node1 ~]# cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user web;
```

```
[root@node1 ~]# sudo systemctl restart nginx.service
[root@node1 ~]# ps -ef | grep nginx
web         1563    1562  0 21:32 ?        00:00:00 nginx: worker process
```

### Changer l'emplacement de la racine Web

```
[root@node1 var]# sudo mkdir www
[root@node1 var]# cd www/
[root@node1 www]# sudo mkdir super_site_web
[root@node1 www]# cd super_site_web/
[root@node1 super_site_web]# touch index.html
[root@node1 super_site_web]# ls
index.html
[root@node1 super_site_web]# cd ..
[root@node1 www]# sudo chown -R web:web super_site_web/
[root@node1 www]# ls -la
total 0
drwxr-xr-x. 3 root root  28 Nov 24 21:54 .
dr-xr-x---. 4 root root 158 Nov 24 21:54 ..
drwxr-xr-x. 2 web  web   24 Nov 24 21:58 super_site_web
[root@node1 www]# cd super_site_web
[root@node1 super_site_web]# ls -la 
total 4
drwxr-xr-x. 2 web  web   24 Nov 23 13:13 .
drwxr-xr-x. 3 root root  28 Nov 23 13:11 ..
-rw-r--r--. 1 web  web  101 Nov 23 13:13 index.html
```

```
[root@node1 ]#cat /etc/nginx/nginx.conf | grep root
        root         /var/www/super_site_web;
```

````
[root@node1 www]# systemctl restart nginx.service
[root@node1 www]# curl http://192.168.56.100:8080
<!DOCTYPE html>
<html>
<head>
<title>Un usper site web</title>
</head>
<body>

<h1>Ceci est un titre</h1>

<p>Ceci est un paragraphe</p>


</body>
</html>
````