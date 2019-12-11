---
title: General overview Rinprod
author: Roel M. Hogervorst
date: '2019-12-10'
slug: general-overview-rinprod
categories:
  - blog
tags:
  - best-practices
  - software Engineering
  - data_science
  - SeriesBestPractices 
subtitle: '#Rinprod Best practices in software engineering for R: Overview'
share_img: "/post/2019-12-10-general-overview-rinprod_files/server-1235959_1280.jpg"
---

<!-- content  -->


*This is an overview post for the entire series of #Rinprod. I've not added this post to the R-bloggers feed because I this is the overview page.*


This is a blogpost series about applying software engineering best practices to
R, specifically for machine learning / data science. I think there are some excellent tutorials about these
best practices but not specific for R. So in this series I would like to explore
software engineering best practices with you. 
In my work (where I work in python) I use these practices everyday and I think about applying these best practices a lot. 

<img src="/post/2019-12-10-general-overview-rinprod_files/server-1235959_1280.jpg" alt="A server, the basis of the cloud, where we want to run our R code" width="80%"/>

The goal of this series is practical advise. I hope you can apply what you read to your work directly. 

To learn how, I will start with a single data science script
that loads data, does some feature engineering, runs a model and creates predictions. I will show you how to apply refactoring, add monitoring, add logging and finally add some tests.^[Yes some would advocate for writing tests first, but in practice you start with a proof of concept already build and build on top of that.]


* Introduction [from proof of concept to production]() and why you should care.
* What is in the script [blogpost 2019-10-30]() [, code](https://github.com/RMHogervorst/example_best_practices_ml/tree/cd14929327b99a7c379eca896cdf7b471ccfd868).
* Refactoring [blogpost 2019-11-05](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/07f4d40c401efaa53713e255fd0caaf1e6554767)

* Adding logging and monitoring [blogpost 2019-11-12](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/91acc95f4cf3ce6258515f0c5d097019a01bbe9a)
* Adding tests and validation [blogpost 2019-11-19](), [code after this step]()

