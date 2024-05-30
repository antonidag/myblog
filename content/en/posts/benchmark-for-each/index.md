---
title: "Foreach loop vs performances"
date: 2024-05-13T00:00:00+00:00
draft: false
description: 
image: "posts/benchmark-for-each/preview.gif"
---

## Background
Benchmark on For, Javascript & Liquid template.
There is a bit of noise around how performant the Logic App for loop really is, 
Looping over an array and preforming operations on each item, is a quite common task.

We will conduct a benchmark between the Logic Apps,  action, inorder to get more insight on how the different methods perform.

## Exploring options For loops
Loop over an array of elements is one of bread and butter when it comes programming, in Logic Apps this is normally perform by the [For each](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-loops?tabs=consumption#foreach-loop) action. But there are many ways to interact with a collection such as [Inline code](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption), [Liquid Transformation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption), [Data Operations](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-perform-data-operations?tabs=consumption) and even [Expressions](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference). Some of mentions actions are more limited and others are more free on what you can do, so depending on the operation you would like to perform some method might more suitable than others. 
For example if you would like to filter an collection based on property the Filter Actions is a good option, if you would like to reverse the order of in an array you can simply use the [reverse](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference#reverse) Expression. 


## The Benchmark
This benchmark will center around a use case on data filtering and enriching elements. To get a better data sample of the performance, we will increase the amount of elements by 500, up to 10,000 elements. Except for the performance we will also try and rate how eazy/hard it is to debug and development.

Each workflow will focus the implementation around one of the following actions:
- For Each
- Filter Array
- Inline code


### Scenario Description:
1. **Read/Input Array**
2. **Loop Over Array:**
   - Once the array is retrieved, iterate over individual elements within the array.
3. **Conditional Handling:**
   - Filter out objects based on specific type
4. **Add/enrich elements with additional data**
5. **Return filtered array with enriched data**

The order of the operations is not necessarily needed to follow, the important is that the input array is filtered and individual elements are enriched with more data and that the output array only contains the filtered elements with additional data.  

### Workflow implementation

__For each__

![For each with Filter Array workflow](For_each.png)

__Filter Action with For each__

![For each with Filter Array workflow](For_each_with_FilterArray.png)

__Inline code__

![For each with Filter Array workflow](JavsScript.png)


View my github [project]() for more details!

### Environment settings
App service plans settings WS1, 1 pre-warmed instance and the burst was set to 1.  
Logic App for each default settings

## Result
Present the results
### Time per element in seconds
![Time_per_element_in_seconds](time_per_element.svg)
### Difference compared to For each action in seconds
![time_per_element_difference](time_per_element_difference.svg)
### Average time per element in seconds
- For each: __0.231__
- Inline code: __0.264__
- Liquid Transformation: __0.461__

## Reflections

in an blog post from Microsoft it gives you tips in ways you can optimizes your workflow and etc...
https://techcommunity.microsoft.com/t5/azure-integration-services-blog/using-inline-code-instead-of-a-foreach-loop-for-better/ba-p/3369587

For anyone more interested in benchmark, I have made a similar test on a another topic rather condition actions [blog](/posts/benchmark-condition/). 