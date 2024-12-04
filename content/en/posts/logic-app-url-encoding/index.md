---
title: "Working with url-encoded data in Logic Apps?🔢"
date: 2024-10-07T00:00:00+00:00
draft: false
description: "Learn how to handle multipart/form-data in Azure Logic Apps Standard. Reading and sending multipart data using HTTP connectors, with step-by-step examples."
image: "posts/logic-app-multipart-form-data/logic-app-multipart-data.gif"
---

## Background 
Azure Logic Apps provides robust support for sending data in various formats, like `JSON`, `XML`, and text. 
However, in some cases, you may need to send a request and receive in the `application/x-www-form-urlencoded` format, typically used for form submissions in web applications. 
In this guide we will walk you through sending URL-encoded data in Logic Apps!

## What is URL Encoding? 🔢
URL encoding also official known as Percent-encoding is a technique to represent characters in a URL as alphanumeric and hexadecimal escape codes. 
In an URL some characters are reserved for special functions and are there for not allowed. For more information regarding Percent-encoding [see here](litnk to morzilla).
An example of this would be:

- `Hello Foo Bar?`
- `Hello%20Foo%20Bar%3F`

URL encoding is most often associated with the `application/x-www-form-urlencoded` content type. Similar to multipart content, URL-encoded data is commonly used in form submissions, but with the distinction that the data is sent as key-value pairs.

Let's look at a practical example, here is an raw HTTP request with URL-encoded data using Postman: 
```
POST /anything HTTP/1.1
Host: httpbin.org
Content-Type: application/x-www-form-urlencoded
 
firstName=Hello%20Foo%20Bar!%3F&lastName=person&municipality=Skåne
```
As you can see, the data was sent as key-values in the request body and separated by the `&` character. The two keys being `text` and `additional` in the example above.
Now that we have a basic understanding we can move on to Logic Apps!

## Sending URL-Encoded Data with Logic Apps📤
Create a new Logic Apps workflow and use the HTTP connector to define the structure of your request. Ensure that the Content-Type is set to `application/x-www-form-urlencoded`, which will tell the receiving service to interpret the data in the correct format.

Here’s how you can set it up:

Step 1: Configure the HTTP Connector
In your Logic Apps Designer, add an HTTP action. Set the following properties:



In this example, we'll send a URL-encoded payload containing a user's details.

Create an HTTP action and configure the URI and method.
Set the Content-Type header to application/x-www-form-urlencoded.
In the Body field, construct the URL-encoded string using Logic Apps expressions.
Your final setup should look like this:

```
{
  "type": "Http",
  "inputs": {
    "uri": "https://httpbin.org/anything",
    "method": "POST",
    "headers": {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    "body": "firstName=@{uriComponent('Foo')}&lastName=@{uriComponent('Bar')}&age=@{uriComponent('30')}&municipality=@{uriComponent('Skåne')}"
  },
  "runAfter": {},
  "runtimeConfiguration": {
    "contentTransfer": {
      "transferMode": "Chunked"
    }
  }
}
```


#

Method: POST
URI: the endpoint URL where you're sending the request
Headers: Set the Content-Type header to application/x-www-form-urlencoded
Step 2: Construct the Request Body
The body of the request should be a single string in key-value pair format. For example:


To dynamically construct this URL-encoded body, use Logic Apps expressions to concatenate data from your workflow.

Example
Here’s a sample request to send user information in a URL-encoded format:


In this setup:

@{encodeUriComponent()} is used to ensure the values are URL-encoded, especially useful if the values contain special characters.

### Receiving URL-Encoded Data with Logic Apps 📨
Logic Apps can also receive URL-encoded data using the Request trigger. When receiving data in a URL-encoded format, Logic Apps parses the data into key-value pairs, which can be accessed directly in your workflow.

Example of a URL-encoded HTTP Request
Here's an example of a URL-encoded HTTP POST request that you might receive:


## Reflections

URL-encoding in Logic Apps opens up easy integration with web services requiring this data format. By setting up the Content-Type header correctly and encoding your data, you can reliably send URL-encoded requests to various APIs or services. With these steps, you’re well-equipped to work with URL-encoded data in Logic Apps, broadening the range of integrations available to your workflows.

Happy automating!