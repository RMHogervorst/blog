---
title: Distributing data science products
author: Roel M. Hogervorst
date: '2021-11-05'
categories:
  - blog
  - R
tags:
  - intermediate
  - rinprod
  - tools
slug: distributing-data-science-products
subtitle: ''
share_img: '/img/rinprod/robot-916284_640.jpg'
---

<!-- tags choose:
beginner, intermediate or advanced
*beginner:*
*for, loops, brackets, vectors, data structures, subsetting, functions, qplot, ggplot2, dplyr, spps-to-r, haven, tidyr, tidyverse*

*intermediate:* 
*tools, building packages, testing, slides in markdown, apply, package, advanced ggplot2, environments, animation, test, workflow, reproducability, version control, git, tidyeval*

*advanced:*
*S4 classes, extensions , shiny, Object Oriented Programming, Non standard Evaluation, code performance, profiling, Rcpp, optimize-your-code*
-->
<!-- categories: R and blog. Blog is general, R means rweekly and r-bloggers -->

<!-- share img is either a complete url or build on top of the base url (https://blog.rmhogervorst.nl) so do not use the same relative image link. But make it more complete post/slug/image.png -->


<!-- content  -->

**Where or what is production?**
What does it mean when someone says to bring some data science product 'in production' ? What does it mean for data science products to be in production? Is your product already in production? Is it a magical place? 

I think two questions are of importance:

* does my 'thing' provide value?
* is my work repeatable?

If the answer to these questions is yes, than your 'thing' is in production. The devil is, as always, in the details. How do you integrate your work into the infrastructure. So how can you integrate your data science product into your company infrastructure?

## Distributing data science products
I see 3 or 5 different end-products that I would call 'production'.

> Data scientists produce results with a statistical model.

How we go from there is one of three ways

* The end goal is a **rapport** (analysis done in Rmarkdown/jupyter-notebook) End result delivered in [a knowledge repo](https://github.com/airbnb/knowledge-repo/), internal website or pdf via email. _You use statistical models to gain insight, an explanation._
* The end goal is a **prediction**. _You use a statistical model to create predictions._ Data goes in, and predictions (in the form of data) go out. 
* The end goal is **the trained model itself**. _You deliver a trained statistical model_, to be used downstream by someone else. Very popular with neural networks (because it takes forever to train them), there are pre-trained word and image recognition models. There are several ways to distribute that model, see next section.

![](production_0_image.png)


### Options for distributing a trained model
1. **distribute the parameters of the model** alone. For instance: If you build a linear model, you can extract the parameters and turn those into an advanced SQL query with f.i.: [`{tidypredict}`](https://tidypredict.tidymodels.org/#supported-models) or [`{modeldb}`](https://modeldb.tidymodels.org/). I don't know any python packages that can do this, but you could program it. If your model is sufficiently simple you can even print out the decision rules for practitioners, for instance with [`{FFTrees}`](https://github.com/ndphillips/FFTrees). 
2. **return the trained model artefact**: save your pickled python model or `.rds` R model in a central location with some metadata and pull it where necessary. Tensorflow models are distributed like this. 
3. **wrap your model and environment into a docker container**, supply it with an API and distribute that container. The entire model is hidden away behind an interface that everyone in any programming language can work with. The big cloud vendors do it in a similar way (they call it AI for some reason). 

## So what should I choose?
Talk to your stakeholders from start to finish. **Plan for production from the start of your proof-of-concept.** You already know which of the options is required, is your end goal an explanation or a prediction? If your end product is a prediction, will you batch predict, or create an image that can be called with a standard API?
Figure these things out as early as possible, so that your project has the best changes of becoming successful product and not one of the many failed proofs of concept.

Good luck!
