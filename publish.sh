#!/bin/bash
# publish to private npm registry
# prereq: create an 'automation' token on npmjs.com and set it as your authToken in .npmrc
# steps:
# download packages from LS
# delete study-calc (optional: move compact to same dir)
# cd to package dir and run

if [ -z "$1" ]; then
	DISABLED="--dry-run"
fi
echo Publishing ${DISABLED:+disabled}
read -p "Have you deleted the study-calc?"
# echo "Starting OTP process--make sure to check the box \"do not prompt\""
find . -type d -mindepth 1 -maxdepth 1 | xargs -n 1 -I {} bash -c "cd {}; npm publish $DISABLED --access=restricted" 2>&1 | tee publish.log
