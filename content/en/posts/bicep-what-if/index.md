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
In the world of Azure deployments it starts with ARM templates and now more recently bicep templates. Both ARM and bicep are IaC and bicep templetes are just and simpler "extension" to ARM. 

When working with biceps you will run into a the following: 
- resources 
- module 
- main bicep file
- parameters files

## Creating an what if pipeline


