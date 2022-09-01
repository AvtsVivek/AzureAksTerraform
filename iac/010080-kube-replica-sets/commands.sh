cd ../..

# cd into the directory.
cd ./iac/010080-kube-replica-sets

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

# If you want to delete a pod
kubectl delete pod aci-connector-linux-fcd85b789-7q6m2 -n kube-system

# If you want to look at the logs. Ensure you have the connect pod name below
kubectl logs -f aci-connector-linux-54fb76ccd-m5xct -n kube-system

# kubectl create -f kube-manifests/replicaset-demo.yml
kubectl apply -f .\kube-manifests\

kubectl get replicaset

kubectl get rs

kubectl describe rs/my-helloworld-rs

kubectl describe rs my-helloworld-rs

# You should now see 6(replicas: 6 in the kube manifest file)
kubectl get po -o wide

kubectl get po -n default

# Test how the high availability or reliability concept is achieved automatically in Kubernetes
# Whenever a POD is accidentally terminated due to some application issue, 
# ReplicaSet should auto-create that Pod to maintain desired number of Replicas configured to achive High Availability.
# So to test that, just delete a pod. Get the name of any pod from the list and then delete it as follows.

kubectl delete pod my-helloworld-rs-7xwp9 

# Now observe again, a new pod will be created. Verify Age and name of new pod
kubectl get po -o wide

# Now we can test how scalability is going to happen seamlessly & quickly
# Update the replicas field in replica-set.yaml from 3 to 6.

# Apply latest changes to ReplicaSet, I think, you can use apply as well instead of replace.
kubectl replace -f .\kube-manifests\replica-set.yaml

kubectl get po -o wide

kubectl get rs
kubectl get svc

# Expose the replicaset as a service 
# Note here the type is LoadBalancer and NOT NodePort
kubectl expose rs my-helloworld-rs  --type=LoadBalancer --port=80 --target-port=8080 --name=my-helloworld-rs-service

# Now observe the service that gets created. Get the EXTERNAL-IP, but before that wait for a minute, else it will show pending.
# Also go to the portal, inside of the resource group aks-tf-trial1-rg-dev-nrg, you should see two public ips.
kubectl get service

# Now browse to that external ip
http://<External-IP-from-get-service-output>/hello
20.204.213.117/hello

kubectl describe service my-helloworld-rs-service

# Notice that there is no external ip address associted with this service.
kubectl get service my-helloworld-rs-service -o wide

kubectl get ns

# Now clean up
# Time to clean up so delete this service.
kubectl delete service my-helloworld-rs-service

# Once deleted, go to the portal, inside of the resource group aks-tf-trial1-rg-dev-nrg, you should see now only one public ip.
# The other one should be gone.

# Get all Objects in default namespace
kubectl get all

kubectl delete rs my-helloworld-rs

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
