---
title: Where does the output of Rscript go?
author: Roel M. Hogervorst
date: '2020-04-14'
slug: where-does-the-output-of-rscript-go
categories:
  - R
tags:
  - rscript
  - standard streams
  - errors
subtitle: 'stdin, stdout, stderr'
share_img: '/post/2020-04-14-where-does-the-output-of-rscript-go_files/Rscript_example.png'
---

<!-- content  -->
We often run R interactively, through Rstudio or in the terminal. But you can also run Rscripts without manual intervention. Using Rscript. But where does the output go?

Warning: This post is very linux/unix (macos) centred, I don't know how this works in Windows.
*Also I'm using the standard shell in linux 'bash' I believe there are some small nuances in the commands in other shells like zsh.* 

## Why do I want to know this?
In my work we run a lot of periodic scripts, a lot of python but also R scripts. These scripts download data from a database, do calculations and write back to a database. 
They are scheduled and run without supervision. But if something goes wrong we want to know what happened and so we look at the logs. If you know these tricks you can write good scripts that are easy to debug. 

# Testing the output streams
I created this file `message_warning.R`

```
#!/usr/bin/env Rscript
print("this is a print \n")
cat("this is a cat \n")
message("this is a message \n")
warning("this is a warning")
stop("this is a stop, or error!")
```

It contains `print()`, `cat()`, `message()`, `warning()` and `stop()`.

## Run in R interactively
When you run this interactively; `source("message_warning.R")`, they all show up in the R console.


## Rscript interactively
If you execute this file with Rscript it also shows up in the terminal

`Rscript message_warning.R`

```
[1] "this is a print \n"
this is a cat
this is a message

Warning message:
this is a warning
Error: this is a stop, or error!
Execution halted
```

But when you run things in the terminal , you often want to do something with the output. 
Maybe you want to search the logs while they are streaming with a `grep` command. 

But what happens when you pipe the output into a file?

## Pipe Rscript into a file
I'm using the `>` command to capture the output and write it to a text file ('stuff.txt').

`Rscript message_warning.R > stuff.txt`

The terminal returns:

```
this is a message

Warning message:
this is a warning
Error: this is a stop, or error!
Execution halted
```
And stuff.txt contains:
```
[1] "this is a print \n"
this is a cat 
```
So print and cat are captured but message and warning are not.
This is because R writes to stdout and to stderr. 

## Why are there multiple outputs (stdin, stdout, stderr)?
This might not surprise some people, but it did surprise me. There is a long Unix^[And therefore inherited in Linux] tradition of 'streams'. You read from an input stream 'standard in' (stdin) and write to an output stream 'standard out' (stdout). Extra warnings and diagnostics are written to a seperate steam 'standard error. It is a stream independent of standard output and can be redirected separately. This makes it possible to ignore warnings and still work with the output of a program or capture errors in a different file and ignore all the normal messages. 

## Pipe standard error into a file
But we can also write the sterr to file.

`Rscript message_warning.R 2> stuff.txt`  

Now the terminal outputs the print and cat:
```
[1] "this is a print \n"
this is a cat
```
and the stuff.txt file contains the message and error

```
this is a message 

Warning message:
this is a warning 
Error: this is a stop, or error!
Execution halted
```

## Capturing both error and print statements

`Rscript message_warning.R  >& stuff.txt`

# Lessons learned
The output of `message()`, `warning()`, and `stop()` are written to stderr. You can use this to your advantage: if you only output useful information, like the result of a calculation, prediction, etc. Then you can chain multiple R scripts together to do your work. 
If you use `print()` or `cat()` remember that this is returned to the user, so it is adviceable to make those results useful. As you can see in the results, `print()` returns a linenumber and the result (`[1] "print"`), so this is often not useful or hard to parse. 

Print and cat also can't be disabled! You can suppress messages with `suppressMessages()` and warnings with `suppressWarnings()` (you can't suppress errors, because errors are unrecoverable by default, you can capture them with TryCatch).


## Resources
- [littleR](http://dirk.eddelbuettel.com/code/littler.html) is a better alternative for Rscript, it handles command line arguments better and is slightly faster. 
- [standard streams description on wikipedia](https://en.wikipedia.org/wiki/Standard_streams)
