#!/bin/bash

rm -rf zdjecia_robocze
mkdir -p zdjecia_robocze

unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze
unzip -q -o galeria.zip -d zdjecia_robocze

cd zdjecia_robocze

find . -type f -name "*.zip" | while read -r belka_zip; do
    unzip -q -o "$belka_zip"
    rm -f "$belka_zip"
done

find . -mindepth 2 -type f -exec mv {} . \; 2>/dev/null
find . -type d -not -name "." -exec rm -rf {} \; 2>/dev/null

for plik in *; do
    if [ -f "$plik" ]; then
        rozszerzenie="${plik##*.}"
        rozszerzenie_lower=$(echo "$rozszerzenie" | tr 'A-Z' 'a-z')
        nazwa_bazowa="${plik%.*}"
        
        if [ "$rozszerzenie_lower" = "sh" ] || [ "$rozszerzenie_lower" = "zip" ] || [ "$rozszerzenie_lower" = "html" ] || [ "$rozszerzenie_lower" = "css" ]; then
            continue
        fi

        mv "$plik" "${nazwa_bazowa}.jpg" 2>/dev/null
    fi
done

echo "" > bloki.html

for foto in *.jpg; do
    if [ -f "$foto" ]; then
        cat << HTML_BLOCK >> bloki.html
<div class="responsive">
  <div class="gallery">
    <a target="_blank" href="$foto">
      <img src="$foto">
    </a>
    <div class="desc">$foto</div>
  </div>
</div>
HTML_BLOCK
    fi
done

if [ -f "index.html" ]; then
    sed -i '/<div class="responsive">/,$d' index.html
    cat bloki.html >> index.html
    echo "</div>" >> index.html
    echo "</body>" >> index.html
    echo "</html>" >> index.html
    rm -f bloki.html
    echo "Sukces: Galeria HTML zostala wygenerowana!"
else
    echo "Blad: Brak pliku index.html!"
fi

cd ..
zip -q -r gotowe_zdjecia.zip zdjecia_robocze/

echo "Wszystkie zadania zakonczone!"
