---
title: ChatGPT in (the Core of) your Product is a Bad Idea
subtitle: Foundational models are inherently risky.
author: Roel M. Hogervorst
date: '2024-03-19'
slug: chatgpt-in-the-core-of-your-product-is-a-bad-idea
categories:
  - blog
tags:
  - ai-risks
  - antipattern
  - pseudoprofoundBS
  - genAI
difficulty:
    - beginner
post-type:
    - post
image: '/blog/2024/03/19/chatgpt-in-the-core-of-your-product-is-a-bad-idea/Clarote-AI4MediaPower_Profit-1280x720.png'
share_img: '/blog/2024/03/19/chatgpt-in-the-core-of-your-product-is-a-bad-idea/Clarote-AI4MediaPower_Profit-1280x720.png'
---

<!-- content  -->

Google ~bard~[^2] gemini, Claude, or chatGPT seem to be able to do many things. 
They have easy APIs and many plugins. The price is lower than seems possible. 

And yet, integrating these things into your product is really risky.
Here is why:

![A brightly coloured illustration which can be viewed in any direction. It has many elements to it working together: men in suits around a table, someone in a data centre, big hands controlling the scenes and holding a phone, people in a production line. Motifs such as network diagrams and melting emojis are placed throughout the busy vignettes.](Clarote-AI4MediaPower_Profit-1280x720.png)

### Problems with foundational models
These "AI's"[^3] are build on foundational models. They are trained on massive amounts of text data, and finally finetuned for specific tasks. We don't know what data was used for training. The companies will not tell us. 

- There are moral problems: the training data comes from people, people created content and require attribution. But these models regurgitate work by others without attribution. Essentially plagiarizing or stealing work. AI-models parrot back things that they were trained on, are you ok with the darkest parts of 4 chan or white supremacist internet leaking into your product?[^4]
- There are legal problems: These models can produce copyright infringement by repeating copyrighted material[^1].
- There are technical problems: these models are non-deterministic, asking the exact same thing twice will result in different answers.
- The quality of the results can vary enormously. For certain questions the results are quite good, for slightly different questions the results are dog shit. The results are never as good as the hype promised:

> if AI was actually capable of replacing the outputs of human beings — even if it was anywhere *near* doing so — any number of massive, scurrilous firms would be doing so at scale, and planning to do so more as models improved.  -- Ed Zitron 2024

The point is we don't know what data the model is trained on, what the models will answer and what information will leak out. This is all uncertainty, and uncertainty is risk. 


### Problems with consuming from a black box api
By using an API, you pay for every api call. That is nice because it makes your costs quite transparent. It also hides a lot from you.

- You don't know if the model changed. There is no way to know if the model you used yesterday is the same one as today, that matters if you want consistent results. You are unable to retrace it.
- The environmental impact of running this much compute (massive amounts of GPU) to create a really good autocomplete are staggering.
- You are not paying the actual costs, and someday you will. AI systems are subsidized by venture capital and you are not yet paying the actual costs. 

as dot jayne so elegantly wrote:

> There are many reasons not to integrate so called AI products into your business, but if there's one thing the boys in finance might understand it's that the current offerings are ~heavily~ subsidized by venture capital cash. The Silicon Valley investment model of undercutting existing methods to grow fast and become the only option before raising prices to actually be profitable is well known and anyone who doesn't think AI will follow the same price curve isn't worth the MBA that came half off with their suit.


Right now I see a lot of 'fun' projects with no real business value. The product is just not good.

If you go this route, trying to integrate an AI into your product, don't. It is risky, it isn't good. People don't trust it, the costs (environmental and moneywise) are high. 




### references


[^1]: honestly, this bothers me the least. But it seems not everyone has the same priorities and legal problems seem to be the only thing that scares otherwise immoral companies. But I digress. 
[^2]: Are they doing a *Meta*; changing names so we don't associate the previous shit with the other name? or is it an innocent name change? 
[^3]: I'll stop complaining about the word AI after this. There is no artificial intelligence. I build machine learning solutions myself, AI is only used because it reminds people of movie robots that have intelligence just like humans.
[^4]: oh wait, fascists are absolutely okay for reddit, twitter and facebook. It is not okay. 


- dot Jayne puts it way more eloquent than me in [this thread](https://tech.lgbt/@dotjayne/112090049761641133):

> Do you really want an autocorrect raised by the internet and backed by the most expensive lawyers money can buy acting as a face of or decision maker for your company? You have seen the Internet, yes??

Ed Zitron wrote in ['have we reached peak AI'](https://www.wheresyoured.at/peakai/):

> Sam Altman desperately needs you to believe that generative AI will be essential, inevitable and intractable, because if you don't, you'll suddenly realize that trillions of dollars of market capitalization and revenue are being blown on something remarkably mediocre. If you focus on the present — what OpenAI's technology can do today, and will likely do for some time — you see in terrifying clarity that generative AI isn't a society-altering technology, but another form of efficiency-driving cloud computing software that benefits a relatively small niche of people.


<span><a href="www.clarote.net">Clarote</a> & <a href="https://www.ai4media.eu/">AI4Media</a> / <a href="https://www.betterimagesofai.org">Better Images of AI</a> / Power/Profit / <a href="https://creativecommons.org/licenses/by/4.0/">Licenced by CC-BY 4.0</a></span>
