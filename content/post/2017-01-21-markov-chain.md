---
title: Generate text using Markov Chains (sort of)
author: Roel M. Hogervorst
difficulty:
  - beginner
post-type:
  - walkthrough
description: "Building a bot that sort of talks like TNG characters"
date: '2017-01-21'
categories:
  - blog
  - R
tags:
  - Markov
  - TNG
  - dplyr
  - tidytext
  - bot
slug: markov-chain
---

Inspired by the hilarious podcast [The Greatest Generation](gagh.biz "A podcast by two people who are a little embarrassed to have a podcast about Star Trek the Next Generation"), I have worked again with all the lines from all the episode scripts of TNG. 
Today I will make a clunky bot (although it does nothing and is absolutely not useful) that talks like Captain Picard.
I actually wanted to use a Markov Chain to generate text. A Markov Chain has a specific property. It doesn't care what happened before, it only looks at probabilities from the current state to a next state. 

### Markov Chains

An example is a board game based on dice throws. Every time I throw the die there are equal opportunities to go from my current side to any other side. In this case every probability is equal, but when the die is loaded probabilities would change.

In the current example I'm using all the phrases I extracted from the series TNG [1](https://github.com/rtrek). And then well use words that follow each other choosing "randomly" but weighted by occurrence.

But first cleaning
==================

I'm using the packages dplyr, stringr, tidytext and tidyr.
If you'd like to follow along download the [dataset](https://github.com/RTrek/TNG/raw/master/data/TNG.rda "this link goes to the dataset ~26 mb, if you don't trust that, go to that repo and download the csv file from data-raw") and load it in R with load("path to file")

The dataset itself is rather large `dim(TNG) #110176     17` with 11 thousand rows and 17 variables. However we will only use the variables `type`, `who` and `text`. `Type` contains either "description" or "speech". We only need speech. Because I was a novice and because in general I'm not very tidy [2] (Which is rather ironic since I like to adore to Tidy principles...) this dataset is rather dirty. I copied and did not sanitize the who part. This means that if you filter on "Riker", you will not get everything he said. The script has weird things like: "Riker's com voice", "Riker's voice" and several variants of "V.O." (means voice over).

Cleaning the who column
-----------------------

We have to clean out the who column, filter only the rows that contain speech. Perhaps we also want to select only rows for certain characters. And finally we want to cut up the text into bigrams or trigrams. Thanks to an excellent [book](http://tidytextmining.com/ "free to read on the internet") by Julia Silge and David Robinson this was surprisingly easy to do. I cannot recommend their package [tidytext](https://cran.r-project.org/package=tidytext) enough, truly awesome!

You could do the following steps all in one pipe, but for clarity sake, and your sanity, we will take smaller steps.

``` r
speech_TNG <- TNG %>%
        filter(type == "speech") %>%    # select only speech parts
        mutate(who = str_replace(who, "'S COM VOICE", "") %>% 
                       str_replace( "\\(.{1,}\\)", "") %>%
                       str_replace( "\".{1,}\"", "") %>%
                       str_replace( "YOUNG", "") %>%
                       str_replace( "'S VOICE", "") %>%
                       str_trim())
```

This looks crazy, but don't despair:

-   assign to speech\_TNG the result of:
-   take TNG `THEN`
-   return only the rows where type is "speech" `THEN`
-   mutate the who column by
    -   replacing from the who column "'S COM VOICE" with nothing `THEN`
    -   replacing a "(" followed by at least 1 any character followed by a ")" with nothing `THEN`
    -   replacing quotation marks (" ") with any characters in between with nothing `THEN`
    -   replacing YOUNG with nothing `THEN`
    -   replacing 's voice with nothing `THEN`
    -   trimming all whitespace at start and end

How did I know how to build this enormous pipe? I took a sample of the who column and tried stuff untill it suited my needs \[3\].

\[3\]: for example `sample <- TNG %>% filter(type == "speech") %>% select(who) %>% sample_n(20) %>% .$who`

Extracting bi- and trigrams per character
=========================================

And now we can create seperate datasets for every character.

``` r
bigrams_data <- speech_TNG %>%
        filter(who == "DATA") %>%
        unnest_tokens(bigram, text, token = "ngrams",to_lower = TRUE, n= 2) %>%
        separate(bigram, c("word1", "word2"), sep = " ") %>%
        count(word1, word2, sort = TRUE)
```

We use the `unnest_tokens` command from the tidytext package. This command will take your cell with text and extract either sentences, words, ngrams or paragraphs. It also converts everything to lowercase and delete any punctuation. The resulting variable I now call "bigram". Then I take that variable "bigram" and split it up into two variables calling them "word1" and "word2". Finally I count how many times the combinations occur.

For Picard, the bigrams would be:

``` r
bigrams_picard <- speech_TNG %>%
        filter(who == "PICARD") %>%
        unnest_tokens(bigram, text, token = "ngrams",to_lower = TRUE, n= 2) %>%
        separate(bigram, c("word1", "word2"), sep = " ") %>%
        count(word1, word2, sort = TRUE)
```

And his trigrams would be

``` r
trigrams_picard <- speech_TNG %>%
        filter(who == "PICARD") %>%
        unnest_tokens(trigram, text, token = "ngrams",to_lower = TRUE, n= 3) %>%
        separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
        count(word1, word2,word3, sort = TRUE)
```

Creating a markov chain (sort of)
=================================

My endproduct takes two words and tries to find a third word. Then it takes the final two words and tries to find another word untill the sentance has a length that I specify at the start.

What I actually created is a trigram dataframe, and a function that searches that frame. The function takes two words and returns all the rows where the first word matches the first column and the second word matches the second column.

Furthermore I made a sentence creator, a function where you supply the first two words and the length of the sentence. That function keeps using the last words in the sentence until the correct length is achieved. With the fallback method of using bigrams when the trigrams don't work anymore it could still fail, but not so often.

### Word generator

``` r
return_third_word <- function( woord1, woord2){
        woord <- trigrams_picard %>%
                filter_(~word1 == woord1, ~word2 == woord2) %>%
                sample_n(1, weight = n) %>%
                .[["word3"]]
        woord
}
```

However this function sometimes returns an empty row. So I baked in a backup for when it can't find the word combination.

``` r
return_third_word <- function( woord1, woord2){
        woord <- trigrams_picard %>%
                filter_(~word1 == woord1, ~word2 == woord2) %>%
                sample_n(1, weight = n) %>%
                .[["word3"]]
        if(length(woord) == 0){
                bleh <- filter_(bigrams_picard, ~word1 == woord2) %>%
                        sample_n(1, weight = n)
                warning("no word found, adding ", bleh, "to", woord1 , woord2)
                woord <- bleh
        }
        woord
}
```

-   From trigrams\_picard,
-   return the rows where word 1 matches woord1, and word2 matches woord2.
-   Of those rows \* return a single random row, where the randomness is weighted by occurrence. \* Return the single word.

I also used a bit of [non-standard evalation (NSE)](https://blog.rmhogervorst.nl/blog/2016/06/13/nse_standard_evaluation_dplyr/ "link to NSE article") just for fun.

### Sentence generator

``` r
generate_sentence <- function(word1, word2, sentencelength =5, debug =FALSE){
        #input validation
        if(sentencelength <3)stop("I need more to work with")
        sentencelength <- sentencelength -2
        # starting
        sentence <- c(word1, word2)
        woord1 <- word1
        woord2 <- word2
        for(i in seq_len(sentencelength)){
                if(debug == TRUE)print(i)
                word <- return_third_word( woord1, woord2)
                sentence <- c(sentence, word)
                woord1 <- woord2
                woord2 <- word
        }
        output <-paste(sentence, collapse = " ")
        output
}
```

-   Check that there are more then 2 lenght.
-   Loop a certain times
    -   in that loop use woord1 and woord 2 as input
    -   create a new word
    -   add that word to sentence
    -   change the values of woord1 and woord2
-   output the sentance with all the words in one line.

For example this created for me: `generate_sentence("I", "am", 9)`

    "i am loathe to do with you because they"
    "i am not the case however wesley is alive"
    "i am aware of the tachyon pulse it might be able to determine how to"
    # and with the enterprise and length 9
    "the enterprise we use the cloak to escape do"
     "the enterprise we have had"
     "the enterprise for a thing"

-   it's incredibly slow and inefficient, but hey, it's a toy project!
-   Also it failed on me multiple times on 15 length

Right it makes no sense whatsoever. Thanks for following along!

Do you have suggestions, improvements, found errors? open an issue or email me. 
