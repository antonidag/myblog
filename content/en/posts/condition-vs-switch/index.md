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

## Condition and Switch actions
In a programming language like C#, you will run into if and switch statements, they are controlling mechanizes to determine how to act on a value or a group of values. However, in Logic Apps the Condition action is similar to a if-else and the Switch action is like a Switch-case statement in C#. There is few limitations in the Logic Apps implementation of these actions. For instance the Condition action does not support a chain of if-else statements, instead you need to create multiple Condition actions to build up the chain of if-else statements and add termination code to avoid entering multiple conditions.

To make it a bit more black/white we will look pusedo-code to under stand how the Condition action work:
```
if (a == 10){
    doThis();
    break;
} else {

}
if (a == 20){
    doSomething();
    break;
} else {

}
if (a == 20){
    doSomethingElse();
    break;
} else {

} 
if (a != 10 and a != 20 and a != 30 ){
    doThat();
} else {

}
```
And pusedo-code for the Switch action: 
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

Benchmark on conditions and switch.

Explain the difference between the to actions

Method
How the benchmark is made. Services and etc
Explain the common senario

Link to github, with workflows and iac
## Environment settings
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
