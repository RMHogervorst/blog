---
title: Testing Azure Functions Locally with Azurite
author: Roel M. Hogervorst
date: '2021-01-18'
slug: testing-azure-functions-locally-with-azurite
categories:
  - blog
tags:
  - docker
  - secrets
  - docker-compose
  - Azure
  - advanced
subtitle: 'Supplying secrets and simulating storage'
share_img: 'blog/2021/01/18/testing-azure-functions-locally-with-azurite/remi-boudousquie-b0s5l-7CMYU-unsplash.jpg'
output:
  html_document:
    keep_md: yes
---

<!-- content  -->
I've been developing Azure Functions with R for the past week. 
There are some nice basic tutorials to run custom code on 'Functions', the basic tutorials all create a simple web app. That is, the docker container responds to http triggers. However, if you want to use a different trigger, you need to have a storage account too. There are two ways to do this:

* use the actual storage account you created on azure
* simulate storage with the ['azurite' container](https://github.com/Azure/Azurite#run-azurite-v3-docker-image). 

![image of whale coming out of the water](remi-boudousquie-b0s5l-7CMYU-unsplash.jpg)


Whatever option you choose, you need to supply the secrets (connectionstring) to the container. If you do not, you get this error: `System.ArgumentNullException: Value cannot be null. (Parameter 'connectionString')` 

I chose the docker container that simulates Azure storage. I found it very difficult to get the azurite container and the 'function' container to communicate with each other. Maybe there is a way to do it with docker networks, but in the end, I think the most elegant way is to use docker-compose.

With `docker-compose` you write a yaml file that tells docker what containers to use and how to connect them, and you can do even more fancy things. 
I used docker compose  to spin up 2 containers. Docker compose, by default, sets up a local network connection between the containers. You don't have to open network ports to each other.  

So [here](https://github.com/RMHogervorst/rscript_serverless/blob/main/Azure/plumber_cleaned_up/docker-compose.yml) is an example docker-compose.yml file:

```
version: "3.8"
services:
    storage:
        image: "mcr.microsoft.com/azure-storage/azurite"
    function:
        image: "rmhogervorst/azuretimertweet:v0.0.1"
        env_file: 
            - .Renviron
        environment:
            "AzureWebJobsStorage": "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://storage:10000/devstoreaccount1;"
```

There are 2 services; 'storage' and 'function'. Storage is the emulator called azurite. serverless is the container I created locally with docker build ( that contains the function I want to use). 

### Telling the container about storage
You still need to tell the 'function' dockerfile how to authenticate to the storage layer. 
When 'functions' run in the azure production environment, a connection string is supplied with the correct information in it, but when you simulate it for local use you need to write it like so
```
"AzureWebJobsStorage":
  DefaultEndpointsProtocol=http;
  AccountName=devstoreaccount1;
  AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;
  BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;
  QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;
```
this is all pasted together into 1 string as you can see in the [azurite documentation](https://github.com/Azure/Azurite#connection-strings). 
In the docker-compose.yml file, you supply the string with an  `environment:` tag. In docker you give the ip adress (which is localhost; 127.0.0.1) "BlobEndpoint=http://`127.0.0.1`:10000/devstoreaccount1;", but in docker compose I supply it the name of the other container ('storage'): "BlobEndpoint=http://`storage`:10000/devstoreaccount1;". That way you don't have to know what the internal IP address is within the docker compose environment. Docker will supply the correct local network adress within the docker simulated computer. 

Start the two containers with `docker-compose up`

It takes a few seconds for the storage container to start.  Until the storage container is ready the other container sprays some errors. Wait for 10 seconds or so and it starts to run normally. On azure itself the storage is always available and superfast so it works without problems there.

## Bonus
As you can see I also supply the local credentials, saved inside an '.Renviron'-file to the docker container that needs them. 
So for supplying credentials from a file to 
* a single docker container use : `docker run -e .Renviron <DOCKERCONTAINERNAME>`  
* a docker-compose file, write a `env_file:` line in the yaml. 


## Resources
* [Azurite container ](https://github.com/Azure/Azurite#run-azurite-v3-docker-image)
* [using azurite and what connection strings to supply](https://github.com/Azure/Azurite#connection-strings)
* image of whale, Rémi Boudousquié <https://unsplash.com/photos/b0s5l-7CMYU>