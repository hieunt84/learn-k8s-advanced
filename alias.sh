#!/bin/bash
echo alias k=\'kubectl\' >> .bashrc
echo alias kg=\'kubectl get\' >> .bashrc
echo alias ka=\'kubectl apply\' >> .bashrc
echo alias kd=\'kubectl delete\' >> .bashrc
source .bashrc
