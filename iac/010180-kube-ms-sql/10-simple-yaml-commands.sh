cd ../..

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/06-Azure-MySQL-for-AKS-Storage

# https://github.com/RicardoNiepel/azure-mysql-in-aks-sample

# cd into the directory.
cd ./iac/010180-kube-ms-sql

terraform fmt

terraform init

terraform validate

terraform plan -var-file="secrets.tfvars" -out main.tfplan

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

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-02-PODs-with-YAML

# Get pods
kubectl get pods -n kube-system

kubectl get pods -n default

kubectl get all -n default

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-03-ReplicaSets-with-YAML

###################################################################################

# kubectl apply -f .\kube-manifests\01-mysql-external-service.yml

# kubectl get svc

# kubectl describe svc mysql

kubectl run -it --rm --image=mcr.microsoft.com/mssql-tools --restart=Never mssql-client 

sqlcmd -S hr-dev-ms-sql-server.database.windows.net -U adm1n157r470r -P 4-v3ry-53cr37-p455w0rd

select name from sys.databases

GO

Ctrl + C

exit

# kubectl run -it --rm --image=mcr.microsoft.com/mssql-tools --restart=Never mssql-client sqlcmd -S hr-dev-ms-sql-server.database.windows.net -U adm1n157r470r -P 4-v3ry-53cr37-p455w0rd -Q 'select name from sys.databases'

###################################################################################

kubectl get all

###################################################################################

terraform plan -destroy -out main.destroy.tfplan -var-file="secrets.tfvars"

# terraform show main.destroy.tfplan

terraform apply main.destroy.tfplan

Remove-Item -Recurse -Force .terraform/modules

Remove-Item -Recurse -Force .terraform

Remove-Item terraform.tfstate

Remove-Item terraform.tfstate.backup

Remove-Item main.tfplan

Remove-Item main.destroy.tfplan

Remove-Item .terraform.lock.hcl
