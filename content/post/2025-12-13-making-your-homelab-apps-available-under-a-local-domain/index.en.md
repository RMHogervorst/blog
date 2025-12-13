---
title: Making your Homelab Apps Available under a .local Domain
author: Roel M. Hogervorst
date: '2025-12-13'
slug: making-your-homelab-apps-available-under-a-local-domain
categories:
  - blog
tags:
  - homelab
  - smart-home
  - mdns
  - kubernetes
subtitle: 'A touch of Traefik, externalDNS'
image: '/blog/2025/12/13/making-your-homelab-apps-available-under-a-local-domain/pdia-4a6cd96e-b84c-47fd-8b14-092df61e17ae.jpg'
difficulty:
  - advanced
post-type:
  - post
---

<!-- content  -->

I created a few applications on my homelab, one of those is music-assistant. Music-assistant is an awesome project that plays all your local and remote music over all your speakers. It can play Spotify, ripped cds, webradio stations etc., and it will play them over smart and dumb speakers. It also integrates with home-assistant. Anyways, what I want to talk about today is making services available on your home network.

The trick I use today is mDNS with kubernetes. And it results in services on my local network available under DNS like: http://music-assistant.local, http://catvideos.local. 

I'm super excited about this, because I only recently learned about mDNS (aka: zeroconf). [mDNS (multicast DNS)](https://en.wikipedia.org/wiki/Multicast_DNS) is a zero-configuration dns system, that only works on local networks (lan). It is used by all sorts of (smart) devices (esphome devices use it, and home assistant finds most of the lan devices this way too). Using mdns you can plug something in the network, type http://poopyhole.local in your browser and it will resolve to the device that you just plugged in _(given that it uses that name)_. You don't have to find out the ip-address by going to your router, nor do you have to manually set up dns records. The protocol sort sort of yells over the network what its name is and devices listen to it.

![](pdia-4a6cd96e-b84c-47fd-8b14-092df61e17ae.jpg)
If you have a raspberry pi or other server you can set the mDNS name in the settings. But what if you have multiple services running on one device? What if you hate yourself so much that you give yourself kubernetes? That is exactly where I am.

I have a lightweight kubernetes cluster (k3s) that runs traefik as ingress service. I've installed the [external-mdns operator](https://github.com/blake/external-mdns) that publishes mdns records for services. But it took me while to figure out how it works (probably because I didn't read the docs?).

Here is what I did to finally make it work:

I created this ingress based on 'host', pointing to the service `ma` that connects to the music assistant pod.

```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: music-assistant
  namespace: homeassistant
spec:
  rules:
  - http:
      paths:
      - path: "/"
        pathType: Prefix
        backend:
          service:
            name: ma
            port:
              name: web
    host: music-assistant.local
```
External DNS picks up the .local ingress and will shout over the network
where to find the website:

```bash
$ getent hosts music-assistant.local
10.1.1.56    music-assistant.local
```
Voila!

_(This post lived in my archive for more than a year before I published it. So it feels a bit weird to publish this one, and the next one close to each other. But know that I ran this setup for a year or so before I added tls certificates)_

Image sourced from the <a href="https://pdimagearchive.org/images/4a6cd96e-b84c-47fd-8b14-092df61e17ae">Public Domain Image Archive / Zentralbibliothek Zürich</a>
