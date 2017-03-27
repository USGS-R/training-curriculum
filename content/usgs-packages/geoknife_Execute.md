---
author: Lindsay R. Carr
date: 9999-09-30
slug: geoknife-job
title: geoknife - construct calls
image: img/main/intro-icons-300px/r-logo.png
identifier: 
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
draft: true
---
Setting up a geojob
-------------------

A `geojob` is the object that contains all of the necessary processing information to execute a data request to GDP. The `geojob` is made up of the `stencil`, `fabric`, and `knife` (if you need to learn what these components are, please visit [the previous lesson](/usgs-packages/geoknife_Discovery)).

To create a `geojob`, use the function `geoknife` and give the three components as arguments. `stencil` and `fabric` must be indicated, but `knife` has a default. Any additional arguments are specifications for the webprocessing step. See `?'webprocess-class'` for options. This lesson will not discuss all of the options.

``` r
# load the geoknife package
library(geoknife)
```

    ## 
    ## Attaching package: 'geoknife'

    ## The following object is masked from 'package:stats':
    ## 
    ##     start

    ## The following object is masked from 'package:graphics':
    ## 
    ##     title

    ## The following object is masked from 'package:base':
    ## 
    ##     url

Let's setup a `geojob` to find the unweighted annual evapotranspiration rates for the state of Indiana using the annual evapotranspiration data we saw in [the previous lesson](usgs-packages/geoknife_Discovery/#available-webdata). Since we have seen the URL and know the available variables and times, we can set all of that manually in the `webdata` function. Note: the times field must be a vector of start then end date, and be class `POSIXct`.

``` r
# create fabric
evap_fabric_info <- list(times = as.POSIXct(c("2005-01-01", "2015-01-01")),
                         variables = "et",
                         url = 'https://cida.usgs.gov/thredds/dodsC/ssebopeta/yearly')
evap_fabric <- webdata(evap_fabric_info)

# create stencil
evap_stencil <- webgeom('state::Indiana')

# create knife (which defaults to weighted)
evap_knife <- webprocess()
# find unweighted algorithm
all_algorithms <- query(evap_knife, 'algorithms')
unw_algorithm <- all_algorithms[grep('unweighted', names(all_algorithms))]
# set knife algorithm to unweighted
algorithm(evap_knife) <- unw_algorithm

# create the geojob
evap_geojob <- geoknife(evap_stencil, evap_fabric, evap_knife)
```

Checking the geojob status
--------------------------

The geojob has been created and started on the server. Now, you can check to see if the processing is complete by using `check`.

``` r
check(evap_geojob)
```

    ## $status
    ## [1] "Process successful"
    ## 
    ## $URL
    ## [1] "https://cida.usgs.gov:443/gdp/process/RetrieveResultServlet?id=ab3875fd-f487-4e01-9e91-abfc38b4b240OUTPUT"
    ## 
    ## $statusType
    ## [1] "ProcessSucceeded"

Other helpful functions to get status information about the job are `error` (returns T/F to say if there was an error during the processing) and `successful` (returns T/F indicating whether the job process was able to complete without any issues). Only one of these can return `TRUE` at a time.

``` r
error(evap_geojob)
```

    ## [1] FALSE

``` r
successful(evap_geojob)
```

    ## [1] TRUE

The results of all the status checks say that our job was successful!

Getting geojob data
-------------------

Since this job has finished processing and was successful, you can now get the data. You'll notice that `evap_geojob` does not actually contain any data. It only contains information about the job that you submitted. To get the data, you need to use `result` or `download`. The stock statistics algorithms will return simple tabular data, so you can use `result` to automatically take the output and parse it into an R `data.frame`. We used a basic stat algorithm in the evapotranspiration example, so let's use `result` to get the `geojob` output.

``` r
evap_data <- result(evap_geojob)
nrow(evap_data)
```

    ## [1] 11

``` r
head(evap_data)
```

    ##     DateTime  Indiana variable statistic
    ## 1 2005-01-01 603.7376       et      MEAN
    ## 2 2006-01-01 688.1866       et      MEAN
    ## 3 2007-01-01 576.3254       et      MEAN
    ## 4 2008-01-01 691.2009       et      MEAN
    ## 5 2009-01-01 689.2706       et      MEAN
    ## 6 2010-01-01 630.4045       et      MEAN

Other stock algorithms could return netcdf or geotiff data. This will require you to handle the output manually using `download`. This will allow you to download the output to a file and then read it using your preferred method (e.g. `read.table`, `read.csv`). See `?download` for more information.

wait and email
--------------

This was not a computationally or spatially intensive request, so the job finished almost immediately. However, if we had setup a more complex job, it could still be running. Even though the processing of these large gridded datasets uses resources on a remote server, your R code could be impacted by the length of the processes. There are a few scenarios to consider:

1.  You are manually executing a job and manually checking it.
2.  You are running a script that kicks off a `geoknife` process followed by lines of code that use the returned data.
3.  You are running a long `geoknife` process and want to be able to close R/RStudio and come back to a completed job later.

For the first scenario, the workflow from above was fine. If you are manually checking that the job has completed before trying to extract results, then nothing should fail.

For the second scenario, your code will fail because it will continue to execute the code line by line after starting the job. So, your code will fail at the code that gets the data (`result`/`download`) since the job is still running. You can prevent scripts from continuing until the job is complete by using the function `wait`. This function makes a call to GDP to see if the job is complete at specified intervals, and allows the code to continue once the job is complete. This function has two arguments: the `geojob` object and `sleep.time`. `sleep.time` defines the interval at which to check the status of the job. Please try to adjust `sleep.time` to limit the number of calls to GDP, e.g. if you know the job will take about an hour, set `sleep.time=1800` (a half hour). The default for `sleep.time` is 5 seconds.

``` r
# typical wait workflow
evap_geojob <- geoknife(evap_stencil, evap_fabric, evap_knife)
wait(evap_geojob, sleep.time = 10)
evap_data <- result(evap_geojob)
```

If you know ahead of time that your process will be long, you can tell the job to wait to continue when defining your knife (the default is to not wait). `sleep.time` can be specified as an argument to `webprocess`. The following is functionally the same as the use of `wait()` from above.

``` r
# create knife with the args wait and sleep.time
evap_knife <- webprocess(wait=TRUE, sleep.time=10)

# follow the same code from before to get the unweighted algorithm
all_algorithms <- query(evap_knife, 'algorithms')
unw_algorithm <- all_algorithms[grep('unweighted', names(all_algorithms))]
algorithm(evap_knife) <- unw_algorithm

# create geojob using knife w/ wait
evap_geojob <- geoknife(evap_stencil, evap_fabric, evap_knife)

# get result
evap_data <- result(evap_geojob)
```

As in the third scenario, if you have a job that will take a long time and plan to close R in the interim, you can specify the argument `email` when creating the knife. Then when you use your new knife in the `geoknife` call, it will send an email with appropriate information upon job completion. The email alert will contain the completed job URL and ID needed to pull down the data later using `result` (needs URL) or `download` (needs ID).

``` r
# example of how to specify an email address to get a job completion alert
knife_willemail <- webprocess(email='fake.email@gmail.com')
knife_willemail
```

    ## An object of class "webprocess":
    ## url: https://cida.usgs.gov/gdp/process/WebProcessingService 
    ## algorithm: Area Grid Statistics (weighted) 
    ## web processing service version: 1.0.0 
    ## process inputs: 
    ##    SUMMARIZE_TIMESTEP: false
    ##    SUMMARIZE_FEATURE_ATTRIBUTE: false
    ##    REQUIRE_FULL_COVERAGE: true
    ##    DELIMITER: COMMA
    ##    STATISTICS: 
    ##    GROUP_BY: 
    ## wait: FALSE 
    ## email: fake.email@gmail.com

The examples used for this section were simple, and we didn't run into any issues. But what if we had? [The next section](/usgs-packages/geoknife_Troubleshoot) discusses how to troubleshoot your `geoknife` calls.
