---
title: Setting up report-uri on a hugo site with netlify
author: Roel M. Hogervorst
date: '2018-07-20'
slug: setting-up-report-uri-on-a-hugo-site
categories:
  - blog
tags:
  - report-uri
  - security
  - https
  - hugo
  - blogdown
  - netlify
subtitle: ''
share_img: ''
draft: true
---

How to set up report uri on your hugo site 

to make this work we need to create a report-uri.com account, change some headers, enable (force) https. 


# Why do we need csp?

CSP tells a browser and the world, what sources are allowed to be loaded, and what sources not. 
For instance, I want to load my own content, bootstrap theming css and javascript.
What you don't want is that when someone loads your website, ads (not ones you served), or cryptocurrency miners or other stuff is loaded with you website. 

A content security policy tells the browser what it may load. Everything not on the list gets blacklisted for your page and will not be loaded. Which is great! but..

it is pretty hard to set up these rules from the start. That is why we need a different approach.
First we set up a bunch of rules and report only. All the reports are send to report-uri.com.
We use the free tier, which is probably good enough. 

After a few days we check the report-uri reports to see if something is getting reported that should actually be whitelisted. For instance if I frequently load stuff from github, I might want to whitelist certain repos, but more often than that there is some javascript that you need.



# Steps
go to report-uri make an account

assume you have set up your blog with blogdown, github and netlify to build after each push


create a '_headers' file in static. all files from static will be placed at the root of your website. so if you put dogshit.txt in static, you can read it on yourwebsite.com/dogshit.txt

In the headers we can set certain options. 

we go to report-uri and find the policy. copy that to your header file

```
# a headers file example
/*   # means for every page (you can set rules for specific parts)
  Content-Security-Policy-Report-Only: default-src 'none'; form-action 'none'; frame-ancestors 'none'; report-uri https:/thethingyougetfromreport-uri.report-uri.com/r/d/csp/wizard
```

This will report to the wizard endpoint in report-uri. The wizard will will show you which domains are loaded on every pageload.

What is loaded?

If you use bootstrap theming, css from bootstrap is loaded, fonts from google, 
mathjax javascript, bootstrap javascript, you might load images from different websites.


all this is loaded, and not yet blocked


----


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



---



# References

- Some explanations on how to set up several things on the netlify side  <https://www.netlify.com/docs/ssl/>
- the [report-uri website](https://report-uri.com/)
- if you want to delve a bit deeper in [what header to set and to scan your website](https://securityheaders.com)
- [a post about setting up netlify and report-uri](https://www.josephearl.co.uk/post/static-sites-netlify-security/)
- [awesome blogpost by Bob Rudis about CSP on r websites](https://rud.is/b/2019/03/10/wrangling-content-security-policies-in-r/)

