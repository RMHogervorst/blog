---
title: WTF is Kubernetes and Should I Care as R User?
author: Roel M. Hogervorst
date: '2022-04-17'
slug: wtf-is-kubernetes-and-should-i-care-as-r-user
categories:
  - R
  - blog
tags:
  - kubernetes
  - docker
  - devops
  - intermediate
  - reproducability
subtitle: 'Fearless to production'
share_img: 'https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif'
output:
  html_document:
    keep_md: yes
---

<!-- content  -->
I'm going to give you a high overview of kubernetes and how you can make your R work shine in kubernetes.

Are you, 
* an R-user in a company that uses kubernetes?
* building R applications (models that do predictions, shiny applications, APIs)?
* curious about this whole kubernetes thing that your coworkers are talking about?
* somewhat afraid?

Then I have the post for you! 

Many R users come from an academic background, statistics and social sciences. That makes you an excellent problem solver with a deep knowledge of problems and a nuanced understanding of the world. You actually know what you are talking about! 

But there is a different world, a world where the most important thing is showing an advertisement to as many people as possible. I'm joking, but the computer science world is where ideas like kubernetes were born. And like every other group specific words are used that can be hard to understand without context. That means that you have to use those words to find answers on your questions. This post will introduce some of those words and I have a list at the bottom. And now it is available to all of us, through a cloud provider in your area. 


### Don't try to setup kubernetes yourself
Let me start with a warning: if you have one model that needs to run in production and there is no other infrastructure people around you to help, DO NOT TRY TO SETUP KUBERNETES! That is madness. It is relatively easy to package up your code into a docker container and the public cloud has many ways to run just 1 container. Managing and setting up a kubernetes cluster is a lot of work (So I've been told, I am a happy user of platforms like kubernetes but I do not want to manage it, and so far have not).

Warnings out of the way, let's go!


## What the fork is kubernetes. 

When you first read about kubernetes you might feel like this person here:

![detail from Escher drawing (or etch, I don't remember): a person looks at an impossible kube](IMG_20220316_131853.jpg)

I assume you have made a docker image at least once (if not I can really recommend the rocker images!). Docker is like a small operating system that you install your stuff on. You might think it is annoying to have an operating system inside your operating system but this small operating system is a system you can give to someone else and they will be able to run it exactly like you. It's reproducible and packaged up in one chunk. Take that idea one step further and we get to kubernetes.

In kubernetes _(or spelled k8s, because that is way cooler!)_ we don't have a single container, but a fleet of containers to build our applications. For instance: a database, a load balancer, the code that runs a website and maybe even your R container that runs your prediction code combined can become an e-commerce site.

You might wonder why you would want to build a whole load of docker containers for your applications, it seems like a lot of duplicated computers for no good reason. There are good reasons to build it like this, but before I explain, let's step back and look at the cluster.

### Kubernetes orchestrates containers
There are a gazillion tutorials and youtubers that will explain in details what kubernetes is. I could talk about abstractions of compute and storage, but I will not. 

The way I see it is: **kubernetes controls containers**. You tell the cluster what you want by giving it a configuration. Kubernetes controls your containers by comparing that configuration of what you want: _"two versions of this container with x amount of cpu"_ against what it currently has _"no containers of this kind"_. Kubernetes will take actions to move towards that state.
It's like the cluster 'sees' that there are no containers of the type you specified and so it thinks "I should probably start two containers". 


The kubernetes cluster continuously monitors the state of the cluster against its instructions. ![Ace Ventura 'it's alive!](https://media4.giphy.com/media/OpT4MnyEXaRIA/giphy.gif?cid=790b761127458709678ad10105267a3d624ece19533b9b49&rid=giphy.gif)

And if something is off, kubernetes corrects the situation. 


Oh and kubernetes is not messing around, if something is crashing the entire container will be thrown out ...
![Ace Ventura 'alright then'](https://media2.giphy.com/media/tq4PuoUVgsK9q/giphy.gif?cid=790b7611de8900c28995af186abb79e51a9b14b99fe730a3&rid=giphy.gif&ct=g)
and replaced by a fresh copy. 
![Ace Ventura 'hitting head on floor'](https://media2.giphy.com/media/fEb9fdKn1ya76/giphy.gif?cid=790b76119107c091f29bf94ef937ec8c412ce9fa7b3b9090&rid=giphy.gif&ct=g)


### Building complex systems from components
One of the things I find interesting about kubernetes is that it allows you to configure a complex application from simpler parts: one load balancer container, one machine learning API, one database, and three website serving containers for example. All wired up together
form an entire business. 

![magician floating a woman](https://media3.giphy.com/media/3o6Zt9BJUo6OECnczK/giphy.gif?cid=790b761188c0ecdc0005a3b57bccf7c91db7550346b989e5&rid=giphy.gif&ct=g)

Because the applications are all separate containers you can swap them out if you want to. If a company gets larger you can allocate one team for that one part of the business and whatever they do for that part of the application does not influence other parts.

You can also dynamically increase the number of containers that serve traffic when it is very busy, and downscale when there is less traffic.

Or you can add a new version of your machine learning API without impacting the other components. Or run two versions at the same time where one is serving traffic and the other is running in shadow mode to test your new predictions against the old one. 

Whether you want to use R, python, matlab, julia or javascript for your work, it does not affect the other containers at all.
It does not matter at all what language you use, as long as your container can communicate in a standard way with other components. In many cases through a REST API. So if you package up your R code and add a plumber API on top it just works! 

So the idea of multiple small separate computers becomes more attractive this way. You can develop independently without interfering other components. So if you work together with a website team and you are responsible for a Machine Learning endpoint that will be called by the website you can run that container in the same environment with very little problems.

### Kubernetes in practice
Every kubernetes deployment (fancy config file for a continuously running container) or job (fancy config file for a container that starts and finishes when the job is done) consists of configuration and a container.  Usually described in a Dockerfile. So your project looks like:
* your code (python/R/julia/matlab, whatever you fancy)
* a Dockerfile that packages up your code
* a configuration file (deployment.yaml, job.yaml) (sometimes someone else will do this for you)

So you build your machine learning code. You package it up into a docker container (we call it an image now, because we are fancy). You push that image into a registry.
Using the configuration file, you tell the kubernetes cluster where to find that image and how to build your service out of it ("make two copies and give them lots of ram").
Kubernetes has new instructions now, and makes sure the cluster state matches those instructions. And it works! 

### Being an effective team member
So how can you be an effective team member when working with kubernetes.

1. make sure your container actually runs, test that extensively!
2. arrange what your API should look like: when you use [{plumber}](https://CRAN.R-project.org/package=plumber): what endpoint will be called, what port should be reached for, and what will the data look like? Make sure you write some tests for that! When you use [{shiny}](https://CRAN.R-project.org/package=shiny): what port does it live on, what are the memory and CPU requirements for your application. In all cases: what secrets must be supplied to the container? 
3. arrange where logs should go and how they should look. My favorite R logging package is [{logger}](https://CRAN.R-project.org/package=logger) and it can do many many forms of logging. If something goes wrong you want the logs to tell you what happened and where you should investigate.

### Upgrading your game and protecting yourself
This is quite a complex machinery, even if you are only responsible for your own container.
So it's important that failures are caught as quickly as possible. It would be a shame if your prediction machine does not work because you forgot to install {purrr}. 

The following things are generic best practices that make your work better. Better, reproducible and more predictable. That means less surprises. BEcause surprises are great, except when someone calls you out of your bed at 03:00 hours. It sucks if you have to emergency troubleshoot a critical application because your project died and restarting doesn't work, nor does a previous version work. No one likes that kind of surprise. 

You don't have to implement everything all at once, every step is progress. You want to be confident your work meets all the standards. In an ideal world, you should be fearless in deploying new versions of your code, because you are confident that mistakes will be caught by automated steps. 

So to fail as quickly as possible, before your work reaches the outside world (production) and make the iterations superfast you need to at least test your code. 

#### Test everything
Write R tests that check if you can handle the expected inputs. Check that you are logging errors when they occur. Check how you handle unexpected inputs (a person with an age of 200, a car with no weight, etc). 
You test your R work so you are confident that your R code works. You also have to 
test the container, pass expected input to the container, pass unexpected input, test if the container fails and protests loudly when the required environmental variables are not found.

#### Pin what you can
Fix things that can vary: pin dependencies so that it works on your machine, as well as a docker image. Use [{renv}](https://CRAN.R-project.org/package=renv) to install specific versions of r-packages, and to record that in a lockfile. Use pinned base containers too, for instance `rocker/r-ver:4.0.0`. If you pin the package versions and docker images your build will be reproducible, and that means less surprises. Less surprises is good for everyone. 

#### Automate all the dull steps
I'm extremely lazy, repetitive steps bore me to tears. And boring steps makes me forget critical steps. 

Make sure all the right actions are done for you. Script those steps. 
In your version control system, make steps that check your code on style and stupid things (linting), make a step that runs all the tests, make a step that builds the docker image,
make a step that checks the image, make a step that pushes the image to the registry, make a step that deploys the new version of your code to the production cluster. 

Make the computer do all the dull steps, if the automated stuff passes, you should be confident your work works. If you do not feel confident, think hard about why, are there edgecases that you fear? Add them to the testsuite. 

# Conclusion
I hope you come away from this post with the idea that **kubernetes is just a bunch of docker images with an overzealous boss that micromanages all the work that goes on in a cluster**, or something like that.

You should not care that much about kubernetes, I hope you have an infrastructure team around you that will help you automate the essentials parts of kubernetes. Just make sure your docker image works, and integrates nicely with the existing applications around you.

I also hope you can go to that infrastructure team and ask for help using the right words. In time I hope you are a fearless deployer (new word) that rocks the world with your awesome R-product, and I hope to hear you speak about that awesome work on a conference. 


## Notes
* cool picture right! You can see it in the Escher museum if you are ever in Den Haag (The Hague), The Netherlands <https://www.escherinhetpaleis.nl/?lang=en>


## Jargon and fancy words
Sometimes the hardest part of finding help is finding the right words to describe your problem. 

* **image**: although there are differences between an image and container (=active image) in practice it does not matter that much in communication
* **container registry**: The kubernetes cluster must pull the containers from a registry, so it is vital your image ends up in that register. 
* **k8s**: the cool way to spell kubernetes (I don't know how you can make /coo-ber-net-ees/ from k-eight-s; but it did allow for k9s as interface and k3s for a mini kubernetes on your computer)
* **kubernetes**, it's an american pronounciation of the greek word 'κυβερνήτης' which means helmsman. There is a clear nautical theme here. Docker has an image of a whale, the concept of multiple docker containers with some control around it is known as a 'pod'. There is a way to deploy entire applications on kubernetes with 'helm' and there is a docker registry known as 'harbor'. 
