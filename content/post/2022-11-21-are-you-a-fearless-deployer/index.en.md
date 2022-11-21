---
title: Are you a Fearless Deployer?
author: Roel M. Hogervorst
date: '2022-11-21'
categories:
  - blog
tags:
  - deployment
  - iteration
  - MLOps
  - training-pipeline
slug: are-you-a-fearless-deployer
subtitle: Fast experimentation and confident deployments should be your goal
description: Fear during deployment is holding you back, find out what the problem
  is and help everyone with faster experimentation and confident deployments.
difficulty:
  - advanced
post-type:
  - thoughts
share_img: /blog/2022/11/21/are-you-a-fearless-deployer/katya-ross-I4YsI1zWq_w-unsplash.jpg
image: /blog/2022/11/21/are-you-a-fearless-deployer/katya-ross-I4YsI1zWq_w-unsplash.jpg
---

<!-- content  -->
how do you feel when you press the 'deploy to production' button? Confident, slightly afraid? I bet many data scientists find it a bit scary. It's worth it to dig a bit deeper into this fear. 

![hands pushing lighted up buttons](katya-ross-I4YsI1zWq_w-unsplash.jpg)

In my ideal world we are not scared at all. We have a devops mindset. We have no anxiety, no fears at all. You should be confident that the deployment pipeline takes care of everything. The pipeline runs tests, it checks things, and takes the final product into production. It is a **fearless deployment**.

A data scientist should not have to worry about the deployment process.  
A data scientist should focus on modelling, should be experimenting. And when a
point is reached where business value is high enough, a data scientist should feel confidence in pushing the production button. 
Are you not confident in your deployment? You might have an MLOps problem!

> Deployment fear is a symptom of an MLOps problem

No confidence or trust in  the system of deployment is a symptom. 
So ask yourself where the fear is coming from. Machine learning products are only valuable when they are exposed to the real world. So when you unnecessarily delay deployment out of fear,  the organization will lose time or money. 

So how do we fix this?

## Investigating and mitigating deployment fear
![a cartoon image of a rocket lifting off](andy-hermawan-O1jUvZX9DOA-unsplash.jpg)


Talk to your team members about deployment. Be open about your fears. Start diagramming your workflow to find the scariests pieces of the machine learning product:

- Are there manual steps? Can you automate them (with github actions, gitlab etc, bash scripts)?
- Are there hidden dependencies with other systems? Try to minimize those, or focus on compatability
- Are you not sure about performance? Bake performance benchmarks against a golden dataset into the deployment pipeline, and fail the pipeline when you don't reach minimal performance.
- Are you not sure about the predictions? Make sure to include monitoring to the system so you know how it is doing right away. Maybe you can periodically check performance of the production model against the truth.

In short: identify and eliminate or alleviate the scariest parts of deployment and build up confidence in system. Become a fearless deployer. 
So are you a fearless deployer or not? Hit me up on the socials and tell me all about it!



<details> <summary>Image credits</summary>

- Image of 'hands pushing lighted up buttons' by [Katya Ross](https://unsplash.com/@katya) on [the Portland Festival of Lights, OMSI, Portland, United States](https://unsplash.com/photos/I4YsI1zWq_w "image link") 
- Image of 'a cartoon image of a rocket lifting off' by [Andy Hermawan](https://unsplash.com/@kolamdigital)  [3D Rendering Rocket Space Launching Illustration](https://unsplash.com/photos/O1jUvZX9DOA)

   </details>