---
title: Writing manuscripts in Rstudio, easy citations
author: roel_hogervorst
date: '2017-03-14'
categories:
  - blog
  - R
tags:
  - citations
  - intermediate
  - tutorial
  - writing
  - reproducible
  - bibtex
  - workflow
slug: writing-manuscripts-in-rstudio
---

## Intro and setup
This is a simple explanation of how to write a manuscript in RStudio. Writing a manuscript in RStudio is not ideal, but it has gotten better over time. It is now relatively easy to add citations to documents in RStudio.

**The goal is not think about formatting, and citations, but to write the manuscript and add citations on the fly with a nice visual help. **

This tutorial explains how to link Zotero (a reference manager) to your project folder and how to easily add citations. 
In this tutorial I assume you have [Zotero](www.zotero.org) installed.
You will need to have the zotero extension [betterBibtex](https://github.com/retorquere/zotero-better-bibtex/wiki) installed and I will 
use RStudio, with the packages knitr, shiny and other basic tooling in place.
To search and insert citations in a file you will need to install the package
`citr`  install the latest [*dev-version from github*](https://github.com/crsh/citr) or the stable version from [cran](https://CRAN.R-project.org/package=citr).
 
## Why would I write my manuscript in RStudio?
The main reasons to write in RStudio ( and not in f.i. Word ) are reproducibity, and version control. Writing in plain text as you do in RStudio makes it very easy to keep track of your work with version control and the plain files are easily shared. Working from RStudio also allows you to combine the code and text in one document. This is called [literate programming](https://en.wikipedia.org/wiki/Literate_programming "wikipedia link"). Literate programming makes it incredibly easy to share your code (it's in the document) and compiling the document runs the code again, ensuring reproducibility.   

I use RStudio projects so everything
important to a project is in the same folder and the working directory is  automatically correct. I create a new RMarkdown document ![rmarkdown doc](/img/example_rstudio_manuscript.PNG)


#### Earlier workflows 
It was always possible to intersperse code and text in R, previously people used the `Sweave` package to combine code and text. You had to write the text in Latex and markup the code. Latex prints very pretty, but in raw form it is horrible to read, as you can see in the example:

```
\documentclass[12pt]{article}
\usepackage{lingmacros}
\usepackage{tree-dvips}
\begin{document}

\section*{Notes for My Paper}

Don't forget to include examples of topicalization.
They look like this:

{\small
\enumsentence{Topicalization from sentential subject:\\ 
\shortex{7}{a John$_i$ [a & kltukl & [el & 
  {\bf l-}oltoir & er & ngii$_i$ & a Mary]]}
{ & {\bf R-}clear & {\sc comp} & 
  {\bf IR}.{\sc 3s}-love   & P & him & }
{John, (it's) clear that Mary loves (him).}}
}
```
*I copied this from a example page.^[http://mally.stanford.edu/~sr/computing/latex-example.html]*

The output looks beautiful, but it's damn near unworkable in plain text. And even worse, mistakes are easily made and very hard to find (since you don't know where the trouble started, and the error messages are quite cryptic).

#### From latex / Sweave to RMarkdown

Markdown is a very simple markup language that is readable for humans and can be translated into html / latex / word / etc by computers. In stead of \section{name fo the section} we can just use a pound symbol (a.k.a. hashtag: #) to mark a heading. One pound for a heading 1, 2 for heading 2 etc. The difference between markdown and RMarkdown is R-code in the text. There are plenty good tutorials out there so I will only give you one^[http://rmarkdown.rstudio.com/lesson-1.html] and a search online will give you more.


#### Citations

Citations connect your paper to the past, linking your research to earlier research. It is essential that people can find the correct paper or book you are referring to. For that reason (and vanity I think) there are many styles of citations. I've used the APA and Chicago style in the past and there are probably about 500. Every single one has different rules; cite inline by author name and year, or by number, etc. 

If you resubmit your paper to a journal with a different citation style you have to rewrite every citation in the manuscript. Because we have better things to do, there are reference managers that automatically use the correct styling. And that change all the references in the text. I have used this in Word and LibreOffice in the past. But changing styles works a bit different in plain text formats such as markdown and latex. In general you cite research by a **key** that refers to a **bibliography**. In the build process the keys are replaced with the citations in the style that you want, so that the endproduct has the correct citations. 
This is also implemented in Latex and RStudio. In general the workflow is as follows:

1. add the citations in the correct 'language' (bibtex) to your document or to a different document and provide a link to. 
2. Use **keys** that refer to the correct entry in the bibtex. 
3. The citation manager inserts the correctly styled reference in the correct location while it writes the final version. 


You write and cite like this:

"The ggplot2 package is used to plot images in layers [@wickham_ggplot2_2009]."

The key (a at-sign and name) refers to a bibtex entry. For example:

```
@book{wickham_ggplot2_2009,
  address = {New York, NY},
  title = {Ggplot2},
  isbn = {978-0-387-98140-6 978-0-387-98141-3},
  language = {en},
  timestamp = {2017-02-19T10:19:27Z},
  urldate = {2015-11-09},
  url = {http://ggplot2.org},
  publisher = {{Springer New York}},
  author = {Wickham, Hadley},
  year = {2009},
  note = {04749},
  file = {ggplot2 - hadley wickham.pdf:C\:\\Users\\roel\\AppData\\Roaming\\Zotero\\Zotero\\Profiles\\aw40nx7l.default\\zotero\\storage\\AADU9XVP\\ggplot2 - hadley wickham.pdf:application/pdf}
}
```

Which will resolve to (if you use APA formatting): 

> The ggplot2 package is used to plot images in layers (Wickham, 2009).


### Bibtex files creation

Now, making your own bibtex files is a serious pain in the backside. So we don't do that. We also don't try to remember all the keys, but first about the creation of the bibtex file.

I don't want to keep track of the correct way to cite sources, that is just a waste of time. We have excellent reference managers for this goal. I use Zotero. I just throw the pdfs in the correct folder and Zotero finds the correct metadata using the pdfs DOI (digital object identifier). 
This is how it looks on my computer
![a snapshot of zotero on my pc](/img/example_zotero_look.PNG)

I use the extension [betterbibtex](link), that adds extra functionality to Zotero. In this case it also takes care of synchronizing the bibtext file that you export to the folder you're working in and the corresponding collection in Zotero. (see further on).

I export the collection from zotero into the rstudio folder. ![zotero keep updated image](/img/example_zotero_keep_updated.PNG)



#### The RMarkdown document
If you open a new rmarkdown document from the RStudio console a basic document with metadata is already opened. 
The top of your manuscript should contain metadata such as the title output and in this case we also need to append it to show where to find the bibliography.:
For example we make a html document called sample_Document with a bibliography based on a document bibliography.bib found in the same folder.
```
---
title: "Sample Document"
output: html_document
bibliography: bibliography.bib
---
```
While writing the manuscript we cite like so ![image of citing](/img/example_adding_citations_rmarkdown.PNG)

For more information about citations and bibliographies look at the RStudio website^[<http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html>]

#### Choosing a citation style in the manuscript
*update 2017-03-15* Michael Koontz [explains how to add a citation style to your document](https://twitter.com/_mikoontz/status/838859261572591623) in short:

1. search for a citation style <https://github.com/citation-style-language/styles/find/master> (f.i. APA)
2. find the correct file and click on raw
3. copy the link to the citation style file in the yaml
```
---
title: "Sample Document"
output: html_document
bibliography: bibliography.bib
csl: https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl
---
```



#### Making citing easier with the help of CITR
Then use the citr package <https://github.com/crsh/citr>. 
*Citr works quite nicely, but unfortunately it has recently acquired default behavior that is frankly annoying. If Zotero is active (open in a window on your computer), citr will ignore the bibliography you mentioned in the top of the document and just try to read in the entire zotero library. (which will fail on my computer) I had to change a setting to change this.*^[ you have to change `options(citr.use_betterbiblatex = FALSE)` adding this to .Renviron works].

Loading citations:
![image of loading citr](/img/example_loading_citr.PNG)

Adding a citation to a document:
![image of adding a citation](/img/example_adding_citation_with_citr.PNG)


This adds the correct citation as you can see

![side by side comparison](/img/example_citation_side_by_side.PNG)


## Conclusion
This piece became a bit longer then anticipated but I discovered new behavior of `citr`, so there's that. 
All in all RStudio / R and related tools can become the complete workbench for reading in data, cleaning and analyzing, and also writing the manuscript.


For practical examples of reproducible work see this book^[https://www.practicereproducibleresearch.org/]

## References
