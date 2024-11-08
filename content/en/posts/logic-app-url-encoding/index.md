---
title: "How to send and read url-encoded data with Logic Apps?📄"
date: 2024-10-07T00:00:00+00:00
draft: false
description: "Learn how to handle multipart/form-data in Azure Logic Apps Standard. Reading and sending multipart data using HTTP connectors, with step-by-step examples."
image: "posts/logic-app-multipart-form-data/logic-app-multipart-data.gif"
---

## Background 
Azure Logic Apps provides robust support for sending data in various formats, like JSON, XML, and text. However, in some cases, you may need to send a request in the application/x-www-form-urlencoded format, typically used for form submissions in web applications. This guide will walk you through sending URL-encoded data in Logic Apps, enabling you to communicate seamlessly with services expecting this content type.

## What is URL Encoding? 🔢
URL encoding is a technique to represent characters in a URL as alphanumeric and hexadecimal escape codes. This is essential for handling special characters that aren't allowed in URLs or are reserved for specific functions. URL-encoded data is commonly used in form submissions, where data is sent in key-value pairs like firstName=Foo&lastName=Bar.

URL encoding is most often associated with the application/x-www-form-urlencoded content type. Unlike multipart/form-data, which can handle binary data and multiple parts, URL encoding is straightforward and best suited for simple text data.

### The Content-Type HTTP Header: URL Encoding
The Content-Type HTTP header, which informs the server about the format of the data, is crucial here. For URL-encoded data, the header is application/x-www-form-urlencoded. When using this content type, data is encoded in a query string-like format. For example:
```
POST /anything HTTP/1.1

firstName=Foo&lastName=Bar&age=30
```


## Sending URL-Encoded Data with Logic Apps
### Setting Up the Workflow 🛠️
To get started, create a new Logic Apps workflow and use the HTTP connector to define the structure of your request. Ensure that the Content-Type is set to application/x-www-form-urlencoded, which will tell the receiving service to interpret the data in the correct format.

Here’s how you can set it up:

Step 1: Configure the HTTP Connector
In your Logic Apps Designer, add an HTTP action. Set the following properties:

Method: POST
URI: the endpoint URL where you're sending the request
Headers: Set the Content-Type header to application/x-www-form-urlencoded
Step 2: Construct the Request Body
The body of the request should be a single string in key-value pair format. For example:

```
// Some fields in the output has been removed for readability. 
{
    "headers": {
        "Content-Type": "multipart/form-data; boundary=--------------------------493073486649885477988289"
    },
    "body": {
        "$content-type": "multipart/form-data; boundary=--------------------------493073486649885477988289",
        "$content": "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTQ5MzA3MzQ4NjY0OTg4NTQ3Nzk4ODI4OQpDb250ZW50LURpc3Bvc2l0aW9uOiBmb3JtLWRhdGE7IG5hbWU9IkZpcnN0TmFtZSIKCkZvbwotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tNDkzMDczNDg2NjQ5ODg1NDc3OTg4Mjg5CkNvbnRlbnQtRGlzcG9zaXRpb246IGZvcm0tZGF0YTsgbmFtZT0iTGFzdE5hbWUiCgpCYXIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTQ5MzA3MzQ4NjY0OTg4NTQ3Nzk4ODI4OQpDb250ZW50LURpc3Bvc2l0aW9uOiBmb3JtLWRhdGE7IG5hbWU9IkFnZSIKCjMwCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS00OTMwNzM0ODY2NDk4ODU0Nzc5ODgyODktLQ==",
        "$multipart": [
            {
                "headers": {
                    "Content-Disposition": "form-data; name=\"FirstName\"",
                    "Content-Length": "3"
                },
                "body": {
                    "$content-type": "application/octet-stream",
                    "$content": "Rm9v"
                }
            },
            {
                "headers": {
                    "Content-Disposition": "form-data; name=\"LastName\"",
                    "Content-Length": "3"
                },
                "body": {
                    "$content-type": "application/octet-stream",
                    "$content": "QmFy"
                }
            },
            {
                "headers": {
                    "Content-Disposition": "form-data; name=\"Age\"",
                    "Content-Length": "2"
                },
                "body": {
                    "$content-type": "application/octet-stream",
                    "$content": "MzA="
                }
            }
        ]
    }
}
```

To dynamically construct this URL-encoded body, use Logic Apps expressions to concatenate data from your workflow.

Example
Here’s a sample request to send user information in a URL-encoded format:

```
{
  "method": "POST",
  "uri": "https://example.com/api/submit",
  "headers": {
    "Content-Type": "application/x-www-form-urlencoded"
  },
  "body": "firstName=@{encodeUriComponent('Foo')}&lastName=@{encodeUriComponent('Bar')}&age=@{encodeUriComponent('30')}"
}

```

In this setup:

@{encodeUriComponent()} is used to ensure the values are URL-encoded, especially useful if the values contain special characters.

### Receiving URL-Encoded Data with Logic Apps 📨
Logic Apps can also receive URL-encoded data using the Request trigger. When receiving data in a URL-encoded format, Logic Apps parses the data into key-value pairs, which can be accessed directly in your workflow.

Example of a URL-encoded HTTP Request
Here's an example of a URL-encoded HTTP POST request that you might receive:


### Sending URL-Encoded Data 📤
In this example, we'll send a URL-encoded payload containing a user's details.

Create an HTTP action and configure the URI and method.
Set the Content-Type header to application/x-www-form-urlencoded.
In the Body field, construct the URL-encoded string using Logic Apps expressions.
Your final setup should look like this:

```
{
  "method": "POST",
  "uri": "https://example.com/api/submit",
  "headers": {
    "Content-Type": "application/x-www-form-urlencoded"
  },
  "body": "firstName=@{encodeUriComponent('Alice')}&lastName=@{encodeUriComponent('Johnson')}&age=@{encodeUriComponent('28')}"
}


```
Notice that we did not set the `boundary` value since this gets auto generated by HTTP connector. You can test this workflow by calling the former workflow to make sure it works as intended. 

Below is the final code configuration for sending a `multipart/form-data` message: 
![workflow_send](workflow_send.png)

## Reflections

URL-encoding in Logic Apps opens up easy integration with web services requiring this data format. By setting up the Content-Type header correctly and encoding your data, you can reliably send URL-encoded requests to various APIs or services. With these steps, you’re well-equipped to work with URL-encoded data in Logic Apps, broadening the range of integrations available to your workflows.

Happy automating!