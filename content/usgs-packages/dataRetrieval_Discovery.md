---
author: Lindsay R. Carr
date: 9999-11-30
slug: dataRetrieval-discovery
title: dataRetrieval - Data discovery
image: usgs-packages/static/img/dataRetrieval.svg
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 11
---

**The following material is IN DEVELOPMENT**

Before continuing with this lesson, you should make sure that the `dataRetrieval` package is installed and loaded. If you haven't recently updated, you could reinstall the package by running `install.packages('dataRetrieval')` or go to the "Update" button in the "Packages" tab in RStudio.

``` r
# load the dataRetrival package
library(dataRetrieval)
```

There is an overwhelming amount of data and information stored in the National Water Information System (NWIS). This lesson will attempt to give an overview of what you can access. If you need more detail on a subject or have a question that is not answered here, please visit the [NWIS help system](https://help.waterdata.usgs.gov/).

Data available
--------------

**Data types:** NWIS and WQP store a lot of water information. NWIS contains streamflow, peak flow, rating curves, groundwater, and water quality data. As can be assumed from the name, WQP only contains water quality data.

**Time series types:** the databases store water data at various reporting frequencies, and have different terms for these. There are 3 main types: unit value, daily value, and discrete. WQP only contains discrete data.

1.  *instantaneous value* (sometimes called *unit value*) data is reported at the frequency in which it was collected, and includes real-time data. It is generally available from 2007-present.
2.  *daily value* data aggregated to a daily statistic (e.g. mean daily, minimum daily, or maximum daily). This is available for streamflow, groundwater levels, and water quality sensors.
3.  *discrete* data collected at a specific point in time, and is not a continuous time series. This includes most water quality data, groundwater levels, rating curves, surface water measurements, and peak flow.

**Metadata types:** both NWIS and WQP contain metadata describing the site at which the data was collected (e.g. latitude, longitude, elevation, etc), and include information about the type of data being used (e.g. units, dissolved or not, collection method, etc).

Common NWIS function arguments
------------------------------

**`siteNumber`** All NWIS data are stored based on the geographic location of the equipment used to collected the data. These are known as streamgages and they take continuous timeseries measurements for a number of water quality and quantity parameters. Streamgages are identified based on an 8-digit (surface water) or 15-digit (groundwater) code. In `dataRetrieval`, we refer to this as the `siteNumber`. Any time you use a `siteNumber` in `dataRetrieval`, make sure it is a string and not numeric. Oftentimes, NWIS sites have leading zeroes which are dropped when treated as a numeric value.

**`parameterCd`** NWIS uses 5-digit codes to refer to specific data of interest called parameter codes, `parameterCd` in `dataRetrieval`. For example, you use the code '00060' to specify discharge data. If you'd like to explore the full list, see the [Parameter Groups Table](https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%). The package also has a built in parameter code table that you can use by executing `parameterCdFile` in your console.

**`service`** Identifier referring to the time series frequencies explained above, or the type of data that should be returned. For more information, visit the [Water Services website](https://waterservices.usgs.gov/rest/Site-Service.html#outputDataTypeCd).

-   instaneous = "iv"
-   daily values = "dv"
-   groundwater levels = "gwlevels"
-   water quality = "qw"
-   statistics = "stat"
-   site = "site"

**`startDate`** and **`endDate`** Strings in the format "YYYY-MM-DDTHH:SS:MM", either date or character class. The start and end date-times are inclusive.

**`stateCd`** Two character abbreviation for a US state or territory. Execute `state.abb` in the console to get a vector of US state abbreviations. Territories include:

-   AS (American Samoa)
-   GU (Guam)
-   MP (Northern Mariana Islands)
-   PR (Puerto Rico)
-   VI (U.S. Virgin Islands)

For more query parameters, visit [NWIS service documentation](https://waterservices.usgs.gov/rest/Site-Service.html#Service).

Discovering NWIS data
---------------------

In some cases, users might have specific sites and data that they are pulling with `dataRetrieval` but what if you wanted to know what data exists in the database before trying to download it? You can use the functions `whatNWISsites` and `whatNWISdata`. Another option is to download the data using `readNWISdata`, and see the first and last available dates of that data with the argument `seriesCatalogOutput=TRUE`.

### whatNWISsites

`whatNWISsites` will return a data.frame with site numbers that have available data matching your query parameters. From there, you can determine which sites to use to actually download data. This will only return requests for arguments that pertain to a site - you cannot use this function to query by dates, services, or stats. Those are specific to the data (use `whatNWISdata` instead). Note that you need a "major filter" in order for the query to work. "Major filters" include `siteNumber`, `stateCd`, `huc`, `bBox`, or `countyCd`.

In this example, let's find South Carolina stream sites that have temperature data. We specify the state, South Carolina, using the `stateCd` argument and South Carolina's two letter abbreviation, SC.

``` r
sites_sc <- whatNWISsites(stateCd="SC")
nrow(sites_sc)
```

    ## [1] 20070

This query returns all of the NWIS sites that are in South Carolina To be more specific, let's say we only want stream sites. This requires the `siteType` argument and the abbreviation "ST" for stream. See other siteTypes [here](https://help.waterdata.usgs.gov/code/site_tp_query?fmt=html).

``` r
sites_sc_stream <- whatNWISsites(stateCd="SC", siteType="ST")
nrow(sites_sc_stream)
```

    ## [1] 633

We can now see that out of the 20,070 NWIS sites in South Carolina only 3% are stream sites. Let's add one more query item to this - parameter. We only want to use sites that have temperature data (USGS parameter code is 00010). Use the argument `parameterCd` and enter the code as a character string, otherwise leading zeroes will be dropped.

``` r
sites_sc_stream_temp <- whatNWISsites(stateCd="SC", siteType="ST",
                                      parameterCd="00010")
nrow(sites_sc_stream_temp)
```

    ## [1] 300

We are now down to just 300 sites, much less than our original 20,070. To actually download this data, you can query using our three arguments, `stateCd` + `siteType` + `parameterCd`, or by the site numbers from the `sites_sc_stream_temp` data.frame using `unique(sites_sc_stream_temp[['site_no']])`. Downloading NWIS data will be covered in the next section, [readNWISdata](/usgs-packages/dataRetrieval-readNWIS).

The `whatNWISsites` function can also be very useful for making quick maps with site locations, see the columns `dec_lat_va` and `dec_long_va` (decimal latitude and longitude value). For instance,

``` r
# SC stream temperature sites
library(maps)
map('state', regions='south carolina')
title(main="South Carolina Stream Temp Sites")
points(x=sites_sc_stream_temp$dec_long_va, 
       y=sites_sc_stream_temp$dec_lat_va)
```

<img src='../static/dataRetrieval-discovery/sc_streamtemp_sites_map-1.png'/ title='Map of South Carolina stream temp sites'/ alt='Geographic locations of NWIS South Carolina stream sites with temperature data'/>

You can also quickly compare the amount of data between states:

``` r
# stream temperature data in SC vs WV
sites_wv_stream_temp <- whatNWISsites(stateCd="WV", siteType="ST",
                                      parameterCd="00010")
nrow(sites_sc_stream_temp)
```

    ## [1] 300

``` r
nrow(sites_wv_stream_temp)
```

    ## [1] 1598

Or compare the amount of data between site types:

``` r
# SC temperature data in streams vs lakes
sites_sc_lake_temp <- whatNWISsites(stateCd="SC", siteType="LK",
                                      parameterCd="00010")
nrow(sites_sc_stream_temp)
```

    ## [1] 300

``` r
nrow(sites_sc_lake_temp)
```

    ## [1] 33

What if you wanted sites from multiple states? You need to separately query each state because `stateCd` can only be length 1. You can use for loops or the `apply` family of functions to accomplish this. The example here uses a `for` loop and the `dplyr` function, `bind_rows`. We will assume you know how to use these functions.

``` r
library(dplyr) #bind_rows is a dplyr function

# find South West US sites with stream temperature
# then add to the data frame
sites_sw_stream_temp <- data.frame()
for(i in c("CA", "AZ", "NM", "NV")){
  state_sites <- whatNWISsites(stateCd=i, siteType="ST", parameterCd="00010")
  sites_sw_stream_temp <- bind_rows(sites_sw_stream_temp, state_sites)
}

nrow(sites_sw_stream_temp)
```

    ## [1] 4860

### whatNWISdata

`whatNWISdata` will return a data.frame specifying the types of data available for a specified site(s) that fits your querying criteria. You can add queries by the data service, USGS parameter code, or statistics code. Continuing with the South Carolina temperature data example from the `whatNWISsites` section, let's look for the mean daily stream temperature. Since you cannot query `whatNWISdata` using `siteType` or `stateCd`, let's use the site numbers from the previous lesson to specify South Carolina stream sites. You will need to specify the parameter again since the sites likely collect more than one parameter.

``` r
# Average daily SC stream temperature data
data_sc_stream_temp_avg <- whatNWISdata(
  siteNumbers = unique(sites_sc_stream_temp[['site_no']]),
  parameterCd="00010",
  service="dv",
  statCd="00003")
nrow(data_sc_stream_temp_avg)
```

    ## [1] 90

In some queries, you might notice an error that says "Too Long". This generally happens when you specify too many site numbers at once, which makes the web service URL too long. If this happens, try shortening the number of sites you are querying at a time and append all results at the end (similar to how we queried each state separately in the `whatNWISsites` example). You could also use a different major filter (bounding box, state, huc) that would give a shorter list to include in your query URL.

The data returned from this query can give you information about the data available for each site including, date of first and last record (`begin_date`, `end_date`), number of records (`count_nu`), site altitude (`alt_va`), corresponding hydrologic unit code (`huc_cd`), and parameter units (`parameter_units`). These columns allow even more specification of data requirements before actually downloading the data.

To illustrate this, let's apply an additional filter to these data using the `filter` function from `dplyr`. Imagine that the trend analysis you are conducting requires a minimum of 300 records and the most recent data needs to be no earlier than 1975.

``` r
# Useable average daily SC stream temperature data
library(dplyr)
data_sc_stream_temp_avg_applicable <- data_sc_stream_temp_avg %>% 
  filter(count_nu >= 300, end_date >= "1975-01-01")
nrow(data_sc_stream_temp_avg_applicable)
```

    ## [1] 87

This means you would have 87 of sites to work with for your study.

Common WQP function arguments
-----------------------------

**`countrycode`**, **`statecode`**, and **`countycode`** These geopolitical filters can be specified by a two letter abbreviation, state name, or Federal Information Processing Standard (FIPS) code. If you are using the FIPS code for a state or county, it must be preceded by the FIPS code of the larger geopolitical filter. For example, the FIPS code for the United States is `US`, and the FIPS code for South Carolina is `45`. When querying with the statecode, I would enter `statecode="US:45"`. The same rule extends to county FIPS. You can reference the `dataRetrieval` datasets `stateCd` and `countyCd`for the abbreviation, name, or FIPS code of states and counties. Countries need to be specified with their two-letter FIPS code.

**`siteType`** Specify the hydrologic location the sample was taken, e.g. streams, lakes, groundwater sources. These should be listed as a string. Available types can be found [here](https://www.waterqualitydata.us/Codes/Sitetype?mimeType=xml).

**`organization`** The ID of the reporting organization. All USGS science centers are written "USGS-" and then the two-letter state abbrevation. For example, the Wisconsin Water Science Center would be written "USGS-WI". For all available organization IDs, please see [this list of org ids](https://www.waterqualitydata.us/Codes/Organization?mimeType=xml). The id is listed in the "value" field, but they are accompanied by the organization name in the "desc" (description) field. **`siteid`** This is the unique identification number associated with a data collection station. Site IDs for the same location may differ depending on the reporting organization. The site ID string is written as the agency code then the site number separated by a hyphen. For example, the USGS site 01594440 would be written as "USGS-01594440".

**`characteristicName`** and **`characteristicType`** Unlike NWIS, WQP does not have codes for each parameter. Instead, you need to search based on the name of the water quality constituent (referred to as `characteristicName` in `dataRetrieval`) or a group of parameters (`characteristicType` in `dataRetrieval`). For example, "Nitrate" is a `characteristicName` and "Nutrient" is the `characteristicType` that it fits into. For a complete list of water quality types and names, see [characteristicType list](https://www.waterqualitydata.us/Codes/Characteristictype?mimeType=xml) and [characteristicName list](https://www.waterqualitydata.us/Codes/Characteristicname?mimeType=xml).

**`startDate`** and **`endDate`** Arguments specifying the beginning and ending of the period of record you are interested in. For the `dataRetrieval` functions, these can be a date or character class in the form YYYY-MM-DD. For example, `startDate = as.Date("2010-01-01")` or `startDate = "2010-01-01"` could both be your input arguments.

Discovering WQP data
--------------------

WQP has millions of records, and if you aren't careful, your query could take hours because of the amount of data that met your criteria. To avoid this, you can query just for the number of records and number of sites that meet your criteria using the argument `querySummary=TRUE` in the function, `readWQPdata`. This argument is also available for `readWQPqw`. See the [lesson on downloading WQP data](/usgs-packages/readWQP) to learn more about getting data. You can also use `whatWQPsites` to get the site information that matches your criteria.

Let's follow a similar pattern to NWIS data discovery sections and explore available stream temperature data in South Carolina.

### readWQPdata + querySummary

`readWQPdata` is the function used to actually download WQP data. In this application, we are just querying for a count of sites and results that match our criteria. Since WQP expect state and county codes as their FIPS code, you will need to use the string "US:45" for South Carolina.

``` r
wqpcounts_sc <- readWQPdata(statecode="US:45", querySummary = TRUE)
names(wqpcounts_sc)
```

    ##  [1] "date"                      "content-disposition"      
    ##  [3] "total-site-count"          "biodata-site-count"       
    ##  [5] "nwis-site-count"           "storet-site-count"        
    ##  [7] "total-activity-count"      "biodata-activity-count"   
    ##  [9] "nwis-activity-count"       "storet-activity-count"    
    ## [11] "total-result-count"        "biodata-result-count"     
    ## [13] "nwis-result-count"         "storet-result-count"      
    ## [15] "content-type"              "strict-transport-security"

This returns a list with 16 different items, including total number of sites, breakdown of the number of sites by source (BioData, NWIS, STORET), total number of records, and breakdown of records count by source. Let's just look at total number of sites and total number of records.

``` r
wqpcounts_sc[['total-site-count']]
```

    ## [1] 6831

``` r
wqpcounts_sc[['total-result-count']]
```

    ## [1] 3427562

This doesn't provide any information about the sites, just the total number. I know that with 3,427,562 results, I will want to add more criteria before trying to download. Let's continue to add query parameters before moving to `whatWQPsites`.

``` r
# specify that you only want data from streams
wqpcounts_sc_stream <- readWQPdata(statecode="US:45", siteType="Stream",
                                  querySummary = TRUE)
wqpcounts_sc_stream[['total-site-count']]
```

    ## [1] 1944

``` r
wqpcounts_sc_stream[['total-result-count']]
```

    ## [1] 1795130

1,795,130 results are still a lot to download. Let's add more levels of criteria:

``` r
# specify that you want water temperature data and it should be from 1975 or later
wqpcounts_sc_stream_temp <- readWQPdata(statecode="US:45", siteType="Stream",
                                       characteristicName="Temperature, water",
                                       startDate="1975-01-01",
                                       querySummary = TRUE)
wqpcounts_sc_stream_temp[['total-site-count']]
```

    ## [1] 1413

``` r
wqpcounts_sc_stream_temp[['total-result-count']]
```

    ## [1] 152023

152,023 is little more manageble. We can also easily compare avilable stream temperature and lake temperature data.

``` r
wqpcounts_sc_lake_temp <- readWQPdata(statecode="US:45", 
                                      siteType="Lake, Reservoir, Impoundment",
                                      characteristicName="Temperature, water",
                                      startDate="1975-01-01",
                                      querySummary = TRUE)
# comparing site counts
wqpcounts_sc_stream_temp[['total-site-count']]
```

    ## [1] 1413

``` r
wqpcounts_sc_lake_temp[['total-site-count']]
```

    ## [1] 577

``` r
# comparing result counts
wqpcounts_sc_stream_temp[['total-result-count']]
```

    ## [1] 152023

``` r
wqpcounts_sc_lake_temp[['total-result-count']]
```

    ## [1] 45299

From these query results, it looks like South Carolina has much more stream data than it does lake data.

Now, let's try our South Carolina stream temperature query with `whatWQPsites` and see if we can narrow the results at all.

### whatWQPsites

`whatWQPsites` works similarly to `whatNWISsites` in that it gives back site information that matches your search criteria. Unlike `whatNWISsites`, you can use any of the regular WQP web service arguments here. We are going to use `whatWQPsites` with the final criteria of the last query summary call - state, site type, parameter, and the earliest start date. This should return the same amount of sites as the last `readWQPdata` query did, 1,413.

``` r
# Getting the number of sites and results for stream 
# temperature measurements in South Carolina after 1975.
wqpsites_sc_stream_temp <- whatWQPsites(statecode="US:45", siteType="Stream",
                                       characteristicName="Temperature, water",
                                       startDate="1975-01-01")
# number of sites
nrow(wqpsites_sc_stream_temp)
```

    ## [1] 1413

``` r
# names of available columns
names(wqpsites_sc_stream_temp)
```

    ##  [1] "OrganizationIdentifier"                         
    ##  [2] "OrganizationFormalName"                         
    ##  [3] "MonitoringLocationIdentifier"                   
    ##  [4] "MonitoringLocationName"                         
    ##  [5] "MonitoringLocationTypeName"                     
    ##  [6] "MonitoringLocationDescriptionText"              
    ##  [7] "HUCEightDigitCode"                              
    ##  [8] "DrainageAreaMeasure.MeasureValue"               
    ##  [9] "DrainageAreaMeasure.MeasureUnitCode"            
    ## [10] "ContributingDrainageAreaMeasure.MeasureValue"   
    ## [11] "ContributingDrainageAreaMeasure.MeasureUnitCode"
    ## [12] "LatitudeMeasure"                                
    ## [13] "LongitudeMeasure"                               
    ## [14] "SourceMapScaleNumeric"                          
    ## [15] "HorizontalAccuracyMeasure.MeasureValue"         
    ## [16] "HorizontalAccuracyMeasure.MeasureUnitCode"      
    ## [17] "HorizontalCollectionMethodName"                 
    ## [18] "HorizontalCoordinateReferenceSystemDatumName"   
    ## [19] "VerticalMeasure.MeasureValue"                   
    ## [20] "VerticalMeasure.MeasureUnitCode"                
    ## [21] "VerticalAccuracyMeasure.MeasureValue"           
    ## [22] "VerticalAccuracyMeasure.MeasureUnitCode"        
    ## [23] "VerticalCollectionMethodName"                   
    ## [24] "VerticalCoordinateReferenceSystemDatumName"     
    ## [25] "CountryCode"                                    
    ## [26] "StateCode"                                      
    ## [27] "CountyCode"                                     
    ## [28] "AquiferName"                                    
    ## [29] "FormationTypeText"                              
    ## [30] "AquiferTypeName"                                
    ## [31] "ConstructionDateText"                           
    ## [32] "WellDepthMeasure.MeasureValue"                  
    ## [33] "WellDepthMeasure.MeasureUnitCode"               
    ## [34] "WellHoleDepthMeasure.MeasureValue"              
    ## [35] "WellHoleDepthMeasure.MeasureUnitCode"           
    ## [36] "ProviderName"

Similar to what we did with the NWIS functions, we can filter the sites further using the available metadata in `wqpsites_sc_stream_temp`. We are going to imagine that for our study the sites must have an associated drainage area and cannot be below sea level. Using `dplyr::filter`:

``` r
# Filtering the number of sites and results for stream temperature 
# measurements in South Carolina after 1975 to also have an
# associated drainage area and collected above sea level.
wqpsites_sc_stream_temp_applicable <- wqpsites_sc_stream_temp %>% 
  filter(!is.na(DrainageAreaMeasure.MeasureValue),
         VerticalMeasure.MeasureValue > 0)

nrow(wqpsites_sc_stream_temp_applicable)
```

    ## [1] 71

This brings the count down to a much more manageable 71 sites. Now we are ready to download this data.
