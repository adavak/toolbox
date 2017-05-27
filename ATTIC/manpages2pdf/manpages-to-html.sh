#!/bin/bash
# Description: create a directory containing manpages as HTML pages, and generate an index
# TODO: group all output in one file, TOC linking to anchors for every command
# TODO: add "help" pages to output
# TODO: add plain text files to output
set -o errexit
set -o nounset
export LANG=C # Output language
outdir="$PWD" # Output directory

######

document_html_head="<html><body><h1>MANPAGES</h1><hr><h1>Table of contents</h1><ul>"
toc_html_tail="</ul><hr>"
document_html_tail="</body></html>"
toc_html_content=""

css='<style>
body {
	font-family: "Droid Sans";
	background-color: #DDD;
}

.h2.nroffsh {
	color: #E57474;
}

a {
	text-decoration: none;
	color: #7496A3;
}

a:hover {
	color: #9BC8DA;
}
</style>
'

#####

if [ ! -d "${outdir}/tmp" ]; then mkdir -p "${outdir}/tmp"; fi

# create temp. html files for each manpage, build table of contents
for command in $(cat MANPAGES.txt); do
	if man -w "$command" >/dev/null; then
		manpage_file=$(man -w "$command") #path to manpage roff file
		man_content_html=$(zcat "$manpage_file" | roffit --bare) # HTML manpage content
		man_description=$(man -f "$command") # short description text
		man_anchor="<h1 href=\"#${command}\">${command}</h1>" # HTML section title/anchor
		toc_entry="<li><a href=\"#${command}\">${command}</a> - ${man_description}</li>" # HTML TOC entry for manual
		echo "${man_anchor}${man_content_html}" > "tmp/$command.tmp.txt"
	else
		toc_entry="<li><a href=\"https://man.cx/${command}\">$command</a> - <i>???</i>"
	fi
	toc_html_content="$toc_html_content $toc_entry"
done

# generate document
echo "${document_html_head}${css}${toc_html_content}${toc_html_tail}" >| "${outdir}/MANPAGES.html"
cat tmp/*.tmp.txt >> "${outdir}/MANPAGES.html"
echo "$document_html_tail" >> "${outdir}/MANPAGES.html"
rm "$outdir/tmp/*.tmp.txt" && rmdir "$outdir/tmp"
echo "Done saving to ${outdir}/MANPAGES.html"

######################



# 	man -f $page
# 	man -t $page | ps2pdf - -> $page.pdf; done

# for page in $TEXT_FILES; do enscript -p - $page | ps2pdf - -> `basename $page`.pdf; done

# for page in $HELP_COMMANDS; do help $page | enscript --encoding=ps -p - | ps2pdf - -> $page.pdf; done


#man -t $COMMAND | ps2pdf - $COMMAND.pdf
#enscript to convert text files to ps
#ps2pdf to convert ps files to pdf
#pdfunite to merge pdf files

#How do I create a table of contents? a pdf index?
