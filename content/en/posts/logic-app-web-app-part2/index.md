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
When you think about it, a web app is made up of many functional parts that all work together create the full user experience. In simple terms there is it is just some some `html` and `javascript` code and a web server to run host the files on. But designing and distributing a web app for multiple user over different locations include a lot a bit more infrastructure. Just want to make a note that if you are building a top modern web application you probably would not use an Logic App Standard as the primary framework, anyway if you find yourself in a spot where it fits, there is a few bullet-points that can help you ease the implementation and avoid some pitfalls. I am not every team has full skill set of an web-developer.  
## Overall architecture
Bild på over all 

<embed height="500px" width="100%" src="https://antonidag.github.io/flowitec/?data=%7B%22nodes%22%3A%5B%7B%22id%22%3A%22Application%20Gateway-1%22%2C%22label%22%3A%22Application%20Gateway%22%2C%22title%22%3A%22domain.se%22%2C%22x%22%3A322.0459235943043%2C%22y%22%3A144.29018314501627%7D%2C%7B%22id%22%3A%22Page-4%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22adim%22%2C%22x%22%3A556.7022779803369%2C%22y%22%3A474.7856466930928%7D%2C%7B%22id%22%3A%22Page-5%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22main%22%2C%22x%22%3A322.22708372407885%2C%22y%22%3A471.7607082864877%7D%2C%7B%22id%22%3A%22Page-6%22%2C%22label%22%3A%22Page%22%2C%22title%22%3A%22login%22%2C%22x%22%3A81.58592855522625%2C%22y%22%3A471.1559756278914%7D%2C%7B%22id%22%3A%22Logic%20App-5%22%2C%22label%22%3A%22Logic%20App%22%2C%22title%22%3A%22Logic%20App%22%2C%22x%22%3A321.6307309491443%2C%22y%22%3A612.4713008777226%7D%2C%7B%22id%22%3A%22API%20Management-6%22%2C%22label%22%3A%22API%20Management%22%2C%22title%22%3A%22myApim%22%2C%22x%22%3A322.4067241967431%2C%22y%22%3A288.1743103700328%7D%5D%2C%22edges%22%3A%5B%5D%7D">

### Front-end & Back-end
Home page 
The concept of front-end and back-end still exists within this context. However, the lines can be a bit blurry sometimes. But even modern framework like next.js utilize this kind of feature mixing front and back-ends into one application. You can essentiality choose how much client code you would like to implement with Logic App as web app. The method I found to quite straight was to build that one page would be one workflow. 

### Routing
Correct routing is a big part of making this work
### Assets 
Dealing with assets is also a bit tricky since you can't do any direct pointing the server since it is a Logic App service, but the way you would do it is to in Azure expose a storage account on a specific path. Like domain.se/assets/**.img/jpg 

### Redirecting

### Authentication

### Cache APIM internal

### Performance / Stateless / avoid to much complexity within liquid.


## Turning Logic App into a web app 🌐
As mentioned earlier, Logic Apps does not provide these features out of the box, but we can build it!⚒️

**How do we achieve this?**



## Reflections
