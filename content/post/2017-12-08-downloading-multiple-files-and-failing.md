---
title: Downloading files from a webserver, and failing.
author: Roel M. Hogervorst 
difficulty:
  - intermediate
description: "It can be incredibly useful to see where someone fails, here are my lessons learned from failing in dowloading many files."
post-type:
  - walkthrough
  - reminder
date: '2017-12-08'
categories:
  - blog
  - R
tags:
  - hack
  - curl
  - purrr
  - scraping
slug: downloading-multiple-files-and-failing
share_img: /img/scraping_a_plate.jpg
---

Recently I wanted to download all the transcripts of a podcast (600+ episodes). 
The transcripts are simple txt files so in a way
I am  not even 'web'-scraping but just reading in 600 or so text files which is 
not really a big deal. I thought. 

This post shows you where I went wrong TL:DR : _do not assume everything will always work on the internet_.

Also here is a [picture](https://www.flickr.com/photos/32123311@N00/502155430 "source: flickr, cc-by 2.0 jbloom") I found of scraping. 

![Scraping a plate ](/img/scraping_a_plate.jpg)


### Webscraping general 
For every download you ask the server for a file and it returns the file (this is also how you normally browse the web btw, your browser requests the pages).

In general it is nice if you ask permission (I did, on twitter and the author was really nice! I recommend it!) and don't 
push the website to its limit. The  servers where these files are hosted are quite beefy and I will 
probably not even make a dent in them, when I'm downloading these files. But still, be gentle. 

**No really, be a responsible scraper and tell the website owners you are scraping (in person or by identifying in the header) and check if it is allowed**

I recently witnessed a demo where someone explained a lot of dirty tricks on how to get over those pesky servers denying them access and generally ignoring good practices and it made me sick...  

Here are some general guides:

- [Bob Rudis (@hrbrmstr) about scraping and robots.txt](https://rud.is/b/2017/07/28/analyzing-wait-delay-settings-in-common-crawl-robots-txt-data-with-r/)
- [excellent vignette of the httr package, read the part about user-agent](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html)

### Downloading non-html files
There are multiple ways I could do this downloading:
if I had used rvest to scrape a website I would have set a user-agent
header[^2] 
and I would have used incremental backoff: when the server refuses a connection
we would wait and retry again, if it still refuses we would wait twice as long
and retry again etc.


However, since these are txt files I can just use read_lines^[This is the readr variant of readLines from base-R, it is much faster then the original]
to read the txt file of a transcript and apply further work downstream. 


#### A first, failing approach, tidy but wrong
This was my first approach:

- all episodes are numbered and the transcript files are sequental too, so just a paste0 of "https://first-part-of-link" number".txt" would work.
- put all links as row into dataframe
- apply some purrr magic by mapping every link to a read_lines function (*what? use the read_lines() function on every link* ).


```r
latest_episode <- 636
 

system.time(
 
    df_sn <- data_frame(link = paste0("https:linktowebsite.com/firstpart-",
 

                                      formatC(1:latest_episode, width = 3,flag = 0),".txt")) %>%
 
        mutate(transcript = map(link, read_lines2))
 
)
```

This failed.

Some episodes don't exists or have no transcript (I didn't know). Sometimes the internet connection didn't want to work and just threw me out. Sometimes the server stopped my requests. 

On every of those occasions the process would stop, give an informative error[^3]. But the R-process would stop and I had no endresult.

#### Getting more information to my eyeballs and pausing in between requests

Also I didn't know where it failed. So I created a new function that also sometimes waited (to not overwhelm the server)

```r
## to see where we are this function wraps read_lines and prints the episodenumber
 

read_lines2 <- function(file){
 

    print(file)
 
    if(runif(1,0,1) >0.008)Sys.sleep(5)

    read_lines(file)

}
```

This one also failed, but more informatively, I now knew if it failed on a certain episode.

But ultimately, downloading files from the internet is a somewhat unpredictable process. And it is much easier to just first download all the files and read them in afterwards.

#### A two step approach, download first, parse later.

Also I wanted to let the logs show that I was the one doing the scraping and how to reach me if I was overwhelming the service. 

Enter curl. 
Curl is a library that helps you download stuff, it is used by the httr package and is a wrapper around the c++ package with the same name, *wrapped by Jeroen 'c-plus-plus' Ooms*. 

Since I ran this function a few times I downloaded some of the files, and didn't really want to download every file again, so I also added a check to see if the file wasn't already downloaded[^1] . And I wanted it to print to the screen, because I like moving text over the screen when I'm debugging.

```r
download_file <- function(file){
    filename <- basename(file)
    if(file.exists(paste0("data/",filename))){
        print(paste("file exists: ",filename))
    }else{
        print(paste0("downloading file:", file))
        h <- new_handle(failonerror = FALSE)
        h <- handle_setheaders(h, "User-Agent"= "scraper by RM Hogervorst, @rmhoge, gh: rmhogervorst")
        curl_download(url = file,destfile = paste0("data/",filename),mode = "wb", handle = h)
        Sys.sleep(sample(seq(0,2,0.5), 1)) # copied this from  Bob Rudis(@hrbrmstr)
    }
}
```

I set the header (I think...) and I tell `curl` not to worry if it fails, *we all need reassurance sometimes*, but just to continue. 

And the downloading begins:

```r
# we choose walk here, because we don't expect output (we do get prints)
# We specificaly do this for the side-effect: downloading to a folder.

latest_episode <- 636
#downloading
walk(paste0("https://first-part-of-link.com/episodenr-",
           formatC(1:latest_episode, width = 3,flag = 0),".txt"), download_file)
```

[^1]: I thought that was really clever, don't you? 
[^2]: a piece of information we send with every request that describes who we are 
[^3]: really, it did


## Conclusion

So in general, don't be a dick, ask permission and take it easy. 

The final download approach works great! And it doesn't matter if you stop it halfway. In the future you can see why I wanted all of these files. 

I thought this would be the easy step, would the rest be even harder? Tune in next time!


#### Cool things that I could have done:

- use purrr::safely ? I think it will continue to work after a fail then?
- use a trycatch in the download
- first check if the file exists
- Do something more with curl, honestly it has many many options that I just didn't explore. 
- use some CLI spinners for every download, way cooler
- write to a log, and not to the console.


