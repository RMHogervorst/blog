---
title: From Proof of Concept to Production
author: Roel M. Hogervorst
date: '2019-12-13'
slug: best-practices-in-software-engineering-poc-prod
categories:
  - R
tags:
  - best-practices
  - software Engineering
  - data_science
  - SeriesBestPractices 
subtitle: '#Rinprod Best practices in software engineering for R: introduction'
image: '/post/2019-12-13-best-practices-in-software-engineering_files/shawn-lee-vuEiSEegQAk-unsplash.jpg'
---

How do you go from proof of concept script to production? 
We start with a 'simple' script and move it gradually to production.
In this post I'll introduce what I mean with going to production.

![A nice bespoke machine learning model (actually a watch)](/post/2019-12-13-best-practices-in-software-engineering_files/shawn-lee-vuEiSEegQAk-unsplash.jpg)


## From proof of concept to 'production'


Applying machine learning in companies often starts with a simple proof of concept to 
figure out the value of a project. Maybe you put a script together on your laptop that improves the conversion of a group of customers. You calculated how much money this will make your company. Cool! Everyone is excited!

And now your boss tells you to run this script every day. 
You did it once, how hard can it be to run this script all the time?
But, this is your laptop. Theoretically you could push the button every day, 
in fact I have seen scripts that run every day on 1 person's
computer, but really, there must be better ways.


![The big deploy-to-production button: Pull the lever, Kronk!](/post/2019-12-13-best-practices-in-software-engineering_files/florian-olivo-ca7tJ48YD64-unsplash.jpg)

A month later you moved your script to an always-on computer, and
you no longer have to press a button; there is a CRON job that fires up the process. 

This can work for a very long time. In fact there are excel sheets in companies that deliver millions of euros^[You didn't think I would use dollars here right?] of value. 
And to be clear, I don't think this is wrong. If it works, it works. But if it breaks
or needs a change... boy, now it gets tricky!

THIS NEEDS A REWRITING

Working code is not static. Production code is living code, it should be easy to read, easy to understand, easy to modify without fear that the entire process breaks. It should also be 
a joy to work with (if only for your own mental health). For machine learning projects I want to be able to see how the project is performing.
The machine learning part is a very small part of the total application. [ADD KOANINGS IMAGE OF ML IN SOFTWARE HERE?]  That application reads in data, deals with it, trains a model, predicts for new cases and returns values in a consistent way. A production system does not just need a machine learning part but everything else is vital. Such a system must not be fragile. You need to deal with certain uncertainties.  You need control of the 
data flow, verification of results and you need to be able to track performance and 
running over time. Also such a system is never done, you can make sure that it needs
 minimal work, but work on it someone will nevertheless. 
So how do we get there? This beautiful world where the code works and is a joy to work with?
We work with best practices. 


![Best practices, like this chain, keep your project together](/post/2019-12-13-best-practices-in-software-engineering_files/jj-ying-PDxYfXVlK2M-unsplash.jpg)

# The best practices I will be talking about in this series
There are many guides, books, talks, ...
FOCUS ON REFACTORING, MONITORING LOGGING , TESTS AND VALIDATION

THIS HIERE? [
I've always been fascinated by these practices, I read clean code when I started coding, and I am currently reading Refactoring and I even called my first blog 
'clean code'. I HAVE MOVED ALL THE POSTS TO THIS BLOG]

However not all software engineering best practices apply to data science work. We must choose what best practices make sense and what don't. Personally I think the focus OF 
SOFTWARE ENGINEERING is
way to much on object oriented programming, which is possible in R (in 3 different ways even), but seems like an
enourmous overhead. At a higher level, yes it seems smarter to seperate the concerns.
But classes and methods seems wrong. WE WORK WITH DATA, SO DATA SHOULD BE THE FOCUS,
WE HAVE PACKAGES AND FUNCTIONS THAT DO SOMETHING WITH DATA. 
R WAS DESIGNED TO DO STATISTICS IN A RELATIVELY EASY WAY, AND YOU AS A USER TO PICK UP PROGRAMMING IF YOU WANT TO [REFER TO USER TALK BY ROGER PENG?]. SOME THINGS ARE JUST 
BUILD IN, WE HAVE A NATIVE DATA STRUCTURE DATAFRAME THAT IS EXCELLENT FOR RECTANGULAR
DATA, WHICH IS WHAT WE USE ALL THE TIME FOR ML. MISSINGNESS IS A VALID OPTION.
TECHNICALLY WE GO FROM DATAFRAME TO MATRIX TO MODEL. 



## About me
In my $DAYJOB I'm building machine learning solutions for a company. We engineer
automatic processes that should work without our intervention. We build small applications 
that perform batch jobs, in general reading from a database, processing and writing to a database. 
We are using software engineering best practices to make life easier for ourselves.
We have a small team and we really don't want to spend too long on debugging our applications. For us it is really important that we have confidence in
the process and that we know when it fails and why. We move from project to project and in the mean time the applications should run predictibly. When a project fails and you have to 
return to that project, we should be able to quickly find out what went wrong, why it went wrong and what we can do to fix that. We do not want to first take a day or two to find out how the code works. And if the requirements for a project change we want to be able to easily add new functionality. 

So we focus on easy to understand code, with a little as possible interconnectivity.BETTER PRHARSE?


# So why should you, my reader care?
For an academic or the only data scientist in a company, you might wonder, why would I
read up on these skills? 
The short answer is: it will save you time and head aches. 

But you can make use of these practices if you are going to use something more than twice.
If you follow these best practices you will know how your project works after 
2 months of working
on something else. If someone else wants to continu your work, they can.  And if you want 
to add functionality it will be way easier than before.

I don't think you have to become a super programmer to work on data science. I do think you should know some basic concepts, and develop an insight in when something could be done better. But I'm a big fan of small steps. Maybe try refactoring your scripts in the next project, and adding more monitoring to the project after. Pick and explore. I will not tell you what to do: I'm not a police officer, use your common sense.



## production
There have been flame wars about the terms scale and production. But what I mean is this:

Production is where people / the company depend on your code, you don't run it manually.

If you have a CRON job that runs every week and uploads to a database that can be production.

Crucially:  your process runs without your intervention and starts and stops automatically. And you have some way to monitor if the process is running as expected. 

In this specific case there is some machine learning process, not something a database can execute. I want to show you how you can incorperate these best practices in your basic scrip without being overwhelmed. Take it small steps at the time.

you want to run your process, without supervision and be alerted when it fails, 
prefeerable telling you where to search first for problems. 
Ideally you make your code indepent of where it is supposed to work. In some companies
there are operations teams that take over scheduling, deployment etc. In other companies 
there is a schedular in use which you must use, for example Airflow or Luigi. 

You might think that professional programmers are building super advanced and complicated code. Focused on speed and performance. Although speed and performance are important, 
code is also meant to be read. By humans. Code changes over time, most of the best practices
focus on improving your reasoning about the code. Code is nothing more than a crystalization of thought. AND A WAY FOR SILICON [ELECTRIFIED ROCKS] TO WORK ON IT. SO WE SHOULD MAKE IT AS EASY AS POSSIBLE TO REASON ABOUT YOUR CODE ABSTRACTION LAYERS. SO WE HAVE TE MAKE SURE THAT ITS WELL ORGANIZED AND TALKS TO US. THAT IT COMPLAINS WHEN THINGS ARE WRONG.


----
ELEGANT, FOCUSED, NO DUPLICATION

CLEAR INTENTION

SMALL FUNCTIONS, THAT CONTAIN each other.

---
DON'T REPEAT YOURSELF, KEEP IT SIMPLE, YAGNI, BEGIN DESIGN FIRST, AVOID PREMATURE OPT, 
Principle Of Least Astonishment 

SOLID single responsibility, open-closed (open for extension, closed for modification), etc

Law of Demeter

The main idea of this principle is to divide the areas of responsibilities between classes and encapsulate the logic inside the class, method or structure. From this principle we can highlight several recommendations:

----


# Example script 
In this series I want to show you best practices as I understand them, applied to
an R script. 

* We take some data
* handling missing data
* feature selection
* feature engineering
* train a model on it, 
* use the trained model on new data

I presume you have done your exploratory analyses, and so you know what is in 
the data. 

In this series we will use that basic script (I say basic, but it it still a quite
complicated program, so please don't think you are dumb if you never created such a thing )
.
The basic script can be found in [this specific Git commit, you can browse around in that state on github](https://github.com/RMHogervorst/example_best_practices_ml/tree/cd14929327b99a7c379eca896cdf7b471ccfd868).

We will rework that script with the help of:

* refactoring
* adding logging / monitoring
* adding tests and validations

I've worked on the script UNDER VERSION CONTROL and the changes are put into a branch. So you can follow
the steps on github. VERSION CONTROL IS VITALLY IMPORTANT FOR GOOD PRACTICES AND YOUR SANITY. READ MORE IN THE EXCELENT WATCH ME GIT, WATCH ME REBASE [JENNY BRYAN]().

* start of script [blogpost 2019-10-30]() [, code](https://github.com/RMHogervorst/example_best_practices_ml/tree/cd14929327b99a7c379eca896cdf7b471ccfd868).
* Refactoring [blogpost 2019-11-05](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/07f4d40c401efaa53713e255fd0caaf1e6554767)
* Adding logging and monitoring [blogpost 2019-11-12](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/91acc95f4cf3ce6258515f0c5d097019a01bbe9a)
* Adding tests and validation [blogpost 2019-11-19](), [code after this step]()


# What's next?
I realized there is not a lot of information on how these practices should work for the R
community. (if they are, please tag me on [twitter!](https://twitter.com/RoelMHogervorst))
I really like to hear from you. What has been your experience putting R in into production? Are there other best practices I should talk about? Do you have lessons learned?
@ me on twitter, checkout and use the  [hashtag #rinprod](https://twitter.com/hashtag/rinprod?src=hash). Or start a topic on [community.rstudio.org](https://community.rstudio.org) (and you can tag me in there as well).

![All the models that you discarded and that never made it to prodcution](/post/2019-12-13-best-practices-in-software-engineering_files/heather-zabriskie-yBzrPGLjMQw-unsplash.jpg)


## Extra resources

* Mark Sellors has done a ton of work on R in production [here ](https://github.com/rinprod) is a repo and a [presentation at RstudioConf 2019](https://rinprod.com/).
* Edwin Thoen is writing a book about [Agile Data Science](https://edwinth.github.io/ADSwR/index.html) that has incorperated a lot of best practices, he talks about testing, versioning, and how agile philosophy applies to Data Science.
* The book clean code by Robert C. Martin is a classic and still reads truth.
* I cannot recommend Advanced R by Hadley Wickham enough [online version](https://adv-r.hadley.nz/)
* And r 4 data science has a deep understanding of R [online version](https://r4ds.had.co.nz/)
* This [dev.to post has a nice concise overview of best practices](https://dev.to/luminousmen/what-are-the-best-software-engineering-principles--3p8n)
* VERSION CONTROL AND R, BEST PRACTICES JENNY BRYAN.


## Image sources
* image of watches Photo by Heather Zabriskie on Unsplash https://unsplash.com/photos/yBzrPGLjMQw 
* New watch on green background Photo by Shawn Lee on Unsplash https://unsplash.com/photos/vuEiSEegQAk
* large switch Photo by Florian Olivo on Unsplash https://unsplash.com/photos/ca7tJ48YD64
* image of chain https://unsplash.com/photos/PDxYfXVlK2M Photo by JJ Ying on Unsplash
