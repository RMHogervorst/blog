---
title: Productionizing refactoring
author: Roel M. Hogervorst
date: '2019-10-29'
slug: productionizing-refactoring
categories:
  - R
  - blog
tags:
  - best-practices
  - software Engineering
  - data_science
  - SeriesBestPractices 
subtitle: '#Rinprod Best practices in software engineering for R: Refactoring'
share_img: https://media1.tenor.com/images/cb27704982766b4f02691ea975d9a259/tenor.gif?itemid=11365139
---

<!-- content  -->
<!-- 
 
Good tutorials are: 
- quick. tell what you want to do, how to do it
- easy: success is important. playtest the tutorial under different circumstances
- not to easy: Don't get htem throug ht toturoial onluy to runinto a wall later on. 

{{< columns >}}
This is column 1.
{{< column >}}
This is column 2.
{{< endcolumn >}}

-->

LAST TIME I SAID
1. EVERYTHING IS IN ONE SCRIPT.
2. DO WE KNOW IF THE MODEL IS PERFORMING BETTER OR WORSE OVER TIME?
3. DO YOU HEADLESSLY KNOW IF THE PROCESS RAN?
4. WHAT IF I WANT TO CHANGE THE ALGORITHM?


CODE LOOK AT START
https://github.com/RMHogervorst/example_best_practices_ml/commits/feature/refactoring

In [this specific commit on GITHUB ](https://github.com/RMHogervorst/example_best_practices_ml/tree/cd14929327b99a7c379eca896cdf7b471ccfd868)

REFACTORING
MAYBE ADD LINKS TO GITHUB SO YOU CAN SEE WHAT HAS CHANGED
27bb56c (HEAD -> feature/refactoring) HEAD@{0}: commit: [refactoring] pull out model and activate plots
2d6fff7 HEAD@{1}: commit: [refactoring] Pull apart recipe into seperate file
65558ca HEAD@{2}: commit: [refactoring] refactoring load_data functions
9514a61 HEAD@{3}: commit: [refactoring] Move data loading into seperate function


The runtime of the model is approximately the same, in practice it won't matter that much. 
but when you want to change something it is way easier, you know in which file to look.

MAINTABABLE, EXTENDING, 

ABSTRACTING, BREAKING APART, IMPROVING NAMES AND LOCATION

CREATED FEATUER ENGINEERING, LOAD DATA, MONITORING FUNCTIONS FILE

CREATED FUNCTIONS, THE FUNCTIONS ENCAPSULATE THE MAJOR FUNCTIONALITY.
that way when you want to work on the model, go into the model function.
if you want to swab the model, modify the model part. EXTENSIBILITY

the main function get's smaller and smaller. 
the large intent becomes clear, because those are the only things we see. 
and the funcitons have names that make clear what their goal is.


CODE LOOKS AT FINISH
[code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/07f4d40c401efaa53713e255fd0caaf1e6554767)

Are we really finished? we could abstract it even more. 
maybe the splitting of the data could be a apart.
maybe the predictions could be apart?

should we encapsulate the entire thing in a function?
This all depends on your use. how often do you change things. 
again, code is meant to be read by humans. we can always improve and simplify.