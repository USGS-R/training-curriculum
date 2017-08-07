---
author: Lindsay R. Carr
date: 9999-04-25
slug: app-part3
title: Application - Part 3, plots and maps
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
In this section, you will use data downloaded from the [previous section](/usgs-packages/app-part2) to create time series plots and a map. The goal is to have 3 timeseries plots per site/HUC (precipitation, nitrogen concentration, and phosphorus concentration), and one summary map of cumulative precipition for each HUC.

This will be put together as a single script at the end, but use the code below to remind yourself what we have done up to this point.

Getting sites and data:

<button class="ToggleButton" onclick="toggle_visibility('get-sites-data')">
Show Answer
</button>
              <div id="get-sites-data" style="display:none">

``` r
library(sbtools)
library(dataRetrieval)
library(geoknife)

# identify site id and query for files
sb_site_id <- "59848b35e4b0e2f5d46717d1"
avail_files <- item_list_files(sb_site_id)

# use appropriate reader to get file (tab delimited) into R & get site numbers
sb_sites_df <- read.table(avail_files$url[1], sep="\t", header=TRUE,
                          colClasses = "character", stringsAsFactors = FALSE)
sites <- sb_sites_df$site_number

# get HUC 8 codes for precip data
sb_sites_info <- readNWISsite(sites)
huc8s <- sb_sites_info$huc_cd

# define period
startDate <- "2015-10-01"
endDate <- "2016-09-30"

# download nutrient data
pcodes_nitrogen <- c("00613", "00618", "00631")
pcodes_phosphorus <- c("00665")
nitrogen_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_nitrogen,
                            startDate = startDate, endDate = endDate)
phosphorus_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_phosphorus,
                              startDate = startDate, endDate = endDate)

# download precip data
precip_stencil <- webgeom(paste0('HUC8::', paste(huc8s, collapse=",")))
precip_knife <- webprocess() # accept defaults for weighted average
all_webdata <- query("webdata")
precip_fabric <- webdata(all_webdata["United States Stage IV Quantitative Precipitation Archive"])
variables(precip_fabric) <- query(precip_fabric, 'variables')
times(precip_fabric) <- c(startDate, endDate)
```

</div>
Executing the geojob:

<button class="ToggleButton" onclick="toggle_visibility('execute-job-off')">
Show Answer
</button>
              <div id="execute-job-off" style="display:none">

``` r
precip_geojob <- geoknife(precip_stencil, precip_fabric, precip_knife)
wait(precip_geojob, sleep.time = 10) # add `wait` when running scripts
precip_data <- result(precip_geojob)
```

</div>
Prepare data for plotting
-------------------------

First re-organize the precipitation into a long format (one column for value, one for HUC) rather than a separate column of precip for each HUC. See `gather` from the package `tidyr` for ideas on how to do it.

<button class="ToggleButton" onclick="toggle_visibility('reorganize-precip-data')">
Show Answer
</button>
              <div id="reorganize-precip-data" style="display:none">

``` r
library(tidyr)
precip_data_long <- gather(precip_data, huc8, precip, -which(!names(precip_data) %in% huc8s))
```

</div>
Now choose one site to create the plots. Seperate the data so each data frame contains only one site (see `?filter` from `dplyr` for hints). After we establish the plotting code, we will automate this for all sites.

<button class="ToggleButton" onclick="toggle_visibility('filter-data')">
Show Answer
</button>
              <div id="filter-data" style="display:none">

``` r
library(dplyr)

nitrogen_site1 <- filter(nitrogen_data, site_no == sites[1])
phosphorus_site1 <- filter(phosphorus_data, site_no == sites[1])

huc_site1 <- filter(sb_sites_info, site_no == sites[1])$huc_cd # corresponding HUC8
precip_site1 <- filter(precip_data_long, huc8 == huc_site1)
```

</div>
Create time series plots
------------------------

Create a separate time series plot of precipitation, nitrogen, and phosphorus for each site using the separated data frames. See `?layout` to see how to include all three in one graphics device.

<button class="ToggleButton" onclick="toggle_visibility('time-series-plots')">
Show Answer
</button>
              <div id="time-series-plots" style="display:none">

``` r
layout(matrix(1:3, nrow=3))
plot(precip_site1$DateTime, precip_site1$precip,
     col="red", pch=20, xlab = "Time", ylab = "Precip accumulation, in")
plot(nitrogen_site1$sample_dt, nitrogen_site1$result_va, 
     col="green", pch=20, xlab = "Time", ylab = "Nitrogren concentration, mg/l")
plot(phosphorus_site1$sample_dt, phosphorus_site1$result_va,
     col="blue", pch=20, xlab = "Time", ylab = "Phosphorus concentration, mg/l")
```

<img src='../static/app-part3/time-series-plots-1.png'/ title='TODO'/>
</div>
Automate the plots for all sites
--------------------------------

Now that we have established the code required to make all three timeseries plots for each site, automate this so it happens for each site (a.k.a. make a [for loop](/intro-curriculum/reproduce/#looping)).

<button class="ToggleButton" onclick="toggle_visibility('automate-time-series-plots')">
Show Answer
</button>
              <div id="automate-time-series-plots" style="display:none">

``` r
for(i in sites){
  huc_site_i <- filter(sb_sites_info, site_no == i)$huc_cd # corresponding HUC8

  precip_site_i <- filter(precip_data_long, huc8 == huc_site1)
  nitrogen_site_i <- filter(nitrogen_data, site_no == i)
  phosphorus_site_i <- filter(phosphorus_data, site_no == i)
  
  layout(matrix(1:3, nrow=3))
  plot(precip_site_i$DateTime, precip_site_i$precip,
       col="red", pch=20, xlab = "Time", ylab = "Precip accumulation, in",
       main = paste("Site", i))
  plot(nitrogen_site_i$sample_dt, nitrogen_site_i$result_va, 
       col="green", pch=20, xlab = "Time", ylab = "Nitrogren concentration, mg/l")
  plot(phosphorus_site_i$sample_dt, phosphorus_site_i$result_va,
       col="blue", pch=20, xlab = "Time", ylab = "Phosphorus concentration, mg/l")
}
```

<img src='../static/app-part3/automate-time-series-plots-1.png'/ title='TODO'/><img src='../static/app-part3/automate-time-series-plots-2.png'/ title='TODO'/><img src='../static/app-part3/automate-time-series-plots-3.png'/ title='TODO'/>
</div>
Map cumulative precip
---------------------

Finally, create a map that summarizes all HUC yearly cumulative precipitation at once. This will take some data massaging first: determine the cumulative annual (by water year) precipitation for each HUC.

<button class="ToggleButton" onclick="toggle_visibility('cumulative-precip')">
Show Answer
</button>
              <div id="cumulative-precip" style="display:none">

``` r
precip_annual <- precip_data_long %>%
  rename(dateTime = DateTime) %>% # need to rename to use with addWaterYear
  addWaterYear() %>% 
  group_by(waterYear, huc8) %>% 
  summarize(cumulative_precip = sum(precip))
```

</div>
Now, map the HUCs and color based on precipication.

HMMMMMMMMMM I HAVEN'T DECIDED THE CLEANEST WAY TO DO THIS YET.
