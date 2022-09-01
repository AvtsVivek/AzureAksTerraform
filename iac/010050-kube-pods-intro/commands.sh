cd ../..

# cd into the directory.
cd ./iac/010050-kube-pods-intro

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

az aks get-credentials --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --admin

az aks get-credentials --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster

az aks get-credentials --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --overwrite-existing

kubectl cluster-info

# If you want to logout or unset, use the following.
# kubectl config unset current-context

kubectl get nodes

kubectl get nodes -o wide

az aks show --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster

# When asked, use the following creds
# --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
# --password @AKSDemo123

kubectl cluster-info

az aks nodepool list

az aks nodepool list --resource-group aks-tf-trial1-rg-dev --cluster-name aks-tf-trial1-rg-dev-aks-cluster -o table

kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

# The following should show msi
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

# If you want to delete a pod
kubectl delete pod aci-connector-linux-fcd85b789-7q6m2 -n kube-system

# Observe the output. You will see the aci-connector-linux-686f8748cc-7fld5 pod is not able to start.
# So look at the logs. Ensure you have the connect pod name below
kubectl logs -f aci-connector-linux-54fb76ccd-m5xct -n kube-system

kubectl delete pod aci-connector-linux-54fb76ccd-m5xct -n kube-system

# Creating a pod.
kubectl run my-first-pod --image avts/nginxvivek:v1

# in case you want to delete.
kubectl delete pod/my-first-pod

kubectl get pods

kubectl get pod -o wide

kubectl get po

kubectl describe po my-first-pod

# In case you want to delete.
kubectl delete po my-first-pod

kubectl get po -n default

# Ensure the pod is there, in case you deleted.
kubectl run my-first-pod --image avts/nginxvivek:v1

kubectl get po -n default

# Now the Expose the Pod as a Service(Nodeport, not as LoadBalancer) so that, we can access this from outside.
# kubectl expose pod <Pod-Name>  --type=NodePort --port=80 --name=<Service-Name>

kubectl expose pod my-first-pod  --type=NodePort --port=80 --name=my-first-service

# Now observe the service that gets created.
kubectl get service

kubectl describe service my-first-service

# Notice that there is no external ip address associted with this service.
# That is because the service is of NodePort and not LoadBalancer
kubectl get service my-first-service -o wide

# So delete this service.
kubectl delete service my-first-service

# Now create it again, this time set the type as LoadBalancer instead of NodePort
kubectl expose pod my-first-pod  --type=LoadBalancer --port=80 --name=my-first-service

# This time, you should see an Extenal ip address. Wait for a minute, else you will see pending for External-ip
kubectl get service

kubectl get service -o wide

kubectl describe service my-first-service

kubectl get ns

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
