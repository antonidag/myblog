---
title: Conditions and Switch, which is faster in Logic Apps? 
date: 2023-11-16T20:46:09+01:00
draft: true
description: 
---

Introduction

Background & Related work
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
