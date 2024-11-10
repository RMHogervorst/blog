---
title: Many Small Models for Speed
author: Roel M. Hogervorst
date: '2024-11-10'
slug: many-small-models-for-speed
categories:
  - blog
tags:
  - MLOps
  - deployment
  - production
subtitle: ''
image: /blog/2024/11/10/many-small-models-for-speed/aedrian-salazar-Tws17PwytpA-unsplash.jpg
difficulty:
  - advanced
post-type:
  - post
---

<!-- content  -->
LLMs are pretty cool, but they are massive! If you want to run those for yourself
you need a hefty GPU and quite a lot of engineering. But the world of machine 
learning is so much bigger then LLMs. In organizations all over the world, there
are models forecasting time-series, predicting prices, creating embeddings, 
classifying categories and what not.

If you have several prediction/classification steps that combine into one end-
result, you could consider training one bigger model that does all of the things. 
I think for many use-cases you are better off with a set of small models working 
together.

![a small lego figure (as a reference to smallness)](aedrian-salazar-Tws17PwytpA-unsplash.jpg)

## Small is better

In the devops world people create micro-services; splitting functionality into 
loose services that are managed by different teams. Teams can work faster,
deploy faster and the component can scale up and down easier when necessary.

When we create a machine learning API (a service), we don't train a model once
and wrap an API around it. A machine learning product is not just the trained
model artifact. It is the training pipeline, the automatic evaluation, periodic
retraining and promotion of newer artifacts. There should be a way to incorporate 
new training data and train and evaluate without any intervention. If you set
up this highly automated[^1] deployment system, you free up your precious time
to work on new machine learning projects. 

Small, highly focused models are easier to debug, faster to train, and easier
to reason about. You can also incrementally improve a component in your pipeline.
Once you have set up your automated deployment and evaluation pipelines you can
experiment to improve the performance of the component, and hopefully also the
entire system.

## Small is not always better
When is small too small? When its performance is less valuable than the cost.
You don't need perfect accuracy to provide value. If your model is slightly better
than the system it replaces you are gaining an advantage. But sometimes you need
more than you get. That is the time to use larger models, based on more data.
Because more data is better for performance[^2].

## In conclusion

I think it is more important to set up automated deployment and evaluation pipelines
for your small models than to get a bigger model. A medium model in production is infinitely better
then a great model on your laptop. Smaller models can be easier deployed, and once you
set up your system, they can run without too much supervision.

[^1]: The Google cloud people have a [useful framework for MLOps maturity](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning), that talks about continuous delivery of machine learning models. The situation I described here is something between level 1 and 2, 0 = no automation at all.
[^2]: When the training data is accurate and diverse, making sure your training data is labelled correctly is one the best investments you can make. Because wrong labels mess up your performance. Most of the benchmark datasets contain wrong labels. [Vincent Warmerdam wrote a nice post](https://koaning.io/posts/labels/) explaining this.