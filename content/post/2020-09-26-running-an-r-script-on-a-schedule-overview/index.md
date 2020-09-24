---
title: 'Running an R Script on a Schedule: Overview'
author: Roel M. Hogervorst
date: '2020-09-26'
slug: running-an-r-script-on-a-schedule-overview
categories:
  - R
tags:
  - scheduling
  - rscript
  - intermediate
  - renv
subtitle: ''
share_img: 'img/rinprod/horloge_klein2.png'
output:
  html_document:
    keep_md: yes
---


<!-- useful settings for rmarkdown-->



<!-- content  -->
There are lots of rstats tutorials about creating beautiful plots, setting up shiny applications and even a few on setting up plumber APIs (but we could use more). However a lot of work consists of running a script without any interaction. 

This is an overview page for the tutorials I've created so far. This overview is for you if you want to know how to run your batch script (do one thing without supervision) automatically.

![](server.jpg)


This is a blogpost I will update, and I also created an overview page with many ways you can run your Rscript on a schedule. Complete with considerations like: can my coworker continue working on this if I suddenly leave the company, questions about security, costs and ease of setup. 
Find that [massive doc here](https://github.com/RMHogervorst/scheduling_r_scripts), and please contribute if you'd like.

I've written about [scheduling a script](https://blog.rmhogervorst.nl/tags/scheduling/) on:

- [heroku](https://blog.rmhogervorst.nl/blog/2020/09/21/running-an-r-script-on-a-schedule-heroku/)
- [github](https://blog.rmhogervorst.nl/blog/2020/09/24/running-an-r-script-on-a-schedule-gh-actions/)
- [gitlab](https://blog.rmhogervorst.nl/blog/2020/09/24/running-an-r-script-on-a-schedule-gitlab/)

Then we move over to docker containers and using registries:

-  [docker containers on gitlab](https://blog.rmhogervorst.nl/blog/2020/09/25/running-an-r-script-on-a-schedule-docker-containers)


In the future:

- docker containers on github

- docker containers on GCP (google cloud project)

- docker containers on AWS (amazon)

- docker containers on Azure

We can also talk about setting up automatic scripts on your 
computer, or remote servers.



# links

- I'm keeping a living document of scheduling options on [this github repo](https://github.com/RMHogervorst/scheduling_r_scripts)
- I tweeted an [enormous thread with options here](https://mobile.twitter.com/RoelMHogervorst/status/1308787069678952448)
- Find all posts about scheduling an R script [here](https://blog.rmhogervorst.nl/tags/scheduling/)


### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```r 
sessioninfo::session_info()
```

```
─ Session info ───────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.2 (2020-06-22)
 os       macOS Catalina 10.15.6      
 system   x86_64, darwin17.0          
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2020-09-24                  

─ Packages ───────────────────────────────────────────────────────────────────
 package     * version date       lib source        
 assertthat    0.2.1   2019-03-21 [1] CRAN (R 4.0.0)
 cli           2.0.2   2020-02-28 [1] CRAN (R 4.0.0)
 crayon        1.3.4   2017-09-16 [1] CRAN (R 4.0.0)
 digest        0.6.25  2020-02-23 [1] CRAN (R 4.0.0)
 evaluate      0.14    2019-05-28 [1] CRAN (R 4.0.0)
 fansi         0.4.1   2020-01-08 [1] CRAN (R 4.0.0)
 glue          1.4.1   2020-05-13 [1] CRAN (R 4.0.1)
 htmltools     0.5.0   2020-06-16 [1] CRAN (R 4.0.1)
 knitr         1.29    2020-06-23 [1] CRAN (R 4.0.1)
 magrittr      1.5     2014-11-22 [1] CRAN (R 4.0.0)
 rlang         0.4.7   2020-07-09 [1] CRAN (R 4.0.2)
 rmarkdown     2.3     2020-06-18 [1] CRAN (R 4.0.1)
 sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.0.1)
 stringi       1.4.6   2020-02-17 [1] CRAN (R 4.0.0)
 stringr       1.4.0   2019-02-10 [1] CRAN (R 4.0.0)
 withr         2.2.0   2020-04-20 [1] CRAN (R 4.0.2)
 xfun          0.15    2020-06-21 [1] CRAN (R 4.0.2)
 yaml          2.2.1   2020-02-01 [1] CRAN (R 4.0.0)

[1] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

</details>


