#!/bin/sh


id_card()
{
name=$(hostname)
ip=$(ip a | grep inet | grep 192. | cut -d' ' -f6)
kernel_version=$(uname -r)
os=$(cat /etc/issue |  cut -d' ' -f1)
RAMleft=$(free -mh | grep Mem: | cut -c 15-20)
RAM=$(free -mh | grep Mem: | cut -c 39-44)
Disque=$(df -h | grep sda3 | cut -d' ' -f12)
Process=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tail -n 5)
Port=$(sudo ss -latnp | grep LISTEN )
image=$(curl https://api.thecatapi.com/v1/images/search --silent | jq -r '.[].url')

echo "Machine name : $name"
echo "OS $os and kernel version is $kernel_version"
echo "IP : $ip "
echo "Ram :$RAM RAM restante sur $RAMleft RAM totale "
echo "Disque : $Disque space left"
echo -e "Top 5 processes by RAM usage :\n$Process"

echo -e  "Listening ports :\n$Port"

echo -e "\nHere's your random cat : $image"
}

id_card