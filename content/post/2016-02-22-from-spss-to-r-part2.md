---
title: From spss to R, part 2
author: roel_hogervorst
date: '2016-02-22'
categories:
  - blog
  - R
tags:
  - beginner
  - haven
  - dplyr
  - spps-to-r
  - data:duo2015
  - tutorial
slug: from-spss-to-r-part2
---
# Introduction

In this lesson we will open a .sav file in Rstudio and manipulate the data.frame. We will select parts of the file and create some simple overviews. First time with R? No problem, see lesson [1] (https://blog.rmhogervorst.nl/2016/02/20/from-spss-to-r-part1.html#introduction "From spss to R, part 1")



## Download a .sav (SPSS) file

I downloaded the following dataset from DUO (Dienst uitvoering onderwijs): [**Aantal wo ingeschrevenen (binnen domein ho)**][3]. 
This dataset has a <span title="creative commons version 0"> cc0 </span> declaration, which means it is in the public domain and we can do anything we want with this <span title="thank you Dutch Goverment!" > file. </span> 
More information about the file can be found in the [Toelichting.pdf](https://www.duo.nl/open_onderwijsdata/images/Toelichting%2001.%20Ingeschrevenen%20wo.pdf "all in Dutch I'm afraid").

*UPDATE 2017-08-23: DUO HAS UPDATED THEIR SITE, BREAKING EVERYTHING. THIS IS CURRENLTY THE DOWNLOAD PAGE: https://www.duo.nl/open_onderwijsdata/databestanden/ho/ingeschreven/wo-ingeschr/ingeschrevenen-wo1.jsp*

*We can already work with this file, because it is in an open format, but for this exercise I will transform it to a .sav file. [See the transformation here](https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/dplyr-example-duo.R "Github example of csv -> .sav with haven")*

Download the .sav [file](https://github.com/rmhogervorst/datasets/ingeschrevenwo2015.sav) to start. Do remember where you put the file, you will need it later. 
Or let R download the file, even better for reasons of [reproducability](https://blog.rmhogervorst.nl/tags/ "all posts").
Consider starting a new [project](https://blog.rmhogervorst.nl//tags/rproject/ "with a rProject you files will be more organized") for this example.

# Opening the file in Rstudio
Fire up your trusty rstudio.
 
You will need the following packages:
haven, dplyr. Click on install:
![](/img/installing-packages-rstudio.PNG)

and fill in the names, or type `install.packages("haven", "dplyr"). 

Follow the description below or look at the complete script at:[github.com/RMHogervorst/cleancodeexamples](https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/dplyr-example-duo.R). The script and this page are more or less the same (spelling might be better here ;p ).

### Opening the SPSS file and getting it in R
```r
# necessary packages: #### 
library(haven)
library(dplyr)
# location of the datafile online ####
link <- "https://cdn.rawgit.com/RMHogervorst/cleancode/gh-pages/datasets/duo2016.sav" 
# UPDATE 2017-08-23 THIS IS A NEW SPSS FILE FROM 2016 DATA.
# load the .sav file into R using the link ####
wo2015 <- read_sav(link) 
```

So we activated the necessary packages, saved a link to the datafile, told the `read_sav()` command where to find the file, and finally assigned the output of the command to a name `wo2015`. 

### Exploration of the data frame in base-R
The following commands are very often the first things you will use when you get your hands on a new dataset.

```r
str(wo2015) # str is short for structure
names(wo2015) # what are the columnsnames?
table(wo2015$PROVINCIE) # create a table
sapply(wo2015, class)
head(wo2015)  #shows the top part of the data, 
# there is also a tail() function you could try.
View(table(wo2015$SOORT.INSTELLING))
```

The Rstudio interface already gives you all sorts of information. Just click on all the things in the environment window. 
the structure command `str()` displays in your console, and is identical to what Rstudio tells you if you click the blue button in front of the data.frame. 
The table command is very useful, but when there are many values, you can get a cleaner look by `View(table())`. The `sapply()` command is one you might use a lot in the future, but know now that it repeats a function over the columns of your data.frame and gives you a simple result back. 
Most of the columns are of class character, some are numeric, and two are of the class "labelled". 

When we used the command `View(table(wo2015$SOORT.INSTELLING))` there were actually three commands in sequence. 

- take column SOORT.INSTELLING from dataframe wo2015: `wo2015$SOORT.INSTELLING`
- create a table of that: `table()`
- put the result into the Viewer: `View()`

When looking at the endresult from the last command, you can see the frequencies of the types of SOORT INSTELLING (type of university).

**Do the same thing (display a table of frequencies) with INSTELLINGSNAAM.ACTUEEL (name of university)**

*How many universities are there?*

### Some Haven and SPSS specific things
As you know SPSS cannot work with factor (nominal) values.
You have to tell SPSS that the variable is a nominal variable
and you have to create numbered values, with a label assigned to the values *(3 = male, 4 = female)*.
When you import a .sav file into R that information can get lost. But on the other hand you might want to use the numbered information. As an compromise the haven package imports the numbers and the labels. So can we find the labels?

```r
class(wo2015$OPLEIDINGSVORM) # no, that just tells us that it's labelled. 
attributes(wo2015$OPLEIDINGSVORM) # the command attributes gives you back all the metadata
```

You can see the labels and numbers. 1 = deeltijd (part time education),
2 = duaal (), 3 is voltijd (full time)
The attributes command works on everything try: `attributes(wo2015[1,2])`.
 
So we can display the labels with number. but we would rather use that information
in R. R has no problem with nominal variables. And furthermore you won't make
mistakes about which form of eduction your talking about.

the haven package has a function as_labeled. So let's make the OPLEIDINGSVORM column a bit more informative:
```r
as_factor(wo2015$OPLEIDINGSVORM) 
``` 
Now look back at wo2015
Nothing has changed!
That's right, you need to assign the result of the operation back to a column

```r
wo2015$OPLEIDINGSVORM2 <- as_factor(wo2015$OPLEIDINGSVORM) 
```
**Do the same thing to OPLEIDINGSFASE.ACTUEEL**


## data manipulation with dplyr
Data manipulation was sometimes hard with r. However the [dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html "Dplyr is a package for manipulating dataframes. this link is an introduction by the creator") package changed everything.  

## dplyr Functions
There are 7 'verbs' that do all the work.

    filter() (and slice())
    arrange()
    select() (and rename())
    distinct()
    mutate() (and transmute())
    summarise()
    sample_n() and sample_frac()

Filter filters rows, select selects columns, distinct is a variant of unique and mutate creates new variables. These verbs are tools, the plyrs of a dataframe. Very generic tools that help you select and filter your data.
All the verbs have the same arguments: first argument = dataframe, the next arguments are for the function. 

But don't believe me on my word, let's get to work.

### SELECT

	SELECT (dataframe, variablename1, variablename2, etc)

Select is used to select variables (columns) in your data frame.

```r
library(dplyr)
select(wo2015, PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ) 
```

We have selected 4 variables. as you can see in the output. It also says: Source: local data frame [2,417 x 4]  meaning 2417 cases and 4 variables.

### FILTER

	FILTER (dataframe, ways to filter)

Filter selects cases (rows of the dataframe).

```r
filter(wo2015, PROVINCIE == "Limburg") 
```
The endresult is a data.frame [91 x 24] with all columns but 
 with only the cases in the Limburg province

### combining FILTER and SELECT

```r
select(filter(wo2015, PROVINCIE == "Limburg"),PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN )
```
I will show you a more readable form later on, but this works.
The data frame has the 91 cases from the filter action and the 4 columns from the select action. This even works the other way around:

```r
filter(select(wo2015, PROVINCIE, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ), PROVINCIE == "Limburg")
```

But not always:
`filter(select(wo2015, OPLEIDINGSVORM2,j2012.MAN, j2013.MAN ), PROVINCIE == "Limburg")
` will not work (try it).

*Why not?*
The different functions accept data.frames as input and give a data.frame as output. The data.frame from the **select** action does not contain the column PROVINCIE. Therefore the **filter** function can't select on that variable.

### ARRANGE & DISTINCT

The functions `arrange()` and `distinct()` sort the data and select the unique values from a data frame:

```r
arrange(wo2015, GEMEENTENUMMER) # data frame [2,417 x 24] all cases, all variables.
distinct(wo2015, GEMEENTENAAM)  # data frame [16 x 24]  (all the variables, only unique gemeentenamen)
```

### MUTATE
MUTATE(dataframe, name_of new variable = action).
Mutate creates new variables from other variables.

Let's find the difference between 2015 and 2014 in males.

`mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN)`

Ok, but what happened?
We can't see the new variable from14to15M, it is there because the output says:
` Variables not shown: CROHO.ONDERDEEL (chr), [......] from14to15M (dbl)
`

So let's see.

```r
test<-mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN)
View(test)
```
Scroll to the end of the viewer or use `test$from14to15M`.

An other way would be to select the variables first.

```r
select(mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN), from14to15M, PROVINCIE)
```
But these nested commands become complicated very fast. You lose the overview of your actions. But since 2014 we can use a new way to type commands in R.

# Piping / chaining and dplyr

With the pipe operator (%>%) you can chain the commands together.
The functions work the same but it is much easier to read.

```r
#from:
select(mutate(wo2015, from14to15M = j2015.MAN - j2014.MAN), from14to15M, PROVINCIE)
# to:
wo2015 %>% mutate(from14to15M = j2015.MAN - j2014.MAN) %>% select(from14to15M, PROVINCIE)
# or even better
wo2015 %>% 
	mutate(from14to15M = j2015.MAN - j2014.MAN) %>% 
	select(from14to15M, PROVINCIE)
# much easier to read! 
```
The pipe operator puts the data.frame from the left side as first argument in the right side.

Read the pipe operator as THEN:

```r
wo2015 %>% 
	mutate(from14to15M = j2015.MAN - j2014.MAN) %>% 
	select(from14to15M, PROVINCIE)
# take the dataframe, THEN mutate                       THEN select these variables.
```
Take the data.frame, THEN mutate                       THEN select these variables. 
The commands follow in the way that you use them instead of nested in each other.

### SUMMARIZE / SUMMARISE (both work)

Use summarize to apply functions over groups of cases. For instance the mean of an entire column.

```r
summarize(wo2015, mean2015_males = mean(j2015.MAN))   # if one value is missing (NA)
# there is no mean value. 
summarize(wo2015, mean2015_males = mean(j2015.MAN, na.rm = T)) # this way we remove the missings
```

But perhaps you would like to know the mean number of students per opleidingsfase? 
Summarize works with `group_by`, let's use that pipe operator again:

```r
wo2015 %>% group_by(OPLEIDINGSFASE.ACTUEEL) %>% 
	summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
```

Chaining can make things very easy. 
Let's take numbers in zuid-holland only

```r
wo2015 %>% 
	filter(PROVINCIE == "Zuid-Holland") %>%      # R will continue on the following line
        group_by(OPLEIDINGSFASE.ACTUEEL) %>%           # It also helps in readability
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
```

Grouping can be done on multiple levels and with multiple arguments:

```r
wo2015 %>% group_by(PROVINCIE, OPLEIDINGSFASE.ACTUEEL) %>%
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
wo2015 %>% filter(PROVINCIE == "Zuid-Holland" | PROVINCIE == "Limburg") %>%  # | means or
        group_by(OPLEIDINGSFASE.ACTUEEL) %>% 
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T))
# That was an OR operator, there is also an AND.
wo2015 %>% filter(PROVINCIE == "Zuid-Holland" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%  
        group_by(OPLEIDINGSVORM2) %>% 
        summarise(mean2015_males = mean(j2015.MAN, na.rm = T), number = n()) # n() gives a count
```
The `summarize` command can make multiple columns (remember that every output is also a dataframe).

Finally a filter action with numbers. Just to show you that that works as well. 
We start with all the cases, **THEN** only take the cases (rows) where variable j2011.VROUW has less or equal to 10, **THEN** take only the propedeuse cases **THEN** filter the cases with more then 10 cases and **THEN** group the cases by provincie, and **THEN** count the number of cases per province.

```r 
wo2015 %>% filter(j2011.VROUW <= 10) %>% # so less or equal to 10 women in 2011
        filter(OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>% # multipe filters? no problem.
        filter(j2015.VROUW > 10)  %>% # more then 10 in 2015. 
        group_by(PROVINCIE) %>% summarize(number_of_programs = n())
```
In other words: 

> In every province, how many programs had less then 10 women in 2011 and more then 10 in 2015? 

# Review

In this lesson you have learned to open .sav files with haven,
how to change labelled values from the Haven package, and worked with most of the dplyr commands.

## Next time:
dplyr is also called the grammar of data manipulation. 
In the next lesson we will take on the grammar of graphics with ggplot2,
see you then.




### Notes
[3]: <https://www.duo.nl/open_onderwijsdata/databestanden/ho/Ingeschreven/wo_ingeschr/Ingeschrevenen_wo1.jsp > "Because this was the first dataset I found, but this dataset is actually useful for me in my work as well"

### Further Reading
The following introduction is better than I could have made:

[1]: <https://stat545-ubc.github.io/block009_dplyr-intro.html](https://stat545-ubc.github.io/block009_dplyr-intro.html>

and here is some background information

<https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html>  
