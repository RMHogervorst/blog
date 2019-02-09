---
title: From spss to R, part 4
author: roel_hogervorst
date: '2016-04-04'
categories:
  - blog
  - R
tags:
  - beginner
  - dplyr
  - ggplot2
  - spps-to-r
  - tutorial
slug: from-spss-to-r-part4
---

This is the second part of working with ggplot. We will combine the 
packages dplyr and ggplot to improve our workflow. 
When you make a visualisation you often experiment with different versions of your plot. Our workflow will be dynamic, in stead of saving every version of the plot you created, we will recreate the plot untill  it looks the way you want it. 

In [the previous lesson](https://blog.rmhogervorst.nl/blog/2016/03/02/from-spss-to-r-part3.html "a full link to the previous lesson") we worked with some build in datasets. But there is often more fun in public real world datasets. 

We will work with the Dutch government data about higher education more info at <https://www.duo.nl/open_onderwijsdata/databestanden/ho/ingeschreven/wo-ingeschr/ingeschrevenen-wo1.jsp "UPDATE 2017, NEW LOCATION, THANKS GOVERNMENT...">. To help you along I have already transformed the data into a more tidy format [^1]. The data can be found at my github repository at this link: <https://github.com/RMHogervorst/cleancodeexamples/blob/master/files>. UPDATE 2017-08-23, SPSS FORMAT HAS CHANGED IN HAVEN, SO NEW DATA (2016) WITH FILES BOTH IN SPSS AND CSV FORMAT.

*Everything else is the same, but the data is newer (2016, you can still work with the 2015 data in csv format, that will never break)*

# Getting started

You will need:

- Internet access
- Rstudio
- a recent version of R
- the packages: dplyr, ggplot2, readr.

You need to understand / apply

- chaining commands using the pipe (`%>%`) operator
- opening and closing of Rstudio, the assign (`<-`)  operator
- recently used the dplyr commands (did you do the [second](https://blog.rmhogervorst.nl/blog/2016/02/22/from-spss-to-r-part2.html) lesson? you're good then)


## Starting loading the file and a first look

Start a new project in Rstudio or open a project you created in a previous session [^2]. 
Copy the steps in your script or the console or follow the [script](https://github.com/RMHogervorst/cleancodeexamples/blob/master/scripts/introduction-to-ggplot2-part2.R). 

```r
#location of files: "https://github.com/RMHogervorst/cleancodeexamples/blob/master/files"

link<-"https://raw.githubusercontent.com/RMHogervorst/cleancodeexamples/master/files/duo2016_tidy.csv"
# Libraries to use
library(dplyr) # yes I use it almost daily
library(ggplot2)
library(readr) # for the use of read_csv 
# (there is also a read.csv function in base r, but it has some undesirable properties)
# load the data
duo2015_tidy<- read_csv(link)
# This is the same file we used in: 
# https://blog.rmhogervorst.nl/blog/2016/02/24/creating-tidy-data.html
# look at the data with View(duo2015_tidy) or
glimpse(duo2015_tidy)  # often more meaningful

```

The file contains the number of students per year per gender per program in Dutch Universities between 2011 and 2015.
Look around the dataset and get a sense of what it contains. Unfortunately for non-Dutch speakers, the set is entirely in Dutch...  But I will explain the variables for you so far as I know.

- PROVINCIE		province, which of the twelve [provinces](https://en.wikipedia.org/wiki/Provinces_of_the_Netherlands)
- GEMEENTENUMMER	municipal number	No idea what basis this has
- GEMEENTENAAM		municipal name	(some municipals have changed names)
- SOORT INSTELLING	type of university regular or small
- BRIN.NUMMER.ACTUEEL no idea some sort of govermental number per university
- INSTELLINGSNAAM.ACTUEEL	University name at this moment (some have changed over time)
- CROHO.ONDERDEEL		CROHO stands for Central Registry Programs Higher Education
- CROHO.SUBONDERDEEL	ONDERDEEL means part, and subonderdeel subpart (every program in the Netherlands has a unique number
- OPLEIDINGSCODE.ACTUEEL	code of the program
- OPLEIDINGSNAAM.ACTUEEL	Name of the program (can change of course...)
- OPLEIDINGSVORM	type of education, voltijd means fulltime, deeltijd means part time and duaal means dual, or a mix of working and studying
- OPLEIDINGSFASE.ACTUEEL might be recognizable; bachelor, master or bachelor propedeuse (first year of bachelor)
- YEAR		Yeah, I translated that one already
- GENDER	is actually also a dutch word meaning the same thing
- FREQUENCY	how many students in this particalar group

Now that we know the structure of the dataset we can look at parts of it.

## Slicing and dicing your set while exploring

The most important lesson of today is: 

> don't save intermediate results / datasets / images

In SPSS if you want to look at a subset of your data you would either create a selection group or save some results to a different file. While we can do that in R, it's better to create a pipeline of data and change some of the steps. IT saves memory (mostly not important) but even better it keeps your dataset intact and prevents a filelist of over 200 files with uninspiring and meaningless names such as: ` dataset1, dataset2AFTERSAVING, dataset456 ` etc. This will keep your work, your workspace and your code **clean**[^3].

We will first look at some details in the dataset. Follow along if you like but even better would be if you try to vary some steps. Instead of  `YEAR ==2016` take `2011` or only take master students. Learn by making mistakes and by following up on interesting side stories. 

```r
# First filter on 2015, full time and bachelor.
duo2015_tidy %>% filter(YEAR == 2015 & OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>% View
```

This will display a subsample of your data. But for every unique program there are two rows. One for males (MAN) and one for females (VROUW). 
You might not care for the seperate groups and want to combine them.

```r
duo2015_tidy %>% filter(YEAR == 2015 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        View
```

This might seem like a lot of typing, but you can just modify the last part of the commands by adding the group_by and summarize commands. 

An other thing you might have noticed, is that the previous data frame result is now gone and replaced by this result. That is fine, it was temporary anyways. 

An other question could be if the numbers per program changed over time?

```r
duo2015_tidy %>% filter(YEAR == 2014 & 
                                OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        View
```

However there is just to much information to compare. Let's see if we can visualize these numbers.
Now this might look a bit odd because we will combine a chain of commands with the pipe (`%>%`) operator and then we add layers of the plot with the plus sign (`+`)[^4]. 

```r
duo2015_tidy %>% filter( OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        group_by(OPLEIDINGSNAAM.ACTUEEL, YEAR) %>% summarise(combinedMF = sum(FREQUENCY)) %>%
        ggplot(aes(YEAR, combinedMF)) + geom_line(aes(group = OPLEIDINGSNAAM.ACTUEEL))
```

I agree that this endresult is less then useful. But look at the code it's really interesting. 
This is a great time to take a little excursion

### a small excursion into chaining 
*Think back to part 2 of this course about chaining and dplyr*
We started with the same chain that created a the summarized data frame. That data frame can be imported by ggplot. Remember that the pipe operator puts the end result as first argument in the command after it. *dplyr = layered grammar of data manipulation* and *ggplot2 = layered grammar of graphics* . So we have two sets of grammar here.

The code above is just a simplified, much easier to read, notation of the following code:

```r
TEMP1 <-   summarise(group_by(filter(duo2015_tidy,  OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor"), OPLEIDINGSNAAM.ACTUEEL, YEAR) ,combinedMF = sum(FREQUENCY))
# do you still see where the arguments of every command are?
ggplot(data = TEMP1, aes(YEAR, combinedMF)) + geom_line(aes(group = OPLEIDINGSNAAM.ACTUEEL))
```
  
As you can see it's hard to read what happened, or when things break, what arguments belong to which function. further more for every plot call you need to create a temporary dataset. One you will probably forget to remove afterwards.

The pipe operator works with every command that starts with a data argument and there are ways to make it work with other commands. It really makes your life easier.

End of excursion, why don't we make some useful plots.

## Making plots that look better

There is a lot of information in this dataset. We will need to be more specific in our questions.
How many programs are there actually? 

There are 666 unique program names. 

What code would you use to find this out? [^5]

Since every bachelor and masters program has a unique name and since bachelors generally give access to multiple masters, there are many many program names. But how many programs are there in the bachelor propedeuse phase?

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" &
                                OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        distinct(OPLEIDINGSNAAM.ACTUEEL) 
```
The end result is a data frame with 141 cases/ rows. Look at the data frame. 

Is this a combination of males and females? Or are these really all the programs?[^6] 

So there are 141 programs and many universities. Let's first focus on one program in different universities. Two very popular programs in the Netherlands are Psychology[^7] and Law.
What happens here: 

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" |OPLEIDINGSNAAM.ACTUEEL == "B Rechtsgeleerdheid" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER)) + 
		facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL)
```

- Take dataset
- only rows with  fulltime AND first year bachelor
- only rows with B psychology OR B law
- set up ggplot with year at the x axis, frequency at y axis and group by GENDER *
- make a line plot, colour by GENDER, and
- facet (make subplots) by municipal and program

`*` The setting up part `ggplot()` doesn't draw anything yet.

Look at the plot. (I have recreated it here using `ggsave("plot-psylawcities.png")`)

![first plot of Psychology and Law in different cities by gender over time](/img/plot-psylawcities.png)

This is just a first plot, it's far from pretty. It has no title, the years at the borders of psychology and law overlap, the name of the municipal/ city is not readable, and the colors of the gender are counter intuitive. If I had used these colors, blue for males and red for females would be more in line with western culture[^8].

Another problem is that the Amsterdam numbers for Law are much lower then for Psychology, they don't display so well on this scale. A separate plot for Psychology and Law would be better.

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_colour_manual(values=c( "lightblue", "pink")) 
```
Let's address both color (going stereotype blue and pink) and program.
After my first plot, I found the lines a bit thin, so I set the size. I also used a manual color scale. 

![plot with different colors only psychology](/img/plot-psypinkblue.png)

One of the odd things about rstudio is that if you click on the zoom button the plot looks good, but if you use ggsave it takes the uglier version in the side viewer. I guess I could change the settings in  the ggsave command[^9].

## Advanced ggplot

The colors in the plot are not so bright. Which is actually a good thing for printing. But in this plot it can make it hard to read. 

So let's use some other custom colors.

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_colour_manual(values=c( "#3399ff", "#ff00ff"))
```
The colors are a number, how does that work?
Colors in R, or in all sorts of programs really, can be specified with their name: "red, magenta", "cyan", "black" etc. Or with their html code "#000fff" pick it with this [site](http://www.w3schools.com/colors/colors_picker.asp). 

Take for instance the very ugly color "Aqua", it has the name aqua, the html code #00ffff, rgb(0,255,255) and hsl(180,100%, 50%). Using a site such as the one above can help you in picking colours. to use in your plots. Try to plot the plot above with aqua or #00ffff as one of the values.

An other way to change the colors is by using a color package. 
One great package is the [color brewer package](http://www.r-bloggers.com/r-using-rcolorbrewer-to-colour-your-figures-in-r/). Install the package and try `RColorBrewer::display.brewer.all(n=8, exact.n=FALSE)` to see the different colors. 

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")
```

This looks somewhat better. 
More information about colors and creating your own colors can be found at:
<http://www.cookbook-r.com/Graphs/Colors_%28ggplot2%29/>

In the previous lesson we used different themes to customize the plots. 
We can change features of the plot like the title, axis labels, axis details and many more aspects. 

To add a title to a plot use the ggtitle command. 
```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
		ggtitle("Psychology students in several cities over five years")
```

So this works, but with the title the axis labels for years and frequency are redundant.
To remove parts of a plot we need to modify the theme settings. A theme is used for all aspects of the plot. where the axis are, what the labels are and so forth. To modify these parts of the plot you need the `theme()` command. Inside the theme command you give the arguments `axis.title.x= element_blank()` to remove the x axis or `legend.position= "bottom"` to put the legend at the bottom of the plot.

You don't need to remember them all. Use the cookbook for r or search for what you want to change online. 

for example the following code:

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
        ggtitle("Psychology students in several cities over five years") +
        theme(axis.title.x = element_blank(),  # changing multiple theme settings
              axis.title.y = element_blank(),  # on a temporary basis, only for this plot
              legend.position = "bottom",
              strip.text.y=element_text(angle = 0, vjust = 0.5) # make readable
        )
```

Produces the following plot (with `ggsave("psychologystudentscities.png", scale = 1.5)`:

![](/img/psychologystudentscities.png)

If you find yourself repeating the same theme changes in multiple plots, you are violating the DRY principle (Do not repeat yourself). ggplot changes are just lists in R, so you can save all the changes to a list and apply that list to your plots. for example:

This is your plot

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
        ggtitle("Psychology students in several cities over five years") +
        theme_minimal() 
```

The first part is identical as before, but I'm a big fan of the minimal theme. It removes all sorts of chart junk.  However, you don't like the way the cities are placed. You want it horizontal.
And you don't like the labels on the axes. 

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
        ggtitle("Psychology students in several cities over five years") +
        theme_minimal() +
        theme(axis.title.x = element_blank(),  # changing multiple theme settings
              axis.title.y = element_blank(),  # on a temporary basis, only for this plot
              legend.position = "bottom",
              strip.text.y=element_text(angle = 0, vjust = 0.5) # make readable
        )
```

This is nice, but you want to recreate the same style for many programs and like any person you hate to copy paste everything. It is time for your own theme.

A ggtheme has every option that you could set defined. So it is possible to create that from scratch, I do not recommend it. The best option is to use a predefined theme and overlay your changes, like you already did above, you first called the theme_minimal() layer and than changed some theme elements.

In practice:

```r
# This is the theme, it is simply the minimal theme with the 
# modifications added. 
studytheme <- theme_minimal() + 
        theme(axis.title.x = element_blank(),  # changing multiple theme settings
              axis.title.y = element_blank(),  # on a temporary basis, only for this plot
              legend.position = "bottom",
              strip.text.y=element_text(angle = 0, vjust = 0.5) # make readable
        )
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Psychologie" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
        ggtitle("Psychology students in several cities over five years") +
        studytheme
```

And now with the Law program.

```r
duo2015_tidy %>% filter(OPLEIDINGSVORM == "voltijd onderwijs" & OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor") %>%
        filter(OPLEIDINGSNAAM.ACTUEEL == "B Rechtsgeleerdheid" ) %>%
        ggplot(aes(YEAR, FREQUENCY, group = GENDER)) +
        geom_line(aes(colour = GENDER), size = 1) + facet_grid( GEMEENTENAAM ~ OPLEIDINGSNAAM.ACTUEEL) +
        scale_color_brewer( palette = "Accent")+
        ggtitle("Law students in several cities over five years") +
        studytheme
```


<figure class="half">
	<img src="/img/lawstudents-clean.png" alt="image">
	<img src="/img/psystudents-clean.png" alt="image">
	<figcaption>law and psychology students plots</figcaption>
</figure>

 
# Summary and wrapping it up

In the previous lessons you learned how to make basic plots, how to select, filter and combine the dplyr verbs. This lesson you combined these skills. Furthermore you can now customize your plots, create a style/theme and apply that theme to your plots. Making it very consistent. 

This was the final introduction to R from SPSS. From now on, you are a R user. You know the basic commands, you can find what you are looking for online or in the help function,  and you are able to generate advanced plots.  
 


## Further Reading

^[Datacamp: 5 hour video introduction to ggplot2](http://www.r-bloggers.com/the-easiest-way-to-learn-ggplot2/ "I have not seen this, let me know")

- <http://www.cookbook-r.com/Graphs/>
- more information about themes <http://docs.ggplot2.org/dev/vignettes/themes.html>

### Use examples ggplot2

- examples of graphics. <http://r4stats.com/examples/graphics-ggplot2/>
- Color palettes in R. <http://vis.supstat.com/2013/04/plotting-symbols-and-color-palettes/ >



## NOTES
[^1]: Tidying was done in a different blog post: <https://blog.rmhogervorst.nl/blog/2016/02/24/creating-tidy-data.html> 
[^2]: R projects keep you code and workspace setting contained. So you can work with wildly different settings without resetting them between sessions. 
[^3]: I mean, I had to refer to the name of this blog at least once. But I think it's really important. I always lose track of all the subfiles, so this is much better. and faster.
[^4]: It is odd, and hadley wickham, the creator of ggplot and dplyr (which imported the pipe operator) , agrees. But this is the way it is and changing it will break the code of millions of users...
[^5]: There are multiple ways to do this but I would use this `length(unique(duo2015_tidy$OPLEIDINGSNAAM.ACTUEEL))`
[^6]: No these are the programs in total, because of the `distinct()` command. That is the dplyr way of selecting unique cases.
[^7]: Psychology is arguably a study often chosen for lack of ideas: " I didn't really know what to choose so I chose something social...". I'm not sure how many students have this attitude. 
[^8]: Or at least in the Netherlands babyblue is a common color for males. Red not so much specific for females, but pink would be.  
[^9]: I actually found `ggsave("nameofplot.png",scale = 1.5)` to work nicely.
