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

We will conduct a benchmark between the Logic Apps [For each](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-loops?tabs=consumption#foreach-loop), [Inline code](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption) and [Liquid Operation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption) action, inorder to get somewhat more insight on how the different actions perform.

## Exploring options For loops

### For Each action
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

### Inline code action
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

### De-batching - which should we choose? JavaScript or For each? 
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