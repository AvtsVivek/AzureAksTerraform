## Aks cluster without Ad integration.

- This is exactly [ame as the previous one](https://github.com/AvtsVivek/AzureAksTerraform/tree/main/iac/010050-kube-pods-intro) except for AD integration. 

- So the following is commented out in here.

```
azure_active_directory_role_based_access_control {
  managed = false
  azure_rbac_enabled = true
}
```

- And because of this, there are changes, See the images 

- Difference 1 
![Add Publish Profile](./images/4k8s-NoAdIntegration1.jpg)

- Difference 2. With Ad integration, the following are not available. 
![Add Publish Profile](./images/4k8s-NoAdIntegration2.jpg)

- Difference 3 
![Add Publish Profile](./images/4k8s-NoAdIntegration3.jpg)

- Difference 4 
![Add Publish Profile](./images/4k8s-NoAdIntegration4.jpg)

- Difference 5
![Add Publish Profile](./images/4k8s-NoAdIntegration5.jpg)

