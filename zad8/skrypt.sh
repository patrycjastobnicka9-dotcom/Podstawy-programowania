cd ../zad7/zdjecia_robocze
magick montage -label '%f' -background white -tile 2x4 -geometry +20+20 *.jpg -compress jpeg ../../zad8/portfolio.pdf
cd ../../zad8