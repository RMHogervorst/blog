---
title: OpenSanctions is an amazing example of entity resolution at scale
description: ""
subtitle: ""
date: 2024-04-26
preview: ""
tags:
    - data_engineering
    - data_science
    - entity_resolution
categories:
    - blog
difficulty:
    - advanced
post-type: 
    - post
share_img: ""
image: ""
---

In my previous post I talked about entity resolution and how data science plays a role. I am a big fan of OpenSanctions, and their process (entirely open) is a beautiful example of Entity resolution. 

OpenSanctions is an international database of persons and companies of political, criminal, or economic interest. It's a combination of sanction lists, publicly available databases, and criminal information. Companies can use this information to check their customers, to prevent money laundering and sanction evasion. 

They scrape public lists, combine that information into one overview and create an API that is useful for the entire world. This is an amazing public good, it is in everyone's interest that criminal money does not flow into the legitimate economy^[^1]. 

I want to look at what OpenSanctions does, from the entity resolution viewpoint; that is preprocess, indexing, comparison, merging. But first let's describe the problem:

Every government publishes sanction information. Some people / companies are on multiple lists, there are no standards, every government is doing their own thing. 

What you want, is a merging of all identical persons and identical companies. You want a merging of all their properties from the different sources, so you can search through these persons and companies and find one single entity if there is one. You want unified data. And that means Entity Resolution.

### Preprocessing
The datasets are incredibly diverse, and changing (people are added or removed from sanction lists). We don't know exactly what the data looks like, but we do know that it contains persons, companies and related objects. 
Data formats are horrible actually, some countries publish in PDF ( God, why?), excel ( again, why?),  some use open formats such as CSV, or publish it on the web in the form of html.

The approach of OpenSanctions is to create scrapers that emit information in a rich intermediate format, the FTM format. _(created by journalist collective)._ That means that scrapers are created specifically for specific sources, but the data on the other side of the pipeline is very structured and easily comparable. Because we understand what a person is, we can map dissimilar pieces of data to one model: a person has a name, a date of birth, lives somewhere, has one or more nationalities etc. There is a strong semantic data model. 

### indexing (blocking)

>  the system now considers term frequencies in scoring possible candidates, handles text transliteration into the latin alphabet, and it is tolerant against spelling variations thanks to its ability to compare character fragments (so-called ngrams) in names.

### Comparison

Those fragments are compared against known data and consolidated.

Manual decision for every example (text based user interface)

Meaningful features on dates, countries names. Finally great merge process Wikidata ID as ID.

USe knowledge that sanctionlist is already deduplicated (don't need to compare with itself)


### merge
Keep track of already decided. Merge everything down.
create unique id (use wikidata)


## Notes
[^1]: There is already too much plutocrat money in our economies, and gross amounts of tax evasion. Unfortunately that is not in OpenSanctions, probably because it is only immoral, and not illegal. 


<https://www.opensanctions.org/>
- [opensactions data dictionary ](https://www.opensanctions.org/reference/)
- https://followthemoney.tech/
> FollowTheMoney (FtM) is a data model for anti-corruption investigations. It contains definitions of the entities relevant in such research (like people or companies) and tools that let you generate, validate, and export such data easily. Entities can reference each other, thus creating a graph of relationships.

- https://www.opensanctions.org/articles/2021-11-11-deduplication/
- https://www.opensanctions.org/docs/identifiers/ 

> The newly imported entity will be matched against all the existing records in the system, and an analyst decides whether to merge it with one of the existing profiles. This usually takes place 12 to 72 hours after a new entity is collected from the data source.
If the entity was merged with others, the combined entity will be assigned an ID using the format NK-xxxxxx. NK IDs are random unique text identifiers. They are sometimes called canonical IDs in the data and documentation.
If the merged entity describes a person, it may also be identified using a Q-ID (e.g. Q12345). Q-IDs are Wikidata item identifiers. They are preferred over NK- identifiers.