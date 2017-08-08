---
author: Lindsay R. Carr
date: 9999-06-15
slug: sbtools-exercises
title: sbtools - Exercises
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 4
---
Before starting the exercises, you should make sure that the `sbtools` package is installed and loaded. If you haven't recently updated, you could reinstall the package by running `install.packages('sbtools')` or go to the "Update" button in the "Packages" tab in RStudio.

``` r
# load the sbtools package
library(sbtools)
```

Exercise 1
----------

Using querying functions, find out how many ScienceBase items were collected during 2010 related to lake temperature. Hint: use `query_sb` to search using more than one criteria, and use a Lucene query string if you want an exact match.

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-1')">
Show Answer
</button>
              <div id="unnamed-chunk-1" style="display:none">

``` r
laketemp <- query_sb(query_list = list(q = '', lq = '"lake temperature"', 
                                       dateRange = '{"start":"2010-01-01","end":"2010-12-31"}',
                                       dateType = 'dateCollected'),
                   limit = 100)
length(laketemp)
```

    ## [1] 15

</div>
Exercise 2
----------

Using [this item](https://www.sciencebase.gov/catalog/item/5979248ee4b0ec1a488a49c6), create a new child item. Then, add a subtitle and explanation about this new child item (e.g. "this is a practice item for using sbtools"). Hint: have you authenticated?

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-2')">
Show Answer
</button>
              <div id="unnamed-chunk-2" style="display:none">

``` r
new_item <- item_create(parent_id = "5979248ee4b0ec1a488a49c6", 
                        title = "My new item")
updated_item <- item_update(new_item, 
                            info = list(subTitle = "Test item for sbtools",
                                        body = "This is my practice item for using sbtools."))
```

</div>
Exercise 3
----------

Using the folder "Example NWIS Data" under [this item](https://www.sciencebase.gov/catalog/item/5979248ee4b0ec1a488a49c6), read each file in as a data frame. Hint: JSON files can be read using `fromJSON` from the `jsonlite` package.

<button class="ToggleButton" onclick="toggle_visibility('unnamed-chunk-3')">
Show Answer
</button>
              <div id="unnamed-chunk-3" style="display:none">

``` r
# You can either use the parent folder to determine the "Example NWIS Data" id;
# or go online and get the item id from the end of the URL.

# Use parent folder to get specific child folder reproducibly
all_children <- item_list_children("5979248ee4b0ec1a488a49c6")
children_titles <- unlist(lapply(all_children, function(item) item$title))
folder_item <- all_children[[grep("Example NWIS Data", children_titles)]]

# Use the "Example NWIS Data" id from the website
folder_item <- item_get("59792b28e4b0ec1a488a49dc")

# download the item file info and the files
nwis_files <- item_list_files(folder_item)
nwis_files
```

    ##                                     fname    size
    ## 1 california_dissolvedoxygen_early80s.csv 1106756
    ## 2           idaho_discharge_june_2003.csv  275424
    ## 3        mississippi_mouth_site_info.json     485
    ##                                                                                                                                       url
    ## 1 https://www.sciencebase.gov/catalog/file/get/59792b28e4b0ec1a488a49dc?f=__disk__9d%2F63%2F42%2F9d6342d1db88d0c9f70b2d508124eb842d4421c6
    ## 2 https://www.sciencebase.gov/catalog/file/get/59792b28e4b0ec1a488a49dc?f=__disk__fb%2F8b%2F48%2Ffb8b48da7774ffbcb9f67b7ab59572e249bb4d24
    ## 3 https://www.sciencebase.gov/catalog/file/get/59792b28e4b0ec1a488a49dc?f=__disk__34%2F62%2F12%2F34621296e1c306cc49dc6920db5b1a677b28ebd2

``` r
ca_dissolvedoxygen <- read.csv(nwis_files$url[1])
id_flow <- read.csv(nwis_files$url[2])
ms_siteinfo <- jsonlite::fromJSON(nwis_files$url[3])
```

</div>
