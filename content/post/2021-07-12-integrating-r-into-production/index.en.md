---
title: 'UseR2021: Integrating R into Production'
author: Roel M. Hogervorst
date: '2021-07-12'
slug: integrating-r-into-production
categories:
  - blog
  - R
tags:
  - useR2021
  - mlops
  - packageoverview
subtitle: 'A view on UseR 2021'
image: ''
---

This year's useR was completely online, and I watched many of the talks. I believe
the videos will be public in the future but there were some talks that I wanted 
to highlight.


I think that the biggest problem with machine learning- (or even data-) projects 
is the integration with existing systems. Many machine learning products are 
batch or real-time predictions. For those predictions to make value you will
need:

* a way to ingest data for training
* a way to ingest data for prediction
* a place to output the predictions
* a place to train the model (a machine)
* some insight into what the process is doing: logging
* notifications to the right people when something goes wrong: alerting

I super enjoyed finding talks that hit those points. And I will highlight a few of them.


### Gergely Daroczi - Using R to Empower a Precision Dosing Web Application 
Gergely talks about a real world example of an application in a medical setting
and completely run in the cloud. This is a very nice explainer about integrating
an application. 

The front is a static site, with an integration with authentication service,
and a backend modeling API that is a docker container with plumber service running 
behind a load balancer (all hosted in AWS, although he mentions GCP alternatives too).

Gergely also pays special attention to the logs: they are send in a json format
to a logging service and are also readable in the console. He is using the [{logger}](https://CRAN.R-project.org/package=logger) package.

I believe there is an alerting service on top of the logging service.

noteworthy packages:

* [{logger}](https://CRAN.R-project.org/package=logger) 

### Maximilian Held, Najko Jahn - Bridging the Unproductive Valley: Building Data Products Strictly Without Magic
This package makes it easier to do the right thing in devops. Fall into the pit of
success. 

> Opinionated Devops for R Data Products Strictly Without Magic 

The package never guesses, you have to be explicit. Every data product needs
to be a package (that gives you many great things for free because of the awesome
package infrastructure in R). Builds docker images for you, and they are using
the same images in development, production, CI/CD pipelines etc. Which makes your
life a lot easier! Adds wrappers for database connections etc. 

I don't think other companies could just copy this work, but you could  work with
this as base very easily! 


Noteworthy packages:
* muggle [web page](https://subugoe.github.io/muggle/), [source code](https://github.com/subugoe/muggle/)


### Aaron Jacobs - Production Metrics for R with the 'openmetrics' Package

Two things I learned from this: (1) there is a sort of standard for logging in kubernetes openmetrics!
and  (2) logging and metrics are way more worked on that I thought in the R world.

A few years back I asked on a forum what people used for logging and alerting
and it seemed that most people didn't see the point. But recently I see a lot
of work on integration and it helps everyone if you speak the same standards
as the rest of the IT world. 

So the [{openmetrics}](https://CRAN.R-project.org/package=openmetrics) package
allows you to add a /metrics endpoint to your plumber and shiny applications 
so prometheus (a standard logging application in kubernetes) can pick up useful
metrics. You can define metrics yourself, but the authors of this package
have already defined a few for you, such as number of connected users, errors etc
for shiny.

If you have batch processes than it doesn't really work, (prometheus polls machines periodically and so your host needs to be up long enough to get pinged) but there is also a oush
based gateway for that. 

Noteworthy packages:
* [{openmetrics}](https://CRAN.R-project.org/package=openmetrics)

### Peter Solymos  - Data science serverless-style with R and OpenFaaS
I got really excited about Peter's talk. I had a [series of blogposts](https://blog.rmhogervorst.nl/blog/2020/09/26/running-an-r-script-on-a-schedule-overview/) about running scripts on a schedule, and although I did mention openFAAS (open Function As A Service) I never got around to spinning up a cluster to try to make R scripts work. But
luckely for us, Peter Solymos did, he created R templates so you don't have to
start from scratch! 

* see [this github repo with R templates](https://github.com/analythium/openfaas-rstats-templates) and [this blogpost on the openfaas blog](https://www.openfaas.com/blog/r-templates/). 

### Mark van der Loo - A fresh look at unit testing with tinytest
Mark is part of a group developers that want to reduce the number of dependencies in R code. 
the [tinyverse](http://www.tinyverse.org/) I think they call themselves. One of those projects is this package
[{tinytest}](https://CRAN.R-project.org/package=tinytest). The package is easy
to add to your package, most functions in [{testthat}](https://CRAN.R-project.org/package=testthat)
are replaced with tinytest functions. Another thing you can do is add the 
tests to the actual package code. So when your users have issues, they can run 
the testcode to detect problems. It also runs in parallel very easily. 
I think I'll try tinytest in my next project!

Noteworthy packages:
* [{tinytest}](https://CRAN.R-project.org/package=tinytest)

### Peter Meißner - Going Big and Fast - {kafkaesque} for Kafka Access
Kafka is used in many companies and so a way to talk to it from and to R is super useful!
You can consume messages from the cue one by one, or in batch. I think it is
supernice to have this integration working, yet another place were we can add R. 


Noteworthy packages:
* kafkaesque [github repo](https://github.com/petermeissner/kafkaesque).



### Neal Richardson - Solving Big Data Problems with Apache Arrow

The Apache Arrow project is years underway and I have seen many uses of it.
Fast load and write times of files, easy data sharing between R and python.
But I learned new things about arrow:
Arrow reads and writes parquet format files, is able to read in only subsets of
your data and thus allows you to work with data that is really bigger than 
you can handle. For instance if you have superbig csv files that clog up your
memory, but you only need  certain columns, you can turn it into arrow and only
read those columns in to your R session! 
It can even read and write directly to and from blobstorage of the major cloud vendors (AWS and GCP)! 
So you could read from a bucket with dplyr (on top of arrow) to filter and select without having to download everything! It is like dtplyr and databases but with arrow files.

Noteworthy packages:
* [{arrow}](https://CRAN.R-project.org/package=arrow) ,[vignette about dplyr and arrow](https://cran.r-project.org/web/packages/arrow/vignettes/dataset.html), [vignette about reading directly from cloud storage](https://cran.r-project.org/web/packages/arrow/vignettes/fs.html)


## Talks not directly about productionizing machine learning
But still super interesting to me!

### Frans van Dunné - Automating business processes with R

Nice tip I never thought about: Frans mentioned running scripts not as R script, but rmarkdown, because you see the output directly, and where it failed.

(It will make your dependencies bigger, because you need to render rmarkdown)

### Jonathan Bourne - Getting sprung in R: Introduction to the rsetse package for embedding feature-rich networks
A package for graph embeddings. 

Use it for:

* understanding more about robustness of networks
* distinguishing groups of networks
* smooths node features, can give insight 

The process has automated settings for fitting the model so you can start rightaway.

This is an embedding technique just like PCA or tSNE called Strain Elevation Tension Spring embedding (SETSe). A phycics based model that represents the network as system of springs. 

> It converts the node attributes of a graph into forces and the edge  attributes into springs. The algorithm finds an equilibrium position  when the forces of the nodes are balanced by the forces on the springs. 

Very impressive that it works on graphs of 10k nodes and millions of edges. It does
take half an hour on such big graphs, but it uses very little memory.  


* SETSe [{rsetse}](https://CRAN.R-project.org/package=rsetse) on CRAN, <https://jonnob.github.io/rSETSe/> 