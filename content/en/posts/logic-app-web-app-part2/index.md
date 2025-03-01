---
title: "Logic App Web App v2"
date: 2025-01-27T00:00:00+01:00
draft: false
description: 
image: "posts/logic-app-web-app/clientwebserver.gif"
---


## Background
Last year I wrote an blog post about how Logic Apps Standard can be used as framework to build an web application, you can find the blog [here](/posts/logic-app-web-app). But that was more or less a proof of concept, idea, is this really possible. I did not look into other layers that is typical needed in your web application, and how these requirements can be solved to meet a more of an enterprise level. So in this blog post we will explore different topics of an web application and how these can be solved with Azure Services! 

## Digesting a web application 💻
At its core, a web application is simply `HTML` and `JavaScript` code hosted on a web server. However, when you look deeper, you'll see that a web app consists of multiple technical components, such as:

- User Interface & Experience – How users interact with the app.
- Frontend & Backend – The logic driving both the visible and behind-the-scenes parts.
- Authentication & Authorization – Who gets in and what they can do.
- Performance & Scalability – Ensuring fast load times and handling increased traffic.
- Security – Protecting against threats like DDoS attacks, XSS, and SQL injection.
- and so on...

All these elements must work together to create a fully functional web application. Deploying and managing a web app for users across different locations requires additional infrastructure and careful design.

It is worth noting that if you are building a cutting-edge web application, Logic App Standard may not be your first choice as a primary framework since there is some limitations. However, if you find a scenario where it fits, there are some tips and tricks that could help you down the line!

## Architecture Overview
If we look at it from a top-level perspective and work our way down, the entry point of the application will be __Azure Application Gateway__. From there, traffic will be routed to __Azure API Management__, and the final destination will be __Logic App Standard__ where most of implementation will happen.

<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22App%20Entry%22%2C%22x%22%3A443.4024604461355%2C%22y%22%3A208.68049208922713%7D%2C%7B%22id%22%3A%22API%20Management-2%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22APIM%22%2C%22x%22%3A443.81265354730033%2C%22y%22%3A379.0952547660403%7D%2C%7B%22id%22%3A%22Logic%20App-3%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Web%20Application%22%2C%22x%22%3A454.5806677475383%2C%22y%22%3A752.9261866159344%7D%2C%7B%22id%22%3A%22Policy-4%22%2C%22label%22%3A%22Policy%22%2C%22title%22%3A%22JWT-Validation%22%2C%22x%22%3A577.5068543634727%2C%22y%22%3A518.053778498359%7D%2C%7B%22id%22%3A%22Page-5%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Login%22%2C%22x%22%3A317.2903338737692%2C%22y%22%3A620.0660807290365%7D%2C%7B%22id%22%3A%22Page-6%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Index%22%2C%22x%22%3A579.3732864091317%2C%22y%22%3A623.5391914798571%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__API%20Management-2-Policy-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Policy-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Policy-4-Page-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Policy-4%22%2C%22target%22%3A%22Page-6%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-2-Page-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Page-5%22%7D%2C%7B%22id%22%3A%22xy-edge__Page-5-Logic%20App-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Page-5%22%2C%22target%22%3A%22Logic%20App-3%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-2-Function-7%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Function-7%22%7D%2C%7B%22id%22%3A%22xy-edge__Page-6-Logic%20App-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Page-6%22%2C%22target%22%3A%22Logic%20App-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-API%20Management-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22API%20Management-2%22%7D%5D%7D">

Each service plays an important role in this architecture:

- __Application Gateway__ acts as the entry point for the web application, functioning as both a firewall and capable for load balancing as well. It ensures secure traffic management, enforcing domain rules, certificates, and regional restrictions (e.g., allowing only EU traffic).

- __API Management__ handles APIs, routing, authentication, and caching for optimized response times.

- __Logic App Standard__ handles both the front-end and back-end code of the application. It delivers `HTML` and `JavaScript` to the client while also implementing business APIs. All pages are generated and rendered by the server [(SSR)](/posts/logic-app-web-app/#server-side-rendering), with some being more dynamic than others.

By following this structure we ensure clear separations:
- Fist layer handles incoming traffic in a secure way. 
- Second layer deals with APIs, authentication and caching. 
- Last layer is the application logic itself.

## Front-end & Back-end
For those of you who have read my first blog post about Logic Apps as a Web App, you probably already know how it’s done, but let’s do a quick recap anyway.
Essentially, we use the request trigger together with the response action, making sure the ``Content-Type`` is set to ``text/html`` so the content displays properly in the browser—and that’s pretty much it. If you want a more detailed breakdown, check out the implementation section here.

The whole front-end/back-end concept is a bit mixed here since Logic Apps handles everything, but in some ways, this isn’t anything new or totally-crazy. Server-side rendering has been around for years, and if you look at frameworks like Blazor or Next.js, they play around with the same idea in their own way. One core difference is that modern tools like Blazor are built with this functionality in mind, offering a structured and integrated way to handle rendering and interactivity. In our case, it’s more of an old-school approach to creating a web application—leveraging Logic Apps in a way it wasn’t originally designed for.

### Defining the Structure
With this in mind, the method that I have put together follows a few core principles:

- __Treat each page as a workflow__ – Every page corresponds to a Logic Apps workflow, ensuring clear separation.
- __Shared components__ can be created as separate workflow and load thru an `<iframe>`.  
- __Load dynamic content via an iframe__ – If a page requires dynamic content, use an iframe and create a separate sub-workflow for that specific content.
- __Separate workflows for actions__ – Any action that is not an the typical `GET` method like edit, create, or delete should be handled in its own dedicated workflow, keeping page logic clean.
- __One Liquid template per page__ – Each page should have only one Liquid template to keep things structured and avoid unnecessary complexity.
- Utilize the templates for more than basic headers, css, and body.
- __Never invoke and return a page by the index workflow from another workflow__, a workflow should always return its own page instead the user should be redirected. 

### Navigation
Logic Apps request trigger generates a quite lengthy url we can examin it here: 
```
&sig=sadaslödkqlöwkedlqkwdlkasdaslödksa
```
This is one of the reasons why navigation is quite tricky with Logic Apps, because the signature is in some way a secret that should not be exposed. The other issue is that we can not predict these values meaning that hard to work with. Basically we just want to have simple linking between the pages like `<a href="/posts">Go to posts</a>`
Correct is a big part of making this work. It would not look very clean if we had to include the whole Logic app url here. Luckily with the proposed architecture this is solved at the Application Gateway and API Management layers, thus enabling us to a simple `<a href="/posts"></a> `with out any hassle for example. This is also with it is important to never invoke another pages workflow and retuning it from because it will create disorientation and lead to utter failure.  

### Redirecting
Is a technical term used in web applications to when the application is automatically directing you to and another part of the site. An example of this could you are making a purchase on a e-shop and then the actual payment is direct to Klara site and once the payment is completed you are redirected back to the e-shop. 


The way that I found to was to create a simple `HTML` with some `JavaScript`, shown here: 

```

```  

One of the reason we have to do it like this is because Logic App Request connector does not support the redirect HTTP 302 and Loction.  

## Authentication
Cookies are sent in the HTTP header, and they are domain specific. 
Best practice is to HTTP-only cookies
Cookies & APIM policy jwt

the best way to do this ia doing a Federation login with your OICD Identify, this way credentials never have to enter your application. 

## Performance 
Cache APIM internal/ Stateless / avoid to much complexity within liquid.
There is of course many ways to improve the page load, one example of this to utilizes the cache, is to load dynamic content as within iframes or embed tags. Is is because then html elements will be cache rather than the content.   


## Assets 
Dealing with assets is also a bit tricky since you can not do any direct pointing the server since it is a Logic App service, but the way you would do it is to in Azure expose a storage account on a specific path. Like domain.se/assets/**.img/jpg 

## Reflections

The more and more I started to working on this I have realized that no matter which technology stack, framework you choose or method. Making a successful application requires a thought through architecture and it is actually less dependent on what tools you are using. Yes, ofcourse some things are easier to build while others are harder but in the end it is still the same issues you are trying to tackle. In some sense you are trying to create away to easily manipulate the html code while presenting content quickly. Like a Single Page Application is not a silver bullet solving every problem. 

After a project like this I do have to say that it works really well, you would really noised that it is a Logic App "running" in the show. You also get a quite good understanding of the an web application works and its challenges, and apprichiachgen for new tools like React, and Blazor. 

I think the most hassles you will have working with Logic Apps for a website is probably the routing since there is any direct integration between Azure API Management and Logic App Standard. The developer experience is pretty OK, depending on who you are asking it might be really bad since running the project locally is not really an option, you need API Management to fix the routing. But if you are used to a bit of mix of local and cloud development building, debugging, is straight forward.  

When you are dealing low complexity such as just a simple create, update, list and delete operations something something
