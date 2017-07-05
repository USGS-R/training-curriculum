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

`query_sb` is the "catch-all" function for querying ScienceBase from R. It only takes one argument for specifying query parameters, `query_list`. This is an R list with specific query parameters as the list names and the user query string as the list values. See the `Description` section of the help file for all options (`?query_sb`).

``` r
# search by keyword
precip_data <- query_sb(query_list = list(q = 'precipitation'))
length(precip_data) # 20 entries, but there is likely more than 20 results
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
# search by keyword, sort by last updated, and increase num results allowed
precip_data_recent <- query_sb(query_list = list(q = 'precipitation', 
                                                 sort = 'lastUpdated',
                                                 limit = 50))
length(precip_data_recent) # 50 entries, but the search criteria is the same, just sorted
```

    ## [1] 20

``` r
head(precip_data_recent, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: Developing an Agroforestry Dashboard for the Marshall Islands
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 537bafe0e4b0929ba498b965
    ##   Parent ID: 5362adade4b0c409c6289bab
    ## 
    ## [[2]]
    ## <ScienceBase Item> 
    ##   Title: Measured and estimated monthly precipitation values for precipitation gages in the Black Hills area, South Dakota, water years 1931-98
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 535ea343e4b08e65d60fafb4
    ##   Parent ID: 52824fe6e4b08f1425d6e23c

``` r
# search by keyword + type
precip_maps_data <- query_sb(query_list = list(q = 'precipitation', browseType = "Static Map Image", sort='title'))
head(precip_maps_data, 2)
```

    ## [[1]]
    ## <ScienceBase Item> 
    ##   Title: The Washington-British Columbia Transboundary Climate-Connectivity Project
    ##   Creator/LastUpdatedBy:      / 
    ##   Provenance (Created / Updated):   / 
    ##   Children: 
    ##   Item ID: 57b3b8e7e4b03bcb0103980a
    ##   Parent ID: 5318c6bae4b0ae6e9d5a3bb1

It might be easier to look at the results returned from queries by just looking at their titles. The other information stored in an sbitem is useful, but a little distracting when you are looking at many results. You can use `sapply` to extract the titles.

``` r
# look at all titles returned from the map query previously made
sapply(precip_maps_data, function(item) item$title)
```

    ## [1] "The Washington-British Columbia Transboundary Climate-Connectivity Project"

Now you can use `sapply` to look at the titles for your returned searches instead of `head`.

If you want to search by more than one keyword, you should use Lucene query syntax. Visit [this page](http://www.lucenetutorial.com/lucene-query-syntax.html) for information on Lucene queries. For instance, you can have results returned that include both "flood" and "earthquake", or either "flood" or "earthquake". Current functionality requires a regular query to be specified in order for `lq` to return results. So, just include `q = ''` when executing Lucene queries (this is a known [issue](https://github.com/USGS-R/sbtools/issues/236) in `sbtools`).

``` r
# search by 2 keywords (AND)
hazard2and_data <- query_sb(query_list = list(q = '', lq = 'flood AND earthquake'), 
                            limit=200)
length(hazard2and_data)
```

    ## [1] 62

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

    ## [1] 158

### Using `query_sb_text`

`query_sb_text` returns a list of `sbitems` that match the title or description fields. Use it to search authors, station names, rivers, states, etc.

``` r
# search using a contributors name
contrib_results <- query_sb_text("Robert Hirsch")
sapply(contrib_results, function(item) item$title)
```

    ##  [1] "Input data and results of WRTDS models and seasonal rank-sum tests to determine trends in the quality of water in New Jersey streams, water years 1971-2011"                
    ##  [2] "Evaluation of stream nutrient trends in the Lake Erie drainage basin in the presence of changing patterns in climate, streamflow, land drainage, and agricultural practices"
    ##  [3] "Nitrate in the Mississippi River and its tributaries, 1980-2010: an update"                                                                                                 
    ##  [4] "Antecedent flow conditions and nitrate concentrations in the Mississippi River basin"                                                                                       
    ##  [5] "Decadal surface water quality trends under variable climate, land use, and hydrogeochemical setting in Iowa, USA"                                                           
    ##  [6] "Comparison of two regression-based approaches for determining nutrient and sediment fluxes and trends in the Chesapeake Bay watershed"                                      
    ##  [7] "Flood trends: Not higher but more often"                                                                                                                                    
    ##  [8] "Preface; Water quality of large U.S. rivers; results from the U.S. Geological Survey's National Stream Quality Accounting Network"                                          
    ##  [9] "Past, present, and future of water data delivery from the U.S. Geological Survey"                                                                                           
    ## [10] "On critiques of Stationarity is dead: Whither water management?"                                                                                                          
    ## [11] "U.S. stream flow measurement and data dissemination improve"                                                                                                                
    ## [12] "The stream-gaging program of the U.S. Geological Survey"                                                                                                                    
    ## [13] "Fragmented patterns of flood change across the United States"                                                                                                               
    ## [14] "A bootstrap method for estimating uncertainty of water quality trends"                                                                                                      
    ## [15] "Long-term changes in sediment and nutrient delivery from Conowingo Dam to Chesapeake Bay: Effects of reservoir sedimentation"                                               
    ## [16] "Large biases in regression-based constituent flux estimates: causes and diagnostic tools"                                                                                   
    ## [17] "Estimating probabilities of reservoir storage for the upper Delaware River basin"                                                                                           
    ## [18] "Trend analysis of weekly acid rain data, 1978-83"                                                                                                                           
    ## [19] "Spatial and temporal patterns of dissolved organic matter quantity and quality in the Mississippi River Basin, 19972013"                                                   
    ## [20] "User guide to Exploration and Graphics for RivEr Trends (EGRET) and dataRetrieval: R packages for hydrologic data"

``` r
# search using place of interest
park_results <- query_sb_text("Yellowstone")
sapply(park_results, function(item) item$title)
```

    ##  [1] "Spatial and temporal relations between fluvial and allacustrine Yellowstone cutthroat trout, Oncorhynchus clarki bouvieri, spawning in the Yellowstone River, outlet stream of Yellowstone Lake"
    ##  [2] "Conservation and Climate Adaptation Strategies for Yellowstone Cutthroat Trout"                                                                                                                 
    ##  [3] "Greater Yellowstone Study Area"                                                                                                                                                                 
    ##  [4] "DMP - FY 2013 - Conservation and Climate Adaptation Strategies for Yellowstone Cutthroat Trout"                                                                                                 
    ##  [5] "Evaluating management alternatives to mitigate the adverse effects of climate change on whitebark pine ecosystems in the Greater Yellowstone Ecosystem"                                         
    ##  [6] "Abronia ammophila (Yellowstone Sand Verbena)"                                                                                                                                                   
    ##  [7] "Animal migration amid shifting patterns of phenology and predation: lessons from a Yellowstone elk herd"                                                                                        
    ##  [8] "A multicriteria assessment of the irreplaceability and vulnerability of sites in the Greater Yellowstone Ecosystem"                                                                             
    ##  [9] "Yellowstone Park. The Mud Geyser on Yellowstone River, north of Yellowstone Lake. Wyoming. 1921."                                                                                               
    ## [10] "Surficial geologic map of the west Yellowstone Quadrangle, Yellowstone National Park and adjoining area, Montana, Wyoming, and Idaho"                                                           
    ## [11] "Mapping the last frontier in Yellowstone National Park: Yellowstone Lake"                                                                                                                       
    ## [12] "Oncorhynchus clarkii bouvieri (Yellowstone cutthroat trout)"                                                                                                                                    
    ## [13] "Abronia ammophila var. (Yellowstone Sand Verbena)"                                                                                                                                              
    ## [14] "Scenery of the Yellowstone. Lower canyon of the Yellowstone. Yellowstone National Park. Wyoming. 1871. (Stereoscopic view)"                                                                     
    ## [15] "Scenery of the Yellowstone. Lower canyon of the Yellowstone. Yellowstone National Park. Wyoming. 1871."                                                                                         
    ## [16] "Yellowstone National Park, Wyoming. Canyon walls of the Yellowstone River."                                                                                                                     
    ## [17] "Yellowstone National Park, Wyoming. Canyon walls of the Yellowstone River."                                                                                                                     
    ## [18] "Yellowstone National Park, Wyoming. East over Yellowstone Lake. West Thumb Yellowstone Lake."                                                                                                   
    ## [19] "Water-chemistry data for selected springs, geysers, and streams in Yellowstone National Park, Wyoming, 1999-2000."                                                                              
    ## [20] "Yellowstone Park. Near view of Upper Falls of Yellowstone River. Wyoming. 1921."

``` r
# search using a site location
loc_results <- query_sb_text("Embudo")
length(loc_results)
```

    ## [1] 17

``` r
sapply(loc_results, function(item) item$title)
```

    ##  [1] "Embudo, New Mexico, birthplace of systematic stream gaging"                                                                           
    ##  [2] "Rio Grande gauging station, Rio Grande River, Embudo, Rio Arriba County, New Mexico. Circa 1899."                                     
    ##  [3] "Interior of Rio Grande gauging station, Rio Grande River, Embudo, Rio Arriba County, New Mexico. Circa 1899."                         
    ##  [4] "The USGS at Embudo, New Mexico: 125 years of systematic streamgaging in the United States"                                            
    ##  [5] "Embudo camp. Rio Arriba County, New Mexico. 1888."                                                                                    
    ##  [6] "Hydrologic analysis of the Rio Grande Basin north of Embudo, New Mexico; Colorado and New Mexico"                                     
    ##  [7] "A shifting riftGeophysical insights into the evolution of Rio Grande rift margins and the Embudo transfer zone near Taos, New Mexico"
    ##  [8] "Geologic map and cross sections of the Embudo Fault Zone in the Southern Taos Valley, Taos County, New Mexico"                        
    ##  [9] "Low-flow water-quality and discharge data for lined channels in Northeast Albuquerque, New Mexico, 1990 to 1994"                      
    ## [10] "USGS reservoir and lake gage network: Elevation and volumetric contents data, and their uses"                                         
    ## [11] "Report of progress of stream measurements for the calendar year 1905, Part XI, Colorado River drainage above Yuma"                    
    ## [12] "Measuring streamflow in Virginia (2002 revision)"                                                                                     
    ## [13] "U.S. Geological Survey water-resources programs in New Mexico, FY 2015"                                                               
    ## [14] "Recent Improvements to the U.S. Geological Survey Streamgaging Program...from the National Streamflow Information Program"            
    ## [15] "Measuring streamflow in Virginia (1999 revision)"                                                                                     
    ## [16] "Summary of urban stormwater quality in Albuquerque, New Mexico, 2003-12"                                                              
    ## [17] "100 years of sedimentation study by the USGS"

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

<img src='../static/sbtools-discovery/unnamed-chunk-7-1.png'/ title='TODO'/>

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
sapply(recent_data, function(item) item$title)
```

    ##  [1] "US Topo"                                                                                   
    ##  [2] "Collection of Field Photographs from Alaska"                                               
    ##  [3] "National Elevation Dataset (NED) Alaska 2 arc-second"                                      
    ##  [4] "Multi-stressor Predictive Models of Invertebrate Condition in the Corn Belt, U.S.A."       
    ##  [5] "Topo Map Data"                                                                             
    ##  [6] "Landscape Capability for Virginia Rail, Version 3.1, Northeast U.S."                       
    ##  [7] "Connectivity in WA: Products of the Washington Wildlife Habitat Connectivity Working Group"
    ##  [8] "National Transportation Dataset (NTD)"                                                     
    ##  [9] "Terrestrial Core and Connector Network, CT River Watershed"                                
    ## [10] "USGS US Topo 7.5-minute map for Amesville, OH 2011"                                        
    ## [11] "USGS US Topo 7.5-minute map for Alfred, OH 2013"                                           
    ## [12] "USGS US Topo 7.5-minute map for Addison, OH-WV 2013"                                       
    ## [13] "USGS US Topo 7.5-minute map for Adamsville, OH 2010"                                       
    ## [14] "USGS US Topo 7.5-minute map for Akron East, OH 2010"                                       
    ## [15] "USGS US Topo 7.5-minute map for Alvordton, OH-MI 2013"                                     
    ## [16] "USGS US Topo 7.5-minute map for Albertville, WI 2010"                                      
    ## [17] "USGS US Topo 7.5-minute map for Bartlettsville, IN 2013"                                   
    ## [18] "USGS US Topo 7.5-minute map for Elmer, NJ 2011"                                            
    ## [19] "USGS US Topo 7.5-minute map for Briggsville, WI 2013"                                      
    ## [20] "USGS US Topo 7.5-minute map for Brillion, WI 2010"

``` r
# find data that's been created over the last year
oneyearago <- today - (365*24*3600) # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneyearago, date_type = "dateCreated")
sapply(recent_data, function(item) item$title)
```

    ##  [1] "USGS NED Original Product Resolution CA Sonoma 2013 bh soco 0074 TIFF 2017"             
    ##  [2] "USGS NED Original Product Resolution CA Sonoma 2013 bh soco 0051 TIFF 2017"             
    ##  [3] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2679 10 TIFF 2017"
    ##  [4] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2679 30 TIFF 2017"
    ##  [5] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2679 40 TIFF 2017"
    ##  [6] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2686 10 TIFF 2017"
    ##  [7] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2666 40 TIFF 2017"
    ##  [8] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2662 30 TIFF 2017"
    ##  [9] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2660 10 TIFF 2017"
    ## [10] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2664 40 TIFF 2017"
    ## [11] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2658 30 TIFF 2017"
    ## [12] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2669 30 TIFF 2017"
    ## [13] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2795 10 TIFF 2017"
    ## [14] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2795 30 TIFF 2017"
    ## [15] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2795 40 TIFF 2017"
    ## [16] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2796 20 TIFF 2017"
    ## [17] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2862 40 TIFF 2017"
    ## [18] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2791 10 TIFF 2017"
    ## [19] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2785 40 TIFF 2017"
    ## [20] "USGS NED Original Product Resolution VA Eastern-ShoreBAA 2015 DEM S23 2786 30 TIFF 2017"

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
    ##  [9] "Principal facts of gravity data in the southern San Luis Basin, northern New Mexico"                                                                                                               
    ## [10] "Airborne Geophysical Surveys over the Eastern Adirondacks, New York State"                                                                                                                         
    ## [11] "Mean of the Top Ten Percent of NDVI Values in the Yuma Proving Ground during Monsoon Season, 1986-2011"                                                                                            
    ## [12] "PaRadonGW.shp - Evaluation of Radon Occurrence in Groundwater from 16 Geologic Units in Pennsylvania, 19862015, with Application to Potential Radon Exposure from Groundwater and Indoor Air"     
    ## [13] "Boat-based water-surface elevation surveys along the upper Willamette River, Oregon, in March, 2015"                                                                                               
    ## [14] "Sediment Texture and Geomorphology of the Sea Floor from Fenwick Island, Maryland to Fisherman's Island, Virginia"                                                                                 
    ## [15] "Point locations for earthquakes M2.5 and greater in a two-year aftershock sequence resulting from the HayWired scenario earthquake mainshock (4/18/2018) in the San Francisco Bay area, California"
    ## [16] "Data for a Comprehensive Survey of Fault Zones, Breccias, and Fractures in and Flanking the Eastern Española Basin, Rio Grande Rift, New Mexico"                                                   
    ## [17] "Bathymetry and Capacity of Shawnee Reservoir, Oklahoma, 2016"                                                                                                                                      
    ## [18] "Direct-push sediment cores, resistivity profiles, and depth-averaged resistivity collected for Platte River Recovery and Implementation Program in Phelps County, Nebraska"                        
    ## [19] "Carbonate geochemistry dataset of the soil and an underlying cave in the Ozark Plateaus, central United States"                                                                                    
    ## [20] "Streamflow and fish community diversity data for use in developing ecological limit functions for the Cumberland Plateau, northeastern Middle Tennessee and southwestern Kentucky, 2016"

``` r
# find raster data
sbraster <- query_sb_datatype("Raster")
sapply(sbraster, function(item) item$title)
```

    ##  [1] "Modified Land Cover Raster for the Upper Oconee Watershed"                                                                                         
    ##  [2] "Digital elevation model of Little Holland Tract, Sacramento-San Joaquin Delta, California, 2015"                                                   
    ##  [3] "Seafloor character--Offshore Pigeon Point, California"                                                                                             
    ##  [4] "2010 UMRS Color Infrared Aerial Photo Mosaic - Illinois River, LaGrange Pool South"                                                                
    ##  [5] "2010 UMRS Color Infrared Aerial Photo Mosaic - Mississippi River, Pool 06"                                                                         
    ##  [6] "Vegetation data for 1970-1999, 2035-2064, and 2070-2099 for 59 vegetation types"                                                                   
    ##  [7] "Ecologically-relevant landforms for Southern Rockies LCC"                                                                                          
    ##  [8] "Multivariate Adaptive Constructed Analogs (MACA) CMIP5 Statistically Downscaled Data for Coterminous USA"                                          
    ##  [9] "Backscatter [USGS07]--Offshore of Gaviota Map Area, California"                                                                                    
    ## [10] "Sediment Thickness--Pigeon Point to Monterey, California"                                                                                          
    ## [11] "Seafloor character--Offshore of Point Conception Map Area, California"                                                                             
    ## [12] "Trout Unlimited-Coldwater Fisheries Data"                                                                                                          
    ## [13] "Coal Mines"                                                                                                                                        
    ## [14] "Condition Index - Aquatic - Focal Species"                                                                                                         
    ## [15] "Vhg: terrestrially-defined vulnerability, biome velocity for Great Northern LCC"                                                                   
    ## [16] "Vtw: hydrologically-defined vulnerability, temperature change for Great Northern LCC"                                                              
    ## [17] "North American vegetation model data for land-use planning in a changing climate:"                                                                 
    ## [18] "Bathymetry hillshade--Offshore of Point Conception Map Area, California"                                                                           
    ## [19] "Projected Future LOCA Statistical Downscaling (Localized Constructed Analogs) Statistically downscaled CMIP5 climate projections for North America"
    ## [20] "Bathymetry Hillshade [2m]--Offshore of Monterey Map Area, California"

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
