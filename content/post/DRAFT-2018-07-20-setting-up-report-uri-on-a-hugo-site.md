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






# References

- Some explanations on how to set up several things on the netlify side  <https://www.netlify.com/docs/ssl/>
- the [report-uri website](https://report-uri.com/)
- if you want to delve a bit deeper in [what header to set and to scan your website](https://securityheaders.com)

