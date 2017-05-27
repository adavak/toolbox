#!/bin/bash
# Description: Commit x hours in the past
hours="$1"
newdate=$(($(date +%s) - $hours * 3600))
shift
git commit --date="$newdate +0200" "$@"