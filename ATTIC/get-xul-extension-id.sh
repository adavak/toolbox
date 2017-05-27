#!/bin/bash
# Retrieve the extension id for a firefox addon from its install.rdf
#Source: http://kb.mozillazine.org/MozillaZine_Knowledge_Base:About

set -e

EXID=`unzip -qc $1 install.rdf | xmlstarlet sel \
    -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
    -N em=http://www.mozilla.org/2004/em-rdf# \
    -t -v \
    "//rdf:Description[@about='urn:mozilla:install-manifest']/em:id"`

echo "$EXID"
