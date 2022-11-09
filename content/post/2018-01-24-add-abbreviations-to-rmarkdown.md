---
title: add abbreviations to your rmarkdown doc
author: Roel M. Hogervorst
description: "How to add abbreviations in all your documents."
difficulty:
  - beginner
post-type:
  - reminder
date: '2018-01-24'
categories:
  - blog
  - R
tags:
  - rmarkdown
  - tibble
  - dplyr
slug: add-abbreviations-to-rmarkdown
---

Today a small tip for when you write rmarkdown documents. Add a chunk on top with abbreviations.

In the first chunks you set the options and load the
packages. Next create abbreviations, you don't have to care about the ordering, just put them down as you realize you are creating them.


The first step makes a dataframe (a tibble, rowwise), and the second step orders them.

```
tribble(
    ~Abbreviation, ~ Explanation,
    "CIA", "Central Intelligence Agency",
    "dplyr", "data.frame plyr, a tool for working with data in a rectangular format",
    "ABC", "The first few letters of the alphabet"
) %>%
    arrange(Abbreviation)
```

If you make use of many abbreviations, you might want to put them all in a dataframe and add them to your document.

Even better: add them to a package: a dataframe with all your abbreviations, a template rmarkdown document with your company logos, and perhaps some
ggplot themes to style your corporate work.

For instance: I create an enourmous collection of
obscure abbreviations in use in my company and put them all in my package. You don't want to use them all in your document, that would be silly. You only want to explain the abbreviations that you use in the document.

```
library(tidyverse)
library(your_corp_package)
all_abbreviations_used <- c("CIA", "DONKLEBODY", "WUT", "SPEEDR")
abbreviations %>%
      filter(abbreviation %in% all_abbreviations_used)
```


tada! Simple, useful.

Do you have ideas how to expand this idea? Perhaps you could scan the text of a document and extract abbreviations?
