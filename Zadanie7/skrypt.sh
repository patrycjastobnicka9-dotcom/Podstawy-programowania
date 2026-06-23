#!/bin/bash

rm -rf zdjecia_robocze
mkdir -p zdjecia_robocze

unzip -q -o kopie-1.zip -d zdjecia_robocze
unzip -q -o kopie-2.zip -d zdjecia_robocze

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

# Generowanie czystego szablonu A4 pionowo (2 kolumny x 4 wiersze)
cat << 'HTML_HEADER' > index.html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
  body { margin: 0; padding: 0; background-color: #FAFAFA; }
  .page { width: 210mm; height: 297mm; padding: 15mm; margin: 10mm auto; background: white; box-sizing: border-box; }
  .grid-container { display: table; width: 100%; height: 100%; border-collapse: separate; border-spacing: 10mm; }
  .grid-row { display: table-row; }
  .grid-item { display: table-cell; width: 50%; vertical-align: top; text-align: center; border: 1px solid #ccc; padding: 5px; background: #f9f9f9; }
  .grid-item img { max-width: 100%; height: 45mm; object-fit: contain; display: block; margin: 0 auto 5px auto; }
  .desc { font-family: Arial, sans-serif; font-size: 11pt; color: #333; word-break: break-all; }
</style>
</head>
<body>
<div class="page">
  <div class="grid-container">
HTML_HEADER

licznik=0
for foto in *.jpg; do
    if [ -f "$foto" ] && [ $licznik -lt 8 ]; then
        if [ $((licznik % 2)) -eq 0 ]; then
            echo "    <div class=\"grid-row\">" >> index.html
        fi
        cat << HTML_BLOCK >> index.html
      <div class="grid-item">
        <img src="$foto">
        <div class="desc">$foto</div>
      </div>
HTML_BLOCK
        if [ $((licznik % 2)) -eq 1 ]; then
            echo "    </div>" >> index.html
        fi
        licznik=$((licznik + 1))
    fi
done

if [ $((licznik % 2)) -eq 1 ]; then
    echo "    </div>" >> index.html
fi

cat << 'HTML_FOOTER' >> index.html
  </div>
</div>
</body>
</html>
HTML_FOOTER

echo "Sukces: Dokument A4 (2x4) zostal wygenerowany!"
cd ..
zip -q -r gotowe_zdjecia.zip zdjecia_robocze/
echo "Wszystkie zadania zakonczone!"