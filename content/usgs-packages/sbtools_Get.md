---
author: Lindsay R. Carr
date: 9999-07-01
slug: sbtools-get
title: sbtools - Download Data
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
This lesson will describe the basic functions to manage ScienceBase authenticated sessions and view or download ScienceBase items. If you aren't sure what a ScienceBase item is, head back to the [previous lesson on `sbitems`](/sbtools-sbitem).

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

Each user has a specific ScienceBase id associated with their account. The user ids can be used to inspect what top-level items saved under your account (discussed in next section). To determine your user id, use the function `user_id` in an authenticated session. No arguments are necessary.

``` r
user_id()
```

    ## [1] "56215f74e4b06217fc478c3a"

When you're done with your session, you can actively logout using the `session_logout`. No arguments are required. If you do not do this, you will be automatically logged out after a certain amount of time or when you close R.

Inspect and download items
--------------------------

The first inspection step for ScienceBase items is to determine if the item even exists. To do this, use the function `identifier_exists`. The only required argument is `sb_id` which can be either a character string of the item id or an `sbitem`. It will return a logical to indicate if the item exists or not.

``` r
identifier_exists("4f4e4acae4b07f02db67d22b")
```

    ## [1] TRUE

``` r
identifier_exists("thisisnotagoodid")
```

    ## [1] FALSE

ScienceBase items can be described by alternative identifiers, e.g. digital object identifiers, IPDS codes, etc. They are defined on ScienceBase with a scheme, type, and key. For examples of identifiers, see the "Additional Information | Identifiers" section of [Differential Heating](https://www.sciencebase.gov/catalog/item/580587a2e4b0824b2d1c1f23).

You can use the function `item_exists` to check whether or not a scheme-type-key tuple already exists. The function has three required arguments - `scheme`, `type`, and `key`. Note that the table of alternative identifiers on ScienceBase is in a different order than this function accepts. On ScienceBase: type, scheme, key. For `item_exists`: scheme, type, key.

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

*describe as.sbitem and why you would use it*

``` r
# as.sbitem()
```

Let's inspect various ScienceBase items. There are functions to look at the parent item, metadata fields, sub-items, and associated files. Each of these functions require the id of the sbitem as the first argument. For all of these examples, we are going to use the same sbitem id, "4f4e4b24e4b07f02db6aea14".

First, let's inspect the parent item. The function to use is `item_get_parent`, and the item id is the only necessary argument.

``` r
ex_id <- "4f4e479de4b07f02db491e34"
ex_id_parent <- item_get_parent(ex_id)
ex_id_parent$title
```

    ## [1] "Arizona Geological Survey"

Now, let's see if this item has any children by using the `item_list_children` function. Notice that this function says "list" and not "get" as the previous one did. Functions with "list" only return a few fields associated with each item. Functions with "get" are pulling down all available information, including files, associated with an item.

``` r
ex_id_children <- item_list_children(ex_id)
length(ex_id_children)
```

    ## [1] 20

``` r
sapply(ex_id_children, function(item) item$title)
```

    ##  [1] "Cuttings for F.I.C.O."                                           
    ##  [2] "Cuttings for 0533. EL PASO NATURAL GAS - #1 FEDERAL-BULLARD WASH"
    ##  [3] "Cuttings for UNITED STATES BUREAU OF INDIAN AFFAIRS #63"         
    ##  [4] "Cuttings for BASILE"                                             
    ##  [5] "Cuttings for A.M. LANE"                                          
    ##  [6] "Samples for 01-52. Duval 32 State (strat)"                       
    ##  [7] "Cuttings for SHELL OIL - #1 NAVAJO (EAST BOUNDARY BUTTE)"        
    ##  [8] "Cuttings for 0210. MARLETTE MARTIN - #1 FITZGERALD"              
    ##  [9] "Cuttings for 0332. O'DONNELL & EWING - #1 FEDERAL"               
    ## [10] "Cuttings for 0430. TEXACO INCORPORATED - #1 NAVAJO-BC"           
    ## [11] "Cuttings for 0437. GULF OIL - #1 NAVAJO-AGUA SAL"                
    ## [12] "Cuttings for 0637. NORTHWEST PIPELINE - #1 JUDY LEE - NAVAJO"    
    ## [13] "Cuttings for 0796. PHILLIPS PETROLEUM - #A-1 MOUNTAIN VIEW STATE"
    ## [14] "Cuttings for 0801. MOUNTAIN STATES RESOURCES - #12 NAVAJO-O"     
    ## [15] "Cuttings for 0859. SHIELDS EXPLORATION CO. - #12-24 FEDERAL"     
    ## [16] "Cuttings for 09-28. GENERAL PETROLEUM - #14-6 CREAGER STATE"     
    ## [17] "Cuttings for BEAVER CREEK"                                       
    ## [18] "Cuttings for 10K-244"                                            
    ## [19] "Cuttings for PETRIFIED FOREST #1"                                
    ## [20] "Cuttings for CLAY HANNA"

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

You can also inspect specific metadata fields of ScienceBase items. To do this, use the `item_get_fields` function. This function requires a second argument to the item id called `fields` that is a character vector of the fields you want to retrieve. See the [developer documentation for a SB item model](https://my.usgs.gov/confluence/display/sciencebase/ScienceBase+Item+Core+Model) for a list of potential fields. You can also use the argument `drop` to indicate that if only one field is requested, the object returned remains a list (`drop=FALSE`) or becomes a vector (`drop=TRUE`). The default is `drop=TRUE`.

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
# request a nonexistent fields
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

Web feature services to visualize spatial data???
-------------------------------------------------

*Need to pick a different item. This one errs since there is "no ScienceBase WFS Service available".*

``` r
# ex_id_wfs <- item_get_wfs(ex_id)
# names(ex_id_item)
```
