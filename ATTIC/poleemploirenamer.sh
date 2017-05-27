#!/bin/bash
#Renomme les pdf du site de pole emploi selon leur type

#Assume que les noms de fichiers ont ce format, ce qui n'est pas toujours le cas
for i in 20*.pdf
do

if [[ `pdfgrep "RELEVE DE SITUATION" "$i" 2>/dev/null` ]]
then #Le document est un relevé de situation
	SUBJECT="Relevé de situation"
else #Récupérer le titre depuis la ligne "Objet:"
	SUBJECT=`pdfgrep Objet "$i" 2>/dev/null | cut -f 1-2 -d " " --complement  | sed -e "s/'/_/g"`
fi

DOCDATE=`pdfgrep ", le " "$i" 2>/dev/null | awk '{print ( $(NF) " " $(NF-1) " " $(NF-2) )}'` #TODO convert 3 last fields to standard date
NEWNAME="Pole Emploi ${SUBJECT} ${DOCDATE}.pdf"

mv $i "$NEWNAME"
done
