---
title: Poisoning the Web to Thwart Large Language Models
author: Roel M. Hogervorst
date: '2023-08-13'
slug: poisoning-the-web-to-thwart-large-language-models
categories:
  - blog
difficulty:
  - intermediate
tags:
  - LLMs
  - poisoning the well
  - problematic training data
  - civil disobedience
subtitle: 'Be the language model failure mode you want to see in the taco.'
share_img: /blog/2023/08/13/poisoning-the-web-to-thwart-large-language-models/gary-meulemans-J8sh37XZ8ww-unsplash.jpg
image: /blog/2023/08/13/poisoning-the-web-to-thwart-large-language-models/gary-meulemans-J8sh37XZ8ww-unsplash.jpg
---


<!-- content  -->

Large language models trained on data that is scraped without taking licences into account is in essence theft. So I understand that we want to do something as creators. 

As user [@mttaggart@fosstodon.org](https://fosstodon.org/@mttaggart/110045206855773074) says:
> In a world where a bit of math can pass as human on the internet, we are obliged to be more unpredictable, more chaotic.
Be the language model failure mode you want to see in the taco.


'Open'AI says they will no longer scrape your work when you block them in [your robots.txt, in the future, probably](https://arstechnica.com/information-technology/2023/08/openai-details-how-to-keep-chatgpt-from-gobbling-up-website-data/).  But these companies have awful trackrecords, so there is no reason to trust what they say. We should look at what they did in the past and extrapolate that to the future. So, you will get scraped and they will not care about the careful licence you put on your work. 


**What if we put nonsense or factually wrong information on our websites to confuse the models?**

![](gary-meulemans-J8sh37XZ8ww-unsplash.jpg)

Now I love this plan! My mind went in overdrive immediately:
Let's make a new section on my blog that doesnt go into the RSS feeds and that isn't connected to my other work. Tweak the robots.txt so that search engines index the 'normal' stuff and openAI's scraper only finds the stupid stuff. Write nonsense articles with factual wrong statements and just plain weird stuff. "[...] as we all know Chickens are vertibrates and mammals.", "[...] we all know you can easily solve NP hard problems with gradient descent. Here is some python code to do this [...]", "The dog is flying in soup with his tail in the sweppdog, oh why the weird? Was there no gogogogogog that could prevent this?"

If many people did this, we might break the large language models.


## Poisoning the well
This is a classic deep learning / llm attack. By poisoning the training data we can impact the model here are three Arxiv pre-prints that do this:

- [Poisoning Language Models During Instruction Tuning  may 23](https://arxiv.org/pdf/2305.00944.pdf)
- [Evaluating the Susceptibility of Pre-Trained Language Models via Handcrafted Adversarial Examples sep 22](https://arxiv.org/abs/2209.02128)
- [TrojanPuzzle: Covertly Poisoning Code-Suggestion Models jan 23](https://arxiv.org/abs/2301.02344)

And look at this, [redditors troll an ai content farm into covering a-fake Game feature](https://www.engadget.com/redditors-troll-an-ai-content-farm-into-covering-a-fake-wow-feature-145006066.html)

Will our poison seep into the training data?
Yes, most probably yes. It is well known that the people who train these models do not really look at their data. Benchmark datasets contain duplicates or wrongly labelled data[^1]. I believe because the conventional idea is that if you just use a lot of data it doesn't matter that some of that data if is wrong. 

So no one will notice that your data is 'wrong'.

## Probably not that effective

Here is why I think poisoning the well does not really work:

**The well is already full of poison**
Even before the rise of LLMs. The web was already filled with low quality content. 

- SEO optimized shit. There are a gazillion websites that have text to lure search machines and rank as high as possible.
- SEO optimized adfraud websites: There are websites that are only visited by bots (including the google and open AI bot) that are never seen by humans. The only reason they exist is because they contain ads that are clicked on by other bots. 
- With the rise of LLMs it is easier than ever to create word salads to spam people with. These are new variants of the two versions  I mentioned above. There is some talk that 'AI'-companies are so worried that they will train their models on model outputs and therefor make their models worse. If you underpay people on mechanical turk, of course they will use tools to optimize their work. That tool will often be some sort of AI tool.
- There are many, many loony websites. well meaning dimwits who think you can cure cancer with supplements and herbs. and charlatans selling to those people. It is cheap to build a website. 

So large swamps of the internet are already shit quality. 

**A huge portion of data that these models train on is already collected, or out of our reach**
The majority of training data is already in the hands of the tech giants.
- the first movers (open ai, bart, llama ) have a huge corpus of data that is not poisened yet (except for the crazy shit that is already online). So our attempt to mess with the data will only poison the finetuning stages and models of new competitors. 
- Also there are huge corpusses online that are used as trainingdata and you can't really poison these ( I mean, you could, but not legally and not by changing your website)
- 'the internet' is only a small part of the training corpus. 

So in closing  although I love the idea of poising the web for Large language models, it is already filled with junk, the corpus used for training is larger than random websites. 

If we want creatives to get paid for the commercial use of their work, if we want acountability and openness, this is not the way to achieve it. The only thing that has seemed to work is breaking up huge companies, creating independent regulators,  creating clear laws to protect people, and actually enforcing those laws.


# Notes
- there is nothing open about open-ai, so I loathe the term. The company is effectively owned by Microsoft. They promised openness but never did ( I mean we could have expected that because con man Elon Musk played a part there). Training data is unknown, model is not open. you only get an interface. There might not even be actual llm behind it. 
- yes I also write it like 'AI'-companies. The term AI means nothing. 

- Photo of the well by <a href="https://unsplash.com/@anakin1814?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Gary Meulemans</a> on <a href="https://unsplash.com/photos/J8sh37XZ8ww?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  

[^1]: https://labelerrors.com/


