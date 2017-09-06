---
author: Lindsay R. Carr
date: 9999-07-25
slug: sbtools-discovery
title: sbtools - Data discovery
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 31
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

These functions take a variety of inputs, and all return an R list of `sbitems` (a special `sbtools` class). All of these functions default to 20 returned search results, but you can change that by specifying the argument `limit`. The `query_sb` is a generalization of the other functions, and has a number of additional query specifications: [Lucene query string](http://www.lucenetutorial.com/lucene-query-syntax.html), folder and parent items, item ids, or project status. Sometimes it is helpful to look at the [Advanced Search web form](https://www.sciencebase.gov/catalog/items/queryForm) to see what options are available to include in your `sbtools` code.

Before we practice using these functions, make sure you load the `sbtools` package in your current R session.

``` r
library(sbtools)
```

### Using `query_sb_text`

`query_sb_text` returns a list of `sbitems` that match the title or description fields. Use it to search authors, station names, rivers, states, etc.

``` r
# search using a contributor's name
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
# search using a river
river_results <- query_sb_text("Rio Grande")
length(river_results)
```

    ## [1] 20

``` r
head(river_results, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Middle Rio Grande Multitemporal Land Cover Classifications - 1935, 1962, 1987, 1999, and 2014
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 58fe18eee4b0f87f0854ad3f
    ##   Parent ID: 5474ec49e4b04d7459a7eab2
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Water and Air Temperature Throughout the Range of Rio Grande Cutthroat Trout in Colorado and New Mexico; 2010-2015 V2
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 56d08559e4b015c306ee98c7
    ##   Parent ID: 5274215be4b097f32ac3f3d5

It might be easier to look at the results returned from queries by just looking at their titles. The other information stored in an sbitem is useful, but a little distracting when you are looking at many results. You can use `sapply` to extract the titles.

``` r
# look at all titles returned from the site location query previously made
sapply(river_results, function(item) item$title)
```

    ##  [1] "Middle Rio Grande Multitemporal Land Cover Classifications - 1935, 1962, 1987, 1999, and 2014"                                                                     
    ##  [2] "Water and Air Temperature Throughout the Range of Rio Grande Cutthroat Trout in Colorado and New Mexico; 2010-2015 V2"                                             
    ##  [3] "Data release of Three-Dimensional Hydrogeologic Framework Model of the Rio Grande Transboundary Region of New Mexico and Texas, USA and Northern Chihuahua, Mexico"
    ##  [4] "Upper Rio Grande"                                                                                                                                                  
    ##  [5] "Acoustic Doppler current profiler velocity data collected during 2015 and 2016 in the Calumet Harbor, Illinois"                                                    
    ##  [6] "Data for a Comprehensive Survey of Fault Zones, Breccias, and Fractures in and Flanking the Eastern Española Basin, Rio Grande Rift, New Mexico"                   
    ##  [7] "Magnetotelluric sounding locations, stations 1 to 22, Southern San Luis Valley, Colorado, 2006"                                                                    
    ##  [8] "Notropis jemezanus (Rio Grande shiner)"                                                                                                                            
    ##  [9] "Pseudemys gorzugi (Rio Grande Cooter)"                                                                                                                             
    ## [10] "Etheostoma grahami (Rio Grande darter)"                                                                                                                            
    ## [11] "The Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                                       
    ## [12] "View of the Rio Grande near Pole Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                                      
    ## [13] "View on the Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                               
    ## [14] "The Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                                       
    ## [15] "View of the Rio Grande, near Pole Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                                     
    ## [16] "View on the Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                               
    ## [17] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874. (Stereoscopic view)"                                                                            
    ## [18] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874."                                                                                                
    ## [19] "The Rio Grande Del Norte, below Wagon Wheel Gap. Mineral County, Colorado. 1874."                                                                                  
    ## [20] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874. (Stereoscopic view)"

Now you can use `sapply` to look at the titles for your returned searches instead of `head`.

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
# Environmental Characteristics data
query_sb_doi('10.5066/F77W699S')
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Selected Environmental Characteristics of Sampled Sites, Watersheds, and Riparian Zones for the U.S. Geological Survey Midwest Stream Quality Assessment
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 5714ec24e4b0ef3b7ca85d75
    ##   Parent ID: 569972c5e4b0ec051295ece5

### Using `query_sb_spatial`

`query_sb_spatial` accepts 3 different methods for specifying a spatial area in which to look for data. To illustrate the methods, we are going to use the spatial extents of the Appalachian Mountains and the Continental US.

``` r
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
```

<img src='../static/sbtools-discovery/query_sb_spatial-1.png'/ title='Map of Appalchia & CONUS points'/ alt='Map of US with points used to define Appalachia and the Continental US'/>

The first way to query spatially is by specifying a bounding box `bbox` as an `sp` spatial data object. Visit the [`sp` package documentation](https://cran.r-project.org/web/packages/sp/vignettes/intro_sp.pdf) for more information on spatial data objects.

``` r
# query by bounding box
query_sb_spatial(bbox=
                   sp::SpatialPoints(appalachia,  proj4string = 
                      sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")))
```

    ## Loading required namespace: sp

    ## list()

Alternatively, you can supply a vector of latitudes and a vector of longitudes using `lat` and `long` arguments. The function will automatically use the minimum and maximum from those vectors to construct a boundary box.

``` r
# query by latitude and longitude vectors
query_sb_spatial(long = appalachia$long, lat = appalachia$lat)
```

    ## list()

``` r
query_sb_spatial(long = conus$long, lat = conus$lat)
```

    ## list()

The last way to represent a spatial region to query ScienceBase is using a POLYGON Well-known text (WKT) object as a text string. The format is `"POLYGON(([LONG1 LAT1], [LONG2 LAT2], [LONG3 LAT3]))"`, where `LONG#` and `LAT#` are longitude and latitude pairs as decimals. See the [Open Geospatial Consortium WKT standard](http://www.opengeospatial.org/standards/wkt-crs) for more information.

``` r
# query by WKT polygon
wkt_coord_str <- paste(conus$long, conus$lat, sep=" ", collapse = ",")
wkt_str <- sprintf("POLYGON((%s))", wkt_coord_str)
query_sb_spatial(bb_wkt = wkt_str)
```

    ## list()

### Using `query_sb_date`

`query_sb_date` returns ScienceBase items that fall within a certain time range. There are multiple timestamps applied to items, so you will need to specify which one to match the range. The default queries are to look for items last updated between 1970-01-01 and today's date. See `?query_sb_date` for more examples of which timestamps are available.

``` r
# find data worked on in the last week
today <- Sys.Date()
oneweekago <- today - as.difftime(7, units='days') # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneweekago)
sapply(recent_data, function(item) item$title)
```

    ##  [1] "US Topo"                                                                                                  
    ##  [2] "National Elevation Dataset (NED) Alaska 2 arc-second"                                                     
    ##  [3] "Topo Map Data"                                                                                            
    ##  [4] "USGS 2017 LDurning: Water classification of the Colorado River Corridor, Grand Canyon, Arizona, 2013Data"
    ##  [5] "Everglades National Park sediment elevation and marker horizon data release"                              
    ##  [6] "Upper Midwest and Great Lakes Landscape Conservation Cooperative"                                         
    ##  [7] "Church Buttes on Blacks Fork near Granger. Uinta County, Wyoming. 1870."                                  
    ##  [8] "Camp scene. Wyoming. 1870."                                                                               
    ##  [9] "Evanston coal mines, Uinta County, Wyoming, 1871."                                                        
    ## [10] "National Transportation Dataset (NTD)"                                                                    
    ## [11] "USGS US Topo 7.5-minute map for Canton, NJ-DE 2011"                                                       
    ## [12] "USGS US Topo 7.5-minute map for Canton, NJ-DE 2014"                                                       
    ## [13] "USGS US Topo 7.5-minute map for Chatham, NJ 2011"                                                         
    ## [14] "USGS US Topo 7.5-minute map for Chatham, NJ 2014"                                                         
    ## [15] "USGS US Topo 7.5-minute map for Altamaha, GA 2014"                                                        
    ## [16] "USGS US Topo 7.5-minute map for Alma NW, GA 2011"                                                         
    ## [17] "USGS US Topo 7.5-minute map for Arabi, GA 2014"                                                           
    ## [18] "USGS US Topo 7.5-minute map for Bridgeton, NJ 2014"                                                       
    ## [19] "USGS US Topo 7.5-minute map for Branchville, NJ 2014"                                                     
    ## [20] "USGS US Topo 7.5-minute map for Bartlettsville, IN 2013"

``` r
# find data that's been created over the last year
oneyearago <- today - as.difftime(365, units='days') # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneyearago, date_type = "dateCreated")
sapply(recent_data, function(item) item$title)
```

    ##  [1] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99101375 ArcGrid 2017"
    ##  [2] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99101377 ArcGrid 2017"
    ##  [3] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 98901621 ArcGrid 2017"
    ##  [4] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 98901587 ArcGrid 2017"
    ##  [5] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99101517 ArcGrid 2017"
    ##  [6] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99101533 ArcGrid 2017"
    ##  [7] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 98901557 ArcGrid 2017"
    ##  [8] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 98901601 ArcGrid 2017"
    ##  [9] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 98901611 ArcGrid 2017"
    ## [10] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501481 ArcGrid 2017"
    ## [11] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501489 ArcGrid 2017"
    ## [12] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501491 ArcGrid 2017"
    ## [13] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501515 ArcGrid 2017"
    ## [14] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501591 ArcGrid 2017"
    ## [15] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501597 ArcGrid 2017"
    ## [16] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99701385 ArcGrid 2017"
    ## [17] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501463 ArcGrid 2017"
    ## [18] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99701413 ArcGrid 2017"
    ## [19] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501585 ArcGrid 2017"
    ## [20] "USGS NED Original Product Resolution IL FordIroqouisLivingston 2015 dem 99501609 ArcGrid 2017"

### Using `query_sb_datatype`

`query_sb_datatype` is used to search ScienceBase by the type of data an item is listed as. Run `sb_datatypes()` to get a list of 50 available data types.

``` r
# get ScienceBase news items
sbnews <- query_sb_datatype("News")
sapply(sbnews, function(item) item$title)
```

    ## [1] "Will Climate Change Hurt Tropical Rainforests? Scientists Study the Effects of Warming on Puerto Rican Forest"
    ## [2] "Fire and Ice: Gauging the Effects of Wildfire on Alaskan Permafrost"                                          
    ## [3] "Sample Event Item"

``` r
# find shapefiles
shps <- query_sb_datatype("Shapefile")
sapply(shps, function(item) item$title)
```

    ##  [1] "Gulf of Alaska Digitization Project"                                                                                                                                                               
    ##  [2] "Estimated low-flow statistics at ungaged stream locations in New Jersey, water year 2016"                                                                                                          
    ##  [3] "Airborne magnetic and radiometric survey, Ironton, Missouri area"                                                                                                                                  
    ##  [4] "Gravity Change from 2014 to 2015, Sierra Vista Subwatershed, Upper San Pedro Basin, Arizona"                                                                                                       
    ##  [5] "Airborne electromagnetic and magnetic survey data, East Poplar Oil Field and surrounding area, October 2014, Fort Peck Indian Reservation, Montana"                                                
    ##  [6] "Magnetotelluric sounding locations, stations 1 to 22, Southern San Luis Valley, Colorado, 2006"                                                                                                    
    ##  [7] "Cape Lookout, North Carolina 2012 National Wetlands Inventory Habitat Classification"                                                                                                              
    ##  [8] "Inorganic and organic concentration data collected from 38 streams in the United States, 2012-2014, with supporting data, as part of the Chemical Mixtures and Environmental Effects Pilot Study." 
    ##  [9] "Mean of the Top Ten Percent of NDVI Values in the Yuma Proving Ground during Monsoon Season, 1986-2011"                                                                                            
    ## [10] "Principal facts of gravity data in the southern San Luis Basin, northern New Mexico"                                                                                                               
    ## [11] "Airborne Geophysical Surveys over the Eastern Adirondacks, New York State"                                                                                                                         
    ## [12] "PaRadonGW.shp - Evaluation of Radon Occurrence in Groundwater from 16 Geologic Units in Pennsylvania, 19862015, with Application to Potential Radon Exposure from Groundwater and Indoor Air"     
    ## [13] "Boat-based water-surface elevation surveys along the upper Willamette River, Oregon, in March, 2015"                                                                                               
    ## [14] "Sediment Texture and Geomorphology of the Sea Floor from Fenwick Island, Maryland to Fisherman's Island, Virginia"                                                                                 
    ## [15] "Point locations for earthquakes M2.5 and greater in a two-year aftershock sequence resulting from the HayWired scenario earthquake mainshock (4/18/2018) in the San Francisco Bay area, California"
    ## [16] "Data for a Comprehensive Survey of Fault Zones, Breccias, and Fractures in and Flanking the Eastern Española Basin, Rio Grande Rift, New Mexico"                                                   
    ## [17] "Bathymetry and Capacity of Shawnee Reservoir, Oklahoma, 2016"                                                                                                                                      
    ## [18] "Direct-push sediment cores, resistivity profiles, and depth-averaged resistivity collected for Platte River Recovery and Implementation Program in Phelps County, Nebraska"                        
    ## [19] "Carbonate geochemistry dataset of the soil and an underlying cave in the Ozark Plateaus, central United States"                                                                                    
    ## [20] "Gravity cores from San Pablo Bay and Carquinez Strait, San Francisco Bay, California"

``` r
# find raster data
sbraster <- query_sb_datatype("Raster")
sapply(sbraster, function(item) item$title)
```

    ##  [1] "Modified Land Cover Raster for the Upper Oconee Watershed"                                                                                         
    ##  [2] "Digital elevation model of Little Holland Tract, Sacramento-San Joaquin Delta, California, 2015"                                                   
    ##  [3] "Grassland quality and pollinator habitat potential in Southwest Louisiana"                                                                         
    ##  [4] "Seafloor character--Offshore Pigeon Point, California"                                                                                             
    ##  [5] "2010 UMRS Color Infrared Aerial Photo Mosaic - Illinois River, LaGrange Pool South"                                                                
    ##  [6] "2010 UMRS Color Infrared Aerial Photo Mosaic - Mississippi River, Pool 06"                                                                         
    ##  [7] "Vegetation data for 1970-1999, 2035-2064, and 2070-2099 for 59 vegetation types"                                                                   
    ##  [8] "Ecologically-relevant landforms for Southern Rockies LCC"                                                                                          
    ##  [9] "Multivariate Adaptive Constructed Analogs (MACA) CMIP5 Statistically Downscaled Data for Coterminous USA"                                          
    ## [10] "Backscatter [USGS07]--Offshore of Gaviota Map Area, California"                                                                                    
    ## [11] "North American vegetation model data for land-use planning in a changing climate:"                                                                 
    ## [12] "Bathymetry hillshade--Offshore of Point Conception Map Area, California"                                                                           
    ## [13] "Projected Future LOCA Statistical Downscaling (Localized Constructed Analogs) Statistically downscaled CMIP5 climate projections for North America"
    ## [14] "Bathymetry Hillshade [2m]--Offshore of Monterey Map Area, California"                                                                              
    ## [15] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T5 from 2003"                                                            
    ## [16] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T6 from 2006"                                                            
    ## [17] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P6 from 2006"                                                            
    ## [18] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T4 from 14 July 1999"                                                    
    ## [19] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P11 from 18 July 1990"                                                   
    ## [20] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P1 from 1977"

Best of both methods
--------------------

Although you can query from R, sometimes it's useful to look at an item on the web interface. You can use the `query_sb_*` functions and then follow that URL to view items on the web. This is especially handy for viewing maps and metadata, or to check or repair a ScienceBase item if any of the `sbtools`-based commands have failed.

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

### Using `query_sb`

`query_sb` is the "catch-all" function for querying ScienceBase from R. It only takes one argument for specifying query parameters, `query_list`. This is an R list with specific query parameters as the list names and the user query string as the list values. See the `Description` section of the help file for all options (`?query_sb`). To see the available categories to use for the field `browseCategory`, visit [this SB page](https://www.sciencebase.gov/vocab/vocabulary/browseCategories).

``` r
# search by keyword
precip_data <- query_sb(query_list = list(q = 'precipitation'))
length(precip_data) # 20 entries, but there is likely more than 20 results
```

    ## [1] 20

``` r
sapply(precip_data, function(item) item$title)
```

    ##  [1] "Change in Precipitation (Projected and Observed) and Change in Standard Precipitation For Emissions Scenarios A2, A1B and B1 for the Gulf of Mexico"
    ##  [2] "Precipitation as Snow (PAS)"                                                                                                                        
    ##  [3] "Mean Summer (May to Sep) Precipitation (MSP)"                                                                                                       
    ##  [4] "Summer (Jun to Aug) Precipitation (PPTSM)"                                                                                                          
    ##  [5] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ##  [6] "Mean Annual Precipitation (MAP)"                                                                                                                    
    ##  [7] "Precipitation mm/year projections for years 2010-2080 RCP 8.5"                                                                                      
    ##  [8] "Precipitation mm/year projections for years 2010-2080 RCP 4.5"                                                                                      
    ##  [9] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [10] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [11] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [12] "Precipitation - 30-year Normal (cm)"                                                                                                                
    ## [13] "Winter (Dec to Feb) Precipitation (PPTWT)"                                                                                                          
    ## [14] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [15] "Average, Standard and Projected Precipitation for Emissions Scenarios A2, A1B, and B1 for the Gulf of Mexico"                                       
    ## [16] "30 Year Mean Annual Precipitation 1960- 1990 PRISM"                                                                                                 
    ## [17] "Precipitation variability and primary productivity in water-limited ecosystems: how plants 'leverage' precipitation to 'finance' growth"            
    ## [18] "Climate change and precipitation - Consequences of more extreme precipitation regimes for terrestrial ecosystems"                                   
    ## [19] "A Numerical Study of the 1996 Saguenay Flood Cyclone: Effect of Assimilation of Precipitation Data on Quantitative Precipitation Forecasts"         
    ## [20] "A precipitation-runoff model for part of the Ninemile Creek Watershed near Camillus, Onondaga County, New York"

``` r
# search by keyword, sort by last updated, and increase num results allowed
precip_data_recent <- query_sb(query_list = list(q = 'precipitation', 
                                                 sort = 'lastUpdated',
                                                 limit = 50))
length(precip_data_recent) # 50 entries, but the search criteria is the same, just sorted
```

    ## [1] 20

``` r
sapply(precip_data_recent, function(item) item$title)
```

    ##  [1] "Attributes for NHDPlus Version 2.1 Reach Catchments and Modified Routed Upstream Watersheds for the Conterminous United States: PRISM 30 Year (1961-1990) Monthly Mean of Number of Days of Measurable Precipitation"
    ##  [2] "Attributes for NHDPlus Version 2.1 Reach Catchments and Modified Routed Upstream Watersheds for the Conterminous United States: PRISM 30 Year (1961-1990) Annual Average Number of Days of Measurable Precipitation" 
    ##  [3] "Southwest CSC"                                                                                                                                                                                                       
    ##  [4] "Northwest CSC"                                                                                                                                                                                                       
    ##  [5] "Northeast CSC"                                                                                                                                                                                                       
    ##  [6] "North Central CSC"                                                                                                                                                                                                   
    ##  [7] "Alaska CSC"                                                                                                                                                                                                          
    ##  [8] "Greater sage-grouse (<em>Centrocercus urophasianus</em>) nesting and brood-rearing microhabitat in Nevada and CaliforniaSpatial variation in selection and survival patterns"                                       
    ##  [9] "Model-Based Scenario Planning to Inform Climate Change Adaptation in the Northern Great Plains"                                                                                                                      
    ## [10] "Geospatial data for Luquillo Mountains, Puerto Rico: Mean annual precipitation, elevation, watershed outlines, and rain gage locations"                                                                              
    ## [11] "Wetland hydroperiod and climate change; implications for biodiversity and water availability"                                                                                                                        
    ## [12] "Geospatial data supporting assessments of streamflow alteration to support bay and estuary restoration in the Gulf States"                                                                                           
    ## [13] "The effects of climate-change-induced drought and freshwater wetlands"                                                                                                                                               
    ## [14] "The role of snow cover affecting boreal-arctic soil freeze-thaw and carbon dynamics"                                                                                                                                 
    ## [15] "Assessing coastal wetland vulnerability to sea-level rise along the northern Gulf of Mexico coast: gaps and opportunities for developing a coordinated regional sampling network"                                    
    ## [16] "Hierarchical, quantitative biogeographic provinces for all North American turtles and their contribution to the biogeography of turtles and the continent"                                                           
    ## [17] "Main chamber of Devils Hole, Death Valley National Park, Nevada. 1986."                                                                                                                                              
    ## [18] "Linking Mule Deer Migration to Spring Green-Up in Wyoming"                                                                                                                                                           
    ## [19] "Selected Basin Characterization Model Parameters for the Great Basin Carbonate and Alluvial Aquifer System of Nevada, Utah, and Parts of Adjacent States"                                                            
    ## [20] "Effects of extreme floods on macroinvertebrate assemblages in tributaries to the Mohawk River, New York, USA"

``` r
# search by keyword + type
# Used sb_datatype() to figure out what types were allowed for "browseType"
precip_maps_data <- query_sb(query_list = list(q = 'precipitation', browseType = "Static Map Image", sort='title'))
sapply(precip_maps_data, function(item) item$title)
```

    ## [1] "The Washington-British Columbia Transboundary Climate-Connectivity Project"

If you want to search by more than one keyword, you should use Lucene query syntax. Visit [this page](http://www.lucenetutorial.com/lucene-query-syntax.html) for information on Lucene queries. For instance, you can have results returned that include both "flood" and "earthquake", or either "flood" or "earthquake". Current functionality requires a regular query to be specified in order for `lq` to return results. So, just include `q = ''` when executing Lucene queries (this is a known [issue](https://github.com/USGS-R/sbtools/issues/236) in `sbtools`).

``` r
# search by 2 keywords (AND)
hazard2and_data <- query_sb(query_list = list(q = '', lq = 'flood AND earthquake'), 
                            limit=200)
length(hazard2and_data)
```

    ## [1] 63

``` r
# search by 2 keywords (OR)
hazard2or_data <- query_sb(query_list = list(q = '', lq = 'flood OR earthquake'),
                           limit=200)
length(hazard2or_data)
```

    ## [1] 200

``` r
# search by 3 keywords with grouped query
hazard3_data <- query_sb(query_list = 
                           list(q = '', lq = '(flood OR earthquake) AND drought'),
                         limit=200)
length(hazard3_data)
```

    ## [1] 161

No results
----------

Some of your queries will probably return no results. When there are no results that match your query, the returned list will have a length of 0.

``` r
# search for items related to a Water Quality Portal paper DOI
wqp_paper <- query_sb_doi(doi = '10.1002/2016WR019993')
length(wqp_paper)
```

    ## [1] 0

``` r
head(wqp_paper)
```

    ## list()

``` r
# spatial query in the middle of the Atlantic Ocean
atlantic_ocean <- query_sb_spatial(long=28.790431, lat=-41.436485)
length(atlantic_ocean)
```

    ## [1] 0

``` r
head(atlantic_ocean)
```

    ## list()

``` r
# date query during Marco Polo's life
marco_polo <- query_sb_date(start = as.Date("1254-09-15"), 
                           end = as.Date("1324-01-08"))
length(marco_polo)
```

    ## [1] 0

``` r
head(marco_polo)
```

    ## list()
