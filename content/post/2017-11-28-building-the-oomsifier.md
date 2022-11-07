---
title: Building the oomsifyer
author: Roel M. Hogervorst 
difficulty:
  - intermediate
description: "In this post I am solving the life long dream of people all around the world … of adding dancing banana gifs to pictures…"
post-type:
  - walkthrough
date: '2017-11-28'
categories:
  - blog
  - R
tags:
  - magick
  - example_function
  - hack
  - banana
  - gif
slug: building-the-oomsifier
---

Today I will show you a quick hack (OK it took me like 4 hours during my travels today yesterday and today),
on how to add a dancing banana to any picture.

Now, you might be thinking... Really, why would you add a dancing banana to
a picture, but I don't have time for that kind of negativity in my life.

![](/img/r-pkg.gif)

## Why oomsifier?
Jeroen Ooms is one of those crazy productive people in the R world. The way he
wraps c++ libraries into packages makes you think his middle name is c-plus-plus.

At the Sat-R-day in budapest in 2016 (?) Jeroen demonstrated the magick library. 
You can now control images from inside R using dark magic and the bindings to
 the magick library. In honor of this work and because I needed a cool name,
I will demonstrate **THE OOMSIFYER**.

> Solving the life long dream of people all around the world ... of adding dancing banana gifs to pictures...

If you are like me, you would have thought this would be really easy, but you would be wrong.

First the function then the explanation and some stuff that took me waaay too long
to find out.

The function

```r
banana <- image_read("/img/banana.gif") # this assumes you have a project with the folder /images/ inside.

add_banana <- function(image, offset = NULL, debug = FALSE){
    image_in <- magick::image_read(image)
    banana <- image_read("images/banana.gif") # 365w 360 h
    image_info <- image_info(image_in)
    if("gif" %in% image_info$format ){stop("gifs are to difficult for  me now")}
    stopifnot(nrow(image_info)==1)
    # scale banana to correct size:
    # take smallest dimension.
    target_height <- min(image_info$width, image_info$height)
    # scale banana to 1/3 of the size
    scaling <-  (target_height /3)
    front <- image_scale(banana, scaling)
    # place in lower right corner
    # offset is width and hieight minus dimensions picutre?
    scaled_dims <- image_info(front)
    x_c <- image_info$width - scaled_dims$width
    y_c <- image_info$height - scaled_dims$height
    offset_value <- ifelse(is.null(offset), paste0("+",x_c,"+",y_c), offset)
    if(debug) print(offset_value)
    frames <- lapply(as.list(front), function(x) image_composite(image_in, x, offset = offset_value))

    result <- image_animate(image_join(frames), fps = 10)
    result
}
```

## So what can it do?

This function takes an image, f.i. a ggplot2 image that you saved to disk, and adds the dancing banana gif to the bottom right corner. 

![ggplot with banana example](/img/ggplot.gif)

I had to combine information from the magick [vignette](https://cran.r-project.org/web/packages/magick/vignettes/intro.html#animation)  and an earlier [blogpost](https://ropensci.org/blog/2016/08/23/z-magick-release/) about magick in R. 

Things I learned:

* the magick package returns image information as a data frame
* a gif is a succesion of images (frames)
* a normal picture is a single frame
* to combine a gif and a single frame you have to have exactly as much frames of your original picture as the number of frames in the gif
* for every frame you have to merge the gif and image with each other into a composite image
* the offset is the number of pixels from the left of the frame and from the top of the frame. I wanted to put the dancing banana at the bottom right of the picture AND I wanted to scale the banana so that it would take over the entire image so the offset needed to be responsive to both scaling and the input dimensions
* [the practical dev](https://twitter.com/ThePracticalDev) has many silly o-reilly like book covers that I find hilarious


![spss picture](/img/spss.gif)


In a the following posts I might turn this function into an API, stay tuned!
