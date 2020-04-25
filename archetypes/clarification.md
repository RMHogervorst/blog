---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
author: Roel M. Hogervorst
date: {{ .Date }}
# categories are blog / and or R. posts under R will be syndicated by r-bloggers and rweekly
categories: []
# Add all packages you are using as a tag
tags:
subtitle: ''
share_img: 'https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif'
# 'output' is necessary to obtain index.md
# Do not commit index.html
output: 
  html_document:
    keep_md: true
---

<!-- tags  at least intermediate, clarification, explainer and all packages used.  -->
<!-- categories: R and blog. Blog is general, R means rweekly and r-bloggers -->


<!-- useful settings for rmarkdown-->

```{r setup, include=FALSE}
# Options to have images saved in the post folder
# And to disable symbols before output
knitr::opts_chunk$set(fig.path = "", comment = "")

# knitr hook to make images output use Hugo options
knitr::knit_hooks$set(
  plot = function(x, options) {
    hugoopts <- options$hugoopts
    paste0(
      "{{<figure src=",
      '"', x, '" ',
      if (!is.null(hugoopts)) {
        glue::glue_collapse(
          glue::glue('{names(hugoopts)}="{hugoopts}"'),
          sep = " "
        )
      },
      ">}}\n"
    )
  }
)

# knitr hook to use Hugo highlighting options
knitr::knit_hooks$set(
  source = function(x, options) {
  hlopts <- options$hlopts
    paste0(
      "```r ",
      if (!is.null(hlopts)) {
      paste0("{",
        glue::glue_collapse(
          glue::glue('{names(hlopts)}={hlopts}'),
          sep = ","
        ), "}"
        )
      },
      "\n", glue::glue_collapse(x, sep = "\n"), "\n```\n"
    )
  }
)
```
<!-- content -->

<!-- 
After reading this post, new r-users from another language will realize how they can do the thing they already know how to do in another language in R, so they will now use R for it

I believe readers of posts like these are intermediates (their mental model of the language and package is more in line with how other languages work). 
intermediate (regular user, have a mental model, but it is not very sophisticated) 
I wrote for intermediates with the following tags:
*tools, building packages, testing, slides in markdown, apply, package, advanced ggplot2, environments, animation, test, workflow, reproducability, version control, git, tidyeval*

explanation of how to do something in this language when you come from a different one
After reading this post, you will be able to do this thing you did in this language, but now in R

Frequently go back (bookmark) to this post as a reference to find out how you do a thing, and eventually use R alone because it is easier

Make a great image to add to the share link on top.


-->




### References
- Find more explainers by me in [this overview page](https://blog.rmhogervorst.nl//tags/clarification/)

### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```{r}
sessioninfo::session_info()
```

</details>