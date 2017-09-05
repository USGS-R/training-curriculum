---
author: Lindsay R. Carr
date: 9999-07-01
slug: sbtools-get
title: sbtools - Download Data
draft: true 
image: usgs-packages/static/img/sbtools.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 33
---
This lesson will describe the basic functions to manage ScienceBase authenticated sessions and view or download ScienceBase items. If you aren't sure what a ScienceBase item is, head back to the [previous lesson on `sbitems`](/usgs-packages/sbtools-sbitem).

Don't forget to load the library if you're in a new R session!

``` r
library(sbtools)
```

Authentication
--------------

This section is specific to authentication with ScienceBase. If you don't have a ScienceBase account, skip to the next section. Just know that you will only be able to download public data.

The first step to authenticating (or logging in) to ScienceBase is to use the function `authenticate_sb`. The arguments are your username and password. Alternatively, you can use the function interactively by not supplying any arguments. It will prompt you for your username in the R console and then your password in a pop-up window. Be very cautious when using the username and password arguments - don't include these in any scripts! To be safe, you can leave out the arguments and use the interactive login. Try interactively logging in:

``` r
authenticate_sb()
```

To double check that your authentication was successful, use the function `is_logged_in`. It will return a logical to let you know if you are logged in or not. No arguments are needed.

``` r
is_logged_in()
```

    ## [1] TRUE

Each user has a specific ScienceBase item associated with their account. You can inspect the items and files attached to your home item and even add new items and files (both discussed in the [next section](/usgs-packages/sbtools-modify)) . To determine the ScienceBase ID of your home item, use the function `user_id` in an authenticated session. No arguments are necessary.

``` r
user_id()
```

    ## [1] "56215f74e4b06217fc478c3a"

When you're done with your session, you can actively logout using the `session_logout` function. No arguments are required. If you do not do this, you will be automatically logged out after a certain amount of time or when you close R.

Inspect and download items
--------------------------

The first inspection step for ScienceBase items is to determine if the item even exists. To do this, use the function `identifier_exists`. The only required argument is `sb_id` which can be either a character string of the item id or an `sbitem`. It will return a logical to indicate whether the item exists or not.

``` r
identifier_exists("4f4e4acae4b07f02db67d22b")
```

    ## [1] TRUE

``` r
identifier_exists("thisisnotagoodid")
```

    ## [1] FALSE

You can use the function `item_exists` to check whether or not alternative identifiers (a scheme-type-key tuple) exist (visit the [sbitem lesson](/usgs-packages/sbtools-sbitem) if you don't know about alternative identifiers). The function has three required arguments - `scheme`, `type`, and `key`. Note that the table of alternative identifiers on ScienceBase is in a different order than this function accepts: `type, scheme, key` on ScienceBase but `scheme, type, key` for `item_exists`.

``` r
# test a made up tuple
item_exists(scheme = "made", type = "this", key = "up")
```

    ## [1] FALSE

``` r
# test a tuple from the SB item "4f4e4acae4b07f02db67d22b"
item_exists(scheme = "State Inventory", type = "UniqueKey", key = "P1281")
```

    ## [1] TRUE

``` r
# test the same scheme & type with a made up key
item_exists(scheme = "State Inventory", type = "UniqueKey", key = "1234")
```

    ## [1] FALSE

Let's inspect various ScienceBase items. There are functions to look at the parent item, metadata fields, sub-items, and associated files. Each of these functions require the id of the sbitem as the first argument. For all of these examples, we are going to use the same sbitem id, "4f4e4b24e4b07f02db6aea14".

First, let's inspect the parent item. The function to use is `item_get_parent`, and the item id is the only necessary argument.

``` r
ex_id <- "4f4e479de4b07f02db491e34"
ex_id_parent <- item_get_parent(ex_id)
ex_id_parent$title
```

    ## [1] "Arizona Geological Survey"

Now, let's see if this item has any children by using the `item_list_children` function.

``` r
ex_id_children <- item_list_children(ex_id)
length(ex_id_children)
```

    ## [1] 20

``` r
sapply(ex_id_children, function(item) item$title)
```

    ##  [1] "Cuttings for UNITED STATES BUREAU OF INDIAN AFFAIRS - MANY FARMS #1 BOYD AND MORRISON"
    ##  [2] "Cuttings for SUNSET CRATER TEST HOLE"                                                 
    ##  [3] "Cuttings for MCGUIRE"                                                                 
    ##  [4] "Cuttings for BUILDING & DESIGN INCORPORATED"                                          
    ##  [5] "Cuttings for UNITED STATES BUREAU OF RECLAMATION - TA-9"                              
    ##  [6] "Cuttings for 3T-333"                                                                  
    ##  [7] "Cuttings for ARIZONA GAME & FISH - EAGER #1"                                          
    ##  [8] "Cuttings for RR-5"                                                                    
    ##  [9] "Cuttings for 1K-217 - KABITO DAY SCHOOL"                                              
    ## [10] "Cuttings for FORNES"                                                                  
    ## [11] "Cuttings for FICO S-53"                                                               
    ## [12] "Cuttings for WILSON TRAILER COMPANY #3"                                               
    ## [13] "Cuttings for 14T-320"                                                                 
    ## [14] "Cuttings for FICO S-22"                                                               
    ## [15] "Cuttings for 16T-507"                                                                 
    ## [16] "Cuttings for WRIGHT"                                                                  
    ## [17] "Cuttings for HACKBERRY #4"                                                            
    ## [18] "Cuttings for SOUTHERN PACIFIC RAILROAD - DRAGOON WELL"                                
    ## [19] "Cuttings for SHAG'S"                                                                  
    ## [20] "Cuttings for DOBELL #1"

Let's check to see if this item has any files attached to it using `item_list_files`. This will return a dataframe with the three columns: `fname` (filename), `size` (file size in bytes), and `url` (the URL to the file on ScienceBase).

``` r
ex_id_files <- item_list_files(ex_id)
nrow(ex_id_files)
```

    ## [1] 2

``` r
ex_id_files$fname
```

    ## [1] "metadata.xml"                                  
    ## [2] "10:02:09_100949_nggdpp_azgs_borehole_P1435.xml"

To actually get the files into R as data, you need to use their URLs and the appropriate parsing function. Both of the files returned for this item are XML, so you can use the `xml2` function, `read_xml`. As practice, we will download the first XML file.

``` r
xml2::read_xml(ex_id_files$url[1])
```

    ## {xml_document}
    ## <NGGDPP>
    ## [1] <NGGDPPCollection originalSurveyId="325461" originalUniqueKey="P1435 ...
    ## [2] <NGGDPPSurvey>\n  <COMPLETER_FIRST_NAME>Stephen</COMPLETER_FIRST_NAM ...

You can also inspect specific metadata fields of ScienceBase items. To do this, use the `item_get_fields` function. If you wish to see all fields associated with an item you could use `item_get` (discussed below) which will return the entire item. `item_get_fields` requires a second argument to the item id called `fields` that is a character vector of the fields you want to retrieve. See the [developer documentation for a SB item model](https://my.usgs.gov/confluence/display/sciencebase/ScienceBase+Item+Core+Model) for a list of potential fields. You can also use the argument `drop` to indicate that if only one field is requested, the object returned remains a list (`drop=FALSE`) or becomes a vector (`drop=TRUE`). The default is `drop=TRUE`.

``` r
# request multiple fields
multi_fields <- item_get_fields(ex_id, c("summary", "tags"))
length(multi_fields)
```

    ## [1] 2

``` r
names(multi_fields)
```

    ## [1] "summary" "tags"

``` r
# single field, drop=TRUE
single_field_drop <- item_get_fields(ex_id, "summary")
names(single_field_drop)
```

    ## NULL

``` r
class(single_field_drop)
```

    ## [1] "character"

``` r
# single field, drop=FALSE
single_field <- item_get_fields(ex_id, "summary", drop=FALSE)
single_field
```

    ## $summary
    ## [1] "This collection consists of rock chips in vials and plastic bags. The material is stored in vials and was collected mostly from water wells, and has been washed. Material stored in plastic bags, mostly from oil and gas wells, is not washed and is stored in boxes. The collection includes cuttings from 5078 water wells, and 635 oil and gas wells."

``` r
class(single_field)
```

    ## [1] "list"

If a field is empty, it will return `NULL`.

``` r
# request nonexistent fields
item_get_fields(ex_id, c("dates", "citation"))
```

    ## $<NA>
    ## NULL
    ## 
    ## $<NA>
    ## NULL

Now that we've inspected the item, let's actually pull the item down. There are a number of extra fields to inspect now.

``` r
ex_id_item <- item_get(ex_id)
names(ex_id_item)
```

    ##  [1] "link"                        "relatedItems"               
    ##  [3] "id"                          "identifiers"                
    ##  [5] "title"                       "summary"                    
    ##  [7] "body"                        "provenance"                 
    ##  [9] "materialRequestInstructions" "hasChildren"                
    ## [11] "parentId"                    "contacts"                   
    ## [13] "webLinks"                    "browseCategories"           
    ## [15] "browseTypes"                 "systemTypes"                
    ## [17] "tags"                        "spatial"                    
    ## [19] "extents"                     "facets"                     
    ## [21] "files"                       "distributionLinks"

Web feature services to visualize spatial data
----------------------------------------------

This function allows you to pull down web feature services (WFS) data from ScienceBase. Note that this is not the most robust function. The developers thought this could be a cool feature, but didn't want to invest too much time if there wouldn't be demand. If you'd use it a lot, visit the [`sbtools` GitHub page](https://github.com/USGS-R/sbtools/issues) and let the developers know through a new issue or "thumbs-up" an existing, related issue.

When this function does work, you can use the results to create a map of the data in R. Here's a simple example using the R package `maps`. The item we will use as an example contains low flow estimations for New Jersey. We can map the sites used in the study.

``` r
nj_wfs <- item_get_wfs("58cbe556e4b0849ce97dcd31")
```

    ## Loading required namespace: rgdal

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "C:\Users\lcarr\AppData\Local\Temp\1\RtmpkDU3Rn/file27603ff95b43", layer: "NJ_low_flow_estimates_2016"
    ## with 62 features
    ## It has 18 fields

``` r
names(nj_wfs)
```

    ##  [1] "Date_req"   "Strm_name"  "DA"         "X1Q10"      "X7Q10"     
    ##  [6] "w7Q10"      "X30Q10"     "w30Q10"     "X70_dura"   "X75_dura"  
    ## [11] "latitude"   "longitude"  "Reference"  "Requestor"  "Comp_by"   
    ## [16] "method"     "USGS_sites" "comments"

``` r
maps::map("county", "new jersey")
points(nj_wfs$longitude, nj_wfs$latitude, col="red")
```

<img src='../static/sbtools-get/sbtools-wfs-1.png'/ title='Map of sbitem WFS data sites'/ alt='Sites from a ScienceBase item's WFS data on a map of New Jersey'/>
