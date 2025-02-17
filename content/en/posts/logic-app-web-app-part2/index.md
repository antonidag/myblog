---
title: "Logic App Web App v2"
date: 2025-01-27T00:00:00+01:00
draft: false
description: 
image: "posts/logic-app-web-app/clientwebserver.gif"
---


## Background
Last year I wrote an blog post about how Logic Apps Standard can be used to build an web application, you can find the blog [here](/posts/logic-app-web-app). But that was more or less a proof of concept, idea, is this really possible. I did not look into other layers that is typical needed in your web application, and how these requirements can be solved to meet a more of an enterprise level. So in this blog post we will explore different topics of an web application and how these can be solved with Azure Services! 

## Digesting a web application 💻
When you think about it in simple terms a Web App is it is just some some `html` and `javascript` code and a web server to run host the files on.
However when you scratch the surface you will see that a web app is made up of many technical parts such as: 
- User Interface & experience
- Front & Backend
- Authentication
- Performance  
- and the list goes on...
 
All of these need work together to create the full web application. Designing and distributing a web app for multiple user over different locations include a lot a bit more infrastructure. Just want to make a note that if you are building a top modern web application you probably would not use an Logic App Standard as the primary framework, anyway if you find yourself in a spot where it fits, there is a few bullet-points that can help you ease the implementation and avoid some pitfalls. I am not every team has full skill set of an web-developer. 

We will start with going over the arch, then more into the details of areas. 
## Architecture
Looking at it from a top-level perspective and working our way down, the entry point of the application will be __Azure Application Gateway__. From there, traffic will be routed to __Azure API Management__, and the final destination will be __Logic App Standard__.

<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22App%20Entry%22%2C%22x%22%3A443.4024604461355%2C%22y%22%3A208.68049208922713%7D%2C%7B%22id%22%3A%22API%20Management-2%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22APIM%22%2C%22x%22%3A443.81265354730033%2C%22y%22%3A379.0952547660403%7D%2C%7B%22id%22%3A%22Logic%20App-3%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Web%20Application%22%2C%22x%22%3A454.5806677475383%2C%22y%22%3A752.9261866159344%7D%2C%7B%22id%22%3A%22Policy-4%22%2C%22label%22%3A%22Policy%22%2C%22title%22%3A%22JWT-Validation%22%2C%22x%22%3A577.5068543634727%2C%22y%22%3A518.053778498359%7D%2C%7B%22id%22%3A%22Page-5%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Login%22%2C%22x%22%3A317.2903338737692%2C%22y%22%3A620.0660807290365%7D%2C%7B%22id%22%3A%22Page-6%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Index%22%2C%22x%22%3A579.3732864091317%2C%22y%22%3A623.5391914798571%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__API%20Management-2-Policy-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Policy-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Policy-4-Page-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Policy-4%22%2C%22target%22%3A%22Page-6%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-2-Page-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Page-5%22%7D%2C%7B%22id%22%3A%22xy-edge__Page-5-Logic%20App-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Page-5%22%2C%22target%22%3A%22Logic%20App-3%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-2-Function-7%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-2%22%2C%22target%22%3A%22Function-7%22%7D%2C%7B%22id%22%3A%22xy-edge__Page-6-Logic%20App-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Page-6%22%2C%22target%22%3A%22Logic%20App-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-API%20Management-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22API%20Management-2%22%7D%5D%7D">

Each of these layers plays a critical role:

- __Application Gateway__ is the entry point for the application and acts as our firewall and load balancer, protecting the application from potential threats.

- __API Management__ is where our APIs reside. It allows us to define paths for the web application, implement caching, and manage user authentication.

- __Logic App Standard__ serves HTML and JavaScript, handling both static and dynamic pages as needed.

### Front-end & Back-end
Home page 
The concept of front-end and back-end still exists within this context. However, the lines are bit more blurry. But even modern framework like next.js utilize this kind of mixing front and back-ends into one application, some funcunallity runs on the server while other runs on client. The same principle can be applied here, it more or less a matter of how creative you want to be. The method I found to quite straight was to build that one page would be one workflow. 

Something about liquid  

### Routing
Correct routing is a big part of making this work
### Redirecting

### Authentication
Cookies are sent in the HTTP header, and they are domain specific. 
Best practice is to HTTP-only cookies

Cookies & APIM policy jwt 
### Performance 
Cache APIM internal/ Stateless / avoid to much complexity within liquid.
There is of course many ways to improve the page load, one example of this to utilizes the cache, is to load dynamic content as within iframes or embed tags. Is is because then html elements will be cache rather than the content.   
### Assets 
Dealing with assets is also a bit tricky since you can't do any direct pointing the server since it is a Logic App service, but the way you would do it is to in Azure expose a storage account on a specific path. Like domain.se/assets/**.img/jpg 

## Reflections

I think the most hassles you will have working with Logic Apps for a website is probably the routing since there is any direct integration between Azure API Management and Logic App Standard. 

The more and more I started to working on this I have realized that no matter which technology stack, framework you choose or method. Making a successful application requires a thought through architecture and it is actually less dependent on what platform you are using. Yes, ofcourse some things are easier to build while others are harder but in the end it is still the same issues you are trying to tackle. In some sense you are trying to create away to easily manipulate the html code while presenting content quickly. Like a Single Page Application is not a silver bullet solving every problem. 