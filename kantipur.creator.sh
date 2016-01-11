#!/bin/bash
########### Created By @niranjanshr13. Find him with @niranjanshr13. Niranjan Shrestha.----------------------------##########

# convert Eastern Time to Nepal and initialize everything.
dateinitial=$(date +%s)
converttonepal=$(expr $dateinitial + 39600)
date=$(date -d @$converttonepal +%Y-%m-%d)
# removing every jpg for old jpg
rm *.jpg
# Creating kantipur pdf.
curl http://epaper.ekantipur.com/kantipur/$date/1 | grep rel | grep .pdf | grep -o rel=".*" | sed 's/rel=//g' | sed 's/>//g' | sed 's/"//g' > /var/www/html/kantipur.download
cd /var/www/html/
wget -i kantipur.download
rm /var/www/html/kantipur.download
# Looping and renaming file into humanly readable number.
for name in *.pdf
do
    newname="$(echo "$name" | cut -c23-)"
    mv "$name" "$newname"
done

# convert pdf into jpg ----->> This is only for @niranjanshr13. You can remove code below --->>> only  the loop. 
for picture in *.pdf
do
picturepdf="$(echo $picture | cut -f 1 -d '.')"
car=$(echo $picturepdf'.jpg')
convert -verbose  -density 200 $picture $car
done
# Removing all pdf and save file.
rm *.pdf *.save
