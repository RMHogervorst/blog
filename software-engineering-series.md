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

* start of script [blogpost 2019-10-30]() [, code](https://github.com/RMHogervorst/example_best_practices_ml/tree/cd14929327b99a7c379eca896cdf7b471ccfd868).
* Refactoring [blogpost 2019-11-05](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/07f4d40c401efaa53713e255fd0caaf1e6554767)
* Adding logging and monitoring [blogpost 2019-11-12](), [code after this step](https://github.com/RMHogervorst/example_best_practices_ml/tree/91acc95f4cf3ce6258515f0c5d097019a01bbe9a)
* Adding tests and validation [blogpost 2019-11-19](), [code after this step]()


outlines: what is the message I want to give?
(machine learning approach is most useful if you don't have to touch it
anymore to make it work. Like most programs, you write it to do repetitive work and
you are free to work on different things. an improvement, drink coffee, start a brewery
a different project)

# best practices in software engineering (for r users)
What does it mean to bring something to production?
why should you care
what best practices are we talking about
who am I 
from proof of concept to production
what is production
example R script 
general post with links to other posts


# started with a script 
Just a description of what happens in the script.
raising questions about extensibility and how easy it is to understand.

# refactoring
start with a single script 
(maybe focus on why we do refactoring, possibly speed, def easier to extend, easier to reason about,
it's for you and your team after 2 weeks of vacation, you don't know it anymore.)
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
