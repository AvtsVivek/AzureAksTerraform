cd ../..

# cd into the directory.
cd ./iac/010090-kube-deploy

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

# When asked, use the following creds
# --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
# --password @AKSDemo123

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

# Create Deployment
# kubectl create deployment <Deplyment-Name> --image=<Container-Image>
kubectl create deployment my-first-deployment --image=avts/nginxvivek:v1

# Verify Deployment
kubectl get deployments
kubectl get deploy 

# Describe Deployment
kubectl describe deployment my-first-deployment

# Verify ReplicaSet
kubectl get rs

# Verify Pod
kubectl get po

kubectl get replicaset

kubectl get rs

kubectl describe rs/my-first-deployment-55d5896678

kubectl describe rs my-first-deployment-55d5896678

# Verify Deployment
kubectl get deploy -o wide

# Scale the deployment to increase the number of replicas (pods)
# Scale Up the Deployment
# kubectl scale --replicas=10 deployment/<Deployment-Name>
kubectl scale --replicas=10 deployment/my-first-deployment 

# Verify Deployment
kubectl get deploy -o wide

# Verify ReplicaSet
kubectl get rs

# Verify Pods
kubectl get po

# Scale Down the Deployment
kubectl scale --replicas=2 deployment/my-first-deployment 
kubectl get deploy



# Expose the replicaset as a service 
# But before that, go to the portal, inside of the resource group aks-tf-trial1-rg-dev-nrg, you should see one public ip.
# Also note the services
kubectl get svc
# Note here the type for the expose is LoadBalancer and NOT NodePort

kubectl expose deployment my-first-deployment --type=LoadBalancer --port=80 --target-port=80 --name=my-first-deployment-service

# Get Service Info
kubectl get svc

# Now observe the service that gets created. Get the EXTERNAL-IP, but before that wait for a minute, else it will show pending.
# Also go to the portal, inside of the resource group aks-tf-trial1-rg-dev-nrg, you should see two public ips, instead of earlier one.
kubectl get svc

kubectl get deploy my-first-deployment -o yaml

kubectl get deploy my-first-deployment -o json

kubectl delete svc my-first-deployment-service

kubectl delete deploy my-first-deployment

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following 
kubectl get deploy my-first-deployment -o json | jq '.spec.template.spec.containers[0].name'
# This should give the container name. Note that. So the <container-name> is nginxvivek
# Replace <container-name> with nginxvivek
# kubectl set image deployment/my-first-deployment <container-name>
kubectl set image deployment/my-first-deployment nginxvivek=avts/nginxvivek:v2

# https://github.com/stacksimplify/kubernetes-fundamentals/tree/master/04-Deployments-with-kubectl/04-03-Rollback-Deployment

# Get the External Ip from the svc. 
kubectl get svc
# Then browse to that ip. You should see Version 2.

# Next update that to 3
kubectl set image deployment/my-first-deployment nginxvivek=avts/nginxvivek:v3
# Get the External Ip from the svc. 
kubectl get svc
# Then browse to that ip. You should see Version 3.

# Next update that to 4
kubectl set image deployment/my-first-deployment nginxvivek=avts/nginxvivek:v4
# Get the External Ip from the svc. 
kubectl get svc
# Then browse to that ip. You should see Version 3.

# Observe the events
kubectl describe deployment/my-first-deployment

# Also look at the replica sets.
kubectl get rs

# Verify Rollout Status 
kubectl rollout status deployment/my-first-deployment

# Verify Deployment
kubectl get deploy

# Check the Rollout History of a Deployment
kubectl rollout history deployment/my-first-deployment  

# Check the status
kubectl rollout status deployment/my-first-deployment  

# Edit Deployment
kubectl edit deployment/my-first-deployment --record=true

# Observe the events
kubectl describe deployment/my-first-deployment

# Also look at the replica sets.
kubectl get rs

kubectl rollout status deployment/my-first-deployment  

# Now RollBack deployments.

# First take a look at history
kubectl rollout history deployment/my-first-deployment  

kubectl rollout history deployment/my-first-deployment --revision=6

# Undo Deployment
kubectl rollout undo deployment/my-first-deployment

# Rollback Deployment to Specific Revision
kubectl rollout history deployment/my-first-deployment  
kubectl rollout undo deployment/my-first-deployment --to-revision=9

# List Deployment Rollout History
kubectl rollout history deployment/my-first-deployment  

# Rolling restarts will kill the existing pods and recreate new pods in a rolling fashion.
kubectl rollout restart deployment/my-first-deployment  

# https://github.com/stacksimplify/kubernetes-fundamentals/tree/master/04-Deployments-with-kubectl/04-04-Pause-and-Resume-Deployment

# Pause the Deployment
kubectl rollout pause deployment/my-first-deployment

kubectl set image deployment/my-first-deployment nginxvivek=avts/nginxvivek:v1

# Check the Rollout History of a Deployment
# No new rollout should start, we should see same number of versions as 
# we check earlier with last version number matches which we have noted earlier.
kubectl rollout history deployment/my-first-deployment  

# No new replicaSet created. We should have same number of replicaSets as earlier when we took note. 
kubectl get rs

# Resume the Deployment
kubectl rollout resume deployment/my-first-deployment

# Check the Rollout History of a Deployment
kubectl rollout history deployment/my-first-deployment  
# Observation: You should see a new version got created

# Get list of ReplicaSets
kubectl get rs
# Observation: You should see new ReplicaSet.

# Clean up

# Delete Deployment
kubectl delete deployment my-first-deployment

# Delete Service
kubectl delete svc my-first-deployment-service

# Get all Objects from Kubernetes default namespace
kubectl get all

##############################################################################

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
