---
title: Portioning projects
author: roel_hogervorst
date: '2016-02-14'
categories:
  - blog
  - R
tags:
  - philosophy
  - intermediate
  - modular projects
slug: portioning-projects
---

Often we write programs to automate things. The programs range from simple to complex. But in essence, you always do the same thing:

You are trying to solve a problem.

A common pitfall, *at least for me*, is that you start out to big. What you need to do is start simple and small, and only if your simple thing works, increase the complexity. Separate parts of the program need to be separate functions. 

## Code to solve a Problem

Your higher aim is for your code to  solve a large and important Problem. For instance, taking many values and compute other values on the way.

But to get to the solving of the big Problem (with a capital P), you need to overcome small problems (small p). One way to solve your Problem is to put everything into one script,  or one function. But I would like to argue for the use of modules. Make one project for your big and important Problem in Rstudio. Make small functions or modules for the little problems. Make one or two functions that combine the small parts. Create small scripts for every function or combine multiple functions in one script. But keep it small.

In other words: create simple functions that are really good at one thing. Then combine them into a larger whole.
This is called modular programming.

### Why is this better?

Small modules can be optimized to perform one thing really well.

Small modules are more readable for you in the future and for others if they want to contribute.

Small modules are much easier to test. Make a test that inputs the right sort of input and see if it creates the output you want. Make a test imputing the wrong sort of input, and see that it throws an error.

Modular programming also makes it easier to add new functions. You can reuse modules (refactoring) or simply add a new module that extends your program. 

![distinction one script approach and modular approach](/img/project_philosophy.png)

# Planning your project

How do you start?

### Imagine the way your code should work when finished

This is a perfect moment to start your documentation. How will someone use this code? What are the options? What type of data are allowed? *Don't think that no one will read it, you will be one of the people who need to understand your past you.*

All these questions lead to logical submodules:

- check the options that a user imputed.
- What are sensible default options.
- Check for datatype (do you allow numeric, factors, etc ), create errors.
- Describe what the user does in the documentation. 
- Then write out how your code performs those actions.

The endresult will be a list of submodules and their description. 

## Start as small as possible

You have thought of all the ways your code should work. But you need to start simple. Think of the minimal viable product, a function that is so basic that it should work. It should be a small step into solving your big Problem. For instance, transform the variable. Or check that the input is a data.frame or whatever.

Test your small problem. Fix your code.

### Start on one of the other submodules

Make small modules that do one thing and one thing only. Make automated tests that will inform you if the module doesn't work anymore.  When your submodule works, start a new one, repeat until your Problem is solved.
Start small and make incremental changes.

### Further reading
* [Modular Programming, wikipedia](https://en.wikipedia.org/wiki/Modular_programming)
