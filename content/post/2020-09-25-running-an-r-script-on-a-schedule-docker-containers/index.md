---
title: 'Running an R Script on a Schedule: Docker Containers on gitlab'
author: Roel M. Hogervorst
date: '2020-09-25'
slug: running-an-r-script-on-a-schedule-docker-containers
categories:
  - R
tags:
  - docker
  - rscript
  - glue
  - ggplot2
  - rtweet
subtitle: 'img/rinprod/horloge_klein.png'
share_img: 
output:
  html_document:
    keep_md: yes
---

<!-- useful settings for rmarkdown-->


<!-- content -->
In this tutorial/howto I show you how to run a docker container on a schedule on gitlab. 

Docker containers are awesome because, once made, they run everywhere! It does not matter what type of computer^[Though I believe there is a problem with ARM based vs other CPU's]. you have. Once I build a container you can run my container on a linux box, windows machine or mac. This is also why people love containers for production, you can finally truly pick up a container from development and hand it over to production. 

Thanks to the massive work by [the rocker team](https://github.com/rocker-org/rocker)
we have containers ready that 'just work' with R, there are
even containers with Rstudio installed! 

![](victoire-joncheray-XsP7GCLMWjM-unsplash.jpg)

## My docker file
I'm using the versioned container `rocker/r-ver` set to
the latest R version as of now `4.0.2`. I could set it to
`latest` but that would mean the container could just break when
those containers are refreshed. Keeping this fixed version 
saves us a lot of headache later on. 

For building of packages though, it is super useful to always test against the latest versions!

For how to set up a docker file I refer you to the excellent tutorials ['An introduction to Docker for R users'](https://colinfay.me/docker-r-reproducibility/) by Colin Fay, and the [larger tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) by ROpensci. 

My [docker file](https://github.com/RMHogervorst/invertedushape/blob/main/Dockerfile) has 3 steps

- 1. take the basic container and update it

```
FROM rocker/r-ver:4.0.2

# before step (in gitlab)
# - update, and set for maximum cpu use
# - make a renv folder and install renv
RUN apt-get update
RUN echo "options(Ncpus = $(nproc --all))" >> /usr/local/lib/R/etc/Rprofile.site
```
- 2. setup renv

```
RUN mkdir -p ~/.local/share/renv
RUN R -e 'install.packages("renv")'
```

- 3. user settings: install the systems libraries, copy files to the container and install all the necessary packages from the lockfile

```
# user settings
# - install the systems libraries
# - copy script and lock file
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev libssl-dev libxt6
COPY run_job.R run_job.R
COPY renv.lock renv.lock
# I found that renv::restore does not use the super fast
#   rstudio package manager, and so by pre instaling rtweet and ggplot2
#   and all their dependencies we get way faster building speed
RUN R -e 'install.packages(c("ggplot2","rtweet"))'
RUN R -e 'renv::restore()'
# on running of the container this is called:
CMD Rscript run_job.R
```

Build the container with `docker build -t <name_for_container> .`

Test it out using `docker run --env-file .Renviron <name_for_container>`

# Using gitlab 
gitlab has its own docker registry where you can push to.
see the [gitlab docs](https://gitlab.com/help/user/packages/container_registry/index) for more info.

You have to set up some authentification with docker first,
but after that you can do a docker build and push it to a registry on gitlab. This is super useful for many things. We could build a container with everything we want already installed and use that to test our new code! 

But we can take it even one step further. We can make gitlab create the container, save it and run it!

The [`.gitlab-ci.yml` file](https://gitlab.com/rmhogervorst/dockerized_script/-/blob/main/.gitlab-ci.yml) is quite clean and was super easy 
to modify from the [examples given here](https://gitlab.com/help/user/packages/container_registry/index#container-registry-examples-with-gitlab-cicd). Gitlab has amazing documentation!

The configuration has 2 stages: build and test.

- **Build** makes the container and pushes it to the local registry
- **Test** pulls the container from the registry and runs the container

It is waaay faster than my previous approach.
A nice effect of having two stages in this file is that if the later stage fails you can rerun that stage without rerunning the first part.

You can schedule it again like [in this gitlab post](http://localhost:1313/blog/2020/09/24/running-an-r-script-on-a-schedule-gitlab/) go to CI/CD - schedules and make a schedule


It is also possible to push docker containers to github, GCP or other cloud providers. Some of which I will explore in the future. 

That is all for today!


### References
- Find more tutorials by me in [this tutorial overview page](https://blog.rmhogervorst.nl//tags/tutorial/)
- Find all posts about scheduling an R script [here](https://blog.rmhogervorst.nl/tags/scheduling/)
- gitlab [container registry docs](https://gitlab.com/help/user/packages/container_registry/index)
- <span>Photo by <a href="https://unsplash.com/@victoire_jonch?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Victoire Joncheray</a> on <a href="https://unsplash.com/s/photos/container?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>

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
