#!/bin/bash

MEM_KUBECONFIG="/tmp/kube/config"
mkdir -p /tmp/kube
echo "Created /tmp/kube dir"

doppler --project jedrw secrets get KUBECONFIG_DATA --plain | base64 -d > $MEM_KUBECONFIG
echo "Wrote kubeconfig into $MEM_KUBECONFIG"

