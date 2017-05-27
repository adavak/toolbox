#!/bin/bash
#Description: Generate a markdown-formatted list of all scripts in a directory, along with their descriptions
#Lines with descriptions have to start with "#Description: "

echo "### Files"
for i in $(find . -maxdepth 1 -type f -exec basename '{}' \; | sort)
do
	md_desc=$(grep "^#Description" "$i" 2>/dev/null | cut -d " " -f 1 --complement)
	echo " * [$i]($i) - $md_desc"
done

echo ""
echo "### Directories"
for i in $(find . -maxdepth 1 -type d -exec basename '{}' \; | sort)
do
	md_desc=$(grep "^#Description" "$i" 2>/dev/null | cut -d " " -f 1 --complement)
	echo " * [$i]($i) - $md_desc"
done

#TODO: sort output
#Also works for .deb packages: for i in *; do pkgdesc=$(dpkg -I "$i" | grep "^ Description" | cut -d ":" -f 1 --complement); echo " * [$i]($i) - $pkgdesc"; done