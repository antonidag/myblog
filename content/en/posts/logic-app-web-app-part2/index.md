---
title: "Logic App Web App v2"
date: 2025-07-01T00:00:00+01:00
draft: false
description: 
image: "posts/logic-app-web-app/clientwebserver.gif"
---


## Background
Last year I wrote an blog post about how Logic Apps Standard can be used as framework to build an web application, you can find the blog [here](/posts/logic-app-web-app). But that was more or less a proof of concept, idea, is this really possible. I did not look into other layers that is typical needed in your web application, and how these requirements can be solved to meet a more of an enterprise level. So in this blog post we will explore different topics of an web application and how these can be solved with Azure Services! 

## What really is an web application 💻
At its core, a web application is simply `HTML` and `JavaScript` code hosted on a web server. However, when you look deeper, you'll see that a web app consists of multiple technical components, such as:

- User Interface & Experience – How users interact with the app.
- Frontend & Backend – The logic driving both the visible and behind-the-scenes parts.
- Authentication & Authorization – Who gets in and what they can do.
- Performance & Scalability – Ensuring fast load times and handling increased traffic.
- Security – Protecting against threats like DDoS attacks, XSS, and SQL injection.
- and so on...

All these elements must work together to create a fully functional web application. Deploying and managing a web app for users across different locations requires additional infrastructure and careful design.

It is worth noting that if you are building a cutting-edge web application, Logic App Standard may not be your first choice as a primary framework since there is some limitations. However, if you find a scenario where it fits, there are some tips and tricks that could help you down the line!

## From browser to Logic App
If we look at it from a top-level perspective and work our way down, the entry point of the application will be __Azure Application Gateway__. From there, traffic will be routed to __Azure API Management__, and the final destination will be __Logic App Standard__ where most of implementation will happen.

<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22myapp.se%22%2C%22x%22%3A600%2C%22y%22%3A270%7D%2C%7B%22id%22%3A%22End-point-2%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Flogin%22%2C%22x%22%3A391%2C%22y%22%3A390%7D%2C%7B%22id%22%3A%22End-point-3%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fhome%22%2C%22x%22%3A601%2C%22y%22%3A392%7D%2C%7B%22id%22%3A%22End-point-4%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fsettings%22%2C%22x%22%3A803%2C%22y%22%3A394%7D%2C%7B%22id%22%3A%22API%20Management-5%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22%2Fext-myapp%22%2C%22x%22%3A601%2C%22y%22%3A541%7D%2C%7B%22id%22%3A%22Trigger-6%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20login%20request%20is%20received%22%2C%22x%22%3A376.452941037135%2C%22y%22%3A649.5956169029506%7D%2C%7B%22id%22%3A%22Logic%20App-7%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Web%20Application%22%2C%22x%22%3A600.8906415035528%2C%22y%22%3A925.8347176299218%7D%2C%7B%22id%22%3A%22Trigger-9%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20home%20request%20is%20received%22%2C%22x%22%3A601.0254170475325%2C%22y%22%3A648.7945249038028%7D%2C%7B%22id%22%3A%22Trigger-10%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20settings%20request%20is%20received%22%2C%22x%22%3A824.3494540224185%2C%22y%22%3A646.9308580458288%7D%2C%7B%22id%22%3A%22HTML-11%22%2C%22label%22%3A%22HTML%22%2C%22title%22%3A%22HTML%22%2C%22x%22%3A649.4732268254302%2C%22y%22%3A806.4551350526904%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__End-point-2-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-2%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-3-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-3%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-4-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-4%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-6%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-2%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-4%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-9%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-9%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-10%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-10%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-6-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-6%22%2C%22target%22%3A%22HTML-11%22%7D%2C%7B%22id%22%3A%22xy-edge__HTML-11-Logic%20App-7%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTML-11%22%2C%22target%22%3A%22Logic%20App-7%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-9-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-9%22%2C%22target%22%3A%22HTML-11%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-10-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-10%22%2C%22target%22%3A%22HTML-11%22%7D%5D%7D">

### How Routing Works
The routing flow is handled in three main steps:

- **Application Gateway** acts as the public entry point. It receives all incoming HTTP(S) requests, applies security rules (like WAF, SSL termination, and IP restrictions), and then forwards the requests to API Management. This layer can also handle basic path-based routing if needed.

- **API Management (APIM)** receives requests from the Application Gateway. APIM is responsible for mapping clean, user-friendly URLs (such as `/posts`) to the correct Logic App workflow endpoints. This is typically done using APIM policies or rewrite rules, which translate the incoming path to the full Logic App HTTP trigger URL (including required parameters and signatures). APIM can also enforce authentication, caching, and rate limiting at this stage.

- **Logic App Standard** is where the actual business logic and page rendering happen. APIM calls the appropriate Logic App workflow, which generates and returns the `HTML/JS` for the requested page.

*Why is this important?*

This approach keeps sensitive information, like the Logic App signature `sig` and other parameters hidden from the client. Users only see clean URLs, while APIM securely injects the necessary secrets and parameters when forwarding requests to Logic App service. This not only improves security but also makes navigation and linking much simpler.

## Frontend, backend or a bit of mix?
For those of you who have read my first blog post about Logic Apps as a Web App, you probably already know how it is done, but let's do a quick recap anyway.
Essentially, we use the request trigger together with the response action, making sure the ``Content-Type`` is set to ``text/html`` so the content displays properly in the browser—and that is pretty much it. If you want a more detailed breakdown, check out the implementation section [here].

The whole frontend/backend concept is a bit lost, but in some ways, this is not anything new or totally crazy. Server side rendering has been around for years, and if you look at frameworks like Blazor or Next.js, they play around with the same idea in their own way. One core difference is that modern tools like Blazor are built with this functionality in mind, offering a structured and integrated way to handle rendering and interactivity. In our case, it is more of an old-school approach to creating a web application leveraging Logic Apps in a way it was not originally designed for.

### How it is all structured
With this in mind, the method that I have put together follows a few core principles:

- __One page = one workflow__
- __Separate workflows for actions__ – Any action that is not an the typical `GET` method like edit, create, or delete should be handled in its own dedicated workflow, keeping page logic clean.
- __One Liquid template per page__ – Each page should have only one Liquid template to keep things structured and avoid unnecessary complexity.
  - Utilize the templates for more than basic headers, css, and body.
- __A workflow should always live on its own. Never return another workflows HTML content, redirect the user to that page instead__

- __Load dynamic content via an iframe__ – If a page requires dynamic content, use an `<iframe>` and create a separate workflow for that specific content.
  - For instance shared components like, menu, sidebar and footer can be created as separate workflows.  


### Page workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Trigger-2%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20an%20HTTP%20request%20is%20received%22%2C%22x%22%3A480%2C%22y%22%3A299%7D%2C%7B%22id%22%3A%22Action-3%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Transform%20%26%20compose%20HTML%20content%22%2C%22x%22%3A480%2C%22y%22%3A437%7D%2C%7B%22id%22%3A%22Action-6%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Return%20HTML%20to%20client%22%2C%22x%22%3A480%2C%22y%22%3A587%7D%2C%7B%22id%22%3A%22End-point-7%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Flogin%22%2C%22x%22%3A480%2C%22y%22%3A177%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__Trigger-2-Action-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-2%22%2C%22target%22%3A%22Action-3%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-7-Trigger-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-7%22%2C%22target%22%3A%22Trigger-2%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-3-Action-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Action-3%22%2C%22target%22%3A%22Action-6%22%7D%5D%7D">

## Action workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Trigger-2%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20an%20HTTP%20request%20is%20received%22%2C%22x%22%3A480%2C%22y%22%3A299%7D%2C%7B%22id%22%3A%22Action-3%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Call%20service%22%2C%22x%22%3A480%2C%22y%22%3A437%7D%2C%7B%22id%22%3A%22Action-4%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22On%20faliure%22%2C%22x%22%3A481%2C%22y%22%3A563%7D%2C%7B%22id%22%3A%22Action-4%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22On%20faliure%22%2C%22x%22%3A481%2C%22y%22%3A563%7D%2C%7B%22id%22%3A%22Action-5%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Redirect%20to%20page%22%2C%22x%22%3A592%2C%22y%22%3A683%7D%2C%7B%22id%22%3A%22Action-6%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Redirect%20to%20404%2F500%20page%22%2C%22x%22%3A360%2C%22y%22%3A684%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__Trigger-2-Action-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-2%22%2C%22target%22%3A%22Action-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-3-Action-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Action-3%22%2C%22target%22%3A%22Action-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-4-Action-5%22%2C%22middleLabel%22%3A%22false%22%2C%22source%22%3A%22Action-4%22%2C%22target%22%3A%22Action-5%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-4-Action-6%22%2C%22middleLabel%22%3A%22true%22%2C%22source%22%3A%22Action-4%22%2C%22target%22%3A%22Action-6%22%7D%5D%7D">


### Redirecting
Redirecting is when you automatically send the user to another part of the site, such as after a payment with a third-party provider. Since Logic App Request connector does not support HTTP 302 redirects and the `Location` header, the workaround is to return a simple HTML page with JavaScript:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Redirecting...</title>
  </head>
  <body>
    <script>
      window.location.replace('/posts');
    </script>
  </body>
</html>
```

You can use this in an "Action workflow", such as to login a user or update a database record. Depending on how it went, the user can be directed to the next page or step. 


## Performance
To improve performance, use APIM internal caching and keep Logic App workflows stateless. Avoid excessive complexity in Liquid templates. For dynamic content, consider loading it via iframes or embed tags, so the browser can cache the HTML elements.


## Reflections

The more I worked on this project, the more I realized that building a successful application is less about the specific technology stack and more about having a well-thought-out architecture. Every approach has its pros and cons—some things are easier to build, others are harder, but the core challenges remain the same. In the end, you are trying to present content quickly and manage HTML efficiently.

After a project like this, I can say Logic Apps work surprisingly well. You would not really notice that a Logic App is running the show, which was the whole point. You also gain a better understanding of how web applications work and the components that are necessary for a good application.

The biggest hassle with Logic Apps for a web application is the **routing**, since there is no direct integration between Azure API Management and Logic App Standard. The developer experience is decent but not enough, running the project locally is not an option, because of API Management dependency. If you are comfortable with a mix of local and cloud development, you will get by.

There are things that I am skipping in this article, for instance how to handle home, cookies and session, and other default types of behavior that come with a web application. For this you will need to look at APIM policies.

Anyway, for low complexity scenarios, such as CRUD and demos, Logic Apps web applications could be an option, but not a great one. You would need to over-engineer Logic Apps just to get decent performance and experience. If you require a lot of changes and complex user interfaces, you may end up going down a rabbit hole that is quite deep!



