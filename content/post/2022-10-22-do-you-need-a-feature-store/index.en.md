---
title: Do you Need a Feature Store?
author: Roel M. Hogervorst
date: '2022-10-22'
slug: do-you-need-a-feature-store
categories:
  - blog
tags:
  - mlops
  - featurestore
  - intermediate
  - tools
subtitle: 'From simple to advanced'
share_img: '/blog/2022/10/22/do-you-need-a-feature-store/erda-estremera-sxNt9g77PE0-unsplash.jpg'
output:
  html_document:
    keep_md: yes
---

<!-- content  -->

A feature store is a central place where you get your (transformed) training and prediction data from. But do you need this? Why would you invest (engineering effort) in a feature store?[^2] 

![image of a dog in a box, it's features in one place, kinda?](erda-estremera-sxNt9g77PE0-unsplash.jpg)


All engineering is making trade offs, a feature store is an abstraction that can lead to more consistency between teams and between projects. 
A feature store is not useful for a single data scientist for a single project. It becomes useful when you do multiple projects, with multiple teams.  


But we should not let the technology dictate our actions, so let's explore how you might end up with the need for this specific abstraction.  

## Project complexity
As the number of projects grow you might see the same pattern again and again;  code becomes unwieldy, difficult to understand and difficult to change. 

![a picture of messy workspace with paint everywhere, this is like code being messsy. ](ricardo-viana--tYsPFKMm7g-unsplash.jpg) _Does your project look like this?_

For the computer it does not matter if we put code in separate files or all in one file. But code is not only executed, it gets read by humans too. And more importantly, it needs to be changed over time, and if you don't understand the code in a project, you cannot make effective changes. 

Some of the code is high level, and some of it is very low level. And to help yourself and your team mates, we separate that messy code and untangle it so we can more easily reason about it.We **create an abstraction** to reduce our mental load.

This might sound a bit vague so let me describe a more concrete example and how you would abstract some parts to help yourself and your team.

## Forecasting puzzle sales
Let us imagine a forecasting project. In forecasting projects we work with time series data, data that describes the same measure over time. For example: sales every day of the week.
We can use historic sales data to forecast sales in the future.


For forecasting you often create many time based features: averages, maximums and minimums per week, per month, or per day. You might want to mark holiday periods, special events and other things that have impact on your sales. 

Using these time based features is super useful. But the part of your code that retrieves and transforms the input data becomes pretty big. If you use notebooks, this might be a notebook in itself. A lot of code for one project is not necessary a problem, but you have to duplicate a lot of that code for every new time series project. There must be better options.

## abstraction: package

If you find yourself copying a lot of code from different projects, you might want to create a package that you can import functions from like this:

```python
from timeseriesbuilder import avg_week, avg_day, avg_quarter`

def feature_creation(dataframe):
  dataframe["avg_week_sales"] = avg_week(dataframe["sales"])
  dataframe["avg_day_sales"] = avg_day(dataframe["sales"])
  dataframe["avg_quarter_sales"] = avg_quarter(dataframe["sales"])
  return dataframe
```
or this

```r
library(timeseriesbuilder)

feature_creation <- function(dataframe){
  result <- dataframe |>
    mutate(
      avg_week_sales=avg_week(sales),
      avg_month_sales=avg_month(sales),
      avg_quarter_sales=avg_quarter(sales)
      )
  result    
}
```


With a custom made package you can create the functions once, and import them in all your projects. You can add tests and documentation too. This makes your code probably easier to understand and everyone across the teams uses the same definitions (_you would not believe how often definitions are not standardized between teams in the same company!_).

![an empty box, representing a package](kelli-mcclintock-GopRYASfsOc-unsplash.jpg) (_Why don't we put all the logic that we use in several projects into one box, and reuse that box?_)

Using a package and importing that in all your projects is a great solution to growing code complexity. However a large chunk of your code base is **still** about transformations. And if you need to re-calculate the same features in different projects, you might wonder if we cannot do this in a better way. If we pull data from the same database table and always calculate the same features, you might consider adding another table or view that already does these calculations and read your data from that derived table or view. But is it worth the trouble, and will it keep up to date? Who will maintain this logic? 

You might also find yourself maintaining data logic for inference and training, you might read files[^1] for training and calling an cached endpoint for inference. There must be a better way!

## abstraction: feature store.
What if you take the logic to create the features and put that in a central place that everyone in the team can use. **That is a feature store.**
You keep all the logic about features and its documentation in one place. 

![another empty box, yes boxes represent abstractions](kelli-mcclintock-ANp23FdOOls-unsplash.jpg)

The feature store makes sure to use the same logic for fast live data for inference and slower larger datasets for training. It reads from the source systems and transforms the data into the features you want and you only read in that transformed data. 

```python

# retrieve the data like this
trainingset =get_features(
  dataset="puzzlesales",
  features=[
  "avg_week_sales",
  "avg_month_sales",
  "avg_quarter_sales",
  ]
)

```

Instead of creating low level connections to multiple database tables to retrieve a certain set of columns you select already transformed features from one place. Instead of loading data, transforming it and model with the results, you only pull already-transformed features into your model. 

Over multiple projects this can lead to significant code reduction and can result in consistency over projects. If the calculations are expensive and need to be done for many projects, the results can be cached on the feature store and only need to be calculated once. 

# Conclusion
Do you need a feature store? That depends on the size of your team and the number of projects. It is a significant investment of effort and time. But it can give you consistent feature definitions over all your projects, and as a bonus, faster retrieval times. 
When maintaining feature logic becomes a burden you should probably look into feature stores.


You don't start with a feature store, you grow into the need.


[^2]: I'm not the only one asking why you would need a feature store. [This redditor asks the same question](https://www.reddit.com/r/mlops/comments/y9ih48/eli5_feature_stores/)
[^1]: But you might want to skip csv files and use something (anything) better <https://blog.rmhogervorst.nl/blog/2022/08/15/data-ingestion-patterns-for-ml/>



## image credits
- pictures taken from <a href="https://unsplash.com/">Unsplash</a>, from authors  <a href="https://unsplash.com/@kelli_mcclintock?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Kelli McClintock</a> , <a href="https://unsplash.com/@erdaest?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Erda Estremera</a> and  <a href="https://unsplash.com/@ricardoviana?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ricardo Viana</a> 
  
    