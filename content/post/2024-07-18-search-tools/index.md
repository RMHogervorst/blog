---
title: "Search tools"
description: If you want to search, you often get elastic, but there are many options and depending on what kind of search you want. Here are some ways of looking at it.
subtitle: "local, website, logs or something else?"
date: 2024-07-18
lastmod: 2024-07-30
preview: ""
tags:
    - search
    - do-one-thing-well
categories:
    - blog
difficulty:
    - intermediate
post-type:
    - clarification
share_img: ""
image: "/blog/2024/07/18/search-tools/wilhelm-gunkel-Sn5oPeictgw-unsplash.jpg"
---

> If you want to search, you often get elastic, but there are many options and depending on what kind of search you want. Here are some ways of looking at it.


![a person looks through binoculars, it's really silly, but I thought it would represent 'search'](wilhelm-gunkel-Sn5oPeictgw-unsplash.jpg)



I came across this post on mastodon:

https://mastodon.social/@mhoye/112422822807191436
> I'm on here looking for text indexers and everything is 'lightning fast exoscale terafloops that scales to enterprise quantawarbles with polytopplic performanations' and it would be great if this industry could breathe into a bag until it remembers that one person with one computer is a constituency that matters.


The post, the replies and follow up thread are actually super useful. They narrow down what @mhoye wants; a fully local search thing that goes through docs on @mhoye's harddisk and a simple interface (webpage) to query.

With that question and some search engine queries, you end up on projects such as elastic and other hyped solutions, but they might not be the best solution for your usecase. It is amazing how elasticsearch has dominated _(ahum)_ search engine results, even for tasks where a way simpler application would be much better.

Search has become such a wide field that you have be really specific in what you want, to make an informed decision. This is visible in the replies, a wide range of possibilities from cli binaries like egrep to full fledged elastic search alternatives. 

They are all valid options for certain usecases. It is frustratingly hard to give a simple answer!
Here are some axes on which to evaluate your quest for a searchable solution.

_Note that I have not played with all of these and I am not getting money either. This is a rather open ended post, there is no conclusion, think about these axes when you evaluate 'search'._

### Local or on a server?

Is it for your personal documents on your laptop or NAS? If you don't want to move documents but just want to search through them small dedicated tools like [ripgrep](https://github.com/BurntSushi/ripgrep) are excellent, but they can 'only' search for a regex. And even though it is written in rust it will take some time to retrieve results over your entire harddisk. There are also tools that index all your documents for faster retrieval.

If you move to a server this gives you many more options, and more challenges. It allows you to use more heavy duty tools but it also means you have to bring the data to the search engine. See for more info the [heading "Do you want to insert documents or does it search through documents in place"](#do-you-want-to-insert-documents-or-does-it-search-through-documents-in-place).

### Site search vs document search

Website search has different constraints then lokal document search. Search on a website needs to respond fast and handle many concurrent queries, you also need to index the entire website. The amount of information is usually smaller compared to document search. 

In document search you throw many documents into the machine and search through all of them. The documents can be files, but also logs or metrics. 

Here are some site search libraries I've seen in the thread. Some focus on being fast after building your static website, others focus on being small.

- https://github.com/zincsearch/zincsearch
- https://github.com/askorama/orama
- https://github.com/CloudCannon/pagefind https://pagefind.app/ 
- https://github.com/kbrsh/wade

Specifically JavaScript site search:
- https://github.com/projectEndings/staticSearch
- https://github.com/quickwit-oss/tantivy
- https://github.com/lucaong/minisearch
- https://github.com/iacore/fuzzbunny/

### Do you want to insert documents or does it search through documents in place?
Inserting documents means the search engine can pre-process the document and create data structures that make search faster. It also means you have to keep things in sync. Search becomes a  service that applications connect to. On the pro site, it will only index files that you insert into it, but it means you have to put the documents in first.

Elastic, mellisearch and solr are services that you must insert documents into.
Even [sqlite with full text search](https://www.sqlite.org/fts5.html) is a service of some kind that you bring docs into.

ripgrep and www.recoll.org do things on your disk, but recoll indexes your files and so sort of brings the files into it, but it does not require you to send documents to it.

### Do you want to stream, save and search through logs or metrics?
There are specialized heavy duty solutions for logs and metrics, from elastic search to clickhouse to mellisearch. 

Clickhouse is an interesting candidate, because it is an analytical database. So if you have analytical workloads you might not need another search tool because the text search in clickhouse is really fast.


## Notes
_I created this post on the 18th, but published it on the 30th_

image [from unsplash](https://unsplash.com/photos/a-woman-sitting-at-a-table-with-a-camera-in-front-of-her-Sn5oPeictgw) by [Wilhelm Gunkel](https://unsplash.com/@wilhelmgunkel)