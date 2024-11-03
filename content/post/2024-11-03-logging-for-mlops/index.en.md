---
title: Logging for Machine Learning
author: Roel M. Hogervorst
date: '2024-11-03'
slug: logging-for-mlops
categories:
  - blog
tags:
  - MLOps
  - logging
  - python
  - errors
subtitle: 'How and what should you log in machine learning'
summary: "The python logging system is really powerful but not a lot of machine learning practitioners use it, and that is a shame. Here are some of my thoughts on logging for your Machine learning (ML) projects."
image: blog/2024/11/03/logging-for-mlops/mildly-useful-TeeK3XdZd54-unsplash.jpg
difficulty:
  - advanced
post-type:
  - post
---

How and what should you log in machine learning? The python logging system is
really powerful but not a lot of machine learning practitioners use it, and that
is a shame. Here are some of my thoughts on logging for your Machine learning (ML) projects.

![an image of logs (the tree kind, not what I'm talking about, I am super funny)](mildly-useful-TeeK3XdZd54-unsplash.jpg)

<!--more-->

## Logging vs print

In most programming languages there is the print statement, 
which sends results to stdout (the console). But in python, print is something 
that can break your system. And logging should never break production[^2]. 
There is a dedicated system for logging. The logging system does not break 
production, and it has several levels (for example DEBUG, INFO, WARNING, ERROR), 
allowing you to specify what kind of message this is. You can even filter out
logs of different levels, for example only show INFO or higher.
Logs also have time-stamps which are really useful for correlating events and 
can be used to monitor the process (for example; is loading of data getting 
slower over time?). Monitoring is a topic for another time, lets get back to logs.

## What we log and why

After the initial experimental phase our ML programs run without supervision.
I do not babysit my training runs, or the API that responds based on a trained model.
Those things are instrumented, they have metrics and logs. Log events are a 
capture of the state in that moment. This gives us insight into the system.
That is why you must log all critical events (more on that later).
I can trace the normal operation of a system, and when things go wrong I can
see exactly where things went wrong[^3]. And when we want to rerun the system
to get to its failure we can turn on DEBUG logs so we get a better view of what
happened. 

The logs also surface WARNINGs and ERRORs. I have a very strict view
on warnings and errors. When the system runs as expected there are NO WARNINGS
and NO ERRORS. Some programs raise warnings for things that are not really a 
problem, I either fix that issue, downgrade the warning to INFO or suppress the 
warning. If you do not do this you will get fatigued or overwhelmed;  
_your system gives you 2 warnings but you should ignore one? That leads to mistakes._ 
MLOps life is much easier when ALL
warnings are high priority improvements and all errors require immediate action. 


Enough about the generics, lets gets into some details. I think there are two 
distinct processes in MLOps that require a slightly 
different approach. The training phase and the inference phase. 

### What to log during a training job

A training job has critical events that you need to log.
It needs to `read data`, `feature engineer`, `start training`, 
possibly do `hyper parameter selection`, if there are multiple `rounds/epochs` 
you want to log the state of those rounds, check `performance on hold-out set`, 
`save the trained artefact` and `persist the artefact to storage` somewhere. 
Why do we log these events? So we know how far the job has gotten and from which
point we need to debug. I'm not watching grass grow, I'm not waiting for a training
job. I get notified when it fails or succeeds and continue from there.

I talked about warnings and errors; there are states that you know will 
lead to failure.  So you should pre-emptily stop the process to prevent weird
effects downstream. For example if the reading of data returns no data, 
your training job must log an error and fail. Fail fast, fail early, 
fail surly[^4] (complain loudly). If you know some prerequisites are necessary,
do not continue if it is not there. It is wise to add some checks if you know
the distribution of your data. For example age of people, is generally not negative
and not older then 120 years. If your data has many many columns this can become 
impractical, there are some anomaly detection methods that save the distribution
of the training data and let you know when it is out of bounds. I have no 
experience with those things so I do not know if this works in practice.

### What to log during inference

During inference you want to log other critical events; `startup` of 
system/container, `model loading`, `ready for serving`, during lifetime you want 
to log every `request` and on system `shutdown`. 
Logging in an API is lightweight, but not without cost, so you do not want debug 
logs unless something is wrong. During training, latency is not that big of an 
issue, but latency is very important when you serve a model API.

I think you should warn when incoming data is very different from the training data,
and when it is quantitatively different you should probably just error. For example
when your training data had a column that was always between 0 and 1, and your
incoming data is very extreme (always a 0 or 1) you should warn. This could happen
but it is very unlikely and a human should look at the process. If the incoming
data is outside the training range (2, 14, -1, etc.) you should protect yourself
and error. something is clearly wrong. I would say that in those cases no answer
is better than a wrong answer.

If you do batch predictions, latency is not a big problem, you can log more but you
should still warn and error on clearly wrong data. It is your choice if you want
to filter out clearly out of range data and continue with the rest, or if you want
to fail completely (the thinking is, if some values are untrustworthy, should 
I even trust any of it?). Either way, someone needs to look at the incoming data 
process. 

## From no logs to a fully logged project

I think a logical[^6] progression from nothing to good enough goes like this:

- during development you have used print on some places, those places need to be DEBUG statements, to show you a detailed state at that point.
- identify the critical points in your process
- add INFO logs on those points
- add useful details on those points (number of rows, logloss, accuracy, etc.)
- add checkpoints with warnings when things could be a problem, and errors when they definitely are a problem.
- remove warnings that do not help you
- Whenever the system fails you will find out that you missed things, that is a learning event where you should add debugs for state and errors to prevent repeating issues.
- downgrade logs that do not help you in normal day to day operations, or remove them


I recommend adding log statements to all your scripts and send the logs to the 
console when you start. From there it is relatively easy to add configuration 
that send logs to a centralized location, or to change the logging format, 
or to filter the logging of certain parts of your code. This does not change 
the logging statements in your code, it is all configuration, which is awesome.

The python logging system is really powerful but also slightly different from 
'normal' python, so there are some things you should look out for[^1], 
but it is really easy to start with default settings and make it more complex 
when you need it. 

There are tons of resources about logging in python applications, not a lot about
Machine learning specifically, but this should give you enough to get started.

## Read more:

- The python docs about logging <https://docs.python.org/3/howto/logging.html> are really good.
- The book 'Practical MLOps' by Noah Gift and Alfredo Deza (2021) has great practical python examples about logging. 
- The book 'Designing machine learning systems' by Chip Huyen (2022) goes into a lot of depth about what to monitor, what to log and especially how to use all of that.

The image at the top comes from unsplash: <a href="https://unsplash.com/@usefulcollective?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Mildly Useful</a> on <a href="https://unsplash.com/photos/pile-of-tree-logs-TeeK3XdZd54?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
  

[^1]: python loggers are singletons (there is only ever one logger) and all the specific loggers are layered on top of the root logger. It is possible to change the log level on multiple loggers without realising it. Leading to weird debug sessions. 
[^2]: "logging should never break production, print can break production, do not use print." 2021 Practical MLOps - Noah Gift and Alfredo Deza
[^3]: This is the dream of course, in practice things go wrong, I have a hard time finding out what went wrong and modify the logging and monitoring so that I do not have to do this again. You live and learn.
[^4]: This is an expression by Hadley Wickham that I'm probably saying wrong. But he is absolutely right, your system needs to give you clear explanations of what is going wrong, not 'an error occurred'. _Hadley Wickham is a prolific R developer, he and his team now, created many of the most popular R packages. I know I write about python a lot, but the R people do some things way better, and clear error messages are one of them._
[^6]: ... get it? **log**ical. I am a hoot at parties.