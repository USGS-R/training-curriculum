---
author: Lindsay R. Carr
date: 9999-04-01
slug: app-part4
title: Application - Part 4, publish results
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
In this section, we will complete the workflow and push the finished plots to ScienceBase from within the script. See the [previous section](/usgs-packages/app-part3) to see how we created the plots (or expand the code below).

Getting sites and data:

<button class="ToggleButton" onclick="toggle_visibility('sites-data-plot')">
Show Answer
</button>
              <div id="sites-data-plot" style="display:none">

``` r
library(sbtools)
library(dataRetrieval)
library(geoknife)
library(tidyr)
library(dplyr)

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
Executing geojob:

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
Creating plots:

<button class="ToggleButton" onclick="toggle_visibility('sites-data-plot-continued')">
Show Answer
</button>
              <div id="sites-data-plot-continued" style="display:none">

``` r
precip_data_long <- gather(precip_data, huc8, precip, 
                           -which(!names(precip_data) %in% huc8s))

for(i in sites){
  huc_site_i <- filter(sb_sites_info, site_no == i)$huc_cd # corresponding HUC8

  precip_site_i <- filter(precip_data_long, huc8 == huc_site_i)
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

<img src='../static/app-part4/sites-data-plot-continued-1.png'/ title='TODO'/><img src='../static/app-part4/sites-data-plot-continued-2.png'/ title='TODO'/><img src='../static/app-part4/sites-data-plot-continued-3.png'/ title='TODO'/>
</div>
Create location to publish on SB
--------------------------------

The challenge with this application was to provide summaries of precipitation, nitrogen, and phosphorus data for a specific set of sites provided by a cooperator. The challenge was to automate the entire workflow, so the final step is to publish our results to ScienceBase. It would make most since to push the results to the same ScienceBase item that the cooperator provided for sites, but since this is an exercise and others will be completing it, we will save the results to a personal SB item.

Therefore, the first step is to create a folder under your user to save the results. Title this new item "usgs-pkgs-application-results". Visit the [sbtools modify lesson](/usgs-packages/sbtools-modify) to remind yourself how to do this. Try it on your own before expanding the solution code!

<button class="ToggleButton" onclick="toggle_visibility('create-new-item')">
Show Answer
</button>
              <div id="create-new-item" style="display:none">

``` r
# automatically created under the authenticated user
sb_results_item <- item_create(title = "usgs-pkgs-application-results")

# you would only create the item once, then you could just use its id moving forward
sb_results_id <- sb_results_item$id
```

</div>
Publish plots as images
-----------------------

Next save the graphics as PNG files and upload to ScienceBase (add this code to the loop where the plots are rendered).

<button class="ToggleButton" onclick="toggle_visibility('automate-plots-publish')">
Show Answer
</button>
              <div id="automate-plots-publish" style="display:none">

``` r
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

updated_item <- item_append_files(sb_results_id, files = site_fnames)
rm_files <- file.remove(site_fnames) # now that it's online, remove local copy
```

</div>
Check to see if the files were successfully uploaded to SB:

``` r
sb_fnames <- item_list_files(sb_results_id)
all(site_fnames %in% sb_fnames$fname)
```

    ## [1] TRUE

Completed modular workflow
--------------------------

You should now have a complete, modular workflow - from data retrieval to processing to visualizing, and finally to publishing and sharing. You could change the ScienceBase item ID to point to different site numbers to use for other cooperator's data. See the completed workflow below.

<button class="ToggleButton" onclick="toggle_visibility('complete-workflow')">
Show Answer
</button>
              <div id="complete-workflow" style="display:none">

``` r
library(sbtools)
library(dataRetrieval)
library(geoknife)
library(tidyr)
library(dplyr)

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
precip_geojob <- geoknife(precip_stencil, precip_fabric, precip_knife)
wait(precip_geojob, sleep.time = 10) # add `wait` when running scripts
precip_data <- result(precip_geojob)

precip_data_long <- gather(precip_data, huc8, precip, 
                           -which(!names(precip_data) %in% huc8s))

# Create and save plots
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

updated_item <- item_append_files(sb_results_id, files = site_fnames)
rm_files <- file.remove(site_fnames) # now that it's online, remove local copy
```

</div>
