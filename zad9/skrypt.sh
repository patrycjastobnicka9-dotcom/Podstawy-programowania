#!/bin/bash

mkdir -p kopie
unzip -q -o kopie-1.zip -d kopie
unzip -q -o kopie-2.zip -d kopie

cd kopie

for plik in *.zip; do
    if [ -f "$plik" ]; then
        rok=$(echo "$plik" | cut -d'-' -f1)
        miesiac=$(echo "$plik" | cut -d'-' -f2)
        
        mkdir -p "${rok}/${miesiac}"
        mv "$plik" "${rok}/${miesiac}/"
    fi
done

cd ..