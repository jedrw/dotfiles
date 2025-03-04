#!/bin/bash

# Username used to connect to the share
USERNAME=$(whoami)
# Look at your keyring with seahorse to get attributes
# Keyring attribute
KEYRING_ATTR=user

DIR=~/.local/share/mount
PIPE=$DIR/smbcredentials

mkdir -p $DIR

[[ -p $PIPE ]] || (
    rm -f $PIPE
    mkfifo $PIPE
)

while true
do
    SECRET=$(secret-tool lookup $KEYRING_ATTR $USERNAME)
    (
        echo "username=$USERNAME"
        echo "password=$SECRET"
    ) > $PIPE
done