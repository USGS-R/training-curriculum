---
author: Lindsay R. Carr
date: 9999-10-31
slug: dataRetrieval-readWQP
title: dataRetrieval - readWQP
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 13
---
readWQP functions
-----------------

After discovering Water Quality Portal (WQP) data in the [data discovery section](/dataRetrieval-discovery), we can now read it in using the desired parameters. There are two functions to do this in `dataRetrieval`. Table 1 describes them below.

<!--html_preserve-->
<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="3" style="text-align: left;">
<caption>
Table 1. readWQP function definitions
</caption>
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Function
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Arguments
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readwqpdata">readWQPdata</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Most general WQP data import function. Users must define each parameter.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
..., querySummary, tz
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
<a href="#readwqpqw">readWQPqw</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
Used for querying by site numbers and parameter codes only.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
siteNumbers, parameterCd, startDate, endDate, tz, querySummary
</td>
</tr>
</tbody>
</table>
<!--/html_preserve-->

The main difference between these two functions is that `readWQPdata` is general and accepts any of the paremeters described in the [WQP Web Services Guide](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Submitting). In contrast, `readWQPqw` has five arguments and users can only use this if they know the site number(s) and parameter code(s) for which they want data.

The following are examples of how to use each of the readWQP family of functions. Don't forget to load the `dataRetrieval` library if you are in a new session.

1.  [readWQPdata, state, site type, and characteristic name](#readwqpdata-state)
2.  [readWQPdata, county and characteristic group](#readwqpdata-county)
3.  [readWQPdata, bbox, characteristic name, and start date](#readwqpdata-bbox)
4.  [readWQPqw](#readwqpqw)

### readWQPdata

The generic function used to pull Water Quality Portal data. This function is very flexible. You can specify any of the parameters from the [WQP Web Service Guide](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Submitting). To learn what the possible values for each, see the [table of domain values](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Domain). Follow along with the three examples below or see `?readWQPdata` for more information.

<a name="readwqpdata-state"></a>

**Phosphorus data in Wisconsin lakes for water year 2010**

``` r
# This takes about 3 minutes to complete.
WI_lake_phosphorus_2010 <- readWQPdata(statecode="WI", 
                                       siteType="Lake, Reservoir, Impoundment", 
                                       characteristicName="Phosphorus", 
                                       startDate="2009-10-01", endDate="2010-09-30")

# What columns are available?
names(WI_lake_phosphorus_2010)
```

    ##  [1] "OrganizationIdentifier"                           
    ##  [2] "OrganizationFormalName"                           
    ##  [3] "ActivityIdentifier"                               
    ##  [4] "ActivityTypeCode"                                 
    ##  [5] "ActivityMediaName"                                
    ##  [6] "ActivityMediaSubdivisionName"                     
    ##  [7] "ActivityStartDate"                                
    ##  [8] "ActivityStartTime.Time"                           
    ##  [9] "ActivityStartTime.TimeZoneCode"                   
    ## [10] "ActivityEndDate"                                  
    ## [11] "ActivityEndTime.Time"                             
    ## [12] "ActivityEndTime.TimeZoneCode"                     
    ## [13] "ActivityDepthHeightMeasure.MeasureValue"          
    ## [14] "ActivityDepthHeightMeasure.MeasureUnitCode"       
    ## [15] "ActivityDepthAltitudeReferencePointText"          
    ## [16] "ActivityTopDepthHeightMeasure.MeasureValue"       
    ## [17] "ActivityTopDepthHeightMeasure.MeasureUnitCode"    
    ## [18] "ActivityBottomDepthHeightMeasure.MeasureValue"    
    ## [19] "ActivityBottomDepthHeightMeasure.MeasureUnitCode" 
    ## [20] "ProjectIdentifier"                                
    ## [21] "ActivityConductingOrganizationText"               
    ## [22] "MonitoringLocationIdentifier"                     
    ## [23] "ActivityCommentText"                              
    ## [24] "SampleAquifer"                                    
    ## [25] "HydrologicCondition"                              
    ## [26] "HydrologicEvent"                                  
    ## [27] "SampleCollectionMethod.MethodIdentifier"          
    ## [28] "SampleCollectionMethod.MethodIdentifierContext"   
    ## [29] "SampleCollectionMethod.MethodName"                
    ## [30] "SampleCollectionEquipmentName"                    
    ## [31] "ResultDetectionConditionText"                     
    ## [32] "CharacteristicName"                               
    ## [33] "ResultSampleFractionText"                         
    ## [34] "ResultMeasureValue"                               
    ## [35] "ResultMeasure.MeasureUnitCode"                    
    ## [36] "MeasureQualifierCode"                             
    ## [37] "ResultStatusIdentifier"                           
    ## [38] "StatisticalBaseCode"                              
    ## [39] "ResultValueTypeName"                              
    ## [40] "ResultWeightBasisText"                            
    ## [41] "ResultTimeBasisText"                              
    ## [42] "ResultTemperatureBasisText"                       
    ## [43] "ResultParticleSizeBasisText"                      
    ## [44] "PrecisionValue"                                   
    ## [45] "ResultCommentText"                                
    ## [46] "USGSPCode"                                        
    ## [47] "ResultDepthHeightMeasure.MeasureValue"            
    ## [48] "ResultDepthHeightMeasure.MeasureUnitCode"         
    ## [49] "ResultDepthAltitudeReferencePointText"            
    ## [50] "SubjectTaxonomicName"                             
    ## [51] "SampleTissueAnatomyName"                          
    ## [52] "ResultAnalyticalMethod.MethodIdentifier"          
    ## [53] "ResultAnalyticalMethod.MethodIdentifierContext"   
    ## [54] "ResultAnalyticalMethod.MethodName"                
    ## [55] "MethodDescriptionText"                            
    ## [56] "LaboratoryName"                                   
    ## [57] "AnalysisStartDate"                                
    ## [58] "ResultLaboratoryCommentText"                      
    ## [59] "DetectionQuantitationLimitTypeName"               
    ## [60] "DetectionQuantitationLimitMeasure.MeasureValue"   
    ## [61] "DetectionQuantitationLimitMeasure.MeasureUnitCode"
    ## [62] "PreparationStartDate"                             
    ## [63] "ProviderName"                                     
    ## [64] "ActivityStartDateTime"                            
    ## [65] "ActivityEndDateTime"

``` r
#How much data is returned?
nrow(WI_lake_phosphorus_2010)
```

    ## [1] 3340

<a name="readwqpdata-county"></a>

**All nutrient data in Napa County, California**

``` r
# Use empty character strings to specify that you want the historic record.
# This takes about 3 minutes to run.
Napa_lake_nutrients_Aug2010 <- readWQPdata(statecode="CA", countycode="055", 
                                           characteristicType="Nutrient")

#How much data is returned?
nrow(Napa_lake_nutrients_Aug2010)
```

    ## [1] 4634

<a name="readwqpdata-bbox"></a>

**Everglades water temperature data since 2016**

``` r
# Bounding box defined by a vector of Western-most longitude, Southern-most latitude, 
# Eastern-most longitude, and Northern-most longitude.
# This takes about 3 minutes to run.
Everglades_temp_2016_present <- readWQPdata(bBox=c(-81.70, 25.08, -80.30, 26.51),  
                                            characteristicName="Temperature, water",
                                            startDate="2016-01-01")

#How much data is returned?
nrow(Everglades_temp_2016_present)
```

    ## [1] 1074

### readWQPqw

This function has a limited number of arguments - it can only be used for pulling WQP data by site number and parameter code. By default, dates are set to pull the entire record available. When specifying USGS sites as `siteNumbers` to `readWQP` functions, precede the number with "USGS-". See the example below or `?readWQPqw` for more information.

<a name="readwqpqw"></a>

**Dissolved oxygen data since 2010 for 2 South Carolina USGS sites**

``` r
# Using a few USGS sites, get dissolved oxygen data
# This takes ~ 30 seconds to complete.
SC_do_data_since2010 <- readWQPqw(siteNumbers = c("USGS-02146110", "USGS-325427080014600"),
                                  parameterCd = "00300", startDate = "2010-01-01")

# How much data was returned?
nrow(SC_do_data_since2010)
```

    ## [1] 20

``` r
# What are the DO values and the dates the sample was collected?
head(SC_do_data_since2010[, c("ResultMeasureValue", "ActivityStartDate")])
```

    ## # A tibble: 6 x 2
    ##   ResultMeasureValue ActivityStartDate
    ##                <dbl>            <date>
    ## 1                5.9        2010-04-08
    ## 2                5.8        2010-09-26
    ## 3                6.5        2011-11-28
    ## 4                6.3        2011-06-15
    ## 5                4.8        2011-09-06
    ## 6                5.0        2011-09-06

Attributes and metadata
-----------------------

Similar to the data frames returned from `readNWIS` functions, there are attributes (aka metadata) attached to the data. Use `attributes` to see all of them and `attr` to extract a particular attribute.

``` r
# What are the attributes available?
wqp_attributes <- attributes(Everglades_temp_2016_present)
names(wqp_attributes)
```

    ## [1] "class"        "row.names"    "names"        "siteInfo"    
    ## [5] "variableInfo" "url"          "queryTime"

``` r
# Look at the variableInfo attribute
head(attr(Everglades_temp_2016_present, "variableInfo"))
```

    ##   characteristicName parameterCd param_units valueType
    ## 1 Temperature, water       00010       deg C      <NA>
    ## 2 Temperature, water       00010       deg C      <NA>
    ## 3 Temperature, water       00010       deg C      <NA>
    ## 4 Temperature, water       00010       deg C      <NA>
    ## 5 Temperature, water       00010       deg C      <NA>
    ## 6 Temperature, water       00010       deg C      <NA>

Let's make a quick map to look at the stations that collected the Everglades data:

``` r
siteInfo <- attr(Everglades_temp_2016_present, "siteInfo")

library(maps)
map('state', regions='florida')
title(main="Everglade Sites")
points(x=siteInfo$dec_lon_va, 
       y=siteInfo$dec_lat_va)
# Add a rectangle to see where your original query bounding box in relation to sites
rect(-81.70, 25.08, -80.30, 26.51, col = NA, border = 'red')
```

<img src='../static/dataRetrieval-readWQP/unnamed-chunk-2-1.png'/ title='Map of NWIS Everglade sites'/ alt='A map of NWIS site locations in the Everglades'/>

You can now find and download Water Quality Portal data from R!
