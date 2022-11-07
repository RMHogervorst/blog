---
title: Your most valuable collaborator, future-you
author: Roel M. Hogervorst
subtitle: "You don’t want future-you to curse past-you" 
difficulty:
  - advanced
  - intermediate
post-type:
  - thoughts
date: '2016-05-26'
categories:
  - blog
  - R
tags:
  - version control
  - TDD
  - readme
  - functional programming
slug: your-most-valuable-collaborator-future-you
---

I was recently at a R users [meetup](http://www.meetup.com/amst-R-dam/ "amst-R-dam") where Hadley Wickham talked about data wrangling. He showed some interesting stuff! Did you know that you can put a data frame into a data frame? You can make a list of data frames and add that list to your data frame. Very cool,  and more useful then I thought, but that is not what I wanted to talk about. 

I would like to give you some tips about working with someone you will probably work with in the future. Hadley will introduce that person to you:
 

> “In every project you have at least one other collaborator; future-you. You don't want future-you to curse past-you”[^1]

And future-you is an important collaborator. I have worked with R for a almost two years[^2] and when I look back I actually see some progress in what I do with R. Most of the things I did in the past were poorly documented. I recently wanted to update my imdb search package but I decided not to touch it, because I don't know what will break if I change some things. I have less worries for more recent packages, because I have tests for almost all the functions and I could just run the tests after every change to see if the functionality is still there. 

*[update: I tried to find older creations in my github, but I was actually pretty impressed by how well documented it all was! So my example is not so good, or I just didn't upload bad examples...]*

What I did find was that hurry jobs take up the most time in the end. If I just coded something up fast and  then revisit that after a week it might still work and I might still know what I meant to do. But if the time delay gets longer future-you will need to spend more time figuring out what past-you was trying to achieve. 
  
So even if you are in a hurry now, you will  not remember the reasons for certain decisions in the future. Especially if your project gets bigger, you tend to forget things. 

**The key thing is to be as explicit and clear as possible towards future-you**. So how do we help future-you (or other collaborators) understand past-you?  

Here are some suggestions based on lots of quotes and tidbits.

##  Readme driven development 

Almost all of the github projects have a nicely formated readme. This is a very simple markdown document that describes the overal intent of the project and how to use and install it. The readme is a nice documentation of the software. So how do you make sure that the readme accurately describes the software?

 **You write the readme first.** 

Tom Preson-Werner wrote a nice [article](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html " readme driven development 2010-08-23") about this. If you write the readme first then you can think through the project first and you already know what the end user (probably mostly future-you) will need. And you don't need to write the documentation afterwards.  I have actually tried this in a few projects (f.i. [badgecreator](https://github.com/RMHogervorst/badgecreatr)), it helped me to think about the functions and the logical steps. And if you describe the next steps, other people can jump in more easily. 

## Write the test first

A way to understand past-you's incoherent ramblings in the future (see what I did there?), is to write the tests before you write the part of the code that passes the test. I am talking about unit-tests, tests that check if your code is still working as you planned it out. 

So how would writing the tests first, help future-you and current(?)-you understand each other? If written correctly the unittest is a promise, an understanding if you like, about how pieces of code should function. For instance in one of my projects the unit-test expects an error under certain conditions. Thus the code is supposed to give an error when those conditions arise.  

```r
test_that("rowsums larger or smaller than 1 are failing",{
        expect_error(CreateVertices(errorset,"var1", "var2", "vartoomuch", verticeName = T),regexp = "column means are not equal to 1" )
        expect_error(CreateVertices(errorset,"var1", "var2", "vartoolittle", verticeName = T),regexp = "column means are not equal to 1" )
})
```

I really like the elegance of the testthat package, it **literaly** says what it tests: " *test that* rowsoms larger or smaller than 1 are failing". And if the test fails it will tell you exactly **where** it failed and **what** it was trying to test (according to you). 

So how would you implement this? *I will make a seperate blogpost about this later, but for now look at r-pkg [chapter](http://r-pkgs.had.co.nz/tests.html) about testing* Start with the thing you would like to create, for instance: Count all the people that are called Roel. That is nice small function. Give it a name: `roel_counter`, for example. 

Create a seperate testscript `test_roel_counter.r`. With the testthat framework you would put that file in `tests/testthat/` so that it and all the other unit tests will be executed if you hit the shortkey. 

I usually write tests like this. 

```r
context("roel_counter")
teststring <- c("Roel", "Roel", "Hans")
confusestring < c("Roel", "roel", "rOel", "roef"
         
test_that("roel_counter finds accurate number of roel",{
   expect_equal(roel_counter( teststring, 2)
   expect_false(roel_counter( teststring) == 3)
   expect_equal(roel_counter( confusestring, 3)
   expect_false(roel_counter( confusestring) == 4) 
}
```
The first test will check if Roel counter finds 2 Roels and the second test will check if the string will not just return the total length of the string.

I could add all sorts of variations of my name to the test to see if the function works. In fact most of the things you would try out in the console to see if the function works could be put into the testfile. But in test driven development you would first create the tests and then write the function. After you have written a part of the code that works you will test and see what passes and what fails. Then you add things to the code to pass more tests. Afte all the tests have passed, you write a new test for a new part of the code. 

If current-you is interupted and future-you finds itself back at the code, future-you can just press the hotkey for the tests and find out which are failing and continue on that part. So in a way, future-you can explicitly find out what past-you was trying to achieve. 

## use version control

Version control can help you stay sane. It saves your work if you try something new, it helps you to start again at any previously committed point in history and apart from the merge errors it works generally very well.
 
Version control lets you record snapshots of previous code, but also lets you comment on what you solved or changed. When you save a new version of the code to version control you will have to be a bit explicit. Otherwise you will find yourself in this situation:

![an example of a less helpful commit message](/img/wrong_commit.PNG)

Version control, if you use meaningful descriptions, can help you find out where you did some actions and what you were trying to do. Describe intent in the commit messages. A quote I really like is:   
> "You mostly collaborate with yourself, and me-from-two-months-ago never responds to email."[^3]

My commits have become somewhat better:

![somewhat better commit messages](/img/example_better_commit.PNG)

You could even use a github-issue-based-workflow where you write down the problems you want to solve in seperate issues and after you solved a particular issue, you push the code to github referencing the issue number.[^4] 


## Functional programming

Hadley is really big on functional programming. That is, making clear what you want to achieve, and abstract away what happens in the computer itself. 

One example of this is the pipe operator. The pipe operator is in use in many programming languages (big thing in UNIX) but is not part of base r. Untill it was introduced in the magritr package[^5] by Stefan Milton Bache. The pipe does nothing special except that it takes the thing to the left of it and places that in the first place of the thing to the right.
So for instance `dataset %>% filter(name=="Roel")` means that we start with dataset and then filter the rows that have `"Roel"` in the name column.
In the background it does `filter(dataset, name == "Roel")`  
 
Which makes code much much easier to read.
compare:

`filter_by(select( filter(dataset, year == 2012), month, children, accidents ),accidents)` with

```
dataset %>% 
filter(year==2012) %>% 
select(month, children, accidents) %>%
group_by(accidents)
```  

Then there the  map functions from the purr package, which essentially replace loops. Not because loops are inherently bad, but the functions focus on the operation being performed instead of the details of the loop itself. I will write about these functions once I get used to them in the future.[^6] 

## comments

A final thought about comments in the code. 

> Do it often. 

Describe in comments mostly what your intent was, or your reasons for a function. Don't describe the **what**, but describe the **why**.
Do comment as often as you find necessary. More is better then less. However don't put future plans or errors in the comments, you will not read them. An issue tracker is a great place for those. 

# Final thoughts
Think about this quote:
 
> "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live." 

But looking back at this whole post, **you** will probably be the violent psychopath maintaining the code.

So these are some ways to help yourself in the future, try some and tell me how it went.



# references
[^1]: Or close to these words, I wrote it down later. - Wickham amsterdam 18-5-16 

[^2]: I don't know exactly, but if I use the time when I created a Github Account (november third 2014) it is almost 19 months at the moment of writing. 


[^3]: a tweet of mtholder: <https://twitter.com/kcranstn/status/370914072511791104> text tweet: @mtholder motivating git: You mostly collaborate with yourself, and me-from-two-months-ago never responds to email. @swcarpentry

[^4]: That might be too much, but it's quite nice. if you type 'closes #10' or 'fix #10' github will close issue 10 and refer to that commit. I have also heard of people using seperate branches for problemfixing and using pull requests to the main branch to solve the issues (works the same with fix or closes). I have tried this approach in some cases and it helps structuring your work. 

[^5]: It took me forever to find out why it was called magritr. Because most R packages are named after their function or are a weird pun on something* I couldn't place the name. But it is a pun on a famous painting by Magrit (La trahison des images, according to wikipedia) of a pipe with the text below "ceci n`est pa une pipe" 'this is not a pipe'.<https://en.wikipedia.org/wiki/The_Treachery_of_Images> and for the package <https://cran.r-project.org/web/packages/magrittr/index.html>  

[^6]: See for more information about loops [chapter 16 (iteration)](http://r4ds.had.co.nz/iteration.html) of the "r for datascience" book by hadley wickham. The book is still under development but is a treasuretrove of information. 
