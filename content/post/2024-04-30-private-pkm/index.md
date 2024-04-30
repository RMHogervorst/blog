---
title: Private Personal Knowledge Management
slug: private-pkm
description: This post describes why I want to make my private knowledge base available as a website to myself only and some general directions of the project
subtitle: But globally accessable to me alone
date: 2024-04-30
preview: ""
draft: false
tags:
    - automation
    - bibtex
    - PKM
    - citations
categories:
    - blog
difficulty:
    - intermediate
post-type:
    - post
share_img: "img/presentation_images/keyboard02_10p.jpg"
image: "img/presentation_images/keyboard02_10p.jpg"
---

## Atomic ideas, connected
I write many blogposts on the basis of my notes in my personal knowledge system.  I'm using a digital zettelkasten method (you pull apart knowledge into atomic components (zettels) and write those components down, connecting them in ways that make sense for you). This allows me to make creative connections between ideas and concepts.

## living apart, together
Sometimes at work I want to look up something that I know is in my zettelkasten. Unfortunately I cannot easily access that. I could sync my personal things to my work laptop but I don't want to do that. I want to keep work and private seperate, for mental and legal reasons. I love that I can shut down my work laptop and work phone and being completely unavailable. A clear distinction between work and personal. Legally, things that I create during work time are automatically owned by $work (which is stupid, especially if you do software or other knowledge work). I have a good relationship with my coworkers and immediate bosses, but you never know if things turn sour. Work could try to claim ownership on everything I synced to the work laptop. I don't think that will ever happen, but hope for the best, prepare for the worst. 

## an idea is born
Because I'm always trying out new stuff I thought it would be neat if I could create a website with all my zettels (knowledge base) and view that through my phone (I don't really need to edit it through my phone).

## Current situation
Here is the current situation:

- I write my zettels in the program [zettlr](https://www.zettlr.com/).
- the notes are plain markdown with citations
- citations are managed by [zotero](https://www.zotero.org/) but are marked with bibtex like so: `[@hogervorstOutline2024]` the `@`-sign followed by a key that is created by zotero, with brackets around them. 
- I quite like writing in zettlr, so I don't want to  change the way I work. **I want to keep using zettlr**
- using tailscale, you can create a private overlay network that connects my phone, nas and laptops, even when I take my phone somewhere else it is still connected.
- you can **create websites that live on your private tailscale network** only.
- I have access to an always on NAS and server (a laptop)

Ideas I've rejected:

- syncing the zettelkasten notes to my phone (I can't really easily view them from my phone, _I do this with joplin but joplin needs specially formatted markdown and doesn't do citations nor internal links on android_)
- putting everything online through github or something (most of my stuff is mundane, but some is private, and some is sensitive, I could filter that out, but frankly that sounds like a lot of extra work.)
- there is an 'export project to html5' option in zettlr, but that keeps crashing

So I want to create a **webservice** that is only available **over tailscale** that processes the markdown notes **from zettlr** while keeping the i**nternal links consistent,** and keeping the **citations intact** or even better write them out.

## soft requirements
**wishes for transformation into website**
- don't change anything about zettlr (or as small as possible)
- support citations (I did not put in bibtext references for nothing)
- ability for keyword search
- abilty to filter by tag
- should display math equations (not too many in my slipbox, but when shown they are crucial)

nice to have:
- display a graph of my zettels