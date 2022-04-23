---
title: Don't Panic! a Scientific Approach to Debugging Production Failure
author: Roel M. Hogervorst
date: '2022-04-25'
slug: don-t-panic-a-scientific-approach-to-debugging-production-failure
categories:
  - blog
  - R
tags:
  - rinprod
  - production
  - intermediate
  - advanced
  - devops
  - uncertainty
subtitle: ''
image: ''
---

Your production system just broke down. What should you do now? Can you imagine your shiny application / flask app, or your API service breaking down?

As a beginning programmer, or operations (or devops) person it can be overwhelming to deal with logs, messages, metrics and other possible relevant information that is coming at you at such a point.

And when something fails you want it to get back to working state as fast as possible. People depend on this stuff! 

You get into panic mode. 

That is not helpful. Be careful when in panic mode! Don't do stupid stuff like me.
![board with text "don't panic"](tonik-unsplash.jpg)


## Silly stuff I've done in panic mode

When you are in panic mode you focus on what is right in front of you and make suboptimal decisions. Here is some I have made.

#### Assuming it is the same as previous time

When an application failed for the second time in 2 weeks, my thought was:

> "It failed last time because we ran out of memory on the machine. If I restart the machine again it will work again."

But in this case there was a different cause, we forgot to update the credentials for this machine.

*if I'd read the logs I would have seen a clear error indicating that the connection could not be made because the credentials were missing.*

My panic decision was to default to a cause I had seen before and fix that. If I had taken a minute to read the logs I would know better.

#### updates were not propagated

(this was not really production, but while developing I still panicked) My front-end application did not properly pass information to the back-end.

I had changed the configuration but nginx was not set to auto reload on changes in the configuration (this was in a kubernetes cluster and so the config lived in a configmap which moves automatically inside the machine, so I forgive myself for not realizing that nginx does not automatically reload it). I have looked up several configuration options and tried them all, and none were effective!

*I should have read the logs better. Logging level was set to debug and so there were many messages and I looked over the message that told me how the routing was implemented.*

My panic decision was to assume my changes did not work, when in reality the changes were not picked up.


# A Scientific approach for debugging and for production breakage (OODA loop)
![Scrabble blocks that spell "Pause, Breathe, Ponder, Choose, Do"](brett-jordan-unsplash.jpg)

Even when you are in panic mode, try to keep a scientific approach to debugging. Check your assumptions, generate hypothesis of what causes the problem and check that hypothesis. But this is not a scientific paper, there must be rigor, but also speed; employ the 'theory of close enough', formulate hypotheses quickly and verify them.

**Observe** (1) what happened, (2) what happens and (3) what should happen. **Orient** yourself to the problem by applying your knowledge of the system to the observations, **Decide** on what the cause is and **Act** on it. Then **Observe** again to see if you were right. This is a generic approach known as the OODA loop (Observe, Orient, Decide, Act) and it was originally described by an American Air Force Colonel. But it did not stay in the military, this approach is used in litigation, law enforcement, and business. I think it works as a generic strategy for debugging too. The main point is you should not jump to conclusions too quickly.

So how does this work in practice:

*You get a message that your application is not working from someone else* This is not great, it is bad if someone else noticed before you.

## Observe

-   take stock: what system is up, what system is down? Is the infrastructure around it still up? **write this down**
-   Go to the system that is down, read the logs
-   **write your observations down**

## Orient

-   You know how the system is supposed to work, apply that knowledge on what you just observed.
-   Are you the only one with failures?
-   Where was the failure?
-   What was the failure (messages)?
-   What happened before the failure?
-   What should have happened?
-   Of course you are a good programmer, but always check that you did not mess this up yourself.
-   What has most recently changed?
-   make this a story: *file something went in here, program x picked it up, there was a network error, the success message was not picked up, therefore the two systems are out of sync, causing the error*

## Decide

-   Only now you decide what the most probable cause of failure is.
-   **write this hypothesis down.**

## Act

-   Verify your hypothesis, check your assumptions. There are two options, your hypothesis was right or your hypothesis was wrong.

### Hypothesis confirmed

-   Reconcile this cause of failure and see if the system comes back up.
-   **write down the actions you took to rectify the situation**

### Hypothesis refuted

-   **write down what made you reject your original hypothesis**
-   go back to observing the state, take stock again,
-   check systems one step further away

# Learning from failures

The approach above will help you go through your problem quickly and probably bring the system back into a working state again. By writing down what you observed and what you thought you can learn from this failure.

When the crisis is over take a break, drink a cup of tea and look back at the failure with refreshed eyes.

## Blameless Post-Mortem

A post-mortem, or autopsy is a medical procedure where a doctor finds out the cause of death of a victim. Your systems were maybe not really dead but it is good to go deep and find out why a failure occurred.

The best post-mortems are blameless. Our software and our teams, work in a system. A system you try to make as robust as possible. That a failure occured, means something went by unnoticed, or broke an assumption you made. You try to figure out what barriers were broken, what procedures are faulty, what information was missed. Maybe your system broke down because someone switched off the power to a rack, but why was that possible? Maybe your flask app broke down because someone send in a malformed document with right-to-left reading order text, but should the app deal with this gracefully? should it block malformed documents earlier?

The only way to learn from these (often painful) experiences is to write down what happened and formulate plans to counter that happening in the future again.

Write down a time-line:

-   what happened
-   when did we realize this?
-   what steps did we take?
-   what did we find out?
-   when was it resolved?

After you have written the time-line down, formulate actions you can take:

-   Are there things you could have done to prevent this from happening again?
-   Are there things you can add that will notify you earlier?
-   Are there things you can do to make it more clear what happens?
-   Are there automated checks and actions you can add that will resolve this automatically in the future? (for example, scale automatically when cpu or memory limits are reached. or are there unit-tests you can add that present faulty data that you should recover from)

**Failures are just another way to learn about your systems. A new opportunity to learn and to improve.**

![man sits on chair with book over head and eyes closed while papers drop around him](dmitry-ratushny-unsplash.jpg)

### notes
* "Don't panic" photo by <a href="https://unsplash.com/@thetonik_co?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Tonik</a> on <a href="https://unsplash.com/s/photos/don%27t-panic?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
* "Pause Breath" photo by <a href="https://unsplash.com/@brett_jordan?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Brett Jordan</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
* "book over head" photo by <a href="https://unsplash.com/@ratushny?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Dmitry Ratushny</a> on <a href="https://unsplash.com/s/photos/learning?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  
    