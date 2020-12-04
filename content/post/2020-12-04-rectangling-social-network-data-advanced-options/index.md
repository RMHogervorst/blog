---
title: Rectangling (Social) Network Data, Advanced Options
author: Roel M. Hogervorst
date: '2020-12-04'
categories:
  - blog
  - R
tags:
  - data:fb-pages-food
  - igraph
  - intermediate
  - networkdata
  - regex
  - tidygraph
subtitle: Link features, for link prediction
slug: rectangling-social-network-data-advanced-options
share_img: 'https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif'
output:
  html_document:
    keep_md: yes
---

<!-- useful settings for rmarkdown-->


<!-- content -->

This walkthrough is a follow up on [my previous post about rectangling network data](https://blog.rmhogervorst.nl/blog/2020/11/25/rectangling-social-network-data/)
As a recap: we want to predict links between nodes in a graph by using features
of the vertices.  In the previous post I showed how to load flat files into a graph structure with 
[{tidygraph}](https://CRAN.R-project.org/package=tidygraph), 
how to select positive and negative examples, and I extracted some node features.

Because we want to predict if a link between two nodes is probable, we can
use the node features, but there is also some other information about the 
edges in the graph
that we cannot get out with node features only procedure.
In this small walkthrough I will show you how I approached getting common neighbors between two nodes.
I'm going to work with [{igraph}](https://CRAN.R-project.org/package=igraph), 
lists, indices and regular expression. 


```r 
library(dplyr)
library(tidygraph)
```


## Create features for every edge
My intuition is this: If Boris and Chandra don't know each other, but they have a few friends in 
common, it seems more likely that they will form a connection in time. If Boris and James have no friends in common, there will be less change of a connection.
There is some information in how many people we have
in common, and maybe how many friends we have in common at a further distance.

![Sheep, are close friends](connections.gif)
 
 

Retrieve the data from the previous post:

```r 
enriched_trainingset <- readr::read_rds(file = "data/enriched_trainingset.Rds")
emptier_graph <- readr::read_rds("data/emptier_graph.Rds")
```

The current dataset contains degree, betweenness, pagerank, eigen centrality,
closeness, bridge score and coreness for both vertices. 

```r 
names(enriched_trainingset)
```

```
 [1] "from"           "to"             "target"         "degree"        
 [5] "betweenness"    "pg_rank"        "eigen"          "closeness"     
 [9] "br_score"       "coreness"       "degree_to"      "betweenness_to"
[13] "pg_rank_to"     "eigen_to"       "closeness_to"   "br_score_to"   
[17] "coreness_to"   
```




### Dealing with the differences between igraph and tidygraph
_I believe these actions are also possible with tidygraph, but I haven't found out how yet. If you have examples, I really love to see them!_
Maybe I should have structured the data differently but the indices of the 
nodes in igraph are not the ids in tidygraph. So I have to work around that
by using the names. 

## Regular expressions
*if you are familiar with regex [=>>skip to the code](#retrievingIds)*
Some people are scared of regular expressions, and I get that they are not
everone's cup of tea. There is even a famous quote:

> Some people, when confronted with a problem, think "I know, I'll use regular expressions." 
Now they have two problems. -- by  Jamie Zawinski, see notes for more info

I learned about regular expressions in one of the [coursera courses by the Johns Hopkins University at Coursera](https://www.coursera.org/specializations/jhu-data-science). And I used it a lot to extract phrases from tv-scripts in my star trek projects. 

But although regular expressions CAN look like gibberish, they are super powerful
and you can get a lot of things done with them.  I hope this doesn't scare you. My recommendation is to always create 
test examples and verify your script does what it needs to do, also it is way
easier to chain a number of small regular expressions together to get what you want" select larger pieces of text`captain crunch and his 4 friends` and do a new selection on top of that `4 friends` => `4`.


I'll explain all the parts I've used for you.

I'm going to use a regular expression to extract the number between `(` and `)`
in the text. 
So I want to go from  `"タコベル ジャパン　Taco Bell Japan (116)"` 
to the number `116`.

This is the command: `gsub(pattern=".+\\(([0-9]+)\\)$",replacement="\\1",x=.)`
I'm using this regex to search for what I want: `".+\\(([0-9]+)\\)$"` 
and I'm using `"\\1"` to replace the result with "capture group 1", the last 
part `x=.` is a consequence of me chaining things together with a pipe and 
you should read it as: `names(nodes_igraph)`.
So take the names of all of the vertices, search for the pattern with a `(`and `)`, and replace the entire text with only the number you found.


Let's break it down:

* first the capture groups: you can use `()` to mark a piece of regex and call it back later with `\\number`
* `.+` the `.` means: any character, and the `+` means: 1 or more times (this matches to everything)
* `\\(` means: a literal parentheses or round brackets  '(', but because parentheses have a special meaning, we have to 'escape' the character with two backslashes to tell the regular expression that we want parentheses.
* `([0-9]+)` means: in capture group 1: a number (between 0-9, in other words, all numbers) one or more times.
* `\\)` means: a literal parentheses or round brackets ')' but because they have a special meaning, we have to 'escape' the character with two backslashes.
* `$` means: end of line

So I think you could explain the regex as: take any character all the way until we find a literal opening parenthesis '(' followed by numbers only and a closing parenthesis ')' followed by the end of the line.
So this matches things like: "Chef Grace Ramirez (412)", "도미노피자(Dominostory) (125)"
and will return only the numbers between the '()'.
_It will not match `blabla (23) `, nor `blabla ()`_


<a id="retrievingIds"></a>

```r 
nodes_igraph <- igraph::V(emptier_graph)
ids <- names(nodes_igraph) %>%   
  gsub(".+\\(([0-9]+)\\)$","\\1",x=.) %>% 
  as.numeric()
```


## Finding the neighbors of every node

For every node, find the nodes connected to it, the neighborhood function returns a list with for every node the directly connected nodes.

```r 
# for every node find the nodes at distance 1.
neighbors <- igraph::neighborhood(emptier_graph,order = 1)
# for every node find the nodes at distance 2
neighbors_dist2 <- igraph::neighborhood(emptier_graph,order = 2,mindist = 1)
# Example of one
neighbors_dist2[[11]]
```

```
+ 4/620 vertices, named, from 0a11922:
[1] Spago Las Vegas (136)         Domino's Guatemala (264)     
[3] Chope (391)                   Chef Michelle Bernstein (158)
```


I now create a set of functions:

* a function to look up the node-index in the igraph objects. 
* a function that takes two nodes, looks up all the direct neighbors of both nodes and counts the ones in common.
* another like that one, but on distance 2
* a loop through all edges in the trainingset ( the positive and negative examples) to apply the two functions and add them to the dataset.

```r 
# convenience function to translate the id in tidygraph into the id in igraph. 
lookup_node_id <- function(empty_graph_id){
  which(ids == empty_graph_id)
}

n_common_neighbors <- function(from, to){
  stopifnot(from != to) # I know myself, and protect against me
  from_id <- lookup_node_id(as.integer(from))
  from_nb <- names(neighbors[[from_id]]) # name of this node
  from_itself <- names(nodes_igraph[[from_id]])
  from_nbs <- setdiff(from_nb, from_itself)
  to_id <- lookup_node_id(as.integer(to))
  to_nb <- names(neighbors[[to_id]])
  to_itself <- names(nodes_igraph[[to_id]])
  to_nbs <- base::setdiff(to_nb, to_itself)
  ### return only the neighbor nodes found in both sides
  result <- base::intersect(from_nbs, to_nbs)
    if(is.null(result)){
      0
    }else{
      length(result)    
    }
}
n2_common_neighbors <- function(from, to){
  stopifnot(from != to) # I know myself, and protect against me
  from_id <- lookup_node_id(as.integer(from))
  from_nb <- names(neighbors_dist2[[from_id]])
  from_itself <- names(nodes_igraph[[from_id]])
  from_nbs <- setdiff(from_nb, from_itself)
  to_id <- lookup_node_id(as.integer(to))
  to_nb <- names(neighbors_dist2[[to_id]])
  to_itself <- names(nodes_igraph[[to_id]])
  to_nbs <- base::setdiff(to_nb, to_itself)
  result <- base::intersect(from_nbs, to_nbs)
  if(is.null(result)){
    0
  }else{
    length(result)    
  }
}
# superslow, because it is not vectorized.
get_common_neighbors <- function(dataframe){
  n1 <- rep(NA_integer_,nrow(dataframe))
  n2 <- rep(NA_integer_,nrow(dataframe))
  for (i in 1:nrow(dataframe)) {
    n1[[i]] <- n_common_neighbors(
      dataframe$from[[i]], dataframe$to[[i]]
      )
    n2[[i]] <- n2_common_neighbors(
      dataframe$from[[i]], dataframe$to[[i]]
      )
}
  dataframe$commonneighbors_1 = n1
  dataframe$commonneighbors_2 = n2
  dataframe
}
```

Now lets execute the functions:

Enrich the trainingset with the number of neighbors in
common between two nodes and calculate how many nodes per edge are unique.

```r 
enriched_trainingset <- 
  enriched_trainingset %>% 
  get_common_neighbors()  %>% 
  mutate(unique_neighbors = degree + degree_to - commonneighbors_1)
#readr::write_rds(enriched_trainingset, file="data/enriched_trainingset2.Rds")
```


We can see that there is a difference in neighbors and unique neighbors between
the positive and negative examples. So that is useful for ML later on!

```r 
enriched_trainingset %>% 
  group_by(target) %>% 
  summarise(
    avg_neighbors = mean(commonneighbors_1), 
    avg_unique_nb = mean(unique_neighbors)
    )
```

```
`summarise()` ungrouping output (override with `.groups` argument)
```

```
# A tibble: 2 x 3
  target avg_neighbors avg_unique_nb
   <dbl>         <dbl>         <dbl>
1      0        0.108           4.89
2      1        0.0156          4.18
```




### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```r 
sessioninfo::session_info()
```

```
─ Session info ─────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.2 (2020-06-22)
 os       macOS Catalina 10.15.7      
 system   x86_64, darwin17.0          
 ui       RStudio                     
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2020-12-04                  

─ Packages ─────────────────────────────────────────────────────────────────
 package     * version date       lib source        
 assertthat    0.2.1   2019-03-21 [1] CRAN (R 4.0.2)
 blogdown      0.21    2020-10-11 [1] CRAN (R 4.0.2)
 bookdown      0.21    2020-10-13 [1] CRAN (R 4.0.2)
 cli           2.2.0   2020-11-20 [1] CRAN (R 4.0.2)
 crayon        1.3.4   2017-09-16 [1] CRAN (R 4.0.2)
 digest        0.6.27  2020-10-24 [1] CRAN (R 4.0.2)
 dplyr       * 1.0.2   2020-08-18 [1] CRAN (R 4.0.2)
 ellipsis      0.3.1   2020-05-15 [1] CRAN (R 4.0.2)
 evaluate      0.14    2019-05-28 [1] CRAN (R 4.0.1)
 fansi         0.4.1   2020-01-08 [1] CRAN (R 4.0.2)
 fastmap       1.0.1   2019-10-08 [1] CRAN (R 4.0.2)
 generics      0.1.0   2020-10-31 [1] CRAN (R 4.0.2)
 glue          1.4.2   2020-08-27 [1] CRAN (R 4.0.2)
 hms           0.5.3   2020-01-08 [1] CRAN (R 4.0.2)
 htmltools     0.5.0   2020-06-16 [1] CRAN (R 4.0.2)
 httpuv        1.5.4   2020-06-06 [1] CRAN (R 4.0.2)
 igraph        1.2.6   2020-10-06 [1] CRAN (R 4.0.2)
 jsonlite      1.7.1   2020-09-07 [1] CRAN (R 4.0.2)
 knitr         1.30    2020-09-22 [1] CRAN (R 4.0.2)
 later         1.1.0.1 2020-06-05 [1] CRAN (R 4.0.2)
 lifecycle     0.2.0   2020-03-06 [1] CRAN (R 4.0.2)
 magrittr      2.0.1   2020-11-17 [1] CRAN (R 4.0.2)
 mime          0.9     2020-02-04 [1] CRAN (R 4.0.2)
 miniUI        0.1.1.1 2018-05-18 [1] CRAN (R 4.0.2)
 pillar        1.4.7   2020-11-20 [1] CRAN (R 4.0.2)
 pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.0.2)
 processx      3.4.4   2020-09-03 [1] CRAN (R 4.0.2)
 promises      1.1.1   2020-06-09 [1] CRAN (R 4.0.2)
 ps            1.4.0   2020-10-07 [1] CRAN (R 4.0.2)
 purrr         0.3.4   2020-04-17 [1] CRAN (R 4.0.2)
 R6            2.5.0   2020-10-28 [1] CRAN (R 4.0.2)
 Rcpp          1.0.5   2020-07-06 [1] CRAN (R 4.0.2)
 readr         1.4.0   2020-10-05 [1] CRAN (R 4.0.2)
 rlang         0.4.9   2020-11-26 [1] CRAN (R 4.0.2)
 rmarkdown     2.5     2020-10-21 [1] CRAN (R 4.0.2)
 rstudioapi    0.13    2020-11-12 [1] CRAN (R 4.0.2)
 servr         0.20    2020-10-19 [1] CRAN (R 4.0.2)
 sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.0.2)
 shiny       * 1.5.0   2020-06-23 [1] CRAN (R 4.0.2)
 stringi       1.5.3   2020-09-09 [1] CRAN (R 4.0.2)
 stringr       1.4.0   2019-02-10 [1] CRAN (R 4.0.2)
 tibble        3.0.4   2020-10-12 [1] CRAN (R 4.0.2)
 tidygraph   * 1.2.0   2020-05-12 [1] CRAN (R 4.0.2)
 tidyr         1.1.2   2020-08-27 [1] CRAN (R 4.0.2)
 tidyselect    1.1.0   2020-05-11 [1] CRAN (R 4.0.2)
 utf8          1.1.4   2018-05-24 [1] CRAN (R 4.0.2)
 vctrs         0.3.5   2020-11-17 [1] CRAN (R 4.0.2)
 withr         2.3.0   2020-09-22 [1] CRAN (R 4.0.2)
 xfun          0.19    2020-10-30 [1] CRAN (R 4.0.2)
 xtable        1.8-4   2019-04-21 [1] CRAN (R 4.0.2)
 yaml          2.2.1   2020-02-01 [1] CRAN (R 4.0.2)

[1] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

</details>

### Notes about Regular Expressions

- it seems the quote about regular expressions has a long history and someone did a deep dive into it [here](http://regex.info/blog/2006-09-15/247)
- There is some great regex advice by [by Jeff Atwood (@codinghorror) in this post](https://blog.codinghorror.com/regular-expressions-now-you-have-two-problems/)
- see also `?base::regexp`

### References
- Find more posts by me on [intermediate level](https://blog.rmhogervorst.nl/tags/intermediate/)
- Find a slightly different Rmarkdown only version on my [github](https://github.com/RMHogervorst/link_prediction)
- This post was inspired by a nice python post about networks from [analyticsvidhya.com here](https://www.analyticsvidhya.com/blog/2020/01/link-prediction-how-to-predict-your-future-connections-on-facebook/), that post used the same data and positive and negative examples but threw a deeplearning method against it immedately..
