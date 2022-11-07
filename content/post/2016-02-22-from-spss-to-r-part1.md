---
title: From spss to R, part 1
author: Roel M. Hogervorst
description: >
  "This lesson is about Rstudio, basics, and we will import data from spss. Datamanipulation takes place in lesson 2 and in lesson 3 we will make beautiful plots. The approach is hands on, I want you to do all the things, go through all the motions and start working. Start making mistakes and learn from them."
difficulty:
  - beginner
post-type:
  - tutorial
date: '2016-02-20'
categories:
  - blog
  - R
tags:
  - ggplot2
  - spps-to-r
slug: from-spss-to-r-part1
---

## Introduction
This whole blog is devoted to R and clean coding in R. But what if you want to start with R? There are millions of websites devoted to learning R. just look at the number of hits on a certain search machine. 
![google search results](/img/google_search_spss_r.PNG)
Most of these hits start with the basics and slowly work your way up to more advanced examples.

> There is often one reason to start with R: you want to achieve something that doesn't work in other programs.

This is not a dedicated R programming course, there are a gazillion really great courses( see below [^1], [^2], [^3], [^4]). 
So I will only show you a few basics, which I think you need. Any specifics can be found in a google search. really, it's very easy. 

The goal of these three lessons is to show you how things work, to load a dataset from spss into R and to create a plot. Because plotting is one of the reasons people switch sides and join the R-community. 

# This lesson
This lesson is about Rstudio, basics, and we will import data from spss. 
Datamanipulation takes place in [lesson 2](blog.rmhogervorst.nl/2016/02/22/from-spss-to-r-part2.html#introduction "lesson 2: haven and dplyr") and in lesson 3 we will make beautiful plots.  The approach is hands on, I want you to do all the things, go through all the motions and start working. Start making mistakes and learn from them. 

We will first install R and Rstudio. R is the program, and Rstudio is a very useful shell around R. Rstudio helps you organize your scripts and data and helps in codecompletion and a million other things. Furthermore, it looks a bit like spss. 

* Content
{:toc} 

## installing the software
You will need the latest version of R itself [R](https://cran.rstudio.com/), and also download the latest version of Rstudio from [Rstudio.com/download](https://www.rstudio.com/products/rstudio/download/) 

## Start Rstudio
You have installed Rstudio, congratulations!

The main screen looks like this:
![Rstudio main](/img/rstudio-bare.PNG)

With 

<figure class="half">
	<img src="/img/rstudio-packages-files-plots-history-environment.PNG" alt="image">
	<img src="/img/rstudio-new-open.PNG" alt="image">
	<figcaption>many hidden options right and left</figcaption>
</figure>

## Working with R
You can work interactively in the console (the bottom part in the next picture) and you can work with scripts (in the top part).


<figure>
	<img src="/img/rstudio-script-console.PNG" >
	<figcaption> script and console </figcaption>
</figure>


To simplify your work, you can create functions or scripts that automate stuff. In R this can be taken further. Everyone can make packages that contain useful functions and their documentation. Installed packages can be activated by the code `library(name_of_package)` . When activated, the functions from that package can be used in your scripts and in the console.

Tasks:

- open your version of Rstudio. open a new R script.
- copy the following code to that new script (you will see changes in color):

```r
# Oh my god a script!
# 
# comments start with a pound symbol (aka hashtag).
# The following line installs the packages
# install.packages(c("ggplot2", "dplyr", "haven"))
 
this line is not code and should thus be commented out

ggplot()
# activate the package ggplot2 in the 
#next line with the library command

# then try line 9 again. 
```

- uncomment line 5
- execute part of the script by selecting the line with your mouse and pressing ctrl-R or just put the cursor on the line and press ctrl-R.
- comment out line 7
- execute line 9, you will see an error. Why?
- activate the ggplot2 package with the library command
- try to execute line 9 again
- what has changed?

You found that the function ggplot() was activated after activating the ggplot2 package. You might have spotted that every line you execute is displayed in the console. That is where the R program really lives. Copy the next part to a new script:

### Getting help
```
# quite helpful to describe what you want to
# do with this script here. 
library(ggplot2) # you already activated this package anyway
# the ? or help() commands inform you about commands
help("ggplot")
# or
?ggplot
```

The help files give you a description of the function, usage and how the arguments work. And at the bottom are some examples. The help files are often somewhat technical but if you look at the examples (and try them) you will find out how things work. Another great place is the vignettes.

Vignettes are long form documentation, often describing every function in the package, practical use, examples and more. 

Or type the following command:

```r
RSiteSearch("vignette") 
```

But the best advice is this: try google. 

Really, the R community is huuuuuge! Type your question and somewhere on stackoverflow, r-mailinglists or other websites, someone else has had the same question you have. If I need to find out how a function works, I type `?function` if I want something else, I search for it online. 

To be more specific, use the following format in your search: [r] [package you want to use] [function if any] [... your problem]
for example
![](/img/example_search.PNG)


# From SPSS to R

## R specifics 

SPSS works with datafiles (.sav), R works internally with several data representations. We will almost exclusively work with data.frames and vectors. 
Dataframes look and feel just like spss file. for example: 

- copy and execute the first 2 lines below.
- use the View command or click on the blue-grey table icon in the right of the screen. next to df. 

``` r
df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30)) #this creates a dataframe with letters
# and standard normal distributed values.  
View(df) # or click  next to table on the icon on the right.
# or display it in the console:
df
```
This opens a view you are familiar with in spss, however you cannot change values here.
So data.frames are just like datafiles in spss. Internaly data frames are just lists with vectors of the same length. So what is a vector? Copy the following script and try to find out.

``` r
df$gp # also try to type this. 
# after the dollarsign rstudio will suggest the columns of the dataframe
df$y # will display all the values of the y column. 
df$i_made_this <- rnorm(30, 2) #see the documentation of rnorm with ?rnorm
# now look at df again, it has an extra column. 
# the <- (arrow) assigns values. 
subset(df, y<1) # there are multiple ways to select parts of your data
df[2,]  # try to find out 
df[,2]  # what all these things
df[2,2] # do. 
g<- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19, # going to the next
      20,21,22,23,24,25,26,27,28,29,0)  # line is no problem
g
#  ----------> in the environment is now a g value with in it numbers 1 to 30
#  g is a vector. can we add this vector to the dataframe?
df$oh_yes_you_can<-g   # we assign g to this variable
```

## Importing data from SPSS.

There are multiple packages that import spss files. Many people use the foreign package, but a new one is the haven package. 

- Install the haven package. 
- Once installed, activate the package.
- read the documentation on read_sav with ?read_sav

I will cheat a bit and let you create a .sav file and read it in afterwards, but please try it with other spss files.

``` r
write_sav(df, "~/df.sav") # this saves the file in your working dir (see console)
# or find the whole path to f.i. your working directory in MY case
write_sav(df, "C://Users/roel/Downloads/df.sav") # that should save the file to 
#your downloads (once you changed it to your settings). 
# the following line reads the file (pick your .sav file) and assigns it to df2 
df2<-read_sav(file.choose()) # you could also specify your 
# file with "path/to/your/file.sav" instead of file.choose().
```
The end result is a data.frame with the name df2 which would be identical to df. 

In the next lesson we will manipulate dataframes, in lesson 3 we will make awesome graphics.

## Further Reading

* [introduction on r-bloggers.com](http://www.r-bloggers.com/migrating-from-spss-to-r-rstats/)
* [all the r-bloggers post with spss](http://www.r-bloggers.com/?s=spss)
* [spss code in R, rbloggers](http://www.r-bloggers.com/translate2r-easy-switch-from-spss-to-r-by-using-common-concepts-like-temporary-and-column-wise-missing-values/)
* [spss to R, rbloggers](http://www.r-bloggers.com/translate2r-and-translatespss2r-implanting-spss-functionality-into-r/)

## R courses
[^1]: https://www.coursera.org/learn/r-programming "Coursera R programming: This is a great course, not sure if it's still free"
[^2]: https://www.codeschool.com/courses/try-r "Codeschool, I have not tried this one, don't know"
[^3]: https://www.datacamp.com/courses/free-introduction-to-r "Datacamp: I've heard great things from this course"
[^4]: https://www.rstudio.com/resources/training/online-learning/ "By the Rstudio people"
