---
title: 'Data Science Technical Terms: Job Titles and Fields'
author: Roel M. Hogervorst
date: '2022-01-29'
slug: data-science-technical-terms-job-titles-and-fields
categories:
  - blog
tags:
  - data_science
  - mlops
  - jobtitles
subtitle: 'MLE, AE, DE, DS, WTF?'
image: '/img/presentation_images/wocintech01.jpg'
output:
  html_document:
    keep_md: yes
  
---

<!-- content  -->
What do I mean when I talk about MLops, Machine Learning Engineering, or data science?
I call myself data engineer, data scientist, or machine learning engineer. But never 
an analyst. To me these job-titles all have a certain meaning, although they overlap.

Here is what the job titles mean to me, right now. 

The first thing you need to keep in mind is the size of the organization the size
of the data team and the data-maturity of an organization. 

## Level 1, smaller and less data-mature orgs
In small and less data-mature organizations there are a few people who do everything
from running experiments, to managing the data warehouse, to scheduling data
operations and running Machine Learning models. Many of these people were called
**data-analysts** before, and are often called **data scientists** now. We can give fancy extra titles like **full-stack data scientists** but in this phase these people wear many hats. 

## Level 2, medium data-mature orgs
When teams and organizations grow to medium data-maturity, the responsibilities are spread over multiple
teams. These teams specialize and the people in those teams need titles to distinguish them from other teams. 

* A data analyst / Business analyst has a focus on analyzing data from the past and reporting to management how the organization is doing. 
* A data scientist has a focus on predictive models (more about what is going to happen)
* A data engineer works less with models and more with large volumes of data, making sure the data that lives in several systems goes into one system (a data warehouse) to enable data-analysts and data-scientists to do their work. 

## Level 3, even more data-mature orgs
And sometimes teams grow even bigger, and organizations more data-mature. That leads to even finer distinctions. 

* Maybe you need a business analyst / data analyst that is skilled in supporting the rest of the business analyst team with automation and transformations of data. That new role is now called an **analytics engineer** and we can place it somewhere between the analyst role and the data engineer role. 

* Keeping multiple machine learning solutions alive, integrated into the organization and up to date requires a mix of expertise between software engineering and in the machine learning, and so these people get the job title **Machine Learning Engineer**. In fact this world of engineering has so many unique challenges that we created a new word for the entire field *Machine Learning Operations* or **MLops*^1.  

# Activities and job-titles
To a certain extend any of these roles will touch a piece of python code, or
write a SQL statement. But some activities are more associated with certain job
titles, in my mind.

![a dog with glasses that looks at a laptop](cookie-the-pom.jpg)

* business analyst: Creating a dashboard or report of monthly revenue by querying the data warehouse.
* Machine learning engineer: Making sure the prediction model is retrained whenever accuracy of the last 5 days is below the threshold. 
* Analytics engineer: Refactoring multiple SQL scripts into smaller parts that can be compiled together (with dbt mostly) so everyone in the org is using the same definitions. 
* Data engineer: Changing a pipeline so data from an external service flows in the right form into the data warehouse. 

_top image from [women of color in tech](https://www.wocintechchat.com/blog/wocintechphotos)_

^1: never AI-ops. I mean no one knows exactly what AI is, it's more a dream than reality and MLEs are very grounded people.