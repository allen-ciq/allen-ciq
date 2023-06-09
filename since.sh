#!/bin/bash
# Replace @since TBD for release
# Usage: ./since.sh <version>

git grep -lF '@since TBD' | sed '\|.github/PULL_REQUEST_TEMPLATE.md|d' | xargs -n 1 sed -i '' 's/@since TBD/@since '$1'/'
