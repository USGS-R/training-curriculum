---
date: 2017-02-07
slug: introR-SAWSC-Feb17
title: SAWSC - North Carolina
menu:
  main:
    parent: Course Specific Material
    weight: 1
---
February 7th - 9th in Raleigh, NC

### Installation

See [Before the Workshop](/intro-curriculum/Before) for information on what software should be installed prior to the course.

### Tentative schedule

**Day 1**

-   08:00 am - 08:30 am -- Instructors available for questions
-   08:30 am - 10:00 am -- [Introduction](/intro-curriculum/Introduction)
-   10:00 am - 10:15 am -- *Break*
-   10:15 am - 12:00 pm -- [Get](/intro-curriculum/Get)
-   12:00 am - 01:00 pm -- *Lunch*
-   01:00 pm - 03:00 pm -- [Clean](/intro-curriculum/Clean)
-   03:00 pm - 03:15 pm -- *Break*
-   03:15 pm - 04:15 pm -- More \[Clean\]
-   04:15 pm - 04:30 pm -- End of day wrap-up

**Day 2**

-   08:00 am - 08:30 am -- Instructors available for questions
-   08:30 am - 10:15 am -- [Explore](/intro-curriculum/Explore)
-   10:15 am - 10:30 am -- *Break*
-   10:30 am - 12:00 pm -- [Analyze: Base](/intro-curriculum/Analyze)
-   12:00 pm - 01:00 pm -- *Lunch*
-   01:00 pm - 02:30 pm -- Analyze: [EGRET](https://cran.r-project.org/web/packages/EGRET/EGRET.pdf), dataRetrieval
-   02:30 pm - 02:45 pm -- *Break*
-   02:45 pm - 04:15 pm -- Visualize with base R: [Visualize](/intro-curriculum/Visualize/)
-   04:15 pm - 04:30 pm -- End of day wrap-up

**Day 3**

-   08:00 am - 08:30 am -- Instructors available for questions
-   08:30 am - 10:00 am -- [Repeat](/intro-curriculum/Reproduce/)
-   10:00 am - 12:00 pm -- Practice: [USGS R packages](/intro-curriculum/USGS/), projects (group/individual), or [additional topics](/intro-curriculum/Additional/)

### Data files

Download data from the [Data page](/intro-curriculum/data/).

### Additional resources

-   [USGS-R blog](https://owi.usgs.gov/blog/tags/r)
-   [USGS-R twitter](https://twitter.com/USGS_R)
-   [USGS-R GitHub](https://github.com/USGS-R) (package source code + bug/feature reporting)
-   [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/) (data wrangling, visualization, shiny, markdown, RStudio, etc)
-   [R Markdown](http://rmarkdown.rstudio.com/lesson-1.html)

-   [dataRetrieval package tutorial](https://owi.usgs.gov/R/dataRetrieval.html#1)

### Instructors

Lindsay Carr (<lcarr@usgs.gov>) -- *primary contact*

David Watkins (<wwatkins@usgs.gov>)

Andrew Yan (<ayan@usgs.gov>)

### Lesson scripts

[This zip file](https://drive.google.com/file/d/0B54YFPSk4XN8WVQwZm1rVV9JMXM) contains the project folder and `.Rproj` file with the scripts that the instructors created in the class.

### smwrQW

`smwrQW` is a package used for analyzing censored water quality data. It does not currently have a named maintainer, but there are community efforts to address questions and fix bugs on [smwrQW's GitHub page](https://github.com/USGS-R/smwrQW/issues) in a timely fashion. The package will remain available for use on GitHub and GRAN.

The first thing to know about `smwrQW` is that all functions operate on objects of class "qw", which is a class specific to this package. For instance, it has special import functions for NWIS that use the `dataRetrieval` functions but return columns in a data.frame as "qw" objects instead of `numeric`. However, if the column does not have any censored values, the `smwrQW` functions will return them as normal `numeric` columns.

``` r
library(dataRetrieval)
library(smwrQW)

# censored values present, so importNWISqw returns a qw object
ammoniadata <- readNWISqw(siteNumbers="05330000", parameterCd="00608", endDate="2017-01-01")
class(ammoniadata$result_va)
```

    ## [1] "numeric"

``` r
ammoniadata_smwr <- importNWISqw(sites="05330000", params="00608", end.date="2017-01-01")
class(ammoniadata_smwr$Ammonia.N)
```

    ## [1] "qw"
    ## attr(,"package")
    ## [1] "smwrQW"

``` r
# no censored values present, so importNWISqw returns a numeric column
tempdata <- readNWISqw(siteNumbers="05330000", parameterCd="00010", endDate="2017-01-01")
class(tempdata$result_va)
```

    ## [1] "numeric"

``` r
tempdata_smwr <- importNWISqw(sites="05330000", params="00010", end.date="2017-01-01")
class(tempdata_smwr$WaterTempDegC)
```

    ## [1] "numeric"

We are not going to go into any additional the functions here, but will look at the resources available. This package has great documentation - there are a number of vignettes that discuss specific groups of functions and their applications. Each function is also well documented and has examples. To look at the vignettes, try running `browseVignettes("smwrQW")` or navigate to "Packages &gt;&gt; smwrQW &gt;&gt; User guides..." in your RStudio pane.

### rloadest

`rloadest` is the R application and extension of the [FORTRAN LOADEST](https://pubs.usgs.gov/tm/2005/tm4A5/pdf/508final.pdf) constituent load estimation program. Similar to `smwrQW`, this package does not have an official maintainer at this time. Questions and issues can be directed to the [`rloadest` GitHub page](https://github.com/USGS-R/rloadest), and will be answered by the USGS-R community as soon as possible.

The `loadReg` function builds a regression model using a number of built-in load estimation models, as well as user-defined models. Two additional functions take the defined load regression and return predicted concentration (`predConc`) and predicted load (`predLoad`).

There are detailed vignettes covering applications of `rloadest` models to censored oruncensored data, seasonal models, etc. See `browseVignettes("rloadest")` or navigate to "Packages &gt;&gt; rloadest &gt;&gt; User guides..." in your RStudio pane for detailed information.

Please also reference this [tutorial for using `EGRET` and `rloadest`](http://usgs-r.github.io/a-la-carte/EGRET.html#1) together.
