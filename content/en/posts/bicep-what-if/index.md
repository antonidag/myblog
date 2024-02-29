---
title: "Optimize Azure Deployments: Bicep What-If for Seamless Operations 
Azure Deployment Anxiety?😬 Try Bicep What-If for Instant Relief!🍾"
date: 2024-02-20T15:53:00+00:00
draft: false
description: 
---

## Background 
There is a lot of difference ways to make sure the right resources are deployed and changed. Most likely this is managed by peer reviews, however looking at code and determine the changes is not always that simple. How do you know whats being changed or created when you deploy infrastructure? 

In this blog we look into bicep what if deployments, and how they can help you making sure you are deploying the right thing! We will do this by creating a github action workflow by using the Azure cli to build, validate and make a what if deployment.  

## Introducing Bicep 💪
Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. 

Read more about bicep in the official [documentation]() 

## What is Az CLI? ⌨️
The Azure Command-Line Interface (CLI) is a cross-platform command-line tool to connect to Azure and execute administrative commands on Azure resources. It allows the execution of commands through a terminal using interactive command-line prompts or a script. 

Read more about the az cli [here](somelink)

## Creating a safe, secure and predictable deployments ☔

__What we are trying to achieve?__
We want create a safe, secure and pain-free deployment. In addition improve quality and make deployments more transparent. There is no silver bullet, therefor this is just some of steps you could take to improve your deployments to Azure: 
- __Build the bicep template__

   *Why do we want to build our bicep template?* The reason for this prevent any syntax errors, circular dependencies and etc. In addition this will also help us identify other warnings such unused variables & hardcoded values.
- __Validate the deployment__

  *Why should we validate the deployment?* template we want to make sure it can be deployed with out any issues,
- __Make an What-if deployment__

  *Why use a what-if deployment?* Our last step before releasing this our Azure environment, we would like to get an report of the resources deployed, a `what if` deployment can help us with this
  

## Building Bicep Templates 🏗️
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


## Executing az cli command locally 🏃‍♂️
Let's star by reproducing the steps locally on our machine. If you have not already have install Azure CLI go ahead and download it, once install you will also need to install bicep extension. This can be install by simply running the following command: 

```
az bicep install
```
__Step 1:__ Login in to Azure

```
az login
```
This will prompt you new window in your browser and let you log in your account.

__Step 2:__ Set the subscription
```
az account set --subscription {SUBSCRIPTION_ID} 
```
It makes thinks easier to set which subscription we are working with, so we do not accidental deploy to the wrong one.

__Step 3:__ Build bicep template 
```
az bicep build --file main.bicep
```
After you have run command, if everything went fine a new file call `main.json` will be created. 


__Step 4:__ Validate the deployment
```
az deployment group validate --resource-group ${{secrets.RG_NAME}} --name MyWhatIfDeployment --template-file main.bicep --parameters main.bicepparam
```

__Step 5:__ Make an What-if deployment
```
az deployment group what-if --resource-group {resourceGroupName} --name MyStorageDeployment --template-file main.bicep --parameters main.bicepparam
```

By make use of all of these commands we can catch any potential errors before it is time for release.

## Setting up Github Action pipeline ⚙️

```
name: Bicep What if deployment
on:
  workflow_dispatch:
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: DEV
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      
      - name: Set up Azure CLI
        uses: Azure/cli@v1.0.9
        with:
          inlineScript: true
          
      - name: Install Azure CLI Bicep extension
        run: az bicep install
      
      - name: Build Bicep file
        run: az bicep build --file main.bicep

      - name: Login to Azure
        run: az login --username ${{ secrets.AZURE_USERNAME }} --password '${{ secrets.AZURE_USER_PASSWORD }}' --tenant ${{ secrets.AZURE_TENANT_ID }}

      - name: Set Azure Subscription
        run: az account set --subscription ${{secrets.SUBSCRIPTION_ID}}
      
      - name: Validate Bicep Template
        run: az deployment group validate --resource-group ${{secrets.RG_NAME}} --name ValidateDeployment --template-file main.bicep --parameters main.bicepparam

      - name: What if deployment
        run: az deployment group what-if --resource-group ${{secrets.RG_NAME}} --name WhatIfDeployment --template-file main.bicep --parameters main.bicepparam
```