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
[...]
inet 192.168.56.100/24 brd 192.168.56.255 scope global noprefixroute enp0s8
[...]
```

### Connexion ssh fonctionnelle 

```
[root@localhost ~]# systemctl status sshd 
[...]
Active: active (running) 
[...]
```

Pour se connecter sur notre VM a notre pc on fait : `ssh `*`user@ipVM`*

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

### Analyser le service nginx 

Avec `ps -ef | grep nginx` on peut voir que le processus nginx tourne sur l'utilisateur **root**.

Avec `ss -ltanp` ou `sudo ss -ltanp` si non root nous pouvons voir que le service nginx tourne sur le port **80**.

Pour regarder le fichier de conf du service nginx on fait `nano /etc/nginx/nginx.conf` ou avec sudo si utilisateur non root. 
Dans ce fichier on peut voir que la racine web se trouve dans `/usr/share/nginx`. 


