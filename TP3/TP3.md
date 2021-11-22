# TP 3 : A little script 

## I. Script carte d'identité 

### Sorti script
```
killian@node1:/srv/idcard$ sudo bash idcard.sh
Machine name : node1.tp2.linux
OS Ubuntu and kernel version is 5.13.0-19-generic
IP : 192.168.56.131/24
Ram : 398Mi RAM restante sur  1,9Gi RAM totale
Disque : 2,1G space left
Top 5 processes by RAM usage :
   1072     809 xfwm4 --replace              3.8  0.0
    574     558 /usr/lib/xorg/Xorg -core :0  3.5  0.0
   1171     809 /usr/bin/python3 /usr/bin/b  2.3  0.0
   1101    1091 /usr/lib/x86_64-linux-gnu/x  2.0  0.0
   1108    1091 /usr/lib/x86_64-linux-gnu/x  2.0  0.0
Listening ports :
LISTEN 0      4096    127.0.0.53%lo:53         0.0.0.0:*     users:(("systemd-resolve",pid=409,fd=14))
LISTEN 0      128           0.0.0.0:22         0.0.0.0:*     users:(("sshd",pid=547,fd=3))
LISTEN 0      128         127.0.0.1:631        0.0.0.0:*     users:(("cupsd",pid=522,fd=7))
LISTEN 0      32                  *:10001            *:*     users:(("vsftpd",pid=542,fd=3))
LISTEN 0      128              [::]:22            [::]:*     users:(("sshd",pid=547,fd=4))
LISTEN 0      128             [::1]:631           [::]:*     users:(("cupsd",pid=522,fd=6))

Here's your random cat : https://cdn2.thecatapi.com/images/oKIJfbCRy.jpg

```


## II. Script youtube-dl


### Sorti script

```
killian@node1:/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=-XElAl0zG-E
La vidéo suivante https://www.youtube.com/watch?v=-XElAl0zG-E a été téléchargé.
Chemin où la vidéo a été téléchargée : /srv/yt/downloads/Video courte mais a mourir de rire/Video courte mais a mourir de rire.mp4
```

### Log

```
[11/22/21 22:06:28] La vidéo  viens d'être télécharger. File path : /srv/yt/downloads/Video courte mais a mourir de rire/Video courte mais a mourir de rire.mp4
[11/22/21 22:07:44] La vidéo  viens d'être télécharger. File path : /srv/yt/downloads/Video courte mais a mourir de rire/Video courte mais a mourir de rire.mp4
```

## Make a service

