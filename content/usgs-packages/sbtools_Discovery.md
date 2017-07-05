---
author: Lindsay R. Carr
date: 9999-07-01
slug: sbtools-discovery
title: sbtools - Data discovery
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
Although ScienceBase is a great platform for uploading and storing your data, you can also use it to find other available data. You can do that manually by searching using the ScienceBase web interface or through `sbtools` functions.

Discovering data via web interface
----------------------------------

The most familiar way to search for data would be to use the ScienceBase search capabilities available online. You can search for any publically available data in the [ScienceBase catalog](https://www.sciencebase.gov/catalog/). Search by category (map, data, project, publication, etc), topic-based tags, or location; or search by your own key words.

![ScienceBase Catalog Homepage](../static/img/sb_catalog_search.png#inline-img "search ScienceBase catalog")

Learn more about the [catalog search features](www.sciencebase.gov/about/content/explore-sciencebase#2.%20Search%20ScienceBase) and explore the [advanced searching capabilities](www.sciencebase.gov/about/content/sciencebase-advanced-search) on the ScienceBase help pages.

Discovering data via sbtools
----------------------------

The ScienceBase search tools can be very powerful, but lack the ability to easily recreate the search. If you want to incorporate dataset queries into a reproducible workflow, you can script them using the `sbtools` query functions. The terminology differs from the web interface slightly. Below are functions available to query the catalog:

1.  `query_sb_text` (matches title or description)
2.  `query_sb_doi` (use a DOI identifier)
3.  `query_sb_spatial` (data within or at a specific location)
4.  `query_sb_date` (items within time range)
5.  `query_sb_datatype` (type of data, not necessarily file type)
6.  `query_sb` (generic SB query)

These functions take a variety of inputs, and all return an R list of `sbitems` (a special `sbtools` class). All of these functions default to 20 returned search results, but you can change that by specifying the argument `limit`. The `query_sb` is a generalization of the other functions, and has a number of additional query specifications: [Lucene query string](http://www.lucenetutorial.com/lucene-query-syntax.html), folder and parent items, item ids, or project status. Before we practice using these functions, make sure you load the `sbtools` package in your current R session.

``` r
library(sbtools)
```

### Using `query_sb`

`query_sb` is the "catch-all" function for querying ScienceBase from R. It only takes one argument for specifying query parameters, `query_list`. This is an R list with specific query parameters as the list names and the user query string as the list values. See the `DESCRIPTION` section of the help file for all options (`?query_sb`).

``` r
##### THESE FIRST TWO SEARCHES STILL NEED WORK #####

# search by keyword
precip_query <- list(q = 'precipitation')
precip_data <- query_sb(query_list = precip_query)
length(precip_data) # 50 entries, so there is likely more than 50 results
```

    ## [1] 20

``` r
head(precip_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Change in Precipitation (Projected and Observed) and Change in Standard Precipitation For Emissions Scenarios A2, A1B and B1 for the Gulf of Mexico
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 5947ffa5e4b062508e3442eb
    ##   Parent ID: 5931cdcee4b0e9bd0eaa47cc
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Precipitation as Snow (PAS)
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 52d6bdcde4b0b566e996b438
    ##   Parent ID: 52d6b312e4b0b566e996b38a

``` r
# search by keyword + category
precip_maps_query <- list(q = 'precipitation', browseType = "Static Map Image", sort='title')
precip_maps_data <- query_sb(query_list = precip_query)
head(precip_maps_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Change in Precipitation (Projected and Observed) and Change in Standard Precipitation For Emissions Scenarios A2, A1B and B1 for the Gulf of Mexico
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 5947ffa5e4b062508e3442eb
    ##   Parent ID: 5931cdcee4b0e9bd0eaa47cc
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Precipitation as Snow (PAS)
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 52d6bdcde4b0b566e996b438
    ##   Parent ID: 52d6b312e4b0b566e996b38a

``` r
##### -------------------------------------- #####

# search by 2 keywords
hazard2_query <- list(q = 'flood', q = 'earthquake')
hazard2_data <- query_sb(query_list = hazard2_query)
length(hazard2_data)
```

    ## [1] 20

``` r
head(hazard2_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Ground breakage and associated effects in the Cook Inlet area, Alaska, resulting from the March 27, 1964 earthquake: Chapter F in <i>The Alaska earthquake, March 27, 1964: regional effects</i>
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 4f4e4ab0e4b07f02db66dcf3
    ##   Parent ID: 4f4e4771e4b07f02db47e1e4
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Effects of the March 1964 Alaska earthquake on the hydrology of south-central Alaska: Chapter A in <i>The Alaska earthquake, March 27, 1964: effects on hydrologic regimen</i>
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 4f4e4a27e4b07f02db6105cd
    ##   Parent ID: 4f4e4771e4b07f02db47e1e4

``` r
# search by 3 keywords
hazard3_query <- list(q = 'flood', q = 'earthquake', q='drought')
hazard3_data <- query_sb(query_list = hazard3_query)
length(hazard3_data)
```

    ## [1] 1

``` r
head(hazard3_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: The Mw6.0 24 August 2014 South Napa earthquake
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 54f97e2de4b02419550d9b60
    ##   Parent ID: 4f4e4771e4b07f02db47e1e4

### Using `query_sb_text`

`query_sb_text` returns a list of `sbitems` that match the title or description fields. Use it to search authors, station names, rivers, states, etc.

``` r
# search using a contributors name
contrib_results <- query_sb_text("Robert Hirsch")
head(contrib_results, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Input data and results of WRTDS models and seasonal rank-sum tests to determine trends in the quality of water in New Jersey streams, water years 1971-2011
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 573e031ee4b02c61aaace7eb
    ##   Parent ID: 56df010ae4b015c306fc2af9
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Evaluation of stream nutrient trends in the Lake Erie drainage basin in the presence of changing patterns in climate, streamflow, land drainage, and agricultural practices
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 57bb0ffce4b03fd6b7dd03dd
    ##   Parent ID: 52e6a0a0e4b012954a1a238a

``` r
# search using place of interest
park_results <- query_sb_text("Yellowstone")
head(park_results, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Spatial and temporal relations between fluvial and allacustrine Yellowstone cutthroat trout, Oncorhynchus clarki bouvieri, spawning in the Yellowstone River, outlet stream of Yellowstone Lake
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 50577ee7e4b01ad7e027f275
    ##   Parent ID: 5046602fe4b0241d49d62cab
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Conservation and Climate Adaptation Strategies for Yellowstone Cutthroat Trout
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 520039e8e4b0ad2d97189de0
    ##   Parent ID: 529e1574e4b0516126f68e8a

``` r
# search using a site location
loc_results <- query_sb_text("Embudo")
length(loc_results)
```

    ## [1] 17

``` r
head(loc_results, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Embudo, New Mexico, birthplace of systematic stream gaging
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 4f4e4a19e4b07f02db6058ea
    ##   Parent ID: 4f4e4771e4b07f02db47e1e4
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Rio Grande gauging station, Rio Grande River, Embudo, Rio Arriba County, New Mexico. Circa 1899.
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 51ddce45e4b0f72b44721a4f
    ##   Parent ID: 519ba0a3e4b0e4e151ef5dd9

### Using `query_sb_doi`

Use a Digital Object Identifier (DOI) to query ScienceBase. This should return only one list item, unless there is more than one ScienceBase item referencing this very unique identifier.

``` r
# USGS Microplastics study 
query_sb_doi('10.5066/F7ZC80ZP')
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Microplastics in 29 Great Lakes tributaries (2014-15)
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 5748a29be4b07e28b664dd62
    ##   Parent ID: 55a9170be4b0183d66e4667e

``` r
####### I've tried A TON of DOIs I found through the web interface and just
####### keep getting empty lists returned.
query_sb_doi('10.1016/j.coldregions.2007.05.009')
```

    ## list()

### Using `query_sb_spatial`

`query_sb_spatial` accepts 3 different methods for specifying a spatial area in which to look for data. You can specify a bounding box `bbox` as an `sp` spatial data object *\[\[\[\[NEED MORE TEXT HERE\]\]\]\]*. Alternatively, you can supply a vector of latitudes and a vector of longitudes using `lat` and `long` arguments. The function will automatically use the minimum and maximum from those vectors to construct a boundary box. The last way to represent a spatial region to query ScienceBase is using a POLYGON Well-known text (WKT) object as a text string. The format is `"POLYGON(([LONG1 LAT1], [LONG2 LAT2], [LONG3 LAT3]))"`, where `LONG#` and `LAT#` are longitude and latitude pairs as decimals. See the [Open Geospatial Consortium WKT standard](http://www.opengeospatial.org/standards/wkt-crs) for more information.

``` r
### SPATIAL QUERY EXAMPLES NEED SOME TLC

appalachia <- data.frame(
  lat = c(34.576900, 36.114974, 37.374456, 35.919619, 39.206481),
  long = c(-84.771119, -83.393990, -81.256731, -81.492395, -78.417345))

conus <- data.frame(
  lat = c(49.078148, 47.575022, 32.914614, 25.000481),
  long = c(-124.722111, -67.996898, -118.270335, -80.125804))

# verifying where points are supposed to be
maps::map('usa')
points(conus$long, conus$lat, col="red", pch=20)
points(appalachia$long, appalachia$lat, col="green", pch=20)

# query by bounding box
bbox_sp_obj <- sp::SpatialPoints(appalachia)
```

<img src='../static/sbtools-discovery/unnamed-chunk-5-1.png'/ title='TODO'/>

``` r
# query_sb_spatial(bbox=bbox_sp_obj)

# query by latitude and longitude vectors
query_sb_spatial(long = appalachia$long, lat = appalachia$lat)
```

    ## list()

``` r
query_sb_spatial(long = conus$long, lat = conus$lat)
```

    ## list()

``` r
# query by WKT polygon
wkt_coord_str <- paste(conus$long, conus$lat, sep=" ", collapse = ",")
wkt_str <- sprintf("POLYGON((%s))", wkt_coord_str)
# query_sb_spatial(bb_wkt = wkt_str)
```

### Using `query_sb_date`

`query_sb_date` returns ScienceBase items that fall within a certain time range. There are multiple timestamps applied to items, so you will need to specify which one to match the range. The default queries are to look for items last updated between 1970-01-01 and today's date. See `?query_sb_date` for more examples of which timestamps are available.

``` r
# find data worked on in the last week
today <- Sys.time()
oneweekago <- today - (7*24*3600) # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneweekago)
head(recent_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: US Topo
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 4f554236e4b018de15819c85
    ##   Parent ID: 4f552e93e4b018de15819c51
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: National Elevation Dataset (NED) Alaska 2 arc-second
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 4f70aaece4b058caae3f8de9
    ##   Parent ID: 4f70a58ce4b058caae3f8ddb

``` r
# find data that's been created over the last year
oneyearago <- today - (365*24*3600) # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneyearago, date_type = "dateCreated")
head(recent_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: USGS NED Original Product Resolution CA Sonoma 2013 bh soco 0074 TIFF 2017
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 595cb18be4b0d1f9f0551fc9
    ##   Parent ID: 530f4226e4b0e7e46bd2c315
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: USGS NED Original Product Resolution CA Sonoma 2013 bh soco 0051 TIFF 2017
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 595cb186e4b0d1f9f0551fb3
    ##   Parent ID: 530f4226e4b0e7e46bd2c315

### Using `query_sb_datatype`

`query_sb_datatype` is used to search ScienceBase by the type of data an item is listed as. Run `sb_datatypes()` to get a list of 50 available data types.

``` r
# get ScienceBase news items
sbnews <- query_sb_datatype("News")
head(sbnews, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Will Climate Change Hurt Tropical Rainforests? Scientists Study the Effects of Warming on Puerto Rican Forest
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 53b1c3c2e4b0c9da2f80d598
    ##   Parent ID: 5266a3c4e4b0992695a7fbfd
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Fire and Ice: Gauging the Effects of Wildfire on Alaskan Permafrost
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 58d552f1e4b05ec79911d3de
    ##   Parent ID: 58ac67bfe4b0ce4410e7d6f2

``` r
# find shapefiles
shps <- query_sb_datatype("Shapefile")
head(shps, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Gulf of Alaska Digitization Project
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 5699855be4b0ec051295ed8b
    ##   Parent ID: 585c3c01e4b01224f329bb08
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Estimated low-flow statistics at ungaged stream locations in New Jersey, water year 2016
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 58cbe556e4b0849ce97dcd31
    ##   Parent ID: 56df0016e4b015c306fc2aad

``` r
# find raster data
sbraster <- query_sb_datatype("Raster")
head(sbraster, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Modified Land Cover Raster for the Upper Oconee Watershed
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 58f7c353e4b0b7ea5451fa98
    ##   Parent ID: 551334dde4b02e76d75c0990
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Digital elevation model of Little Holland Tract, Sacramento-San Joaquin Delta, California, 2015
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 564bafdce4b0ebfbef0d3322
    ##   Parent ID: 585c3c01e4b01224f329bb08

Best of both methods
--------------------

Although you can query from R, sometimes it's useful to look an item on the web interface. You can use the `query_sb_*` functions and then follow that URL to view items on the web. This is especially handy for viewing maps and metadata, or to check or repair a ScienceBase item if any of the `sbtools`-based commands have failed.

``` r
sbmaps <- query_sb_datatype("Static Map Image", limit=3)
oneitem <- sbmaps[[1]]

# get and open URL from single sbitem
url_oneitem <- oneitem[['link']][['url']]
browseURL(url_oneitem)

# get and open URLs from many sbitems
lapply(sbmaps, function(sbitem) {
  url <- sbitem[['link']][['url']]
  browseURL(url)
  return(url)
})
```

    ## [[1]]
    ## [1] "https://www.sciencebase.gov/catalog/item/4f4e4813e4b07f02db4da961"
    ## 
    ## [[2]]
    ## [1] "https://www.sciencebase.gov/catalog/item/4f4e4884e4b07f02db51840f"
    ## 
    ## [[3]]
    ## [1] "https://www.sciencebase.gov/catalog/item/57b3b8e7e4b03bcb0103980a"

No results
----------

Some of your queries will probably return no results. When there are no results that match your query, the returned list will have a length of 0.

``` r
# search for items related to a Water Quality Portal paper DOI
query_results <- query_sb_doi(doi = '10.1002/2016WR019993')
length(query_results)
```

    ## [1] 0

``` r
head(query_results)
```

    ## list()
