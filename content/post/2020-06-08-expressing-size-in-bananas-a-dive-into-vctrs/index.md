---
title: Expressing size in bananas a dive into {vctrs}
author: Roel M. Hogervorst
date: '2020-06-08'
categories:
  - blog
  - R
tags:
  - banana
  - package
  - intermediate
  - units
  - vctrs
  - S3
slug: expressing-size-in-bananas-a-dive-into-vctrs
subtitle: 'Yes I made a stupid package to express lengths in bananas'
output:
  html_document:
    keep_md: yes
---

<!-- useful settings for rmarkdown-->



<!-- content --> 
Recently I've become interested in relative sizes of things. Maybe I'm paying more attention
to my surroundings since I'm locked at home for so long. Maybe my inner child is finally
breaking free. Whatever the reason, I channeled all of that into two packages: 
- [everydaysizes](https://github.com/RMHogervorst/everydaysizes) A rather unfinished collection of dimensions of everyday objects.
- [banana](https://github.com/RMHogervorst/banana) A package that displays dimensions as ... bananas.

I've collected a bunch of sizes and turned them into 'units'. The units package in R can automatically convert units to other units. It's amazing, it can do mph to m/s and many other things. But in this
case I'm using length units: inches, centimeter and meters. 


```r 
library(tidyverse)
```

```
── Attaching packages ─────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
```

```
✓ ggplot2 3.3.0     ✓ purrr   0.3.4
✓ tibble  3.0.1     ✓ dplyr   0.8.5
✓ tidyr   1.0.2     ✓ stringr 1.4.0
✓ readr   1.3.1     ✓ forcats 0.5.0
```

```
── Conflicts ────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
x dplyr::filter() masks stats::filter()
x dplyr::lag()    masks stats::lag()
```

```r 
library(units)
```

```
udunits system database from /Library/Frameworks/R.framework/Versions/3.6/Resources/library/units/share/udunits
```

```r 
# Banana for banana vectors, and everydaysizes for the collection of metrics.
library(banana)  # https://github.com/RMHogervorst/banana
library(everydaysizes) # https://github.com/RMHogervorst/everydaysizes
```

I'm selecting two interesting sizes from the everydaysizes package: The Eiffel Tower (Tour de Eiffel in local language) and a tree I visited in New Zealand: 'the Father of the forest' (or E Matua Ngahere in the local language). 


```r 
how_big <- 
  everydaysizes::things %>% 
  slice(1,7)
how_big %>% select(what, height)
```

```
                                               what    height
1                                      Eiffel Tower 324.0 [m]
2 E Matua Ngahere (giant kauri tree in New Zealand)  29.9 [m]
```

So now we know how high the Eiffel Tower in Paris and the 'Father of the Forest' tree are in meters.

Since this is size is represented in 'units' it is rather trivial to turn them into imperial metrics too:

```r 
how_big %>% 
  mutate(feet = set_units(height, "ft")) %>% 
  select(what, height, feet)
```

```
                                               what    height        feet
1                                      Eiffel Tower 324.0 [m] 1063.0 [ft]
2 E Matua Ngahere (giant kauri tree in New Zealand)  29.9 [m]   98.1 [ft]
```
However, this doesn't really mean anything to me. How about in bananas?

```r 
how_big %>% 
  mutate(feet = set_units(height, "ft")) %>% 
  mutate(bananas = as_banana(height)) %>% 
  select(what, height, feet, bananas)
```

```
                                               what    height        feet
1                                      Eiffel Tower 324.0 [m] 1063.0 [ft]
2 E Matua Ngahere (giant kauri tree in New Zealand)  29.9 [m]   98.1 [ft]
     bananas
1 1822 small
2  168 small
```
Yes I made a stupid package to express things in bananas. Not one size though, it tries to match
it to small or large bananas and it rounds it up to nearest banana. 

What about the height and length of an Alpaca?

```r 
Alpaca <- 
  everyday_items %>% 
  slice(6) %>% 
  select(what, height, width)
Alpaca
```

```
                      what   height    width
1 Alpaca (shoulder height) 0.99 [m] 1.22 [m]
```

```r 
Alpaca_banana <- 
  Alpaca %>% 
  mutate(
    banana_h = as_banana(height),
    banana_w = as_banana(width)
    )
Alpaca_banana
```

```
                      what   height    width banana_h banana_w
1 Alpaca (shoulder height) 0.99 [m] 1.22 [m]  4 large  7 small
```

That is right. An alpaca is approximately 4 large bananas high up to the shoulder and 7 small bananas long. 


### A small dive into banana properties
I'm using *(probably the word here is 'abusing')* the vctrs package to create a new class of s3-vector. In the package I tell work out how transformations from numeric, and units and integers go to bananas and back. I made a mistake somewhere because I can multiply a number with a banana, but not a banana with a numeric. Anyways the {vctrs} package is super fun and a joy to work with! What I did was, I define a different print method for the banana vector. And so inside data.frames and the `str()` function, it uses this print method.

```r 
bananavec <- Alpaca_banana$banana_w[[1]]
class(bananavec)
```

```
[1] "banana"     "vctrs_vctr"
```

```r 
str(bananavec)
```

```
 🍌 [1:1] 7 small
```

But since bananas is a relative metric and always in integers some behavior is a bit ... 'strange':

```r 
bananavec2 <- c(1, 1.1, 1.3, 1.5) * bananavec
bananavec2
```

```
<banana[4]>
[1] 7 small 6 large 7 large 8 large
```

```r 
data.frame(bananavec2, increase = c(1, 1.1, 1.3, 1.5))
```

```
  bananavec2 increase
1    7 small      1.0
2    6 large      1.1
3    7 large      1.3
4    8 large      1.5
```

So we start with 7 small bananas, and an increase of 10% leads to 6 large bananas!

This is because bananavectors are numeric underneath:

```r 
as.numeric(bananavec2)
```

```
[1] 122.0 134.2 158.6 183.0
```

Or actually in centimeters:

```r 
banana::to_units(bananavec2)
```

```
Units: [cm]
[1] 122.0 134.2 158.6 183.0
```

That is all for today. I might spend some time on the inner workings of banana later. 



### State of the machine
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```r 
sessioninfo::session_info()
```

```
─ Session info ───────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 3.6.3 (2020-02-29)
 os       macOS Mojave 10.14.6        
 system   x86_64, darwin15.6.0        
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2020-06-07                  

─ Packages ───────────────────────────────────────────────────────────────────
 package       * version    date       lib source                         
 assertthat      0.2.1      2019-03-21 [1] CRAN (R 3.6.0)                 
 backports       1.1.5      2019-10-02 [1] CRAN (R 3.6.0)                 
 banana        * 0.0.0.9000 2020-06-04 [1] local                          
 broom           0.5.5      2020-02-29 [1] CRAN (R 3.6.0)                 
 cellranger      1.1.0      2016-07-27 [1] CRAN (R 3.6.0)                 
 cli             2.0.2      2020-02-28 [1] CRAN (R 3.6.0)                 
 colorspace      1.4-1      2019-03-18 [1] CRAN (R 3.6.0)                 
 crayon          1.3.4      2017-09-16 [1] CRAN (R 3.6.0)                 
 DBI             1.1.0      2019-12-15 [1] CRAN (R 3.6.0)                 
 dbplyr          1.4.2      2019-06-17 [1] CRAN (R 3.6.0)                 
 digest          0.6.25     2020-02-23 [1] CRAN (R 3.6.0)                 
 dplyr         * 0.8.5      2020-03-07 [1] CRAN (R 3.6.0)                 
 ellipsis        0.3.1      2020-05-15 [1] CRAN (R 3.6.2)                 
 evaluate        0.14       2019-05-28 [1] CRAN (R 3.6.0)                 
 everydaysizes * 0.0.0.9000 2020-06-04 [1] local                          
 fansi           0.4.1      2020-01-08 [1] CRAN (R 3.6.0)                 
 forcats       * 0.5.0      2020-03-01 [1] CRAN (R 3.6.0)                 
 fs              1.3.2      2020-03-05 [1] CRAN (R 3.6.0)                 
 generics        0.0.2      2018-11-29 [1] CRAN (R 3.6.0)                 
 ggplot2       * 3.3.0      2020-03-05 [1] CRAN (R 3.6.0)                 
 glue            1.4.1.9000 2020-05-29 [1] Github (tidyverse/glue@74c714e)
 gtable          0.3.0      2019-03-25 [1] CRAN (R 3.6.0)                 
 haven           2.2.0      2019-11-08 [1] CRAN (R 3.6.0)                 
 hms             0.5.3      2020-01-08 [1] CRAN (R 3.6.0)                 
 htmltools       0.4.0      2019-10-04 [1] CRAN (R 3.6.0)                 
 httr            1.4.1      2019-08-05 [1] CRAN (R 3.6.0)                 
 jsonlite        1.6.1      2020-02-02 [1] CRAN (R 3.6.0)                 
 knitr           1.28       2020-02-06 [1] CRAN (R 3.6.0)                 
 lattice         0.20-38    2018-11-04 [1] CRAN (R 3.6.3)                 
 lifecycle       0.2.0      2020-03-06 [1] CRAN (R 3.6.0)                 
 lubridate       1.7.4      2018-04-11 [1] CRAN (R 3.6.0)                 
 magrittr        1.5        2014-11-22 [1] CRAN (R 3.6.0)                 
 modelr          0.1.6      2020-02-22 [1] CRAN (R 3.6.0)                 
 munsell         0.5.0      2018-06-12 [1] CRAN (R 3.6.0)                 
 nlme            3.1-144    2020-02-06 [1] CRAN (R 3.6.3)                 
 pillar          1.4.4      2020-05-05 [1] CRAN (R 3.6.3)                 
 pkgconfig       2.0.3      2019-09-22 [1] CRAN (R 3.6.0)                 
 purrr         * 0.3.4      2020-04-17 [1] CRAN (R 3.6.2)                 
 R6              2.4.1      2019-11-12 [1] CRAN (R 3.6.0)                 
 Rcpp            1.0.4.6    2020-04-09 [1] CRAN (R 3.6.3)                 
 readr         * 1.3.1      2018-12-21 [1] CRAN (R 3.6.0)                 
 readxl          1.3.1      2019-03-13 [1] CRAN (R 3.6.0)                 
 reprex          0.3.0      2019-05-16 [1] CRAN (R 3.6.0)                 
 rlang           0.4.6      2020-05-02 [1] CRAN (R 3.6.2)                 
 rmarkdown       2.1        2020-01-20 [1] CRAN (R 3.6.0)                 
 rstudioapi      0.11       2020-02-07 [1] CRAN (R 3.6.0)                 
 rvest           0.3.5      2019-11-08 [1] CRAN (R 3.6.0)                 
 scales          1.1.0      2019-11-18 [1] CRAN (R 3.6.0)                 
 sessioninfo     1.1.1      2018-11-05 [1] CRAN (R 3.6.0)                 
 stringi         1.4.6      2020-02-17 [1] CRAN (R 3.6.0)                 
 stringr       * 1.4.0      2019-02-10 [1] CRAN (R 3.6.0)                 
 tibble        * 3.0.1      2020-04-20 [1] CRAN (R 3.6.2)                 
 tidyr         * 1.0.2      2020-01-24 [1] CRAN (R 3.6.0)                 
 tidyselect      1.0.0      2020-01-27 [1] CRAN (R 3.6.0)                 
 tidyverse     * 1.3.0      2019-11-21 [1] CRAN (R 3.6.0)                 
 units         * 0.6-6      2020-03-16 [1] CRAN (R 3.6.0)                 
 vctrs           0.3.0      2020-05-11 [1] CRAN (R 3.6.2)                 
 withr           2.1.2      2018-03-15 [1] CRAN (R 3.6.0)                 
 xfun            0.14       2020-05-20 [1] CRAN (R 3.6.2)                 
 xml2            1.2.2      2019-08-09 [1] CRAN (R 3.6.0)                 
 yaml            2.2.1      2020-02-01 [1] CRAN (R 3.6.0)                 

[1] /Library/Frameworks/R.framework/Versions/3.6/Resources/library
```

</details>


