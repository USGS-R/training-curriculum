---
author: Lindsay R. Carr
date: 9999-08-30
slug: geoknife-exercises
title: geoknife - exercises
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 3
---
Before starting the exercises, you should make sure that the `geoknife` package is installed and loaded. If you haven't recently updated, you could reinstall the package by running `install.packages('geoknife')` or go to the "Update" button in the "Packages" tab in RStudio.

``` r
# load the geoknife package
library(geoknife)
```

Exercise 1
----------

*How many GDP data sets are related to sea level rise? Hint: `grep`.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-1')">
Show Answer
</button>
              <div id="unnamed-chunk-1" style="display:none">

``` r
# First, you need to query for all web data
all_webdata <- query("webdata")
all_titles <- title(all_webdata)
all_abstracts <- abstract(all_webdata)

# Then start sleuthing using `grep`
keyword_str <- "sea level rise|sea level|sea level|sea rise"
index_t <- grep(keyword_str, all_titles, ignore.case = TRUE)
index_a <- grep(keyword_str, all_abstracts, ignore.case = TRUE)
index_both <- unique(c(index_t, index_a))

# Look at the titles and abstracts of datasets that match your criteria
length(index_both)
```

    ## [1] 2

``` r
all_titles[index_both]
```

    ## [1] "Sea Level Rise Projections for DSL-SAMBI"
    ## [2] "Thermosteric Sea Level Rise"

``` r
all_abstracts[index_both]
```

    ## [1] "This dataset is output from the Sea Level Affecting Marshes Model (SLAMM) for the South Atlantic Migratory Bird Initiative (SAMBI) geographic planning region. It represents 10 year increments (ranging from year 2000 - year 2100) for the climate change scenario A1B, A1FI, A2, or B1. The dataset was developed as one component for modeling landscape scale alterations of avian habitats due to climate change. It may also be used as a stand-alone product to illustrate potential changes in marsh and coastal environments due to longterm sea level rise. Model outputs from SLAMM are subject to constraints of the modeling process itself. The Biodiversity and Spatial Information Center (BaSIC) did not create the SLAMM modeling approach and/or algorithims. However, all effort was made to ensure data inputs required by the model are of the highest quality. Certain input parameters may need to be altered to create a more reliable model projection. BaSIC is currently (January 2010) working with cooperators to address such issues. Clough, J. S. 2008. SLAMM 5.0.1. Technical documentation and executable program downloadable from http://www.warrenpinnacle.com/prof/SLAMM/index.html"
    ## [2] ""

</div>
Exercise 2
----------

*What variables are in the "University of Idaho Daily Meteorological data for continental US" dataset? Also, choose one variable and determine the range of dates. Hint: create a geoknife fabric first.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-2')">
Show Answer
</button>
              <div id="unnamed-chunk-2" style="display:none">

``` r
# First, you need to query for all web data
all_webdata <- query("webdata")

# Use the all_webdata object to create the fabric
us_meterology <- webdata(all_webdata["University of Idaho Daily Meteorological data for continental US"])

# Now use query to see what variables are available
metero_vars <- query(us_meterology, "variables")
metero_vars
```

    ## [1] "precipitation_amount"                     
    ## [2] "max_relative_humidity"                    
    ## [3] "min_relative_humidity"                    
    ## [4] "specific_humidity"                        
    ## [5] "surface_downwelling_shortwave_flux_in_air"
    ## [6] "min_air_temperature"                      
    ## [7] "max_air_temperature"                      
    ## [8] "wind_speed"

``` r
# Let's pick the fourth variable to look at a date range
# To determine the times available, you must add the variable to the fabric
variables(us_meterology) <- metero_vars[4]
query(us_meterology, "times")
```

    ## [1] "1979-01-01 UTC" "2017-06-20 UTC"

</div>
Exercise 3
----------

*What was the average maximum air temperature in Texas on July 4, 2007? Use the dataset titled "TopoWx: Topoclimatic Daily Air Temperature Dataset for the Conterminous United States", which has a maximum temperature variable, tmax. Hint: you will need all three pieces - stencil, fabric, and knife.*

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-3')">
Show Answer
</button>
              <div id="unnamed-chunk-3" style="display:none">

``` r
# First, you need to query for all web data
all_webdata <- query("webdata")

# Setup the maximum air temp fabric using the URL in all_webdata
airtemp_title <- "TopoWx: Topoclimatic Daily Air Temperature Dataset for the Conterminous United States"
airtemp_url <-  url(all_webdata[airtemp_title])
airtemp_fabric <- webdata(list(
  url = airtemp_url,
  variables = "tmax",
  times = as.POSIXct(c("2007-07-04", "2007-07-04"), tz = "UTC")
))

# Now setup the stencil
texas <- webgeom(geom = "sample:CONUS_states", 
                 attribute = "STATE",
                 values = "Texas")

# Leave the default knife since we want an average over the stencil
# Execute the geoknife job
airtemp_job <- geoknife(stencil = texas, fabric = airtemp_fabric, wait=TRUE)

# Download the data
air_max_data <- result(airtemp_job)
air_max_data
```

    ##              DateTime    Texas variable statistic
    ## 1 2007-07-03 12:00:00 31.13529     tmax      MEAN

</div>
