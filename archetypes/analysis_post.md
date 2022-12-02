---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
author: Roel M. Hogervorst
date: {{ .Date }}
categories:
  - blog
subtitle: ""
tags: []
image:
share_img:'https://media1.tenor.com/images/cb27704982766b4f02691ea975d9a259/tenor.gif?itemid=11365139'
output: 
  html_document:
    keep_md: true
---

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
[analysis]: After reading this post, the r-user (or outsider) will understand how I got to certain answers and (preferably) agrees with them and is excited to start a similar approach on their dataset.

This is the kind of thing that might end up in data is beautiful (or ugly) on reddit.

Title: contains the main answer or question: Do things get darker in later episodes of..
-->

<!--
    start with problem, how to approach it, and what the answers are? (write last) -->

<!--
{{< columns >}}
This is column 1.
{{< column >}}
This is column 2.
{{< endcolumn >}}
-->

<!-- why this problem? -->

<!--approach -->

<!--packages used and data used -->

<!--step by step through process -->

<!--conclusion  -->

<!-- references -->

### State of the machine
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```{r}
sessioninfo::session_info()
```

</details>


