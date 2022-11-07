---
title: Tidying your data
author: Roel M. Hogervorst 
difficulty:
  - beginner
description: "The basics for cleaning up data, and reshaping it to a form for your analysis."
post-type:
  - tutorial
date: '2016-02-24'
categories:
  - blog
  - R
tags:
  - dplyr
  - tidyr
  - data:duo2015
slug: creating-tidy-data
---

# Introduction

To make analyses work we often need to change the way files look.
Sometimes information is recorded in a way that was very efficient for input but not workable for your analyses. In other words, the data is messy and we need to
make it tidy.

Tidy data means [^1]:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

Today we will work with the DUO dataset about the number of students per program in the past 5 years [^2] which was used in lesson 2 of [from-spps-to-r](https://blog.rmhogervorst.nl/blog/2016/02/22/from-spss-to-r-part2.html).

The raw datafile in r looks like this:
![messy data duo](/img/tidy-duo-before.PNG)

Which is efficient in space, but not useful for analyses. For many analyses you will need to refer to multiple columns. For example:

-  is the total number of people (both males and females) in 2012 different from the total in 2015 in the regular bachelor propedeuses? 

The format of the raw file is  also called the wide format.  
What we want is a long format like this:
![tidy data duo](/img/tidy-duo-endresult.PNG)
Where every observation (the number of people in the group) has it's own row.

 
What you need to know before we start:

- the dplyr package, the pipe (%>%) operator, see[from-spss-to-r-2](https://blog.rmhogervorst.nl/blog/2016/02/22/from-spss-to-r-part2.html).
- subsetting, data frames, basic manipulation of data 
- how to install packages, see [from-spss-to-r-1](https://blog.rmhogervorst.nl/blog/2016/02/20/from-spss-to-r-part1.html).


### Preparation
Set up a project or clean your workspace in r. Follow the instructions by copying the code or see the script [here](https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/tidyr-on-duo-data.R)

```r
# we will use the tidy r package
install.packages("tidyr")
library(readr)
library(tidyr) 
library(dplyr)
link<-"https://www.duo.nl/open_onderwijsdata/images/01.%20Ingeschrevenen%20wo-2015.csv"
ingeschreven_wo_2015<-read_csv2(link, trim_ws = T) #uses the ; notation therefore csv2
View(ingeschreven_wo_2015)
```
When we look at the tail end of the data.frame we see some weird cases, some are empty and some are  summary variables.

## Tasks
To get to tidy data we need to do a few things:

* remove final two rows that contain whitespaces and totals
* shape the data into frequencies per year per gender

### Removing the final two rows

```r
ingeschreven_wo_2015[2415:2417,12:16]  
#show the bottom part of the data.frame 
duo2015<-ingeschreven_wo_2015[-(2416:2417),]
# compare:
tail(ingeschreven_wo_2015)
# with
tail(duo2015)
```

### Shape the data into frequencies per year per gender

Check the description in the vignette to see some examples and use cases of tidyr.  `vignette("tidy-data")`
First we shape the file from  wide to long format, the columns 13 - 22
contain both year and gender. Which I would like to have seperated.
In this first step we gather all the data from the columns 13 to 22
and put turn them into cases.
I think this is equivalent to Restructure in SPSS?

```r
duo2015 %>% gather(year, frequency, c(13:22)) %>% View
```
If you look at this temporary file you see that it contains 24150 cases  and only 14 columns. Compared to the 2415 cases and 22 columns in the original set.  
Unfortunately the 13th column contains both year and gender. Let's fix this.

### Separating the year-gender column
Again this is temporary file. Only when we are happy with the endresult wil we save the file.

```r
duo2015 %>% gather(year, frequency, c(13:22)) %>% 
        separate(year, c("year", "gender" ))  %>%
        arrange(`OPLEIDINGSNAAM ACTUEEL`, year, gender) %>%  
		# sort on name, year gender
        View 
```
That works, let's create a new datafile. The commands remain the same but we assign the entire thing to a new name:

```r
duo2015_tidy<-duo2015  %>% 
        gather(year, FREQUENCY, c(13:22)) %>% 
        separate(year, c("YEAR", "GENDER" ))  %>%
        arrange(`OPLEIDINGSNAAM ACTUEEL`, YEAR, GENDER)
View(duo2015_tidy)
```
We left out the View command, because that would show it to the Viewer, but we need a new data.frame. The last command in the chain, `arrange` , does not really change the file, but orders the rows in a different way.
The next step could be saving it to a new csv file. But something is bothering me. 

## Cleaning up some variablenames
Some of the variable names (columnnames) contain spaces, for example: OPLEIDINGSNAAM ACTUEEL. we can access those variables with the backtick: ``duo2015_tidy$`OPLEIDINGSNAAM ACTUEEL` ``  but it's not pretty, often confusing and prone to mistakes. Let's replace the columnnames with a bar in place of the space.First the command then the explanation:
```r
names(duo2015_tidy)<-gsub(" ", "-", names(duo2015_tidy))
```
The command `names()`  returns the variablenames, the command gsub uses pattern recognition and  replacement (for more info see `?gsub`).
The first argument of gsub is what to recognize, (" ") meaning spaces
the second argument is the replacement. I chose a bar ("-"), but nothing ("") or a dot (".") would work equaly well.
The third argument is the vector to apply this principle on, the names of the variables in this case. Finally we assign the endresult of that command to names(duo2015). 

So in one line we replaced the spaces in the names of the variables and assigned the new columnnames.

Then save it to a file:
`write_csv(duo2015_tidy, "files/duo2015_tidy.csv")`

**That's it, we're done. Your data is tidy. and ready for analyses or plots.**

### References

[^1]: Wickham, Hadley. “Tidy Data.” Journal of Statistical Software 59, no. 10 (2014). doi:10.18637/jss.v059.i10.
[^2]: <https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp>

