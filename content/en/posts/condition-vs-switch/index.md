---
title: "Condition, which is faster in Logic Apps?" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Everyone loves when an system can handle/react fast and make it feel like seamless operation. This is true whether it is in a large scale enterprise or a in smaller organization. How fast systems can handle requests can be a complicated chain of services communicating with each other, therefor optimizations and performance improvements are an important task we developers need to deal with.

In this post we will look at three difference ways to implement if statements in Logic Apps, to see if there is any performance difference. We will conduct a benchmark on a real world senario and by compare the results.

## Understanding if:s in Logic Apps
As you start to develop workflows, you will run into if statements quite fast; they serve as control mechanisms to decide actions based on values. In Logic Apps, if statements are commonly used with the Condition action, but there are alternative actions and functions that you could use, such as the JavaScript action and if expression. Each of these ways comes with its perks and limitations!

### Condition action
Works similar to an if-else statement. Depending on the condition, the action will return either a true or false, and execute one or the other path. In programming languages like C#, it is common to create a chain of if-else statements, this feature is however not supported in the Logic App Condition action. 
Instead, you have to create multiple Condition actions to build up the chain of if-else statements, but there is also the possibility to nested your Condition actions.
```
// Pseudo-code Condition actions of chaining if-else
if (a == 10){
    return do();
} else {

}
if (a == 20){
    return doMore();
} else {

}
if (a == 30){
    return doEvenMore();
} else {

}
return null;

//Pseudo-code Condition actions of nesting if-else
if (a == 10){
    return do();
} else {
    if (a == 20){
        return doMore();
    } else {
            if (a == 30){
                return doEvenMore();
            } else {
                return null;
        }
    }
}

```
### If Expression
For those who are not aware Expressions in Logic Apps are a sequence that can contain one or more functions, operators, variables, explicit values, or constants [ref](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference#if). One of these expressions is the function `if` and is often combined with other functions shown below: 
```
if(equals(a,10),a,null)
```
A really cool thing about Expressions is that you can nest them like the code above, and this can be applied for `if` functions as well. This means that you could create a nested if-else statements like the following: 
```
if(equals(a,10),a,if(equals(a,20),a,if(equals(a,30),a,null)))
```
As you can see when writing a nested expressions the readability get quite awful. Therefor it is best practice to not "over do" this feature.

### Javascript action
Allows you to run "vanilla" Javascript code within the Logic Apps, and can be used for a vast verity of tasks. The action can use outputs from other actions and also `return` the output of the code, which in turn can be used in other actions in your workflows.


## The Benchmark
### Use Case: Array Processing and Conditional Record Handling

It is common in the real-world that data needs to be filtered and then processed based on various conditions. This benchmark will center around a straight forward use case on data processing. To get a better data sample of the performance, we will increase the amount of records by 500, up to 10000 records. 

#### Scenario Description:
1. **Loop Over array:**
   - Once the array is retrieved, the iterate over individual records within the array.

2. **Conditional Handling:**
   - If the number is equal to 10, 20, or 30. Then return the number.

### Data source
Files was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a> tool, the following template generates an array with the numbers of 0, 10

### Workflow implementation
Each workflow will start with an Request trigger followed by a For Each action. The difference in the workflows only be and Condition actions implementation.

#### Condition action
#### Expression if
#### Javascript action
### Environment settings
All the benchmarks was be using a WS1 App Service Plan, the scale out settings was limited to 1. 
The workflows concurrency For Each settings will be default, meaning that Logic App will process several records at the same time. 

## Result

## Conclusion

## Summary
