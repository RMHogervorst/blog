---
title: "The city, neighborhoods and streets: Organizing your MLproject"
author: Roel M. Hogervorst
date: '2022-10-25'
slug: organize-your-mlproject
categories:
  - blog
tags:
  - intermediate
  - development
  - modular-projects
  - optimize-your-code
description: 'Have you received a project that someone else created and did it make you go 🤯? Sometimes a project organically grows into a mess of scripts and you don't know how to make it better. The main problem is often the project organization. I want you to think about, and organize, your project in three levels that I call city-level, neighborhood-level and street-level. In this post I will explain how to do that.'
subtitle: 'reduce your mental load by using conventions'
share_img: '/blog/2022/10/25/organize-your-mlproject/kyler-boone-GRu2e_Z01-o-unsplash.jpg'
output:
  html_document:
    keep_md: yes
---

<!-- content  -->
Have you received a project that someone else created and did it make you go 🤯?
(Was that someone else: you from a few months back?[^1] ) Sometimes a project organically grows into a mess of scripts and you don't know how to make it better. 

The main problem is often the project organization. I want you to think about, and organize, your project in three levels that I call city-level, neighborhood-level and street-level. This structuring helps you, your collaborators and yourself in 2 months.

![Tokyo from above](kyler-boone-GRu2e_Z01-o-unsplash.jpg)

### city level:  overall organization of the project
On this level almost every machine learning project has the same components:

- retrieve data (features) from a source system ([you are not getting it from csv are you?](https://blog.rmhogervorst.nl/blog/2022/08/15/data-ingestion-patterns-for-ml/))
- Split data into training and test sets (_we split before we transform so we do not leak training information into the testset_)
- Create transformations (_on training data, apply those to test data too_)
- Train model (_on the trainingset_)
- Evaluate model performance (_on the testset_)
- make decisions on further deployments

There are some strategic choices to make here, but it is mostly the same for every project. 

Here is a rough sketch of the main function in python.
This main function describes the high level  (city level) design, you know 
where to look for details.

```python
from dataloader import load_data
from split import split_data
from features import create_features
from model import model
from decision import make_decision


def ml_project():
	"""Run the entire project"""
	# get the data
	data = load_data()
	# split it
	training, test = split_data(data)
	# create transformations on data
	X_train, y_train = create_features(training)
	X_test, y_test = create_features(test)
	# train model
	trained_model=model.train(X_train, y_train)
	# evaluate model
	evaluation =model.eval(X_test, y_test)
	# make decision
	make_decision(evaluation)
	
if __name__ == "main":
	ml_project()
```


In R a package is often more convenient, use one file to define the overall logic. 
For example `R/main.R`:

```R
#' Run the entire project
#'
#' This is the main function that gets the data,
#' trains the model, evaluates performance and
#' finaly makes a decision.
#' @export
#' @examples
#' main()
main <- function(){
	data <- load_data()
	data_split <- split_data(data)
	training <- training(data_split)
	testing <- testing(data_split)
	workflow <- get_workflow(training)
	model_fit <- fit(workflow, data=training)
	result <- evaluate_model(model_fit, data=testing)
	decision(result)
}

```

### neighborhood level: organization within a component
For example: this is how you would organize the component **retrieving data**.

- load settings
- connect to datasource
- get data

Each of these points can be small or big and consists of smaller decisions.

![A neighborhood in Utrecht](martin-woortman-aMYrbqCTMu4-unsplash.jpg)


In python the retrieving data part looks like this.
For example `dataloader.py`:
```python
# imports here

def load_data():
	"""main function to retrieve data"""
	# we put all the neighborhood level steps here
	load_settings()
	db_con = get_db_connection()
	data = retrieve_data(db_con)
	return data

# here you define the functions you use in load_data()

```
In R we create a new file for example `R/load_data.R`:

```r
#' Main function to retrieve data
load_data <- function(){
	load_settings()
	db_con <- get_db_connection()
	data <- retrieve_data(db_con)
	data
}
```


### street level: low level decisions
In the street level we create the low level details. 
How do we retrieve the database details, how do create a daily average, etc.

Here for example **Connect to datasource**: 
- get credentials from environmental variable
- make a connection object
- pass the connection object to the data loader

![Street in Utrecht, Netherlands](robin-ooode-XusR7PXCV0o-unsplash.jpg)

I would put these low level decisions in the underlying functions. Like so:

```python
# see above
# here you define the functions you use in load_data()

def load_settings():
	"""if necessary"""
	pass

def get_db_connection():
	"""f.i. sqlalchemy connection"""
	db_dict = {
		"username":os.environ["username"],
		"password":os.environ["password"],
		"database":os.environ["database"],
		"url":os.environ["url"],
		"port":os.environ["port"]
	}
	engine = create_engine(f"postgresql+psycopg2://{username}:{password}@{url}:{port}/{database}")
	return engine

def retrieve_data(db_con):
	# load maybe a sql query, or instructions
	# use the db_con to get the data
	return data
```

In R you do a similar thing. 

```R
get_db_connection <- function(){
		con <- dbConnect(
	  bigrquery::bigquery(),
	  project = "publicdata",
	  dataset = "samples",
	  billing = billing
	 )
	con
}


retrieve_data <- function(db_con){
	dbGetQuery(con, sql)
}


```

## Organization helps you think
![](geojango-maps-Z8UgB80_46w-unsplash.jpg)

By organizing your code in different levels you can focus on the right things at the right time. We can spend our mental energy wisely and not be distracted by other things. 

- Do we talk about global order of operations _(city level)_? We don't want to think about or look at the low level _(street-level)_ details like database credentials, or the specific query that is used to retrieve the data.

- Is there a problem in the way data is retrieved _(a neighborhood level issue)_? You only need to look into the data retrieval module. 
- You want to swap out the model used, and plug in a different model? You only need to modify the training module. 



[^1]: [I wrote about this in 2016: **your most valuable collaborator, future you**](https://blog.rmhogervorst.nl/blog/2016/05/26/your-most-valuable-collaborator-future-you/)


### Images

- [Tokyo ](https://unsplash.com/photos/GRu2e_Z01-o) by [Kyler Boone](https://unsplash.com/@kylerb)
- [A neighborhood picture](https://unsplash.com/photos/aMYrbqCTMu4) by [Martin Woortman](https://unsplash.com/@martfoto1) 
- [A street in Utrecht](https://unsplash.com/photos/XusR7PXCV0o) by [Robin Ooode](https://unsplash.com/@robinoode)
