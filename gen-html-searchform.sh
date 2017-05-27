#!/bin/bash
read -r -p "base search URL: " url
read -r -p "query URL parameter: " param
read -r -p "icon file name: " icon
read -r -p "description of search form: " descr

echo "
<form method=\"get\" action=\"$url\">
<input value=\"Go!\" type=\"image\" src=\"res/$icon\">
<input name=\"$param\"  maxlength=\"255\" placeholder=\"🔍$descr\" type=\"text\">
</form>" >> "$descr.txt"

