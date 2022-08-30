
cd ../..

# cd into the directory.
cd ./iac/010050-basic-aks-tf

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
az aks get-credentials --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster --admin

az aks get-credentials --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster

az aks get-credentials --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster --overwrite-existing

kubectl cluster-info

# If you want to logout or unset, use the following.
# kubectl config unset current-context

kubectl get nodes

az aks show --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster

# When asked, use the following creds
# --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
# --password @AKSDemo123

kubectl cluster-info

az aks nodepool list

az aks nodepool list --resource-group terraform-aks-dev --cluster-name terraform-aks-dev-aks-cluster -o table

kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

az aks show --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster --query servicePrincipalProfile

# az aks enable-addons ^
#     --resource-group terraform-aks-dev ^
#     --name terraform-aks-dev-aks-cluster ^
#     --addons virtual-node ^
#     --subnet-name %AKS_VNET_SUBNET_VIRTUALNODES%

# Why is the following giving empity array? Not sure. Need to find out.
az identity list --resource-group terraform-aks-dev-nrg

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
