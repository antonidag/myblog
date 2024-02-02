---
title: "Fast Lane or Slow Lane? Choosing the Quickest Logic App Condition!🏎️" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Logic Apps is a flexible tool that provides you with the opportunity to implement tasks in various ways. Having more options is often beneficial, but at times, it can be a bit confusing. How do you determine when to use what and under what circumstances? Is there any performance difference?

In this post, we will explore three different ways to implement if statements in Logic Apps to assess potential performance differences and examine the various implementations. We will conduct a benchmark and compare the results.

##  Exploring Alternatives to If statements 🏴󠁲󠁯󠁩󠁦󠁿
As you start developing workflows, you will encounter if statements quite quickly; they serve as control mechanisms to decide actions based on values. In Logic Apps, if statements are commonly used with the Condition action, but there are alternative actions and functions that you could use, such as the JavaScript action and if expression. Each of these methods comes with its perks and limitations!

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
A memorable feature of Expressions is the ability to nest them. However, when nesting functions, operations together with other outputs form previous actions the readability can become challenging. Therefore, it is a best practice not to overuse this feature. 

### JavaScript action
Allows you to run "vanilla" JavaScript code within Logic Apps and can be used for a vast variety of tasks. The <a href="https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption" target="_blank" rel="noopener noreferrer">JavaScript action</a> can utilize outputs from other actions and can also `return` the output of the code, which, in turn, can be used in other actions in your workflows.

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

- __The JavaScript__ uses the JavaScript actions and returns the output which is later used in the Response action.
![JavScript workflow](javascript.png)


### Environment settings
All the benchmarks will be using a WS2 App Service Plan, the scale out settings was limited to 1. 
The workflows mode was set to the `Stateful` mode and the concurrency settings had the default, meaning that Logic App will process several records at the same time. 

## Result 📊

## Conclusion

## Summary
