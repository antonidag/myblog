---
title: "How to send and get multipart/form-data with Logic Apps? "
date: 2024-09-12T00:00:00+00:00
draft: false
description: ""
image: "posts/postman-api-testing-github-actions/postman-api-testing.gif"
---

## Background 
The support for working with pain JSON, XML or text files is great in Logic Apps, however sometimes you need send a customized message or a request to a service, in some cases you need to be available handle a different content type than your typical JSON or XML payloads and those can be a bit more challenging. In this guide we will a specially look into the less used media content type  `multipart/form-data` payloads! 

## What is the Content-Type HTTP header? 📭
The `Content-type` HTTP header is used to describe the payload format. in the HTTP request and response so that the recevning side can decode/parse the payload correctly. There are many different content types, most commonly seen in REST APIs are usually `application/json` or `application/xml`. The `Content-Type` should not be confused with the encoding of the payload, the HTTP header `Content-Encoding` describes the applied encoding on the resource. 

### What is multipart/form-data?
So let's continue with the content type `multipart/form-data`, you will encounter this type of  content type, at least in my experience when working with HTML forms as for an example. The user needs to submit there first/last name and perhaps attach an file as well. There is probably many more implementations where the content type `multipart/form-data` is used, but just to give you feel where you might encounter this. 

Okey, but how does it look and work? Below is an example request of sending `multipart/form-data` from the Postman client: 
```
POST /anything HTTP/1.1
Host: httpbin.org
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Content-Type: multipart/form-data; boundary=--------------------------671747156319508458970968
Content-Length: 506
 
----------------------------671747156319508458970968
Content-Disposition: form-data; name="Age"
30
----------------------------671747156319508458970968
Content-Disposition: form-data; name="FirstName"
Foo
----------------------------671747156319508458970968
Content-Disposition: form-data; name="LastName"
Bar
----------------------------671747156319508458970968
Content-Disposition: form-data; name="AdditionalInfo"
SGVsbG8gV29ybGQh
----------------------------671747156319508458970968--
```
This is the raw HTTP request taken from the Postman console, and one thing that stands out in the payload body, is that the body content is sent as a blocks of data. Each block is dived by the `boundary` value and is separating each block. As a part of each block there is a `Content-Disposition` header. This header must be a apart of a multipart body to give information about the field it is applied to. One thing important to mention is also that the value of `boundary` is user-defined, meaning that it is something that the sending party needs implement. In the example above you you see that we have four blocks; Age, FirstName, LastName and AdditionalInfo. Value of each "key" can be viewed under the `Content-Disposition` header, so for "Age" its `30`, "FirstName" equals `Foo` and so on. 

If it is still unclare head over this this source to read [more](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST) [Content-Disposition](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition).


## Multipart/form-data with Logic Apps
Now we pretty much know a bunch of things, but how does it work within Logic Apps? 
Logic Apps likes to talks in HTTP and JSON/XML, but mostly HTTP and JSON.


SOme examples: 
## Reflections