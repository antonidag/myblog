---
title: Bicep What if deployment IaC 
date: 2023-11-22T15:53:00+00:00
draft: true
description: 
---

## Background
How do you know whats being changed when you deploy infra structure? 
There is a lot of difference ways to make sure the right resources are deplyed and changed. Most likely this is managed by peer reviews, however looking at code and determine the changes is not always that simple. 


In this blog we look into bicep what if deployments, and how they can help you making sure you are deploying the right thing! We will also create a github action using the Azure cli to iniziate the what if deployment.  
## What is Bicep?  
To the world a bicep is a muscle, but in the world of Azure its a way to deploy resources to your subscription. Both bicep and ARM IaC and bicep templetes are just and simpler "extension" to ARM. 

When working with biceps you will run into a the following: 
- resources 
  - is the Azure Resource you want to deploy
- bicep module 
  - is a reuseable competent that can be used along with parameters to deploy one or many resources. 
- main bicep file
  - often referred to the file that orchestrates all of your deployments
- parameters
     - json files
     - bicepparm file 

You can read more about these topics on the Microsoft bicep documentation.

## Github actions what if deployment pipeline


