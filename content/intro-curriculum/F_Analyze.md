---
author: Jeffrey W. Hollister & Emily Read
date: 2016-07-05
slug: AnalyzeII
draft: True
title: F. Analyze with packages
menu:
---
    ## Warning: package 'knitr' was built under R version 3.2.5

The second section will run through a fairly quick example of using a package, `EGRET`, for some analysis. I've included this section just to show how (relatively) trivial it is to add an advanced capability to R via packages.

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Use EGRET to explore flow history
-   [Exercise 2](#exercise-2): Use EGRET WRTDS to explore long-term changes in river water quality

Lesson Goals
------------

-   Understand how to add statistical functionality to R via packages
-   See some of the best ways to learn a new package

The R Exploration and Graphics for RivEr Trends (EGRET) package was developed by USGS scientists Robert Hirsch and Laura DeCicco for the analysis of long-term water quality trends in rivers. The package integrates all of the steps a scientist needs to take when doing long term analysis: gather data from multiple sources, organize it, analyze for long-term trends, and create summary graphics for the data analysis. The Weighted Regression on Time, Discharge, and Season (WRTDS) is the method used to assess long-term changes in water quality concentrations and fluxes, and accounts for long-term changes in flow. A publication on the analytical method can be found [here](http://pubs.usgs.gov/tm/04/a10/pdf/tm4A10.pdf), and the package on R, including a vignette with examples, can be found [here](http://cran.r-project.org/web/packages/EGRET/index.html). You can also use the R help function to search within RStudio on this package and its functions. 'EGRET' uses the 'dataRetrieval' package to access data from EPA STORET and USGS NWIS. All of the examples used in this lesson are drawn from the 'EGRET' package vignette; many thanks to Laura DeCicco and Bob Hirsch for providing such excellent examples.

The `EGRET` package expands and formalizes some of the flow and water quality analyses that we scratched the surface on in [E. Analyze - base](E_Analyze.html). The implementation in R is accessed through the `EGRET` package. If you have not already, let's install this, load it up and start to look around.

``` r
options(repos=c("https://cran.rstudio.com/", "http://owi.usgs.gov/R"))
install.packages("EGRET")
library(EGRET)
help(package="EGRET")
```

Flow history
============

There are quite a few functions included with this package. First let's take a look at the flow history for a site in California with an observational record of more than 100 years:

``` r
# Merced River at Happy Isles Bridge, CA:
siteNumber <- "11264500"
Daily <- readNWISDaily(siteNumber, "00060", startDate="", endDate="")
```

    ## There are 36862 data points, and 36862 days.

``` r
INFO <- readNWISInfo(siteNumber, "", interactive=FALSE)
INFO$shortName <- "Merced River at Happy Isles Bridge, CA"
eListMerced <- as.egret(INFO, Daily, NA, NA)
plotFlowSingle(eListMerced, istat=5)
```

<img src='/static/AnalyzeII/flow_history_example-1.png'/>

``` r
# Then run the same function after setting the Period of Analysis to December
# through February only
eListMerced <- setPA(eListMerced, paStart=12, paLong=3)
plotFlowSingle(eListMerced, istat=5, qMax=200)
```

<img src='/static/AnalyzeII/flow_history_example-2.png'/>

The two plots produced here show us that although annual mean discharge does not have a strong trend at this location over the past century, discharge during the winter season appears to be increasing. This may be related to changing patterns in the fraction of precipitation that falls in this region as snow versus rain.

Next, let's take a closer look at the distribution of discharge at this site:

``` r
plotFourStats(eListMerced, qUnit=3)
```

<img src='/static/AnalyzeII/plotFourStats_example-1.png'/>

What do you notice about changes in maximum, minimum, median, and 7-day minimum?

Exercise 1
----------

Use the `plotFourStats` function to look at the spring, summer, and fall seasons. How do those trends compare to what you observed for winter? Hint: use the `setPA` function. Did you notice that the RStudio Plots tab lets you click back to previous plots?

Water quality analysis
----------------------

Next, let's consider water quality without using WRTDS:

``` r
#Choptank River at Greensboro, MD:
siteNumber <- "01491000"
startDate <- "1979-10-01"
endDate <- "2011-09-30"
param<-"00631"
Daily <- readNWISDaily(siteNumber,"00060",startDate,endDate)
```

    ## There are 11688 data points, and 11688 days.

``` r
INFO<- readNWISInfo(siteNumber,param,interactive=FALSE)
INFO$shortName <- "Choptank River"
Sample <- readNWISSample(siteNumber,param,startDate,endDate)
eList <- mergeReport(INFO, Daily, Sample)
```

    ## 
    ##  Discharge Record is 11688 days long, which is 32 years
    ##  First day of the discharge record is 1979-10-01 and last day is 2011-09-30
    ##  The water quality record has 653 samples
    ##  The first sample is from 1979-10-24 and the last sample is from 2011-09-29
    ##  Discharge: Minimum, mean and maximum 0.00991 4.09 246
    ##  Concentration: Minimum, mean and maximum 0.05 1.1 2.4
    ##  Percentage of the sample values that are censored is 0.15 %

Now the analysis is done, but we still need to do some plotting.

``` r
multiPlotDataOverview(eList, qUnit=1)
```

<img src='/static/AnalyzeII/Choptank_noWRTDS_plotexample-1.png'/>

This four panel plot shows the relationship between discharge, concentration of inorganic N, and season. Upon examination of the lower left hand plot, you may notice seasonal changes in the distribution of inorganic N observed. Next, let's use WRTDS to look further into seasonal changes.

WRTDS predicts and explains concentration based on three variables known to affect it: time, season, and discharge. To add a fitted WRTDS model to the Choptank River eList we created above, we'll use the 'modelEstimation' function:

``` r
eList <- modelEstimation(eList)
```

Exercise 2
----------

Next, use 'EGRET' functions to take a look at how well WRTDS predicts inorganic N concentration and fluxes. Hint: navigate to p. 33 of the ['EGRET' vignette](http://cran.r-project.org/web/packages/EGRET/vignettes/EGRET.pdf).

Learning a New Package
----------------------

As of Jul 25, 2016, there were 8822 packages available on [CRAN](http://cran.r-project.org/web/packages/). Given this diversity and since these packages are created and maintained by many different authors, the ways in which you can get help on a specific package and the quality of that assistance can vary greatly. That being said, there are a few indicators of decent help for a given package.

First, if a package has a vignette that is usually a good first place to start. To list the vignettes for a given package you can use the `vignette()` function. For instance:

``` r
vignette(package="knitr")
```

You can then open a specific vignette by name:

``` r
vignette("knitr-intro")
```

Second, it is becoming increasingly common to see journal articles about packages. Many journals now accept software manuscripts, but the journals I most often use for finding out about new R packages are:

*note: This is a VERY incomplete list...*

-   [Journal of Statistical Software](http://www.jstatsoft.org/)
-   [R Journal](http://journal.r-project.org/)
-   [F1000 Research](http://f1000research.com/search?q=R%20Package&sortingBy=&sortingOrder=&indexed=&articleTypes=SOFTWARE_TOOLS)
-   [PLoS One](http://www.plosone.org/search/simple?from=globalSimpleSearch&filterJournals=PLoSONE&query=R+Package&x=0&y=0)

Third, the last resort is of course [Google](http://www.google.com)!
