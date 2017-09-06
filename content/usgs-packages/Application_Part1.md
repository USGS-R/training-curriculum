---
author: Lindsay R. Carr
date: 9999-05-25
slug: app-part1
title: Application - Part 1, find sites
draft: true 
image: usgs-packages/static/img/workflow.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 41
---
As stated in the Challenge description, site information has been provided via ScienceBase. For the purposes of this exercise, let's assume your cooperator gave you the [link to the ScienceBase item](https://www.sciencebase.gov/catalog/item/59848b35e4b0e2f5d46717d1) that contained the site information. Using functions taught earlier in `sbtools` lessons, create a vector of the ScienceBase site numbers. In addition, use functions in `dataRetrieval` to gather relevant location data about each site (e.g. HUC ids).

Get sites
---------

First, authenticate your ScienceBase session using `authenticate_sb()`. Now, use `sbtools` functions to read the appropriate file from the [SB item created by your cooperator](https://www.sciencebase.gov/catalog/item/59848b35e4b0e2f5d46717d1) into R as a data frame. Try it on your own before looking at the answer below. Don't hesitate to go back to the [sbtools download data lesson](/usgs-packages/sbtools-get) for a refresher. Hint: the item id is the last element of the URL.

<button class="ToggleButton" onclick="toggle_visibility('get-sb-sites')">
Show Answer
</button>
              <div id="get-sb-sites" style="display:none">

``` r
library(sbtools)

# identify site id and query for files
sb_site_id <- "59848b35e4b0e2f5d46717d1"
avail_files <- item_list_files(sb_site_id)

# look at what files are available and choose which you want
avail_files
```

    ##            fname size
    ## 1 usgs_sites.tsv  176
    ##                                                                                                                                       url
    ## 1 https://www.sciencebase.gov/catalog/file/get/59848b35e4b0e2f5d46717d1?f=__disk__cd%2Fb2%2F60%2Fcdb260a105e1eccca222642f18b891e35e62eada

``` r
# use appropriate reader to get file into R
sb_sites_df <- read.table(avail_files$url[1], sep="\t", header=TRUE,
                          colClasses = "character", stringsAsFactors = FALSE)
head(sb_sites_df)
```

    ##   site_number                         station_name
    ## 1    04067500 MENOMINEE RIVER NEAR MC ALLISTER, WI
    ## 2    04085427     MANITOWOC RIVER AT MANITOWOC, WI
    ## 3    04208000    Cuyahoga River at Independence OH

</div>
Create a vector of just site numbers to use for subsequent functions.

<button class="ToggleButton" onclick="toggle_visibility('create-site-vec')">
Show Answer
</button>
              <div id="create-site-vec" style="display:none">

``` r
sites <- sb_sites_df$site_number
sites
```

    ## [1] "04067500" "04085427" "04208000"

</div>
Get relevant site metadata
--------------------------

In anticipation of downloading precipitation data through the Geo Data Portal, we need to determine which regions to use since it does not operate based on NWIS sites. GDP can use 8-digit hydrologic unit codes (HUCs), which can be determined for each site number using `readNWISsite`. Use `readNWISsite` to get a vector of 8-digit HUCs. Try it on your own before looking at the answer below.

<button class="ToggleButton" onclick="toggle_visibility('get_hucs')">
Show Answer
</button>
              <div id="get_hucs" style="display:none">

``` r
library(dataRetrieval)
sb_sites_info <- readNWISsite(sites)

# look at column names to find where the HUC codes live
names(sb_sites_info)
```

    ##  [1] "agency_cd"             "site_no"              
    ##  [3] "station_nm"            "site_tp_cd"           
    ##  [5] "lat_va"                "long_va"              
    ##  [7] "dec_lat_va"            "dec_long_va"          
    ##  [9] "coord_meth_cd"         "coord_acy_cd"         
    ## [11] "coord_datum_cd"        "dec_coord_datum_cd"   
    ## [13] "district_cd"           "state_cd"             
    ## [15] "county_cd"             "country_cd"           
    ## [17] "land_net_ds"           "map_nm"               
    ## [19] "map_scale_fc"          "alt_va"               
    ## [21] "alt_meth_cd"           "alt_acy_va"           
    ## [23] "alt_datum_cd"          "huc_cd"               
    ## [25] "basin_cd"              "topo_cd"              
    ## [27] "instruments_cd"        "construction_dt"      
    ## [29] "inventory_dt"          "drain_area_va"        
    ## [31] "contrib_drain_area_va" "tz_cd"                
    ## [33] "local_time_fg"         "reliability_cd"       
    ## [35] "gw_file_cd"            "nat_aqfr_cd"          
    ## [37] "aqfr_cd"               "aqfr_type_cd"         
    ## [39] "well_depth_va"         "hole_depth_va"        
    ## [41] "depth_src_cd"          "project_no"

``` r
huc8s <- sb_sites_info$huc_cd
huc8s
```

    ## [1] "04030108" "04030101" "04110002"

</div>
