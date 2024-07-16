---
title: An offline first smart home is really nice
description: Recently my internet connection was down for several days, home assistant just kept going, and that is amazing!
subtitle: Local first smart home was a great decision
date: 2024-07-16T08:46:40.893Z
preview: ""
draft: false
tags:
    - home-assistant
    - webtechnologies
    - smart-home
categories:
    - blog
difficulty: 
    - beginner
post-type: 
    - thoughts
share_img: ""
image: "/img/presentation_images/keyboard02_10p.jpg"
---

Recently my internet connection was down for several days, where I live in Europe that almost never happens. I am so used to having an internet connection that I really had to adjust to this.

Of course having mobile phones with data connections means my online addiction was regularly fed, but I can't roam my home lan over my mobile connection (yet?).

Home assistant just kept going and that is awesome! In the before days this was normal and expected behavior, but many applications require an active internet connection nowadays. 

With internet down, but local lan still up this is what still worked during my trials-of-no-internet.

- local dns (which includes mdns): so all network devices kept their name and could be navigated to.
- all home assistant automations (at this moment they do not call outside services)
- all network connected plugs, all zigbee connected plugs
- all lights
- window sensors
- I could even add a new device to home assistant

Things that no longer worked (they require internet connection so no surprises here)

- weather forecasts
- rain forecast (seperate service)
- airquality
- supermarket integration
- package delivery notifications

Now imagine this would run in a cloud computer. Nothing would work anymore. And I would pay a lot of money for that.