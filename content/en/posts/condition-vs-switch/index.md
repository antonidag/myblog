---
title: "Conditions and Switch, which is faster in Logic Apps?" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Everyone loves when an system can handle/react fast and make it feel like seamless operation. This is true whether it is in a large scale enterprise or a in smaller organization. How fast systems can handle requests can be a complicated chain of services communicating with each other, therefor optimizations and performance improvements are an important task we developers need to deal with.

In this post we will look at the Logic Apps Control actions; Condition and Switch, to see if there is any performance difference. We will make a benchmark by comparing two workflows implementations. One workflow implementing the Control action Condition and the other the Switch action.

But let's first go thru the difference between <a href="https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-conditional-statement?tabs=consumption" target="_blank" rel="noopener noreferrer">Condition</a> and a <a href="https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-switch-statement"  target="_blank" rel="noopener noreferrer">Switch</a> action!

## Condition and Switch actions
In a programming language like C#, you will run into if and switch statements, they are controlling mechanizes to determine how to act on a value or a group of values. In Logic Apps these are implemented as Condition and Switch. The Condition action is similar to a if-else and the Switch action is like a Switch-case statement in C#. There is few limitations in the Logic Apps implementation of these actions.

For instance the Condition action does not support a multiple chain of if-else statements, instead you need to create multiple Condition actions to build up the chain of if-else statements.

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

And pseudo-code for the Switch action is implemented:

```
switch (a)
{
    case 10:
      doThis();
      break;
    case 20:
      doSomething();
      break;
    case 30:
      doSomethingElse();
      break;
   default:
     doThat();
}
```

The pseudo-code makes it a bit more clear on how these action different from each other a specially when you are in need of determine multiples paths to execute.

## The Benchmark
### Use Case: File Processing and Conditional Record Handling

It is common real-world scenario where data needs to be filtered and then processed based on various conditions. Therefor the benchmark will center around a straight forward use case on data processing from an HTTP end-point. To get a better sample of the performance we will increase the amount of records by 500, up to 10_000 records.

#### Scenario Description:
1. **Fetch array from HTTP end-point:**

   - This array serves as the primary data source for our benchmark.

2. **Loop Over array:**

   - Once the array is retrieved, the iterate over individual records within the array.

3. **Conditional Handling:**
   - The first set of conditions involves checking if a string within the record is equal to specific values, namely 10, 20, or 30.
   - If the condition is met, corresponding values are written to a new array.

### Data source
Files was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a> tool, the following template generates an array with the numbers of 0, 10, 20, 30, 40, 50 and 60:
```
[
    '{{repeat(10000)}}',
    '{{random(0,10,20,30,40,50,60)}}'
]
```
For simplicity the files will be hosted and served on Github pages, since the focus on the benchmark will be the performance of the Logic Apps actions the data source itself it will not be a factor in our case. 

Feel free to adjust the language or add more details based on your specific requirements and preferences.

Benchmark on conditions and switch.

Explain the difference between the to actions

Method
How the benchmark is made. Services and etc
Explain the common senario

Link to github, with workflows and iac

### Environment settings

App service plans settings
Other Services connected to the logic & benchmark

## Workflow settings

Some diagram
basic flow - condition
Read file
for each line
if eq yes then write line to new file
nq then skip line

basic flow - switch
Read file
for each line
swtich on line
if yes then write line to new file
default then skip line

Data

Summary
