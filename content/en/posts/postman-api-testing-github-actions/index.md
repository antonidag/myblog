---
title: "Automated API Testing with Postman and Github Actions"
date: 2024-03-10T00:00:00+00:00
draft: false
description: ""
image: ""
---

## Background 
Testing software is an important part of its lifecycle and a big part of its success. There is lot different frameworks and method out there. Finding the right tool for the project could sometime be challenging! [Postman](https://www.postman.com/) is popular API platform for building and using APIs, and widely used among developers, architects and technical functions! 

Integrating testing in the CI pipeline can improve the overall quality and productivity. Therefor, in this blog post we will explore how Postman can be used to automate API testing using Github Actions. 

## What is Postman?
As mention before Postman is a popular platform to build and using API:. Postman is packed with a lot of features such as workspaces where you share and build API artifacts. It also comes with the availability to perform load testing and test individual API:s. For more information more about Postman and its feature read more at their [website](https://www.postman.com/product/what-is-postman/)

## Integration Testing
When it comes to testing software there are many different approaches unit, functional, integration and end-to-end testing to mention a few. Some are more fitted for some type of testing and other for another method. Integration testing verifies that the components or modules interacts as intended. Typically integration tests could be verifying an: 
- External API 
- Database Integration
- or File system Integration

[book](https://www.techtarget.com/searchsoftwarequality/definition/integration-testing)

## Creating API tests in Postman
We are going to test an weather API from [weatherapi.com](https://www.weatherapi.com/). They provide a rich amount of API:s, see their API documentation for more [info](https://www.weatherapi.com/docs). 

We want test & validate that the:
- Authentication is working
- Validate expected HTTP headers
- Validate JSON payload


Before we can jump into writing test, we first need work inside of Postman. Start by creating a new Collection and name it appropriate to the API you are testing, in my case "Weather API".
There is several ways to import collections and API:s into Postman, I will create the HTTP request manually. Depending on your API there could different types on parameters, headers and authentication required, this configuration is supported by Postman. 

To create test for an API we need to navigate to the "Test" menu inside of the created request. Tests in Postman are written in JavaScript. There is [documentation](https://learning.postman.com/docs/writing-scripts/script-references/script-reference-overview/), test examples and how-tos that can be helpful to familiarize with before starting writing your test cases. Once you have some basic knowledge around it will come quite easy to start! 

However, let's by creating this simple test:
```
pm.test("Successful authentication", function () {
    pm.expect(pm.response).to.have.status(200); // 200 indicates successful authentication
});


```
To run the test, we need to right click the collection and enter the "Run collection" menu. Then we can click on run to see the results. 

If you have a hard time writing the tests, you can get help from the [Postbot](https://www.postman.com/product/postbot/). The bot can assist you with fixing, adding more tests and writing documentation for the API.
With a bit of editing and help from the bot the tests for one of API operations finalized to: 
```
pm.test("Validate headers", function () {
    pm.response.to.have.header('Content-Type', 'application/json');
});
pm.test("Successful authentication", function () {
    pm.expect(pm.response).to.have.status(200); 
});
pm.test("Payload is json", function () {
    pm.response.to.have.jsonBody();
});
pm.test("Validate payload properties", function () {
    var responseBody = pm.response.json();
    pm.expect(responseBody).to.have.property('location');
    pm.expect(responseBody).to.have.property('current');
});
pm.test("Temperature is within a valid range", function () {
    const responseData = pm.response.json();
    pm.expect(responseData.current.temp_c).to.be.a('number');
    pm.expect(responseData.current.temp_c).to.be.within(-100, 100);
});
pm.test("Wind speed should be a non-negative number", function () {
    const responseData = pm.response.json();
    pm.expect(responseData.current.wind_kph).to.be.a('number');
});
pm.test("Location information is not empty", function () {
  const responseData = pm.response.json();
  pm.expect(responseData.location).to.exist.and.to.not.be.empty;
});
pm.test("Validate last_updated field format", function () {
    const responseData = pm.response.json();
    pm.expect(responseData.current.last_updated).to.match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/);
});
pm.test("Precipitation is a non-negative number", function () {
    const responseData = pm.response.json();
    pm.expect(responseData.current.precip_mm).to.be.at.least(0);
    pm.expect(responseData.current.precip_in).to.be.at.least(0);
});
pm.test("UV index is a non-negative number", function () {
    const responseData = pm.response.json();
    pm.expect(responseData.current.uv).to.be.a('number');
    pm.expect(responseData.current.uv).to.be.at.least(0);
});
```

There is a great guide on this topic at Postman documentation, if you want to know more about see [here]().

## Automate Postman Test with Github Actions
Before diving into the setup process, there are a few prerequisites to fix:
- __Generate Postman API Key__
- __Set up a GitHub Project:__ Create a project in GitHub and set up an Environment within your project.
- __Add GitHub Secrets:__ Store credentials securely as GitHub secrets to ensure they are not exposed in your repository.

Worth mention is that their could be more to configure and to think about if you where to use Postman in a real wold CI pipeline. For instance different environment and variables and etc. 


However, once you have all your variables and secrets done Postman has made running a tests in Github Actions super simple! 
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

When the workflow is done it will generate and output similar to the following:
```
Run postman collection run "27855227-be5be94b-8361-4efc-afd2-49762436fcef"
  
postman

Weather API

→ Current
  GET http://api.weatherapi.com/v1/current.json?key={APIKey}&q=Malmo&aqi=no [200 OK, 1.32kB, 355ms]
  ✓  Validate headers
  ✓  Successful authentication
  ✓  Payload is json
  ✓  Validate payload properties
  ✓  Temperature is within a valid range
  ✓  Wind speed should be a non-negative number
  ✓  Location information is not empty
  ✓  Validate last_updated field format
  ✓  Precipitation is a non-negative number
  ✓  UV index is a non-negative number

→ Forecast
  GET http://api.weatherapi.com/v1/forecast.json?key={APIKey}&q=Malmo&days=1&aqi=no&alerts=no [200 OK, 17.97kB, 237ms]
  ✓  Validate headers
  ✓  Successful authentication
  ✓  Payload is json
  ✓  Temperature is within a valid range
  ✓  Hour array is present and has expected number of elements
  ✓  Response has the required fields
  ✓  Localtime is in a valid date format
  ✓  Forecastday array is present and contains the expected number of elements
  ✓  Last updated time is in a valid date format
  ✓  Condition object within the 'current' object should exist and be an object

→ History
  GET http://api.weatherapi.com/v1/forecast.json?key={APIKey}&q=Malmo&days=1&aqi=no&alerts=no [200 OK, 17.97kB, 6ms]
  ✓  Validate headers
  ✓  Successful authentication
  ✓  Payload is json
  ✓  Response time is less than 200ms
  ✓  Forecast contains at least one forecastday
  ✓  Temperature is within a reasonable range
  ✓  Wind direction is in a valid format
  ✓  Condition text is a non-empty string
  ✓  UV index is a non-negative integer

┌─────────────────────────┬────────────────────┬───────────────────┐
│                         │           executed │            failed │
├─────────────────────────┼────────────────────┼───────────────────┤
│              iterations │                  1 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│                requests │                  3 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│            test-scripts │                  6 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│      prerequest-scripts │                  3 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│              assertions │                 29 │                 0 │
├─────────────────────────┴────────────────────┴───────────────────┤
│ total run duration: 721ms                                        │
├──────────────────────────────────────────────────────────────────┤
│ total data received: 35.29kB (approx)                            │
├──────────────────────────────────────────────────────────────────┤
│ average response time: 199ms [min: 6ms, max: 355ms, s.d.: 144ms] │
└──────────────────────────────────────────────────────────────────┘

Postman CLI run data uploaded to Postman Cloud successfully.
```
Here you can see the summery of the all the tests and valvule information such as execution time, how many assertions and etc.

## Reflection

PostBot really nice, well integrated, helps with you workflow.