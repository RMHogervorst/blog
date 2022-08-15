---
title: Reading in your training data
author: Roel M. Hogervorst
date: '2022-08-15'
slug: data-ingestion-patterns-for-ml
categories:
  - blog
tags:
  - development
  - explainer
  - mlops
  - quickthoughts
  - advanced
subtitle: 'Data Ingestion Patterns for ML'
share_img: '/blog/2022/08/15/data-ingestion-patterns-for-ml/adli-wahid-Nw0IoLcLHeQ-unsplash.jpg'
output:
  html_document:
    keep_md: yes
---
<!-- content  -->

How do you get your training data into your model? Most tutorials and kaggle notebooks begin with reading of csv data, but in this post I hope I can convince you to do better. 
![A man pushing a trishaw with a heavy load in the street of Dhaka, Bangladesh. (This is how I feel when I wrangle a csv that could have been a parquet file)](adli-wahid-Nw0IoLcLHeQ-unsplash.jpg)



I think you should spend as much time as possible in the feature engineering and modelling part of your ML project, and as little time as possible on getting the data from somewhere to your machine.

Here are some ways of getting data into the modelmaking machine I have seen in the wild (or build myself):

* reading csv from disk
* read from database query
* read from data warehouse table
* read from cloud storage (s3, azure, gcp, minio, etc)
* read from feature store.

### CSV from disk
For a single exploration, csv works fine. You don't care that much data loading about issues. But when you want to automate your trainingdata ingestion things become troublesome. 
CSV seems simple, but it is awful on several levels. What kind of format do you use? European (;-separated) values or American (,-separated) values? Are you actually using tabs as separators? Did you accidentily touch the file with excel?[^1]

[^1]: The real question you should ask yourself is:"Where did this data come from? Who created this CSV?" Because nine out of ten times it came out of a data warehouse, why didn't you read it directly from the data warehouse into your system?

In reality your data is never perfectly formatted and since CSV has no types, your machine will happily read in numbers as text or dates as text and don't even get me started on missing values!

Reading in csv data in an automated way can be done, but requires a lot of guardrails against expected issues, type conversions and weird stuff in the translation from csv to useful data. Is all this code and effort a valuable spend of your time? This is not where you want to be.


### Read from a production application database with a query
You probably know a enough SQL to get data from a database. In this case you can write a query that by joining several tables together directly retrieve the information you want from the production database. 
Unfortunately you have to make monster queries of six or seven tables joined together, because the production database is optimized for whatever application it serves, not optimized for data scientists' queries. 

There are definite advantages: you have full control over the query, databases know what the type is of their columns and both R and python have great libraries to translate that type to the available data.frame types. Missing values are correctly missing and datetimes mostly 'just' work[^2]. You know your data is up to date because you pull it directly from production.

[^2]: Ah, dates, they seems so simple but are so so hard! The eternal mysteries of SQLServer datetime that starts at January first 1753, Or excel format differnences between mac and pc! Who knew there were so many things that could go wrong [Falsehoods programmers believe about time](https://gist.github.com/timvisee/fcda9bbdff88d45cc9061606b4b923ca) 

There are also disadvantages: Directly querying an application database is dangerous. Application databases are made for applications, not for analytical queries. You will put load on the database. Do you want to be the one that takes the production database down with your queries?
Other issues are the sheer amount of complexity you have to maintain to query the database is quite a lot of work. This is not where you want to be.

### Read from data warehouse

If you are lucky, there was an effort to turn production application data into easily understandable data in a data warehouse (offer a small prayer for the poor data engineers who did the whole table joining operation for you! And they have to maintain it too). A data warehouse is a analytics optimized 'database' that can handle massive ammounts of data. Now the business analyst and data scientist (you!) have a more unified and cleaned version of the data. You still have to write a SQL query, but it is much easier than a massive monster query on the production application database. 

Again if you load directly from a table (or view, or query) your programming language of choice usually knows how to translate the datatype from the data warehouse to the datatype of your data frame[^3].

[^3]: Do you see why it is extra work if you first export your query to csv and load that csv in your data frame afterwards? (first you convert all the beautiful and rich information into text (csv) and later convert  it back to types in your data.frame.)

Reading from a view or table in a data warehouse is usually pretty easy and fast. Your machine does need credentials to talk to the data warehouse.

### Read from cloud object storage
Some organizations do not have a data warehouse, they put everything in object storage in the cloud. This is much cheaper and is called a data lake. 
Hopefully the data is in a format that remembers type, for example parquet (column optimized) or avro (row optimized). You might have to read in several files, join them up, filter away unnecessary rows and start your modeling on the results. If the files are large you might need specialized tools or engineering help to get it done. In the end you end up with data that can be used for your modeling pipeline.

Data lakes are notoriously hard to navigate. If there is a lot of data and you get lost easily data lakes can become data swamps. On the other hand you cannot take down production with your queries and you are extremely free to do what you want with the data. Your machine does need credentials to access to the data lake.

### Read from featurestore
If you have multiple teams working on similar data, or if you have sub-second latency requirements for your models you can look into a feature store.

A feature store, stores .. features. It stores data and calculated transformations of your data. For example; if you have timeseries data you often want to decompose the values over time into components (trend, repeatable patterns), and use several types of aggregations (avg_last_week, avg_yesterday, min_last_week, median_this_year), or do some other transformations. Wouldn't it be nice if everyone in your company could use the same features you came up with? That is what the feature store does for you: you define several features and the featurestore can deliver those to you and your work friends. No more differences in how you calculute avg_last_week, no more reinventing feature engineering steps for every new project. You call the featurestore and request exactly what you want. Featurestores can deliver fast features for inference, but also the same transformations on historic data for training purposes. It doesn't matter that old values are stored in cloud storage and recent values in a different database, a feature store is an abstraction that takes away all that hard work for you, so you can focus on modeling. 

But a feature store is a major investment if you don't already have it, and setting it up for every new datasource could be very time consuming. 

## Recommendations

!['on a tight leash' a toddler pulls on leash, small dog doesn't move. (A recognizable struggle for anyone who needs to query seven database tables to get a sales table) ](vidar-nordli-mathisen-cSsvUtTVr0Q-unsplash.jpg)

* stop turning perfectly good information from the database into garbage csv, seriously, stop it. If you must export it to a fileformat take a modern type aware format.
* take a good look at the amount of effort that goes into each project to get the data in the format you want. what parts can you aggregate over several projects? Can your ETL tool / scheduler maybe do work for you? Maybe you can just read from a single view or table that has the data in the form you want. Or from a single file in a object storage bucket?
* if you have multiple projects it could be advantageous to move the get-the-data-into-a-single-place part to a separate project, or into a feature store. Your model code becomes much simpler. And simpler code is easier to maintain and easier to change. And in practice that means faster development.

# Getting data is also part of ML project
So these are some of the things I have seen, with many forms in between: schedulers that combine several data warehouse tables and dump the result as csv, views on top of production application databases that can be easily read in (hiding the complexity really). 

Getting data for your training or inference is an important part of machine learning projects. And how you do this is an engineering decision. You (and your team, and your organization) need to trade off simplicity and maintainability. And you need to clearly define who is responsible for what. I think it is worth it to strive for minimal data reading code. 


## Sources
* image of 'A man pushing a trishaw with a heavy load in the street of Dhaka, Bangladesh' by <a href="https://unsplash.com/@adliwahid?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Adli Wahid</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
* image 'on a tight leash'  by <a href="https://unsplash.com/@vidarnm?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Vidar Nordli-Mathisen</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
    