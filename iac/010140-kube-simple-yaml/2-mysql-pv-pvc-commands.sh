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

kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\

# Or individually 
kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\01-storage-class.yml
kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\02-persistent-volume-claim.yml
kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\03-UserManagement-ConfigMap.yml
kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\04-mysql-deployment.yml
kubectl apply -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\05-mysql-clusterip-service.yml

# List Replicasets
kubectl get po
kubectl get svc
kubectl get sc
kubectl get pvc
kubectl get pv
kubectl get deploy
kubectl get ConfigMap

# Get the my sql pod name.
kubectl get pod mysql-7fc6f84c7b-jkhgh -o wide

kubectl describe pod mysql-7fc6f84c7b-jkhgh

kubectl logs -f mysql-7fc6f84c7b-jkhgh

# Create a new pod to connect to the existing my sql server running inside of cluster pod
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

kubectl exec -it mysql-7fc6f84c7b-jkhgh -- mysql -h mysql -pdbpassword11

show schemas # this woould not work. You should put semi colon(;) as well

show schemas;

kubectl delete -f .\kube-manifests\5-01-SC-PVC-ConfigMap-MySQL\

kubectl get pvc
kubectl get pv


# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the external ip
kubectl get svc myapp-pod-loadbalancer-service -o json | jq '.status.loadBalancer.ingress[].ip'

# Observe that the persitant volume is in released state
kubectl get pv pvc-8893b875-4eb4-485f-a2f8-ec3ee6376bc8 -o json | jq '.status.phase'

kubectl delete pv pvc-8893b875-4eb4-485f-a2f8-ec3ee6376bc8

# Since the pv is delete, the follwoing command will not give any result. 
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
