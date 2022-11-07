---
title: Non-standard-evaluation and standard evaluation in dplyr
author: Roel M. Hogervorst 
difficulty:
  - advanced
description: "a description"
post-type:
  - reminder
date: '2016-06-13'
categories:
  - blog
  - R
tags:
  - dplyr
  - NSE
  - optimize-your-code
  - data:duo2015
  - data:mtcars
  - lazyeval
slug: NSE_standard_evaluation_dplyr
---

THIS POST IS NO LONGER ENTIRELY RELEVANT. DPLYR 0.7 HAS A SLIGHTLY DIFFERENT (AND SLIGHTLY MORE INTUITIVE) WAY OF WORKING WITH NON-STANDARD EVALUATION. EDIT: IT IS COMPLETELY DIFFERENT NOW. AND I 
RECOMMEND <https://dplyr.tidyverse.org/>. 


I love the dplyr package with all of its functions, however if you use normal dplyr in functions in your package r-cmd-check will give you a warning: `R CMD check NOTE: No visible binding for global variable NAME OF YOUR VARIABLE` [^1]. The functions do work, and everything is normal, however if you submit your package to CRAN, such a NOTE is not acceptable. A workaround is to add globalVariables to one of your scripts. for instance:

```r
globalVariables(c("var1", "var2", "varyourmother")
				)
``` 
Which works but it is not necessary. 

## NSE 
dplyr (and some other packages and functions) work with non-standard-evaluation (NSE). One example is `library(magrittr)` vs `library("magrittr")` , both work. But
`install.packages(magrittr)` vs `install.packages("magrittr")` is different, you need the quotes. In almost all the functions in r when you name a part of an object you need the quotes but in some functions you don’t. They are designed to work in a non-standard way. Some even miss a standard way. 

I will focus on the dplyr functions only, a general introduction to NON standard evaluation might come later. 

Under the hood the dplyr functions work just as other functions, in fact 
all the functions use normal evaluation (standard evaluation), but for interactive use there is a non standard evaluation version, which saves you typing. The interactive version is then first evaluated with the lazyeval package and is then sent to the SE version. 
There is even a naming scheme [^2]:
> Every function that uses NSE should have a standard evaluation (SE) escape hatch that does the actual computation. The SE-function name should end with _.

Therefore there are multiple verbs: select(), select_(), mutate(), mutate_(), etc. Under the hood `select()` is evaluated with the lazyeval package and sent to `select_()`.
In functions you should use the SE versions, not only to stop notes from creating, but also because it gives you extra options. 

# From NSE (the standard interactive use) to SE (standard evalation within functions

So this is a list of things i regularly do with NSE and their translation in SE.

I will use the data file about students in higher education in the Netherlands. 

### background
There are basicaly three ways to quote variables that dplyr/ lazyeval understands:

- with a formula `~mean(mpg)`
- with quote()   `quote(mean(mpg))`
- as a string  `"mean(mpg)"`

## Select()
Example of the select function from dplyr. 

```r 
library(dplyr)
 # first the normal NSE version
select(duo2015_tidy, OPLEIDINGSNAAM.ACTUEEL, FREQUENCY)
# standard evaluation 
select_(duo2015_tidy, ~OPLEIDINGSNAAM.ACTUEEL)
select_(duo2015_tidy, ~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY) # comma doesn't work, + doesn't work
select_(duo2015_tidy, quote(OPLEIDINGSNAAM.ACTUEEL, FREQUENCY)) # nope
select_(duo2015_tidy, quote(OPLEIDINGSNAAM.ACTUEEL), quote(FREQUENCY)) # yes!
select_(duo2015_tidy, "OPLEIDINGSNAAM.ACTUEEL", "FREQUENCY", "YEAR", "OPLEIDINGSFASE.ACTUEEL") # works
```

Output:

```
Source: local data frame [24,150 x 2]

   OPLEIDINGSNAAM.ACTUEEL FREQUENCY
                    (chr)     (int)
1     B Aarde en Economie       121
2     B Aarde en Economie        54
3     B Aarde en Economie       140
4     B Aarde en Economie        52
5     B Aarde en Economie       132
6     B Aarde en Economie        55
7     B Aarde en Economie       144
```

## Filter()
Then the filter function ( I also use the select function here)

```r 
# ways that work. 
filter(duo2015_tidy, YEAR ==2015) %>% select(OPLEIDINGSNAAM.ACTUEEL, FREQUENCY)
filter_(duo2015_tidy, ~YEAR ==2015) %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, quote(YEAR ==2015)) %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, "YEAR ==2015") %>% select_(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
# or with a list to dots.
dotsfilter <- list(~OPLEIDINGSNAAM.ACTUEEL, ~FREQUENCY)
filter_(duo2015_tidy, "YEAR ==2015") %>% select_(.dots = dotsfilter)
```

output:

```
Source: local data frame [4,830 x 2]

         OPLEIDINGSNAAM.ACTUEEL FREQUENCY
                          (chr)     (int)
1           B Aarde en Economie       151
2           B Aarde en Economie        60
3           B Aardwetenschappen         0
4           B Aardwetenschappen       149
5           B Aardwetenschappen       335
6           B Aardwetenschappen         0
7           B Aardwetenschappen        83
```
## Group_by() & Summarize()
Group_by and summarize examples, see also the NSE vignette on dplyr [^3]. 

```r 
group_by(duo2015_tidy, GENDER) %>% summarise(total = n())
# group by in SE, and summarize with NSE
group_by_(duo2015_tidy, ~GENDER) %>% summarise(total = sum(FREQUENCY))
# both NSE, pass list of arguments to .dots
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = list(~total = sum(FREQUENCY))) # does not work
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = list(~sum(FREQUENCY))) # does work. 
dots <- list(~sum(FREQUENCY))
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = dots)
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(.dots = setNames(dots, "total"))
group_by_(duo2015_tidy, ~GENDER) %>% summarise_("sum(FREQUENCY)")
group_by_(duo2015_tidy, ~GENDER) %>% summarise_(~sum(FREQUENCY))
```

output:

```
Source: local data frame [2 x 2]

  GENDER sum(FREQUENCY)
   (chr)          (int)
1    MAN         609755
2  VROUW         639609
```

## Mutate() and slightly more advanced use

You want to add two columns up, but you don't yet know which columns that will be (example from Paul Hiemstra[^4]).

```r
# normal interactive use  
library(dplyr)
mtcars %>% mutate(new_column = mpg + wt)
```

So you would like a function that does something like this: 

```r 
f <- function(col1, col2, new_col_name) {
    mtcars %>% mutate(new_col_name = col1 + col2)
}
```

The problem is that r will search for col1 and col2, which don't exist. 
Furthermore the name of the endresult will be new_col_name, and not the content of new_col_name. To get around non-standard evaluation, you can use the lazyeval package. The following function does what we expect:

```r 
f <- function(col1, col2, new_col_name) {
    mutate_call <- lazyeval::interp(~ a + b, a = as.name(col1), b = as.name(col2))
    mtcars %>% mutate_(.dots = setNames(list(mutate_call), new_col_name))
}
```
You first create a call that will be evaluated by mutate_ . the call is first interpreted so that the final and correct names are used by mutate_ 

Of course if you already knew wich varibles you would use, there is no need for interpretation, and something like this would work:

```r
mtcars %>% mutate_(.dots = setNames(list(~mpg+wt), "sum mpg wt"))
mtcars %>% mutate_(.dots = list(~mpg+wt)) # if you don't need the name specified
```

# NSE in context

So if you want to use the dplyr functions in your own functions these are some variants that you could use. See the list of References and Notes for more information.  

# References:
[question on stack overflow](https://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string)  
[using mutate inside a function, shows excellent use of mutate function,  r-bloggers](http://www.r-bloggers.com/using-mutate-from-dplyr-inside-a-function-getting-around-non-standard-evaluation/)

[fun standardizing NSE (he has a particular kind of fun...)](http://www.carlboettiger.info/2015/02/06/fun-standardizing-non-standard-evaluation.html
)
[advanced r chapter about NSE - hadley wickham](http://adv-r.had.co.nz/Computing-on-the-language.html
)
[on r, I have not read this one ](http://developer.r-project.org/nonstandard-eval.pdf )

# NOTES
[^1]: an issue that demonstrates the r cmd check NOTE. <https://github.com/Rdatatable/data.table/issues/850> 
[^2]: wow the package is updated yesterday, but this describes the naming <https://cran.r-project.org/web/packages/lazyeval/vignettes/lazyeval-old.html>
[^3]: NSE in dplyr <https://cran.r-project.org/web/packages/dplyr/vignettes/nse.html>
[^4]: This example comes from Paul Hiemstra on his numbertheory blog that I found via r-bloggers. <http://www.numbertheory.nl/2015/09/23/using-mutate-from-dplyr-inside-a-function-getting-around-non-standard-evaluation/> With the reference to the r-bloggers version in the links above. 
