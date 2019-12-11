# planning

Every week a new post. on tuesday morning. 
every post should link to others and general one, but should be readable on its own.

```
date        what      code done?  outline done?   editing done?   title ?
2019-11-12  intro     x           x
2019-11-19  refactor  x           
2019-11-26  log/mon   
2019-12-03  tests val 
2019-12-10
2019-12-17
```

best practices



outlines: what is the message I want to give?
(machine learning approach is most useful if you don't have to touch it
anymore to make it work. Like most programs, you write it to do repetitive work and
you are free to work on different things. an improvement, drink coffee, start a brewery or work on 
a different project)

# best practices in software engineering (for r users)
What does it mean to bring something to production?
from proof of concept to production
what is production
why should you care


what best practices are we talking about
who am I 

example R script 

# separarate link post
general post with links to other posts


# started with a script 
Just a description of what happens in the script.
raising questions about extensibility and how easy it is to understand.

# refactoring
start with a single script 
(maybe focus on why we do refactoring, possibly speed, def easier to extend, easier to reason about,
it's for you and your team after 2 weeks of vacation, you don't know it anymore.
maybe we can use the iron imperitive: don't waste my time, THAT ALSO INCLUDES YOU IN THE FUTURE. MAKE SURE YOU ARE CAN UNDERSTAND IT WELL LATER. COUPLED WITH TECHNICAL DEPT: QUICK HACKS YOU USED TO MAKE IT WORK, THAT WILL HAVE TO BE CHANGED LATER. THAT IMPETE YOU LATER: COST OF ADDDITIONAL REWORK TO WORK AROUND EARLIER SOLUTION. IT IS DEPT THAT COMPOUNDS, YOU HAVE TO DO THAT WORK EVERY TIME. BY CHOOSING AND EASY SOLUTION NOW WHERE A BETTER MORE DIFFICULT SOLUTION EXISTS BUT WOULD TAKE LONGER)
move things into functions and place them somewhere else
abstract steps away so we see things on the same level
better names


# adding monitoring logging
WHY AND WHAT
(basically control/observability of the ml-system) Even if we don't touch it
we know how it is doing. if we touch it, we know where it is going wrong.
what are logs for, levels of logging
monitoring: send metrics to different system to keep track of your ml-system.
things like model drift etc. example: when you work ecommerce: black friday, christmass etc 
keep a huge influx of visitors and sales, so the model might take longer etc
HOW: this is how you add logging and monitoring. 

# tests and validations
WHY AND WHAT
We test because we want to make sure the ml-system is doing what we want.
We also want to be able to change code and verify nothing broke by running 
the testsuite. 
Test in logical chunks.
validation statements in code defend you from stupid issues:
is this is an integer, character. are there new groups? is the data empty
do the resulting predictions change over time?
can do something with monitoring too.
