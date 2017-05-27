#!/bin/bash
cd /path/to/repo && if [[ $(git status --short) != "" ]]; then exit 1; fi