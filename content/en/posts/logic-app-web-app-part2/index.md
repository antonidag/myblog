---
title: "Logic Apps as a Web App, Part 2: Overengineering Done Right 🧠⚙️"
date: 2025-07-01T00:00:00+01:00
draft: false
description: 
image: "posts/logic-app-web-app-part2/logic-app-web-app-part-2.png"
---

## Background
Last year, I wrote a blog post about how Logic Apps Standard can be used as a framework to build a web application. You can find that post [here](/posts/logic-app-web-app). But that was more or less a proof of concept — the idea was simply to test if it was even possible.

I didn’t dig into the additional layers typically required in a real-world web app, nor how those requirements could be handled to reach something closer to an enterprise-level solution. So in this post, we’ll explore several of those topics — and how they can be solved using Azure services!

## What really *is* a web application? 💻
At its core, a web application is simply `HTML` and `JavaScript` code hosted on a web server. However, when you look deeper, you'll find that a web app consists of multiple technical components, such as:

- User Interface & Experience – How users interact with the app.
- Frontend & Backend – The logic driving both the visible and behind-the-scenes parts.
- Authentication & Authorization – Who gets in and what they can do.
- Performance & Scalability – Ensuring fast load times and the ability to handle increased traffic.
- Security – Protecting against threats like DDoS, XSS, and SQL injection.
- ...and so on.

All these elements must come together to create a fully functional web application.

## From browser to Logic App
Looking at it from a high-level perspective, the entry point to the application is **Azure Application Gateway**. From there, traffic is routed to **Azure API Management (APIM)**, with the final destination being **Logic Apps Standard**, where most of the actual implementation takes place.

<embed style="pointer-events: none;" height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22myapp.se%22%2C%22x%22%3A600%2C%22y%22%3A270%7D%2C%7B%22id%22%3A%22End-point-2%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Flogin%22%2C%22x%22%3A391%2C%22y%22%3A390%7D%2C%7B%22id%22%3A%22End-point-3%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fhome%22%2C%22x%22%3A601%2C%22y%22%3A392%7D%2C%7B%22id%22%3A%22End-point-4%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Fsettings%22%2C%22x%22%3A803%2C%22y%22%3A394%7D%2C%7B%22id%22%3A%22API%20Management-5%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22%2Fext-myapp%22%2C%22x%22%3A601%2C%22y%22%3A541%7D%2C%7B%22id%22%3A%22Trigger-6%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20login%20request%20is%20received%22%2C%22x%22%3A376.452941037135%2C%22y%22%3A649.5956169029506%7D%2C%7B%22id%22%3A%22Logic%20App-7%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Web%20Application%22%2C%22x%22%3A600.8906415035528%2C%22y%22%3A925.8347176299218%7D%2C%7B%22id%22%3A%22Trigger-9%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20home%20request%20is%20received%22%2C%22x%22%3A601.0254170475325%2C%22y%22%3A648.7945249038028%7D%2C%7B%22id%22%3A%22Trigger-10%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20settings%20request%20is%20received%22%2C%22x%22%3A824.3494540224185%2C%22y%22%3A646.9308580458288%7D%2C%7B%22id%22%3A%22HTML-11%22%2C%22label%22%3A%22HTML%22%2C%22title%22%3A%22HTML%22%2C%22x%22%3A649.4732268254302%2C%22y%22%3A806.4551350526904%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__End-point-2-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-2%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-3-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-3%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-4-API%20Management-5%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-4%22%2C%22target%22%3A%22API%20Management-5%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-6%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-2%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Application%20Gateway-1-End-point-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Application%20Gateway-1%22%2C%22target%22%3A%22End-point-4%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-9%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-9%22%7D%2C%7B%22id%22%3A%22xy-edge__API%20Management-5-Trigger-10%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22API%20Management-5%22%2C%22target%22%3A%22Trigger-10%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-6-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-6%22%2C%22target%22%3A%22HTML-11%22%7D%2C%7B%22id%22%3A%22xy-edge__HTML-11-Logic%20App-7%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22HTML-11%22%2C%22target%22%3A%22Logic%20App-7%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-9-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-9%22%2C%22target%22%3A%22HTML-11%22%7D%2C%7B%22id%22%3A%22xy-edge__Trigger-10-HTML-11%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-10%22%2C%22target%22%3A%22HTML-11%22%7D%5D%7D">

### How Routing Works
The routing flow is handled in three main steps:

- **Application Gateway** acts as the public entry point. It handles all incoming HTTP(S) requests, applies security rules (like WAF, SSL termination, and IP restrictions), and then forwards requests to API Management. It can also handle basic path-based routing.

- **API Management (APIM)** receives the request from the Application Gateway. APIM maps clean, user-friendly URLs (such as `/posts`) to the correct Logic App workflow endpoints. This is typically done using APIM policies or rewrite rules, which translate the path to the Logic App HTTP trigger URL (including necessary parameters and the `sig`). APIM can also enforce authentication, caching, and rate limiting.

- **Logic App Standard** is where the actual business logic and page rendering happens. APIM forwards the request to the appropriate Logic App workflow, which then returns the `HTML/JS` for the requested page.

*Why is this important?*

This approach keeps sensitive information, like the Logic App signature `sig` and other parameters hidden from the client. Users only see clean URLs, while APIM securely injects the necessary secrets and parameters when forwarding requests to Logic App service. This not only improves security but also makes navigation and linking much simpler.

## Frontend, backend or a bit of mix?
For those of you who have read my first blog post about Logic Apps as a Web App, you probably already know how it is done, but let's do a quick recap anyway.
Essentially, we use the request trigger together with the response action, making sure the ``Content-Type`` is set to ``text/html`` so the content displays properly in the browser—and that is pretty much it. If you want a more detailed breakdown, check out the implementation section [here].

The whole frontend/backend separation is sort of lost here, but that is not necessarily a bad thing. Server-side rendering (SSR) has been around for years. Frameworks like Blazor or Next.js are built on similar concepts, just with more structure. In our case, it is a more old-school approach to web development using Logic Apps in a way they were not originally intended for.

### How it is all structured
With this in mind, the method that I have put together follows a few core principles:

- __One page = one workflow__
- __Separate workflows for actions__ – Any action that is not an the typical `GET` method like edit, create, or delete should be handled in its own dedicated workflow, keeping page logic clean.
- __One Liquid template per page__ – Each page should have only one Liquid template to keep things structured and avoid unnecessary complexity.
  - Utilize the templates for more than basic headers, css, and body.
- __A workflow should always live on its own. Never return another workflows HTML content, instead redirect the user to that page__

- __Load dynamic content via an iframe__ – If a page requires dynamic content, use an `<iframe>` and create a separate workflow for that specific content.
  - For instance shared components like, menu, sidebar and footer can be created as separate workflows.  


### Page workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://flowitech.antonbjorkman.com/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Trigger-2%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20an%20HTTP%20request%20is%20received%22%2C%22x%22%3A480%2C%22y%22%3A299%7D%2C%7B%22id%22%3A%22Action-3%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Transform%20%26%20compose%20HTML%20content%22%2C%22x%22%3A480%2C%22y%22%3A437%7D%2C%7B%22id%22%3A%22Action-6%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Return%20HTML%20to%20client%22%2C%22x%22%3A480%2C%22y%22%3A587%7D%2C%7B%22id%22%3A%22End-point-7%22%2C%22label%22%3A%22End-point%22%2C%22title%22%3A%22%2Flogin%22%2C%22x%22%3A480%2C%22y%22%3A177%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__Trigger-2-Action-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-2%22%2C%22target%22%3A%22Action-3%22%7D%2C%7B%22id%22%3A%22xy-edge__End-point-7-Trigger-2%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22End-point-7%22%2C%22target%22%3A%22Trigger-2%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-3-Action-6%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Action-3%22%2C%22target%22%3A%22Action-6%22%7D%5D%7D">

## Action workflow
<embed style="pointer-events: none;" height="500px" width="100%" src="https://flowitech.antonbjorkman.com/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Trigger-2%22%2C%22label%22%3A%22Trigger%22%2C%22title%22%3A%22When%20an%20HTTP%20request%20is%20received%22%2C%22x%22%3A480%2C%22y%22%3A299%7D%2C%7B%22id%22%3A%22Action-3%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Call%20service%22%2C%22x%22%3A480%2C%22y%22%3A437%7D%2C%7B%22id%22%3A%22Action-4%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22On%20faliure%22%2C%22x%22%3A481%2C%22y%22%3A563%7D%2C%7B%22id%22%3A%22Action-4%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22On%20faliure%22%2C%22x%22%3A481%2C%22y%22%3A563%7D%2C%7B%22id%22%3A%22Action-5%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Redirect%20to%20page%22%2C%22x%22%3A592%2C%22y%22%3A683%7D%2C%7B%22id%22%3A%22Action-6%22%2C%22label%22%3A%22Action%22%2C%22title%22%3A%22Redirect%20to%20404%2F500%20page%22%2C%22x%22%3A360%2C%22y%22%3A684%7D%5D%2C%22edges%22%3A%5B%7B%22id%22%3A%22xy-edge__Trigger-2-Action-3%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Trigger-2%22%2C%22target%22%3A%22Action-3%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-3-Action-4%22%2C%22middleLabel%22%3A%22%22%2C%22source%22%3A%22Action-3%22%2C%22target%22%3A%22Action-4%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-4-Action-5%22%2C%22middleLabel%22%3A%22false%22%2C%22source%22%3A%22Action-4%22%2C%22target%22%3A%22Action-5%22%7D%2C%7B%22id%22%3A%22xy-edge__Action-4-Action-6%22%2C%22middleLabel%22%3A%22true%22%2C%22source%22%3A%22Action-4%22%2C%22target%22%3A%22Action-6%22%7D%5D%7D">


### Redirecting
Redirecting is when you automatically send the user to another part of the site, such as after a payment with a third-party provider. Since Logic App Request connector does not support HTTP 302 redirects and the `Location` header, the workaround is to return a simple ``HTML`` page with ``JavaScript``:

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
* **Dynamic loading:** Load data only when needed using ``iframes`` or `embed` tags.

When implemented correctly, these optimizations will drastically improve the responsiveness.

## Reflections

The more I worked on this project, the more I realized that success is not tied to any specific technology, it is about the architecture.

Every web stack has its tradeoffs. Some parts are easy to implement, others are painful. But the challenge is always the same: serve content fast and manage ``HTML`` in a maintainable way.

Logic Apps did surprisingly well. You would not notice that Logic Apps are "running the show", which was the goal. It also gave me a much deeper appreciation for how modern web applications are structured.

The biggest hassle with Logic Apps for a web application is the **routing**, since there is no direct integration between Azure API Management and Logic App Standard. The developer experience is decent but not enough, running the project locally is not an option, because of API Management dependency. If you are comfortable with a mix of local and cloud development, you will get by.

There are things that I am skipping in this article, for instance how to handle home, cookies and session, and other default types of behavior that come with a web application. For this you will need to look at APIM policies.

Anyway, for low complexity scenarios, such as ``CRUD`` and demos, Logic Apps web applications could be an option, but not a great one. You would need to over-engineer Logic Apps just to get decent performance and experience. If you require a lot of changes and complex user interfaces, you may end up going down a rabbit hole that is quite deep!