#!/bin/bash

mkdir -p zdjecia_robocze
unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze

cd zdjecia_robocze

for zipplik in *.zip; do
    if [ -f "$zipplik" ]; then
        unzip -q -o "$zipplik"
        rm "$zipplik"
    fi
done

for plik in *.[jJ][pP][gG] *.[jJ][pP][eE][gG] *.[pP][nN][gG] *.[bB][mM][pP]; do
    if [ -f "$plik" ]; then
        nazwa_bazowa="${plik%.*}"
        magick "$plik" -resize x720 -density 96 -units PixelsPerInch "${nazwa_bazowa}.jpg"
        if [[ "$plik" != *.jpg && "$plik" != *.jpeg ]]; then
            rm "$plik"
        fi
    fi
done

zip -q -r ../gotowe_zdjecia.zip *