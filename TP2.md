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


Pour vérifier qu'on a une conenction à internet voici les commandes qu'on va faire : 

``ping 1.1.1.1``, ``ping google.com``