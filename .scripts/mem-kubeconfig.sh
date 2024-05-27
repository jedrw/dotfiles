#!/bin/bash

DIR=~/.local/share/mount
PIPE=$DIR/kubeconfig

mkdir -p $DIR

[[ -p $PIPE ]] || (
    rm -f $PIPE
    mknod $PIPE p
    chmod 600 $PIPE
)

while true
do
    doppler --project jedrw secrets get KUBECONFIG_DATA --plain | base64 -d > $PIPE
done