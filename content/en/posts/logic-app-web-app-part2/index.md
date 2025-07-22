---
title: "Logic Apps as a Web App, Part 2: Overengineering Done Right 🧠⚙️"
date: 2025-07-17T00:00:00+01:00
draft: false
description: 
image: "posts/logic-app-web-app-part2/logic-app-web-app-part-2.png"
---

## Background
Last year, I wrote a blog post about how Logic Apps Standard can be used as a framework to build a web application. You can find that post [here](/posts/logic-app-web-app). But that was more or less a proof of concept — the idea was simply to test if it was even possible.

I did not dig into the additional layers typically required in a real-world web app, nor how those requirements could be handled to reach something closer to an enterprise-level solution. So in this post, we will explore several of those topics — and how they can be solved using Azure services!

## What really *is* a web application? 💻
At its core, a web application is simply `HTML` and `JavaScript` code hosted on a web server. However, when you look deeper, you'll find that a web app consists of multiple components, such as:

- User Interface & Experience
- Frontend & Backend
- Authentication & Authorization
- Performance & Scalability
- Security
- ...and so on

All these components must come together to create a fully functional web application.

## From browser to Logic App
Looking at it from a high-level perspective, the entry point to the web application is **Azure Application Gateway**. From there, traffic is routed to **Azure API Management (APIM)**, with the final destination being **Logic Apps Standard**, where most of the actual implementation takes place.

<embed style="pointer-events: none;" height="500px" width="100%" src="https://flowitech.antonbjorkman.com/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22myapp.se%22%2C%22x%22%3A573%2C%22y%22%3A285%7D%2C%7B%22id%22%3A%22End-point-2%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fhome%22%2C%22x%22%3A572.4657726422979%2C%22y%22%3A385.6294990768911%7D%2C%7B%22id%22%3A%22End-point-3%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fposts%22%2C%22x%22%3A778.2543223181937%2C%22y%22%3A387.34721257053974%7D%2C%7B%22id%22%3A%22End-point-4%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Flogin%22%2C%22x%22%3A337.3302754174315%2C%22y%22%3A383.2145378939182%7D%2C%7B%22id%22%3A%22API%20Management-5%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22%2Fext-myapp%22%2C%22x%22%3A572.6527874294602%2C%22y%22%3A497.41496118297306%7D%2C%7B%22id%22%3A%22HTTP%20Trigger-6%22%2C%22label%22%3A%22HTTP%20Trigger%22%2C%22title%22%3A%22On%20%2Fhome%20HTTP%20request%22%2C%22x%22%3A572.4657726422978%2C%22y%22%3A623.316160812568%7D%2C%7B%22id%22%3A%22HTTP%20Trigger-7%22%2C%22label%22%3A%22HTTP%20Trigger%22%2C%22title%22%3A%22On%20%2Flogin%20HTTP%20request%22%2C%22x%22%3A362.414961182973%2C%22y%22%3A626.9386025870275%7D%2C%7B%22id%22%3A%22HTTP%20Trigger-8%22%2C%22label%22%3A%22HTTP%20Trigger%22%2C%22title%22%3A%22On%20%2Fposts%20HTTP%20request%22%2C%22x%22%3A775.0846857655416%2C%22y%22%3A629.3027523106756%7D%2C%7B%22id%22%3A%22Logic%20App-9%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Web%20Application%22%2C%22x%22%3A573.0528925514391%2C%22y%22%3A877.1300281882095%7D%2C%7B%22id%22%3A%22HTML-10%22%2C%22label%22%3A%22HTML%22%2C%22title%22%3A%22HTML%22%2C%22x%22%3A621.5984473189196%2C%22y%22%3A764.6767818850003%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-2%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-3%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-2-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-2%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-HTTP%20Trigger-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22HTTP%20Trigger-6%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-HTTP%20Trigger-7%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22HTTP%20Trigger-7%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-HTTP%20Trigger-8%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22HTTP%20Trigger-8%22%7D%2C%7B%22id%22%3A%22xy-edge__HTTP%20Trigger-6-HTML-10%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Trigger-6%22%2C%22target%22%3A%22HTML-10%22%7D%2C%7B%22id%22%3A%22xy-edge__HTTP%20Trigger-7-HTML-10%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Trigger-7%22%2C%22target%22%3A%22HTML-10%22%7D%2C%7B%22id%22%3A%22xy-edge__HTTP%20Trigger-8-HTML-10%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Trigger-8%22%2C%22target%22%3A%22HTML-10%22%7D%2C%7B%22id%22%3A%22xy-edge__HTML-10-Logic%20App-9%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTML-10%22%2C%22target%22%3A%22Logic%20App-9%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-4-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-4%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-3-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-3%22%2C%22target%22%3A%22API%20Management-5%22%7D%5D%7D">

### How Routing Works
The routing flow is handled in three main steps:

- **Application Gateway** acts as the public entry point. It handles all incoming ``HTTP(s)`` requests, applies security rules (like WAF, SSL termination, and IP restrictions), and then forwards requests to API Management. It can also handle basic path-based routing.

- **API Management (APIM)** receives the request from the Application Gateway. APIM maps clean, user friendly URLs (such as `/posts`) to the correct Logic App workflow endpoints. This is typically done using APIM policies or rewrite rules, which translate the path to the Logic App HTTP trigger URL. APIM can also enforce authentication, caching, and rate limiting.

- **Logic App Standard** is where the actual business logic and page rendering happens. APIM forwards the request to the appropriate Logic App workflow, which then returns the `HTML` and  `JavaScript` for the requested page.

*Why is this important?*

This approach keeps sensitive information, like the Logic App signature `sig` and other parameters hidden from the client. Users only see clean URLs, while APIM securely injects the necessary secrets and parameters when forwarding requests to Logic App service. This not only improves security but also makes navigation and linking much simpler.

## Frontend, backend or a bit of mix?
For those of you who have read my first blog post about Logic Apps as a Web App, you probably already know how it is done, but let's do a quick recap anyway.
Essentially, we use the request trigger together with the response action, making sure the `Content-Type` is set to `text/html` so the content displays properly in the browser—and that is pretty much it.

The whole frontend/backend separation is sort of lost here, but that is not necessarily a bad thing. Server-side rendering (SSR) has been around for years. Frameworks like Blazor or Next.js are built on similar concepts, just with more structure. In our case, it is a more old-school approach to web development using Logic Apps in a way they were not originally intended for.

### How it is all structured
With this in mind, the method that I have put together follows a few core principles:

- __One page = one workflow__
- __Separate workflows for actions__ – Any action that is not an the typical `GET` method like edit, create, or delete should be handled in its own dedicated workflow, keeping page logic clean.
- __One Liquid template per page__ – Each page should have only one Liquid template to keep things structured and avoid unnecessary complexity.
  - Utilize the templates for more than basic headers, css, and body.
- __A workflow should always live on its own.__ - Never return another workflows HTML content, instead redirect the user to that page

- __Load content via iframe__ – If a page requires dynamic content, use an `<iframe>` and create a separate workflow for that specific content.
  - For instance shared components like, menu, sidebar and footer can be created as separate workflows.  


### Page workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://flowitech.antonbjorkman.com/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22HTTP%20Trigger-7%22%2C%22label%22%3A%22HTTP%20Trigger%22%2C%22title%22%3A%22On%20HTTP%20request%22%2C%22x%22%3A570.2714125447231%2C%22y%22%3A637.0164911379002%7D%2C%7B%22id%22%3A%22HTTP%20Request-6%22%2C%22label%22%3A%22HTTP%20Request%22%2C%22title%22%3A%22Return%20payload%22%2C%22x%22%3A571.0001912871144%2C%22y%22%3A1000.0833571761759%7D%2C%7B%22id%22%3A%22Compose-4%22%2C%22label%22%3A%22Compose%22%2C%22title%22%3A%22Transform%20content%20to%20HTML%20%26%20CSS%22%2C%22x%22%3A570.3504984789272%2C%22y%22%3A767.6363049640273%7D%2C%7B%22id%22%3A%22HTML-4%22%2C%22label%22%3A%22HTML%22%2C%22title%22%3A%22HTML%22%2C%22x%22%3A619.1061534705811%2C%22y%22%3A890.0734967674751%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__HTTP%20Trigger-7-Compose-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Trigger-7%22%2C%22target%22%3A%22Compose-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Compose-4-HTML-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Compose-4%22%2C%22target%22%3A%22HTML-4%22%7D%2C%7B%22id%22%3A%22xy-edge__HTML-4-HTTP%20Request-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTML-4%22%2C%22target%22%3A%22HTTP%20Request-6%22%7D%5D%7D">

## Action workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://flowitech.antonbjorkman.com/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22HTTP%20Trigger-7%22%2C%22label%22%3A%22HTTP%20Trigger%22%2C%22title%22%3A%22On%20HTTP%20request%22%2C%22x%22%3A570.2714125447231%2C%22y%22%3A637.0164911379002%7D%2C%7B%22id%22%3A%22HTTP%20Request-6%22%2C%22label%22%3A%22HTTP%20Request%22%2C%22title%22%3A%22Call%20service%22%2C%22x%22%3A569.852357987649%2C%22y%22%3A746.4121979943282%7D%2C%7B%22id%22%3A%22Condition-3%22%2C%22label%22%3A%22Condition%22%2C%22title%22%3A%22On%20sucess%22%2C%22x%22%3A570.0085009144348%2C%22y%22%3A854.3993364491855%7D%2C%7B%22id%22%3A%22Page-5%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Redirect%20to%20Home%22%2C%22x%22%3A448.1980093475564%2C%22y%22%3A984.729836144374%7D%2C%7B%22id%22%3A%22Page-5%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Redirect%20to%20Home%22%2C%22x%22%3A448.1980093475564%2C%22y%22%3A984.729836144374%7D%2C%7B%22id%22%3A%22Page-6%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22Redirect%20to%20Bad%22%2C%22x%22%3A684.0263321818228%2C%22y%22%3A984.729836144374%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__HTTP%20Trigger-7-HTTP%20Request-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Trigger-7%22%2C%22target%22%3A%22HTTP%20Request-6%22%7D%2C%7B%22id%22%3A%22xy-edge__HTTP%20Request-6-Condition-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTTP%20Request-6%22%2C%22target%22%3A%22Condition-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Condition-3-Page-5%22%2C%22middleLabel%22%3A%22true%22%2C%22source%22%3A%22Condition-3%22%2C%22target%22%3A%22Page-5%22%7D%2C%7B%22id%22%3A%22xy-edge__Condition-3-Page-6%22%2C%22middleLabel%22%3A%22false%22%2C%22source%22%3A%22Condition-3%22%2C%22target%22%3A%22Page-6%22%7D%5D%7D">

### Redirecting
Redirecting is when you automatically send the user to another part of the site, such as after a payment with a third-party provider. Since Logic App Request connector does not support HTTP 302 redirects and the `Location` header, the workaround is to return a simple `HTML` page with `JavaScript`:

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

You can use this in "Action workflows" to send users to the next page after a successful update or login.

## Performance
Response times and overall performance are critical for web applications—if your app is slow, users will leave. To make your Logic App Web App feel fast and responsive, consider these strategies:

* **Caching:** Use APIM caching policies wherever possible.
* **Stateless workflows:** Less overhead and better performance.
* **Dynamic loading:** Load data only when needed using `iframes` or `embed` tags.

When implemented correctly, these optimizations will have big impact on the responsiveness.

## Reflections

The more I worked on this project, the more I realized that success is not tied to any specific technology, it is about the architecture.

Every web stack has its tradeoffs. Some parts are easy to implement, others are painful. But the challenge is always the same: serve content fast and manage `HTML` in a maintainable way.

Logic Apps did surprisingly well. You would not notice that Logic Apps are "running the show", which was the goal. It also gave me a much deeper appreciation for how modern web applications are structured.

The biggest hassle with Logic Apps for a web application is the **routing**, since there is no direct integration between Azure API Management and Logic App Standard. The developer experience is decent but not enough, running the project locally is not an option, because of API Management dependency. If you are comfortable with a mix of local and cloud development, you will get by.

There are things that I am skipping in this article, for instance how to handle cookies, session, and other default types of behavior that come with a web application. For this you will need to look at APIM policies.

Anyway, for low complexity scenarios, such as `CRUD` apps and demos, using Logic Apps to build web applications could be an option. When you over-engineer, you can actually get quite good performance and user experience. With the right architecture in place, you can also meet enterprise-level requirements such as authentication, security, and scaling. However, if your application requires alot of changes or complex user interfaces, you might find yourself going down a deep rabbit hole!