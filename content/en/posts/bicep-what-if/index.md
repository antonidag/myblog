---
title: Bicep What if deployment IaC
date: 2024-02-20T15:53:00+00:00
draft: false
description: 
---

## Background 
There is a lot of difference ways to make sure the right resources are deployed and changed. Most likely this is managed by peer reviews, however looking at code and determine the changes is not always that simple. How do you know whats being changed or created when you deploy infrastructure? 

In this blog we look into bicep what if deployments, and how they can help you making sure you are deploying the right thing! We will do this by creating a github action workflow by using the Azure cli to build, validate and make a what if deployment.  

## What is Bicep? 💪
To the world a bicep is a muscle, but in the world of Azure its a way to deploy resources to your subscription. Both bicep and ARM IaC and bicep templates are just and simpler "extension" to ARM. 

You can read more about these topics on the Microsoft bicep documentation.

## What is Az CLI? 

## Create bicep template & parameter file
Visual Code, with the Bicep extension will help with syntax and autocompletion and is loaded with many other features as well!
Github action extension.

The resource we will use as an example is an Storage Account.
```
param location string
param storageName string
param kind string
param skuName string
param accessTier string

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  sku: {
    name: skuName
  }
  kind: kind
  name: storageName
  location: location
  properties: {
    accessTier: accessTier
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}
```

The bicepparm file can help you separate parameters from your deployment file like this:
```
using './main.bicep'

param location = 'northeurope'
param storageName = 'mystr123'
param kind = 'StorageV2'
param skuName = 'Standard_LRS'
param accessTier = 'Hot'
```

Great, now we have bicep template and parameters fill it with! 

## Something here

Before we create our Github Action workflow, we need to think about what we are trying to achieve?
We want create a safe, secure and pain-free deployment. Improve the quality and make it more transparent on what we deploying into the environment. In order to get there, we can do do the following: 
- __Build bicep template__

   *Why do we want to build our bicep template?* The reason for this prevent any syntax errors, circular dependencies and etc. In addition this will also help us identify other warnings such unused variables & hardcoded values.
- __Validate deployment__

  *Why should we validate the deployment?* template we want to make sure it can be deployed with out any issues,
- __What-if deployment__

  *Why use a what-if deployment?* Our last step before releasing this our Azure environment, we would like to get an report of the resources deployed, a `what if` deployment can help us with this
  
## Run az cli command locally
Let's star by reproducing the steps locally on our machine. If you have not already have install Azure CLI go ahead and download it, once install you will also need to install bicep extension. This can be install by simply running the following command: 

```
az bicep install
```
 You can run the following command in your terminal:
```
az bicep build --file main.bicep
```
After you have run command, if everything went fine a new file call `main.json` will be created. This is ARM template and you can read more about the relation between Bicep and ARM here.  

and this will be done by using the command `validate`:
```
az deployment group validate --resource-group ${{secrets.RG_NAME}} --name MyWhatIfDeployment --template-file main.bicep --parameters main.bicepparam
```

:
```
az deployment group what-if --resource-group {resourceGroupName} --name MyStorageDeployment --template-file main.bicep --parameters main.bicepparam
```

By make use of all of these commands we can catch any potential errors before it is time for release.

## Create Github Action pipeline