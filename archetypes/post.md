---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
author: Roel M. Hogervorst
date: {{ .Date }}
categories:
  - blog
subtitle: ""
image: "{{time.Format "2006/01/13" .Date }}/{{ replace .TranslationBaseName "-" " " | title }}/image.jpg"
share_img: 'https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif'
difficulty:
  - advanced
  - beginner
  - intermediate
post-type:
  - post|lessons-learned|link|thoughts|tutorial|walkthrough|analysis
---

<!-- tags choose:
beginner, intermediate or advanced
*beginner:*
*for, loops, brackets, vectors, data structures, subsetting, functions, qplot, ggplot2, dplyr, spps-to-r, haven, tidyr, tidyverse*

*intermediate:* 
*tools, building packages, testing, slides in markdown, apply, package, advanced ggplot2, environments, animation, test, workflow, reproducability, version control, git, tidyeval*

*advanced:*
*S4 classes, extensions , shiny, Object Oriented Programming, Non standard Evaluation, code performance, profiling, Rcpp, optimize-your-code*
-->
<!-- categories: R and blog. Blog is general, R means rweekly and r-bloggers -->

<!-- share img is either a complete url or build on top of the base url (https://blog.rmhogervorst.nl) so do not use the same relative image link. But make it more complete post/slug/image.png -->


<!-- content  -->
<!-- 

{{< columns >}}
This is column 1.
{{< column >}}
This is column 2.
{{< endcolumn >}}

-->




### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```{r}
sessioninfo::session_info()
```

</details>


