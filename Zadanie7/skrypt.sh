#!/bin/bash

mkdir -p zdjecia_robocze

echo "Rozpakowywanie archiwow zip..."
unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze

cd zdjecia_robocze

echo "Rozpoczynam masowe przetwarzanie zdjec..."

for plik in *; do
    if [ -f "$plik" ]; then
        
        rozszerzenie="${plik##*.}"
        rozszerzenie_lower=$(echo "$rozszerzenie" | tr 'A-Z' 'a-z')
        nazwa_bazowa="${plik%.*}"
        
        if [ "$rozszerzenie_lower" = "sh" ] || [ "$rozszerzenie_lower" = "zip" ]; then
            continue
        fi

        echo "Przetwarzanie pliku: $plik"

        convert "$plik" -resize x720 -density 96 -units PixelsPerInch "${nazwa_bazowa}.jpg"
        
        if [ "$rozszerzenie_lower" != "jpg" ] && [ "$rozszerzenie_lower" != "jpeg" ]; then
            rm "$plik"
        fi
    fi
done

cd ..

echo "Pakowanie plikow JPG do archiwum..."
zip -q -r gotowe_zdjecia.zip zdjecia_robocze/

echo "Zadanie zakonczone pomyslnie!"
