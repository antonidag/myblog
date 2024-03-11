---
title: "API Testing with Postman and Github Actions"
date: 2024-03-10T00:00:00+00:00
draft: false
description: ""
image: ""
---

## Background 
Testings is can be hard, but API testing has never been this easy. 

In this blog post we will automate testing with Postman with Github Actions.

## What is Postman?
Postman is a popular tool to call API:s, it has a easy to use UI and have become more and more soficticated. Now days Postman comes with a lot of features.

## Building a simple Logic App

## Creating API tests 
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