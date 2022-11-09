---
title: Logging my phone use with tasker
author: Roel M. Hogervorst 
difficulty:
  - intermediate
description: "How do you set up tasker on your phone to log phone use."
post-type:
  - tutorial
date: '2019-01-28'
slug: logging-my-phone-use-with-tasker
categories:
  - blog
tags:
  - tasker
  - phone
share_img: https://media1.tenor.com/images/cb27704982766b4f02691ea975d9a259/tenor.gif?itemid=11365139
---

<!-- content  -->
<!-- 
 
Good tutorials are: 
- quick. tell what you want to do, how to do it
- easy: success is important. playtest the tutorial under different circumstances
- not to easy: Don't get htem throug ht toturoial onluy to runinto a wall later on. 

-->


In this post I'll show you how I logged my phone use with tasker, in a follow
up post I'll show you how I visualized that.

I had a great vacation last week but relaxing in Spain I thought about my 
use of technology and became a bit concerned with how many 
times I actually look at my phone. 

But how many times a day do I actually look at my phone?
I used the android app [tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm)
I bought and have used the app before, but I never really bothered to figure 
the app out. I did now.

Tasker can be used to automate many things in your phone, for instance turn on
wifi when you're near a certain place, dim screen when it's late, mute the phone
when you're in a meeting and many more things. 

But in this case I wanted a simple way to track my phone use, as a proxy for 
phone use I have a counter that starts every day at 0 and increments with one
everytime the screen is on. 

## How to do that:

- In Profiles, create a new profile, with state: 'Display State On', give it a useful name f.i.: 'screen counter'
- Then add a task, give that a name too, f.i. : 'update screen count'

That task has multiple actions, I set mine up to 

- wait for 4 seconds (a quick on and off does not count)
- Variable add '%SCREEN_COUNT' value 1, wrap around 0
- *if you want to, you could flash a message*
- write file,  give it a name, f.i. 'screenlog.csv' and create some text to write to that file. I used "screenlog";"%DATE";"%TIME";"%SCREEN_COUNT" and toggle append and add newline

This way the file gets appended with new screen counts everytime I open the phone,
the resulting file is a ';' - seperated file where tasker replaces the %DATE etc with the current values
So today it would write 

```
"screenlog";"01-28-19";"21.27";"148"
```

For some reason the app sometimes writes in USA style date and sometimes in normal
day-month-year style, so that gives me head aches, but it works reasonably well.

## How to reset the counter?
I set up a new profile for that reason. 
Every day in the final minutes of the day a new task is run that resets the $SCREEN_COUNT to 0.

