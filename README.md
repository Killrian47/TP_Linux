# TP_Linux

## TP 1 : Are you dead yet ?

Voici les commandes que j'ai trouvé pour faire crash une VM : 

- ```sudo dd if=/dev/zero of=/dev/sda ```. Celle-ci permet de remplacer tout les dossiers et fichiers se trouvant dans le dossier /dev/ de notre VM par des 0. On peut passer en ``root`` si on souhaite faire la commande sans ``sudo``.