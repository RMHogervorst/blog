---
title: New Package, Pinboardr
author: Roel M. Hogervorst
date: '2020-05-11'
slug: new-package-pinboardr
categories:
  - R
tags:
  - package
  - bookmarks
  - beginner
  - pinboardr
subtitle: ''
share_img: 'header_image.png'
output:
  html_document:
    keep_md: yes
---

<!-- useful settings for rmarkdown-->



<!-- content  -->

I've created a new package to interact with [pinboard](https://pinboard.in) *not to be confused with pinterest*. I noticed there wasn't a package yet and the API is fairly clear. 
So come and check it out {pinboardr} at <https://github.com/RMHogervorst/pinboardr>

I did see a new package to interact with pocket: [pocketapi](https://github.com/CorrelAid/pocketapi).
Since pocket is also a kind of bookmark manager I thought there was a need for these kinds of
packages. I will leave this package on github for a while, to figure out if I need to
make changes and in a month or so I will push it to CRAN. Everyone who uses pinboard and R is
invited to 'kick the tyres' as they say. Let me know if the docs are clear, if it is usable
and useful for you.

### What is pinboard? 
Pinboard is a bookmark website. In stead of bookmarking on your own computer in the browser you
can use pinboard. The service is very minimalistic and privacy focused. I use it all the time
to put articles on my reading list, to archive tweets and to collect material for my secondary blog
and for this blog.

## Basic functionality
I added a more extensive readme, and all the functions are documented too. But in this
short blogpost I wanted to show some examples.

With {pinboardr} you can see what you and other people used as tags for a page:

```r 
library(pinboardr)
caption <- "package {pinboardr}"
pb_posts_suggest(url="https://blog.rmhogervorst.nl/blog/2020/04/08/scraping-gdpr-fines/")
```

```
      tag popular recommended
1 Twitter   FALSE        TRUE
```

```r 
pb_posts_suggest("http://neverssl.com")
```

```
             tag popular recommended
1            ssl    TRUE        TRUE
2           wifi    TRUE        TRUE
3         public   FALSE        TRUE
4        Airport   FALSE        TRUE
5  captiveportal   FALSE        TRUE
6         coffee   FALSE        TRUE
7        connect   FALSE        TRUE
8     connection   FALSE        TRUE
9           help   FALSE        TRUE
10         IFTTT   FALSE        TRUE
```


Get recent bookmarks with a specific type

```r 
library(tidyverse)
```

```r 
recent <- pb_posts_recent(tags = "r",count=4)
names(recent)
```

```
[1] "href"        "title"       "description" "meta"        "hash"       
[6] "time"        "public"      "toread"      "tags"       
```

```r 
recent %>% select(title, tags)
```

```
                                                                    title
1                            wttr.in/README.md at master · chubin/wttr.in
2                                Automatic Code Cleaning in R with Rclean
3   \U0001f4fb Radio 538 playlist / afspeellijst van donderdag 13-06-2013
4 Dataviz and the 20th Anniversary of R, an Interview With Hadley Wickham
                       tags
1            package_idea r
2                   r tools
3                blogidea r
4 visualisation r interview
```

Find out when you bookmarked things. 
(I think many bookmarks have the same date because I imported and exported from one tool to another)

```r 
dates <- pb_posts_dates()
dates %>% 
  mutate(dates= as.POSIXct(date)) %>% 
  ggplot(aes(dates, count)) +
  geom_col()+
  labs(title="bookmarks per date", caption=caption)
```
{{<figure src="unnamed-chunk-4-1.png" >}}
Can you guess when I was on the other side of the world with very spotty internet?

```r 
dates %>% 
  mutate(dates= as.POSIXct(date)) %>% 
  filter(dates > "2019-08-01") %>% 
  ggplot(aes(dates, count)) +
  geom_col()+
  labs(title="bookmarks per date", subtitle = "zoomed in", caption=caption)
```
{{<figure src="unnamed-chunk-5-1.png" >}}

So, see if you like it and check it out at [github](https://github.com/RMHogervorst/pinboardr)

### Reproducibility
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
 date     2020-05-11                  

─ Packages ───────────────────────────────────────────────────────────────────
 package     * version    date       lib source        
 assertthat    0.2.1      2019-03-21 [1] CRAN (R 3.6.0)
 backports     1.1.5      2019-10-02 [1] CRAN (R 3.6.0)
 broom         0.5.5      2020-02-29 [1] CRAN (R 3.6.0)
 cellranger    1.1.0      2016-07-27 [1] CRAN (R 3.6.0)
 cli           2.0.2      2020-02-28 [1] CRAN (R 3.6.0)
 colorspace    1.4-1      2019-03-18 [1] CRAN (R 3.6.0)
 crayon        1.3.4      2017-09-16 [1] CRAN (R 3.6.0)
 curl          4.3        2019-12-02 [1] CRAN (R 3.6.0)
 DBI           1.1.0      2019-12-15 [1] CRAN (R 3.6.0)
 dbplyr        1.4.2      2019-06-17 [1] CRAN (R 3.6.0)
 digest        0.6.25     2020-02-23 [1] CRAN (R 3.6.0)
 dplyr       * 0.8.5      2020-03-07 [1] CRAN (R 3.6.0)
 ellipsis      0.3.0      2019-09-20 [1] CRAN (R 3.6.0)
 evaluate      0.14       2019-05-28 [1] CRAN (R 3.6.0)
 fansi         0.4.1      2020-01-08 [1] CRAN (R 3.6.0)
 farver        2.0.3      2020-01-16 [1] CRAN (R 3.6.0)
 forcats     * 0.5.0      2020-03-01 [1] CRAN (R 3.6.0)
 fs            1.3.2      2020-03-05 [1] CRAN (R 3.6.0)
 generics      0.0.2      2018-11-29 [1] CRAN (R 3.6.0)
 ggplot2     * 3.3.0      2020-03-05 [1] CRAN (R 3.6.0)
 glue          1.4.0      2020-04-03 [1] CRAN (R 3.6.2)
 gtable        0.3.0      2019-03-25 [1] CRAN (R 3.6.0)
 haven         2.2.0      2019-11-08 [1] CRAN (R 3.6.0)
 hms           0.5.3      2020-01-08 [1] CRAN (R 3.6.0)
 htmltools     0.4.0      2019-10-04 [1] CRAN (R 3.6.0)
 httr          1.4.1      2019-08-05 [1] CRAN (R 3.6.0)
 jsonlite      1.6.1      2020-02-02 [1] CRAN (R 3.6.0)
 knitr         1.28       2020-02-06 [1] CRAN (R 3.6.0)
 labeling      0.3        2014-08-23 [1] CRAN (R 3.6.0)
 lattice       0.20-38    2018-11-04 [1] CRAN (R 3.6.3)
 lifecycle     0.2.0      2020-03-06 [1] CRAN (R 3.6.0)
 lubridate     1.7.4      2018-04-11 [1] CRAN (R 3.6.0)
 magrittr      1.5        2014-11-22 [1] CRAN (R 3.6.0)
 modelr        0.1.6      2020-02-22 [1] CRAN (R 3.6.0)
 munsell       0.5.0      2018-06-12 [1] CRAN (R 3.6.0)
 nlme          3.1-144    2020-02-06 [1] CRAN (R 3.6.3)
 pillar        1.4.4      2020-05-05 [1] CRAN (R 3.6.3)
 pinboardr   * 0.0.0.9000 2020-05-11 [1] local         
 pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 3.6.0)
 purrr       * 0.3.4      2020-04-17 [1] CRAN (R 3.6.2)
 R6            2.4.1      2019-11-12 [1] CRAN (R 3.6.0)
 Rcpp          1.0.4.6    2020-04-09 [1] CRAN (R 3.6.3)
 readr       * 1.3.1      2018-12-21 [1] CRAN (R 3.6.0)
 readxl        1.3.1      2019-03-13 [1] CRAN (R 3.6.0)
 reprex        0.3.0      2019-05-16 [1] CRAN (R 3.6.0)
 rlang         0.4.6      2020-05-02 [1] CRAN (R 3.6.2)
 rmarkdown     2.1        2020-01-20 [1] CRAN (R 3.6.0)
 rstudioapi    0.11       2020-02-07 [1] CRAN (R 3.6.0)
 rvest         0.3.5      2019-11-08 [1] CRAN (R 3.6.0)
 scales        1.1.0      2019-11-18 [1] CRAN (R 3.6.0)
 sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 3.6.0)
 stringi       1.4.6      2020-02-17 [1] CRAN (R 3.6.0)
 stringr     * 1.4.0      2019-02-10 [1] CRAN (R 3.6.0)
 tibble      * 3.0.1      2020-04-20 [1] CRAN (R 3.6.2)
 tidyr       * 1.0.2      2020-01-24 [1] CRAN (R 3.6.0)
 tidyselect    1.0.0      2020-01-27 [1] CRAN (R 3.6.0)
 tidyverse   * 1.3.0      2019-11-21 [1] CRAN (R 3.6.0)
 vctrs         0.2.4      2020-03-10 [1] CRAN (R 3.6.0)
 withr         2.1.2      2018-03-15 [1] CRAN (R 3.6.0)
 xfun          0.13       2020-04-13 [1] CRAN (R 3.6.2)
 xml2          1.2.2      2019-08-09 [1] CRAN (R 3.6.0)
 yaml          2.2.1      2020-02-01 [1] CRAN (R 3.6.0)

[1] /Library/Frameworks/R.framework/Versions/3.6/Resources/library
```

</details>


