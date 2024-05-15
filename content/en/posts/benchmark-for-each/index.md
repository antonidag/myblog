---
title: "Fast Lane or Slow Lane? Choosing the Quickest Logic App For Loop!🏎️"
date: 2024-05-13T00:00:00+00:00
draft: false
description: 
image: "posts/benchmark-for-each/preview.gif"
---

## Background
Benchmark on For, Javascript & Liquid template.
There is a bit of noise around how performant the Logic App for loop really is, 
Looping over an array and preforming operations on each item, is a quite common task.

We will conduct a benchmark between the Logic Apps, and [Liquid Operation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption) action, inorder to get more insight on how the different methods perform.

## Exploring options For loops
Loop over an array of elements is one of bread and butter when it comes programming, in Logic Apps this is normally perform by the [For each](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-loops?tabs=consumption#foreach-loop) action. However there are many ways to interact with a collection such as [Inline code](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption), [Liquid Transformation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption), [Data Operations](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-perform-data-operations?tabs=consumption) and even [Expressions](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference). Some of mentions actions are more limited and others are more free on what you can dom, so depending on the operation you would like to perform some method might more suitable than others. 
For example if you would like to filter an collection based on property the Filter Actions is good, if you would like to reverse the order of in an array you can simply use the [reverse](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference#reverse) Expression. 
In this benchmark we will take an extra look that the following actions.
### For Each
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

### Inline code
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

### Liquid Operation
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

There is also the option to use Liquid transformation, but we will skip it to narrow down the scope.

## The Benchmark
How the benchmark is made.

### Scenario Description

### Workflow implementation
Some diagram 

__For each__
workflow - for loop to workflow
HTTP input loop elements
for each line
    compose action new JSON object
    Add to variable
return variable

__Incline code__
workflow - JavaScript loop to workflow
HTTP input loop elements
JavaScript Action
    new {}
    push to array
return JavaScript output

__Liquid Transformation__
workflow - Liquid loop to workflow
HTTP input loop elements
Liquid Transformation
    `{{ forloop}}`
return Liquid output

### Environment settings
App service plans settings

Workflow settings

## Result
Present the results
### Time per element in seconds
### Difference compared to For each action in seconds
### Average time per element in seconds
- For each: __0.231__
- Inline code: __0.264__
- Liquid Transformation: __0.461__

## Reflections

in an blog post from Microsoft it gives you tips in ways you can optimise your workflow and etc...https://techcommunity.microsoft.com/t5/azure-integration-services-blog/using-inline-code-instead-of-a-foreach-loop-for-better/ba-p/3369587

For anyone more intressed in benchmark, I have made a similar test on a another topic rather condition actions [blog](/posts/benchmark-condition/). 