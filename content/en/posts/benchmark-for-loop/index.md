---
title: "Fast Lane or Slow Lane? Choosing the Quickest Logic App For Loop!🏎️"
date: 2024-05-13T00:00:00+00:00
draft: false
description: 
---

## Background
Benchmark on For, Javascript & Liquid template.
There is a bit of noise around how performant the Logic App for loop really is, in an blog post from Microsoft it gives you tips in ways you can optimise your workflow and etc...
Looping over an array and preforming operations on each item, is a quite common task.

We will conduct a benchmark between the Logic App [For loop](), [Inline code]() and [Liquid Operation]() action, inorder to get somewhat more insight on how the different actions perform.

##  Exploring For loops

https://techcommunity.microsoft.com/t5/azure-integration-services-blog/using-inline-code-instead-of-a-foreach-loop-for-better/ba-p/3369587

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

### Liquid Operations action
Limitations of each action:
- 100 000 iteration
- Parallisme 
- Size? 

Method

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