---
author: Lindsay R. Carr
date: 9999-10-15
slug: dataRetrieval-exercises
title: dataRetrieval - Exercises
draft: true 
image: usgs-packages/static/img/dataRetrieval.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 14
---
Before starting the exercises, you should make sure that the `dataRetrieval` package is installed and loaded. If you haven't recently updated, you could reinstall the package by running `install.packages('dataRetrieval')` or go to the "Update" button in the "Packages" tab in RStudio.

``` r
# load the dataRetrieval package
library(dataRetrieval)

# and dplyr so we can easily clean up the returned data
library(dplyr)
```

Exercise 1
----------

*Determine the number of sites in Arizona that have lake temperature data available in NWIS. Then find how many Arizona sites have lake temperature data available in WQP.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-1')">
Show Answer
</button>
              <div id="unnamed-chunk-1" style="display:none">

``` r
# NWIS Arizona lake temperature sites
azlaketemp_nwis <- whatNWISsites(stateCd="AZ", siteType="LK", parameterCd="00010")
nrow(azlaketemp_nwis)
```

    ## [1] 34

``` r
# WQP Arizona lake temperature sites
azlaketemp_wqp <- whatWQPsites(statecode="AZ", 
                               siteType="Lake, Reservoir, Impoundment", 
                               characteristicName="Temperature, water")
nrow(azlaketemp_wqp)
```

    ## [1] 419

</div>
Exercise 2
----------

*Determine which sites in the District of Columbia had daily streamflow below the historic daily average on August 20th, 2013. Hint: use three different functions to figure this out (find site numbers, then statistics data, and then daily value data).*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-2')">
Show Answer
</button>
              <div id="unnamed-chunk-2" style="display:none">

``` r
# Find DC site numbers that have streamflow
dc_stream_sites <- whatNWISsites(stateCd = "DC", siteType="ST", parameterCd="00060")

# Get streamflow from August 20, 2013
dc_2013_q <- readNWISdv(siteNumbers=dc_stream_sites[['site_no']], parameterCd="00060",
                   startDate="2013-08-20", endDate="2013-08-20")
dc_2013_q <- renameNWISColumns(dc_2013_q)

# Vector of sites that actually have data on August 20, 2013
dc_aug20_sites <- dc_2013_q[['site_no']]

# Pull down statistics information for mean flow at those sites
mean_q <- readNWISstat(siteNumbers=dc_aug20_sites, parameterCd="00060", statType = "mean")

# Pull out just rows with August 20th historic mean flows
aug20_mean_q <- filter(mean_q, month_nu == 8, day_nu == 20)

# Compare 2013 value to historic average for each site
dc_2013_q[['Flow']] < aug20_mean_q[['mean_va']]
```

    ## [1] TRUE TRUE TRUE TRUE

</div>
Exercise 3
----------

*Find which Minnesota lake sites have the maximum phosphorus level in January 1992.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-3')">
Show Answer
</button>
              <div id="unnamed-chunk-3" style="display:none">

``` r
# Get all Jan 1992 phosphorus data from Minnesota lakes
mn_lake_phos <- readWQPdata(statecode="MN", siteType="Lake, Reservoir, Impoundment", 
                            characteristicName="Phosphorus",
                            startDate="1992-01-01", endDate="1992-01-31")

# Determine which row(s) have the maximum phosphorus
max_p_row <- which.max(mn_lake_phos[['ResultMeasureValue']])

# Extract the site numbers that correspond to the maximum phosphorus
mn_lake_phos[['MonitoringLocationIdentifier']][max_p_row]
```

    ## [1] "MNPCA-86-0252-01-213"

</div>
Exercise 4
----------

*Map the Minnesota lake phosphorus sites using your data from Exercise 3. Hint: look at metadata and consider using the `maps` package.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-4')">
Show Answer
</button>
              <div id="unnamed-chunk-4" style="display:none">

``` r
# Get longitudes and latitudes of the lake phosphorus data from Jan 1992
mn_site_info <- attr(mn_lake_phos, 'siteInfo')
mn_site_coords <- select(mn_site_info, dec_lon_va, dec_lat_va)
head(mn_site_coords)
```

    ##   dec_lon_va dec_lat_va
    ## 1  -94.10779   46.58749
    ## 2  -94.11946   46.58617
    ## 3  -94.12461   46.55317
    ## 4  -94.14380   46.53020
    ## 5  -94.15986   46.51587
    ## 6  -94.17500   46.57880

``` r
# Put the sites on a simple state map
library(maps)
map('state', 'Minnesota', col="lightblue", lwd=2)
points(mn_site_coords)
```

<img src='../static/dataRetrieval-exercises/unnamed-chunk-4-1.png'/ title='Minnesota lake phosphorus site map'/ alt='Map Minnesota showing locations of maximum lake phosphorus'/>
</div>
