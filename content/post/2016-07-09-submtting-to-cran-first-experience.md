---
title: Submitting your first package to CRAN, my experience
author: roel_hogervorst
date: '2016-07-09'
categories:
  - blog
  - R
tags:
  - intermediate
  - package
  - badgecreatr
  - reminder
slug: submtting-to-cran-first-experience
---

I recently published my first R package to  The Comprehensive R Archive Network  (CRAN). It was very exciting and also quite easy. Let me walk you through my process. 

First a description of my brand new package: badgecreatr, then a description of steps to take for submission. 

# Package description 

When you go around github looking at projects you often see these interesting images in the readme 
[![Build Status](https://travis-ci.org/hadley/ggplot2.svg?branch=master)](https://travis-ci.org/hadley/ggplot2)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/ggplot2)](https://cran.r-project.org/package=ggplot2)

The ones you see above are from [ggplot2](https://github.com/hadley/ggplot2). 

What are these? These are what we call badges or shields and they are often actively generated to indicate if software is actually working or not. 

Travis-ci, a continous integration service, creates the first one: the one that says build | passing. Everytime a new commit is pushed to Github a new version of the package will be build and tested. Of that test passes without problem the badge will remain green, but if the latest build fails, the green part will turn red like so [![Build Status](https://travis-ci.org/RMHogervorst/badgecreatr.svg?branch=develop)](https://travis-ci.org/RMHogervorst/badgecreatr) <- this is my develop branch of badgecreatr that fails while I write this. It could turn green if your read this later on.

The point of these badges is that they quickly signal some quality aspects of your package to new users. I think these badges are incredibly useful, but I found it tedious to copy them to every new project I had, with some small tweaks for different packages *(I'm making this a big deal but I have only build 3 packages)*. Since you will use almost the same badges for many projects  I thought it would be interesting to create a package that would copy them in your readme file with one command. 
I was not the first one with this idea, someone created the briljant badgerbadgerbadger which does the same thing for ruby on rails projects.   

After some thoughts I decided to submit it to CRAN so that people can download it from within R without the use of devtools. So that was the why. 

# Why would you submit a package to CRAN?
The main advantage to getting your package on CRAN is that it will be easier for users to install (with install.packages). Your package will also be tested daily on multiple systems [^1].



# How do you submit a package to CRAN?

Well, the good people of CRAN have put it on the bottom of their [main page](https://cran.r-project.org/ ):

> To “submit” a package to CRAN, check that your submission meets the CRAN Repository Policy and then use the web form. 

Mainly you need to run r cmd-check on your package and make sure there are no warnings, and no notes. Or if there are notes, you have to explain them to the people of CRAN. So what does r-cmd-check actually do? It checks if your package can be build and installed and removed without problems, it checks for common problems in naming and if accurate documentation is provided. In other words, it checks if your package will play nice with R and possible other packages, and if people can actually read what you said about your functions in the package. r-cmd-check also checks if your DESCRIPTION and NAMESPACE files are correctly formatted. 

You also have to do some effort to check if your package will work on other systems (solaris,  FreeBSD, Linux, Windows, MacOS, more?). Since I work on a windows computer, I know it works on my computer. But since I push all my code to Github, and I use Travis-CI, after each commit the entire package is checked on linux (or more, I could even put several mac OS versions in the test I believe). 

Furthermore I checked the functionality of most of the code with unit tests. So I was pretty sure it worked on all systems, also because I haven't used complicated programs that could differ in systems. 

The submission process is quite easy, you have to give your name, your email and then you can add your package (the tarball). It is a simple point and click form. 

The website reads a part of your package, you have to check if the information is correct. Then you have to promise that you read the information and you hit submit.  

# What happens after I submit a package?

You receive a confirmation mail with everything you typed in the website. 
And someone looks over the submission to see if you missed something and if the package works.  

I recieved an e-mail back (really fast!), to tell me that I mistyped some things (too bad that devtools or R-cmd-check doesn't check for these things). 
I was very excited and quickly did a resubmission (which is identical to a first submission, but I explained what I changed according to their comments ) 

Things that I should have done that I forgot or didn't notice:

- single quote software names so 'Windows 8.1'
- write R and CRAN with caps, not small letters 
- I wrote github, projectstatus, travis, rmd etc which should have been:
- 'Github', Projectstatus, 'Travis-CI' etc. 
- linked to a URL that didn't exist yet
- used a link with http, should have been https

That was it, it took me 2 rounds but then it was finished, I received an email with: "on CRAN now.  Best (name of the reviewer)". that's it. 


And it's on CRAN now: <https://cran.r-project.org/web/packages/badgecreatr/index.html>

## General remarks

CRAN submission used to be really hard, you had to manually write all the documentation in a seperate file, had to hand check everything, you had to search for computers to test your package on, etc. But with devtools and the excellent manuals online, starting and building a package is really easy. The final step of submission takes almost no work if you followed best practices beforehand. 


## References:
I had a lot of help from the following sources about writing r packages:

- a very short but extremely useful example of writing packages by Hillary Parker <https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/> 
- Hadley Wickham's book about writing packages <http://r-pkgs.had.co.nz/>
- Karl Broman about writing packages <http://kbroman.org/pkg_primer/>
- You actually have to search for things in the policies, which is a bit dense, but quite ok. <https://cran.r-project.org/web/packages/policies.html>
- the ropensci organisation has some excellent advise on writing packages <https://github.com/ropensci/packaging_guide>

## Notes

[^1]: This I outright copied from Karl Broman found here <http://kbroman.org/pkg_primer/pages/cran.html>
