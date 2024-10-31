---
title: A Model not in Production is a Waste of Money and Time
author: Roel M. Hogervorst
date: '2024-11-02'
slug: a-model-not-in-production-is-a-waste
categories:
  - blog
tags:
  - MLOps
  - production
image: /blog/2024/11/02/a-model-not-in-production-is-a-waste/wolfgang-weiser-unsplash.jpg
difficulty:
  - beginner
post-type:
  - post
---

I always push on people to make their ML project reach production. 
Even if it is not that good yet and even if you could eke out a bit more performance.

I've been inspired by the dev-ops and lean movements and I hope you will be too.
ML products have many ways to improve, you can always tweak more. 
But ML is high risk, with a possible high reward and relatively expensive 
compared to 'normal code'. But it needs to touch reality to actually bring in money[^1].

![](wolfgang-weiser-unsplash.jpg)

Of course you do offline evaluation of your model, but that is theoretical performance.
You need to bring it into the real world and verify performance there.
In other words, I don't give a rat's ass that your model is theoretically 5% better 
than the current SQL query if that SQL query is running in production and your
solution is running on your laptop. The customers do not talk to your laptop.

Only products in production are valuable. So push push push to make that happen.

Here is my ideal scenario:

- Analyse the problem that you want to create a solution for
- talk to the people who deal with the systems where you need to integrate your solution into
- experiment a bit, and create the simplest solution
- set up pipelines for automated testing, and deployment
- integrate the simple model into the system

In other words: push the simplest thing all the way into production, so you learn
all the things that must be taken care of before it ends up there. Code that all
into your pipeline. Now you have an automated system. Experiment further
and deploy better versions with your pipeline. 

You see, a machine learning product is not the model artefact, it is all the stuff
around it too. The deployment pipeline, the training pipeline, the testing suite, 
etc. Once you have the basics in place you can really iterate and slowly improve
the work. You also learn from real data. 

So in other words. push for production as early as possible. 

## Notes
Photo by <a href="https://unsplash.com/@hamburgmeinefreundin?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Wolfgang Weiser</a> on <a href="https://unsplash.com/photos/a-large-pipe-sitting-next-to-a-forest-filled-with-trees-n60sfcqBzE0?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
[^1]: Not all ML products are cost savers, some enable more abilities, some save time spend on stupid work. So substitute the one that works for you here. (if your product costs more, makes everything slower or handicaps people you really should think about your choices in life and find a different project)