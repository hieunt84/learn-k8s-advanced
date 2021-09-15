#!/bin/bash
# ref : https://metallb.universe.tf/installation/

kubectl create ns metallb-system
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm install metallb metallb/metallb -n metallb-system -f ./values.yaml
