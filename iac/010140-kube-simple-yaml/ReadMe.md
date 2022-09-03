## Aks cluster without Ad integration.

- This is exactly [ame as the previous one](https://github.com/AvtsVivek/AzureAksTerraform/tree/main/iac/010080-kube-replica-sets) 

- This talks about deployments, a hiher abstraction of replicasets.

- The exercise 5-01-PVC-ConfigMap-MySQL uses system provisioned storage classes.
  - 
- Storage Class. A storage class in k8s represent storage/disk where data can be stored as required by the applications running in k8s.
  - Using storage class object in k8s, we can configure this storage, such as 
    - provisioner: kubernetes.io/azure-disk
    - reclaimPolicy: Retain  # Default is Delete, recommended is retain
    - volumeBindingMode: WaitForFirstConsumer # Default is Immediate, recommended is WaitForFirstConsumer
    - allowVolumeExpansion: true  
    - parameters:
    - storageaccounttype: Premium_LRS # or we can use Standard_LRS
    - kind: managed # Default is shared (Other two are managed and dedicated)
- Persistant Volume Claim. 
  - Its like a requisition for a strorage. 
  - By this object, we state the need for a pirticular type of storage. 
  - This may get fulfilled, or this may not get fulfilled if not available.
  - It is here we state what type of storage class we need by specifying storage class.
    - storageClassName: managed-premium-retain-sc
- Persistant Volume
  - Its the object that represents the provisioned strorage by k8s.
  - So the developer expresses his requirement using Persistant Volume Claim(not by Persistant Volume pv)
  - And when it is fullfilled, it appears as Persistant Volume, pv. So when a **PVC** is fullfilled, it appears as **PV**
  - 