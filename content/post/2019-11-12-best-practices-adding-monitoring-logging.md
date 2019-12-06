---
title: Best practices adding monitoring logging
author: Roel M. Hogervorst
date: '2019-11-12'
slug: best-practices-adding-monitoring-logging
categories:
  - blog
  - R
tags:
  - best-practices
  - software Engineering
  - data_science
  - SeriesBestPractices 
type: ''
subtitle: '#Rinprod Best practices in software engineering for R: Monitoring and logging'
image: ''
---

https://github.com/RMHogervorst/example_best_practices_ml/commits/feature/monitoring_logging

ADDING LOGGING
  WHY? THE PROCESS WILL RUN WITHOUT YOUR SUPERVISION, EVERY DAY. THE LOGS ARE FOR
  WHEN THINGS ARE GOING WRONG. DESCRIBE KEY EVENTS: HOW LONG DID IT TAKE, WHERE DID YOU 
  GET THE DATA FROM, WHAT VERSIONS ARE YOU USING. YOU OFTEN ADD EXTRA LOGGING STEPS WHEN
  YOU FIND OUT THINGS ARE GOING SLOWER THEN EXPECTED, OR YOU FOUND AN ISSUE AND WANT TO DEBUG
  IT EASIER LATER ON. AS I'VE IMPLEMEENTED IT NOW, THE LOGS ARE NOT THAT USEFUL. IT ONLY
  TELLS US WHAT IS HAPPENING.
  
LEVELS OF LOGGING 
WAYS OF ADDING LOGGING MESSAGES
  NOW IMPLEMENTED LOGGIT WHICH WRITES TO JSON
  THERE ARE SEVERAL OTHER PACKAGES, BUT YOU NEED DIFFERENT LOGGING INSTALLED.
  
rsyslog, logger, send through pushbullet or something  

logger is a very nice package that writes to a file, or whatever you want .
  
WHAT IS MONITORING?
YOU MIGHT WANT TO KEEP TRACK OF PERFORMANCE OF MODELS. NUMBER OF ROWS GOING IN DATA
TIMING. YOU CAN SEND THESE METRICS TO AN EXTERNAL MONITORING SERVICE. THIS VERY MUCH
DEPENDS ON WHERE YOU ARE RUNNING YOUR SERVICE. DATADOG INSTALLS A SERVICE ON YOUR COMPUTER
THAT LISTENS TO EVENTS, AND SENDS THAT TO THE DATADOG SERVICE.

THE MONITOR IS TELLING YOU HOW THE MODEL IS DOING, YOUR PROJECT IS WORKING.
--- NEED MORE RESEARCH HERE!
we run it every day, or multiple times a day and we want to crossvalidate score to be send to a monitoring service. keep track of performance and row counts. we might want to put some constraints on it: if hte rowcount is off by 50% compared to average, is this a problem?
what if the class proportions are very different?

Another great thing is mlflow. I have just seen this package and it takes away so much
of your work. THE DEFAULT IS TO WRITE TO LOCAL FILE. BUT IN YOUR COMPANY YOU CAN SET UP YOUR
LOCAL SERVER TO COLLECT DATA. OR USE DATABRICKS.

LINK TO COMMUNITY.RSTUDIO ABOUT CONVERSATION https://community.rstudio.com/t/best-practices-for-monitoring-r-processes/42805/7


https://daroczig.github.io/logger/articles/anatomy.html
