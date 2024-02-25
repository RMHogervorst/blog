---
title: Evolution of Our Dagster File Organization
author: Roel M. Hogervorst
date: '2024-02-24'
slug: evolution-of-our-dagster-file-organization
categories:
  - blog
tags:
  - Dagster
  - pipelines
difficulty:
  - intermediate
subtitle: 'File structures should make your work easier'
image: '/post/2024/02/24/evolution-of-our-dagster-file-organization/american-public-power-association-fHLdXfURDhA-unsplash.jpg'
share_img: '/post/2024/02/24/evolution-of-our-dagster-file-organization/american-public-power-association-fHLdXfURDhA-unsplash.jpg'
---


<!-- content  -->

Whenever you try to do intelligent data engineering tasks: refreshing tables in order, running python processes, ingesting and outputting data, you need a scheduler. Airflow is the best known of these beasts, but I have a fondness for Dagster.

Dagster focuses on the result of computations: tables, trained model artefacts and not on the process itself, this works really well for data science solutions. 

Dagster makes it also quite easy to swap implementations, you can read from disk while testing or developing, and read from a database in production.

So how do you organize the code that runs your business logic?

![A picture of a squid (dagster uses a cuddlefish as logo)](raimond-klavins-HQ1udFC_-7s-unsplash.jpg)

# code organization
Here is how our dagster code evolved over 2 years. 

But first, what components are we talking about?

In dagster we have: 
- 'jobs': a process with at a minimum 1 subcomponent, called an 'op'
- 'ops': logical component for computation (for instance: retrieving data from a database could be an op, transformation could be an op, training a model could be an op, etc.)
- 'resources': reusable components for interacting with the outside; database connectors, api keys, etc.
- 'sensors' and 'schedules': ways to trigger jobs based on conditions, or a time
- 'assets' sort of a job and op hybrid


### organization on component
When we started out we used a folder structure organized by type of component. (I'm not sure anymore, but I belief this was the recommondation by dagster itself). 

High over we have a folder with normal code (repo) and a folder with tests (tests). 
In the repo folder we organize by component. A folder for
ops, jobs, and SQL scripts (we had a lot of custom SQL scripts).


```bash
repo/
|-- __init__.py
|-- jobs/
|	|-- __init__.py
|	|-- retrieve_stuff.py
|	|-- reshuffle_db.py
|	sql/
|	|-- sqlscript1.sql
|	|-- sqlscript2.sql
|-- ops/
|	|-- __init__.py
|	|--op1.py
|	|--op2.py
|--resources/
|	|-- __init__.py
|	|-- db_connector.py
tests/
|--conftest.py
|--ops/
|	|--test_op1.py
|--jobs/
|	|--test_retrieve_stuff.py
|	|--test_reshuffle_db.py
|--resources/
|	|--test_db_connector.py
|-- repo.py
```

This worked fine for a while but there are a few problems.

Sensors, schedules, and assets have no logical place. The distinction on ops don't make sense too. When we set it up, I thought we would create generic operators that we could reuse in several jobs (like in Airflow, where you can create hooks and operators). But in reality that did not happen so much. We defined ops as part of a larger transformation; the job. 

For all processes we effectively create one big file per process. In that file we define everything (the ops and the job). Our files became massive, at the top high level functions and ops. At the bottom of the file lives the job itself and configuration. 

Editors help in jumping around in the code, but the amount of code in one file make it less easy to organize. 

### organization around a job
Over time we were not happy with our approach. There was too much in one file. It is much nicer to organize the code at different levels of abstraction: 

- the job is the highest level of abstraction, the overal goal of the job. This is where the documentation lives, and schedules and settings.
- Every job contains ops, ops do one thing and contain the high level code for that and documentation for the op. 
- small utility functions used in the ops. 

We went one folder deeper and splitted the files. 

```bash
repo/
|-- __init__.py
|-- jobs/
|	|-- __init__.py
|	|-- retrieve_stuff/
|	|	|-- __init__.py
|	|	|-- job.py
|	|	|-- lowerlevel.py
|	|	reshuffle_db/
|	|	|-- job.py
|	|	|-- transformation.py
|	|	|-- sql/
|	|	|	|-- sqlscript1.sql
|	|	|	|-- sqlscript2.sql
|--resources/
|	|-- __init__.py
|	|-- db_connector.py
tests/
|--conftest.py
|--jobs/
|	|--test_retrieve_stuff.py
|	|--test_retrieve_lowerlevel.py
|--resources/
|	|--test_db_connector.py
|-- repo.py
```

In stead of one big file we create a job.py and other files when necessary. 
The job file contains the high level logic, it makes it clear what big steps (ops) are taken to produce an asset. That means the ops themselves hide most of the complexity (in functions that we import from other files in the same folder). 

What you see in the job file is mostly what inputs are expected and what outputs are returned. You also see all the documentation: docstrings in the ops and assets, and descriptions in the job. 
Here you also see where all the metadata is created. 

How the op(erator) transforms the data is a deeper level and you can find that in the other files in the same folder. 

The pros of this approach is that most of the logic lives close to each other. Files that change together, live close to each other. By pulling apart the mega files the code is easier reviewable in a pull request and makes more sense logically.

As the number of jobs grew, it became disorganized again. What if we have several jobs that support one business unit? the dagster UI does not make it easy to filter jobs based on a tag or other metadata (it is slightly better for assets).

### organize based on business
We are now considering restructuring the code around business. 
Putting all the work for a business unit into one folder.
We could easier reuse code for variants of jobs. It makes more sense to add a readme with rich instructions to a project. 
It might even be worth it to create seperate definition-objects for each business unit. That createas a different python process for that part with different python packages, and if it becomes very heavy we could even spin up different rpc servers. 



And so we keep changing our code to make our lives easier. 

![Two linemen working on powerline](american-public-power-association-fHLdXfURDhA-unsplash.jpg)


## Links and further resources
  Image credit: 
- [brown and white fish in water (unsplash)](https://unsplash.com/photos/brown-and-white-fish-in-water-HQ1udFC_-7s?utm_content=creditShareLink&utm_medium=referral&utm_source=unsplash)
- [American Linemen on powerlines](https://unsplash.com/photos/two-linemen-on-cherry-pickers-fHLdXfURDhA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Further reading
- [Dagster guide to structuring your projects](https://docs.dagster.io/guides/dagster/recommended-project-structure)
- [dagster guide to machine learning projects](https://docs.dagster.io/guides/dagster/ml-pipeline)