---
title: "Conditions and Switch, which is faster in Logic Apps?" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Everyone loves when an system can handle/react fast and make it feel like seamless operation. This is true whether it is in a large scale enterprise or a in smaller organization. How fast systems can handle requests can be a complicated chain of services communicating with each other, therefor optimizations and performance improvements are an important task we developers need to deal with.

In this post we will look at three differnce ways to implement if statements in Logic Apps, to see if there is any performance difference. We will conduct a benchmark on a real world senario and by compare the results.

But let's first go thru the ways uu could implement if statements in Logic Apps!

## Understanding if:s in Logic Apps
You will run into if statements quite quickly, they are controlling mechanizes to determine how to act on a value or a group of values. In Logic Apps if statments are implemented as Condition, however there is also alternitives methods that you could use. For instance the Javascript action and the if expression. These three methods they all come with their own limitations and perks! 
1. The Condition action is similar to a if-else statement, based on a condtion the action will either be true or false, and depending on the output execute either one or other path. When your are working in a programing language, such as C# is it pretty common that create a chain of if-else statements, but this feature is not avalible in the Logic App Condition action, instead you need to create multiple Condition actions to build up the chain of if-else statements. Let take a view at the pseudo-code below to get better understanding:

```
// Example of chaining if-else statments, in programing language as C#
if (a == 10){
    doThis();
} else if (a == 20){
    doSomething();
} else if (a == 30){
    doSomethingElse();
} else {

}


// Example how the Logic Apps Condition action implements if-else
if (a == 10){
    doThis();
} else {

}
if (a == 20){
    doSomething();
} else {

}
if (a == 30){
    doSomethingElse();
} else {

}
```
2. The Javascript action can also be used for implemention if-else, this a pretty straight forward you can run javascript and does give us the option to make a something

3. Using expression if, the expession in Logic Apps can be used in numerus places to help and eaze the implementation and simplify experssions that you would like to do. The if expression works very similar to tanary operator.
## The Benchmark
### Use Case: Array Processing and Conditional Record Handling

It is common in the real-world that data needs to be filtered and then processed based on various conditions. This benchmark will center around a straight forward use case on data processing. To get a better data sample of the performance, we will increase the amount of records by 500, up to 10000 records. 

#### Scenario Description:
1. **Loop Over array:**

   - Once the array is retrieved, the iterate over individual records within the array.

2. **Conditional Handling:**
   - The first set of conditions involves checking if the number is equal to specific values, namely 10, 20, or 30.
   - If the condition is met, then process the data.

### Data source
Files was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a> tool, the following template generates an array with the numbers of 0, 10

### Workflow implementation
To mimic the senareio and keep the implementation as simple as possible, we will expose an end-point where we can post an array of numbers. The workflows will start will an Request trigger and then followed by the For Each action. The difference in the workflows only be Switch and Condition actions implementation.
#### Condition
to optimize for perfemance we will utalize the run in paralell action.
![Workflow-switch](workflow-condition.svg)
#### Switch
![Workflow-switch](workflow-switch.svg)
### Environment settings
All the benchmarks was be using a WS1 App Service Plan, the scale out settings was limited to 1. 
The workflows concurrency For Each settings will be default, meaning that Logic App will process several records at the same time. 

## Result

## Conclusion

## Summary
