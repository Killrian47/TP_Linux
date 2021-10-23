# TP_Linux

## TP 1 : Are you dead yet ?

Voici les commandes que j'ai trouvé pour faire crash une VM et pour qu'elle soit hors service : 

- ```sudo dd if=/dev/zero of=/dev/sda```. Celle-ci permet de remplacer tout les dossiers et fichiers se trouvant dans le dossier /dev/ de notre VM par des 0. On peut passer en ``root`` si on souhaite faire la commande sans ``sudo``.

- ```sudo rm -Rf /*```. Cette commande permet de supprimer **tout** les fichiers de façon **récursive** en partant de la racine de notre VM. Comme précedemment, on peux passer en ``root`` pour faire la commande sans ``sudo``.

- Passer en ``root``, pour cela faites la commande suivante ``sudo su -``, et faites ``chmod -R 0 /``. Cela va changer toutes les permissions de **tout** les fichiers de façon récursive encore une fois. **Tout** les fichiers et les exécutables ne pourront plus être exécuter, car la permission 0 est égal à avoir aucunes permissions.

- Passer en ``root``, puis taper la commande suivante ``rm -rf /bin/``. Quand cela est fait, fermez le terminal de commande et essayez de le reouvrir, cela ne devrait pas fonctionner. Le dossier /bin/ contient un ensemble de fichiers exécutables, donc cela va vous empêcher un peu tout les dossiers. 

-