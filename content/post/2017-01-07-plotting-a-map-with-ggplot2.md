---
title: Plotting a map with ggplot2, color by tile
author: roel_hogervorst
date: '2017-01-06'
categories:
  - blog
  - R
tags:
  - ggplot2
  - intermediate
  - tutorial
  - maps
  - sp
slug: plotting-a-map-with-ggplot2
---

Introduction
------------

Last week I was playing with creating maps using R and GGPLOT2. As I was learning I realized information about creating maps in ggplot is scattered over the internet. So here I combine all that knowledge. So if something is absolutely wrong/ ridiculous / stupid / slightly off or not clear, contact me or [open an issue on the github page](https://github.com/RMHogervorst/BLOG/issues).

When you search for plotting examples you will often encounter the packages `maps` and `mapdata`. However most of the examples are based on the USA, which is conveniently already contained in those packages.

But since I wanted to plot The Netherlands, I was out of luck, I couldn't find a map of The Netherlands in those packages. But.. you can build those maps yourself!

This tutorial consists of :

-   downloading the shapefile of your country
-   getting the file in your R session
-   basis plotting with ggplot
-   combining the shapefile with other information

The end result is a map of a country with municipals colored by number of people in there.

Downloading the file to your computer
-------------------------------------

Steps: download shape files for your country from <http://www.gadm.org/country>

NOTE THAT YOU CAN NOT USE THESE CHARTS FOR COMMERCIAL APPLICATIONS. *You can however use charts created by the Kadaster or Netherlands Statistics Institute (CBS)*

Choose a country and choose a file format. I chose `R (SpatialPolygonsDataFrame)`. In the next page you can choose the level of detail in the map.

![image of the Netherlands with different borders](/img/gadm_levels.PNG)

The picture above you can see what I saw. This type of picture is available for every country.

If you download the shapefile on

-   level 0 : you will get the outline of the country (everything yellow)
-   level 1 : Major borders, that is every province in the Netherlands (everything red)
-   level 2 : Boundaries of counties, districts *Dutch: gemeenten* (blue lines)

If you download on level 2 you will also get the information of level 1 en level 0. The file is thus larger and has a ridiculous amount of detail.

Download the file to your computer in the folder data \[link to best practices\]

Getting the file into R
-----------------------

``` r
library(sp)  # you need this library to work with SpatialPolygons
NLD <- readRDS("shapefiles/NLD_adm2.rds")
```

At this point you can already use this file with base plot try: `plot(NLD)`

However we want to manipulate this file and use it in ggplot. The following part is about the structure of the file, to see what happens next, skip it and go to the next.

### about the structure of this file

**Note: you don't need to know this, you can just skip ahead to the next heading.** The file that you imported is a SpatialPolygonsDataFrame, which is a special object. This is a s4 object *try google for the difference between s3 and s4 objects and more in R*. Whats important is that an S4 object has 'slots' that are accessible through the `@` symbol. try typing in the name of the object followed by a `$` and with the `@` sign. The object contains a slot for *data*, *polygons*, *plotorder*, *bbox* and *proj4strings.*

\*I had great help inspecting this [stackoverflow question](https://gis.stackexchange.com/questions/87789/spatialpointsdataframe-properties-and-operators-in-r). The point of this S4 object is that you almost never have to manipulate the deeper structure of the file. there are functions that do those steps for you.

But I thought it would be interesting to understand this structure

First we look at **data**:

``` r
library(tibble) # better printing
library(dplyr)  # obviously
NLD@data %>% as_tibble()
```

    ## # A tibble: 491 × 15
    ##    OBJECTID  ID_0   ISO      NAME_0  ID_1  NAME_1  ID_2         NAME_2
    ##       <int> <int> <chr>       <chr> <int>   <chr> <int>          <chr>
    ## 1         1   158   NLD Netherlands     1 Drenthe     1    Aa en Hunze
    ## 2         2   158   NLD Netherlands     1 Drenthe     2          Assen
    ## 3         3   158   NLD Netherlands     1 Drenthe     3  Borger-Odoorn
    ## 4         4   158   NLD Netherlands     1 Drenthe     4      Coevorden
    ## 5         5   158   NLD Netherlands     1 Drenthe     5      De Wolden
    ## 6         6   158   NLD Netherlands     1 Drenthe     6          Emmen
    ## 7         7   158   NLD Netherlands     1 Drenthe     7      Hoogeveen
    ## 8         8   158   NLD Netherlands     1 Drenthe     8         Meppel
    ## 9         9   158   NLD Netherlands     1 Drenthe     9 Midden-Drenthe
    ## 10       10   158   NLD Netherlands     1 Drenthe    10    Noordenveld
    ## # ... with 481 more rows, and 7 more variables: HASC_2 <chr>, CCN_2 <int>,
    ## #   CCA_2 <chr>, TYPE_2 <chr>, ENGTYPE_2 <chr>, NL_NAME_2 <chr>,
    ## #   VARNAME_2 <chr>

``` r
NLD@data %>% tail(2)
```

    ##     OBJECTID ID_0 ISO      NAME_0 ID_1       NAME_1 ID_2      NAME_2
    ## 490      490  158 NLD Netherlands   14 Zuid-Holland  490 Zoeterwoude
    ## 491      491  158 NLD Netherlands   14 Zuid-Holland  491 Zwijndrecht
    ##       HASC_2 CCN_2 CCA_2   TYPE_2    ENGTYPE_2 NL_NAME_2 VARNAME_2
    ## 490 NL.ZH.ZD    NA       Gemeente Municipality                    
    ## 491 NL.ZH.ZW    NA       Gemeente Municipality


The slot data contains 491 rows with 15 variables. This data is hierarchical with level 1 nested under level 0 and level 2 nested under level 1. So this data contains information about municipalies (Dutch: gemeenten) that are part of a province (Dutch: provincie), that are part of a country: Nederland. On every level there is an `ID` and a `NAME`. There is a ID\_0 and a corresponding NAME\_0, and a ID\_1 with a NAME\_1 and finally a ID\_2 and NAME\_2.

The structure:

-   ID\_x: level identification ID\_0 = country, ID\_1 = province, ID\_2 = Municipality
-   NAME\_x: the name of the level region

f.i. :

    OBJECTID  ID_0   ISO      NAME_0  ID_1  NAME_1  ID_2         NAME_2   
    8         8   158   NLD Netherlands     1 Drenthe     8         Meppel

Meppel is Municipality in the Province Drenthe in the country Netherlands.

other variables: - OBJECTID: link to polygons (and rownumber) - ISO: I think the International Standards Organisation code of the country - HASC\_2 some sort of coding Country.province,area - CCN\_2 don't know - CCA\_2 don't know - TYPE\_2 name of type 2 Gemeente in my case - ENGTYPE\_2 English name for TYPE\_2 (Municipality) - NL\_NAME\_2 don't know - VARNAME\_2 I think variants of the Municipality name

Let's look at the **Polygons**

I'm not entirely sure about the relation between *data* and *polygons* but there seems to be a link where OBJECTID from data corresponds to the group ID of the polygons.

``` r
NLD@polygons %>% length()
```

    ## [1] 491

``` r
NLD@polygons[[10]] %>% # read the tenth object 
  slotNames()  # and give me the slotnames
```

    ## [1] "Polygons"  "plotOrder" "labpt"     "ID"        "area"

Every polygon object of the 491 polygons has

-   Polygons [1] : which make up the area of this part of the chart.
-   plotOrder: This has something to do with which shapes are presented first. However all the objects in here have plotOrder 1. So I really don't know what this is.
-   labpt: this is the centroid of the polygon. The middle point as it were.
-   ID: identical to rownumber/OBJECTID in `@data`
-   area: I think the square kilometer area inside the polygon.

I believe that there can be more Polygons inside the Polygons of an area. So if we look inside of one polygon in a polygon..

``` r
NLD@polygons[[10]]@Polygons[[1]] %>% slotNames()
```

    ## [1] "labpt"   "area"    "hole"    "ringDir" "coords"

We see that every part has a middle point, area size a hole a ringdir and a matrix of coordinates.

Lets move back out to the top and look at plotorder: which is 1 again... and the other two slots: bbox and proj4string.

**bbox** is the bounding box. the ultimate limits of the area described by this dataframe.

``` r
NLD@bbox
```

    ##         min       max
    ## x  3.360782  7.227095
    ## y 50.723492 53.554585

**proj4string** is a notation that tells graphical systems what coordinate system is used. Because there are a lot of coordinates!
in this case `+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0` So a longitude lattitude projection, with datum wgs84 which is a [worldwide used coordinate system](https://en.wikipedia.org/wiki/World_Geodetic_System). And I think the last part is an ofset if necessary.

So concluding: This dataframe consists of general describing data in `@data` coordinates for every row, with some coordinate referencing to help translating the coordinates into other projections.

*Read on from here* \#\# Basic plotting of the map with ggplot Why don't we just plot the map?

``` r
library(ggplot2) # can't work without it
ggplot(data = NLD, aes(x = long, y = lat))+
  geom_polygon( )
```

    ## Regions defined for each Polygons

![](/img/figures/unnamed-chunk-5-1.png)

We got a message: Regions defined for each Polygons, this is ggplot telling us that some work was done on the background to reshape the data for plotting use.

Also, the map looks really, really ugly. What's the deal? Because ggplot doesn't know what kind of data this is, it stretches the points untill the plotting region is filled.

Let's try something where all the steps in the x direction are identical to the y direction. Let's fix the coordinates.

``` r
library(ggplot2)
ggplot()+
  geom_polygon(data = NLD, 
               aes(x = long, y = lat, group = group)) +
  coord_fixed()
```

    ## Regions defined for each Polygons

![](/img/figures/unnamed-chunk-6-1.png)

This looks better, but for people from the Netherlands, this still doesn't look quite right. The country is stretched in a weird way and the center, filled with a [big ass man made lake](https://en.wikipedia.org/wiki/IJsselmeer "this lake used to be a sea, but we didn't want a sea anymore") should not by plotted.

First the stretching. There is a special coordinate thingy in ggplot called coord\_map(). I like the standard projection, but if you liek you can try any of the projections in `?mapproj::mapproject` . Go crazy!

``` r
ggplot()+
  geom_polygon(data = NLD, aes(x = long, y = lat, group = group)) +
  coord_map()
```

    ## Regions defined for each Polygons

![](/img/figures/unnamed-chunk-7-1.png)


Lets first take out the lakes. This is where local knowledge comes to play. If we look at the level\_1 names `NLD@data$NAME_1 %>% unique()`, we see 14 different areas. However, there are only 12 provinces in the Netherlands. 2 of these areas are actually lakes: "IJsselmeer" and "Zeeuwse meren". We can get those out by using subset.[2]. The command says: subset NLD where NLD$NAME\_! is NOT the two lakes.

I also want to lose the message. Use `fortify()` to apply the polygons to region transformation.

``` r
NLD_fixed <- subset(NLD, !NLD$NAME_1  %in% c("Zeeuwse meren", "IJsselmeer"))
NLD_fixed <- fortify(NLD_fixed)
```

    ## Regions defined for each Polygons

``` r
#NLD_fixed <- broom::tidy(NLD) # this would also work and is recommended by Hadley Wickham in the future.
ggplot(NLD_fixed) +
  geom_polygon( aes(x = long, y = lat, group = group))+
  coord_map()
```

![](/img/figures/unnamed-chunk-8-1.png)

Let's add some color!

``` r
ggplot(NLD_fixed) +
  theme_minimal()+  # no backgroundcolor
  geom_polygon( aes(x = long, y = lat, group = group),
                color = "white",   # color is the lines of the region
                fill = "#9C9797")+ # fill is the fill of every polygon.
  coord_map()
```

![](/img/figures/unnamed-chunk-9-1.png)

Combine the map with another dataset and color the tiles
--------------------------------------------------------

From the open data portal of the Netherlands I downloaded the number of people every municipally. Yeah open data!

loading the data. skipping the file information, selecting only the columns with a municipal name and number and throwing away empty columns. *note that there will be some discrepancies, the map information is a bit older and the municipallies are from 2016, so some names might not match. If I really care I could do some matching. But I don't.*

``` r
gemeenten2016sept <- readr::read_csv2("data/Bevolking__leeftijd,_050117111254.csv",skip = 3) %>% 
select(gemeente = `Regio's`, number = aantal) %>% filter(!is.na(number))
```

    ## Parsed with column specification:
    ## cols(
    ##   `Regio's` = col_character(),
    ##   Perioden = col_integer(),
    ##   Leeftijd = col_character(),
    ##   aantal = col_integer()
    ## )

    ## Warning: 1 parsing failure.
    ## row col  expected    actual
    ## 391  -- 4 columns 1 columns

Combining the map information, names of municipalies and number of people in one file.

-   combine IDs inside the map information, with names and numbers.

``` r
names_and_numbers <- data_frame(id=rownames(NLD@data),
                                gemeente=NLD@data$NAME_2) %>% 
  left_join(gemeenten2016sept, by = "gemeente")
```

-   Combining the names and numbers with the map information.

``` r
final_map <- left_join(NLD_fixed, names_and_numbers, by = "id")
ggplot(final_map)+
  theme_minimal()+
  geom_polygon( aes(x = long, y = lat, group = group, fill= number),
                color = "grey", alpha = 1/5) +
  coord_map()+
  scale_fill_distiller(name = "Number of people in gemeente", # change title legend
                       palette = "Spectral")+ # change the color scheme
  theme(legend.position = "bottom")  # chagne the legend position
```

![](/img/figures/unnamed-chunk-12-1.png)

[1] I know! really confusing, polygons inside polygons!, crezy!

[2] I haven't found a tidy way to do this yet


References
----------

-   <http://www.milanor.net/blog/maps-in-r-introduction-drawing-the-map-of-europe/>
-   <http://stackoverflow.com/questions/9199727/themathic-map-choropleth-map-of-the-netherlands>
-   <https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-kadaster/bestuurlijke-grenzen-actueel>
-   <http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html>

#### Session info

``` r
devtools::session_info()
```

    ## Session info --------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.3.2 (2016-10-31)
    ##  system   x86_64, mingw32             
    ##  ui       RTerm                       
    ##  language (EN)                        
    ##  collate  Dutch_Netherlands.1252      
    ##  tz       Europe/Berlin               
    ##  date     2017-01-07

    ## Packages ------------------------------------------------------------------

    ##  package      * version date       source        
    ##  assertthat     0.1     2013-12-06 CRAN (R 3.3.0)
    ##  backports      1.0.4   2016-10-24 CRAN (R 3.3.2)
    ##  colorspace     1.3-2   2016-12-14 CRAN (R 3.3.2)
    ##  DBI            0.5-1   2016-09-10 CRAN (R 3.3.1)
    ##  devtools       1.12.0  2016-06-24 CRAN (R 3.3.1)
    ##  digest         0.6.10  2016-08-02 CRAN (R 3.3.1)
    ##  dplyr        * 0.5.0   2016-06-24 CRAN (R 3.3.1)
    ##  evaluate       0.10    2016-10-11 CRAN (R 3.3.2)
    ##  ggplot2      * 2.2.1   2016-12-30 CRAN (R 3.3.2)
    ##  gtable         0.2.0   2016-02-26 CRAN (R 3.3.0)
    ##  htmltools      0.3.5   2016-03-21 CRAN (R 3.3.0)
    ##  knitr          1.15.1  2016-11-22 CRAN (R 3.3.2)
    ##  labeling       0.3     2014-08-23 CRAN (R 3.3.0)
    ##  lattice        0.20-34 2016-09-06 CRAN (R 3.3.2)
    ##  lazyeval       0.2.0   2016-06-12 CRAN (R 3.3.0)
    ##  magrittr       1.5     2014-11-22 CRAN (R 3.3.0)
    ##  mapproj        1.2-4   2015-08-03 CRAN (R 3.3.2)
    ##  maps           3.1.1   2016-07-27 CRAN (R 3.3.2)
    ##  memoise        1.0.0   2016-01-29 CRAN (R 3.3.0)
    ##  munsell        0.4.3   2016-02-13 CRAN (R 3.3.0)
    ##  plyr           1.8.4   2016-06-08 CRAN (R 3.3.0)
    ##  R6             2.2.0   2016-10-05 CRAN (R 3.3.1)
    ##  RColorBrewer   1.1-2   2014-12-07 CRAN (R 3.3.0)
    ##  Rcpp           0.12.8  2016-11-17 CRAN (R 3.3.2)
    ##  readr          1.0.0   2016-08-03 CRAN (R 3.3.1)
    ##  rmarkdown      1.3     2016-12-21 CRAN (R 3.3.2)
    ##  rprojroot      1.1     2016-10-29 CRAN (R 3.3.2)
    ##  scales         0.4.1   2016-11-09 CRAN (R 3.3.2)
    ##  sp           * 1.2-4   2016-12-22 CRAN (R 3.3.2)
    ##  stringi        1.1.2   2016-10-01 CRAN (R 3.3.1)
    ##  stringr        1.1.0   2016-08-19 CRAN (R 3.3.1)
    ##  tibble       * 1.2     2016-08-26 CRAN (R 3.3.1)
    ##  withr          1.0.2   2016-06-20 CRAN (R 3.3.1)
    ##  yaml           2.1.14  2016-11-12 CRAN (R 3.3.2)

