---
title: Your Machine Learning Model is not the Product
author: Roel M. Hogervorst
date: '2024-11-01'
slug: your-machine-learning-model-is-not-the-product
categories:
  - blog
tags:
  - MLOps
  - Value-Stream
image: /blog/2024/11/01/your-machine-learning-model-is-not-the-product/jennifer-bedoya-unsplash.jpg
difficulty:
  - intermediate
post-type:
  - post
---

I'm so sorry. Your precious AI model, with handcrafted beautiful perfect features,
with awesome hyper parameters, is not the product.
Listen, it is awesome work, not a lot of people can do it, but a good ML model
is not the end-product[^1].

![](jennifer-bedoya-unsplash.jpg)

I want to talk about value. In the jobs I've worked the machine learning model 
was part of a larger system. And only when all the components come together you 
create value. For example, if you create an article recommendation system for a website,
your recommender is not the product.

You need to think about the entire chain of components that make it work. A 
customer of the website goes through several activities that ultimately lead to sales: 

- They find the website
- They visit the website 
- They browse for TVs, 
- They see your recommendations 
- They might click on them
- The pages need to work
- The payment has to work 
- The delivery needs to work 

The entire value-stream _(activities that lead to a wanted result for customer)_ 
is the product. If you model has awesome recommendations but is too slow for the
website, your model is shit. 

Your recommender is very valuable, but only when it works and fits into the 
existing system. So focus on the valuestream when developing new ML projects.


## Notes and attribution
Photo by <a href="https://unsplash.com/@jennbedoya?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jennifer Bedoya</a> on <a href="https://unsplash.com/photos/silver-and-black-espresso-maker-on-cafe-ryNPr5HSxfk?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
[^1]: Alright, if you are facebook research, of if you publish a model on hugging face, the model might be the product. But those people do not read this blog. 