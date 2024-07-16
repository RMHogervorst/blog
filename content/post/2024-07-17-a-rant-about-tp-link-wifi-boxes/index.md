---
title: A rant about tp-link wifi boxes
description: "When my internet was down, my wifi went down too, that just doesn't make sense, but here we are. In this post I will rant about that."
subtitle: No internet? no wifi for you!
date: 2024-07-17
preview: ""
draft: false
tags:
    - DNS
    - pi-hole
    - lan
categories:
    - blog
difficulty:
    - beginner
post-type:
    - rant
share_img: ""
image: "/blog/2024/07/17/a-rant-about-tp-link-wifi-boxes/jadon-kelly-Qo_2hhoqC3k-unsplash.jpg"
---

My internet was down for several days, (see previous post) and the only thing that really broke, except for obviously internet connected services on home-assistant, was the wifi.

I have tp-link deco boxes and they work really okay for most of the time. They form a mesh and connect with whatever connection is best (through electricity, point to point wifi, or a network cable). In general, they just work. Until your internet connection is down.

So here I was 12 hours in my trials-of-no-internet, everything was working fine locally, when suddenly and without explanations the wifi boxes start dropping out, indicating with ominous red light that something was wrong. 

The tasks in my home network are really clear: a device from my provider delivers the magical internet to the lan, and the wifi boxes deliver that lan through the air to the devices in the house. These fuckers have 2 operating modes (access point or router). Unfortunately, even if you put these devices in access-point mode, the boxes are doing connectivity checks by doing DNS queries on the world's worst privacy offenders; Google, Facebook, Amazon and Microsoft. There is no way to turn this off (there are tons of forum posts where people complain about this), and if that DNS query is not resolved the boxes will restart. 

I once had the same issue with normal internet connectivity when I piholed facebook and google for the wifi boxes. The problem is not really the DNS queries, that is annoying but in itself not really privacy breaking: the boxes only ask for the address (that is what a DNS query is). The frustrating thing is that the wifi doesn't work without internet. 
**Why is my wifi down when the lan is working perfectly?**

Technically the problem lies in the system:
- pihole resolves all DNS queries by querying upstream
- all DNS records have a time to live (TTL)
- google, microsoft amazon etc have very short TTL values
- pihole will not serve old data (this makes some sense)
- so the wifi routers broke down when the TTL of these records was done and no refresh was possible

So I might have to complicate the system by adding another component: unbound. This will resolve all DNS queries recursively and I can change a setting that will make it serve old DNS resolutions for as long as there are no updates. That way the wifi routers will stay online. yay


### notes
Photo by <a href="https://unsplash.com/@jado_tornado?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jadon Kelly</a> on <a href="https://unsplash.com/photos/wifi-signal-on-metallic-panel-Qo_2hhoqC3k?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
  