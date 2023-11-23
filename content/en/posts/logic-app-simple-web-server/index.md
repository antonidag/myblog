---
title: Logic App as a simple web server (SSR)
date: 2023-11-23T15:53:00+00:00
draft: true
description: 
---


# Intro
Let's build simple web app to submit registration to an event with only Logic Apps (Standard) resources.

## Challenge

How should we serve html, css and javascript? 
Logic Apps is not really built for this kind of behavior, however we can somewhat mimic this func by using the trigger action on Request and action response to return html. 

Since all content has to be loaded before we give the client the response back, lazy loading and speed is something we have to try and optimize in this solution.