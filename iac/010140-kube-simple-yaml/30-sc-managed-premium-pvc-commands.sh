cd ../..

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/05-Azure-Disks-for-AKS-Storage

# cd into the directory.
cd ./iac/010140-kube-simple-yaml

terraform fmt

terraform init

terraform validate

terraform plan -out main.tfplan

# terraform show main.tfplan

terraform apply main.tfplan 

terraform state list

terraform state show 

terraform show terraform.tfstate

# Get the resource group name and AKS_CLUSTER_NAME 
# Default admin

kubectl cluster-info

az aks get-credentials --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --overwrite-existing

kubectl cluster-info

# If you want to logout or unset, use the following.
# kubectl config unset current-context

kubectl get nodes

kubectl get nodes -o wide

az aks show --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster

kubectl cluster-info

az aks nodepool list

az aks nodepool list --resource-group aks-tf-trial1-rg-dev --cluster-name aks-tf-trial1-rg-dev-aks-cluster -o table

kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

# The following should show msi(managed system identity)
az aks show --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --query servicePrincipalProfile

# Why is the following giving empity array? Not sure. Need to find out(some times).
# httpapplicationrouting-terraform-aks-dev-aks-cluster
# omsagent-terraform-aks-dev-aks-cluster
# azurepolicy-terraform-aks-dev-aks-cluster
# terraform-aks-dev-aks-cluster-agentpool
az identity list --resource-group aks-tf-trial1-rg-dev
az identity list --resource-group aks-tf-trial1-rg-dev-nrg

# Get pods
kubectl get pods -n kube-system

kubectl get pods -n default

kubectl get all -n default


###################################################################################

kubectl get sc -o wide

# You will see something like the following. 
# NAME                    PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
# azurefile               file.csi.azure.com   Delete          Immediate              true                   10m
# azurefile-csi           file.csi.azure.com   Delete          Immediate              true                   10m
# azurefile-csi-premium   file.csi.azure.com   Delete          Immediate              true                   10m
# azurefile-premium       file.csi.azure.com   Delete          Immediate              true                   10m
# default (default)       disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   10m
# managed                 disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   10m
# managed-csi             disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   10m
# managed-csi-premium     disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   10m
# managed-premium         disk.csi.azure.com   Delete          WaitForFirstConsumer   true                   10m


# kubectl apply -f .\kube-manifests\5-01-PVC-ConfigMap-MySQL\

# Ensure that the storageClassName in the below file is managed-premium
kubectl apply -f .\kube-manifests\5-02-pvc\01-pvc-managed-premium-WaitForFirstConsumer.yml

# Run the following command, you will see a pvc, but its in pending.
# Its pending, because the storageClassName is managed-premium, and its VOLUMEBINDINGMODE is WaitForFirstConsumer.
# So till the first consumer is ready, pvc status is pending.
kubectl get pvc
# There is no pv yet, run the following command and see.
# This is because, the storageClassName for the pvc is set to managed-premium. See the file 01-persistent-volume-claim.yml
kubectl get pv

kubectl delete -f .\kube-manifests\5-02-pvc\01-pvc-managed-premium-WaitForFirstConsumer.yml

# List Replicasets
kubectl get po
kubectl get svc
kubectl get sc
kubectl get pvc
kubectl get pv
kubectl get deploy
kubectl get ConfigMap

# Get the my sql pod name.

kubectl get pvc
kubectl get pv

# But if you go to the UI(portal.azure.com) you can still see the azure disk.

###################################################################################
# Get all Objects from Kubernetes default namespace
kubectl get all

###################################################################################

terraform plan -destroy -out main.destroy.tfplan

# terraform show main.destroy.tfplan

terraform apply main.destroy.tfplan

Remove-Item -Recurse -Force .terraform/modules

Remove-Item -Recurse -Force .terraform

Remove-Item terraform.tfstate

Remove-Item terraform.tfstate.backup

Remove-Item main.tfplan

Remove-Item main.destroy.tfplan

Remove-Item .terraform.lock.hcl
