---
title: Setting up a version controlled shiny-server
author: Roel M. Hogervorst
description: 
difficulty:
  - advanced
post-type:
  - clarification
date: '2018-02-06'
categories:
  - blog
  - R
tags:
  - shiny
  - shiny-server
  - git
  - githook
slug: setting-up-a-version-controlled-shiny-server
---

Last week I set up a shiny server, it was relatively easy! But I wanted something more, a way to make changes on my local computer and push it to the server.


Shiny server (I used the open source version) has multiple installers provided by RStudio.


The installers for shiny-server create a user shiny and installs all the services needed.

I used a guide specific for my version of linux to install shiny-server and combined it with two other guides to make it version controlled.


I have added the instructions to this [github gist](https://gist.github.com/RMHogervorst/9d88ebff914b66b984ede8e78876c92f) but you can also follow along.

### Server setup
After you've installed shiny-server, the server serves all apps in '/etc/shiny-server' but I really don't like to scp into the server to upload files, I'd rather work on my computer, put everything under version control and push the changes to the server. That way I can easily revert my changes if something fails and I don't lose work.

I've used Dean Atalli's [excellent guide to setting up a server on digital ocean](https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/) but I've modified a small part. He is using github to push his changes and then pulls from github to his server.
I was in a situation where I did not have access to github and I wanted a slightly simpler setup.

I created a bare repository on the server (that accepts my changes and responds just as github would, except the pretty website features) and used a git-hook. The files in the bare repo are not laid out in the same way as in the original files (on my computer) so I have to do something with that.

A git hook is something that runs  before, during or after you change a repo (it hooks into git). It is a simple shell script that (in my case) runs after a change is made in the repo and executes a command. After a change this 'post-receive'-hook checks out the latest branch and moves it to '/etc/shiny-server/'.


So the set up is like [this](http://toroid.org/git-website-howto "I modified this to make it apply to shiny-server") :

```
/home/shiny/shiny.git
/etc/shiny-server/
/all the other folders in a linux system
```

You move into the shiny.git folder (no real need to use that extension, but it is common) and go to the .git folder. inside the folder you add and modify a file called post-receive like this:

```
#!/bin/sh
GIT_WORK_TREE = /srv/shiny-server git checkout -f
```
You also need to tell the server that this file 'post-receive' may be executed. by 'chmod +x hooks/post-receive'.

### setting up you local computer.

* (optional) Move the files from the server /etc/shiny-server/ to you computer so you can always revert back to the basic settings.
* make sure you have a ssh key set up (this is safer to work with than username password)
* we are going to move the ssh key of your computer to the list of accepted ssh keys in the server.
* make a repo which will be your root folder on the server, meaning this folder will be mirrored in '/etc/shiny-server/' so shiny-server could be a good name.

### a few changes on your server

* add your ssh key to '~/.ssh/authorized_keys' on the server

### back to your local computer
* add a remote to your repo: 'git remote add shinyserver ssh://shiny@server.example.org/home/shiny/shiny-repo.git'

- git remote add:  *add a remote*
- shinyserver   *the name of that remote*
- ssh:// *make a ssh connection to*
- shiny@adres/ *the user shiny on server*
- home/shiny/shiny-repo.git *to the folder shiny-repo in user shiny*


push to repo $ git push shinyserver +master:refs/heads/master

### This should now work

Good luck!

(I did not have access to the server while I wrote this, so I could have made mistakes, PR me with hints and answers or open an issue, alternatively: reach me on twitter @rmhoge)
