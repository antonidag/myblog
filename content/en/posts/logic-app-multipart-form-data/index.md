---
title: "How to send and retrieve multipart/form-data & form-urlencoded with Logic Apps? "
date: 2024-09-12T00:00:00+00:00
draft: false
description: ""
image: "posts/postman-api-testing-github-actions/postman-api-testing.gif"
---

## Background 
The support for working with pain JSON, XML or text files is great in Logic Apps, however sometimes you need send a customized message or a request to a service, in othercase you need to be available handle a different content type than your typical JSON or XML payloads and those can be a bit more challenging. In this guide we will a specially look into the two less used media content types  `multipart/form-data` and `application/x-www-form-urlencoded` payloads! 

## What is the Content-type HTTP header? 📭
The `Content-type` HTTP header is used to describe the payload format. in the HTTP request and response so that the recevning side can decode/parse the payload correctly. There are many different content types, most commonly seen in REST APIs are usually `application/json` or `application/xml`. The `Content-Type` should not be confused with the encoding of the payload, the HTTP header `Content-Encoding` describes the applied encoding on the resource. 

### What is multipart/form-data & xxx-www-form-urlencoded?
So let's continue with the content type `multipart/form-data`  you will encounter the content type `application/xxx-www-form-urlencoded` at least in my experience when working with HTML submit form for example.  I have seen this been implemented in webhooks and HTML forms, there is probably more. 

Okey, but how does it look and work?
Some example of multipart/form-data: 
`Some RAW HTTP request`


Some example of application/xxx-www-form-urlencoded: 
`some raw HTTP request`

## Multipart/form-data & xxx-www-form-urlencoded with Logic Apps
Now we pretty much know a bunch of things, but how does it work within Logic Apps? 
Logic Apps likes to talks in HTTP and JSON/XML, but mostly HTTP and JSON.


SOme examples: 
## Reflections