---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
author: Roel M. Hogervorst
date: {{ .Date }}
# categories are blog / and or R. posts under R will be syndicated by r-bloggers and rweekly
categories:
  - blog
  - R
# Add all packages you are using as a tag
tags:
  - 
difficulty:
  - advanced
  - beginner
post-type:
  - tutorial
subtitle: ''
image: "{{time.Format "2006/01/13", " .Date }}/{{ replace .TranslationBaseName "-" " " | title }}/image.jpg"
share_img: 'https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif'
---

<!-- tags  at least beginner, tutorial, and all packages used.  -->
<!-- categories: R and blog. Blog is general, R means rweekly and r-bloggers -->
<!-- share img is either a complete url or build on top of the base url (https://blog.rmhogervorst.nl) so do not use the same relative image link. But make it more complete post/slug/image.png -->


<!-- content -->

<!-- > 
After reading this post, and following along r-users will know how to apply this approach on their data and think of me as someone who is a good explainer

A [**tutorial**](https://teachtogether.tech/#g:tutorial) helps newcomers to a field build a mental model
*tutorial (step by step pieces of code, with the result at the start)*
Good tutorials are: 
- quick. tell what you want to do, how to do it
- easy: success is important. playtest the tutorial under different circumstances
- not to easy: Don't get htem throug ht toturoial onluy to runinto a wall later on. 

People who read this tutorial have just started out, 
know absolutely nothing, don't even have a mental model of how things work in R.
I call them beginners, because that is what I used before. In the 
Explain everything. Use analogies. 

Subjects I've used before include:
*for, loops, brackets, vectors, data structures, subsetting, functions, qplot, ggplot2, dplyr, spps-to-r, haven, tidyr, tidyverse*


Make a great image to add to the share link on top.

* you will be able to do the thing I did, which generalizes to a broader class of problems, after following this post*
Follow along, running the code on your computer (higher levels with their own data), see this as a useful way to do stuff*
-->




### References
- Find more tutorials by me in [this tutorial overview page](https://blog.rmhogervorst.nl/post-type/tutorial/)

### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```{r}
sessioninfo::session_info()
```

</details>