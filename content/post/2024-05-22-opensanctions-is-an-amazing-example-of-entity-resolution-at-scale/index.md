---
title: OpenSanctions is an amazing example of entity resolution at scale
author: Roel M. Hogervorst
date: '2024-05-22'
categories:
  - blog
tags:
  - data_engineering
  - data_science
  - entity_resolution
difficulty:
  - advanced
post-type:
  - post
image: "/blog/2024/05/22/opensanctions-is-an-amazing-example-of-entity-resolution-at-scale/PhilippSchmitt-AT&TLaboratoriesCambridgeDataflock-1280x914.jpg"
---

In one of my previous post I talked about [entity resolution and how data science plays a role](/blog/2024/04/24/entity-resolution-for-data-scientists/). I am a big fan of OpenSanctions, and their process (entirely open) is a beautiful example of Entity resolution. 

OpenSanctions is an international database of persons and companies of political, criminal, or economic interest. It's a combination of sanction lists, publicly available databases, and criminal information. Companies can use this information to check their customers, to prevent money laundering and sanction evasion. 

They scrape public lists, combine that information into one overview (resolving entities) and create an API that is useful for the entire world. This is an amazing public good, it is in everyone's interest that criminal money does not flow into the legitimate economy[^1]. 

I want to look at what OpenSanctions does, from the entity resolution viewpoint; that is preprocess, indexing, comparison, merging. But first let's describe the problem:

Every government publishes sanction information. Sanctions are one of the ways we put pressure on regimes, it makes it a crime to trade with people or companies on that list. Unfortunately sanctions are not 
machine readable. There are no standards, every government is doing their own thing.
Furthermore not only sanctions are important, you don't want to provide services to criminals, and
it is extremely important that all business with politically exposed persons (PEPs; like ministers, justices, presidents) are clean and above water (think corruption).
Some people and organizations are on multiple lists. 

_For instance Ruja Ignatova
is also known as the 'Crypto queen'[^3]. She is involved in the OneCoin fraud[^2].
Ruja Ignatova is on an interpol international arrest warrant and on the FBI's most wanted list._ 

What you want, is a merging of all identical persons and identical companies. You want a merging of all their properties from the different sources, so you can search through these persons and companies and find one single entity if there is one. You want unified data. And that means Entity Resolution.

![A laptopogram based on a neutral background and populated by scattered squared portraits, all monochromatic, grouped according to similarity. The groupings vary in size, ranging from single faces to overlapping collections of up to twelve. The facial expressions of all the individuals featured are neutral, represented through a mixture of ages and genders.](PhilippSchmitt-AT&TLaboratoriesCambridgeDataflock-1280x914.jpg)

### Preprocessing

The datasets are incredibly diverse, and changing (people are added or removed from sanction lists). We don't know exactly what the data looks like, but we do know that it contains persons, companies and related objects. 
_Data formats are horrible actually, some countries publish in PDF ( God, why?), excel ( again, why?),  some use open formats such as CSV, or publish it on the web in the form of html._

The approach of OpenSanctions is to create scrapers that emit information in a rich intermediate format, the [FTM format](https://followthemoney.tech/explorer/). That means that scrapers are created specifically for specific sources, but the data on the other side of the pipeline is very structured and easily comparable. Because we understand what a person is, we can map dissimilar pieces of data to one model: a person has a name, a date of birth, lives somewhere, has one or more nationalities etc. There is a strong semantic data model.

### indexing (blocking)

I showed some simple indexing techniques, [in the previous post about entity resolution](/blog/2024/04/24/entity-resolution-for-data-scientists/), but OpenSanctions uses many advanced features to create merge candidates.

>  the system now considers term frequencies in scoring possible candidates, handles text transliteration into the latin alphabet, and it is tolerant against spelling variations thanks to its ability to compare character fragments (so-called ngrams) in names. ---[deduplication (open sanctions)](https://www.opensanctions.org/articles/2021-11-11-deduplication/)

### Comparison
Every scrape ends up with pieces of information called fragments. Fragments contain things like `{person: Hank, id: something2340101, fragments:  {age: 43, streetname: somethingstreet}}`.  
Those fragments are compared against known data. You can do smart comparisons, you don't need to compare against the list itself (we can assume the list is already deduplicated), and you can compare first
against the already consolidated entities (richer in data). 

Comparison is done in [a text interface that shows and highlights the differences](https://github.com/opensanctions/nomenklatura).

### merge
Consolidation of new entities (persons, organizations) could be done automatically, but OpenSanctions makes a manual decision for every new entity resolution. 
The merge process that OpenSanctions uses, [creates an unique ID for every entity](https://www.opensanctions.org/docs/identifiers/).
When possible they choose an wikidataID as unique ID. This is really useful because wikidata has rich information as well, so you can enrich further.

## OpenSanctions as a great example of Entity Resolotion at scale
I think OpenSanctions is incredibly inspirational. They work with a small group of employees, some volunteers and everything they do is open; the datasets, the process, the code. The endresult is an amazing resource, used by banks, financial institutions (_everyone who has to know their customer_; KYC) governments and journalists. Their entity resolution process is well thought out and effective, honestly, just really great work!

## Notes
[^1]: There is already too much plutocrat money in our economies, and gross amounts of tax evasion. Unfortunately that is not in OpenSanctions, probably because it is only immoral, and not illegal. 
[^2]: I mean, all cryptocurrencies are scams, but this one didn't even have a cryptocurrency!
[^3]: A fascinating podcast <https://www.bbc.co.uk/sounds/brand/p07nkd84>