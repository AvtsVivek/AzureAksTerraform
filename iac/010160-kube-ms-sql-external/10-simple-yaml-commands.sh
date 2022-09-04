cd ../..

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/06-Azure-MySQL-for-AKS-Storage

# https://github.com/RicardoNiepel/azure-mysql-in-aks-sample


# cd into the directory.
cd ./iac/010160-kube-ms-sql-external

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

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-02-PODs-with-YAML

# Get pods
kubectl get pods -n kube-system

kubectl get pods -n default

kubectl get all -n default

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-03-ReplicaSets-with-YAML

###################################################################################

kubectl apply -f .\kube-manifests\1-external-service\01-kube-base-definition.yml

kubectl apply -f .\kube-manifests\

kubectl delete -f .\kube-manifests\

kubectl get svc

kubectl describe svc mysql

kubectl run -it --rm --image=mysql:5.7.22 --restart=Never mysql-client -- mysql -h vivek-hr-dev-vivek-mysql.mysql.database.azure.com -u mydbadmin@vivek-hr-dev-vivek-mysql -p Hare@123

kubectl delete -f .\kube-manifests\1-external-service\01-kube-base-definition.yml

kubectl get svc

# Replace Host Name of Azure MySQL Database and Username and Password
# db_username = "mydbadmin"
# db_password = "H@Sh1CoR3!"
kubectl run -it --rm --image=mysql:5.7.22 --restart=Never mysql-client -- mysql -h vivek-hr-dev-vivek-mysql.mysql.database.azure.com -u mydbadmin@vivek-hr-dev-vivek-mysql -p H@Sh1CoR3!

kubectl run -it --rm --image=mysql:5.7.22 --restart=Never mysql-client -- mysql -h temp-mysql-vivek.mysql.database.azure.com -u mydbadmin -p H@Sh1CoR3!

kubectl run -it --rm --image=mysql:5.7.22 -- /bin/bash

mysql> show schemas;
mysql> create database webappdb;
mysql> show schemas;
mysql> exit

kubectl get po -o wide

kubectl logs -f usermgmt-webapp-7554f95784-7rp78

###################################################################################

# Now browse to that External IP
http://<EXTERNAL-IP>
http://<EXTERNAL-IP>/hello

kubectl delete -f .\kube-manifests\4-service\

###################################################################################

# Get all Objects from Kubernetes default namespace
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
