---
title: Version control with Git
author: roel_hogervorst
date: '2016-03-01'
categories:
  - blog
  - R
tags:
  - beginner
  - git
  - version control
slug: version-control-start
---

## Keeping track of versions 

You work on a project and would like to keep track of what you did. 
That is why keep old versions of your files. That way you can go back if you messed up beyond recognition. 

* Usually that looks like this:

![filesystem without version control](/img/versioncontrol2.png)

* Or you use dropbox or something like it:

![dropbox versions](/img/dropboxversion.png)

* Other people use email. Emailing to themselves or to collaborators when they finished something.

And that is fine. If it works, it works. 
However in some cases you might want to go back to a previous version and work from there, or start with a variant your colleague made. That could become very difficult with these ways of versioning. Also you never know what changed in these versions untill you open the file and manually compare things. That gets tedious.  

## Version control software

With version control software you can create snapshots of the points where you fixed bugs, where you finished features and even better, you can  tell exactly  where versions of the file are different. 

The most widely used software are Mercurial, SVN and GIT. We will work with GIT, first of all because it can be used with [Rstudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN "Version control with git - Rstudio"), though svn works too, and second because it works nicely with Github. 

So how does Git work? Every time you reach a point in you project that you think is critical, you make a commit. You save a current state of all the files in the directory. And when you make this snapshot of your files, you can (and should) write down what you solved and what you changed since last time. In the future when you look back at your commit history you can read in what state your project was. 

In the next example you can see what changed in the files, without even looking at the files themselves. 
![commits from test_dat, from github](/img/commits_example.png)

### Branching
Even better, you can start from any saved point in time and create a new version. And when you like that version better, merge it back into an other version. 
![branches](/img/branching.png) 
In the example above, at the second commit I branched (purple line). the third row from below is a commit in the purple branch. Then I changed something in the normal branch and finally I merged the blue and purple line in the second line from the top. 

You don't have to use branching, just saving important points along the way is a great start (It would be the point where you email yourself a version, or save a new version of the file).

## Starting with Git

Git was developed by people at Linux because their other version control software was hard to work with [^1]. Git is designed to work with a distributed nonlinear workflow... Which means that everyone can work at any time at their version of software and you can merge those versions together. What you need to know is that it works, it's free, works on all systems, and that many people use it. You can use it for your projects, even if you work alone. It helps keeping your files under control and makes it easy to go back to previous versions of your files. It is not a backup solution (please make backups!) and it is not a unicorn [^2]. But how do you work with git?   

### graphical user interfaces (gui) for git
Git lives in the command line, you need to navigate to the right folder on your computer within the command line, and type the right commands. Unfortunately I always forget what the commands are. But for people like me there is a GUI for windows that takes care of many things. But I would actually recommend Sourcetree for windows (mac also). It's a graphical user interface where you keep track of all your repositories. It's a great tool, see [this](https://www.youtube.com/watch?v=1lBdlh3AGSc) youtube video for a short [14 mins] tutorial into sourcetree.

*Do I need to install all this new sofware? I'm just coding for fun!*

No, you don't have to. All I would recommend is to [download Git](https://git-scm.com/downloads) and install it. Rstudio has gitsupport build in, you only need to install git on your system and tell rstudio where to find it. After that you can click icons.


### Rstudio and Git
According to [Rstudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN), you will have to activate git support after you have downloaded and installed it to your computer.

1. Go to Global Options (from the Tools menu)
2. Click Git/SVN
3. Click 'Enable version control interface for RStudio projects'
4. If necessary, enter the path for your Git or SVN executable where provided. 

![enabling git in rstudio example](/img/enabling-git-rstudio.PNG)

So, how do you use version control within Rstudio?


# Rstudio project and git.
Start a new project
![](/img/rstudio-create-new-project.PNG)

I chose an empty project in a new directory

and then click 'Create a git repository'
![](/img/rstudio-new-project-enablegit.PNG)

The repo and real folder on windows 8.1 look like this.
<figure class="half">
	<img src="/img/rstudio-empty-git.PNG" alt="image">
	<img src="/img/folderview-new-git-project.PNG" alt="image">
	<figcaption>rstudio and the real folder with hidden folders showing</figcaption>
</figure>

When you start a new project a Rproject file is placed in the folder that contains all the project settings you have. But when you enable git, a .gitignore file is also placed in your folder. That file tells git which files not to track for changes. Rproject makes sure that the the temporary r files are not tracked, because temporary files will be recreated every time and tracking them is useless. In my case I have turned on the 'show hidden files' option in windows. If you don't have that on (and you don't have to) you will only see the gitignore file (with no name) and the rstudioproject file.  

Now let's look back at rstudio git tab.

## Git version control within Rstudio: your first commit

![](/img/rstudio-git-first-commit.PNG)
I have added the second file, the icon changes to a green A (short for: add to repository), the first one shows two yellow questionmarks (short for: not tracked, not changed, I think). 

* add the two files of your project and click 'commit'

A new window will open:

![](/img/rstudio-git-commit-window.PNG)

The left part of the screen shows what files are in the commit, the bottom part displays the changes since last commit. Green means added, red means subtracted. 
 
* Click on the second file in your commit, the bottom part displays what has changed. 
* Write a commit message, never commit without a message, if you don't have a description, it probably wasn't worth committing. The message does not have to be long, short is better. in this case I used: "init commit" That just tells me it was the first commit before I did anything.
* Click 'commit' when you typed your description. 

a window will open with a description of what happened.

![](/img/rstudio-git-commit-message.PNG)

When you return to the main view of rstudio you will see that the git tab has changed a bit, there are no files (because nothing has changed yet since your commit 2 seconds ago) and next to the gear wheel it says: 'master' . This is the branch you are on right now. By default the first branch is master.

Let's create a new file

## Git version control within Rstudio: your first new file.

* Create a new file and fill it with some code or:

```r
# This is a awesome function
# It takes a number and gives you 
# the corresponding letter in the
# alphabet.
# 2016-02-27
# YOUR name 
```

* Then save it in scripts/  (yes, you must create that folder as well, or don't I'm not the police...)
* add it to the repo (clicking it will tell git to track that file from now on)

It will look like this
<figure class="half">
	<img src="/img/rstudio-commit1.PNG" alt="before tracking">
	<img src="/img/rstudio-commit2.PNG" alt="after tracking">
	<figcaption>rstudio adding files to commit before and after</figcaption>
</figure>

Let's look at the history of your commits, click on the clock in the git tab.
Mine looks like this:
![rstudio commit history](/img/rstudio-commit-history.PNG)

Note the commit message, it says what the commit adds to the repo. Try to write your messages as if you fulfull a order and discribe the contents. For example: "adds count_messages function that counts messages send to the user"
or, "fix issue #2 can't work with arrays".

That way you can scan through your commits and see what changed where. When you click on a commit you can see what changed since the commit before. 

## some questions

* Will version control eat up all my hard disk space?

No, first of all all r scripts are essentially plain text files and take up little space and second, git only saves what changed since the last time. So the total file size should not go up that much. And third, space is cheap, you will not easily run out of space on modern computers.

* Nice! Can I add my data files to a git repo as well?

It is not recommended to add datafiles to a repo. I think it can work with plain text files such as .txt, .csv, .tdv . But many other files can't be read by git, so it treats them as binary files. Git can only see that the file has changed, but doesn't know WHAT changed. So it saves the new version as a whole. If you have some large binary files that change often, they will eat up a lot of space. There is a git large file system but I don't know how it works yet. 
Do add example csv files or smaller files if you'd like to.   


### Further Reading
* [Git in Rstudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN)
* [git website](https://git-scm.com/)
* [r-blogger.com all articles about git](http://www.r-bloggers.com/?s=git)
* [Atlassian company of Sourcetree, has a long read about branching models](https://www.atlassian.com/git/tutorials/comparing-workflows/centralized-workflow)
* [r-bio example of git and rstudio](https://r-bio.github.io/intro-git-rstudio/)

The **best resource** is [https://stat545-ubc.github.io/](https://stat545-ubc.github.io/git00_index.html "pages about git")

### References

* [^1]: Linus Torvald (the main man behind linux) actually said he wouldn't touch subversion with a ten-foot pole. <https://git.wiki.kernel.org/index.php/LinusTalk200705Transcript>
* [^2]: *Chasing unicorns, the pursuit of something that’s, for all intents and purposes, unobtainable as unicorns don't exist.* Meaning it doesn't magically solve all the problems other version control software has. 
