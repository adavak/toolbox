#!/bin/bash
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Error: Usage: $0 argument1 arg2 arg3"
  exit $E_BADARGS
fi