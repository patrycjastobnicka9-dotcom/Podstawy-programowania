#!/bin/bash

mkdir -p zdjecia_robocze

echo "Rozpakowywanie archiwow zip..."
unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze

cd zdjecia_robocze

echo "Rozpoczynam masowe przetwarzanie zdjec (Zadanie 7)..."

for plik in *; do
    if [ -f "$plik" ]; then
        rozszerzenie="${plik##*.}"
        rozszerzenie_lower=$(echo "$rozszerzenie" | tr 'A-Z' 'a-z')
        nazwa_bazowa="${plik%.*}"
        
        if [ "$rozszerzenie_lower" = "sh" ] || [ "$rozszerzenie_lower" = "zip" ] || [ "$rozszerzenie_lower" = "pdf" ]; then
            continue
        fi

        echo "Przetwarzanie pliku: $plik"
        convert "$plik" -resize x720 -density 96 -units PixelsPerInch "${nazwa_bazowa}.jpg"
        
        if [ "$rozszerzenie_lower" != "jpg" ] && [ "$rozszerzenie_lower" != "jpeg" ]; then
            rm "$plik"
        fi
    fi
done

echo "Generowanie dokumentu PDF z portfolio (Zadanie 8)..."
# Tworzymy plik PDF: siatka 2x4 (osiem zdjec na strone), format A4, podpisane nazwami plikow
montage -label '%f' -geometry 250x350+10+10 -tile 2x4 -page A4 *.jpg portfolio.pdf

cd ..

echo "Pakowanie plikow do finalnego archiwum..."
zip -q -r gotowe_zdjecia.zip zdjecia_robocze/

echo "Wszystkie zadania zakonczone pomyslnie!"
