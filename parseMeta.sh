#!/bin/bash
# pretty-print build meta JSON files

sed -e 's/^"{/{/' -e 's/}"$/}/' -e 's/\\n/\n/g' -e 's/\\//g' < $1 | jq
