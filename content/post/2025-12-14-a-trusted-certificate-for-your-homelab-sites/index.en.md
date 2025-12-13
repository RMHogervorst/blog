---
title: A Trusted Certificate for your Homelab Sites
author: Roel M. Hogervorst
date: '2025-12-14'
slug: a-trusted-certificate-for-your-homelab-sites
categories:
  - blog
tags:
  - kubernetes
  - homelab
subtitle: ''
summary: 'In this post I will describe how you can set up services in kubernetes that will listen for new ingress, create a certificate, get it signed by letsencrypt and presented on the correct website. It will also automatically update DNS records.'
image: '/blog/2025/12/13/a-trusted-certificate-for-your-homelab-sites/pdia-8f5fcfb2-5786-462d-8405-a04a650ebbd3.jpg'
difficulty:
  - advanced
post-type:
  - post
---

<!-- tags choose:
beginner, intermediate or advanced
*beginner:*
*for, loops, brackets, vectors, data structures, subsetting, functions, qplot, ggplot2, dplyr, spps-to-r, haven, tidyr, tidyverse*

*intermediate:* 
*tools, building packages, testing, slides in markdown, apply, package, advanced ggplot2, environments, animation, test, workflow, reproducability, version control, git, tidyeval*

*advanced:*
*S4 classes, extensions , shiny, Object Oriented Programming, Non standard Evaluation, code performance, profiling, Rcpp, optimize-your-code*
-->
<!-- categories: R and blog. Blog is general, R means rweekly and r-bloggers -->

<!-- share img is either a complete url or build on top of the base url (https://blog.rmhogervorst.nl) so do not use the same relative image link. But make it more complete post/slug/image.png -->


<!-- content  -->
In this post I will describe how you can set up services in kubernetes that will
listen for new ingress, create a certificate, get it signed by letsencrypt and presented on
the correct website. It will also automatically update DNS records.


In my previous post I described how you can create .local websites on your homelab,
and how you can use mDNS to have the sites working without extra configuration.
But mDNS is served over http, and many browsers feel slower with http compared to https.

So how do you setup https certificates for your homelab?

![](pdia-8f5fcfb2-5786-462d-8405-a04a650ebbd3.jpg)

This is mostly a description for me, because I had to combine several tutorials to 
make it work for me. So how does it work? 

## From an URL to dogvideos

If I type 'https://dogvideos.rmhogervorst.nl into my phone I should see my example dogvideos website. 

1. So devices have to know where the website lives (dns; domain name system), it returns an ip-address
2. Your device calls that ip address with the name https://dogvideos.rmhogervorst.nl
3. Your server has to respond to that website, and present a valid certificate
4. Your device checks the validity of that certificate
5. profit?

## Local url to local dogvideos

How does that work on a local network? (1) DNS is done at your router, or a pihole, or another
device on your network. You can manually set a local DNS record: `A dogvideos.rmhogervorst.nl 10.1.1.56`.
But I am extremely lazy, and even though I have only four websites running on my homelab, so I automate the creation of DNS records.

There is a kubernetes project called [external-dns](https://kubernetes-sigs.github.io/external-dns/latest/) that interfaces with cloudproviders to update
DNS records. For instance if you run on the google cloud it can interface with google cloud DNS records to update for new services on your cluster.
The project is really easily extended, so there are plugins for local use too: you can update unifi devices, pihole, powerdns, coredns, adguard, and more.

(2) If you run kubernetes you can make it respond correctly with kubernetes ingress or the gateway API

(3) Presenting certificates is done by ingress, and getting and renewing certificates can be done with [cert-manager](https://cert-manager.io/)

(4) To get valid certificates means you need to own and control a domain and use letsencrypt to get a valid cert, or use something like [localcert](https://localcert.net/) to handle that for you.

(5) profit? **So wait a minute how many components have I set up to make my dogvideos website load on my phone on my local network?**

Let's make a tally: 1 container for the website, 1 container for the database, 
1 container for certmanager, 1 container for the certmanager addon for my provider, 
there might be another webhook container for certmanager, 1 traefik ingress container, 
2 external dns containers (1 pod, 2 containers). So 8 containers to run a website on my
homelab... 

That seems excessive, but (!) every new application will not need 8 new containers.
If I now deploy immich, I have 1 main container, 1 machinelearning container, 
1 redis container (this could be shared, but it is not), 
1 postgres container and certmanager, traefik etc. So really it is just 4 containers,
and everything else is shared. This could still feel bloated, and you are right
I could have installed everything directly on the machine, but updating would be
more difficult, and different versions of dependencies are a nightmare. 
Maybe if you use nix for everything you could make it work, but kubernetes is
really easy too. 

## Kubernetes as a framework

Kubernetes with certmanager, external-dns and some more services are the framework 
that I deploy my new apps on. With some small configuration changes everything is taken care of.
certmanager manages the certificates (rotates them too), external DNS knows what domains to look for.

Oh and None of this leaves my home network. The only thing that is visible outside my home are TXT records on my DNS provider that let Letsencrypt verify that I have control over my domain.



Image sourced from the <a href="https://pdimagearchive.org/images/8f5fcfb2-5786-462d-8405-a04a650ebbd3">Public Domain Image Archive / Zentralbibliothek Zürich</a>