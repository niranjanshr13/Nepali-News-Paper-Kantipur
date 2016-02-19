#!/bin/bash
default_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#rm $default_dir/*.jpg
#rm $default_dir/*.pdf
# convert Eastern Time to Nepal and initialize everything.
while :
do
date_initial=$(date +%s)
convert_to_nepal=$(expr $date_initial + 39600 - 28800)
date=$(date -d @$convert_to_nepal +%Y-%m-%d)
# removing every jpg for old jpg
rm $default_dir/*.jpg
rm $default_dir/*.pdf
rm $default_dir/*.pdf*
## Creating kantipur pdf.
#echo $date
#curl http://epaper.ekantipur.com/kantipur/$date/1 | grep rel | grep .pdf | grep -o rel=".*" | sed 's/rel=//g' | sed 's/>//g' | sed 's/"//g' > $default_dir/kantipur.download
#aria2c -x 16 -s 16 -i $default_dir/kantipur.download -d "$default_dir"
aria2c -x 16 -s 16 http://epaper.ekantipur.com/epaper/kantipur/$date/$date.pdf -d "$default_dir"
#rm $default_dir/kantipur.download
# Looping and renaming file into humanly readable number.
for name in $(ls $default_dir/*.pdf)
do
    new_name="$(echo "$name" | cut -d"-" -f4)"
    mv $name $default_dir/$new_name
done
# convert pdf into jpg ----->> This is only for @niranjanshr13. You can remove code below --->>> only  the loop.
for picture in $(ls $default_dir/*.pdf)
do
picture_pdf="$(echo $picture | cut -d'/' -f6 | cut -f1 -d '.')"
#car=$(echo $default_dir/$picture_pdf'.jpg')
convert -verbose -density 200 $picture $default_dir/$picture_pdf.jpg
#convert -density 200 68b8cfcc73_2016-01-26_10.pdf aa.jpg
done
# Removing all pdf and save file.
#rm $default_dir/*.pdf
#rm $default_dir/*.save
###
echo '<body>' > $default_dir/kantipur.html
echo "<center><h1>Kantipur Newspaper of $date </h1></center>" >> $default_dir/kantipur.html
number_image=$(ls $default_dir | grep jpg | wc -l)
for jpeg in $(seq 0 $number_image)
do
echo "<img src=$date-$jpeg.jpg style='width:1080px;height:1920px;'>" >> $default_dir/kantipur.html
done
echo '<audio controls autoplay>' >> $default_dir/kantipur.html
echo 'Your browser does not support the audio element.' >> $default_dir/kantipur.html
echo '</body>' >> $default_dir/kantipur.html
rm *.pdf
sleep 14400
done
