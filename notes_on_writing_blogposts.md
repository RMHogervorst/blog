Something about the difference between a manual and tutorial from teaching tech together.  Greg Wilson (ed.): Teaching Tech Together. Lulu.com, 2018, 978-0-9881137-0-1, http://teachtogether.tech.  :

> A [**tutorial**](https://teachtogether.tech/#g:tutorial) helps newcomers to a field build a mental model; a [**manual**](https://teachtogether.tech/#g:manual), on the other hand, helps competent practitioners fill in the gaps in  their knowledge. Tutorials frustrate competent practitioners because  they move too slowly and say things that are obvious (though they are  anything *but* obvious to novices). Equally, manuals frustrate novices because they use jargon and *don’t* explain things. 

General blog tips from writing without bullshit:
(in general the following sentences are lifted entirely from the book Writing Without Bullshit: Boost Your Career by Saying What You Mean- Josh Bernoff) *everything cursive is my thoughts about it*


Spend extra time on titles and first sentences. Blogs are front-loaded. They either hook you in the first few sentences, or they fail. That title and those sentences will also appear in Google results. They’ll attract more attention if they describe the content brilliantly and promise more.
Deliver meaty, structured content. Use all the tips from chapters 4 through 11: your blog should include bullets, lists, graphics, subheads, and active, direct, jargon-free text featuring “I” and “you.” Include links to other useful blogs and content. Blogs are informal; people expect you to speak to them directly.
Include a graphic worth sharing.
When you publish shareable graphics, make sure they include links back to your site, so they keep working for you even when they’re ripped from their context in your blog.

Promote on social media. Post links to your blog posts on Twitter, Facebook, and LinkedIn. *Maelle Salmon has a great slidedeck with how to promote your content on twitter*


ROAM *a ROAM analysis of my blog*
Readers: who is your audience?

*My readers are r-bloggers and rweekly readers and other people in the #rstats twitterverse. These people vary from very knowledgable to straight up beginners. I'd like to write for the people in between. They know some R, are analysts, but not yet packagebuilders. Some of my posts will be to easy for that specific group (intermediates) and some too complicated.*

*More specifically who are my readers? Some are working in academia (psychology, biology, statistics), some work in industry (HR analyses, prediction, forecasting, sales, etc)doing analyses mostly(?, assumption I have not yet checked), some are in the transition between academia and industry. I think people read the blogposts to learn something new, to see how they can do something faster, more reproducible or cleaner.*

*They are highly educated, know some stats, are coming from multiple backgrounds (so some terms need to be explained because they have not heard them or know the concept under a different name, and I don't want to exclude anyone so keep the geek culture a bit contained), differ in age from 18 (r-users starting in university) to, I don't know, 88(?)*

*I think I can divide my audience in 3 groups (these groups were defined by software carpentry) :beginner (have just started out, know absolutely nothing, don't even have a mental model of how things work), intermediate (regular user, have a mental model, but it is not very sophisticated)  and advanced (have a sophisticated mental model how things work, and know when the model breaks).*

*I think the following subjects (more or less the tags in this blog) are more suited for the different groups:*
*beginner:*
*for, loops, brackets, vectors, data structures, subsetting, functions, qplot, ggplot2, dplyr, spps-to-r, haven, tidyr, tidyverse*

*intermediate:* 
*tools, building packages, testing, slides in markdown, apply, package, advanced ggplot2, environments, animation, test, workflow, reproducability, version control, git, tidyeval*

*advanced:*
*S4 classes, extensions , shiny, Object Oriented Programming, Non standard Evaluation, code performance, profiling, Rcpp, optimize-your-code*

*[tutorial]: beginners, or intermediates who not yet use this approach*
*[clarification]: intermediates (their mental model of the language and package is more in line with how other languages work) *
*[reminder]: beginners who have not used this package before*
*[analysis]: r-users AND non r-users who are nevertheless interested in this specific analysis*
*[philosophical]:*

Objective: How will you change the reader

*There are (I don't know anymore where this comes from, Joelonsoftware?) 3 types of blogpost*:
*tutorial (step by step pieces of code, with the result at the start)*
*clarification (explanation of how to do something in this language when you come from a different one (excel, python, spss))*
*reminder (a how-to of a package, with examples, lists of commands (like a vignette))*

*But I think there is a fourth: Look at this cool results I got from analyses (but this might be like a tutorial)*
*And maybe a fifth, more philosophical type: why do we do things we do, and shouldn't we do it in a different way, because of ....*

*BUT that is not how I change the reader: to be more specific:*
*[Tutorial]: you will be able to do the thing I did, which generalizes to a broader class of problems, after following this post*
*[clarification]: After reading this post, you will be able to do this thing you did in this language, but now in R*
*[reminder]: you can use this package to solve these specific problems and here are the examples*
*[analysis] If you apply this approach (combination of packages and procedures) on your problem you can get answers like this*
*[philosophical]You think the same thing, or disagree with me*

Action: what do you want the reader to do?
*Let's do it per type*
*[tutorial]: Follow along, running the code on your computer (higher levels with their own data), see this as a useful way to do stuff*
*[clarification]: Frequently go back (bookmark) to this post as a reference to find out how you do a thing, and eventually use R alone because it is easier*
*[reminder]: use this post as a reference when you want to do a thing with this package (kinda weak actually!)*
*[analysis]: get inspired to do a similar thing on your data*
*[philosophical]:Follow along in the arguments and change your behavior after reading this*

iMpression: what will the reader think of you?
*[tutorial]:Roel knows how to explain complex problems step by step*
*[clarification]: Roel is someone who can tell me how to bridge from one language to R*
*[reminder]:Roel knows this package inside out*
*[analysis]: Roel has gotten the essentials from this problem*
*[philosophical]:Roel builds a solid argument*



After reading this piece, [readers] will realize [objective], so they will [desired action] and think of me/us as [desired impression].

*[tutorial]: After reading this post, and following along r-users will know how to apply this approach on their data and think of me as someone who is a good explainer*
*[clarification]: After reading this post, new r-users from another language will realize how they can do the thing they already know how to do in another language in R, so they will now use R for it*
*[reminder]: After reading through this post, a new user of the package will be able to use the most common functions and think of me as a great package builder*
*[analysis]: After reading this post, the r-user (or outsider) will understand how I got to certain answers and (preferably) agrees with them and is excited to start a similar approach on their dataset.*
*[philosophical]: After reading this post, r-users will change their mind about the thing I'm writing. They will think of me as humble but knowledgeble*

# How to write
In general: spend half your time on research, other half to writing (rewriting etc)

## Write a title and opening, build a research plan, and create a fat outline.
Do ROAM analysis:
Write the first paragraph of your document. Since you’re completely unencumbered by research, write whatever you want. Just imagine that you’re sitting across from a member of your future readership at a bar and tell them what you’re going to tell them. Don’t worry if it sucks; this isn’t even the first draft, yet.

## Create and Execute a Research Plan

You have no content. You might have some ideas, but you need more. You need research.

## Make a Fat Outline
The purpose of an outline is to help you and the people you’re working with—your boss, your clients, your editor—understand what you’re going to write. And, it should also force you, the writer, to think clearly about content.
A fat outline is more like a treatment for a movie—it includes pieces of the actual content. It flips between writing that will potentially be in the final piece, descriptions of potential content, and promises of future content. It’s harder to write than a traditional outline because you have to think about it, but that’s why it’s useful.
When writing a fat outline, ignore grammar and other traditional writing (and outlining) rules because you’re just showing how you’ll organize the content.
Now there’s some meat on the bones. You know what to research, and you know what’s missing. You know where to plug in the research.
Open up the document that you created earlier with the title and first paragraph. Type your fat outline there. If you find the fat outline difficult to write, figure out why. It’s not because you don’t know which words to use—because the fat outline is just a rough description, and the words don’t matter. Are you unsure of your audience? Are you unclear about what you ought to research? Are you not sure what order to put things in or what belongs together? Fling your thoughts into that outline draft, massage them around, add that funny turn of phrase you thought of or the stats you know are out there and you’re going to track down. Now you’re getting somewhere—even though you’re still planning and not yet actually writing.


## Do the research
Find things out and put them in folder spreadsheet or whatever

## write a draft
Now you can start writing.
Keep going until you get stuck. But when you get stuck, write yourself a note about what you need to fix (for example, “transition needed here”) and then continue. Optimally, you’ll write in 30- to 60-minute bursts with five or ten minutes in between.

draft contains 

## revise it, edit and revisit
write short
front load content (get to point early)
no passive voice
no jargon
no weasel words
use numbers, use statistics and refer to them

headings no more than 2
lists bullits

