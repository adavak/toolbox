#!/bin/sh

cat <<EOF | python -
import sys
from pprint import pprint
pprint(sys.path)
EOF
