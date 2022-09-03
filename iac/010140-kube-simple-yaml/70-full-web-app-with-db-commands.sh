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

kubectl apply -f .\kube-manifests\5-30-full-web-app-with-db

kubectl get pvc
# A PVC will be created but will be in bound state. A disk should now be provisioned.

kubectl get pv
kubectl get deploy
kubectl get po
kubectl get ConfigMap
kubectl get pvc
# Notice a pvc is present with Bound Status.
kubectl get pv
# So is a pv. 

# Now check, pv as well as go to the portal and check for the disk.

# Get the pod of the web app.
kubectl get po

kubectl describe pod usermgmt-webapp-6ff7d7d849-5z6ms

kubectl logs -f usermgmt-webapp-6ff7d7d849-5z6ms

# You can connect to the my sql in two ways.
# 1. Create a new pod to connect to the existing my sql server running inside of cluster pod
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

# Or else, just get into the existing pod.
# 2. First get the pod name.
kubectl get po
kubectl exec -it mysql-7fc6f84c7b-7wnl4 -- mysql -h mysql -pdbpassword11

show schemas # this woould not work. You should put semi colon(;) as well

show schemas;

kubectl get all

# Run the following ommand and get the EXTERNAL-IP of the usermgmt-webapp-service web app.
kubectl get svc

# Next browse to 
# http://<EXTERNAL-IP>/login
# Now login with admin101 and password101

kubectl exec -it mysql-7fc6f84c7b-7wnl4 -- mysql -h mysql -pdbpassword11
show schemas;
use webappdb;
show tables;
select * FROM user;
select * FROM user_role;

kubectl delete -f .\kube-manifests\5-30-full-web-app-with-db

# Now since the data is persisted to the azure disk, the data must not be lost. 
# So run the application again. 
kubectl apply -f .\kube-manifests\5-30-full-web-app-with-db

# Get the sql db pod name
kubectl get po

# Next get into the pod to verify the users you created earlier exist.
kubectl exec -it mysql-7fc6f84c7b-d8h85 -- mysql -h mysql -pdbpassword11
show schemas;
use webappdb;
show tables;
select * FROM user;
select * FROM user_role;

# Not sure why the data is not persisteing. Probalby, the database is bering created everytime. when the pod is getting created. Not sure.




# But if you go to the UI(portal.azure.com) you can still see the azure disk.
####################################################################################
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
