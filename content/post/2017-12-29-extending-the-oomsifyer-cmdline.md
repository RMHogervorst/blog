---
title: Adding bananas from the commandline (extending the oomsifier)
author: Roel M. Hogervorst 
difficulty:
  - advanced
description: "Sometimes you just want to add bananas to pictures from the commandline."
post-type:
  - walkthrough
date: '2017-12-29'
categories:
  - blog
  - R
tags:
  - magick
  - example_function
  - hack
  - banana
  - gif
share_img: /img/r-pkg.gif
slug: extending-the-oomsifyer-cmdline
---

Sometimes you just want to add bananas from the commandline. [Previously](https://blog.rmhogervorst.nl/blog/2017/11/28/building-the-oomsifier.html)
I created a small script that takes an image and adds a dancing banana to the bottom left of the image. I wanted to make an API too, but that will have to wait till next year. Today we will create a commandline script that will do the same thing.

With the excellent explanation in [Mark Sellors' guide](http://blog.sellorm.com/2017/12/18/learn-to-write-command-line-utilities-in-r/ ) I have now created a cmdline thingy in very few steps.


![](/img/r-pkg.gif)

I can now add bananas from the commandline with:

```
./bananafy.R ../images/ggplotexample.png out.gif
```

This executes and says:
```
Linking to ImageMagick 6.9.7.4
Enabled features: fontconfig, freetype, fftw, lcms, pango, x11
Disabled features: cairo, ghostscript, rsvg, webp
writing bananafied image to out.gif
```

#### The modified script

First the script itself, saved as bananafy.R

```
#!/usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1){
    stop("I think you forgot to input an image and output name? \n")
}

library(magick)
## Commandline version of add banana
#banana <- image_read("images/banana.gif") # this assumes you have a project with the folder /images/ inside.

#add_banana <- function(, offset = NULL, debug = FALSE){
offset <- NULL # maybe a third argument here would be cool?
debug <- FALSE
image_in <- magick::image_read(args[[1]])
banana <- image_read("../images/banana.gif") # 365w 360 h
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
message("writing bananafied image to", args[[2]])
image_write(image = result, path = args[[2]])
```

As you might notice I copied the entire thing from the previous post and added some extra Things

* It starts with '#!/usr/bin/Rscript'

According to Mark:

> Sometimes called a ‘shebang’, this line tells the Linux and MacOS command line interpreters (which both default to one called ‘bash’), what you want to use to run the rest of the code in the file. ....The --vanilla on the end, tells Rscript to run without saving or restoring anything in the process. This just keeps things nice a clean.

I've added a message call that tells me where the script saves the image. I could have suppressed the magic messages, but meh, it is a proof of concept.

To make it work, you have to tell linux (which I'm working on) that it can execute the file. That means changing the permissions on that file

In the terminal you go to the projectfolder and type `chmod +x bananafy.R`. You CHange MODe by adding (+) eXecution rights to that file.


### advanced use: making bananafy options available always and everywhere in the terminal.
We could make the bananafyer available to you always in in every folder. T do that you could move the script to f.i. ~/scripts/,  modify the code a bit and add the bananagif to that same folder. You then have to [modify your bashrc file](https://askubuntu.com/questions/153251/launch-shell-scripts-from-anywhere).

* I had to make the link to the banana hardcoded: '~/scripts/images/banana.gif'
* you can call the code from anywhere and the output of the script will end up in the folder you currently are in. So if I'm in ~/pictures/reallynicepictures the bananafied image will be there. 
