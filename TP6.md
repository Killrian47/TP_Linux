# TP6 : Stockage et sauvegarde 

## Partie 1 

### 1. Ajout de disque

On doit ajouter un disque dur de 5Go :
```
[killian@backup ~]$ lsblk | grep sdb 
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0    8G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    7G  0 part
  ├─rl-root 253:0    0  6.2G  0 lvm  /
  └─rl-swap 253:1    0  820M  0 lvm  [SWAP]
sdb           8:16   0    5G  0 disk
sr0          11:0    1 1024M  0 rom
```

### 2. Partitioning 

Nouveau PV de notre nouveau disque : 
```
[killian@backup ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```

Nouvelle VG : 
```
[killian@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "data" successfully created
[killian@backup ~]$ sudo vgs
  VG   #PV #LV #SN Attr   VSize  VFree
  backup   1   0   0 wz--n- <5.00g <5.00g
  rl     1   2   0 wz--n- <7.00g     0
```

Création d'une LV :
```
[killian@backup ~]$ sudo lvcreate -l 100%FREE backup -n last_LV_backup
  Logical volume "last_LV_backup" created.
[killian@backup ~]$ sudo lvs
  LV             VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  last_LV_backup backup -wi-a-----  <5.00g
  root           rl     -wi-ao----  <6.20g
  swap           rl     -wi-ao---- 820.00m
```

Monter la partition : 
```
[killian@backup ~]$ mkdir /backup
mkdir: cannot create directory ‘/backup’: Permission denied
[killian@backup ~]$ sudo !!
sudo mkdir /backup
[killian@backup ~]$ sudo mount /dev/backup/last_LV_backup /backup/
[killian@backup ~]$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
devtmpfs                           388M     0  388M   0% /dev
tmpfs                              405M     0  405M   0% /dev/shm
tmpfs                              405M  5.6M  400M   2% /run
tmpfs                              405M     0  405M   0% /sys/fs/cgroup
/dev/mapper/rl-root                6.2G  2.4G  3.9G  39% /
/dev/sda1                         1014M  266M  749M  27% /boot
tmpfs                               81M     0   81M   0% /run/user/1000
tmpfs                               81M     0   81M   0% /run/user/0
/dev/mapper/backup-last_LV_backup  4.9G   20M  4.6G   1% /backup
[killian@backup /]$ ls -l
total 28
drw-r--r--.   2 killian root 4096 Nov 30 11:56 backup
```

## Partie 2 : Setup du serveur NFS sur backup.tp6.linux

```
[killian@backup /]$ mkdir /backup/web.tp6.linux
mkdir: cannot create directory ‘/backup/web.tp6.linux’: Permission denied
[killian@backup /]$ sudo !!
sudo mkdir /backup/web.tp6.linux
[killian@backup /]$ sudo mkdir /backup/db.tp6.linux
[killian@backup /]$ ls /backup/
db.tp6.linux  web.tp6.linux
```

Conf serveur nfs :

```
[killian@backup /]$ cat /etc/idmpad.conf | grep Domain
Domain = tp6.linux
```

```
[killian@backup /]$ cat /etc/exports
/backup/web.tp6.linux/ 10.5.1.11/24(rw,no_root_squash)
/backup/db.tp6.linux/ 10.5.1.12/24(rw,_no_root_squash)
```


Demarrer le service NFS :

```
[killian@backup /]$ systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
   Active: active (exited) since Tue 2021-11-30 12:43:02 CET; 22s ago
  Process: 2749 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)
  Process: 2735 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
  Process: 2734 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=1/FAILURE)
 Main PID: 2749 (code=exited, status=0/SUCCESS)

Nov 30 12:43:01 backup.tp6.linux systemd[1]: Starting NFS server and services...
Nov 30 12:43:01 backup.tp6.linux exportfs[2734]: exportfs: /etc/exports:2: unknown keyword "_no_root_squash"
Nov 30 12:43:02 backup.tp6.linux systemd[1]: Started NFS server and services.
```

Firewall :

```
[killian@backup /]$ sudo firewall-cmd --add-port=2049/tcp --permanent
success
[killian@backup /]$ sudo firewall-cmd --reload
success
[killian@backup /]$ sudo ss -latnp | grep 2049
LISTEN 0      64           0.0.0.0:2049       0.0.0.0:*
LISTEN 0      64              [::]:2049          [::]:*
```

## Partie 3 : Setup des clients NFS : web.tp6.linux et db.tp6.linux

### Install :

``sudo dnf install nfs-utils`` sur notre VM web ainsi que notre VM db 

### Conf :

``sudo mkdir /srv/backup`` sur nos deux VMs encore

```
[killian@db /]$ cat /etc/idmpad.conf | grep Domain
Domain = tp6.linux
```

```
[killian@web /]$ cat /etc/idmpad.conf | grep Domain
Domain = tp6.linux
```

### Montage :

```
[killian@web ~]$ df -h | grep backup
10.5.1.13:/backup/web.tp6.linux  4.9G   20M  4.6G   1% /srv/backup

[killian@web /]$ cd /srv/
[killian@web srv]$ ls -l
total 4
drw-rw-rw-. 2 root root 4096 Nov 30 12:29 backup

[killian@web srv]$ cat /etc/fstab | grep ext4
10.5.1.13:/backup/web.tp6.linux/ /srv/backup nfs defaults 0 0
[killian@web ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Fri Dec  3 12:01:49 2021
mount.nfs: trying text-based options 'vers=4.2,addr=10.5.1.13,clientaddr=10.5.1.12'
/srv/backup              : successfully mounted
```

```
[killian@db ~]$ df -h | grep db
10.5.1.13:/backup/db.tp6.linux  4.9G   20M  4.6G   1% /srv/backup
[killian@db ~]$ cat /etc/fstab
10.5.1.13:/backup/db.tp6.linux/ /srv/backup nfs defaults 0 0
[killian@db ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Fri Dec  3 12:01:49 2021
mount.nfs: trying text-based options 'vers=4.2,addr=10.5.1.13,clientaddr=10.5.1.12'
/srv/backup              : successfully mounted
```