---
title: Creating a package for your data set
author: roel_hogervorst
date: '2016-03-07'
categories:
  - blog
  - R
tags:
  - intermediate
  - package
  - coffeedata
  - tutorial
slug: create-package-for-dataset
---

Turning your dataset into a package is very useful for reproducable research. This tutorial is for you, even if you've never created a package in r.

Why would you turn your dataset into a package?

* very easy to share
* easy to load (library(name) is easier then `load("path/to/file")` or `data<-read.csv("path/to/file")` etc.)
* documentation is part of the package and will never separate from data
* attributes of file remain
* nice and easy introduction to package building

What do you need to do to create a dataset package:

- Step 0: locate your dataset, both raw and clean 
- step 1: create a new project with Rstudio
- step 2: save the clean file
- step 3: create a description file
- step 4: describe the package with a vignette.*
- step 5: test and build*
- step 6: maintain your dataset if it changes. *

*: Steps 4-6 are optional, but will help you in practicing for other packages.

What you need:

1. Rstudio
2. devtools installed
3. a dataset that you want to turn into a package
4. You need to know how to load a file

In this example I will make a package from my all the times I drank coffee. 
I started keeping score because I realized I drank more coffee since working full time. 
This is just a file which contains time stamps whenever I drank coffee. I have some missing values, because I sometimes forget, but mostly it's correct. 

This file is not really useful to anybody except maybe me, but a package is quite useful for a variety of analyses. Let's walk through the steps, follow along with your dataset. 

# Step 0: locating your datasets

You need a dataset on your harddisk

# Step 1: Create a new project

Create a new project in Rstudio, choose new directory, R package:

![image of starting a new project](/img/rstudio-project-package-new.PNG)

## Naming the package

Think about a simple descriptive name with the following tips:

- no spaces		Good: Coffeedata Bad: Coffee data
- no points 	good: Coffeeproject Bad: Coffee.Project
- no dashes     Good: datasetCoffee. Bad:  dataset-Coffee
- use lowercase, CoffeeDataSet gets confusing. 

Naming packages is really hard, it needs to be descriptive and unique. But this is less important if you only share the package with yourself and friends. 
think about the name, dataset21really is not descriptive nor helpful for you in the future.
  
# Step 2: save the clean file

Ideally you will want to save both the raw file and the cleaned dataset, with a script (or rmarkdown document) that describes the actions you took to clean the raw file. 

I assume that you are now in the rproject you have just started. 

![images of empty project](/img/rstudio-coffeedata-project-empty.PNG)

Locate the file you want to put in the package. And load it so that it's active in the environment:

![image of loaded coffeedata](/img/rstudio-loaded-coffeedata.PNG)

Then do one of the following (replace coffeedata with your data set's name).

```r
library(devtools)
use_data(coffeedata)
```
or use devtools directly

```r
devtools::use_data(coffeedata)
```

This command will create a data folder and put the file in there with the rda extension.


# Step 3: create a description file

When you started the project a description file and an example function was created:
![image of standard rstudio project](/img/rstudio-project-package-prepopulate.PNG)
Open the description file. 

I just copied this from the excellent package building book [^1], please read his website:

> Every package must have a DESCRIPTION. In fact, it’s the defining feature of a package (RStudio and devtools consider any directory containing DESCRIPTION to be a package). To get you started, devtools::create("mypackage") automatically adds a bare-bones description file. This will allow you to start writing the package without having to worry about the metadata until you need to. 

The minimal description will vary a bit depending on your settings, but should look something like this:

![image of package description](/img/package-description.PNG)

Fill in the meta-data of your package.

```
Package: name of package
Title: Use Title Case in One Line.
Version: 0.1.0 
Author: who you are
Maintainer: Who to bother when it breaks
Description: What the package does (one paragraph)
Licence: see below
LazyData: TRUE
```
### a license?

You might think that the license is a bit too much for a package you build. But it it's really hard. If you don't give a licence your data is under your copyright and no one can use it.
For datasets a [CC0 licence](https://creativecommons.org/about/cc0/) puts the data in the public domain and makes it free to  build upon, enhance and reuse the works for any purposes without restriction under copyright or database law.

For packages that contain code (most of the packages) other licenses are better: <http://choosealicense.com/> .

## A description of the file

If you look at `?mtcars` there is a description of the file. You want to avoid this:

![image of r can't find help file](/img/failure-to-describe-package.PNG)

The help file is created with

`devtools::use_package_doc()`

this creates a file in the folder `R/` . Click on the file and add stuff.
![image of r can't find help file](/img/coffeedata-package-r.PNG)

See also this example in [hadley's babyname package](https://github.com/hadley/babynames/blob/master/R/data.R)


# Step 4: describe the package with a vignette.

Use the template from rstudio:
![rstudio rdocument window](/img/rstudio-document-dataset.PNG)

Give it the name of your dataset

This is the endresult

![example rstudio rdocument with coffee filled in](/img/rstudio-document-dataset2.PNG)

after you changed the files use `devtools::document()` to create documents.

# step 5: test and build

Then check your package with the check button or `devtools::check()`. You will probably need to change some stuff based on the check. The check tries to build your package and checks for common problems. The endresult is in: /packagename.Rcheck/

If your package is very simple, consisting of only documentation and a datafile, your build will be completed and works.

Click on build & Reload and try out your new package.


### How do I share this package?

Once installed you can use the package anytime you like with `library(package)` But you might want to share your package with colleagues.

Build a source or binary version:

![rstudiowebsite image of sharing ](http://www.rstudio.com/images/docs/build_pane_build.png)

After you build the source package, a file is created, in my case:
"coffeedata_0.1.0.tar". That file is shareble and can be installed on someones computer. They will need to build from source. 


Online: upload your project using git to either Github <https://github.com/> (many people use it, but can't restrict access in free version) or Bitbucket <https://bitbucket.org/> (close off your project). Or any other sharing service.

If it's on github everyone can install the file using devtools, in my case:

```r
devtools::install_github("rmhogervorst/coffeedata")
```

This also works on bitbucket :

```r
devtools::install_bitbucket("rmhogervorst/coffeedata")
```

Or you download the [source](https://github.com/RMHogervorst/cleancode/raw/gh-pages/datasets/coffeedata_0.1.0.tar.gz) file from the website and install it manually

Yes I have created the file for you. Now you all know how many coffee I drank. Even worse, you can do what you like with that information, because it's in the public domain. 



See Further reading to find out more about other ways to share your package.

# step 6: maintain your dataset if it changes

If your dataset changes, you should update the package. 


### Problems 

> I don't have a description file or any of the other folders... or devtools gives me errors. 

Check if your project has forbidden characters: dots, dashes or spaces.

> Rcheck fails!

Check the log. The log is in the folder next to your package `/packagename.Rcheck/00check.txt`
in my case my project is in: `Projecten\coffeedata` and the logs are in:
 `Projecten\coffeedata.Rcheck\00check.txt`

> the folder disappears! I cant check the log.

This is a good thing, it means your settings are so that non failing builds are removed. Change this in Rstudio Global Options, go to packages, and uncheck the option: *clean up output after succesful R CMD check*.


## Further Reading

- [Hadley Wickham about naming and starting with a package](http://r-pkgs.had.co.nz/package.html)
- [R packages book: What to put in your description file](http://r-pkgs.had.co.nz/description.html)
- [Rstudio: Building checking and distributing packages](https://support.rstudio.com/hc/en-us/articles/200486508-Building-Testing-and-Distributing-Packages)

## References

[^1]: Wickham, Hadley. R Packages. First edition. Sebastopol, CA: O’Reilly Media, 2015. <http://r-pkgs.had.co.nz/>
