---
title: Introduction to R projects
author: Roel M. Hogervorst
description: 
difficulty:
  - beginner
post-type:
  - tutorial
date: '2016-04-10'
categories:
  - blog
  - R
tags:
  - rproject
  - git
  - rstudio
slug: rproject-start
---

It often makes sense to separate your projects. And since space is cheap you are probably creating separate folders on your computer. In RStudio you can create different projects that live in their own folder. 

When you start a different project the files of that project work independently from other projects. And the standard locations of your workspace and other things are also separated from the rest. 

In my case, for example, I have several projects and the last 10 or so are displayed in the dropdown menu:

![Roel's last projects image](/img/rstudio-project-dropdown.PNG)


Opening a new project presents you with a screen .

![rstudio new project image](/img/rstudio-create-new-project.PNG)

You can create a new project in a new location, in an old location or download from [version control](https://blog.rmhogervorst.nl/blog/2016/03/01/version-control-start.html  "See a previous post about version control"). 

Did you try the new directory one already?

In the following example, you can clone (or checkout) a file from the internet. 

I presume you have version control installed already, if not [this article](https://stat545-ubc.github.io/git03_rstudio-meet-git.html)  will help you along. Once you've installed git, you can use version control for all your projects. See the post version control

If you click on `checkout from version control` this will happen

![image of checkout from version control](/img/rstudio-versioncontrol.PNG)

Click on git

and fill in some details.

![image of my repo clone](/img/rstudio-clone-git.PNG)

 in my case I've dowloaded from my own repository but cloning a project from github is possible from every project. 

I went to the website <https://github.com/RMHogervorst/cleancodeexamples> and selected the clone address. *which is usually the address ending in .git*

Here the clone address at a different repository:

![image of hadley's ggplot2 repo address](/img/clone-image.PNG)

That is it, a short introduction to projects. 


### Further reading
[Rstudio: Using Projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects)
