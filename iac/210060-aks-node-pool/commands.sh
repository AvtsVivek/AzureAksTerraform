
cd ../..

# cd into the directory.
cd ./iac/210060-aks-node-pool

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

az aks show --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster

kubectl cluster-info

# If you want to logout or unset, use the following.
# kubectl config unset current-context

# For the following command kubectl get nodes You get the following three.
# aks-linux101-26033225-vmss000000     Ready    agent   5m39s   v1.24.3
# aks-systempool-31232772-vmss000000   Ready    agent   10m     v1.24.3
# akswin101000000                      Ready    agent   5m28s   v1.24.3
kubectl get nodes



# When asked, use the following creds
# --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
# --password @AKSDemo123

kubectl cluster-info

az aks nodepool list

# The following will give three node pools

# linux101    Linux     1.24.3               Standard_DS2_v2  1        30         Succeeded            User  
# systempool  Linux     1.24.3               Standard_DS2_v2  1        30         Succeeded            System
# win101      Windows   1.24.3               Standard_DS2_v2  1        30         Succeeded            User 

az aks nodepool list --resource-group terraform-aks-dev --cluster-name terraform-aks-dev-aks-cluster -o table

kubectl get nodes -o wide
kubectl get nodes -o wide -l nodepoolos=linux
kubectl get nodes -o wide -l nodepoolos=windows
kubectl get nodes -o wide -l environment=dev

kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

# The following should show msi
az aks show --resource-group terraform-aks-dev --name terraform-aks-dev-aks-cluster --query servicePrincipalProfile

# az aks enable-addons ^
#     --resource-group terraform-aks-dev ^
#     --name terraform-aks-dev-aks-cluster ^
#     --addons virtual-node ^
#     --subnet-name %AKS_VNET_SUBNET_VIRTUALNODES%

# Why is the following giving empity array? Not sure. Need to find out(some times).

# httpapplicationrouting-terraform-aks-dev-aks-cluster
# omsagent-terraform-aks-dev-aks-cluster
# azurepolicy-terraform-aks-dev-aks-cluster
# terraform-aks-dev-aks-cluster-agentpool
az identity list --resource-group terraform-aks-dev-nrg

# Get pods
kubectl get pods -n kube-system

# If you want to delete a pod
kubectl delete pod aci-connector-linux-fcd85b789-7q6m2 -n kube-system

# Observe the output. You will see the aci-connector-linux-686f8748cc-7fld5 pod is not able to start.
# So look at the logs. Ensure you have the connect pod name below
kubectl logs -f aci-connector-linux-54fb76ccd-m5xct -n kube-system

# Now deploy the apps.

kubectl apply -R -f .\kube-manifests\

# After the following command, please wait. The windows app will take time(3-10 minutes).
kubectl get pods

kubectl get pods -o wide

kubectl get svc

# Take note of the EXTERNAL-IPs. See the image 2_AzureAksDeployedApps.jpg
# Now browse to each of the extenal ips

kubectl delete pod aci-connector-linux-54fb76ccd-m5xct -n kube-system

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
