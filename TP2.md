# TP_Linux

## TP 2 : Manipulation des services

`` sudo hostname node1.tp2.linux `` changera le nom de notre VM instantanément mais si on redémarre celle-ci, le changement ne sera pas pris en compte. 

Pour qu'il soit pris en compte il faut faire : 

```bash  
 sudo nano /etc/hostname  
```
Puis : 

```
cat /etc/hostname
```

Qui devrait renvoyer : ``node1.tp2.linux``