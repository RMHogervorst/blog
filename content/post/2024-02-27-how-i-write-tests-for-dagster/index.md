---
title: how I write tests for dagster
description: "How and what I test for dagster. Also a few handy tidbits"
subtitle: "unit-testing data engineering"
date: 2024-02-27T15:03:59.862Z
preview: ""
draft: false
tags:
    - Dagster
    - testing
    - data_engineering
categories:
    - blog
difficulty:
    - intermediate
---

It is vital that your data pipelines work as intented, but it is also easy to make mistakes. That is why we write tests.

Testing in Airflow was a fucking pain. The best you could do was create a complete deployment in a set of containers and test your work in there. Or creating python packages, test those and hope it would work in the larger airflow system. In large deployments you could not add new dependencies without breaking other stuff, so you have to either be creative with the python /airflow standard library or run your work outside of airflow. And so you ended up with the situation where you use airflow (written in python, running in the cloud) to call a machine (in the same cloud) to run a python process to transform some data. We ended up with airflow spinning up spark nodes, installing packages on that node, airflow calling out to the machine after installation to run a process, and finally airflow deleting the machine afterwards. Testing that whole process required your dev machine to spin up airflow with all whistles and bells, and to have access to the same resources. It was not pretty. 

## Dagster makes it easy to test locally
Dagster on the other hand runs fine locally, it is a single command, it spins up the same UI as on production and has sane defaults. In Airflow every component in the graph is seperate, there is not sharing of data in between steps. In dagster the result of every 'op' has an in and output, and you connect those components together. And you can create the basic structure of your data transformation in python with all the libraries you want and only swap out the in and output, while changing absolutely nothing in the inner code. That is revolutionary. 

I can make sure my data transformation works, I can run tests based on a csv or local parquet file while in production the same code uses a database table. 

## Designing for testability
I usually try to set up jobs / asset jobs in a way that seperates **actions** from **calculations**. 

* Calculations are functions without side effects, for instance filtering out all the rows of a certain type. Calculations only depend on the input, and if you redo the calculation with the same data your result will be te same. 
* Actions have side effects such as writing to disk, or reading from somewhere. But also things that depend on a time of the day. I do try to setup actions in an idempotem way, so that writing to disk twice, will result in only one file, and writing to a table partition will overwrite that same partition and not create duplicate rows. In dagster you can use io_managers to perform actions, that way you abstract away the reading and writing from external systems, making you focus only on the transformation part. That way you can keep your job/asset graph very clear. 

## Testing according to dagster
Dagster has a [clear philosophy on testing](https://docs.dagster.io/concepts/testing#unit-tests-in-data-applications): 

*   Principal: Errors that can be caught by unit tests should be caught by unit tests.
*   Corollary: Do not attempt to unit test for errors that unit tests cannot catch.

They say it is not useful to simulate complex systems like spark or a datawarehouse. You can capture syntax error, configuration errors, graph structure errors (what operations follow what) and errors following refactoring. 

## What I test
Here is what I test. We are using pytest. 

We unit test:
- individual helper functions (used in ops)
- ops (and assets): verify that input x, results in output y
- configuration helpers: partition creation, config creation
- custom sensors: making sure they run under the conditions we set
- resources

We use integration tests for all the graphs and jobs. 
You can mark tests in pytest with the `pytest.mark` decorator and you can run those tests seperately. For example, you can mark the tests of jobs and graphs with  `@pytest.mark.integration` 

You can then run only the unit-tests with (explicitly not) `pytest -v -m "not integration"` or un the integration tests alone with  `pytest -v -m integration` 

We also create a few generic tests, more like linting, to make sure our ops, jobs, graphs, sensors, and schedules follow good practices. For instance we make sure all our schedules have explicit 'UTC' or 'Amsterdam/Europe' timezones _(because that bites you otherwise)_. And we make sure all our jobs have a description, and all jobs that use a certain resource have a tag for that resource (because we can limit the number of simultaneous jobs of that type).

## Tests can give you the confidence in the system
While there could still be problems between database and Dagster, I am very confident that the transformations will be correct. I'm also confident in the graph logic (what steps happen when). I can test the flow from beginning to end. 