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
    ##  [3] "Upper Rio Grande"                                                                                                                               
    ##  [4] "Acoustic Doppler current profiler velocity data collected during 2015 and 2016 in the Calumet Harbor, Illinois"                                 
    ##  [5] "Data for a Comprehensive Survey of Fault Zones, Breccias, and Fractures in and Flanking the Eastern Española Basin, Rio Grande Rift, New Mexico"
    ##  [6] "Magnetotelluric sounding locations, stations 1 to 22, Southern San Luis Valley, Colorado, 2006"                                                 
    ##  [7] "Pseudemys gorzugi (Rio Grande Cooter)"                                                                                                          
    ##  [8] "Notropis jemezanus (Rio Grande shiner)"                                                                                                         
    ##  [9] "Etheostoma grahami (Rio Grande darter)"                                                                                                         
    ## [10] "The Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                    
    ## [11] "View of the Rio Grande near Pole Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                   
    ## [12] "View on the Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                            
    ## [13] "The Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                    
    ## [14] "View of the Rio Grande, near Pole Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                                  
    ## [15] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874."                                                                             
    ## [16] "View on the Rio Grande, near Lost Trail Creek. Hinsdale County, Colorado. 1874. (Stereoscopic view)"                                            
    ## [17] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874. (Stereoscopic view)"                                                         
    ## [18] "Wagon Wheel Gap, Rio Grande River. Mineral County, Colorado. 1874. (Stereoscopic view)"                                                         
    ## [19] "The Rio Grande Del Norte, below Wagon Wheel Gap. Mineral County, Colorado. 1874."                                                               
    ## [20] "The Rio Grande Del Norte, below Wagon Wheel Gap. Mineral County, Colorado. 1874. (Stereoscopic view)"

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

<img src='../static/sbtools-discovery/query_sb_spatial-1.png'/ title='TODO'/>

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

    ##  [1] "Chemicals of Emerging Concern in Water and Bottom Sediment in the Great Lakes Basin, 2014 - Analytical Methods, Collection Methods,Quality-Assurance Analyses, and Data"
    ##  [2] "U.S. Geological Survey Repositories"                                                                                                                                    
    ##  [3] "Great Lakes Restoration Initiative"                                                                                                                                     
    ##  [4] "2015 Sample Data Release"                                                                                                                                               
    ##  [5] "Landsat Burned Area Essential Climate Variable products for the conterminous United States (1984 - 2015)"                                                               
    ##  [6] "Discovery of Two Biological Mechanisms for Acetylene Metabolism in a Single Organism"                                                                                   
    ##  [7] "Arsenic in Southeastern Carson Valley, Douglas County, Nevada - Evaluation of Existing Data"                                                                            
    ##  [8] "Data for Gulf Coast Vulnerability Assessment"                                                                                                                           
    ##  [9] "GIS Data and Tables Pertaining to the Agricultural Irrigated Land-Use Inventory for Escambia, Santa Rosa, and Okaloosa Counties in Florida, 2016"                       
    ## [10] "California State Wildlife Action Plan"                                                                                                                                  
    ## [11] "1994 Aerial Photo Mosaic Mississippi River Pool 08"                                                                                                                     
    ## [12] "Spatial and temporal dynamics of suspended particle characteristics and composition in Navigation Pool 19 of the Upper Mississippi River"                               
    ## [13] "Wind and Wildlife Assessment Tool"                                                                                                                                      
    ## [14] "Collection of Geologic Paper Reports from Iowa"                                                                                                                         
    ## [15] "Collection of Geothermal Resources of Nevada from NV"                                                                                                                   
    ## [16] "Developing a Management Model of the Effects of Future Climate Change on Species: A Tool for the Landscape Conservation Cooperatives"                                   
    ## [17] "Sea Level Rise Vulnerability Assessment for San Juan County, Washington"                                                                                                
    ## [18] "Sevilleta GIS Vector Datasets"                                                                                                                                          
    ## [19] "LANDFIRE Data Viewer"                                                                                                                                                   
    ## [20] "Collection of Rock cuttings for Indiana"

``` r
# find data that's been created over the last year
oneyearago <- today - as.difftime(365, units='days') # days * hrs/day * secs/hr
recent_data <- query_sb_date(start = today, end = oneyearago, date_type = "dateCreated")
sapply(recent_data, function(item) item$title)
```

    ##  [1] "Spatial and temporal dynamics of suspended particle characteristics and composition in Navigation Pool 19 of the Upper Mississippi River"
    ##  [2] "Population dynamics of the Laysan and other albatrosses in the North Pacific"                                                            
    ##  [3] "Identification of polar bear den habitat in northern Alaska"                                                                             
    ##  [4] "Polar bear research in Alaska"                                                                                                           
    ##  [5] "Polar bear management in Alaska 1997-2000"                                                                                               
    ##  [6] "Seaducks: A time for action"                                                                                                             
    ##  [7] "Techniques of processing Landsat MSS imagery to map surface rock and mineral alteration on the Alaska Peninsula"                         
    ##  [8] "GRSG Breeding Habitat Probability"                                                                                                       
    ##  [9] "Performance and utility of satellite telemetry during field studies of free-ranging polar bears in Alaska"                               
    ## [10] "Resilience and Resistance"                                                                                                               
    ## [11] "Temperature - 30-year Normal (celsius)"                                                                                                  
    ## [12] "hydrographs"                                                                                                                             
    ## [13] "Precipitation - 30-year Normal (cm)"

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
    ## [10] "North American vegetation model data for land-use planning in a changing climate:"                                                                 
    ## [11] "Bathymetry hillshade--Offshore of Point Conception Map Area, California"                                                                           
    ## [12] "Projected Future LOCA Statistical Downscaling (Localized Constructed Analogs) Statistically downscaled CMIP5 climate projections for North America"
    ## [13] "Bathymetry Hillshade [2m]--Offshore of Monterey Map Area, California"                                                                              
    ## [14] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T5 from 2003"                                                            
    ## [15] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T6 from 2006"                                                            
    ## [16] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P6 from 2006"                                                            
    ## [17] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland T4 from 14 July 1999"                                                    
    ## [18] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P11 from 18 July 1990"                                                   
    ## [19] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P1 from 1977"                                                            
    ## [20] "Digital Orthorectified Aerial Image of Cottonwood Lake Study Area Wetland P4 from 1977"

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

`query_sb` is the "catch-all" function for querying ScienceBase from R. It only takes one argument for specifying query parameters, `query_list`. This is an R list with specific query parameters as the list names and the user query string as the list values. See the `Description` section of the help file for all options (`?query_sb`).

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
    ##  [3] "Precipitation"                                                                                                                                      
    ##  [4] "Mean Annual Precipitation (MAP)"                                                                                                                    
    ##  [5] "Mean Summer (May to Sep) Precipitation (MSP)"                                                                                                       
    ##  [6] "Summer (Jun to Aug) Precipitation (PPTSM)"                                                                                                          
    ##  [7] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ##  [8] "Precipitation mm/year projections for years 2010-2080 RCP 8.5"                                                                                      
    ##  [9] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [10] "Precipitation - 30-year Normal (cm)"                                                                                                                
    ## [11] "Precipitation mm/year projections for years 2010-2080 RCP 4.5"                                                                                      
    ## [12] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [13] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [14] "Winter (Dec to Feb) Precipitation (PPTWT)"                                                                                                          
    ## [15] "Isoscapes of d18O and d2H reveal climatic forcings on Alaska and Yukon precipitation"                                                               
    ## [16] "Average, Standard and Projected Precipitation for Emissions Scenarios A2, A1B, and B1 for the Gulf of Mexico"                                       
    ## [17] "30 Year Mean Annual Precipitation 1960- 1990 PRISM"                                                                                                 
    ## [18] "Precipitation variability and primary productivity in water-limited ecosystems: how plants 'leverage' precipitation to 'finance' growth"            
    ## [19] "Climate change and precipitation - Consequences of more extreme precipitation regimes for terrestrial ecosystems"                                   
    ## [20] "A Numerical Study of the 1996 Saguenay Flood Cyclone: Effect of Assimilation of Precipitation Data on Quantitative Precipitation Forecasts"

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

    ##  [1] "Precipitation - 30-year Normal (cm)"                                                                                                                           
    ##  [2] "Chemistry, Microstructure, Petrology, and Diagenetic Model of Jurassic Dinosaur Bones, Dinosaur National Monument, Utah"                                       
    ##  [3] "Fire effects on small mammal communities in Dinosaur National Monument"                                                                                        
    ##  [4] "Geologic versus wildfire controls on hillslope processes and debris flow initiation in the Green River canyons of Dinosaur National Monument"                  
    ##  [5] "MAPS: Monitoring Avian Productivity and Survivorship"                                                                                                          
    ##  [6] "Global Average Annual Sum Precipitation (mm) for HADCM3 SRES B1 at a Â½ Degree Grid Resolution, 2070-2099"                                                     
    ##  [7] "Global Average Annual Sum Precipitation (mm) for HADCM3 SRES A1B at a Â½ Degree Grid Resolution, 2070-2099"                                                    
    ##  [8] "Global Average Annual Sum Precipitation (mm) for HADCM3 SRES A2 at a Â½ Degree Grid Resolution, 2070-2099"                                                     
    ##  [9] "Global Average Annual Sum Precipitation (mm) for CSIRO Mk3.0 SRES A1B at a Â½ Degree Grid Resolution (2070-2099)"                                              
    ## [10] "Global Average Annual Sum Precipitation (mm) for CSIRO Mk3.0 SRES A2 at a Â½ Degree Grid Resolution, 2070-2099"                                                
    ## [11] "Global Average Annual Sum Precipitation (mm) for CSIRO Mk3.0 SRES B1 at a Â½ Degree Grid Resolution (2070-2099)"                                               
    ## [12] "Global Average Annual Sum Precipitation (mm) for CRU TS 2.0 at a Â½ Degree Grid Resolution (1961-1990)"                                                        
    ## [13] "Global Averaged maximum precipitation 1979 - 1999 (20 year average)"                                                                                           
    ## [14] "Summer and winter drought in a cold desert ecosystem (Colorado Plateau) part I: effects on soil water and plant water uptake"                                  
    ## [15] "Water resources of part of Canyonlands National Park, southeastern Utah"                                                                                       
    ## [16] "Deuterium enriched irrigation indicates different forms of rain use in shrub/grass species of the Colorado Plateau"                                            
    ## [17] "Comparison of Ion-Exchange Resin Counterions in the Nutrient Measurement of Calcareous Soils: Implications for Correlative Studies of Plant-Soil Relationships"
    ## [18] "Dominant cold desert plants do not partition warm season precipitation by event size"                                                                          
    ## [19] "Exotic plant invasion alters nitrogen dynamics in an arid grassland"                                                                                           
    ## [20] "Interspecific Competition and Resource Pulse Utilization in a Cold Desert Community"

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

    ## [1] 159

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
