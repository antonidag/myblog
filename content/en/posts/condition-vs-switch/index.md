---
title: "Conditions and Switch, which is faster in Logic Apps?" 
date: 2024-01-04T20:46:09+01:00
draft: false
description: 
image: "myblog/posts/logic-app-web-app/clientwebserver.gif"
---

## Background   
Everyone loves when an system can handle/react fast and make it feel like seamless operation. This is true whether it is in a large scale enterprise or a in smaller organization. How fast systems can handle requests can be a complicated chain of services communicating with each other, therefor optimizations and performance improvements are an important task we developers need to deal with.

In this post we will look at the Logic Apps Scope actions; Condition and Switch, to see if there is any performance difference. We will make a benchmark comparing two workflows implementations. One workflow will use the Scope action Condition and the other will implement the Switch action.  

## Condition and Switch actions
In a programming language like C#, the term often used are if and switch statements, they are controlling mechanizes to determine how to act on a value or a group of values. However, in Logic Apps the Condition action is similar to a if-else and the Switch action is like a Switch-case statement in C#. However, there a few limitations in the Logic Apps implementation of these actions. For instance the Condition action does not support a chain of if-else statements, instead you need to create multiple Condition actions to build up the chain of if-else statements and add termination code to avoid entering multiple conditions.
```
if (a == 10){
    doThis();
} else {
    doThat();
}
```

```
switch (a)
{
   case 10:
      doThis();
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
