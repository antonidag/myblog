---
title: "Fast Lane or Slow Lane? Choosing the Quickest Logic App For Loop!🏎️"
date: 2024-05-13T00:00:00+00:00
draft: false
description: 
image: "posts/benchmark-for-each/preview.gif"
---

## Background
Benchmark on For, Javascript & Liquid template.
There is a bit of noise around how performant the Logic App for loop really is, 
Looping over an array and preforming operations on each item, is a quite common task.

We will conduct a benchmark between the Logic Apps, and [Liquid Operation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption) action, inorder to get more insight on how the different methods perform.

## Exploring options For loops
Loop over an array of elements is one of bread and butter when it comes programming, in Logic Apps this is normally perform by the [For each](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-loops?tabs=consumption#foreach-loop) action. But there are many ways to interact with a collection such as [Inline code](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-add-run-inline-code?tabs=consumption), [Liquid Transformation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-enterprise-integration-liquid-transform?tabs=consumption), [Data Operations](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-perform-data-operations?tabs=consumption) and even [Expressions](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference). Some of mentions actions are more limited and others are more free on what you can dom, so depending on the operation you would like to perform some method might more suitable than others. 
For example if you would like to filter an collection based on property the Filter Actions is a good option, if you would like to reverse the order of in an array you can simply use the [reverse](https://learn.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference#reverse) Expression. 
In this benchmark we will take an extra look that the following actions:
- For Each
- Filter Array
- Inline code
- Liquid Json to Json

## The Benchmark
This benchmark will center around a use case on data filtering and enriching elements. To get a better data sample of the performance, we will increase the amount of elements by 500, up to 10,000 elements. Except for the performance we will also try and rate how eazy/hard it is to debug and development.

The input arrays was generated with the <a href="https://json-generator.com/" target="_blank" rel="noopener noreferrer">Json Generator</a>, and had the following template:
```
JG.repeat(5, 10, {
  id: JG.objectId(),
  email() {
    return (
      _.snakeCase(this.profile.name) +
      '@' +
      this.profile.company +
      JG.domainZone()
    ).toLowerCase();
  },
  username() {
    return (_.words(this.profile.name)[0] + moment(this.profile.dob).format('YY')).toLowerCase();
  },
  profile: {
    name: `${JG.firstName()} ${JG.lastName()}`,
    company: JG.company(),
    dob: moment(JG.date(new Date(1988, 0, 1), new Date(1995, 0, 1))).format('YYYY-MM-DD'),
    address: `${JG.integer(1, 100)} ${JG.street()}, ${JG.city()}, ${JG.state()}`,
    location: {
      lat: JG.floating(-90, 90, 6),
      long: JG.floating(-180, 180, 6),
    },
    about: JG.loremIpsum({ units: 'sentences', count: 2 }),
  },
  status: JG.random('active', 'inactive', 'paused'),
  createdAt: JG.date(new Date(2010, 0, 1), new Date(2015, 0, 1)),
  updatedAt() {
    return moment(this.createdAt).add(1, 'days');
  },
});
```

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
HTTP input loop elements
Init variable
For Each Action
    if status == active
        Add to variable using expressions using addProperty(item(),'batchId', guid())
return variable

__Filter Action with For each__
HTTP input loop elements
Init variable
Filter Action (status == active)
For Each Action
        Add to variable using expressions using addProperty(item(),'batchId', guid())
return variable

__Inline code__
HTTP input loop elements
JavaScript Action
return JavaScript output

```
const generateGUID = () => 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
  const r = Math.random() * 16 | 0;
  const v = c === 'x' ? r : (r & 0x3 | 0x8);
  return v.toString(16);
});

const activeData = [];
for (let i = 0; i < data.length; i++) {
  if (data[i].status === 'active') {
    activeData.push({ ...data[i], batchId: generateGUID() });
  }
}
return activeData;
```

__Liquid Transformation__
HTTP input loop elements
Liquid Json to Json
return Liquid output

Liquid template:
```
{% assign timestamp = 'now' | date: "%Y%m%d%H%M%S%N" %}
{% assign unique_id = timestamp | slice: 0, 8 | append: '-' | append: timestamp | slice: 8, 4 | append: '-' | append: timestamp | slice: 12, 4 | append: '-' | append: timestamp | slice: 16, 4 | append: '-' | append: timestamp | slice: 20, 12 %}
{{ unique_id }}
```
### Environment settings
App service plans settings WS1, 1 pre-warmed instance and the burst is set to 1.  
Logic App for each default settings

## Result
Present the results
### Time per element in seconds
### Difference compared to For each action in seconds
### Average time per element in seconds
- For each: __0.231__
- Inline code: __0.264__
- Liquid Transformation: __0.461__

## Reflections

in an blog post from Microsoft it gives you tips in ways you can optimizes your workflow and etc...
https://techcommunity.microsoft.com/t5/azure-integration-services-blog/using-inline-code-instead-of-a-foreach-loop-for-better/ba-p/3369587

For anyone more interested in benchmark, I have made a similar test on a another topic rather condition actions [blog](/posts/benchmark-condition/). 