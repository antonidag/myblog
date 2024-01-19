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
The Condition action is similar to a if-else statement. Based on a condtion the action will either be true or false, and depending on the output excute other operations. One of the limitations is that the Condition action does not support a multiple chain of if-else statements, instead you need to create multiple Condition actions to build up the chain of if-else statements.

Below can we see how it looks with pseudo-code to better understand how the Condition action is implemented:

```
if (a == 10){
    doThis();
} else {

}
if (a == 20){
    doSomething();
} else {

}
if (a == 20){
    doSomethingElse();
} else {

}
if (a != 10 && a != 20 && a != 30 ){
    doThat();
} else {

}
``` 
?Logic Apps has a magic card up on it sleeves, parallel actions. So the smart thing is that you can run Condition actions in parallel with each other and optimize the performance!?

## The Benchmark
### Use Case: File Processing and Conditional Record Handling

It is common in the real-world that data needs to be filtered and then processed based on various conditions. This benchmark will center around a straight forward use case on data processing. To get a better data sample of the performance, we will increase the amount of records by 500, up to 10_000 records. 

#### Scenario Description:
1. **Loop Over array:**

   - Once the array is retrieved, the iterate over individual records within the array.

2. **Conditional Handling:**
   - The first set of conditions involves checking if a string within the record is equal to specific values, namely 10, 20, or 30.
   - If the condition is met, process data.

### Data source
Files was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a> tool, the following template generates an array with the numbers of 0, 10, 20, 30, 40, 50 and 60:
```
[
    '{{repeat(10000)}}',
    '{{random(0,10,20,30,40,50,60)}}'
]
```

### Workflow implementation
To mimic the senareio and keep the implementation as simple as possible, we will expose an end-point where we can post an array of numbers. The workflows will start will an Request trigger and then followed by the For Each action. The difference in the workflows only be Switch and Condition actions implementation.
#### Condition
![Workflow-switch](workflow-condition.svg)
#### Switch
![Workflow-switch](workflow-switch.svg)
### Environment settings
All the benchmarks was be using a WS1 App Service Plan, the scale out settings was limited to 1. 
The workflows concurrency For Each settings will be default, meaning that Logic App will process several records at the same time. 

## Result

## Conclusion

## Summary
