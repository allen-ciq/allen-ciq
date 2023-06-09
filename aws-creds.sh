#!/bin/bash

set -e
trap "set +e" HUP INT ABRT EXIT QUIT TERM
if [ -z "$1" ]; then
	read -p "MFA token: " TOTP_TOKEN
else
	TOTP_TOKEN=$1
fi
RESP=$(aws sts get-session-token --serial arn:aws:iam::107055233533:mfa/allenng --token-code $TOTP_TOKEN)
# echo $RESP
read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< $(echo $RESP | awk '{print $2" "$4" "$5}')
# printf $AWS_ACCESS_KEY_ID"\n"$AWS_SECRET_ACCESS_KEY"\n"$AWS_SESSION_TOKEN
# export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
printf "[default]\naws_access_key_id = AKIARR3H5HH6QON4C3XE\naws_secret_access_key = 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\n[MFA]\naws_access_key_id = "$AWS_ACCESS_KEY_ID"\naws_secret_access_key = "$AWS_SECRET_ACCESS_KEY"\naws_session_token = "$AWS_SESSION_TOKEN > ~/.aws/credentials
