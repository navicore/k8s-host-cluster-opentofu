#!/usr/bin/env bash

kubectl --kubeconfig kubeconfig.yaml delete storageclass do-block-storage
tofu destroy -auto-approve

