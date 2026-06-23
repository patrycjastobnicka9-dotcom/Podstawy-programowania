#!/bin/bash

OUTPUT_DIR="zdjecia_robocze"
ZIP_OUT="galeria_zadanie.zip"

# Czyszczenie śmieci przed startem
rm -rf "$OUTPUT_DIR"
rm -f "$ZIP_OUT"
mkdir -p "$OUTPUT_DIR"

# 1. Rozpakowanie paczek głównych od Natalii
if [ -f "kopie-1.zip" ]; then
    unzip -q "kopie-1.zip" -d "$OUTPUT_DIR"
fi

if [ -f "kopie-2.zip" ]; then
    unzip -q "kopie-2.zip" -d "$OUTPUT_DIR"
fi

# 2. ROZPAKOWANIE ZIPÓW W ZIPIE (tych wewnętrznych z plikami)
cd "$OUTPUT_DIR" || exit
for wewnętrzny_zip in *.zip; do
    if [ -f "$wewnętrzny_zip" ]; then
        unzip -q "$wewnętrzny_zip"
        rm -f "$wewnętrzny_zip"
    fi
done
cd ..

HTML_FILE="$OUTPUT_DIR/index.html"

# 3. Generowanie idealnego układu PIONOWEGO (tak jak na zdjęciach)
cat <<EOF > "$HTML_FILE"
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galeria</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .gallery-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-width: 600px;
            width: 100%;
        }
        .photo-block {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .photo-block img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
        }
        .photo-title {
            margin-top: 10px;
            font-weight: bold;
            color: #555;
        }
    </style>
</head>
<body>
    <h1>Galeria</h1>
    <div class="gallery-container">
EOF

# Szukanie wszystkich odpakowanych zdjęć i wrzucanie ich pionowo
cd "$OUTPUT_DIR" || exit
for plik in *.{jpg,jpeg,png,JPG,JPEG,PNG}; do
    if [ -f "$plik" ]; then
        cat <<EOF >> "index.html"
        <div class="photo-block">
            <img src="$plik" alt="$plik">
            <div class="photo-title">$plik</div>
        </div>
EOF
    fi
done
cd ..

cat <<EOF >> "$HTML_FILE"
    </div>
</body>
</html>
EOF

# 4. Pakowanie gotowego pionowego HTML i zdjęć do jednego lekkiego ZIP-a
zip -r "$ZIP_OUT" "$OUTPUT_DIR"

# 5. SPRZĄTANIE: Usuwamy ciężki folder roboczy, żeby nie ważył na dysku!
rm -rf "$OUTPUT_DIR"

echo "Done!"