---
title: Setting up CSP on your hugo (+netlify) site
author: Roel M. Hogervorst 
difficulty:
  - intermediate
description: "a description"
post-type:
  - walkthrough
date: '2019-03-13'
publishdate: '2019-03-20'
slug: setting-up-csp-on-your-hugo-site
categories:
  - blog
tags:
  - hugo
  - csp
  - security-headers
  - security
  - report-uri
subtitle: 'Content security policy is being nice to your readers browser'
share_img: /post/2019-03-13-setting-up-csp-on-your-hugo-site_files/kai-pilger-395931-unsplash.jpg
---

I recently got a compliment about having a [content security policy (CSP) on my blog.](https://twitter.com/hrbrmstr/status/1104483521291268097)

But I'm not special, you can have one too!

In this post I will show you how I created this policy and how you can too.
I'm using the service report-uri.com which automates a lot the work. 
This is specific for building a hugo site using netlify.
**I am absolutely no expert and so this is mostly a description of what I did.**

In short:

* put a _headers file in the 'static/' folder
* fill this file with basic security headers 
* set up a report-uri or (a source to which reports should go)
* set the content-security policy (CSP) to report-only
* wait
* learn from the reports what should be allowed and what not
* set the CSP from what you learned
* set the CSP to blocking mode

## Basic setup

* Everything in the '/static' folder in your hugo project is placed at root of the website. 
* If you have a file called _headers in your root netlify will pick that
up and use it as header information. 

So if you place a _headers file in the '/static' folder of your blog folder
netlify will process that and create response headers for you. 


## My setup

I use github (but you can self host, use gitlab or anything else) to build my
blog. Whenever a new blogpost is uploaded github tells netlify and netlify (runs
hugo and) builds the website. You can also create a header file that is just a
bunch of rules that netlify will obey for your website. [As explained here.](https://www.netlify.com/docs/headers-and-basic-auth/)


<img src="/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/nadine-shaabana-1327576-unsplash.jpg" alt="This is your CSP telling the website not anything can be loaded" height="200px"/>


### What are headers?
When your browser communicates with a server they exchange packages, there is content
in the packages and there is some meta-information. Your browser tells the server
what kind of browser it is and what kind of information it wants to receive. And
the server tells the browser what kind of server it is, and what is allowed and
not allowed. We call these rules headers. Just to make it more confusing: the 
metadata on top of a website is called the head. 
*I know... There was little user research in those early dark days of the internet.*

### So what is in my headers?

See my '_headers' file [here](https://github.com/RMHogervorst/blog/blob/master/static/_headers), but don't blindly copy it! I have a much better
way for you to build this information later on.

Top of the file:

```
/*
  X-Frame-Options: DENY
  X-XSS-Protection: 1; mode=block
  X-Content-Type-Options: nosniff
```

What does the header file say:

* `/*` for all pages on blog.rmhogervorst.nl
* `X-frame options` Disable iframes from other places.
* 'X-XSS-Protection: Cross site scripting protection: does not let the page load when a cross site scripting is detected
* X-content-type-options: Don't really know what it does, but  it is recommended.


But then follows the CSP:

![This stops XSS](/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/jose-aragones-627837-unsplash.jpg)
```
Content-Security-Policy: 
default-src cdnjs.cloudflare.com 'self' blog.rmhogervorst.nl code.jquery.com fonts.googleapis.com.....ETC
```

This CSP tells what default-src can deliver content, where code, images,  css and fonts can be loaded  from.

I did not manually type out all of the domains I use on my website. I don't have
the time. 

I use a service called <report-uri.com>. You can start with following a wizard
and adding some basic CSP thingies to your headers. You set your CSP to report-only
(so not blocking anything, but only reporting). This makes all browsers who visit
your site report all the sources to report-uri. 

For an alternative use Bob Rudis (@hrbrmstr)'s post on setting up a report-uri
yourself [on AWS s3](https://rud.is/b/2019/03/14/collecting-content-security-policy-violation-reports-in-s3-effortlessly-freely/). 

I didn't know about it, and report-uri works too, so choose what you want.

![Maybe I went a bit overboard on the stop images](/post/2019-03-13-setting-up-csp-on-your-hugo-site_files/kai-pilger-395931-unsplash.jpg)


All the reports are coming in to the report-uri website now and you can check later (depending
on the traffic) what sources are reported. On the report-uri website you can say which
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
