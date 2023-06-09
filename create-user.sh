#!/bin/bash
# provision a new user with a temp pw or a key read from stdin
# must be run as root

if [[ $# -ne 1 ]]; then
	echo 'Usage: create-user.sh <account name>'
	exit 1
fi

USER=$1
useradd -m $USER

if [[ -t 0 ]]; then
	passwd $USER
	passwd --expire $USER
else
	SSHDIR=$(eval echo "~$USER")/.ssh
	mkdir -p $SSHDIR
	cat >> $SSHDIR/authorized_keys
fi
