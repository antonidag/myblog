---
title: "Automated API Testing with Postman and Github Actions"
date: 2024-03-10T00:00:00+00:00
draft: false
description: ""
image: ""
---

## Background 
Testing Azure API management polices are often done inside of the Azure Portal. But testing manually in the portal can lead to mistakes, you might for get something.

In this blog post we will automate post deployment testing with Postman with Github Actions.

## What is Postman?
Postman is a popular tool to call API:s, it has a easy to use UI and have become more and more soficticated. Now days Postman comes with a lot of features.


## Creating API tests in Postman
We are going to work with a simple Clock REST API, where there is one operation. The operation returns the current time in a json payload. To call the API you need to authenticate with Basic Auth. Here is a raw HTTP response to give you an idea of what we are dealing with: 


```
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 42
Connection: keep-alive
Date: Mon, 18 Mar 2024 16:07:12 GMT
x-powered-by: Express
access-control-allow-methods: GET
x-content-type-options: nosniff
cache-control: no-cache
etag: W/"2a-lj4sTj08ZO6Lk3iDiwPdhwn7+iI"


{
  "currentTime":"2024-03-18T16:07:12.026Z"
}
```

We will test & validate that the:
- Basic Authentication is working
- Validate the expected HTTP Headers
- Validate json payload


Before we can jump into writing test, we first we need to create a new "Collection" and then import or manually create the our requests. 
- set up request and other stuff

After the request are created, we need to goto the "Test" menu. Here we can set up our testing code.

To start of simple, lets test the that the API returns the correct http status:
```
pm.test("response is ok", function () {
    pm.response.to.have.status(200)
})

```
To run the test, we need to right click the collection and enter the Run collection menu. Then we can click on run to see the results. 


Once you understand the syntax and framework writing test in Postman is really fun and easy.

Here is the final code for testing: 
```
pm.test("validate headers", function () {
    pm.response.to.have.header('Content-Type', 'application/json; charset=utf-8'); // Check Content-Type header value
    pm.response.to.have.header('Access-Control-Allow-Methods', 'GET'); // Check Access-Control-Allow-Methods header value
    pm.response.to.have.header('X-Content-Type-Options', 'nosniff'); // Check X-Content-Type-Options header value
    pm.response.to.have.header('Cache-Control', 'no-cache'); // Check Cache-Control header value
});

pm.test("successful authentication", function () {
    pm.expect(pm.response).to.have.status(200); // 200 indicates successful authentication
});

pm.test("payload is json", function () {
    pm.response.to.have.jsonBody(); // Check body to be json
})

pm.test("validate currentTime field", function () {
    // Parse the response body as JSON
    var responseBody = pm.response.json();

    // Check if the currentTime field exists
    pm.expect(responseBody).to.have.property('currentTime');

    // Check if the currentTime field is a valid ISO 8601 date
    pm.expect(responseBody.currentTime).to.match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/);
});


```

There is a great guide on this topic at Postman documentation, if you want to know more about see [here]().

## Automate Postman Test with Github Actions
Before diving into the setup process, there are a few prerequisites to fix:
- __Generate Postman API Key__
- __Set up a GitHub Project:__ Create a project in GitHub and set up an Environment within your project.
- __Add GitHub Secrets:__ Store credentials securely as GitHub secrets to ensure they are not exposed in your repository.

```
name: Automated API tests using Postman CLI

on: push

jobs:
  automated-api-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Postman CLI
        run: |
          curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
      - name: Login to Postman CLI
        run: postman login --with-api-key ${{ secrets.POSTMAN_API_KEY }}
      - name: Run API tests
        run: |
          postman collection run "27855227-be5be94b-8361-4efc-afd2-49762436fcef"
```
## Reflection