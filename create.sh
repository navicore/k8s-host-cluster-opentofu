#!/usr/bin/env bash

tofu plan -target=local_file.kubeconfig
tofu apply -target=local_file.kubeconfig -auto-approve
tofu plan
tofu apply -auto-approve

