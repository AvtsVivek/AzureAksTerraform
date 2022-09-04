## Aks cluster without Ad integration.

# Tried the following as well, but did not work.

az group create --name myAKSMySQLResourceGroup --location westeurope

az acr create --resource-group myAKSMySQLResourceGroup --name vivekaksmysqlacr --sku Basic

az acr show --name vivekaksmysqlacr

az aks create --resource-group myAKSMySQLResourceGroup --name myAKSMySQLCluster --vm-set-type VirtualMachineScaleSets --nodepool-name noaccpool --node-count 1 --node-vm-size Standard_D2s_v3 --generate-ssh-keys --attach-acr vivekaksmysqlacr --load-balancer-sku standard

az aks nodepool add --resource-group myAKSMySQLResourceGroup --cluster-name myAKSMySQLCluster --name accpool --node-count 1 --node-vm-size Standard_DS2_v2

az vmss list -g MC_myAKSMySQLResourceGroup_myAKSMySQLCluster_westeurope -o table

az mysql server create --resource-group myAKSMySQLResourceGroup --name myaksmysqldemoserver  --location westeurope --admin-user myadmin --admin-password H@Sh1CoR3! --sku-name GP_Gen5_2

az network vnet show -g MC_myAKSMySQLResourceGroup_myAKSMySQLCluster_westeurope --name aks-vnet-16903398

az network vnet subnet update -n aks-subnet --vnet-name aks-vnet-16903398 -g MC_myAKSMySQLResourceGroup_myAKSMySQLCluster_westeurope --service-endpoints Microsoft.SQL

az mysql server vnet-rule create -g myAKSMySQLResourceGroup -s myaksmysqldemoserver -n vnetRuleName --subnet /subscriptions/{YourSubscriptionId}/resourceGroups/MC_myAKSMySQLResourceGroup_myAKSMySQLCluster_westeurope/providers/Microsoft.Network/virtualNetworks/aks-vnet-16903398/subnets/aks-subnet

az aks get-credentials --resource-group myAKSMySQLResourceGroup --name myAKSMySQLCluster --overwrite-existing

kubectl run -it --rm --image=mysql:5.7.22 --restart=Never mysql-client -- mysql -h myaksmysqldemoserver.mysql.database.azure.com -u myadmin@myaksmysqldemoserver -p H@Sh1CoR3!
