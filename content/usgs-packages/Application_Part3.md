---
author: Lindsay R. Carr
date: 9999-04-25
slug: app-part3
title: Application - Part 3, plots and maps
draft: FALSE 
image: usgs-packages/static/img/workflow.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 43
---
In this section, you will use data downloaded from the [previous section](/usgs-packages/app-part2) to create time series plots and a map. The goal is to have 3 timeseries plots per site/HUC (precipitation, nitrogen concentration, and phosphorus concentration), and one summary map of cumulative precipition for each HUC.

This will be put together as a single script at the end, but use the code in [Part 5](/usgs-packages/app-part5) to remind yourself what we have done up to this point.

Prepare data for plotting
-------------------------

First re-organize the precipitation into a long format: one column for HUC and one for precip, rather than a separate column of precip for each HUC. See `gather` from the package `tidyr` for ideas on how to do it.

<button class="ToggleButton" onclick="toggle_visibility('reorganize-precip-data')">
Show Answer
</button>
              <div id="reorganize-precip-data" style="display:none">

``` r
library(tidyr)
precip_data_long <- gather(precip_data, huc8, precip, -which(!names(precip_data) %in% huc8s))
```

</div>

Choose one site to use to prototype the plots. After we establish the plotting code, we will automate this for all sites. Separate the data so each data frame contains only one site (see `?filter` from `dplyr` for hints).

<button class="ToggleButton" onclick="toggle_visibility('filter-data')">
Show Answer
</button>
              <div id="filter-data" style="display:none">

``` r
library(dplyr)

nitrogen_site1 <- filter(nitrogen_data, site_no == sites[1])
phosphorus_site1 <- filter(phosphorus_data, site_no == sites[1])

huc_site1 <- filter(sb_sites_info, site_no == sites[1]) %>% pull(huc_cd)
precip_site1 <- filter(precip_data_long, huc8 == huc_site1)
```

</div>
Create time series plots
------------------------

Create time series plots of precipitation, nitrogen, and phosphorus for the site you chose using the separated data frame. See `?layout` to see how to include all three in one graphics device.

<button class="ToggleButton" onclick="toggle_visibility('time-series-plots')">
Show Answer
</button>
              <div id="time-series-plots" style="display:none">

``` r
layout(matrix(1:3, nrow=3))
plot(precip_site1$DateTime, precip_site1$precip,
     col="red", pch=20, xlab = "Time", ylab = "Precip accumulation, in",
     main = paste("Site", sites[1]))
plot(nitrogen_site1$sample_dt, nitrogen_site1$result_va, 
     col="green", pch=20, xlab = "Time", ylab = "Nitrogren concentration, mg/l")
plot(phosphorus_site1$sample_dt, phosphorus_site1$result_va,
     col="blue", pch=20, xlab = "Time", ylab = "Phosphorus concentration, mg/l")
```

<img src='../static/application/time-series-plots-1.png'/ alt='precip, nitrogen, and phosphorus time series plot'/ title='time series plot'/>
</div>
Automate the plots for all sites
--------------------------------

Now that we have established the code required to make all three timeseries plots for one site, automate this so it happens for each site (i.e., make a [for loop](/intro-curriculum/reproduce/#looping)). Save each graphics device as a PNG file: see `?png` and add this code to the loop before the plots are rendered (use `dev.off()` to close each graphics device).

<button class="ToggleButton" onclick="toggle_visibility('automate-time-series-plots')">
Show Answer
</button>
              <div id="automate-time-series-plots" style="display:none">

``` r
site_fnames <- paste0("timeseries_", sites, ".png")

for(i in seq_along(sites)){
  site_i <- sites[i]
  huc_site_i <- filter(sb_sites_info, site_no == site_i) %>% pull(huc_cd) 

  precip_site_i <- filter(precip_data_long, huc8 == huc_site_i)
  nitrogen_site_i <- filter(nitrogen_data, site_no == site_i)
  phosphorus_site_i <- filter(phosphorus_data, site_no == site_i)
  
  png(filename = site_fnames[i], width=8, height=5, units="in", res=100)
  
  layout(matrix(1:3, nrow=3))
  plot(precip_site_i$DateTime, precip_site_i$precip,
       col="red", pch=20, xlab = "Time", ylab = "Precip accumulation, in",
       main = paste("Site", site_i))
  plot(nitrogen_site_i$sample_dt, nitrogen_site_i$result_va, 
       col="green", pch=20, xlab = "Time", ylab = "Nitrogren concentration, mg/l")
  plot(phosphorus_site_i$sample_dt, phosphorus_site_i$result_va,
       col="blue", pch=20, xlab = "Time", ylab = "Phosphorus concentration, mg/l")
  
  dev.off()
}
```

</div>
Map site locations
------------------

Finally, create a map that shows the locations of each USGS site used. Determine the latitude and longitude for each site, then put them on a map of the US. You can use your own mapping method, or use the `map` function from the package `maps` for a simple implementation. Use `png()` to save the map as a PNG file (use before the map code).

<button class="ToggleButton" onclick="toggle_visibility('map-sites')">
Show Answer
</button>
              <div id="map-sites" style="display:none">

``` r
library(maps)

xcoords <- sb_sites_info$dec_long_va
ycoords <- sb_sites_info$dec_lat_va

# for added flair, color the states that contain the sites
states_to_map <- stateCdLookup(as.numeric(unique(sb_sites_info$state_cd)), 
                               outputType = "fullName")

# save map as a png file
map_fname <- "site_map.png"
png(filename = map_fname, width=8, height=5, units="in", res=100)

# create the base map so that map extents are correct
map("usa")

# throw in the colored states
map("state", states_to_map, add = TRUE, fill=TRUE, col="lightblue", border = "lightblue")

# add state outlines
map("state", add=TRUE)

# throw on the site locations as points
points(sb_sites_info$dec_long_va, sb_sites_info$dec_lat_va, col="red", pch=20)

dev.off()
```

    ## png 
    ##   2

</div>
