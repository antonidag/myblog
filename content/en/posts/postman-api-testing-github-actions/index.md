---
title: "API APIM Policy Testing with Postman and Github Actions"
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


## Building a API with APIM policy
Let's just break down an API within Azure API Management. In APIM an API can have several operations. All operations has policy attached to them, a policy can be applied to all operations, but individual operations can specific polices. An operation consists of four parts:
- Frontend: The API definition and specification
- Inbound processing: Modify the request before it is sent to the backend.
- Backend: The service the request is sent to.
- Outbound processing: Modify the request before it is sent to the client.

There is a lot more to be said about APIM, but for now we will not dive in anyfurvere. 

To make things simple we will use the out of the box Echo API that is created with an APIM instance. We edit APIM policy to check for authentication, add headers and etc.


## Creating API tests in Postman
There is great guides on this topic at Postman documentation, want to know more about see [here]().


Once you understand the syntax and framework writing test in Postman is really fun and easy. If you have worked with the product before you feel just as home. 

For our Echo API we will test the following: 
- Working Authentication. API operation should return 401 if use is not authorized.
- Validate payload depending on Content-Type header. 
- Validate that headers are added correctly
```
pm.test("response is ok", function () {
    pm.response.to.have.status(200)
})

```
## Automate Postman Test with Github Actions
Before diving into the setup process, there are a few prerequisites to fix:
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
          postman collection run "27855227-bba92014-b4eb-467c-ad6b-7262094566b3"
          # Lint your API using Postman CLI
          postman api lint 505d75de-5634-4d35-9b35-0d0d23710c3c
```
## Reflection