#!/bin/bash

rm -rf zdjecia_robocze
mkdir -p zdjecia_robocze

unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze

cd zdjecia_robocze

find . -mindepth 2 -type f -exec mv {} . \;
find . -type d -not -name "." -exec rm -rf {} \; 2>/dev/null

for plik in *; do
    if [ -f "$plik" ]; then
        rozszerzenie="${plik##*.}"
        rozszerzenie_lower=$(echo "$rozszerzenie" | tr 'A-Z' 'a-z')
        nazwa_bazowa="${plik%.*}"
        
        if [ "$rozszerzenie_lower" = "sh" ] || [ "$rozszerzenie_lower" = "zip" ] || [ "$rozszerzenie_lower" = "pdf" ]; then
            continue
        fi

        convert "$plik" -resize x720 -density 96 -units PixelsPerInch "${nazwa_bazowa}.jpg"
        
        if [ "$rozszerzenie_lower" != "jpg" ] && [ "$rozszerzenie_lower" != "jpeg" ]; then
            rm "$plik"
        fi
    fi
done

montage -label '%f' -geometry 250x350+10+10 -tile 2x4 -page A4 *.jpg portfolio.pdf

cd ..
zip -q -r gotowe_zdjecia.zip zdjecia_robocze/

echo "Wszystkie zadania zakonczone pomyslnie!"
