---
title: "Optimize Azure Deployments: Bicep What-If for Seamless Operations"
date: 2024-02-20T15:53:00+00:00
draft: false
description: 
---

## Background 
There are many different ways to ensure that the right resources are deployed and changed. Most likely, this is managed by peer reviews. However, looking at code and determining the changes is not always a simple task. How do you know what's being changed or created when you deploy infrastructure?

In this blog, we'll delve into Bicep what-if deployments and how they can help you ensure that you are deploying the right thing! We will do this by creating a GitHub Action pipeline using the Azure CLI to build, validate, and perform a what-if deployment.

## Introducing Bicep 💪
Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. 

Read more about bicep in the official [documentation]() 

## What is Az CLI? ⌨️
The Azure Command-Line Interface (CLI) is a cross-platform command-line tool to connect to Azure and execute administrative commands on Azure resources. It allows the execution of commands through a terminal using interactive command-line prompts or a script. 

Read more about the az cli [here](somelink)

## Creating a safe, secure and predictable deployments ☔

__What we are trying to achieve?__
We aim to create safe, secure, and pain-free deployments while improving quality and transparency. There's no silver bullet, so these are just some steps you could take to enhance your deployments to Azure:
- __Build the bicep template__

  *Why do we want to build our bicep template?* Ensuring there are no syntax errors, circular dependencies, etc. Additionally, this step will help identify other warnings, unused variables, and hardcoded values.
- __Validate the deployment__

  *Why should we validate the deployment?* This ensures that the template is valid for the resource group. 
- __Make an What-if deployment__

  *Why use a What-If deployment?* Before deploying the Bicep template, we can preview the changes. This additional extra step ensures the right resources are deployed and provides a safety net for potential issues.
 
  

## Building Bicep Templates 🏗️

Create a new file `main.bicep` and past in the code below:
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
This template will deploy a `Storage Account` of some kind, depending on the parameters used as input. 

Create a other file and name it `main.bicepparm`. A bicepparm file are used for parameterize your `main.bicep` template:
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
After you have run command, if everything went fine a new file `main.json` will be created. 


__Step 4:__ Validate the deployment
```
az deployment group validate --resource-group {resourceGroupName} --name MyWhatIfDeployment --template-file main.bicep --parameters main.bicepparam
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