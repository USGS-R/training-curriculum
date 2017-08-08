---
author: Lindsay R. Carr
date: 9999-03-25
slug: app-part5
title: Application - Part 5, complete workflow
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 45
---
After going through parts 1 through 4, you now have a complete, modular workflow - from data retrieval to processing to visualizing, and finally to publishing and sharing. You could change the ScienceBase item ID to point to different site numbers to use for other another cooperator's data. See the completed workflow below.

Here are all the libraries required:

``` r
library(sbtools)
library(dataRetrieval)
library(geoknife)
library(tidyr)
library(dplyr)
library(maps)
```

Part 1 Solution
---------------

<button class="ToggleButton" onclick="toggle_visibility('complete-workflow-part1')">
Show Answer
</button>
              <div id="complete-workflow-part1" style="display:none">

``` r
# Identify site id and query for files
sb_site_id <- "59848b35e4b0e2f5d46717d1"
avail_files <- item_list_files(sb_site_id)

# Use appropriate reader to get file (tab delimited) into R & get site numbers
sb_sites_df <- read.table(avail_files$url[1], sep="\t", header=TRUE,
                          colClasses = "character", stringsAsFactors = FALSE)
sites <- sb_sites_df$site_number

# Get HUC 8 codes for precip data
sb_sites_info <- readNWISsite(sites)
huc8s <- sb_sites_info$huc_cd
```

</div>
Part 2 Solution
---------------

<button class="ToggleButton" onclick="toggle_visibility('complete-workflow-part2')">
Show Answer
</button>
              <div id="complete-workflow-part2" style="display:none">

``` r
# Define period
startDate <- "2015-10-01"
endDate <- "2016-09-30"

# Download nutrient data
pcodes_nitrogen <- c("00613", "00618", "00631")
pcodes_phosphorus <- c("00665")
nitrogen_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_nitrogen,
                            startDate = startDate, endDate = endDate)
phosphorus_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_phosphorus,
                              startDate = startDate, endDate = endDate)

# Download precip data
precip_stencil <- webgeom(paste0('HUC8::', paste(huc8s, collapse=",")))
precip_knife <- webprocess() # accept defaults for weighted average
all_webdata <- query("webdata")
precip_fabric <- webdata(all_webdata["United States Stage IV Quantitative Precipitation Archive"])
variables(precip_fabric) <- query(precip_fabric, 'variables')
times(precip_fabric) <- c(startDate, endDate)
precip_geojob <- geoknife(precip_stencil, precip_fabric, precip_knife)
wait(precip_geojob, sleep.time = 10) # add `wait` when running scripts
precip_data <- result(precip_geojob)
```

</div>
Part 3 Solution
---------------

<button class="ToggleButton" onclick="toggle_visibility('complete-workflow-part3')">
Show Answer
</button>
              <div id="complete-workflow-part3" style="display:none">

``` r
precip_data_long <- gather(precip_data, huc8, precip, 
                           -which(!names(precip_data) %in% huc8s))

# Create and save time series plots
site_fnames <- paste0("timeseries_", sites, ".png")

for(i in seq_along(sites)){
  site_i <- sites[i]
  huc_site_i <- filter(sb_sites_info, site_no == site_i)$huc_cd # corresponding HUC8

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

# Create and save a map of sites
xcoords <- sb_sites_info$dec_long_va
ycoords <- sb_sites_info$dec_lat_va

states_to_map <- stateCdLookup(as.numeric(unique(sb_sites_info$state_cd)), 
                               outputType = "fullName")

map_fname <- "site_map.png"
png(filename = '', width=8, height=5, units="in", res=100)

map("usa")
map("state", states_to_map, add = TRUE, fill=TRUE, col="lightblue", border = "lightblue")
map("state", add=TRUE)
points(sb_sites_info$dec_long_va, sb_sites_info$dec_lat_va, col="red", pch=20)
dev.off()
```

</div>
Part 4 Solution
---------------

<button class="ToggleButton" onclick="toggle_visibility('complete-workflow-part4')">
Show Answer
</button>
              <div id="complete-workflow-part4" style="display:none">

``` r
# create new SB item
sb_results_item <- item_create(title = "USGS Pkgs Curriculum - application results")
sb_results_id <- sb_results_item$id

# upload and verify
all_fnames <- c(site_fnames, map_fname)
updated_item <- item_append_files(sb_results_id, files = all_fnames)
sb_fnames <- item_list_files(sb_results_id)
all(all_fnames %in% sb_fnames$fname)

# remove local copies
rm_files <- file.remove(all_fnames) 
```

</div>
