---
title: Cleaning up and combining data, a dataset for practice
author: Roel M. Hogervorst
description: "I've created two datasets that you can use for exercises in data munging"
difficulty:
  - beginner
post-type:
  - post
date: '2018-03-12'
categories:
  - blog
  - R
tags:
  - dirty data
  - munging
  - dplyr
  - readxl
  - unicorns
  - unicycles
  - exercise
slug: a-dirty-dataset-for-you-to-clean
---
tldr: I created an open dataset for the explicit practice of data munging.
Feel free to use it in assignments,
but do mention where you got it from (CC-by-4.0). Also unicorns are awesome.

Find the dataset at: https://github.com/RMHogervorst/unicorns_on_unicycles

## Data munging / cleaning / engineering

At work I was working with a two excel files that were slightly different but
could be combined into 1 dataset. This is very typical for day to day cleaning
operations that analysts and data scientists do (statisticians too).

I realized cleaning, joining and enriching is something that statistics classes
just take for granted. But if a student only works with perfectly prepared
data, they are unable to work with real world data. Because the real world is
someone handing you an excel file with weird values and beautiful colors, that
you cannot use in your work. Or it is a webscraping exercise where some of the
pages are missing and people can't seem to spell right. Some people say 80% of
a data scientists work is cleaning data, so let us teach students how to do that
effectively. I made this dataset in R, but it does not really matter what tool
you use to read and clean this set.


### What is the dataset about?

All good datasets have a story, this dataset is thought to have been recorded by
an amateur scientist, a natural philosopher by the name of Rudolphus
in the 17th century in The Netherlands. This scientist
recorded the annual population of unicorns in western Europe over a century and also recorded
the sales of unicycles in that same time period. Although not much of the
accompanying text remains of
the original documents, what we can read is the tables and the idea that
Rudolphus thought there was some sort of relationship between uncorns and
unicycle sales.

### what kind of tasks would a student have to do?

There are 2 files, that contain a total of 3 tables. The tables can be
connected to each other with full joins on countryname and year (To make it
  more difficult, you could remove one row in one of the sets).

a student should:

- read in the data from excel
- recognize that one file contains 2 tables
- realize that countrynames are slightly different in 1 file
- join the files together
- create 1 'long' tidy datafile (country, year, value1, value2, value3)

During analysis:

-  realize that some years are missing
- perhaps impute, reason for reasons of missingness (disease epidemic in
  Austria, others are missing at random)
- find some relation between unicycles and unicorns in the 17th century in
western Europe

## what can I do with this set?

I've released the set under the creative commons cc-by-4.0 license. That means
you may remix, share, use commercially, and modify the dataset. I just want
you to mention where you got the dataset from.
If you think the units are stupid, change it. if you think the assignment is
too difficult, make it easier. Really, you can use it any way you want.

I hope this set will help in teaching students the art of data munging. I also
thought it was very funny to have unicorns on unicycles, but searching the
internet shows I was hardly the first one to think of that pun. Ah well, just
goes to show that it was a good one.

Find the dataset at: https://github.com/RMHogervorst/unicorns_on_unicycles

Happy coding!
