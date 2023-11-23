---
title: Turing Logic App into a simple web server (SSR)
date: 2023-11-17T12:45:23+01:00
draft: false
description: test
---


# Intro
Its fun to challenge yourself and push the bounders of what and how things could be done, therefore we will build simple web app for submitting registration to an event with only Logic Apps (Standard) resources.

Since Logic Apps does not really support this kind of use case it comes with a few challenges, however it can still be done! :slimily_face:

## Background
Before we head into Logic App development I think it is important to understand the fundamentals of web server works and server side rendering, because thats whats we need to solve. 

### Web Server 
A simple way to explain a web server is a host that serves files to clients and this is done by through the [HTTP protocol]().
The client makes a request to web server, the web server can either response with the file or if something went bad happened return a error response.
This way of hosting web sites is in common words called a static site.

Gif img to show the it works...

### Server Side Rendering
SSR often refers to when a webpage is generated each time a client requests it. In other words, a page returned to the client at request time is a server-side rendered webpage. Compared to static site where pages are pre-generated. [](https://dev.to/ebereplenty/server-side-rendering-ssr-vs-static-site-generation-ssg-214k)

Gif img to explain how it works.

There is a lot more to be said about this topic and since this is not an blog post regarding web server & SSR, I think this general understanding about the concepts will be enuf to continue.

## Turing Logic App into a web app 
Since Logic Apps does not provide this funcunallity out of the box, we will need to mimic a web server. 

How can we achieve this? Easy. 
Create a new workflow, choose sateless. We are choosing stateless to keep the response times low and fast. As a trigger for the workflow "Request" -> "When a request is received" and then the action "Request" -> "Response" in the end of our workflow. The last action will be the actual "page" returned to the client with the html content.

Img show how this is done.

In the "Response" action the following settings is applied: 
Content-Type: text/html
Body: <html>hello world</html>

If we get the workflow url and paste that in a browser it will look something like this:
img on how it looks.

Yay, we have created simple web server using SSR! :emorey:


Now let's create a html form with a submit button 


How should we serve html, css and javascript? 
Logic Apps is not really built for this kind of behavior, however we can somewhat mimic this func by using the trigger action on Request and action response to return html. 

Since all content has to be loaded before we give the client the response back, lazy loading and speed is something we have to try and optimize in this solution.