---
title: Setting up CSP on your hugo (+netlify) site
author: Roel M. Hogervorst
date: '2019-03-13'
slug: setting-up-csp-on-your-hugo-site
categories:
  - blog
tags:
  - hugo
  - csp
  - security-headers
  - security
  - report-uri
subtitle: 'Content security policy is being nice to your browser'
share_img: /post/2019-03-13-setting-up-csp-on-your-hugo-site_files/kai-pilger-395931-unsplash.jpg
---

I recently got a compliment about having a [content security policy (CSP) on my blog.](https://twitter.com/hrbrmstr/status/1104483521291268097)

But I'm not special, you can have one too!

In this post I will give a very short explanation what a CSP is, why you should
create one too and how I did it. One big disclaimer: 
**I am absolutely no expert and so this is mostly a description of what I did.**

I will show how I created a CSP with a service called report-uri.com


## What happens when you go to a website? (skip if you know this all, or don't care)
When you (your browser) connects to a website say `blog.rmhogervorst.nl`,
the server tells the browser what it should look like.  A webpage is basicely an instruction set for the 
browser how to build up the website including instructions on where to load data
from. In my case:

*Check out the html by putting 'view-source:' before the url in your browser to see what I mean*
My webpage tells you it's html, and then in the head part of the page it 
gives some meta information about the website, about the particular
blogpost, info about me and what images to use for twitter. But below that is the
real deal: it tells your browser what stylesheets to load, what javascript to load
and the rest of the website. In the body of the website it tells your browser 
what text to display, what images to load and the javascript and css in the
head of the page have told the website *how* to display that information. 

## What could go wrong?
Your browser is one huge computer, it can display content, but it can also do
lots of computation. And your browser does not care what computation it should
do. Any instruction is happily executed. 

Baddies know this and exploit this. One of the ways this happens is called 
Cross site scripting [(XSS; *the x is for cross, or maybe it looks just really cool?*)](https://en.wikipedia.org/wiki/Cross-site_scripting),
'baddies' inject scripts into a webpage and your browser doesn't know and doesn't
really care, and will execute those scripts. 

Those 'baddies' can inject:

- advertisements and make money on that
- run crypto miners on your browser
- or malicious iframes

If someone messes with your website you are serving this to all your readers.
If someone compromises the connection between the server and computer they can
serve something to a specific reader. 

<img src="/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/jair-lazaro-480031-unsplash.jpg" alt="Clearly a baddie with a cross-site-scripting plan" height="150px"/>

We don't want that. 

And this is a reason for setting up a CSP. 

## What is a CSP?
Bob Rudis has a nice, and more eloquent, overview of what [a CSP is and how it helps against XSS](https://rud.is/b/2019/03/10/wrangling-content-security-policies-in-r/). 
And so I will just quote him:

> To oversimplify things, the CSP header instructs a browser on what you’ve authorized to be part of your site. You supply directives for different types of content which tell browsers what sites can load content into the current page in an effort to prevent things like cross-site scripting attacks, malicious iframes, clickjacking, cryptojacking, and more.

A CSP is a contract between the server and the website, the server tells your browser
who is allowed to play in your garden. If your browser finds anything that is 
not allowed to play there it not only blocks that, but the browser will snitch,
if you give an adress to snitch to,
that someone wants to play who's not allowed. 



## How to set up a CSP using Netlify

I use github (but you can self host, use gitlab or anything else) to build my
blog. Whenever a new blogpost is uploaded github tells netlify and netlify (runs
hugo and) builds the website. You can also create a header file that is just a
bunch of rules that netlify will obey for your website. [As explained here.](https://www.netlify.com/docs/headers-and-basic-auth/)


<img src="/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/nadine-shaabana-1327576-unsplash.jpg" alt="This is your CSP telling the website not anything can be loaded" height="200px"/>

How does it work: in your local blogdown folder there is a 'static' folder.
blogdown puts your images from posts here in the 'post' folder. But if you
place a file called '_headers' there, netlfiy will pick it up at deploy time
and apply the headers found in the file.

### What are headers?
When your browser communicates with a server they exchange packages, there is content
in the packages and there is some meta-information. Your browser tells the server
what kind of browser it is and what kind of information it wants to receive. And
the server tells the browser what kind of server it is, and what is allowed and
not allowed. We call these rules headers. Just to make it more confusing: the 
metadata on top of a website is called the head. 
*I know... There was little user research in those early dark days of the internet.*

### So what is in my headers?

See my '_headers' file [here](), but don't blindly copy it! I have a much better
way for you later on.

Top of the file:

```
/*
  X-Frame-Options: DENY
  X-XSS-Protection: 1; mode=block
  X-Content-Type-Options: nosniff
```

What does the header file say:

* `/*` for all pages on blog.rmhogervorst.nl
* `X-frame options` etc : What is not allowed


But then follows the CSP:

![This stops XSS](/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/jose-aragones-627837-unsplash.jpg)
```
Content-Security-Policy: default-src cdnjs.cloudflare.com 'self' blog.rmhogervorst.nl code.jquery.com fonts.googleapis.com.....ETC
```
I did not manually type out all of the domains I use on my website. I don't have
the time. 

I use a service called <report-uri.com>. You can start with following a wizard
and adding the basic CSP thingies to your headers. You set your CSP to report-only
(so not blocking anything, but only reporting). This makes all browsers who visit
your site report all the sources to report-uri. 

For an alternative use Bob Rudis (@hrbrmstr)'s post on setting up a report-uri
yourself [on AWS s3](https://rud.is/b/2019/03/14/collecting-content-security-policy-violation-reports-in-s3-effortlessly-freely/). 

I didn't know about it, and report-uri works too, so choose what you want.

![Maybe I went a bit overboard on the stop images](/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/kai-pilger-395931-unsplash.jpg)


All the reports are coming in to the website now and you can check later (depending
on the traffic) what sources are reported. On the website you can say which
sources should be allowed and which should be blocked and in the end you end up
with a CSP that you can copy into the headers file.

So tl;dr

* put in _headers file in 'static/'
* fill with basic security headers 
* set up a report-uri (a source to which reports should go)
* set the CSP to report-only
* wait
* learn from the reports what should be allowed and what not
* set the CSP from what you learned
* set the CSP to blocking mode

# Image sources

- [Syringe by jair-lazaro from unsplash](https://unsplash.com/photos/D3UqzqwtdRw)
- https://unsplash.com/photos/1k3vsv7iIIc
- https://unsplash.com/photos/81QkOoPGahY
- https://unsplash.com/photos/DRzYMtae-vA
