---
title: Where to live in the Netherlands based on temperature XKCD style
author: roel_hogervorst
date: '2017-11-20'
categories:
  - blog
  - R
tags:
  - XKCD
  - weather
  - humidex
  - dplyr
  - ggplot2
  - readr
  - Netherlands
slug: xkcd-the-netherlands-weather
---

After seeing a plot of best places to live in Spain and the USA based on the weather, I had to 
chime in and do the same thing for the Netherlands. The idea is simple, determine where you want to live based on your temperature preferences.

First the end result:
![Netherlands, weatherplot XKCD style](/img/xkcd_NL_US_ESP.png)
 
How to read this plot?

In [this](https://xkcd.com/1916/) xkcd comic we see that the topleft of the the graph represents "if you hate cold and hate heat", if you go down from the topleft to the bottom left the winters get colder and ending in "if you love cold and hate heat". Going to the right the heat (and humidity) go up ending in "if you love cold and love heat". Going up to the top right: "if you hate cold and love heat". 

This post explains how to make the plot, to see  where I got the data and what procedures I took look at <https://github.com/RMHogervorst/xkcd_weather_cities_nl>.

### Inspiration

According to this [post by Maële Salmon](http://www.masalmon.eu/2017/11/16/wheretoliveus/) inspired by xkcd, we can determine our ideal city by looking at wintertemperature and humidex (combination of humidity and summer heat).

I've seen major cities in the USA (post by Maelle) and where to live in Spain [by Claudia Guirao](https://twitter.com/claudiaguirao/status/931615734521909248). There is even one on France [in French, of course](https://twitter.com/matamix/status/932283897018273792).

So I had to make one for the Netherlands too. There is just a small detail, 
The Netherlands is tiny, the United States is approximately 237 times larger then The Netherlands. From The Hague to the German border directly east is 164 km (101 miles) and from Leeuwarden to Maastricht in the south is 262 km (162 miles). Essentially my home country has a moderate sea climate with warm summers and relatively mild winters. 

I expect there to be no real big differences between the cities. I use the average temperature over december, january and february for winter temperature and calculate the humidex using the [comf package](https://cran.r-project.org/web/packages/comf/index.html). This humidex is a combination of humidity and temperature. 

-   20 to 29: Little to no discomfort
-   30 to 39: Some discomfort
-   40 to 45: Great discomfort; avoid exertion
-   Above 45: Dangerous; heat stroke quite possible

For cities I went the extremely lazy way and took all of the available weatherstations provided by the Dutch weather service (KNMI, --- Royal Netherlands, Metereological Institute). There are 46 stations in the Netherlands. These are not always in the cities but sort of broadly describe the entire country.
 
### Plot like XKCD
The XKCD package has wonderful plotting abilities and a cool font that you have to install. I copied and modified the code from the post of Mäelle, because it is really good!

If you want to see how I did the data cleaning go to the [github page](https://github.com/RMHogervorst/xkcd_weather_cities_nl). 
 
First we plot all of the stations in the Netherlands *most of these places will probably not be familiar to non-Dutch people*.

``` r
library("xkcd")
library("ggplot2")
library("extrafont")
library("ggrepel")

xrange <- range(result$humidex_avg)
yrange <- range(result$wintertemp)

set.seed(3456)
ggplot(result,
       aes(humidex_avg, wintertemp)) +
  geom_point() +
  geom_text_repel(aes(label = NAME), family = "xkcd", 
                   max.iter = 50000, size = 3)+
  ggtitle("Where to live in The Netherlands \nbased on your temperature preferences",
          subtitle = "Data from KNMI, 2016-2017") +
  xlab("Summer heat and humidity via Humidex")+
  ylab("Winter temperature in Celsius degrees") +
  xkcdaxis(xrange = xrange,
           yrange = yrange)+
  theme_xkcd() +
  theme(text = element_text(size = 13, family = "xkcd"))
```

![temperature ranges in the Netherlands alone](/img/temperatureranges-in-the-netherlands-1.png)

But what does that mean, in the grand scheme of things? As you might notice the range is very small. It would be interesting to add some US cities and perhaps some Spanisch cities to compare against. For fun I also added the Dutch Caribean islands. 

``` r
xrange2 <- range(c(18,40))  # modified these by hand to increase the margins
yrange2 <- range(c(-5,40))
USA <- tribble(
      ~NAME, ~humidex_avg, ~wintertemp,
      "DETROIT, MI", 27, 0,
      "NASHVILLE, TN", 33, 9,
      "FORT MEYERS, FL",37, 20
  )
SPAIN <- tribble(
      ~NAME, ~humidex_avg, ~wintertemp,
      "MADRID, SPAIN", 27, 8,
      "TENERIFE, SPAIN", 24, 13,
      "BARCELONA, SPAIN",32, 10
  )
D_CARI <- tribble(
      ~NAME, ~humidex_avg, ~wintertemp,
      "Bonaire, Caribbean Netherlands", 27, calcHumx(29,76),
      "Sint Eustatius, Caribbean Netherlands", 28, calcHumx(28,77),   
      "Saba, Caribbean Netherlands",30, calcHumx(30,76)
  )

set.seed(3456)
ggplot(result,
       aes(humidex_avg, wintertemp)) +
  geom_point(alpha = .7) +
  geom_text_repel(aes(label = NAME),
                   family = "xkcd", 
                   max.iter = 50000, size = 2)+
  geom_text_repel(data = USA, aes(humidex_avg, wintertemp, label = NAME), family = "xkcd", 
                   max.iter = 50000, size = 2, color = "blue")+
    geom_point(data = USA, aes(humidex_avg, wintertemp), color = "blue")+
    geom_text_repel(data = SPAIN, aes(humidex_avg, wintertemp, label = NAME), family = "xkcd", 
                   max.iter = 50000, size = 2, color = "red")+
    geom_point(data = SPAIN, aes(humidex_avg, wintertemp),color = "red")+
    geom_text_repel(data = D_CARI, aes(humidex_avg, wintertemp, label = NAME), family = "xkcd", 
                   max.iter = 50000, size = 2, color = "orange")+
    geom_point(data = D_CARI, aes(humidex_avg, wintertemp), color = "orange")+
    labs(title = "Where to live in The Netherlands based on \nyour temperature preferences \nCompared with some places in Spain, Caribbean NL and USA",
          subtitle = "Data from KNMI, 2016-2017, added Spain and US cities",
         x = "Summer heat and humidity via Humidex",
         y = "Winter temperature in Celsius degrees",
         caption = "includes Caribbean Netherlands"
             ) +
  xkcdaxis(xrange = xrange2,
           yrange = yrange2)+
  theme_xkcd() +
  theme(text = element_text(size = 16, family = "xkcd"))
```

![Netherlands, weatherplot XKCD style](/img/xkcd_NL_US_ESP.png)

Finally we can compare the wintertemperature and summer humidex in The Netherlands by placing the points on a map using the coordinates of the measure stations.

``` r
NL <- map_data(map = "world",region = "Netherlands")
result %>% 
    rename(LON = `LON(east)`, LAT = `LAT(north)`) %>% 
    ggplot( aes(LON, LAT))+
    geom_point(aes(color = wintertemp))+
    geom_text_repel(aes(label = NAME),
                   family = "xkcd", size = 3,
                   max.iter = 50000)+
    geom_polygon(data = NL, aes(x=long, y = lat, group = group), fill = NA, color = "black") +
    coord_map()+
    labs(title = "Wintertemperature in NL",
         subtitle = "data from KNMI (2016,2017",
         x = "", y = "")+
    theme_xkcd()+
    theme(text = element_text(size = 16, family = "xkcd"))
```

``` r
result %>% 
    rename(LON = `LON(east)`, LAT = `LAT(north)`) %>% 
    ggplot( aes(LON, LAT))+
    geom_point(aes(color = humidex_avg))+
    geom_text_repel(aes(label = NAME),
                   family = "xkcd", size = 3,
                   max.iter = 50000)+
    geom_polygon(data = NL, aes(x=long, y = lat, group = group), fill = NA, color = "black") +
    coord_map()+
    labs(title = "Humidex in NL",
         subtitle = "data from KNMI (2016,2017",
         x = "", y = "")+
    theme_xkcd()+
    theme(text = element_text(size = 12, family = "xkcd"))+
    scale_color_continuous(low = "white", high = "red")
```
![Netherlands, humidex, gps](/img/humidex_NL.png)
![Netherlands, wintertemp, gps](/img/wintertemp_NL.png)




Now show us what your country looks like!

