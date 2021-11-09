# TP_Linux

## TP 2 : Manipulation des services

### Prérequis : Nommer la machine 


La commande `` sudo hostname node1.tp2.linux `` changera le nom de notre VM instantanément mais si on redémarre celle-ci, le changement ne sera pas pris en compte. 

Pour qu'il soit pris en compte il faut faire : 
```bash  
 sudo nano /etc/hostname  
```
Puis changer le nom de notre VM et faire un : 
```
cat /etc/hostname
```
Qui renverra : ``node1.tp2.linux``

### Prérequis : Configuration réseau 


Pour vérifier qu'on a une connection à internet voici les commandes qu'on va faire depuis notre VM : 

``ping 1.1.1.1`` et ``ping google.com`` 

- Pour ``ping1.1.1.1`` on aura ceci en retour sur notre terminal, si l'accès internet est fonctionnel : 

```
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=20.0 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=21.7 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=57 time=21.1 ms
```

- Et pour ``ping google.com`` voici ce qu'on aura juste après la commande :

```
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=1 ttl=113 time=25.3 ms
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=2 ttl=113 time=21.4 ms 
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=3 ttl=113 time=26.7 ms  
```

Et depuis notre PC : 

``ping <ipVM>``

- On aura comme retour sur notre terminal ceci : 

```
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
```

### Partie 1 : SSH

#### 1 : Installation du serveur 

Pour installer un serveur SSH il faut faire la commande suivante : 

```
sudo apt install openssh-server
```
Si celui-ci est déjà installé voici le résultat que l'on obtient : 
```
Reading package lists... Done 
[...]
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```
Si celui-ci n'est pas installé, cela l'installe. 

#### 2 : Lancement du service SSH

Pour lancer un service SSH il faut faire la commande suivante : 

``systemctl start ssh`` 

Et pour vérifier que celui-ci est bien fonctionnel on fait : 

``systemctl status ssh``

Qui nous renverra : 

`[...] Active: `**`active (running)`**` since [...]`

#### 3 : Etude du service SSH 

Pour afficher le statu du service on fait la commande ``systemctl status``. 

On aperçoit ceci : `[...]State :`**`running`**``[...]``

Avec la commande `sudo ps -e` on reçoit les processus utiliser par toute notre VM, c'est à dire `[...] 559 ?  00:00:00 sshd [...]` pour notre serveur sshd.

Pour afficher le port utilisé par ssh, on fait le commande : ``ss -ltn``. 
Et on voit que notre ssh et connecter sur le port 22 grâce à l'adresse local ``0.0.0.0:22``

Pour se connecter au serveur depuis un client, notre invite de commandes sur notre pc par exemple, on doit faire : ``ssh -p``*`portquel'onachangé`*``username@ipVM`` 

#### 4 : Modification de la configuration du serveur 

### Partie 2 : FTP 

#### 1 : Installation du serveur

Pour installer un serveur FTP voici la commande :``sudo apt install vsftpd``.

#### 2 : Lancement du service FTP

Grâce a la commande `systemctl start` on lance notre serveur, et pour vérifier que celui-ci fonctionne bien on fait `systemctl status vsftpd`  qui nous renvoi : 
`[...] Active :`**`active (running)`**`[...]`

#### 3 : Etude du service FTP

Pour trouver quels processus sont liés à notre serveur FTP on fait `ps -e` qui nous renvoit `[...] 565 ?     00:00:00 vsftpd [...]`

Pour afficher les ports utilisés par le serveur FTP on utilise la commande `sudo ss -lantp` qui nous renvoi : `[...] *:21 [...]`

On affiche les logs avec la commande suivante : `sudo journalctl -u vsftpd`

On se connecte au serveur FTP en allant sur un avigateur web et on tape `ftp://`*`ipVM`*

Pour uploader et télécharger un fichier de notre VM à notre PC, on fait un copier coller d'un fichier, peut importe le quel du gestionnaire du fichier de notre VM à celui de notre PC. 

Vérifions si cela a focntionné en faisant un `ls` dans le dossier où on a copier le fichier. 

On vérifie aussi avec les logs en faisant `sudo cat /var/log/vsftpd.log`. Qui nous renvoi `[...]OK UPLOAD: Client [...]`

#### 4 : Modification de la configuration du serveur 

Pour modifier la configuration du serveur on fait `sudo nano /etc/vsftp.conf`. Grâce à cette commande on peut changer le port d'écoute du serveur vsftpd. On rajoute un `listen_port=10001`, pour vérifier qu'on a bien changé, on fait `sudo cat /etc/vsftpd.conf`. 
On voit `[...] listen_port=10001 [...]`. 

Pour vérifier que les modifications ont fait effets, on fait la commande `ss -lpnt`. Si cela n'a pas fonctionner on fait `systemctl restart vsftpd`. Puis on refait la même commande que précédemment. 

On se reconnecte au serveur FTP avec le nouveau port on fait `ftp://`*``ipVM``*`/1001`. 

On utilise la même méthode que précédemment pour upload/download un fichier, on copie colle un fichier dans le gestionnaire de fichier. 

### Partie 3 : Création de votre propre service

#### 1 : Installation du serveur netcat

On installe netcat avec `sudo apt install netcat`

Pour créer un channel avec netcat ont fait `nc -l -p 2000` ou `nc ipVM 2000`

Pour stocker les données on doit créer un nouvaeu fichier pour cela on fait `touch stock.txt`, puis pour stocker les échanges on fait les commandes suivantes `nc -l -p 2000 >> stock.txt` et `nc ipVM 2000 >> stock.txt`. On vérifie cela avec un `cat stock.txt`. 

#### 2 : Test, test et retest 

Nous allons créer un fichier dans /etc/systemd/system pour cela on fait `cd /etc/systemd/system` puis on fait `sudo touch chat_tp2.service`

On donne les permissions de lire et d'écrire sur le nouveau fichier grâce à la commande `sudo chmod 777 chat_tp2.service`, puis on y dépose ceci : 

```
[Unit]
Description=Little chat service (TP2)

[Service]
ExecStart=<NETCAT_COMMAND>

[Install]
WantedBy=multi-user.target

```

Puis on fait `sudo systemctl daemon-reload`.

Maintenant on teste le service qu'on vient de créer, pour le démarrer on fait `sudo systemctl start chat_tp2` et on vérifie qu'il est actif aevc `systemctl status chat_tp2` qui renvoi ceci : `[...] Active:`**`active (running)`**`[...]`

On regarde le port que le serveur utilise grâce à la commande `sudo ss -latnp` qui renvoi `[...] 0.0.0.0:2000 [...]`

On se connecte à un terminal avec la commande `nc ipVM 2000`. On peut envoyer des messages depuis notre terminal et on consulte les logs avec `journalctl -xe -u chat_tp2 -f`. Qui permet de voir les logs en temps réel !
