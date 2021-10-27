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

Pour ``ping1.1.1.1`` on aura ceci en retour sur notre terminal, si l'accès internet est fonctionnel : 

```
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=20.0 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=21.7 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=57 time=21.1 ms
```

Et pour ``ping google.com`` voici ce qu'on aura juste après la commande :

```
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=1 ttl=113 time=25.3 ms
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=2 ttl=113 time=21.4 ms 
64 bytes from par10s42-in-f14.le100.net (216.58.214.174): icmp_seq=3 ttl=113 time=26.7 ms  
```

Et depuis notre PC : 

``ping <ipVM>``

On aura comme retour sur notre terminal ceci : 

```
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
Réponse de <ipVM> : octets=32 temps<1ms TTL=64
```

### Partie 1: SSH

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

