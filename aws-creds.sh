#!/bin/bash
# manage ChartIQ SES keys

set -e

list_keys(){
	if [ "$#" -ne 1 ]; then
		echo Please provide the profile name
		exit 1
	fi
	aws iam list-access-keys --user-name chartiq-ses-chartiq.com --profile "$1"
}

create_key(){
	if [ "$#" -lt 1 ]; then
		echo Please provide the name of the profile to use
		exit 1
	fi
	RESP=$(aws iam create-access-key --user-name chartiq-ses-chartiq.com --profile "$1")
	NEW_PROFILE=ses-$(date +'%Y%m%d')
	KEY_ID=$(jq -r '.AccessKey.AccessKeyId' <<< "$RESP")
	SEC_KEY=$(jq -r '.AccessKey.SecretAccessKey' <<< "$RESP")
	aws configure --profile "$NEW_PROFILE" set aws_access_key_id "$KEY_ID"
	aws configure --profile "$NEW_PROFILE" set aws_secret_access_key "$SEC_KEY"
	# echo access_key_id "$KEY_ID"
	# echo secret_access_key "$SEC_KEY"
	echo export AWS_ACCESS_KEY_ID="$KEY_ID"
	echo export AWS_SECRET_ACCESS_KEY="$SEC_KEY"
}

update_key(){
	if [ "$#" -lt 1 ]; then
		echo Please provide the name of the profile to use
		exit 1
	fi
	if [ "$#" -ne 2 ]; then
		echo Please provide the name of the profile to modify
		exit 1
	fi
	OLD_KEY=$(aws configure get $2.aws_access_key_id)
	aws iam update-access-key --access-key-id $OLD_KEY --status Inactive --user-name chartiq-ses-chartiq.com --profile $1
	# sed -i '' 's/^\['"$1"'\]$/\['"$1"'-old\]/' ~/.aws/*
}

delete_key(){
	if [ "$#" -lt 1 ]; then
		echo Please provide the name of the profile to use
		exit 1
	fi
	if [ "$#" -ne 2 ]; then
		echo Please provide the name of the profile to modify
		exit 1
	fi
	OLD_KEY=$(aws configure get $2.aws_access_key_id)
	aws iam delete-access-key --access-key-id $OLD_KEY --user-name chartiq-ses-chartiq.com --profile $1
}

#commands
case "$1" in
	create)
		create_key $2
		;;
	delete)
		delete_key $2 $3
		;;
	list)
		list_keys $2
		;;
	profiles)
		aws configure list-profiles
		;;
	update)
		update_key $2 $3
		;;
	*)
		echo Available commands:
		awk '/^[[:space:]]*#commands/{cmdBlock = 1; next}/^[[:space:]]*esac/{cmdBlock = 0}cmdBlock && /^[[:space:]]*[a-zA-Z0-9_]+\)[[:space:]]*$/{sub(/[[:space:]]*\)[[:space:]]*$/, ""); print $1}' $0
		;;
esac
