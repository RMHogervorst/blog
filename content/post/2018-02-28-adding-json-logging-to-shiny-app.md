---
title: Adding logging to a shiny app with loggit
author: roel_hogervorst
date: '2018-02-28'
categories:
  - blog
  - R
tags:
  - shiny
  - shiny-server
  - logging
  - loggit
  - advanced
  - R6
slug: adding-json-logging-to-shiny-app
---

*This is a very short post with example code*
Over time when you move your shiny app from your computer to a server, you
want to add some logging. Generally logging is defined in levels : INFO (everything you want to print),
WARNING (it does not stop the application, but it could be a problem), and
ERROR (fatal things).

Shiny server does already log all it's actions to
a file on the server, but that file can be hard to access.
It would be nice if every app has its own logging, close to the app location.

The package [loggit](https://github.com/ryapric/loggit) by Ryan J. Price,
overwrites the normal message, warning and stop functions
in R and replaces them with identically functioning functions, but the package
ALSO writes to a file. Thus the loggit packages writes to a json file of your
choosing and has nice timestamped data, which is extremely easy to parse.

#### Some prerequisites:
* you need to have the loggit package installed on your shiny-server
* you need to create the logfile first (empty)

#### example code
This is a non functioning app.r example.

```r
library(shiny)
library(loggit)
setLogFile("loggit.json")
loggit("INFO", "app has started", app = "start")
ui <- fluidpage(
  #your ui here
  )

server <- function(ui, server, session){
  message("this is an message")
  # it would be nice if you had some server logic here
  session$onSessionEnded(function(){loggit("INFO", "app has stopped", app = "stop")})
}
shinyApp(ui, server)
```

This example has the ui and server defined and a function shinyApp() that
starts the server.

There are 3 things I'd like to point your attention to:

* you first set your logfile location (you need to create it first)
* I've used both loggit() and the general function message() They both write to loglevel INFO
* I also used the session$onSessionEnded thingy, this is activated when you
close the app

Are all these things necessary? No absolutely not, you generally don't want to
know if an app has started, and stopped. You might only want to write the
warnings and errors to the log.

I think the package is extremely user friendly and easy to implement, would you use this in production?


Did I miss anything? Did I make a mistake? open an issue on [github](https://github.com/rmhogervorst/cleancode/issues),
or send me a message on [twitter](https://twitter.com/RoelMhogervorst).
