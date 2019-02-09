---
title: Introducing Badgecreatr, a package that places badges in your readme
author: roel_hogervorst
date: '2016-07-08'
categories:
  - blog
  - R
tags:
  - badgecreatr
  - package
slug: introducing-badgecreatr-create-and-place-badges-in-readme-rmd
---

Introducing **Badgecreatr**, a package to create and place badges in your readme.Rmd file on Github.

Badgecreatr will create the following badges (aka shields): 
 
[![Project Status: Active ? The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html) [![Build Status](https://travis-ci.org/RMHogervorst/badgecreatr.svg?branch=master)](https://travis-ci.org/RMHogervorst/badgecreatr) [![codecov](https://codecov.io/gh/RMHogervorst/badgecreatr/branch/master/graph/badge.svg)](https://codecov.io/gh/RMHogervorst/badgecreatr) 
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.2.4-6666ff.svg)](https://cran.r-project.org/) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/badgecreatr)](https://cran.r-project.org/package=badgecreatr) [![packageversion](https://img.shields.io/badge/Package%20version-0.1.0-orange.svg?style=flat-square)](commits/master) 
[![Last-changedate](https://img.shields.io/badge/last%20change-2016--07--08-yellowgreen.svg)](/commits/master)

### Installation 
Install the package with `install.packages("badgecreatr")`

### How do you use badgecreatr?
Badgecreatr has one main function: `badgeplacer()`.

The most simple command is:

```r
badgecreatr::badgeplacer( githubaccount = "yourgithubname",githubrepo = "yourpackagename", branch = "master")
```


If your project is in its infancy and you don't want people to use it yet:

`badgecreatr::badgeplacer(status = "wip" , githubaccount = "yourgithubname",githubrepo = "yourpackagename")` which will give it the status 'Work in Progress'. 

Repostatus gives you seven [project statuses](www.repostatus.org); Concept, WIP, Suspended, Abandoned, Active, Inactive, and Unsupported.

### Why would you use this package?

When you have started yet another Github based r-package, copied the travis file and created a readme.Rmd file and you want to add these badges. 
Frankly I was a bit annoyed to copy almost identical markdown to new projects, it seemed right for automation. 

**Why would I not use this package?**

- you don't create a r-package
- you don't want to create badges
- you don't use Github 


## What does badgecreatr do?

Badgecreatr reads your `readme.Rmd` file, reads your `DESCRIPTION` file and searches for a `.travis.yml` file.

Within the `DESCRIPTION` file badgecreatr will find:
- package name
- the version number of your package
- the license : GPL-3, GPL-2, MIT, or CC0 
- Minimal R version


**Badgecreatr will create**

- [repostatus](www.repostatus.org) badge (by default it will give you an active status)
- a licence badge
- *If it finds a .travis.yml file*:a Travis-CI Build-Status Badge
- *If it finds a codecov reference in the .travis.yml file,* a Codecov Coverage Status Badge 
- a badge to indicate the version of R you are using
- a CRAN status badge (will say 'not published' if your package is not on CRAN)
- a package version badge
- a last change badge

If you created badges in your readme before, badgecreatr will skip that badge.


Enjoy. - Roel


### Notes:

- The badges for R version, package version and last change are my invention. 
- The last change badge will update every time you re-knit your readme.md file
- If you have suggestions or improvement open an [issue](https://github.com/RMHogervorst/badgecreatr/issues) or submit a [pull request](https://github.com/RMHogervorst/badgecreatr/compare). 
  

## Further reading

- The package on CRAN: <https://cran.r-project.org/web/packages/badgecreatr/index.html> 
- The package on Github : https://github.com/RMHogervorst/badgecreatr
- My inspiration: <https://github.com/badges/badgerbadgerbadger> & <http://shields.io/>
