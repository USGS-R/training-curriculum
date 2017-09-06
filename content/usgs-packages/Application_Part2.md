---
author: Lindsay R. Carr
date: 9999-05-01
slug: app-part2
title: Application - Part 2, download data
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 42
---
In this section, we are going to use `dataRetrieval` and `geoknife` to get nitrogen, phosphorus, and precipitation data for the sites determined in the [previous section](/usgs-packages/app-part1).

We are walking through the workflow in very distinct chunks, but this will be put together as a single script at the end. The code that we used to get the site and 8-digit HUC numbers is available in [Part 5](/usgs-packages/app-part5).

Before downloading the data, make sure you identify the time period of interest. For this example, we are going to use water year 2016.

``` r
startDate <- "2015-10-01"
endDate <- "2016-09-30"
```

Get nutrient data
-----------------

Now, use `dataRetrieval` functions to pull down data for nitrogen and phosphorus. You can choose your own parameter codes to define these nutrients using `parameterCdFile` or use the ones below.

``` r
pcodes_nitrogen <- c("00613", "00618", "00631")
pcodes_phosphorus <- c("00665")
```

Using your choice of `readNWIS` function, get a data frame with nitrogen data for all sites and a second data frame with phosphorus data for all sites. Revisit the [lesson on downloading NWIS data](/usgs-packages/dataRetrieval-readNWIS/) to see what functions are available.

<button class="ToggleButton" onclick="toggle_visibility('nutrient-data')">
Show Answer
</button>
              <div id="nutrient-data" style="display:none">

``` r
nitrogen_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_nitrogen,
                            startDate = startDate, endDate = endDate)
head(nitrogen_data[,c('site_no', 'sample_dt', 'result_va')])
```

    ##    site_no  sample_dt result_va
    ## 1 04208000 2015-10-01     0.022
    ## 2 04208000 2015-10-01     2.680
    ## 3 04208000 2015-10-01     2.700
    ## 4 04208000 2015-11-05     0.014
    ## 5 04208000 2015-11-05     4.000
    ## 6 04208000 2015-11-05     4.020

``` r
phosphorus_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_phosphorus,
                              startDate = startDate, endDate = endDate)
head(phosphorus_data[,c('site_no', 'sample_dt', 'result_va')])
```

    ##    site_no  sample_dt result_va
    ## 1 04208000 2015-10-01     0.090
    ## 2 04208000 2015-11-05     0.111
    ## 3 04208000 2015-12-02     0.101
    ## 4 04208000 2016-01-06     0.111
    ## 5 04208000 2016-02-01     0.158
    ## 6 04208000 2016-03-03     0.108

</div>
Get precip data
---------------

Now we need to download the precipitation data from GDP using `geoknife`. To do so, you will need a dataset and appropriate HUCs. Use the dataset titled "United States Stage IV Quantitative Precipitation Archive". See `?webgeom` for an example of how to format the geom for 8-digit HUCs.

Complete the steps to create and execute a geojob. Download the results of the process as a `data.frame`; this might take a few minutes (~ 10). See [geoknife discovery](/usgs-packages/geoknife-data) and [geoknife execute](/usgs-packages/geoknife-job) lessons for assistance.

<button class="ToggleButton" onclick="toggle_visibility('precip-data')">
Show Answer
</button>
              <div id="precip-data" style="display:none">

``` r
library(geoknife)

# Create appropriate webgeom string for 8-digit hucs
huc8_geoknife_str <- paste0('HUC8::', paste(huc8s, collapse=","))
huc8_geoknife_str
```

    ## [1] "HUC8::04030108,04030101,04110002"

``` r
# Create the stencil and process
precip_stencil <- webgeom(huc8_geoknife_str)
precip_knife <- webprocess() # accept defaults for weighted average

# First find and initiate the fabric
all_webdata <- query("webdata")
precip_fabric <- webdata(all_webdata["United States Stage IV Quantitative Precipitation Archive"])

# Now find/add variables (there is only one)
precip_vars <- query(precip_fabric, 'variables')
variables(precip_fabric) <- precip_vars

# Add times to complete fabric
times(precip_fabric) <- c(startDate, endDate)

# Create geojob + get results
precip_geojob <- geoknife(precip_stencil, precip_fabric, precip_knife)
wait(precip_geojob, sleep.time = 10) # add `wait` when running scripts
precip_data <- result(precip_geojob)
head(precip_data)
```

    ##              DateTime 04030101 04030108 04110002
    ## 1 2015-10-01 00:00:00        0        0        0
    ## 2 2015-10-01 01:00:00        0        0        0
    ## 3 2015-10-01 02:00:00        0        0        0
    ## 4 2015-10-01 03:00:00        0        0        0
    ## 5 2015-10-01 04:00:00        0        0        0
    ## 6 2015-10-01 05:00:00        0        0        0
    ##                                          variable statistic
    ## 1 Total_precipitation_surface_1_Hour_Accumulation      MEAN
    ## 2 Total_precipitation_surface_1_Hour_Accumulation      MEAN
    ## 3 Total_precipitation_surface_1_Hour_Accumulation      MEAN
    ## 4 Total_precipitation_surface_1_Hour_Accumulation      MEAN
    ## 5 Total_precipitation_surface_1_Hour_Accumulation      MEAN
    ## 6 Total_precipitation_surface_1_Hour_Accumulation      MEAN

</div>
