#!/bin/sh

if [[ -d "/srv/yt/downloads" && "/var/log/yt" ]]; then
lien="$1"
title=$(youtube-dl --get-title $lien)
youtube-dl -f mp4 -o "/srv/yt/downloads/$title/%(title)s" $lien > /dev/null
youtube-dl --get-description $lien >> "/srv/yt/downloads/$title/description"

echo "La vidéo suivante $lien a été téléchargé."
echo "Chemin où la vidéo a été téléchargée : /srv/yt/downloads/$title/$title.mp4"
echo "[$(date '+%D %T')] La vidéo $youtube_video_url viens d'être télécharger. Chemin où la vidéo a été téléchargée : /srv/yt/downloads/$title/$title.mp4" >> "/var/log/yt/download.log"

else
        exit
fi