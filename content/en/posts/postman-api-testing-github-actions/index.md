---
title: "Automating API Testing with Postman and GitHub Actions 👩‍🔬"
date: 2024-05-07T00:00:00+00:00
draft: false
description: "Learn how to improve your software development process by automating API testing with Postman and GitHub Actions. Gain practical insights and step-by-step instructions to streamline your CI/CD pipeline, boost productivity, and ensure software reliability. Join us as we harness the power of automation to optimize development workflows."
image: "posts/postman-api-testing-github-actions/postman-api-testing.gif"
---

## Background 
Testing software is an important part of its lifecycle and a big factor of its success. There are many different frameworks and methods available, and finding the right tools can sometimes be challenging! <a href="https://www.postman.com" target="_blank" rel="noopener noreferrer">Postman</a> is a popular API platform for building and using APIs, widely used among developers, and is one of the tools that makes testing simpler.

Integrating testing into your CI pipeline can help improve the overall quality and productivity. Therefore, in this blog post, we will explore how Postman can be used to automate API testing using <a href="https://docs.github.com/en/actions" target="_blank" rel="noopener noreferrer">GitHub Actions</a>!

## What is Postman? 📭
As mentioned before, Postman is a popular platform for building and using APIs. In addition to building APIs, Postman can also be used for testing, documentation, and even the creation of workflows using a visual designer. If you want to know more check out this <a href="https://blog.postman.com/10-postman-features-everyone-should-know/" target="_blank" rel="noopener noreferrer">blog</a> for more information regarding Postman's features.

## Creating API tests in Postman 🧪
We are going to test an weather API from <a href="https://www.weatherapi.com/" target="_blank" rel="noopener noreferrer">weatherapi.com</a>. However you can use any another HTTP API or third party service. Weatherapi.com offers an free tier and once you have your account, you can generate an API Key and follow along.

In our case we want test & validate that the APIs works as intended:
- Authentication
- Expected HTTP headers
- JSON payloads
- Fields are in the correct format & values

But before we can jump into writing tests, we first need to work inside of Postman a bit. Start by creating a new Collection and name it appropriately for the API you are testing. There are several ways to import collections and APIs into Postman, for instance by an Open API specification, cURL and raw text to mention a few. Depending on your API, there might be parameters, headers, and authentication, that you will need to setup before continuing.

To create tests for an API, we need to navigate to the "Test" menu. This menu is found under the API operation itself. Tests in Postman are written in JavaScript and there is a lot <a href="https://learning.postman.com/docs/writing-scripts/script-references/script-reference-overview/" target="_blank" rel="noopener noreferrer">documentation</a>, test examples, and how-tos to help you get started. Once you have some basic knowledge, it will become quite easy!

Let's start by copy this code into Postman:
```
pm.test("Successful authentication", function () { 
  pm.expect(pm.response).to.have.status(200);
});
```
This code above will evaluate that we got an response code of `200`. To run the test, we need to right-click the collection and enter the "Run collection" menu. Then, we can click on "Run {Collection name}", wait a few seconds and view the results.

If you get stuck or are having difficulties writing test cases, you can get help from the <a href="https://www.postman.com/product/postbot/" target="_blank" rel="noopener noreferrer">Postbot</a>. The bot can assist you with writing tests, fixing tests, and even writing documentation. It has an similar interface as ChatGPT where you write prompts on what you need help with and then the changes will be added to your code.

After some editing and help from the bot, the tests for all off the API operations could easily be written within an hour and here is an example of what that can look like:
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
  pm.expect(responseData.current.wind_kph).to.be.at.least(0);
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
Once we have all our test cases and the code is ready, we can begin to have automated testing in our pipelines!🎬

## Automate Postman Test with Github Actions ⚙️
Before diving into the setup process, there are a few prerequisites to fix:
- __Generate Postman API Key__
- __Set up a GitHub Project:__ Create a project in GitHub and set up an Environment within your project.
- __Add GitHub Secrets:__ Store credentials securely as GitHub secrets to ensure they are not exposed in your repository.

Worth mentioning is that there could be more to configuration and think about if you where to use Postman in a production environment.

When you have configured both Postman and Github, setting up the Github actions is the simple part. Open up Postman, go to the "Run Collection" menu and under the "Run on CI/CD". From here you can configure the CI/CD settings such as environments, if you are using Github or Azure DevOps, Linux or Windows machine and etc. When you are ready, simply copy the CLI commands and paste the code into your project. For Github Actions it will look similar to this:   
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
          postman collection run ${{ secrets.POSTMAN_COLLECTION_ID }}
```

By default the pipeline will run on "push" to the repository. When a run is triggered, the API tests will start to execute:
```
Run postman collection run POSTMAN_COLLECTION_ID 
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
Here you can see the result of each individual API tests, response time and payload size. You will also get an summery including data such as the amount of executed requests, assertions, average response times and total duration of the test. This is pretty much standard and what you normally would expect from these types of testing tools.  

## Reflections

Postman has made it really simple and easy to both write and test APIs within their platform. Integrating the tests into the CI/CD pipeline is also ridiculously simple; all the code can be generated by Postman, and it works out of the box. 

I also briefly mention the Postbot in the section <a href="#creating-api-tests-in-postman-">Creating API tests in Postman 🧪</a>. If you have not tried it out, it is worth testing and playing around with because it is well-integrated and gives instant feedback. For instance, adding additional tests is a prompt away: "cover more test cases," and the bot will add more code. Even though you still might need to manually edit and review the code, it definitely saves you some time.

For anyone thinking of integrating Postman into their CI/CD process, I think there are a few things to consider:

- What types of testing are you going to perform?
- Are the protocols supported in Postman?
- What happens if Postman Cloud is down?
- And the pricing?

These are just some questions that come to mind, but regardless, it is a pretty awesome tool for API-related tasks, whether it is testing or consuming APIs.