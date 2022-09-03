cd ../..

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

# Ensure that the storageClassName in the below file is managed-premium
kubectl apply -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\01-persistent-volume-claim.yml


kubectl get pvc
# A PVC will be created but will be in pending state. Also take a look at portal.azure.com. 
# You will not see any azure disk yet.

kubectl get pv

kubectl apply -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\02-UserManagement-ConfigMap.yml

kubectl get ConfigMap

kubectl apply -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\03-mysql-deployment.yml

kubectl get deploy
kubectl get po
kubectl get ConfigMap
kubectl get pvc
# Notice a pvc is present with Bound Status.

kubectl get pv
# Now observe that a PV is ready. Also take a look at Azure Portal for Azure disk.

kubectl delete -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\03-mysql-deployment.yml

kubectl get pvc
# Notice a pvc is still present with Bound Status.

kubectl get pv
# So is a pv. 

# Now delete cofig map and pvc. 
kubectl delete -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\02-UserManagement-ConfigMap.yml
kubectl delete -f .\kube-manifests\5-10-PVC-ConfigMap-MySQL\01-persistent-volume-claim.yml

# Once the pvc is delete, wait for a minute. 
kubectl get pvc

# Now check, pv as well as go to the portal and check for the disk. That should also get deleted.
kubectl get pv

# List Replicasets
kubectl get po
kubectl get svc
kubectl get sc
kubectl get pvc
kubectl get pv
kubectl get deploy
kubectl get ConfigMap

kubectl get all


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
