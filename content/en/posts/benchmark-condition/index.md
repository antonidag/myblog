---
title: "Fast Lane or Slow Lane? Choosing the Quickest Logic App Condition!🏎️" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Logic Apps is a flexible service that gives you the tools to implement tasks in different ways. Having more options is often beneficial, but sometimes it can be a bit confusing. How do you determine when to use what and under what circumstances? Is there any option that is faster or slower?

In this post, we will explore three different methods to implement if statements in Logic Apps. We will conduct benchmarks and compare the results.

##  Exploring Alternatives to If statements 🏴󠁲󠁯󠁩󠁦󠁿
As you start developing, you will encounter if statements quite quickly; they serve as control mechanisms to decide actions based on values. In Logic Apps, the Condition actions is the if statements counter part, but there are alternative actions and functions that you could use, such as the Inline Code action and if expression. Each of these methods comes with its perks and limitations!

### Condition action
Works similarly to an if-else statement. The action will return either true or false, executing one of the paths. The <a href="https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-conditional-statement?tabs=consumption" target="_blank" rel="noopener noreferrer">Condition action</a> supports your classic logical operations such as:
- `or`, only one of the statements has be `true` for the action to return `true`. 
- `and`, all of your statements has to be `true` in order for action to return `true`. 
- The option to group statements, however if you have a more complex condition it is probably easier to use another method.

### Expression
<a href="https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference" target="_blank" rel="noopener noreferrer">Expressions</a> can be used for varus purposes, for instance there are functions for date time operations, logical operations, collection operations to mention a few. One expression we are a bit more interested in is the `if` function, and it is often combined with other functions, as shown below:
```
if(equals(a,10),a,null)
```
One feature of Expressions is the ability to nest them, by nesting expressions you can create complex statements and outputs. However, when nesting functions, operations together with other outputs form previous actions the readability can become challenging. Therefore, it is a best practice not to overuse this feature. 

### Inline Code action
Allows you to run "vanilla" JavaScript code within Logic Apps and can be used for a vast variety of tasks. The <a href="https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption" target="_blank" rel="noopener noreferrer">Inline code action</a> can utilize outputs from other actions and can also `return` the output of the code, which, in turn, can be used in other actions in your workflows.

## The Benchmark ⏱️
### Use Case: Array Processing and Conditional Record Handling
This benchmark will center around a straight forward use case on data processing and conditional handling. To get a better data sample of the performance, we will increase the amount of records by 500, up to 10000 records. 

The arrays was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a>, and had the following template:
```

```

### Scenario Description:
1. **Loop Over array:**
   - Once the array is retrieved, iterate over individual records within the array.

2. **Conditional Handling:**
   - If the number is equal to 20, 30, or 40. Then return the number, else return `null`

### Workflow implementation
We will implement a orchestration workflow that will loop over the items and call the other the workflows e.g Condition, Expression and Javascript. 

The full project with workflows and generated files can be viewed at my <a href="https://github.com/antonidag/logic-app-condition-vs-switch" target="_blank" rel="noopener noreferrer">GitHub</a>.

Let's point out some important difference between the workflows:

- __The Condition__ uses the Condition action with the `or` option, either returning the number or `null` in separated Response actions.
![Condition workflow](condition.png)

- __The Expression__ uses nested if expressions in the Response action.
![Expression workflow](compose.png)

- __The Inline Code__ uses JavaScript code to return the output which is later used in the Response action.
![Inline Code workflow](javascript.png)


### Environment settings
All the benchmarks will be using a WS2 App Service Plan, the scale out settings was limited to 1. 
The workflows mode was set to the `Stateful` mode and the concurrency settings had the default, meaning that Logic App will process several records at the same time. 

## Result 📊

### Time per element in seconds
![Time_per_element_in_seconds](time_per_element.svg)
### Difference compared to Condition action in seconds
![Time_per_element_in_seconds](difference_to_condition.svg)

### Average time per element in seconds
- Expression: __0.231__
- Condition: __0.264__
- Inline code: __0.461__
## Reflections

By looking at the diagrams the Expression implementation resulted in lower time per element in seconds. When comparing this to the Condition workflow, it will give us a 12.25% performance gain on average. This can be calculated by using this formula: 

Percentage difference = (Condition - Expression / Condition) * 100%

Percentage difference = (<math><mrow><mn>0.032</mn><mo> seconds/item</mo></mrow></math> / <math><mrow><mn>0.266</mn><mo> seconds/item</mo></mrow></math>) * 100%

Percentage difference ≈ <math><mrow><mn>12.25</mn><mo>%</mo></mrow></math>

There is also a pattern that correlates with the amount of elements. It seems that the more elements as input the time per element eventually goes down. This trend seems to be true for all the implementations and is not isolated to one workflow. It would be really interesting to see for how long this trend would continue on if we would keep on incrementing with 500 elements. Will it just continue to on and give better and better time per element. 

Before you start and implementing any optimization I think you need to consider if it is worth or not? What will it cost you? The Readability, maintenance are important factors in the application life cycle. Therefor you might want to wait until there is evidence of a bottleneck before you start optimizing. 

Anyway, if we play around with a case where per element it takes 1 seconds and we have 86 400 items, it will take 24 hours to process all the elements. This optimization could then potentially save us around 3.4 hours, which would be good! But if the goal is bring down the process time to a few hours, then this optimization would only be apart of the solution.



The results from these benchmarks are not to be seen as right and wrong, meaning that one or the other method is better or worse. These results only indicates that in a partially situation you might get a similar output. Bare in mind that the data collection has 
## Summary
