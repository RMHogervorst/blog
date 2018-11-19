---
title: The ships hung in the sky in much the same way that bricks don't
author: Roel M. Hogervorst
date: '2018-06-19'
slug: the-ships-hung-in-the-sky-in-much-the-same-way-that-bricks-don-t
categories:
  - blog
tags:
  - HHGTTG
  - beginner
  - ggplot2
  - tidytext
  - sentiment
  - pubcrawl
subtitle: 'A tidy sentiment analysis of the Hitchhiker's Guide to the Galaxy series'
draft: true
---

I love the Hitchhiker's Guide to the Galaxy series. Douglas Adams plays with words and images (like in the title).
The story has an unlikely hero : Arthur Dent, a grumpy man who is permanently uncomfortable. The stories are silly with serious undertones. Even if you don't know anything about Hitchhikers guide, you might know some memes originating from the books:

> The answer to life, the universe and everything is ... 42

> So long and thanks for all the fish

I also think the stories only work in English, I found a Dutch translation and threw it away because Arthur kept drinking coffee (in the English version he drinks tea; I never understood the need to transform that part. Also all of the names were weird, something that never bothered me in the Harry Potter translations. But I'm getting distracted from what I wanted to show). 

### What are we going to do?

One of my friends told me he thought the Hitchhikers books were getting darker over time, that is something we can find out with sentiment analysis! 

I'm using, once again, the excellent tidytext package and book [tidytextmining.com](https://www.tidytextmining.com/) as guide. 

I've collected all of my ramblings and code
on this github page: <https://github.com/RMHogervorst/hhgttg/>

### the dataset
I did not include the book datafiles, because that would be a violation of copyright. But if you have the books in a digital form (you can buy them online), you can load the data in. I've saved all of my digital files in the open epub format. 

With the quick help of [Bob Rudis](https://twitter.com/hrbrmstr "@hrbrmstr") I can know load in epubs in a pretty tidy format (it depends a bit on the type of file, mine were pretty much ready from the get go, except the last book which needed some tweaking). 

### Sentiment analysis

There are multiple ways to do sentiment analyses, there are 4 different sentiment datasets in the tidytext package. 

We can count positive and negative words, 
we can have a dataset of words with their respective negative or positive intensity (valence) or we can classify words on type of emotion (fear, sadness, surprise, etc).

Let's try the different methods.

```
source("R/01_load_data.R") # loads datasets
library(tidyverse) 
library(tidytext)
```

We now have a dataset called HHGTTG. This dataset has a row for every chapter in every book. We break the dataset up into words a dataframe with book, chapter and word columns.

```
unnestedHHGTTG<- 
    HHGTTG %>% 
    group_by(book, chapter) %>% 
    unnest_tokens(output = "word",
        input = content, token = "words") %>% 
    ungroup()
```
## Sentiment per book per emotion

Then we can add sentiment per chapter.

We break the NRC sentiment up into different emotions (I sort of used these at random, I figured surprise would be nice, fear and joy nice to haves).

```
joy <- get_sentiments("nrc") %>% 
    filter(sentiment == "joy")
surprise <- get_sentiments("nrc") %>% 
    filter(sentiment == "surprise")
fear <- get_sentiments("nrc") %>% 
    filter(sentiment == "fear")
sadness <- get_sentiments("nrc") %>% 
    filter(sentiment == "sadness")
```

We can create a plot per book to describe the words that scored highest per emotion.

We use a inner join that keeps only matching rows, all the words that are not in the joy dataset are removed. After that we can take the top 15 words per book. 
```
unnestedHHGTTG %>% 
    inner_join(joy) %>%
    group_by(book) %>% 
    count(word, sort = TRUE) %>% 
    top_n(15, wt = n) %>% 
    ungroup() %>% 
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = book))+
    geom_col(show.legend = FALSE)+
    facet_wrap(~book,scales = "free")+
    coord_flip()+
    labs(
        title = "Top 25 most frequent joy-words",
        subtitle = "",
        x = "", y = ""
    )

```

![joywords]()

The word good, found and sun are in the top of all books. I personally do not find them that joyfull. Let's look at the surprise words.


```
unnestedHHGTTG %>% 
    inner_join(surprise) %>%
    group_by(book) %>% 
    count(word, sort = TRUE) %>% 
    top_n(15, wt = n) %>% 
    ungroup() %>% 
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = book))+
    geom_col(show.legend = FALSE)+
    facet_wrap(~book,scales = "free")+
    coord_flip()+
    labs(
        title = "Top 25 most frequent surprise-words",
        subtitle = "",
        x = "", y = ""
    )
```

![surprise words ]()

Again good, and sun. And suddenly, that seems like a surprise word. 
Let's continue to fearfull words

```
unnestedHHGTTG %>% 
    inner_join(fear) %>%
    group_by(book) %>% 
    count(word, sort = TRUE) %>% 
    top_n(15, wt = n) %>% 
    ungroup() %>% 
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = book))+
    geom_col(show.legend = FALSE)+
    facet_wrap(~book,scales = "free")+
    coord_flip()+
    labs(
        title = "Top 25 most frequent fear-words",
        subtitle = "",
        x = "", y = ""
    )
```

![fear words]()

It seems this dataset thinks god is both fearfull and joyfull. 
Lets continue on to sadness.

```
unnestedHHGTTG %>% 
    inner_join(sadness) %>%
    group_by(book) %>% 
    count(word, sort = TRUE) %>% 
    top_n(15, wt = n) %>% 
    ungroup() %>% 
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n, fill = book))+
    geom_col(show.legend = FALSE)+
    facet_wrap(~book,scales = "free")+
    coord_flip()+
    labs(
        title = "Top 25 most frequent sad-words",
        subtitle = "",
        x = "", y = ""
    )
```

![sad words]()

I think we need to look deeper into the sentiment per chapter.

### Sentiment per chapter positive vs negative
The bing corpus has words divided into negative and positive words.

We can split the words into positive and negative and calculate a score per sentence.

```
sentiment_chapter <- 
    unnestedHHGTTG %>% 
    inner_join(get_sentiments("bing")) %>%
    count(book, chapter, sentiment) %>%
    spread(sentiment, n, fill = 0) %>%
    mutate(
        sentiment = positive - negative,
        N_sent_words = positive+negative,
        relative_sentiment = sentiment / N_sent_words
        )
```

What is the sentiment per chapter?
We look at both the total sentiment (positive - negative) and relative total sentiment / total number of words.

```
sentiment_chapter %>% 
    ggplot(aes(chapter, sentiment, fill = book)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~book, ncol = 2, scales = "free_x")+
    labs(
        title = "Sentiment per chapter",
        subtitle = "Total sentiment per chapter"
    )
```

![sentiment per chapter]()


And the relative

```
sentiment_chapter %>% 
    ggplot(aes(chapter, relative_sentiment, fill = book)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~book, ncol = 2, scales = "free_x")+
    labs(
        title = "Sentiment per chapter",
        subtitle = "relative sentiment per chapter"
    )
```

![relative sentiment per chapter]()


We can also use the valence. 

#### state of the machine
I did this post a bit differently. So I don't have the state, except for this print

```
Session info -----------------------------------
 setting  value                       
 version  R version 3.4.4 (2018-03-15)
 system   x86_64, linux-gnu           
 ui       RStudio (1.1.423)           
 language (EN)                        
 collate  en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2018-06-19                  

Packages ---------------------------------------
 package   * version date       source         
 backports   1.1.2   2017-12-13 CRAN (R 3.4.3) 
 base      * 3.4.4   2018-04-21 local          
 blogdown    0.6     2018-04-18 CRAN (R 3.4.4) 
 bookdown    0.7     2018-02-18 CRAN (R 3.4.3) 
 compiler    3.4.4   2018-04-21 local          
 datasets  * 3.4.4   2018-04-21 local          
 devtools    1.13.5  2018-02-18 CRAN (R 3.4.3) 
 digest      0.6.15  2018-01-28 CRAN (R 3.4.3) 
 evaluate    0.10.1  2017-06-24 CRAN (R 3.4.3) 
 graphics  * 3.4.4   2018-04-21 local          
 grDevices * 3.4.4   2018-04-21 local          
 htmltools   0.3.6   2017-04-28 CRAN (R 3.4.3) 
 knitr       1.20    2018-02-20 CRAN (R 3.4.3) 
 magrittr    1.5     2014-11-22 CRAN (R 3.4.3) 
 memoise     1.1.0   2017-04-21 CRAN (R 3.4.3) 
 methods   * 3.4.4   2018-04-21 local          
 Rcpp        0.12.17 2018-05-18 cran (@0.12.17)
 rmarkdown   1.9     2018-03-01 CRAN (R 3.4.3) 
 rprojroot   1.3-2   2018-01-03 CRAN (R 3.4.3) 
 stats     * 3.4.4   2018-04-21 local          
 stringi     1.2.2   2018-05-02 CRAN (R 3.4.4) 
 stringr     1.3.1   2018-05-10 CRAN (R 3.4.4) 
 tools       3.4.4   2018-04-21 local          
 utils     * 3.4.4   2018-04-21 local          
 withr       2.1.2   2018-03-15 CRAN (R 3.4.4) 
 xfun        0.1     2018-01-22 CRAN (R 3.4.3) 
 yaml        2.1.19  2018-05-01 cran (@2.1.19) 
 ```

