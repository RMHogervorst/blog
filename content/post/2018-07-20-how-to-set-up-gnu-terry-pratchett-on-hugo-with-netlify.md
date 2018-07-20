---
title: How to set up GNU Terry Pratchett on hugo with netlify
author: Roel M. Hogervorst
date: '2018-07-20'
slug: how-to-set-up-gnu-terry-pratchett-on-hugo-with-netlify
categories:
  - blog
tags:
  - intermediate
  - webtechnologies
  - Terry Pratchett
  - netlify
  - hugo
  - blogdown
subtitle: 'Keeping Terry Pratchett alive in static websites'
share_img: '/post/2018-07-20-how-to-set-up-gnu-terry-pratchett-on-hugo-with-netlify_files/Clacks-Tower.jpg'
---

**TL;DR:**

In this post I will show you how to set up special header information on a static website such as 
hugo + netlify. Netlify interprets the _headers file and applies the rules to your website. You only have to set a simple rule, and now you too can keep Terry Pratchett alive!

<img src="/post/2018-07-20-how-to-set-up-gnu-terry-pratchett-on-hugo-with-netlify_files/Clacks-Tower.jpg" alt="Clacks tower image with title text on top" width="60%"/>


# GNU Terry Pratchett
On March 12th 2015 one of my favorite writers; Terry Pratchett died, but the people of the internet were not ready to let him go. From the www.gnuterrypratchett.com website:

>  In Terry Pratchett's Discworld series, the clacks are a series of semaphore towers loosely based on the concept of the telegraph. Invented by an artificer named Robert Dearheart, the towers could send messages "at the speed of light" using standardized codes. Three of these codes are of particular import:

```
    G: send the message on
    N: do not log the message
    U: turn the message around at the end of the line and send it back again
```
> When Dearheart's son John died due to an accident while working on a clacks tower, Dearheart inserted John's name into the overhead of the clacks with a "GNU" in front of it as a way to memorialize his son forever (or for at least as long as the clacks are standing.) 

# The clacks network is sort of like the current internet

Because the internet is our version of the clacks, some geniouses thought of adding a special message in the 'overhead of the internet'. The overhead in the internet is: the response headers sent by every server.  

## Wait, what? response-headers?
So what is it? Everytime you (or your browser really) reaches out to a website with a request
the server on the other side gives you back a response. The response has the webpage (hopefully) and some headers. The headers give you some information about the server and wether or not the server could answer your request. 

But, you can add **extra information** to the headers, there is no limit. And so, since the internet looks a bit like the clacks (somaphore towers) in the Diskworld, we can keep Terry Pratchett alive by adding him to every response. 

## Detecting GNU Terry Pratchett
I love this. I have an extension in my browser that reads the headers and tells me if a website has this enabled. There is a [chrome extension](http://www.gnuterrypratchett.com/#chrome), a [firefox extension](http://www.gnuterrypratchett.com/#firefox), and a [safari extension](http://www.gnuterrypratchett.com/#safari) to detect GNU Terry Pratchett in the overhead. It's a little extension that just starts to blink when it detects something. 

For instance the Dutch news group NOS has it turned on! And the Guardian too.

# Turning on GNU Terry Pratchett on your hugo + netlify deployment

There are plugins for wordpress, drupal, apache. scripts for html, django node.js perl and many many other webframeworks. But there was not one for Hugo yet.

I build and deploy my website through netlify. Netlify gives you the option of specifying your headers. So how how do you do it?


- (if you don't have it yet) create a file called '_headers' in your static folder

- Add this to that file:

```
/*
  X-Clacks-Overhead: "GNU Terry Pratchett"
```

From now on, netlify will return that response-header to every response. You're done!

>  "A man is not dead while his name is still spoken."  - Going Postal, Chapter 4 prologue


## references

- http://www.gnuterrypratchett.com/
- [link to how to set up headers on netlify](https://www.netlify.com/docs/headers-and-basic-auth/)
- I lifted the image from <http://www.techbritannia.co.uk/2015/03/terry-pratchett-the-good-gnus-ensure-hell-never-be-forgotten/> 