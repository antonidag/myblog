---
title: Bicep What if deployment IaC
date: 2024-02-20T15:53:00+00:00
draft: false
description: 
---

## Background
How do you know whats being changed when you deploy infra structure? 
There is a lot of difference ways to make sure the right resources are deployed and changed. Most likely this is managed by peer reviews, however looking at code and determine the changes is not always that simple. 


In this blog we look into bicep what if deployments, and how they can help you making sure you are deploying the right thing! We will also create a github action using the Azure cli to initiated the what if deployment.  
## What is Bicep? 💪
To the world a bicep is a muscle, but in the world of Azure its a way to deploy resources to your subscription. Both bicep and ARM IaC and bicep templates are just and simpler "extension" to ARM. 

You can read more about these topics on the Microsoft bicep documentation.

## Github actions what if deployment workflow
In this section we will go thru the steps to of setting a Github Action workflow and make use of:
- build
- validation,
- what if deployments
To improve the quality of your bicep files and ensure safe, secure deployments. 
### Tools
Let's start by getting our tools update. If you have not already have install Azure CLI, once install you will also need to install bicep extension. 
This can be install by simply running the following command: 
```
az bicep install
```
Visual Code, with the Bicep extension will help with syntax and autocompletion and is loaded with many other features as well!

### Create bicep template & parameter file
```
touch main.bicep
```
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
```
touch main.parm.bicepparam
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

### Running az commands
Let's continue and make the steps manually first before we create our Github Action.
We would fist like to build our bicep template to make sure we did not make any syntax errors or other errors.
```
az bicep build --file main.bicep
```
Then we can get into the next step, before we deploy this template we want to make sure it can be deployed with out any issues, and this will be done by using the command `validate`:
```
az deployment group validate --resource-group ${{secrets.RG_NAME}} --name MyWhatIfDeployment --template-file main.bicep --parameters main.bicepparam
```

Our last step before releasing this our Azure environment, we would like to get an report of the resources deployed, a `what if` deployment can help us with this:
```
az deployment group what-if --resource-group {resourceGroupName} --name MyStorageDeployment --template-file main.bicep --parameters main.bicepparam
```

By make use of all of these commands we can catch any potential errors before it is time for release.

### Create Github Action workflow