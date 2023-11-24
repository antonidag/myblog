---
title: "Exploring Logic App: SSR for Dynamic Web Apps"
date: 2023-11-17T12:45:23+01:00
draft: false
description: Logic App, a service designed for  integrations and business processes. But in this post we will be transforming Logic Apps into a engaging web experience by using server-side rendering (SSR).
---


## Background
Logic Apps is great tool for integrating business processes and can be used for multiple different use cases, however building a web pages is not one of them! As tech savy guy I find it fun to challenge myself to think out side box, therefore we will build simple web app for submitting registration to an event with only [Logic Apps (Standard)](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) resources.

Since Logic Apps does not really support this kind of use case it will come with a few challenges, however it can still be done! ⚒️

Before we head into Logic App development I think it is important to understand the fundamentals of how a web server works and server side rendering, because that is what we are going to need order to get this to work.

### Web Server 💻
A simple way to explain a web server is a host that serves files to clients and that the communication between the client and server is done through the [HTTP protocol](https://developer.mozilla.org/en-US/docs/Glossary/HTTP).
The client makes a request to web server, the web server can either response with the file or if something went bad happened return a error response. [📖](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_web_server)
This simple way of hosting webpages is normally referred to whats called a static site. 

Gif img to show the it works...

### Server Side Rendering
SSR often refers to when a webpage is generated each time a client requests it. In other words, a page returned to the client at request time is a server-side rendered webpage. Compared to static site where pages are pre-generated. [📖](https://dev.to/ebereplenty/server-side-rendering-ssr-vs-static-site-generation-ssg-214k)

Gif img to explain how it works.

There is a lot more to be said about this topic and since this is not an blog post about web server & SSR, I think this general understanding about the concepts will be enuf to continue.

### Responsiveness  
When building web apps or anything user related, the less time a user waits the better it is. Logic Apps is perhaps not know for its fast and optimized operations it does have something up its sleeves stateless workflows... 


## Turing Logic App into a web app 🌐
As menton earlier Logic Apps does not have this funcunallity out of the box, but it can sure be created! 

How do we achieve this?
Logic Apps provide built-in HTTP actions to both react on incoming request and return a response back to the client. This means that we somewhat have the basics of a web server. 
We also want to present dynamic content on our webpage, and for this we can use Liquid. [DotLiquid](https://github.com/dotliquid/dotliquid) is a .NET port of the popular open source project [Liquid](https://shopify.github.io/liquid/), and comes as built-in action in Logic Apps. 

As of now we have a way to communicate to the clients and present dynamic content, I think we ready to start development!

Each page will live inside of a workflow. In our case we will need to create three workflows:
- a workflow page that save/store data and confirms the user registration  
- a workflow page where the user can submit their registration
- a workflow page where user can view registrations



Create a new workflow for the registration page, choose sateless. We are choosing stateless to keep the response times low and fast. As a trigger for the workflow "Request" -> "When a request is received" and then the action "Request" -> "Response" in the end of our workflow. The last action will be the actual "page" returned to the client with the html content.

Img show how this is done.

In the "Response" action the following settings is applied: 
Content-Type: text/html
Body:
```
<!DOCTYPE html>
<html>
<body>

<h1>Hello,</h1>
<p>world!</p>

</body>
</html>
```

If we get the workflow url and paste that in a browser it will look something like this:
img on how it looks.

Yay, we have created simple web server using SSR! :emorey:


Now let's create a html form with a submit button 

```
<html></html>
```

