---
author: Lindsay R. Carr
date: 9999-10-31
slug: dataRetrieval-readWQP
title: dataRetrieval - readWQP
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 3
---
readWQP functions
-----------------

**The following material is IN DEVELOPMENT**

After discovering Water Quality Portal (WQP) data in the [data discovery section](/dataRetrieval-discovery), we can now read it in using the desired parameters. There are two functions to do this in `dataRetrieval`. Table 1 describes them below.

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="3" style="text-align: left;">
Table 1. readWQP function definitions
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

The main difference between these two functions is that `readWQPdata` is general and accepts any of the paremeters described in the [WQP Web Services Guide](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Submitting). In contrast, `readWQPqw` has five arguments and users can only use this if they know the site number(s) and parameter code(s) for which they want data.

The following are examples of how to use each of the readWQP family of functions. Don't forget to load the `dataRetrieval` library if you are in a new session.

1.  [readWQPdata, state, site type, and characteristic name](#readwqpdata-state)
2.  [readWQPdata, county and characteristic group](##readwqpdata-county)
3.  [readWQPdata, bbox, characteristic name, and start date](##readwqpdata-bbox)
4.  [readNWISqw](#readwqpqw)

### readWQPdata

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 2. readWQPdata argument definitions
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Argument
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
...
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
see for a complete list of options. A list of arguments can also be supplied.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
querySummary
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
logical to ONLY return the number of records and unique sites that will be returned from this query. This argument is not supported via the combined list from the argument
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character to set timezone attribute of dateTime. Default is "UTC", and converts the date times to UTC, properly accounting for daylight savings times based on the data's provided tz\_cd column. Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage", as well as the following which do not use daylight savings time: "America/Honolulu", "America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla". See also for more information on time zones.
</td>
</tr>
</tbody>
</table>
This function is very flexible. You can specify any of the parameters from the [WQP Web Service Guide](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Submitting). To learn what the possible values for each, see the [table of domain values](https://www.waterqualitydata.us/webservices_documentation/#WQPWebServicesGuide-Domain).

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

**All nutrient data in Napa County, California lakes**

``` r
# Use empty character strings to specify that you want the historic record.
# This takes about 3 minutes to run.
Napa_lake_nutrients_Aug2010 <- readWQPdata(statecode="CA", countycode="055", 
                                           characteristicType="Nutrient")

#How much data is returned?
nrow(Napa_lake_nutrients_Aug2010)
```

    ## [1] 4322

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

    ## [1] 1026

### readWQPqw

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 3. readWQPqw argument definitions
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Argument
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
siteNumbers
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character site number. This needs to include the full agency code prefix.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
vector of USGS 5-digit parameter code or characteristicNames. Leaving this blank will return all of the measured values during the specified time period. See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character starting date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the earliest possible record. Date arguments are always specified in local time.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character ending date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record. Date arguments are always specified in local time.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character to set timezone attribute of dateTime. Default is "UTC", and converts the date times to UTC, properly accounting for daylight savings times based on the data's provided tz\_cd column. Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage", as well as the following which do not use daylight savings time: "America/Honolulu", "America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla". See also for more information on time zones.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
querySummary
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
logical to look at number of records and unique sites that will be returned from this query.
</td>
</tr>
</tbody>
</table>
This function has a limited number of arguments - it can only be used for pulling WQP data by site number and parameter code. By default, dates are set to pull the entire record available. When specifying USGS sites as `siteNumbers` to `readWQP` functions, precede the number with "USGS-". See the example below.

<a name="readwqpqw"></a>

\*\* Dissolved oxygen data since 2010 for 2 South Carolina USGS sites \*\*

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

    ## # A tibble: 6 × 2
    ##   ResultMeasureValue ActivityStartDate
    ##                <dbl>            <date>
    ## 1                5.9        2010-04-08
    ## 2                5.8        2010-09-26
    ## 3                6.5        2011-11-28
    ## 4                4.8        2011-09-06
    ## 5                6.3        2011-06-15
    ## 6                5.0        2011-09-06

Attributes and metadata
-----------------------

Similar to the data frames returned from `readNWIS` functions, there are attributes (aka metadata) attached to the data. Use `attributes` to see all of them and `attr` to extract a particular attribute.

``` r
# This query takes about 30 seconds
data <- Everglades_temp_2016_present # fill in w/ example readWQPqw

# What are the attributes available?
wqp_attributes <- attributes(data)
names(wqp_attributes)
```

    ## [1] "class"        "row.names"    "names"        "siteInfo"    
    ## [5] "variableInfo" "url"          "queryTime"

``` r
# Look more closely at the site information
attr(data, "siteInfo")
```

    ##                                                  station_nm    agency_cd
    ## 1         TAMIAMI CANAL WEST END 1 MILE BRIDGE NR MIAMI, FL      USGS-FL
    ## 2               TAMIAMI CANAL AT 1 MILE BRIDGE NR MIAMI, FL      USGS-FL
    ## 3         TAMIAMI CANAL EAST END 1 MILE BRIDGE NR MIAMI, FL      USGS-FL
    ## 4                                                  MO  -199      USGS-FL
    ## 5        SWEETWATER STRAND AT LOOP RD. NR MONROE STATION FL      USGS-FL
    ## 6                    EAST SIDE CREEK NEAR LAKE INGRAHAM, FL      USGS-FL
    ## 7                   ALLIGATOR CREEK NEAR GARFIELD BIGHT, FL      USGS-FL
    ## 8                            OYSTER CREEK NEAR FLAMINGO, FL      USGS-FL
    ## 9                RAULERSON BROTHERS CANAL AT CAPE SABLE, FL      USGS-FL
    ## 10                            EAST CREEK NEAR HOMESTEAD, FL      USGS-FL
    ## 11                   CUTHBERT LAKE OUTLET NEAR FLAMINGO, FL      USGS-FL
    ## 12          WEST LAKE OUTLET TO LONG LAKE NEAR FLAMINGO, FL      USGS-FL
    ## 13                                                 G  -3764      USGS-FL
    ## 14                                                G  -3946D      USGS-FL
    ## 15                                                MO  - 215      USGS-FL
    ## 16             UPSTREAM BROAD RIVER NEAR EVERGLADES CITY FL      USGS-FL
    ## 17                                                 G  -3913      USGS-FL
    ## 18                                                 MO - 216      USGS-FL
    ## 19                   TAMIAMI CANAL AT S-12-D NEAR MIAMI, FL      USGS-FL
    ## 20                                                    C-111 21FLDADE_WQX
    ## 21                                             Biscayne Bay 21FLDADE_WQX
    ## 22                                             Biscayne Bay 21FLDADE_WQX
    ## 23                                             Biscayne Bay 21FLDADE_WQX
    ## 24                                             Biscayne Bay 21FLDADE_WQX
    ## 25                                             Biscayne Bay 21FLDADE_WQX
    ## 26                                             Biscayne Bay 21FLDADE_WQX
    ## 27                                         Biscayne Bay 101 21FLDADE_WQX
    ## 28                                  Black Creek Canal (C-1) 21FLDADE_WQX
    ## 29                                  Black Creek Canal (C-1) 21FLDADE_WQX
    ## 30                                  Black Creek Canal (C-1) 21FLDADE_WQX
    ## 31                                     Biscayne Canal (C-8) 21FLDADE_WQX
    ## 32                               Cutler Drain Canal (C-100) 21FLDADE_WQX
    ## 33                               Cutler Drain Canal (C-100) 21FLDADE_WQX
    ## 34                               Cutler Drain Canal (C-100) 21FLDADE_WQX
    ## 35                               Cutler Drain Canal (C-100) 21FLDADE_WQX
    ## 36                                 Coral Gables Canal (C-3) 21FLDADE_WQX
    ## 37                                       Florida City Canal 21FLDADE_WQX
    ## 38                                       Florida City Canal 21FLDADE_WQX
    ## 39                                             Goulds Canal 21FLDADE_WQX
    ## 40                                             Goulds Canal 21FLDADE_WQX
    ## 41                                                    L31E1 21FLDADE_WQX
    ## 42                                 Little River Canal (C-7) 21FLDADE_WQX
    ## 43                                           Military Canal 21FLDADE_WQX
    ## 44                                           Military Canal 21FLDADE_WQX
    ## 45                                           Military Canal 21FLDADE_WQX
    ## 46                                        Miami Canal (C-6) 21FLDADE_WQX
    ## 47                                      Mowry Canal (C-103) 21FLDADE_WQX
    ## 48                                      Mowry Canal (C-103) 21FLDADE_WQX
    ## 49                                      Mowry Canal (C-103) 21FLDADE_WQX
    ## 50                                      Mowry Canal (C-103) 21FLDADE_WQX
    ## 51                                              North Canal 21FLDADE_WQX
    ## 52                                  Princeton Canal (C-102) 21FLDADE_WQX
    ## 53                                  Princeton Canal (C-102) 21FLDADE_WQX
    ## 54                                  Princeton Canal (C-102) 21FLDADE_WQX
    ## 55                                  Princeton Canal (C-102) 21FLDADE_WQX
    ## 56                                  Snake Creek Canal (C-9) 21FLDADE_WQX
    ## 57                                      Snapper Creek (C-2) 21FLDADE_WQX
    ## 58                                      Tamiami Canal (C-4) 21FLDADE_WQX
    ## 59                                      Tamiami Canal (C-4) 21FLDADE_WQX
    ## 60                                               L28TIEBACK  21FLFTM_WQX
    ## 61                             3278P @ #4 South of Goodland  21FLFTM_WQX
    ## 62                            C-139 Annex @ Half Bridge Rd.  21FLFTM_WQX
    ## 63                                3298X West Lake at Center  21FLFTM_WQX
    ## 64                                    3298X Long Lake South  21FLFTM_WQX
    ## 65                                   3298 X Long Lake North  21FLFTM_WQX
    ## 66                                                 BARRNRVR   21FLGW_WQX
    ## 67                                                       S8   21FLGW_WQX
    ## 68                                                     BL03   21FLGW_WQX
    ## 69                                                  ARS-197   21FLGW_WQX
    ## 70                                Z5-CN-10003 UNNAMED CANAL   21FLGW_WQX
    ## 71                                Z5-CN-10004 UNNAMED CANAL   21FLGW_WQX
    ## 72                                Z5-CN-10007 UNNAMED CANAL   21FLGW_WQX
    ## 73                                Z5-CN-10011 UNNAMED CANAL   21FLGW_WQX
    ## 74                                Z5-CN-10012 UNNAMED CANAL   21FLGW_WQX
    ## 75                                Z5-CN-10014 UNNAMED CANAL   21FLGW_WQX
    ## 76                                Z5-CN-10016 UNNAMED CANAL   21FLGW_WQX
    ## 77                                Z6-CN-10004 UNNAMED CANAL   21FLGW_WQX
    ## 78                              Z6-CN-10005 HILLSBORO CANAL   21FLGW_WQX
    ## 79                                Z6-CN-10012 UNNAMED CANAL   21FLGW_WQX
    ## 80                        Z6-CN-10015 NORTH NEW RIVER CANAL   21FLGW_WQX
    ## 81                                Z6-CN-10016 UNNAMED CANAL   21FLGW_WQX
    ## 82                                Z6-CN-10017 UNNAMED CANAL   21FLGW_WQX
    ## 83           Florida City Canal at 117th ave and 344 street  21FLWPB_WQX
    ## 84                    BLACK CREEK @ SW97 AVE,SOUTH DADE CO.  21FLWPB_WQX
    ## 85             Snake Creek Canal (East) SF Canal Study C9-2  21FLWPB_WQX
    ## 86             Snake Creek Canal (West) SF Canal Study C9-1  21FLWPB_WQX
    ## 87                                      C-102 @ SW 248th St  21FLWPB_WQX
    ## 88                            C-103 N SW 288 ST & SW 142 AV  21FLWPB_WQX
    ## 89                                 MowryCan(C-103) @ 152 Av  21FLWPB_WQX
    ## 90                                       TamiamiCan@KromeAv  21FLWPB_WQX
    ## 91                    C-102 @ SW 248th St & South of bridge  21FLWPB_WQX
    ## 92                                  C-102N @SW 248th Street  21FLWPB_WQX
    ## 93                          C-1 Black Creek @ Old Cutler Rd  21FLWPB_WQX
    ## 94                                             L-67 @ SR 41  21FLWPB_WQX
    ## 95                    C-100/Cutler Drain (CD-02 Miami-Dade)  21FLWPB_WQX
    ## 96                    C-100/Cutler Drain (CD-05 Miami-Dade)  21FLWPB_WQX
    ## 97                    C-100/Cutler Drain (CD-06 Miami-Dade)  21FLWPB_WQX
    ## 98                    Florida City Canal (FC-09 Miami-Dade)  21FLWPB_WQX
    ## 99                    Florida City Canal (FC-15 Miami-Dade)  21FLWPB_WQX
    ## 100                     C-7 Little River (LR-10 Miami-Dade)  21FLWPB_WQX
    ## 101 North New River Canal (NNR-2 SF Canal Study/22 Broward)  21FLWPB_WQX
    ## 102                                             L-5 @ G-206  21FLWPB_WQX
    ## 103                             WCA1_L-7 NE of S6 structure  21FLWPB_WQX
    ## 104                                          WCA1 L39 Canal  21FLWPB_WQX
    ## 105                                             L-5 @ G-205  21FLWPB_WQX
    ## 106                                           WCA 2B @S-141  21FLWPB_WQX
    ## 107                                      WCA 3 L-67 @ S-151  21FLWPB_WQX
    ## 108                                     Cape Romano Complex  21FLWQA_WQX
    ## 109                                          Faka Union Bay  21FLWQA_WQX
    ## 110                                         Fakahatchee Bay  21FLWQA_WQX
    ## 111                                            Goodland Bay  21FLWQA_WQX
    ## 112                                 Middle Blackwater River  21FLWQA_WQX
    ## 113                                             Pumpkin Bay  21FLWQA_WQX
    ##                       site_no dec_lat_va dec_lon_va    hucCd
    ## 1               USGS-02289080   25.76139  -80.53667 03090202
    ## 2              USGS-022890825   25.76088  -80.52668     <NA>
    ## 3               USGS-02289085   25.76139  -80.51667 03090202
    ## 4            USGS-02290829502   25.46798  -80.85453 03090202
    ## 5               USGS-02290947   25.78857  -81.09992 03090204
    ## 6        USGS-250802081035500   25.13697  -81.06438 03090203
    ## 7        USGS-251032080473400   25.17556  -80.79278 03090202
    ## 8        USGS-251033080440800   25.17589  -80.73558 03090202
    ## 9        USGS-251115081075800   25.18765  -81.13278 03090203
    ## 10       USGS-251152080370900   25.19861  -80.61888 03090202
    ## 11       USGS-251154080471900   25.19836  -80.78867 03090202
    ## 12       USGS-251203080480600   25.20072  -80.80161 03090202
    ## 13       USGS-251241080385301   25.21000  -80.64778 03090202
    ## 14       USGS-252431080261001   25.40853  -80.43603 03090202
    ## 15       USGS-252820080505401   25.47222  -80.84833 03090202
    ## 16       USGS-253047080555600   25.50129  -80.93222 03090202
    ## 17       USGS-254155080243502   25.69886  -80.35975 03090202
    ## 18       USGS-254344081095101   25.72903  -81.16425 03090204
    ## 19       USGS-254543080405401   25.76232  -80.68145 03090202
    ## 20          21FLDADE_WQX-AR03   25.28901  -80.44306 03090206
    ## 21         21FLDADE_WQX-BB39A   25.52643  -80.30706 03090206
    ## 22          21FLDADE_WQX-BB47   25.33679  -80.32008 03090206
    ## 23          21FLDADE_WQX-BB50   25.22990  -80.37678 03090203
    ## 24          21FLDADE_WQX-BB51   25.25150  -80.41408 03090203
    ## 25          21FLDADE_WQX-BB52   25.56461  -80.30485 03090206
    ## 26          21FLDADE_WQX-BB53   25.50248  -80.33228 03090206
    ## 27       21FLDADE_WQX-BISC101   25.47833  -80.32083 03090206
    ## 28          21FLDADE_WQX-BL01   25.53604  -80.32527 03090206
    ## 29          21FLDADE_WQX-BL03   25.54905  -80.34814 03090206
    ## 30          21FLDADE_WQX-BL12   25.66102  -80.43061 03090206
    ## 31          21FLDADE_WQX-BS10   25.91874  -80.32450 03090206
    ## 32         21FLDADE_WQX-CD01A   25.61047  -80.30354 03090206
    ## 33          21FLDADE_WQX-CD02   25.61118  -80.30987 03090206
    ## 34          21FLDADE_WQX-CD05   25.62384  -80.34363 03090206
    ## 35          21FLDADE_WQX-CD09   25.66588  -80.40868 03090206
    ## 36          21FLDADE_WQX-CG07   25.74108  -80.31067 03090206
    ## 37          21FLDADE_WQX-FC03   25.44805  -80.36738 03090206
    ## 38          21FLDADE_WQX-FC15   25.44810  -80.46090 03090206
    ## 39          21FLDADE_WQX-GL02   25.53722  -80.33303 03090206
    ## 40          21FLDADE_WQX-GL03   25.53730  -80.34376 03090206
    ## 41         21FLDADE_WQX-L31E1   25.49265  -80.34677 03090206
    ## 42          21FLDADE_WQX-LR10   25.86956  -80.33872 03090206
    ## 43          21FLDADE_WQX-MI01   25.48936  -80.33814 03090206
    ## 44          21FLDADE_WQX-MI02   25.48936  -80.34734 03090206
    ## 45          21FLDADE_WQX-MI03   25.48946  -80.36355 03090206
    ## 46          21FLDADE_WQX-MR15   25.89598  -80.37943 03090206
    ## 47          21FLDADE_WQX-MW01   25.47079  -80.37401 03090206
    ## 48          21FLDADE_WQX-MW04   25.47129  -80.37928 03090206
    ## 49          21FLDADE_WQX-MW05   25.52144  -80.44355 03090206
    ## 50          21FLDADE_WQX-MW13   25.51749  -80.54258 03090206
    ## 51         21FLDADE_WQX-NO07A   25.46289  -80.40389 03090206
    ## 52          21FLDADE_WQX-PR01   25.51959  -80.33198 03090206
    ## 53          21FLDADE_WQX-PR03   25.51952  -80.36405 03090206
    ## 54         21FLDADE_WQX-PR04A   25.53697  -80.38960 03090206
    ## 55          21FLDADE_WQX-PR08   25.58707  -80.51122 03090206
    ## 56          21FLDADE_WQX-SK09   25.96423  -80.31109 03090206
    ## 57          21FLDADE_WQX-SP08   25.71548  -80.38297 03090206
    ## 58          21FLDADE_WQX-TM05   25.76254  -80.32030 03090206
    ## 59          21FLDADE_WQX-TM08   25.76178  -80.48108 03090206
    ## 60  21FLFTM_WQX-EVRGWC0113FTM   26.17176  -80.89410 03090202
    ## 61       21FLFTM_WQX-G1SD0037   25.92063  -81.64514 03090204
    ## 62       21FLFTM_WQX-G1SD0049   26.33125  -80.88174 03090202
    ## 63       21FLFTM_WQX-G5SD0044   25.20750  -80.82588 03090202
    ## 64       21FLFTM_WQX-G5SD0045   25.18927  -80.77948 03090202
    ## 65       21FLFTM_WQX-G5SD0050   25.19707  -80.79503 03090202
    ## 66            21FLGW_WQX-3494   25.95259  -81.35590 03090204
    ## 67            21FLGW_WQX-3558   26.32230  -80.77450 03090202
    ## 68            21FLGW_WQX-3571   25.54538  -80.34588 03090206
    ## 69           21FLGW_WQX-37739   25.28739  -80.44186 03090206
    ## 70           21FLGW_WQX-48941   26.17213  -80.86225 03090202
    ## 71           21FLGW_WQX-48942   26.32449  -81.34288 03090204
    ## 72           21FLGW_WQX-48944   26.43081  -81.04653 03090202
    ## 73           21FLGW_WQX-48948   26.34343  -80.78355 03090202
    ## 74           21FLGW_WQX-48949   26.24407  -81.65259 03090204
    ## 75           21FLGW_WQX-48951   25.98618  -80.83814 03090204
    ## 76           21FLGW_WQX-48953   26.16999  -81.67904 03090204
    ## 77           21FLGW_WQX-49264   26.06268  -80.37145 03090206
    ## 78           21FLGW_WQX-49265   26.42003  -80.40584 03090202
    ## 79           21FLGW_WQX-49270   26.31959  -80.76538 03090202
    ## 80           21FLGW_WQX-49273   26.24754  -80.47184 03090202
    ## 81           21FLGW_WQX-49274   25.66044  -80.49029 03090206
    ## 82           21FLGW_WQX-49275   26.35941  -80.65067 03090202
    ## 83       21FLWPB_WQX-28040076   25.44805  -80.37955 03090206
    ## 84       21FLWPB_WQX-28040402   25.54833  -80.34806 03090206
    ## 85       21FLWPB_WQX-G4SE0017   25.96422  -80.30922 03090206
    ## 86       21FLWPB_WQX-G4SE0019   25.95686  -80.43214 03090206
    ## 87       21FLWPB_WQX-G4SE0064   25.53655  -80.40475 03090206
    ## 88       21FLWPB_WQX-G4SE0065   25.49978  -80.41880 03090206
    ## 89       21FLWPB_WQX-G4SE0066   25.47450  -80.43583 03090206
    ## 90       21FLWPB_WQX-G4SE0068   25.76139  -80.48155 03090206
    ## 91       21FLWPB_WQX-G4SE0073   25.53473  -80.40413 03090206
    ## 92       21FLWPB_WQX-G4SE0077   25.53697  -80.38960 03090206
    ## 93       21FLWPB_WQX-G4SE0086   25.55928  -80.35923 03090206
    ## 94       21FLWPB_WQX-G4SE0087   25.76101  -80.49804 03090206
    ## 95       21FLWPB_WQX-G4SECD02   25.61055  -80.31007 03090206
    ## 96       21FLWPB_WQX-G4SECD05   25.62368  -80.34322 03090206
    ## 97       21FLWPB_WQX-G4SECD06   25.62967  -80.31791 03090206
    ## 98       21FLWPB_WQX-G4SEFC09   25.44792  -80.41191 03090206
    ## 99       21FLWPB_WQX-G4SEFC15   25.44789  -80.46086 03090206
    ## 100      21FLWPB_WQX-G4SELR10   25.86945  -80.33867 03090206
    ## 101      21FLWPB_WQX-G4SENNR2   26.11486  -80.31161 03090206
    ## 102      21FLWPB_WQX-G5SE0002   26.33331  -80.65269 03090202
    ## 103      21FLWPB_WQX-G5SE0018   26.47339  -80.44494 03090202
    ## 104      21FLWPB_WQX-G5SE0019   26.47048  -80.44500 03090202
    ## 105      21FLWPB_WQX-G5SE0032   26.33278  -80.71700 03090202
    ## 106      21FLWPB_WQX-G5SE0040   26.15052  -80.44226 03090202
    ## 107      21FLWPB_WQX-G5SE0041   26.01161  -80.50995 03090202
    ## 108      21FLWQA_WQX-G1SD0002   25.85250  -81.67530     <NA>
    ## 109      21FLWQA_WQX-G1SD0004   25.90050  -81.51590 03090204
    ## 110      21FLWQA_WQX-G1SD0005   25.89220  -81.47690 03090204
    ## 111      21FLWQA_WQX-G1SD0006   25.93230  -81.65480 03090204
    ## 112      21FLWQA_WQX-G1SD0008   25.93420  -81.59550 03090204
    ## 113      21FLWQA_WQX-G1SD0009   25.91410  -81.54040 03090204
    ##     OrganizationIdentifier
    ## 1                  USGS-FL
    ## 2                  USGS-FL
    ## 3                  USGS-FL
    ## 4                  USGS-FL
    ## 5                  USGS-FL
    ## 6                  USGS-FL
    ## 7                  USGS-FL
    ## 8                  USGS-FL
    ## 9                  USGS-FL
    ## 10                 USGS-FL
    ## 11                 USGS-FL
    ## 12                 USGS-FL
    ## 13                 USGS-FL
    ## 14                 USGS-FL
    ## 15                 USGS-FL
    ## 16                 USGS-FL
    ## 17                 USGS-FL
    ## 18                 USGS-FL
    ## 19                 USGS-FL
    ## 20            21FLDADE_WQX
    ## 21            21FLDADE_WQX
    ## 22            21FLDADE_WQX
    ## 23            21FLDADE_WQX
    ## 24            21FLDADE_WQX
    ## 25            21FLDADE_WQX
    ## 26            21FLDADE_WQX
    ## 27            21FLDADE_WQX
    ## 28            21FLDADE_WQX
    ## 29            21FLDADE_WQX
    ## 30            21FLDADE_WQX
    ## 31            21FLDADE_WQX
    ## 32            21FLDADE_WQX
    ## 33            21FLDADE_WQX
    ## 34            21FLDADE_WQX
    ## 35            21FLDADE_WQX
    ## 36            21FLDADE_WQX
    ## 37            21FLDADE_WQX
    ## 38            21FLDADE_WQX
    ## 39            21FLDADE_WQX
    ## 40            21FLDADE_WQX
    ## 41            21FLDADE_WQX
    ## 42            21FLDADE_WQX
    ## 43            21FLDADE_WQX
    ## 44            21FLDADE_WQX
    ## 45            21FLDADE_WQX
    ## 46            21FLDADE_WQX
    ## 47            21FLDADE_WQX
    ## 48            21FLDADE_WQX
    ## 49            21FLDADE_WQX
    ## 50            21FLDADE_WQX
    ## 51            21FLDADE_WQX
    ## 52            21FLDADE_WQX
    ## 53            21FLDADE_WQX
    ## 54            21FLDADE_WQX
    ## 55            21FLDADE_WQX
    ## 56            21FLDADE_WQX
    ## 57            21FLDADE_WQX
    ## 58            21FLDADE_WQX
    ## 59            21FLDADE_WQX
    ## 60             21FLFTM_WQX
    ## 61             21FLFTM_WQX
    ## 62             21FLFTM_WQX
    ## 63             21FLFTM_WQX
    ## 64             21FLFTM_WQX
    ## 65             21FLFTM_WQX
    ## 66              21FLGW_WQX
    ## 67              21FLGW_WQX
    ## 68              21FLGW_WQX
    ## 69              21FLGW_WQX
    ## 70              21FLGW_WQX
    ## 71              21FLGW_WQX
    ## 72              21FLGW_WQX
    ## 73              21FLGW_WQX
    ## 74              21FLGW_WQX
    ## 75              21FLGW_WQX
    ## 76              21FLGW_WQX
    ## 77              21FLGW_WQX
    ## 78              21FLGW_WQX
    ## 79              21FLGW_WQX
    ## 80              21FLGW_WQX
    ## 81              21FLGW_WQX
    ## 82              21FLGW_WQX
    ## 83             21FLWPB_WQX
    ## 84             21FLWPB_WQX
    ## 85             21FLWPB_WQX
    ## 86             21FLWPB_WQX
    ## 87             21FLWPB_WQX
    ## 88             21FLWPB_WQX
    ## 89             21FLWPB_WQX
    ## 90             21FLWPB_WQX
    ## 91             21FLWPB_WQX
    ## 92             21FLWPB_WQX
    ## 93             21FLWPB_WQX
    ## 94             21FLWPB_WQX
    ## 95             21FLWPB_WQX
    ## 96             21FLWPB_WQX
    ## 97             21FLWPB_WQX
    ## 98             21FLWPB_WQX
    ## 99             21FLWPB_WQX
    ## 100            21FLWPB_WQX
    ## 101            21FLWPB_WQX
    ## 102            21FLWPB_WQX
    ## 103            21FLWPB_WQX
    ## 104            21FLWPB_WQX
    ## 105            21FLWPB_WQX
    ## 106            21FLWPB_WQX
    ## 107            21FLWPB_WQX
    ## 108            21FLWQA_WQX
    ## 109            21FLWQA_WQX
    ## 110            21FLWQA_WQX
    ## 111            21FLWQA_WQX
    ## 112            21FLWQA_WQX
    ## 113            21FLWQA_WQX
    ##                                       OrganizationFormalName
    ## 1                          USGS Florida Water Science Center
    ## 2                          USGS Florida Water Science Center
    ## 3                          USGS Florida Water Science Center
    ## 4                          USGS Florida Water Science Center
    ## 5                          USGS Florida Water Science Center
    ## 6                          USGS Florida Water Science Center
    ## 7                          USGS Florida Water Science Center
    ## 8                          USGS Florida Water Science Center
    ## 9                          USGS Florida Water Science Center
    ## 10                         USGS Florida Water Science Center
    ## 11                         USGS Florida Water Science Center
    ## 12                         USGS Florida Water Science Center
    ## 13                         USGS Florida Water Science Center
    ## 14                         USGS Florida Water Science Center
    ## 15                         USGS Florida Water Science Center
    ## 16                         USGS Florida Water Science Center
    ## 17                         USGS Florida Water Science Center
    ## 18                         USGS Florida Water Science Center
    ## 19                         USGS Florida Water Science Center
    ## 20          Dade Environmental Resource Management (Florida)
    ## 21          Dade Environmental Resource Management (Florida)
    ## 22          Dade Environmental Resource Management (Florida)
    ## 23          Dade Environmental Resource Management (Florida)
    ## 24          Dade Environmental Resource Management (Florida)
    ## 25          Dade Environmental Resource Management (Florida)
    ## 26          Dade Environmental Resource Management (Florida)
    ## 27          Dade Environmental Resource Management (Florida)
    ## 28          Dade Environmental Resource Management (Florida)
    ## 29          Dade Environmental Resource Management (Florida)
    ## 30          Dade Environmental Resource Management (Florida)
    ## 31          Dade Environmental Resource Management (Florida)
    ## 32          Dade Environmental Resource Management (Florida)
    ## 33          Dade Environmental Resource Management (Florida)
    ## 34          Dade Environmental Resource Management (Florida)
    ## 35          Dade Environmental Resource Management (Florida)
    ## 36          Dade Environmental Resource Management (Florida)
    ## 37          Dade Environmental Resource Management (Florida)
    ## 38          Dade Environmental Resource Management (Florida)
    ## 39          Dade Environmental Resource Management (Florida)
    ## 40          Dade Environmental Resource Management (Florida)
    ## 41          Dade Environmental Resource Management (Florida)
    ## 42          Dade Environmental Resource Management (Florida)
    ## 43          Dade Environmental Resource Management (Florida)
    ## 44          Dade Environmental Resource Management (Florida)
    ## 45          Dade Environmental Resource Management (Florida)
    ## 46          Dade Environmental Resource Management (Florida)
    ## 47          Dade Environmental Resource Management (Florida)
    ## 48          Dade Environmental Resource Management (Florida)
    ## 49          Dade Environmental Resource Management (Florida)
    ## 50          Dade Environmental Resource Management (Florida)
    ## 51          Dade Environmental Resource Management (Florida)
    ## 52          Dade Environmental Resource Management (Florida)
    ## 53          Dade Environmental Resource Management (Florida)
    ## 54          Dade Environmental Resource Management (Florida)
    ## 55          Dade Environmental Resource Management (Florida)
    ## 56          Dade Environmental Resource Management (Florida)
    ## 57          Dade Environmental Resource Management (Florida)
    ## 58          Dade Environmental Resource Management (Florida)
    ## 59          Dade Environmental Resource Management (Florida)
    ## 60      FL Dept. of Environmental Protection, South District
    ## 61      FL Dept. of Environmental Protection, South District
    ## 62      FL Dept. of Environmental Protection, South District
    ## 63      FL Dept. of Environmental Protection, South District
    ## 64      FL Dept. of Environmental Protection, South District
    ## 65      FL Dept. of Environmental Protection, South District
    ## 66                      FL Dept. of Environmental Protection
    ## 67                      FL Dept. of Environmental Protection
    ## 68                      FL Dept. of Environmental Protection
    ## 69                      FL Dept. of Environmental Protection
    ## 70                      FL Dept. of Environmental Protection
    ## 71                      FL Dept. of Environmental Protection
    ## 72                      FL Dept. of Environmental Protection
    ## 73                      FL Dept. of Environmental Protection
    ## 74                      FL Dept. of Environmental Protection
    ## 75                      FL Dept. of Environmental Protection
    ## 76                      FL Dept. of Environmental Protection
    ## 77                      FL Dept. of Environmental Protection
    ## 78                      FL Dept. of Environmental Protection
    ## 79                      FL Dept. of Environmental Protection
    ## 80                      FL Dept. of Environmental Protection
    ## 81                      FL Dept. of Environmental Protection
    ## 82                      FL Dept. of Environmental Protection
    ## 83  FL Dept. of Environmental Protection, Southeast District
    ## 84  FL Dept. of Environmental Protection, Southeast District
    ## 85  FL Dept. of Environmental Protection, Southeast District
    ## 86  FL Dept. of Environmental Protection, Southeast District
    ## 87  FL Dept. of Environmental Protection, Southeast District
    ## 88  FL Dept. of Environmental Protection, Southeast District
    ## 89  FL Dept. of Environmental Protection, Southeast District
    ## 90  FL Dept. of Environmental Protection, Southeast District
    ## 91  FL Dept. of Environmental Protection, Southeast District
    ## 92  FL Dept. of Environmental Protection, Southeast District
    ## 93  FL Dept. of Environmental Protection, Southeast District
    ## 94  FL Dept. of Environmental Protection, Southeast District
    ## 95  FL Dept. of Environmental Protection, Southeast District
    ## 96  FL Dept. of Environmental Protection, Southeast District
    ## 97  FL Dept. of Environmental Protection, Southeast District
    ## 98  FL Dept. of Environmental Protection, Southeast District
    ## 99  FL Dept. of Environmental Protection, Southeast District
    ## 100 FL Dept. of Environmental Protection, Southeast District
    ## 101 FL Dept. of Environmental Protection, Southeast District
    ## 102 FL Dept. of Environmental Protection, Southeast District
    ## 103 FL Dept. of Environmental Protection, Southeast District
    ## 104 FL Dept. of Environmental Protection, Southeast District
    ## 105 FL Dept. of Environmental Protection, Southeast District
    ## 106 FL Dept. of Environmental Protection, Southeast District
    ## 107 FL Dept. of Environmental Protection, Southeast District
    ## 108                  FDEP Watershed Assessment Section (WAS)
    ## 109                  FDEP Watershed Assessment Section (WAS)
    ## 110                  FDEP Watershed Assessment Section (WAS)
    ## 111                  FDEP Watershed Assessment Section (WAS)
    ## 112                  FDEP Watershed Assessment Section (WAS)
    ## 113                  FDEP Watershed Assessment Section (WAS)
    ##     MonitoringLocationIdentifier
    ## 1                  USGS-02289080
    ## 2                 USGS-022890825
    ## 3                  USGS-02289085
    ## 4               USGS-02290829502
    ## 5                  USGS-02290947
    ## 6           USGS-250802081035500
    ## 7           USGS-251032080473400
    ## 8           USGS-251033080440800
    ## 9           USGS-251115081075800
    ## 10          USGS-251152080370900
    ## 11          USGS-251154080471900
    ## 12          USGS-251203080480600
    ## 13          USGS-251241080385301
    ## 14          USGS-252431080261001
    ## 15          USGS-252820080505401
    ## 16          USGS-253047080555600
    ## 17          USGS-254155080243502
    ## 18          USGS-254344081095101
    ## 19          USGS-254543080405401
    ## 20             21FLDADE_WQX-AR03
    ## 21            21FLDADE_WQX-BB39A
    ## 22             21FLDADE_WQX-BB47
    ## 23             21FLDADE_WQX-BB50
    ## 24             21FLDADE_WQX-BB51
    ## 25             21FLDADE_WQX-BB52
    ## 26             21FLDADE_WQX-BB53
    ## 27          21FLDADE_WQX-BISC101
    ## 28             21FLDADE_WQX-BL01
    ## 29             21FLDADE_WQX-BL03
    ## 30             21FLDADE_WQX-BL12
    ## 31             21FLDADE_WQX-BS10
    ## 32            21FLDADE_WQX-CD01A
    ## 33             21FLDADE_WQX-CD02
    ## 34             21FLDADE_WQX-CD05
    ## 35             21FLDADE_WQX-CD09
    ## 36             21FLDADE_WQX-CG07
    ## 37             21FLDADE_WQX-FC03
    ## 38             21FLDADE_WQX-FC15
    ## 39             21FLDADE_WQX-GL02
    ## 40             21FLDADE_WQX-GL03
    ## 41            21FLDADE_WQX-L31E1
    ## 42             21FLDADE_WQX-LR10
    ## 43             21FLDADE_WQX-MI01
    ## 44             21FLDADE_WQX-MI02
    ## 45             21FLDADE_WQX-MI03
    ## 46             21FLDADE_WQX-MR15
    ## 47             21FLDADE_WQX-MW01
    ## 48             21FLDADE_WQX-MW04
    ## 49             21FLDADE_WQX-MW05
    ## 50             21FLDADE_WQX-MW13
    ## 51            21FLDADE_WQX-NO07A
    ## 52             21FLDADE_WQX-PR01
    ## 53             21FLDADE_WQX-PR03
    ## 54            21FLDADE_WQX-PR04A
    ## 55             21FLDADE_WQX-PR08
    ## 56             21FLDADE_WQX-SK09
    ## 57             21FLDADE_WQX-SP08
    ## 58             21FLDADE_WQX-TM05
    ## 59             21FLDADE_WQX-TM08
    ## 60     21FLFTM_WQX-EVRGWC0113FTM
    ## 61          21FLFTM_WQX-G1SD0037
    ## 62          21FLFTM_WQX-G1SD0049
    ## 63          21FLFTM_WQX-G5SD0044
    ## 64          21FLFTM_WQX-G5SD0045
    ## 65          21FLFTM_WQX-G5SD0050
    ## 66               21FLGW_WQX-3494
    ## 67               21FLGW_WQX-3558
    ## 68               21FLGW_WQX-3571
    ## 69              21FLGW_WQX-37739
    ## 70              21FLGW_WQX-48941
    ## 71              21FLGW_WQX-48942
    ## 72              21FLGW_WQX-48944
    ## 73              21FLGW_WQX-48948
    ## 74              21FLGW_WQX-48949
    ## 75              21FLGW_WQX-48951
    ## 76              21FLGW_WQX-48953
    ## 77              21FLGW_WQX-49264
    ## 78              21FLGW_WQX-49265
    ## 79              21FLGW_WQX-49270
    ## 80              21FLGW_WQX-49273
    ## 81              21FLGW_WQX-49274
    ## 82              21FLGW_WQX-49275
    ## 83          21FLWPB_WQX-28040076
    ## 84          21FLWPB_WQX-28040402
    ## 85          21FLWPB_WQX-G4SE0017
    ## 86          21FLWPB_WQX-G4SE0019
    ## 87          21FLWPB_WQX-G4SE0064
    ## 88          21FLWPB_WQX-G4SE0065
    ## 89          21FLWPB_WQX-G4SE0066
    ## 90          21FLWPB_WQX-G4SE0068
    ## 91          21FLWPB_WQX-G4SE0073
    ## 92          21FLWPB_WQX-G4SE0077
    ## 93          21FLWPB_WQX-G4SE0086
    ## 94          21FLWPB_WQX-G4SE0087
    ## 95          21FLWPB_WQX-G4SECD02
    ## 96          21FLWPB_WQX-G4SECD05
    ## 97          21FLWPB_WQX-G4SECD06
    ## 98          21FLWPB_WQX-G4SEFC09
    ## 99          21FLWPB_WQX-G4SEFC15
    ## 100         21FLWPB_WQX-G4SELR10
    ## 101         21FLWPB_WQX-G4SENNR2
    ## 102         21FLWPB_WQX-G5SE0002
    ## 103         21FLWPB_WQX-G5SE0018
    ## 104         21FLWPB_WQX-G5SE0019
    ## 105         21FLWPB_WQX-G5SE0032
    ## 106         21FLWPB_WQX-G5SE0040
    ## 107         21FLWPB_WQX-G5SE0041
    ## 108         21FLWQA_WQX-G1SD0002
    ## 109         21FLWQA_WQX-G1SD0004
    ## 110         21FLWQA_WQX-G1SD0005
    ## 111         21FLWQA_WQX-G1SD0006
    ## 112         21FLWQA_WQX-G1SD0008
    ## 113         21FLWQA_WQX-G1SD0009
    ##                                      MonitoringLocationName
    ## 1         TAMIAMI CANAL WEST END 1 MILE BRIDGE NR MIAMI, FL
    ## 2               TAMIAMI CANAL AT 1 MILE BRIDGE NR MIAMI, FL
    ## 3         TAMIAMI CANAL EAST END 1 MILE BRIDGE NR MIAMI, FL
    ## 4                                                  MO  -199
    ## 5        SWEETWATER STRAND AT LOOP RD. NR MONROE STATION FL
    ## 6                    EAST SIDE CREEK NEAR LAKE INGRAHAM, FL
    ## 7                   ALLIGATOR CREEK NEAR GARFIELD BIGHT, FL
    ## 8                            OYSTER CREEK NEAR FLAMINGO, FL
    ## 9                RAULERSON BROTHERS CANAL AT CAPE SABLE, FL
    ## 10                            EAST CREEK NEAR HOMESTEAD, FL
    ## 11                   CUTHBERT LAKE OUTLET NEAR FLAMINGO, FL
    ## 12          WEST LAKE OUTLET TO LONG LAKE NEAR FLAMINGO, FL
    ## 13                                                 G  -3764
    ## 14                                                G  -3946D
    ## 15                                                MO  - 215
    ## 16             UPSTREAM BROAD RIVER NEAR EVERGLADES CITY FL
    ## 17                                                 G  -3913
    ## 18                                                 MO - 216
    ## 19                   TAMIAMI CANAL AT S-12-D NEAR MIAMI, FL
    ## 20                                                    C-111
    ## 21                                             Biscayne Bay
    ## 22                                             Biscayne Bay
    ## 23                                             Biscayne Bay
    ## 24                                             Biscayne Bay
    ## 25                                             Biscayne Bay
    ## 26                                             Biscayne Bay
    ## 27                                         Biscayne Bay 101
    ## 28                                  Black Creek Canal (C-1)
    ## 29                                  Black Creek Canal (C-1)
    ## 30                                  Black Creek Canal (C-1)
    ## 31                                     Biscayne Canal (C-8)
    ## 32                               Cutler Drain Canal (C-100)
    ## 33                               Cutler Drain Canal (C-100)
    ## 34                               Cutler Drain Canal (C-100)
    ## 35                               Cutler Drain Canal (C-100)
    ## 36                                 Coral Gables Canal (C-3)
    ## 37                                       Florida City Canal
    ## 38                                       Florida City Canal
    ## 39                                             Goulds Canal
    ## 40                                             Goulds Canal
    ## 41                                                    L31E1
    ## 42                                 Little River Canal (C-7)
    ## 43                                           Military Canal
    ## 44                                           Military Canal
    ## 45                                           Military Canal
    ## 46                                        Miami Canal (C-6)
    ## 47                                      Mowry Canal (C-103)
    ## 48                                      Mowry Canal (C-103)
    ## 49                                      Mowry Canal (C-103)
    ## 50                                      Mowry Canal (C-103)
    ## 51                                              North Canal
    ## 52                                  Princeton Canal (C-102)
    ## 53                                  Princeton Canal (C-102)
    ## 54                                  Princeton Canal (C-102)
    ## 55                                  Princeton Canal (C-102)
    ## 56                                  Snake Creek Canal (C-9)
    ## 57                                      Snapper Creek (C-2)
    ## 58                                      Tamiami Canal (C-4)
    ## 59                                      Tamiami Canal (C-4)
    ## 60                                               L28TIEBACK
    ## 61                             3278P @ #4 South of Goodland
    ## 62                            C-139 Annex @ Half Bridge Rd.
    ## 63                                3298X West Lake at Center
    ## 64                                    3298X Long Lake South
    ## 65                                   3298 X Long Lake North
    ## 66                                                 BARRNRVR
    ## 67                                                       S8
    ## 68                                                     BL03
    ## 69                                                  ARS-197
    ## 70                                Z5-CN-10003 UNNAMED CANAL
    ## 71                                Z5-CN-10004 UNNAMED CANAL
    ## 72                                Z5-CN-10007 UNNAMED CANAL
    ## 73                                Z5-CN-10011 UNNAMED CANAL
    ## 74                                Z5-CN-10012 UNNAMED CANAL
    ## 75                                Z5-CN-10014 UNNAMED CANAL
    ## 76                                Z5-CN-10016 UNNAMED CANAL
    ## 77                                Z6-CN-10004 UNNAMED CANAL
    ## 78                              Z6-CN-10005 HILLSBORO CANAL
    ## 79                                Z6-CN-10012 UNNAMED CANAL
    ## 80                        Z6-CN-10015 NORTH NEW RIVER CANAL
    ## 81                                Z6-CN-10016 UNNAMED CANAL
    ## 82                                Z6-CN-10017 UNNAMED CANAL
    ## 83           Florida City Canal at 117th ave and 344 street
    ## 84                    BLACK CREEK @ SW97 AVE,SOUTH DADE CO.
    ## 85             Snake Creek Canal (East) SF Canal Study C9-2
    ## 86             Snake Creek Canal (West) SF Canal Study C9-1
    ## 87                                      C-102 @ SW 248th St
    ## 88                            C-103 N SW 288 ST & SW 142 AV
    ## 89                                 MowryCan(C-103) @ 152 Av
    ## 90                                       TamiamiCan@KromeAv
    ## 91                    C-102 @ SW 248th St & South of bridge
    ## 92                                  C-102N @SW 248th Street
    ## 93                          C-1 Black Creek @ Old Cutler Rd
    ## 94                                             L-67 @ SR 41
    ## 95                    C-100/Cutler Drain (CD-02 Miami-Dade)
    ## 96                    C-100/Cutler Drain (CD-05 Miami-Dade)
    ## 97                    C-100/Cutler Drain (CD-06 Miami-Dade)
    ## 98                    Florida City Canal (FC-09 Miami-Dade)
    ## 99                    Florida City Canal (FC-15 Miami-Dade)
    ## 100                     C-7 Little River (LR-10 Miami-Dade)
    ## 101 North New River Canal (NNR-2 SF Canal Study/22 Broward)
    ## 102                                             L-5 @ G-206
    ## 103                             WCA1_L-7 NE of S6 structure
    ## 104                                          WCA1 L39 Canal
    ## 105                                             L-5 @ G-205
    ## 106                                           WCA 2B @S-141
    ## 107                                      WCA 3 L-67 @ S-151
    ## 108                                     Cape Romano Complex
    ## 109                                          Faka Union Bay
    ## 110                                         Fakahatchee Bay
    ## 111                                            Goodland Bay
    ## 112                                 Middle Blackwater River
    ## 113                                             Pumpkin Bay
    ##     MonitoringLocationTypeName
    ## 1                Stream: Canal
    ## 2                       Stream
    ## 3                Stream: Canal
    ## 4                         Well
    ## 5                       Stream
    ## 6                       Stream
    ## 7                       Stream
    ## 8                       Stream
    ## 9                       Stream
    ## 10                      Stream
    ## 11                      Stream
    ## 12                      Stream
    ## 13                        Well
    ## 14                        Well
    ## 15                        Well
    ## 16                      Stream
    ## 17                        Well
    ## 18                        Well
    ## 19               Stream: Canal
    ## 20              Canal Drainage
    ## 21                     Estuary
    ## 22                     Estuary
    ## 23                     Estuary
    ## 24                     Estuary
    ## 25                     Estuary
    ## 26                     Estuary
    ## 27                     Estuary
    ## 28                     Estuary
    ## 29              Canal Drainage
    ## 30              Canal Drainage
    ## 31              Canal Drainage
    ## 32                     Estuary
    ## 33              Canal Drainage
    ## 34              Canal Drainage
    ## 35              Canal Drainage
    ## 36              Canal Drainage
    ## 37              Canal Drainage
    ## 38              Canal Drainage
    ## 39                     Estuary
    ## 40              Canal Drainage
    ## 41              Canal Drainage
    ## 42              Canal Drainage
    ## 43                     Estuary
    ## 44              Canal Drainage
    ## 45              Canal Drainage
    ## 46              Canal Drainage
    ## 47                     Estuary
    ## 48              Canal Drainage
    ## 49              Canal Drainage
    ## 50              Canal Drainage
    ## 51                     Estuary
    ## 52                     Estuary
    ## 53              Canal Drainage
    ## 54              Canal Drainage
    ## 55              Canal Drainage
    ## 56              Canal Drainage
    ## 57              Canal Drainage
    ## 58              Canal Drainage
    ## 59              Canal Drainage
    ## 60                River/Stream
    ## 61                     Estuary
    ## 62              Canal Drainage
    ## 63                     Estuary
    ## 64                     Estuary
    ## 65                     Estuary
    ## 66                River/Stream
    ## 67              Canal Drainage
    ## 68              Canal Drainage
    ## 69              Canal Drainage
    ## 70              Canal Drainage
    ## 71              Canal Drainage
    ## 72              Canal Drainage
    ## 73              Canal Drainage
    ## 74              Canal Drainage
    ## 75              Canal Drainage
    ## 76              Canal Drainage
    ## 77              Canal Drainage
    ## 78              Canal Drainage
    ## 79              Canal Drainage
    ## 80              Canal Drainage
    ## 81              Canal Drainage
    ## 82              Canal Drainage
    ## 83              Canal Drainage
    ## 84                River/Stream
    ## 85              Canal Drainage
    ## 86              Canal Drainage
    ## 87              Canal Drainage
    ## 88              Canal Drainage
    ## 89              Canal Drainage
    ## 90              Canal Drainage
    ## 91              Canal Drainage
    ## 92              Canal Drainage
    ## 93              Canal Drainage
    ## 94              Canal Drainage
    ## 95              Canal Drainage
    ## 96              Canal Drainage
    ## 97              Canal Drainage
    ## 98              Canal Drainage
    ## 99              Canal Drainage
    ## 100             Canal Drainage
    ## 101             Canal Drainage
    ## 102             Canal Drainage
    ## 103             Canal Drainage
    ## 104             Canal Drainage
    ## 105             Canal Drainage
    ## 106             Canal Drainage
    ## 107             Canal Drainage
    ## 108                    Estuary
    ## 109                    Estuary
    ## 110                    Estuary
    ## 111                    Estuary
    ## 112                    Estuary
    ## 113                    Estuary
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                               MonitoringLocationDescriptionText
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <NA>
    ## 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 20                                                                                                                                                                                                                                                                                                                                                                                                              US 1/SW 518 Street.  East side of US 1 on Aerojet Canal (C-111)
    ## 21                                                                                                                                                                                                                                                                                                                                                                                                                                               Biscayne Bay SE of Black Point
    ## 22                                                                                                                                                                                                                                                                                                                                                                                                               Biscayne Bay at center of Card Sound 4 km south of Cutter Bank
    ## 23                                                                                                                                                                                                                                                                                                                                                                                        Biscayne Bay at Barnes Sound ICWW midway between Card Sound Bridge and Jewfish Creek.
    ## 24                                                                                                                                                                                                                                                                                                                                                                                                   Biscayne Bay 500 meters north of Aerojet Channel in center of Manatee Bay.
    ## 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                Biscayne Bay.
    ## 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                Biscayne Bay.
    ## 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 28                                                                                                                                                                                                                                                                                                                                                                                                                      Confluence with Gould's Channel and Black Creek Channel
    ## 29                                                                                                                                                                                                                                                                                                                                                                                                               SW 97 Ave/SW 238 St.  Black Creek east side of 97 Ave. bridge.
    ## 30                                                                                                                                                                                                                                                                                                                                                                                                               SW 177 Ave./SW 112 St.  Black Creek east of Krome Ave. bridge.
    ## 31                                                                                                                                                                                                                                                                                                                                                                                                        NW 77 Ave/NW 162 St.  East side of Palmetto Expressway access bridge.
    ## 32                                                                                                                                                                                                                                                                                                                                         Cutler Drain Canal.  The station is ~ 1000' from CD01 (mouth of the canal), adjacent to the manatee sign off the mouth of the canal.
    ## 33                                                                                                                                                                                                                                                                                                                                                                                Old Cutler Rd/SW 174 St.  Cutler drain at Old Cutler Road, est side of Old Cutler Road ridge.
    ## 34                                                                                                                                                                                                                                                                                                                                                                                                                                                              US 1/SW 158 St.
    ## 35                                                                                                                                                                                                                                                                                                                                                                                                          SW 134 Ave/SW 110 St.  Cutler Drain east side of SW 134 Ave bridge.
    ## 36                                                                                                                                                                                                                                                                                                                                                                                                         SW 72 Ave/SW 32 St.  Coral Gables waterway at SW 72 Ave., east side.
    ## 37                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 38                                                                                                                                                                                                                                                                                                                                                                                                                                                       SW 167 Ave./SW 344 St.
    ## 39                                                                                                                                                                                                                                                                                                                                                                                                                                       Goulds Canal just east of earthen plug
    ## 40                                                                                                                                                                                                                                                                                                                                                                                                                                                        SW 94 Ave./SW 248 St.
    ## 41                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 42                                                                                                                                                                                                                                                                                                                                                                                                                        NW 87 Ave/NW 102 St. at NW 87 Ave. (Galloway) bridge.
    ## 43                                                                                                                                                                                                                                                                                                                                                                                                                                                      Mouth of Military Canal
    ## 44                                                                                                                                                                                                                                                                                                                                                                                                                                                          Military Canal/L-31
    ## 45                                                                                                                                                                                                                                                                                                                                                                                                       SW 107 Ave/SW 300 St.  Military Canal west side of SW 107 Ave. bridge.
    ## 46                                                                                                                                                                                                                                                                                                                                                                                                        Okeechobee Rd/NW 138 St.  Miami Canal west side of NW 138 St. bridge.
    ## 47                                                                                                                                                                                                                                                                                                                                                                                                                                                         Mouth of Mowry Canal
    ## 48                                                                                                                                                                                                                                                                                                                                                                                                               SW 117 Ave/SW 316 St.  Mowry Canal east of SW 117 Ave. bridge.
    ## 49                                                                                                                                                                                                                                                                                                                                                                                                                                                       SW 155 Ave./SW 264 St.
    ## 50                                                                                                                                                                                                                                                                                                                                                                                                                SW 217 Ave/SW 268 St.  Mowry Canal east of SW 217 Ave. bridge
    ## 51                                                                                                                                                                                                                                                                                                                                                           Approximately half mile downstream on NO07. Station was established because NO07 was deem too dangerous to sample.
    ## 52                                                                                                                                                                                                                                                                                                                                                                                                                                                     Mouth of Princeton Canal
    ## 53                                                                                                                                                                                                                                                                                                                                                                                                                                                       SW 107 Ave./SW 268 St.
    ## 54                                                                                                                                                                                                                                                                                                                                                                                                                                                       SW 122 Ave./SW 248 St.
    ## 55                                                                                                                                                                                                                                                                                                                                                                                                                            SW 197 Ave/SW 192 St.  West of SW 197 Ave. bridge
    ## 56                                                                                                                                                                                                                                                                                                                                                                                                        NW 67 Ave/NW 210 St.  East of Ludlam Road (NW 67 Ave) east of bridge.
    ## 57                                                                                                                                                                                                                                                                                                                                                                                                            SW 117 Ave/SW 56 St.  West side of Snapper Creek Canal Dr. bridge
    ## 58                                                                                                                                                                                                                                                                                                                                                                                                                                                              SW 8 St/ 77 Ave
    ## 59                                                                                                                                                                                                                                                                                                                                                                                                                 SW 177 Ave/SW 8 St.  Tamiami Canal west of Krome Ave bridge.
    ## 60                                                                                                                                                                                                                                                                                                                                                                                                                                                     L-28 Tieback @ I75 South
    ## 61                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 62                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 63                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 64                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 65                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 66                                                                                                                                                                                                                                                                                                                                                                                                                                        BARRON RIVER AT S.R. 29 NEAR COPELAND
    ## 67                                                                                                                                                                                                                                                                                                                                                                                                                                                         MIAMI CANAL ABOVE S8
    ## 68                                                                                                                                                                                                                                                                                                                                                                                                                                    BLACK CREEK CANAL AT SW 97 AVE. & 236 ST.
    ## 69                                                                                                                                                                                                                                                                                                                                                                                                                                                                AEROJET CANAL
    ## 70                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 71                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 72                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 73                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 74                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 75                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 76                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 77                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 78                                                                                                                                                                                                                                                                                                                                                                                                                                                              HILLSBORO CANAL
    ## 79                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 80                                                                                                                                                                                                                                                                                                                                                                                                                                                        NORTH NEW RIVER CANAL
    ## 81                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 82                                                                                                                                                                                                                                                                                                                                                                                                                                                                UNNAMED CANAL
    ## 83                                                                                                                                                                                                                                                                                                                                                         Florida City Canal at 117th avenue and 344th street . SED DEP site 57C.  WBID 3305. For chlorophyll makeup sampling.
    ## 84  SOUTH OF MIAMI; ON SW224 ST PROCEED WEST OF SOUTH REGIONAL WWTP TO       SW97 AVE,SOUTH ON SW97 AVE 0.2 MILES TO BRIDGE OVER BLACK CREEK. APPROX. 2.5 MILES SSE OF INTERSECTION OF U.S.1 AND FLA. TURNPIKE EXTENSION       (SR 821)                                                                           MIGRATED FROM LEGACY STORET AGENCY CODE (21FLA   ) ON 17-JUN-99 MAJOR BASIN NAME: SOUTHEAST                BASIN CODE: 032804 MINOR BASIN NAME: LOWER FLORIDA
    ## 85                                                                                                                                                                                                                                                                                                                                                                                     Snake Creek Canal (East) SF Canal Study C9-2 Broward County Site 31 Miami Dade Site SK09
    ## 86                                                                                                                                                                                                                                                                                                                                                                                                          Snake Creek Canal (West) SF Canal Study C9-1 Broward County Site 32
    ## 87                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 88                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 89                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 90                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 91                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 92                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 93                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 94                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 95                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 96                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 97                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 98                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 99                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <NA>
    ## 100                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 101                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 102                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 103                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 104                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 105                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 106                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 107                                                                                                                                                                                                                                                                                                                                                                                                                                                                        <NA>
    ## 108                                                                                                                                                                                                                                                                                                                                                                                                                                                         Cape Romano Complex
    ## 109                                                                                                                                                                                                                                                                                                                                                                                                                                                              Faka Union Bay
    ## 110                                                                                                                                                                                                                                                                                                                                                                                                                                                             Fakahatchee Bay
    ## 111                                                                                                                                                                                                                                                                                                                                                                                                                                                                Goodland Bay
    ## 112                                                                                                                                                                                                                                                                                                                                                                                                                                                     Middle Blackwater River
    ## 113                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Pumpkin Bay
    ##     HUCEightDigitCode DrainageAreaMeasure.MeasureValue
    ## 1            03090202                             <NA>
    ## 2                <NA>                             <NA>
    ## 3            03090202                             <NA>
    ## 4            03090202                             <NA>
    ## 5            03090204                             <NA>
    ## 6            03090203                             <NA>
    ## 7            03090202                             <NA>
    ## 8            03090202                             <NA>
    ## 9            03090203                             <NA>
    ## 10           03090202                             <NA>
    ## 11           03090202                             <NA>
    ## 12           03090202                             <NA>
    ## 13           03090202                             <NA>
    ## 14           03090202                             <NA>
    ## 15           03090202                             <NA>
    ## 16           03090202                             <NA>
    ## 17           03090202                             <NA>
    ## 18           03090204                             <NA>
    ## 19           03090202                             <NA>
    ## 20           03090206                             <NA>
    ## 21           03090206                             <NA>
    ## 22           03090206                             <NA>
    ## 23           03090203                             <NA>
    ## 24           03090203                             <NA>
    ## 25           03090206                             <NA>
    ## 26           03090206                             <NA>
    ## 27           03090206                             <NA>
    ## 28           03090206                             <NA>
    ## 29           03090206                             <NA>
    ## 30           03090206                             <NA>
    ## 31           03090206                             <NA>
    ## 32           03090206                             <NA>
    ## 33           03090206                             <NA>
    ## 34           03090206                             <NA>
    ## 35           03090206                             <NA>
    ## 36           03090206                             <NA>
    ## 37           03090206                             <NA>
    ## 38           03090206                             <NA>
    ## 39           03090206                             <NA>
    ## 40           03090206                             <NA>
    ## 41           03090206                             <NA>
    ## 42           03090206                             <NA>
    ## 43           03090206                             <NA>
    ## 44           03090206                             <NA>
    ## 45           03090206                             <NA>
    ## 46           03090206                             <NA>
    ## 47           03090206                             <NA>
    ## 48           03090206                             <NA>
    ## 49           03090206                             <NA>
    ## 50           03090206                             <NA>
    ## 51           03090206                             <NA>
    ## 52           03090206                             <NA>
    ## 53           03090206                             <NA>
    ## 54           03090206                             <NA>
    ## 55           03090206                             <NA>
    ## 56           03090206                             <NA>
    ## 57           03090206                             <NA>
    ## 58           03090206                             <NA>
    ## 59           03090206                             <NA>
    ## 60           03090202                             <NA>
    ## 61           03090204                             <NA>
    ## 62           03090202                             <NA>
    ## 63           03090202                             <NA>
    ## 64           03090202                             <NA>
    ## 65           03090202                             <NA>
    ## 66           03090204                             <NA>
    ## 67           03090202                             <NA>
    ## 68           03090206                             <NA>
    ## 69           03090206                             <NA>
    ## 70           03090202                             <NA>
    ## 71           03090204                             <NA>
    ## 72           03090202                             <NA>
    ## 73           03090202                             <NA>
    ## 74           03090204                             <NA>
    ## 75           03090204                             <NA>
    ## 76           03090204                             <NA>
    ## 77           03090206                             <NA>
    ## 78           03090202                             <NA>
    ## 79           03090202                             <NA>
    ## 80           03090202                             <NA>
    ## 81           03090206                             <NA>
    ## 82           03090202                             <NA>
    ## 83           03090206                             <NA>
    ## 84           03090206                             <NA>
    ## 85           03090206                             <NA>
    ## 86           03090206                             <NA>
    ## 87           03090206                             <NA>
    ## 88           03090206                             <NA>
    ## 89           03090206                             <NA>
    ## 90           03090206                             <NA>
    ## 91           03090206                             <NA>
    ## 92           03090206                             <NA>
    ## 93           03090206                             <NA>
    ## 94           03090206                             <NA>
    ## 95           03090206                             <NA>
    ## 96           03090206                             <NA>
    ## 97           03090206                             <NA>
    ## 98           03090206                             <NA>
    ## 99           03090206                             <NA>
    ## 100          03090206                             <NA>
    ## 101          03090206                             <NA>
    ## 102          03090202                             <NA>
    ## 103          03090202                             <NA>
    ## 104          03090202                             <NA>
    ## 105          03090202                             <NA>
    ## 106          03090202                             <NA>
    ## 107          03090202                             <NA>
    ## 108              <NA>                             <NA>
    ## 109          03090204                             <NA>
    ## 110          03090204                             <NA>
    ## 111          03090204                             <NA>
    ## 112          03090204                             <NA>
    ## 113          03090204                             <NA>
    ##     DrainageAreaMeasure.MeasureUnitCode
    ## 1                                  <NA>
    ## 2                                  <NA>
    ## 3                                  <NA>
    ## 4                                  <NA>
    ## 5                                  <NA>
    ## 6                                  <NA>
    ## 7                                  <NA>
    ## 8                                  <NA>
    ## 9                                  <NA>
    ## 10                                 <NA>
    ## 11                                 <NA>
    ## 12                                 <NA>
    ## 13                                 <NA>
    ## 14                                 <NA>
    ## 15                                 <NA>
    ## 16                                 <NA>
    ## 17                                 <NA>
    ## 18                                 <NA>
    ## 19                                 <NA>
    ## 20                                 <NA>
    ## 21                                 <NA>
    ## 22                                 <NA>
    ## 23                                 <NA>
    ## 24                                 <NA>
    ## 25                                 <NA>
    ## 26                                 <NA>
    ## 27                                 <NA>
    ## 28                                 <NA>
    ## 29                                 <NA>
    ## 30                                 <NA>
    ## 31                                 <NA>
    ## 32                                 <NA>
    ## 33                                 <NA>
    ## 34                                 <NA>
    ## 35                                 <NA>
    ## 36                                 <NA>
    ## 37                                 <NA>
    ## 38                                 <NA>
    ## 39                                 <NA>
    ## 40                                 <NA>
    ## 41                                 <NA>
    ## 42                                 <NA>
    ## 43                                 <NA>
    ## 44                                 <NA>
    ## 45                                 <NA>
    ## 46                                 <NA>
    ## 47                                 <NA>
    ## 48                                 <NA>
    ## 49                                 <NA>
    ## 50                                 <NA>
    ## 51                                 <NA>
    ## 52                                 <NA>
    ## 53                                 <NA>
    ## 54                                 <NA>
    ## 55                                 <NA>
    ## 56                                 <NA>
    ## 57                                 <NA>
    ## 58                                 <NA>
    ## 59                                 <NA>
    ## 60                                 <NA>
    ## 61                                 <NA>
    ## 62                                 <NA>
    ## 63                                 <NA>
    ## 64                                 <NA>
    ## 65                                 <NA>
    ## 66                                 <NA>
    ## 67                                 <NA>
    ## 68                                 <NA>
    ## 69                                 <NA>
    ## 70                                 <NA>
    ## 71                                 <NA>
    ## 72                                 <NA>
    ## 73                                 <NA>
    ## 74                                 <NA>
    ## 75                                 <NA>
    ## 76                                 <NA>
    ## 77                                 <NA>
    ## 78                                 <NA>
    ## 79                                 <NA>
    ## 80                                 <NA>
    ## 81                                 <NA>
    ## 82                                 <NA>
    ## 83                                 <NA>
    ## 84                                 <NA>
    ## 85                                 <NA>
    ## 86                                 <NA>
    ## 87                                 <NA>
    ## 88                                 <NA>
    ## 89                                 <NA>
    ## 90                                 <NA>
    ## 91                                 <NA>
    ## 92                                 <NA>
    ## 93                                 <NA>
    ## 94                                 <NA>
    ## 95                                 <NA>
    ## 96                                 <NA>
    ## 97                                 <NA>
    ## 98                                 <NA>
    ## 99                                 <NA>
    ## 100                                <NA>
    ## 101                                <NA>
    ## 102                                <NA>
    ## 103                                <NA>
    ## 104                                <NA>
    ## 105                                <NA>
    ## 106                                <NA>
    ## 107                                <NA>
    ## 108                                <NA>
    ## 109                                <NA>
    ## 110                                <NA>
    ## 111                                <NA>
    ## 112                                <NA>
    ## 113                                <NA>
    ##     ContributingDrainageAreaMeasure.MeasureValue
    ## 1                                           <NA>
    ## 2                                           <NA>
    ## 3                                           <NA>
    ## 4                                           <NA>
    ## 5                                           <NA>
    ## 6                                           <NA>
    ## 7                                           <NA>
    ## 8                                           <NA>
    ## 9                                           <NA>
    ## 10                                          <NA>
    ## 11                                          <NA>
    ## 12                                          <NA>
    ## 13                                          <NA>
    ## 14                                          <NA>
    ## 15                                          <NA>
    ## 16                                          <NA>
    ## 17                                          <NA>
    ## 18                                          <NA>
    ## 19                                          <NA>
    ## 20                                          <NA>
    ## 21                                          <NA>
    ## 22                                          <NA>
    ## 23                                          <NA>
    ## 24                                          <NA>
    ## 25                                          <NA>
    ## 26                                          <NA>
    ## 27                                          <NA>
    ## 28                                          <NA>
    ## 29                                          <NA>
    ## 30                                          <NA>
    ## 31                                          <NA>
    ## 32                                          <NA>
    ## 33                                          <NA>
    ## 34                                          <NA>
    ## 35                                          <NA>
    ## 36                                          <NA>
    ## 37                                          <NA>
    ## 38                                          <NA>
    ## 39                                          <NA>
    ## 40                                          <NA>
    ## 41                                          <NA>
    ## 42                                          <NA>
    ## 43                                          <NA>
    ## 44                                          <NA>
    ## 45                                          <NA>
    ## 46                                          <NA>
    ## 47                                          <NA>
    ## 48                                          <NA>
    ## 49                                          <NA>
    ## 50                                          <NA>
    ## 51                                          <NA>
    ## 52                                          <NA>
    ## 53                                          <NA>
    ## 54                                          <NA>
    ## 55                                          <NA>
    ## 56                                          <NA>
    ## 57                                          <NA>
    ## 58                                          <NA>
    ## 59                                          <NA>
    ## 60                                          <NA>
    ## 61                                          <NA>
    ## 62                                          <NA>
    ## 63                                          <NA>
    ## 64                                          <NA>
    ## 65                                          <NA>
    ## 66                                          <NA>
    ## 67                                          <NA>
    ## 68                                          <NA>
    ## 69                                          <NA>
    ## 70                                          <NA>
    ## 71                                          <NA>
    ## 72                                          <NA>
    ## 73                                          <NA>
    ## 74                                          <NA>
    ## 75                                          <NA>
    ## 76                                          <NA>
    ## 77                                          <NA>
    ## 78                                          <NA>
    ## 79                                          <NA>
    ## 80                                          <NA>
    ## 81                                          <NA>
    ## 82                                          <NA>
    ## 83                                          <NA>
    ## 84                                          <NA>
    ## 85                                          <NA>
    ## 86                                          <NA>
    ## 87                                          <NA>
    ## 88                                          <NA>
    ## 89                                          <NA>
    ## 90                                          <NA>
    ## 91                                          <NA>
    ## 92                                          <NA>
    ## 93                                          <NA>
    ## 94                                          <NA>
    ## 95                                          <NA>
    ## 96                                          <NA>
    ## 97                                          <NA>
    ## 98                                          <NA>
    ## 99                                          <NA>
    ## 100                                         <NA>
    ## 101                                         <NA>
    ## 102                                         <NA>
    ## 103                                         <NA>
    ## 104                                         <NA>
    ## 105                                         <NA>
    ## 106                                         <NA>
    ## 107                                         <NA>
    ## 108                                         <NA>
    ## 109                                         <NA>
    ## 110                                         <NA>
    ## 111                                         <NA>
    ## 112                                         <NA>
    ## 113                                         <NA>
    ##     ContributingDrainageAreaMeasure.MeasureUnitCode LatitudeMeasure
    ## 1                                              <NA>        25.76139
    ## 2                                              <NA>        25.76088
    ## 3                                              <NA>        25.76139
    ## 4                                              <NA>        25.46798
    ## 5                                              <NA>        25.78857
    ## 6                                              <NA>        25.13697
    ## 7                                              <NA>        25.17556
    ## 8                                              <NA>        25.17589
    ## 9                                              <NA>        25.18765
    ## 10                                             <NA>        25.19861
    ## 11                                             <NA>        25.19836
    ## 12                                             <NA>        25.20072
    ## 13                                             <NA>        25.21000
    ## 14                                             <NA>        25.40853
    ## 15                                             <NA>        25.47222
    ## 16                                             <NA>        25.50129
    ## 17                                             <NA>        25.69886
    ## 18                                             <NA>        25.72903
    ## 19                                             <NA>        25.76232
    ## 20                                             <NA>        25.28901
    ## 21                                             <NA>        25.52643
    ## 22                                             <NA>        25.33679
    ## 23                                             <NA>        25.22990
    ## 24                                             <NA>        25.25150
    ## 25                                             <NA>        25.56461
    ## 26                                             <NA>        25.50248
    ## 27                                             <NA>        25.47833
    ## 28                                             <NA>        25.53604
    ## 29                                             <NA>        25.54905
    ## 30                                             <NA>        25.66102
    ## 31                                             <NA>        25.91874
    ## 32                                             <NA>        25.61047
    ## 33                                             <NA>        25.61118
    ## 34                                             <NA>        25.62384
    ## 35                                             <NA>        25.66588
    ## 36                                             <NA>        25.74108
    ## 37                                             <NA>        25.44805
    ## 38                                             <NA>        25.44810
    ## 39                                             <NA>        25.53722
    ## 40                                             <NA>        25.53730
    ## 41                                             <NA>        25.49265
    ## 42                                             <NA>        25.86956
    ## 43                                             <NA>        25.48936
    ## 44                                             <NA>        25.48936
    ## 45                                             <NA>        25.48946
    ## 46                                             <NA>        25.89598
    ## 47                                             <NA>        25.47079
    ## 48                                             <NA>        25.47129
    ## 49                                             <NA>        25.52144
    ## 50                                             <NA>        25.51749
    ## 51                                             <NA>        25.46289
    ## 52                                             <NA>        25.51959
    ## 53                                             <NA>        25.51952
    ## 54                                             <NA>        25.53697
    ## 55                                             <NA>        25.58707
    ## 56                                             <NA>        25.96423
    ## 57                                             <NA>        25.71548
    ## 58                                             <NA>        25.76254
    ## 59                                             <NA>        25.76178
    ## 60                                             <NA>        26.17176
    ## 61                                             <NA>        25.92063
    ## 62                                             <NA>        26.33125
    ## 63                                             <NA>        25.20750
    ## 64                                             <NA>        25.18927
    ## 65                                             <NA>        25.19707
    ## 66                                             <NA>        25.95259
    ## 67                                             <NA>        26.32230
    ## 68                                             <NA>        25.54538
    ## 69                                             <NA>        25.28739
    ## 70                                             <NA>        26.17213
    ## 71                                             <NA>        26.32449
    ## 72                                             <NA>        26.43081
    ## 73                                             <NA>        26.34343
    ## 74                                             <NA>        26.24407
    ## 75                                             <NA>        25.98618
    ## 76                                             <NA>        26.16999
    ## 77                                             <NA>        26.06268
    ## 78                                             <NA>        26.42003
    ## 79                                             <NA>        26.31959
    ## 80                                             <NA>        26.24754
    ## 81                                             <NA>        25.66044
    ## 82                                             <NA>        26.35941
    ## 83                                             <NA>        25.44805
    ## 84                                             <NA>        25.54833
    ## 85                                             <NA>        25.96422
    ## 86                                             <NA>        25.95686
    ## 87                                             <NA>        25.53655
    ## 88                                             <NA>        25.49978
    ## 89                                             <NA>        25.47450
    ## 90                                             <NA>        25.76139
    ## 91                                             <NA>        25.53473
    ## 92                                             <NA>        25.53697
    ## 93                                             <NA>        25.55928
    ## 94                                             <NA>        25.76101
    ## 95                                             <NA>        25.61055
    ## 96                                             <NA>        25.62368
    ## 97                                             <NA>        25.62967
    ## 98                                             <NA>        25.44792
    ## 99                                             <NA>        25.44789
    ## 100                                            <NA>        25.86945
    ## 101                                            <NA>        26.11486
    ## 102                                            <NA>        26.33331
    ## 103                                            <NA>        26.47339
    ## 104                                            <NA>        26.47048
    ## 105                                            <NA>        26.33278
    ## 106                                            <NA>        26.15052
    ## 107                                            <NA>        26.01161
    ## 108                                            <NA>        25.85250
    ## 109                                            <NA>        25.90050
    ## 110                                            <NA>        25.89220
    ## 111                                            <NA>        25.93230
    ## 112                                            <NA>        25.93420
    ## 113                                            <NA>        25.91410
    ##     LongitudeMeasure SourceMapScaleNumeric
    ## 1          -80.53667                  <NA>
    ## 2          -80.52668                  <NA>
    ## 3          -80.51667                  <NA>
    ## 4          -80.85453                  <NA>
    ## 5          -81.09992                  <NA>
    ## 6          -81.06438                  <NA>
    ## 7          -80.79278                  <NA>
    ## 8          -80.73558                  <NA>
    ## 9          -81.13278                  <NA>
    ## 10         -80.61888                  <NA>
    ## 11         -80.78867                  <NA>
    ## 12         -80.80161                  <NA>
    ## 13         -80.64778                  <NA>
    ## 14         -80.43603                  <NA>
    ## 15         -80.84833                  <NA>
    ## 16         -80.93222                  <NA>
    ## 17         -80.35975                  <NA>
    ## 18         -81.16425                  <NA>
    ## 19         -80.68145                  <NA>
    ## 20         -80.44306                  <NA>
    ## 21         -80.30706                  <NA>
    ## 22         -80.32008                  <NA>
    ## 23         -80.37678                  <NA>
    ## 24         -80.41408                  <NA>
    ## 25         -80.30485                  <NA>
    ## 26         -80.33228                  <NA>
    ## 27         -80.32083                  <NA>
    ## 28         -80.32527                  <NA>
    ## 29         -80.34814                  <NA>
    ## 30         -80.43061                  <NA>
    ## 31         -80.32450                  <NA>
    ## 32         -80.30354                  <NA>
    ## 33         -80.30987                  <NA>
    ## 34         -80.34363                  <NA>
    ## 35         -80.40868                  <NA>
    ## 36         -80.31067                  <NA>
    ## 37         -80.36738                  <NA>
    ## 38         -80.46090                  <NA>
    ## 39         -80.33303                  <NA>
    ## 40         -80.34376                  <NA>
    ## 41         -80.34677                  <NA>
    ## 42         -80.33872                  <NA>
    ## 43         -80.33814                  <NA>
    ## 44         -80.34734                  <NA>
    ## 45         -80.36355                  <NA>
    ## 46         -80.37943                  <NA>
    ## 47         -80.37401                  <NA>
    ## 48         -80.37928                  <NA>
    ## 49         -80.44355                  <NA>
    ## 50         -80.54258                  <NA>
    ## 51         -80.40389                  <NA>
    ## 52         -80.33198                  <NA>
    ## 53         -80.36405                  <NA>
    ## 54         -80.38960                  <NA>
    ## 55         -80.51122                  <NA>
    ## 56         -80.31109                  <NA>
    ## 57         -80.38297                  <NA>
    ## 58         -80.32030                  <NA>
    ## 59         -80.48108                  <NA>
    ## 60         -80.89410                  <NA>
    ## 61         -81.64514                  <NA>
    ## 62         -80.88174                  <NA>
    ## 63         -80.82588                  <NA>
    ## 64         -80.77948                  <NA>
    ## 65         -80.79503                  <NA>
    ## 66         -81.35590                  <NA>
    ## 67         -80.77450                  <NA>
    ## 68         -80.34588                  <NA>
    ## 69         -80.44186                  <NA>
    ## 70         -80.86225                  <NA>
    ## 71         -81.34288                  <NA>
    ## 72         -81.04653                  <NA>
    ## 73         -80.78355                  <NA>
    ## 74         -81.65259                  <NA>
    ## 75         -80.83814                  <NA>
    ## 76         -81.67904                  <NA>
    ## 77         -80.37145                  <NA>
    ## 78         -80.40584                  <NA>
    ## 79         -80.76538                  <NA>
    ## 80         -80.47184                  <NA>
    ## 81         -80.49029                  <NA>
    ## 82         -80.65067                  <NA>
    ## 83         -80.37955                  <NA>
    ## 84         -80.34806                  <NA>
    ## 85         -80.30922                  <NA>
    ## 86         -80.43214                  <NA>
    ## 87         -80.40475                  <NA>
    ## 88         -80.41880                  <NA>
    ## 89         -80.43583                  <NA>
    ## 90         -80.48155                  <NA>
    ## 91         -80.40413                  <NA>
    ## 92         -80.38960                  <NA>
    ## 93         -80.35923                  <NA>
    ## 94         -80.49804                  <NA>
    ## 95         -80.31007                  <NA>
    ## 96         -80.34322                  <NA>
    ## 97         -80.31791                  <NA>
    ## 98         -80.41191                  <NA>
    ## 99         -80.46086                  <NA>
    ## 100        -80.33867                  <NA>
    ## 101        -80.31161                  <NA>
    ## 102        -80.65269                  <NA>
    ## 103        -80.44494                  <NA>
    ## 104        -80.44500                  <NA>
    ## 105        -80.71700                  <NA>
    ## 106        -80.44226                  <NA>
    ## 107        -80.50995                  <NA>
    ## 108        -81.67530                  <NA>
    ## 109        -81.51590                  <NA>
    ## 110        -81.47690                  <NA>
    ## 111        -81.65480                  <NA>
    ## 112        -81.59550                  <NA>
    ## 113        -81.54040                  <NA>
    ##     HorizontalAccuracyMeasure.MeasureValue
    ## 1                                  Unknown
    ## 2                                  Unknown
    ## 3                                  Unknown
    ## 4                                        1
    ## 5                                  Unknown
    ## 6                                  Unknown
    ## 7                                        1
    ## 8                                       .5
    ## 9                                  Unknown
    ## 10                                 Unknown
    ## 11                                      .5
    ## 12                                      .5
    ## 13                                       1
    ## 14                                      .5
    ## 15                                      .1
    ## 16                                       1
    ## 17                                      .5
    ## 18                                      .1
    ## 19                                       1
    ## 20                                    <NA>
    ## 21                                    <NA>
    ## 22                                    <NA>
    ## 23                                    <NA>
    ## 24                                    <NA>
    ## 25                                    <NA>
    ## 26                                    <NA>
    ## 27                                    <NA>
    ## 28                                    <NA>
    ## 29                                    <NA>
    ## 30                                    <NA>
    ## 31                                    <NA>
    ## 32                                    <NA>
    ## 33                                    <NA>
    ## 34                                    <NA>
    ## 35                                    <NA>
    ## 36                                    <NA>
    ## 37                                    <NA>
    ## 38                                    <NA>
    ## 39                                    <NA>
    ## 40                                    <NA>
    ## 41                                    <NA>
    ## 42                                    <NA>
    ## 43                                    <NA>
    ## 44                                    <NA>
    ## 45                                    <NA>
    ## 46                                    <NA>
    ## 47                                    <NA>
    ## 48                                    <NA>
    ## 49                                    <NA>
    ## 50                                    <NA>
    ## 51                                    <NA>
    ## 52                                    <NA>
    ## 53                                    <NA>
    ## 54                                    <NA>
    ## 55                                    <NA>
    ## 56                                    <NA>
    ## 57                                    <NA>
    ## 58                                    <NA>
    ## 59                                    <NA>
    ## 60                                    <NA>
    ## 61                                    <NA>
    ## 62                                    <NA>
    ## 63                                    <NA>
    ## 64                                    <NA>
    ## 65                                    <NA>
    ## 66                                    <NA>
    ## 67                                    <NA>
    ## 68                                    <NA>
    ## 69                                    <NA>
    ## 70                                    <NA>
    ## 71                                    <NA>
    ## 72                                    <NA>
    ## 73                                    <NA>
    ## 74                                    <NA>
    ## 75                                    <NA>
    ## 76                                    <NA>
    ## 77                                    <NA>
    ## 78                                    <NA>
    ## 79                                    <NA>
    ## 80                                    <NA>
    ## 81                                    <NA>
    ## 82                                    <NA>
    ## 83                                    <NA>
    ## 84                                    <NA>
    ## 85                                    <NA>
    ## 86                                    <NA>
    ## 87                                    <NA>
    ## 88                                    <NA>
    ## 89                                    <NA>
    ## 90                                    <NA>
    ## 91                                    <NA>
    ## 92                                    <NA>
    ## 93                                    <NA>
    ## 94                                    <NA>
    ## 95                                    <NA>
    ## 96                                    <NA>
    ## 97                                    <NA>
    ## 98                                    <NA>
    ## 99                                    <NA>
    ## 100                                   <NA>
    ## 101                                   <NA>
    ## 102                                   <NA>
    ## 103                                   <NA>
    ## 104                                   <NA>
    ## 105                                   <NA>
    ## 106                                   <NA>
    ## 107                                   <NA>
    ## 108                                   <NA>
    ## 109                                   <NA>
    ## 110                                   <NA>
    ## 111                                   <NA>
    ## 112                                   <NA>
    ## 113                                   <NA>
    ##     HorizontalAccuracyMeasure.MeasureUnitCode
    ## 1                                     Unknown
    ## 2                                     Unknown
    ## 3                                     Unknown
    ## 4                                     minutes
    ## 5                                     Unknown
    ## 6                                     Unknown
    ## 7                                     minutes
    ## 8                                     seconds
    ## 9                                     Unknown
    ## 10                                    Unknown
    ## 11                                    seconds
    ## 12                                    seconds
    ## 13                                    seconds
    ## 14                                    seconds
    ## 15                                    seconds
    ## 16                                    minutes
    ## 17                                    seconds
    ## 18                                    seconds
    ## 19                                    seconds
    ## 20                                       <NA>
    ## 21                                       <NA>
    ## 22                                       <NA>
    ## 23                                       <NA>
    ## 24                                       <NA>
    ## 25                                       <NA>
    ## 26                                       <NA>
    ## 27                                       <NA>
    ## 28                                       <NA>
    ## 29                                       <NA>
    ## 30                                       <NA>
    ## 31                                       <NA>
    ## 32                                       <NA>
    ## 33                                       <NA>
    ## 34                                       <NA>
    ## 35                                       <NA>
    ## 36                                       <NA>
    ## 37                                       <NA>
    ## 38                                       <NA>
    ## 39                                       <NA>
    ## 40                                       <NA>
    ## 41                                       <NA>
    ## 42                                       <NA>
    ## 43                                       <NA>
    ## 44                                       <NA>
    ## 45                                       <NA>
    ## 46                                       <NA>
    ## 47                                       <NA>
    ## 48                                       <NA>
    ## 49                                       <NA>
    ## 50                                       <NA>
    ## 51                                       <NA>
    ## 52                                       <NA>
    ## 53                                       <NA>
    ## 54                                       <NA>
    ## 55                                       <NA>
    ## 56                                       <NA>
    ## 57                                       <NA>
    ## 58                                       <NA>
    ## 59                                       <NA>
    ## 60                                       <NA>
    ## 61                                       <NA>
    ## 62                                       <NA>
    ## 63                                       <NA>
    ## 64                                       <NA>
    ## 65                                       <NA>
    ## 66                                       <NA>
    ## 67                                       <NA>
    ## 68                                       <NA>
    ## 69                                       <NA>
    ## 70                                       <NA>
    ## 71                                       <NA>
    ## 72                                       <NA>
    ## 73                                       <NA>
    ## 74                                       <NA>
    ## 75                                       <NA>
    ## 76                                       <NA>
    ## 77                                       <NA>
    ## 78                                       <NA>
    ## 79                                       <NA>
    ## 80                                       <NA>
    ## 81                                       <NA>
    ## 82                                       <NA>
    ## 83                                       <NA>
    ## 84                                       <NA>
    ## 85                                       <NA>
    ## 86                                       <NA>
    ## 87                                       <NA>
    ## 88                                       <NA>
    ## 89                                       <NA>
    ## 90                                       <NA>
    ## 91                                       <NA>
    ## 92                                       <NA>
    ## 93                                       <NA>
    ## 94                                       <NA>
    ## 95                                       <NA>
    ## 96                                       <NA>
    ## 97                                       <NA>
    ## 98                                       <NA>
    ## 99                                       <NA>
    ## 100                                      <NA>
    ## 101                                      <NA>
    ## 102                                      <NA>
    ## 103                                      <NA>
    ## 104                                      <NA>
    ## 105                                      <NA>
    ## 106                                      <NA>
    ## 107                                      <NA>
    ## 108                                      <NA>
    ## 109                                      <NA>
    ## 110                                      <NA>
    ## 111                                      <NA>
    ## 112                                      <NA>
    ## 113                                      <NA>
    ##                                   HorizontalCollectionMethodName
    ## 1                                 Interpolated from Digital MAP.
    ## 2                                         Interpolated from MAP.
    ## 3                                  Long range navigation system.
    ## 4   Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 5                                                       Unknown.
    ## 6                                                       Unknown.
    ## 7   Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 8   Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 9                                                       Unknown.
    ## 10                                        Interpolated from MAP.
    ## 11  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 12  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 13  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 14  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 15  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 16  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 17  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 18  Mapping grade GPS unit (handheld accuracy range 12 to 40 ft)
    ## 19                                        Interpolated from MAP.
    ## 20                                        Address Matching-Other
    ## 21                                        Address Matching-Other
    ## 22                                        Address Matching-Other
    ## 23                                        Address Matching-Other
    ## 24                                        Address Matching-Other
    ## 25                                        Address Matching-Other
    ## 26                                        Address Matching-Other
    ## 27                                               GPS-Unspecified
    ## 28                                        Address Matching-Other
    ## 29                                        Address Matching-Other
    ## 30                                        Address Matching-Other
    ## 31                                        Address Matching-Other
    ## 32                                        Address Matching-Other
    ## 33                                        Address Matching-Other
    ## 34                                        Address Matching-Other
    ## 35                                        Address Matching-Other
    ## 36                                        Address Matching-Other
    ## 37                                        Address Matching-Other
    ## 38                                        Address Matching-Other
    ## 39                                        Address Matching-Other
    ## 40                                        Address Matching-Other
    ## 41                                               GPS-Unspecified
    ## 42                                        Address Matching-Other
    ## 43                                        Address Matching-Other
    ## 44                                        Address Matching-Other
    ## 45                                        Address Matching-Other
    ## 46                                        Address Matching-Other
    ## 47                                        Address Matching-Other
    ## 48                                        Address Matching-Other
    ## 49                                        Address Matching-Other
    ## 50                                        Address Matching-Other
    ## 51                                               GPS-Unspecified
    ## 52                                        Address Matching-Other
    ## 53                                        Address Matching-Other
    ## 54                                        Address Matching-Other
    ## 55                                        Address Matching-Other
    ## 56                                        Address Matching-Other
    ## 57                                        Address Matching-Other
    ## 58                                        Address Matching-Other
    ## 59                                        Address Matching-Other
    ## 60                                                       Unknown
    ## 61                                               GPS-Unspecified
    ## 62                                               GPS-Unspecified
    ## 63                                               GPS-Unspecified
    ## 64                                               GPS-Unspecified
    ## 65                                               GPS-Unspecified
    ## 66                                                       Unknown
    ## 67                                                       Unknown
    ## 68                                                       Unknown
    ## 69                                                       Unknown
    ## 70                          GPS Code (Pseudo Range) Differential
    ## 71                          GPS Code (Pseudo Range) Differential
    ## 72                          GPS Code (Pseudo Range) Differential
    ## 73                          GPS Code (Pseudo Range) Differential
    ## 74                          GPS Code (Pseudo Range) Differential
    ## 75                          GPS Code (Pseudo Range) Differential
    ## 76                          GPS Code (Pseudo Range) Differential
    ## 77                          GPS Code (Pseudo Range) Differential
    ## 78                          GPS Code (Pseudo Range) Differential
    ## 79                          GPS Code (Pseudo Range) Differential
    ## 80                          GPS Code (Pseudo Range) Differential
    ## 81                          GPS Code (Pseudo Range) Differential
    ## 82                          GPS Code (Pseudo Range) Differential
    ## 83                                               GPS-Unspecified
    ## 84                                                       Unknown
    ## 85                                               GPS-Unspecified
    ## 86                                               GPS-Unspecified
    ## 87                                               GPS-Unspecified
    ## 88                                               GPS-Unspecified
    ## 89                                               GPS-Unspecified
    ## 90                                               GPS-Unspecified
    ## 91                                               GPS-Unspecified
    ## 92                                       Interpolation-Satellite
    ## 93                                       Interpolation-Satellite
    ## 94                                       Interpolation-Satellite
    ## 95                                               GPS-Unspecified
    ## 96                                               GPS-Unspecified
    ## 97                                               GPS-Unspecified
    ## 98                                               GPS-Unspecified
    ## 99                                               GPS-Unspecified
    ## 100                                              GPS-Unspecified
    ## 101                                              GPS-Unspecified
    ## 102                                              GPS-Unspecified
    ## 103                                              GPS-Unspecified
    ## 104                                              GPS-Unspecified
    ## 105                                              GPS-Unspecified
    ## 106                                      Interpolation-Satellite
    ## 107                                      Interpolation-Satellite
    ## 108                                              GPS-Unspecified
    ## 109                                              GPS-Unspecified
    ## 110                                              GPS-Unspecified
    ## 111                                              GPS-Unspecified
    ## 112                                              GPS-Unspecified
    ## 113                                              GPS-Unspecified
    ##     HorizontalCoordinateReferenceSystemDatumName
    ## 1                                          NAD83
    ## 2                                          NAD83
    ## 3                                          NAD83
    ## 4                                          NAD83
    ## 5                                          NAD83
    ## 6                                          NAD83
    ## 7                                          NAD83
    ## 8                                          NAD83
    ## 9                                          NAD83
    ## 10                                         NAD83
    ## 11                                         NAD83
    ## 12                                         NAD83
    ## 13                                         NAD83
    ## 14                                         NAD83
    ## 15                                         NAD83
    ## 16                                         NAD83
    ## 17                                         NAD83
    ## 18                                         NAD83
    ## 19                                         NAD83
    ## 20                                         NAD83
    ## 21                                         NAD83
    ## 22                                         NAD83
    ## 23                                         NAD83
    ## 24                                         NAD83
    ## 25                                         NAD83
    ## 26                                         NAD83
    ## 27                                         NAD83
    ## 28                                         NAD83
    ## 29                                         NAD83
    ## 30                                         NAD83
    ## 31                                         NAD83
    ## 32                                         NAD83
    ## 33                                         NAD83
    ## 34                                         NAD83
    ## 35                                         NAD83
    ## 36                                         NAD83
    ## 37                                         NAD83
    ## 38                                         NAD83
    ## 39                                         NAD83
    ## 40                                         NAD83
    ## 41                                         NAD83
    ## 42                                         NAD83
    ## 43                                         NAD83
    ## 44                                         NAD83
    ## 45                                         NAD83
    ## 46                                         NAD83
    ## 47                                         NAD83
    ## 48                                         NAD83
    ## 49                                         NAD83
    ## 50                                         NAD83
    ## 51                                         NAD83
    ## 52                                         NAD83
    ## 53                                         NAD83
    ## 54                                         NAD83
    ## 55                                         NAD83
    ## 56                                         NAD83
    ## 57                                         NAD83
    ## 58                                         NAD83
    ## 59                                         NAD83
    ## 60                                         UNKWN
    ## 61                                         WGS84
    ## 62                                         WGS84
    ## 63                                         WGS84
    ## 64                                         WGS84
    ## 65                                         WGS84
    ## 66                                         UNKWN
    ## 67                                         UNKWN
    ## 68                                         UNKWN
    ## 69                                         UNKWN
    ## 70                                         WGS84
    ## 71                                         WGS84
    ## 72                                         WGS84
    ## 73                                         WGS84
    ## 74                                         WGS84
    ## 75                                         WGS84
    ## 76                                         WGS84
    ## 77                                         WGS84
    ## 78                                         WGS84
    ## 79                                         WGS84
    ## 80                                         WGS84
    ## 81                                         WGS84
    ## 82                                         WGS84
    ## 83                                         UNKWN
    ## 84                                         UNKWN
    ## 85                                         UNKWN
    ## 86                                         UNKWN
    ## 87                                         NAD83
    ## 88                                         NAD83
    ## 89                                         NAD83
    ## 90                                         NAD83
    ## 91                                         NAD83
    ## 92                                         NAD83
    ## 93                                         NAD83
    ## 94                                         NAD83
    ## 95                                         UNKWN
    ## 96                                         UNKWN
    ## 97                                         UNKWN
    ## 98                                         UNKWN
    ## 99                                         UNKWN
    ## 100                                        UNKWN
    ## 101                                        UNKWN
    ## 102                                        NAD83
    ## 103                                        NAD83
    ## 104                                        NAD83
    ## 105                                        NAD83
    ## 106                                        NAD83
    ## 107                                        NAD83
    ## 108                                        NAD83
    ## 109                                        NAD83
    ## 110                                        NAD83
    ## 111                                        NAD83
    ## 112                                        NAD83
    ## 113                                        NAD83
    ##     VerticalMeasure.MeasureValue VerticalMeasure.MeasureUnitCode
    ## 1                             NA                            <NA>
    ## 2                             NA                            <NA>
    ## 3                             NA                            <NA>
    ## 4                             NA                            <NA>
    ## 5                             NA                            <NA>
    ## 6                             NA                            <NA>
    ## 7                             NA                            <NA>
    ## 8                             NA                            <NA>
    ## 9                             NA                            <NA>
    ## 10                            NA                            <NA>
    ## 11                            NA                            <NA>
    ## 12                            NA                            <NA>
    ## 13                            NA                            <NA>
    ## 14                          3.80                            feet
    ## 15                            NA                            <NA>
    ## 16                            NA                            <NA>
    ## 17                          7.44                            feet
    ## 18                            NA                            <NA>
    ## 19                            NA                            <NA>
    ## 20                            NA                            <NA>
    ## 21                            NA                            <NA>
    ## 22                            NA                            <NA>
    ## 23                            NA                            <NA>
    ## 24                            NA                            <NA>
    ## 25                            NA                            <NA>
    ## 26                            NA                            <NA>
    ## 27                            NA                            <NA>
    ## 28                            NA                            <NA>
    ## 29                            NA                            <NA>
    ## 30                            NA                            <NA>
    ## 31                            NA                            <NA>
    ## 32                            NA                            <NA>
    ## 33                            NA                            <NA>
    ## 34                            NA                            <NA>
    ## 35                            NA                            <NA>
    ## 36                            NA                            <NA>
    ## 37                            NA                            <NA>
    ## 38                            NA                            <NA>
    ## 39                            NA                            <NA>
    ## 40                            NA                            <NA>
    ## 41                            NA                            <NA>
    ## 42                            NA                            <NA>
    ## 43                            NA                            <NA>
    ## 44                            NA                            <NA>
    ## 45                            NA                            <NA>
    ## 46                            NA                            <NA>
    ## 47                            NA                            <NA>
    ## 48                            NA                            <NA>
    ## 49                            NA                            <NA>
    ## 50                            NA                            <NA>
    ## 51                            NA                            <NA>
    ## 52                            NA                            <NA>
    ## 53                            NA                            <NA>
    ## 54                            NA                            <NA>
    ## 55                            NA                            <NA>
    ## 56                            NA                            <NA>
    ## 57                            NA                            <NA>
    ## 58                            NA                            <NA>
    ## 59                            NA                            <NA>
    ## 60                            NA                            <NA>
    ## 61                            NA                            <NA>
    ## 62                            NA                            <NA>
    ## 63                            NA                            <NA>
    ## 64                            NA                            <NA>
    ## 65                            NA                            <NA>
    ## 66                            NA                            <NA>
    ## 67                            NA                            <NA>
    ## 68                            NA                            <NA>
    ## 69                            NA                            <NA>
    ## 70                            NA                            <NA>
    ## 71                            NA                            <NA>
    ## 72                            NA                            <NA>
    ## 73                            NA                            <NA>
    ## 74                            NA                            <NA>
    ## 75                            NA                            <NA>
    ## 76                            NA                            <NA>
    ## 77                            NA                            <NA>
    ## 78                            NA                            <NA>
    ## 79                            NA                            <NA>
    ## 80                            NA                            <NA>
    ## 81                            NA                            <NA>
    ## 82                            NA                            <NA>
    ## 83                            NA                            <NA>
    ## 84                            NA                            <NA>
    ## 85                            NA                            <NA>
    ## 86                            NA                            <NA>
    ## 87                            NA                            <NA>
    ## 88                            NA                            <NA>
    ## 89                            NA                            <NA>
    ## 90                            NA                            <NA>
    ## 91                            NA                            <NA>
    ## 92                            NA                            <NA>
    ## 93                            NA                            <NA>
    ## 94                            NA                            <NA>
    ## 95                            NA                            <NA>
    ## 96                            NA                            <NA>
    ## 97                            NA                            <NA>
    ## 98                            NA                            <NA>
    ## 99                            NA                            <NA>
    ## 100                           NA                            <NA>
    ## 101                           NA                            <NA>
    ## 102                           NA                            <NA>
    ## 103                           NA                            <NA>
    ## 104                           NA                            <NA>
    ## 105                           NA                            <NA>
    ## 106                           NA                            <NA>
    ## 107                           NA                            <NA>
    ## 108                           NA                            <NA>
    ## 109                           NA                            <NA>
    ## 110                           NA                            <NA>
    ## 111                           NA                            <NA>
    ## 112                           NA                            <NA>
    ## 113                           NA                            <NA>
    ##     VerticalAccuracyMeasure.MeasureValue
    ## 1                                     NA
    ## 2                                     NA
    ## 3                                     NA
    ## 4                                     NA
    ## 5                                     NA
    ## 6                                     NA
    ## 7                                     NA
    ## 8                                     NA
    ## 9                                     NA
    ## 10                                    NA
    ## 11                                    NA
    ## 12                                    NA
    ## 13                                    NA
    ## 14                                  0.50
    ## 15                                    NA
    ## 16                                    NA
    ## 17                                  0.01
    ## 18                                    NA
    ## 19                                    NA
    ## 20                                    NA
    ## 21                                    NA
    ## 22                                    NA
    ## 23                                    NA
    ## 24                                    NA
    ## 25                                    NA
    ## 26                                    NA
    ## 27                                    NA
    ## 28                                    NA
    ## 29                                    NA
    ## 30                                    NA
    ## 31                                    NA
    ## 32                                    NA
    ## 33                                    NA
    ## 34                                    NA
    ## 35                                    NA
    ## 36                                    NA
    ## 37                                    NA
    ## 38                                    NA
    ## 39                                    NA
    ## 40                                    NA
    ## 41                                    NA
    ## 42                                    NA
    ## 43                                    NA
    ## 44                                    NA
    ## 45                                    NA
    ## 46                                    NA
    ## 47                                    NA
    ## 48                                    NA
    ## 49                                    NA
    ## 50                                    NA
    ## 51                                    NA
    ## 52                                    NA
    ## 53                                    NA
    ## 54                                    NA
    ## 55                                    NA
    ## 56                                    NA
    ## 57                                    NA
    ## 58                                    NA
    ## 59                                    NA
    ## 60                                    NA
    ## 61                                    NA
    ## 62                                    NA
    ## 63                                    NA
    ## 64                                    NA
    ## 65                                    NA
    ## 66                                    NA
    ## 67                                    NA
    ## 68                                    NA
    ## 69                                    NA
    ## 70                                    NA
    ## 71                                    NA
    ## 72                                    NA
    ## 73                                    NA
    ## 74                                    NA
    ## 75                                    NA
    ## 76                                    NA
    ## 77                                    NA
    ## 78                                    NA
    ## 79                                    NA
    ## 80                                    NA
    ## 81                                    NA
    ## 82                                    NA
    ## 83                                    NA
    ## 84                                    NA
    ## 85                                    NA
    ## 86                                    NA
    ## 87                                    NA
    ## 88                                    NA
    ## 89                                    NA
    ## 90                                    NA
    ## 91                                    NA
    ## 92                                    NA
    ## 93                                    NA
    ## 94                                    NA
    ## 95                                    NA
    ## 96                                    NA
    ## 97                                    NA
    ## 98                                    NA
    ## 99                                    NA
    ## 100                                   NA
    ## 101                                   NA
    ## 102                                   NA
    ## 103                                   NA
    ## 104                                   NA
    ## 105                                   NA
    ## 106                                   NA
    ## 107                                   NA
    ## 108                                   NA
    ## 109                                   NA
    ## 110                                   NA
    ## 111                                   NA
    ## 112                                   NA
    ## 113                                   NA
    ##     VerticalAccuracyMeasure.MeasureUnitCode
    ## 1                                      <NA>
    ## 2                                      <NA>
    ## 3                                      <NA>
    ## 4                                      <NA>
    ## 5                                      <NA>
    ## 6                                      <NA>
    ## 7                                      <NA>
    ## 8                                      <NA>
    ## 9                                      <NA>
    ## 10                                     <NA>
    ## 11                                     <NA>
    ## 12                                     <NA>
    ## 13                                     <NA>
    ## 14                                     feet
    ## 15                                     <NA>
    ## 16                                     <NA>
    ## 17                                     feet
    ## 18                                     <NA>
    ## 19                                     <NA>
    ## 20                                     <NA>
    ## 21                                     <NA>
    ## 22                                     <NA>
    ## 23                                     <NA>
    ## 24                                     <NA>
    ## 25                                     <NA>
    ## 26                                     <NA>
    ## 27                                     <NA>
    ## 28                                     <NA>
    ## 29                                     <NA>
    ## 30                                     <NA>
    ## 31                                     <NA>
    ## 32                                     <NA>
    ## 33                                     <NA>
    ## 34                                     <NA>
    ## 35                                     <NA>
    ## 36                                     <NA>
    ## 37                                     <NA>
    ## 38                                     <NA>
    ## 39                                     <NA>
    ## 40                                     <NA>
    ## 41                                     <NA>
    ## 42                                     <NA>
    ## 43                                     <NA>
    ## 44                                     <NA>
    ## 45                                     <NA>
    ## 46                                     <NA>
    ## 47                                     <NA>
    ## 48                                     <NA>
    ## 49                                     <NA>
    ## 50                                     <NA>
    ## 51                                     <NA>
    ## 52                                     <NA>
    ## 53                                     <NA>
    ## 54                                     <NA>
    ## 55                                     <NA>
    ## 56                                     <NA>
    ## 57                                     <NA>
    ## 58                                     <NA>
    ## 59                                     <NA>
    ## 60                                     <NA>
    ## 61                                     <NA>
    ## 62                                     <NA>
    ## 63                                     <NA>
    ## 64                                     <NA>
    ## 65                                     <NA>
    ## 66                                     <NA>
    ## 67                                     <NA>
    ## 68                                     <NA>
    ## 69                                     <NA>
    ## 70                                     <NA>
    ## 71                                     <NA>
    ## 72                                     <NA>
    ## 73                                     <NA>
    ## 74                                     <NA>
    ## 75                                     <NA>
    ## 76                                     <NA>
    ## 77                                     <NA>
    ## 78                                     <NA>
    ## 79                                     <NA>
    ## 80                                     <NA>
    ## 81                                     <NA>
    ## 82                                     <NA>
    ## 83                                     <NA>
    ## 84                                     <NA>
    ## 85                                     <NA>
    ## 86                                     <NA>
    ## 87                                     <NA>
    ## 88                                     <NA>
    ## 89                                     <NA>
    ## 90                                     <NA>
    ## 91                                     <NA>
    ## 92                                     <NA>
    ## 93                                     <NA>
    ## 94                                     <NA>
    ## 95                                     <NA>
    ## 96                                     <NA>
    ## 97                                     <NA>
    ## 98                                     <NA>
    ## 99                                     <NA>
    ## 100                                    <NA>
    ## 101                                    <NA>
    ## 102                                    <NA>
    ## 103                                    <NA>
    ## 104                                    <NA>
    ## 105                                    <NA>
    ## 106                                    <NA>
    ## 107                                    <NA>
    ## 108                                    <NA>
    ## 109                                    <NA>
    ## 110                                    <NA>
    ## 111                                    <NA>
    ## 112                                    <NA>
    ## 113                                    <NA>
    ##        VerticalCollectionMethodName
    ## 1                              <NA>
    ## 2                              <NA>
    ## 3                              <NA>
    ## 4                              <NA>
    ## 5                              <NA>
    ## 6                              <NA>
    ## 7                              <NA>
    ## 8                              <NA>
    ## 9                              <NA>
    ## 10                             <NA>
    ## 11                             <NA>
    ## 12                             <NA>
    ## 13                             <NA>
    ## 14                         Unknown.
    ## 15                             <NA>
    ## 16                             <NA>
    ## 17  Level or other surveyed method.
    ## 18                             <NA>
    ## 19                             <NA>
    ## 20                             <NA>
    ## 21                             <NA>
    ## 22                             <NA>
    ## 23                             <NA>
    ## 24                             <NA>
    ## 25                             <NA>
    ## 26                             <NA>
    ## 27                             <NA>
    ## 28                             <NA>
    ## 29                             <NA>
    ## 30                             <NA>
    ## 31                             <NA>
    ## 32                             <NA>
    ## 33                             <NA>
    ## 34                             <NA>
    ## 35                             <NA>
    ## 36                             <NA>
    ## 37                             <NA>
    ## 38                             <NA>
    ## 39                             <NA>
    ## 40                             <NA>
    ## 41                             <NA>
    ## 42                             <NA>
    ## 43                             <NA>
    ## 44                             <NA>
    ## 45                             <NA>
    ## 46                             <NA>
    ## 47                             <NA>
    ## 48                             <NA>
    ## 49                             <NA>
    ## 50                             <NA>
    ## 51                             <NA>
    ## 52                             <NA>
    ## 53                             <NA>
    ## 54                             <NA>
    ## 55                             <NA>
    ## 56                             <NA>
    ## 57                             <NA>
    ## 58                             <NA>
    ## 59                             <NA>
    ## 60                             <NA>
    ## 61                             <NA>
    ## 62                             <NA>
    ## 63                             <NA>
    ## 64                             <NA>
    ## 65                             <NA>
    ## 66                             <NA>
    ## 67                             <NA>
    ## 68                             <NA>
    ## 69                             <NA>
    ## 70                             <NA>
    ## 71                             <NA>
    ## 72                             <NA>
    ## 73                             <NA>
    ## 74                             <NA>
    ## 75                             <NA>
    ## 76                             <NA>
    ## 77                             <NA>
    ## 78                             <NA>
    ## 79                             <NA>
    ## 80                             <NA>
    ## 81                             <NA>
    ## 82                             <NA>
    ## 83                             <NA>
    ## 84                             <NA>
    ## 85                             <NA>
    ## 86                             <NA>
    ## 87                             <NA>
    ## 88                             <NA>
    ## 89                             <NA>
    ## 90                             <NA>
    ## 91                             <NA>
    ## 92                             <NA>
    ## 93                             <NA>
    ## 94                             <NA>
    ## 95                             <NA>
    ## 96                             <NA>
    ## 97                             <NA>
    ## 98                             <NA>
    ## 99                             <NA>
    ## 100                            <NA>
    ## 101                            <NA>
    ## 102                            <NA>
    ## 103                            <NA>
    ## 104                            <NA>
    ## 105                            <NA>
    ## 106                            <NA>
    ## 107                            <NA>
    ## 108                            <NA>
    ## 109                            <NA>
    ## 110                            <NA>
    ## 111                            <NA>
    ## 112                            <NA>
    ## 113                            <NA>
    ##     VerticalCoordinateReferenceSystemDatumName CountryCode StateCode
    ## 1                                         <NA>          US        12
    ## 2                                         <NA>          US        12
    ## 3                                         <NA>          US        12
    ## 4                                         <NA>          US        12
    ## 5                                         <NA>          US        12
    ## 6                                         <NA>          US        12
    ## 7                                         <NA>          US        12
    ## 8                                         <NA>          US        12
    ## 9                                         <NA>          US        12
    ## 10                                        <NA>          US        12
    ## 11                                        <NA>          US        12
    ## 12                                        <NA>          US        12
    ## 13                                        <NA>          US        12
    ## 14                                      NGVD29          US        12
    ## 15                                        <NA>          US        12
    ## 16                                        <NA>          US        12
    ## 17                                      NGVD29          US        12
    ## 18                                        <NA>          US        12
    ## 19                                        <NA>          US        12
    ## 20                                        <NA>          US        12
    ## 21                                        <NA>          US        12
    ## 22                                        <NA>          US        12
    ## 23                                        <NA>          US        12
    ## 24                                        <NA>          US        12
    ## 25                                        <NA>          US        12
    ## 26                                        <NA>          US        12
    ## 27                                        <NA>        <NA>        NA
    ## 28                                        <NA>          US        12
    ## 29                                        <NA>          US        12
    ## 30                                        <NA>          US        12
    ## 31                                        <NA>          US        12
    ## 32                                        <NA>          US        12
    ## 33                                        <NA>          US        12
    ## 34                                        <NA>          US        12
    ## 35                                        <NA>          US        12
    ## 36                                        <NA>          US        12
    ## 37                                        <NA>          US        12
    ## 38                                        <NA>          US        12
    ## 39                                        <NA>          US        12
    ## 40                                        <NA>          US        12
    ## 41                                        <NA>          US        12
    ## 42                                        <NA>          US        12
    ## 43                                        <NA>          US        12
    ## 44                                        <NA>          US        12
    ## 45                                        <NA>          US        12
    ## 46                                        <NA>          US        12
    ## 47                                        <NA>          US        12
    ## 48                                        <NA>          US        12
    ## 49                                        <NA>          US        12
    ## 50                                        <NA>          US        12
    ## 51                                        <NA>        <NA>        NA
    ## 52                                        <NA>          US        12
    ## 53                                        <NA>          US        12
    ## 54                                        <NA>          US        12
    ## 55                                        <NA>          US        12
    ## 56                                        <NA>          US        12
    ## 57                                        <NA>          US        12
    ## 58                                        <NA>          US        12
    ## 59                                        <NA>          US        12
    ## 60                                        <NA>        <NA>        NA
    ## 61                                        <NA>        <NA>        NA
    ## 62                                        <NA>          US        12
    ## 63                                        <NA>          US        12
    ## 64                                        <NA>          US        12
    ## 65                                        <NA>          US        12
    ## 66                                        <NA>        <NA>        NA
    ## 67                                        <NA>        <NA>        NA
    ## 68                                        <NA>        <NA>        NA
    ## 69                                        <NA>        <NA>        NA
    ## 70                                        <NA>          US        12
    ## 71                                        <NA>          US        12
    ## 72                                        <NA>          US        12
    ## 73                                        <NA>          US        12
    ## 74                                        <NA>          US        12
    ## 75                                        <NA>          US        12
    ## 76                                        <NA>          US        12
    ## 77                                        <NA>          US        12
    ## 78                                        <NA>          US        12
    ## 79                                        <NA>          US        12
    ## 80                                        <NA>          US        12
    ## 81                                        <NA>          US        12
    ## 82                                        <NA>          US        12
    ## 83                                        <NA>          US        12
    ## 84                                        <NA>          US        12
    ## 85                                        <NA>        <NA>        NA
    ## 86                                        <NA>        <NA>        NA
    ## 87                                        <NA>          US        12
    ## 88                                        <NA>          US        12
    ## 89                                        <NA>          US        12
    ## 90                                        <NA>          US        12
    ## 91                                        <NA>          US        12
    ## 92                                        <NA>          US        12
    ## 93                                        <NA>          US        12
    ## 94                                        <NA>          US        12
    ## 95                                        <NA>          US        12
    ## 96                                        <NA>          US        12
    ## 97                                        <NA>          US        12
    ## 98                                        <NA>          US        12
    ## 99                                        <NA>          US        12
    ## 100                                       <NA>          US        12
    ## 101                                       <NA>          US        12
    ## 102                                       <NA>          US        12
    ## 103                                       <NA>          US        12
    ## 104                                       <NA>          US        12
    ## 105                                       <NA>          US        12
    ## 106                                       <NA>          US        12
    ## 107                                       <NA>          US        12
    ## 108                                       <NA>        <NA>        NA
    ## 109                                       <NA>        <NA>        NA
    ## 110                                       <NA>        <NA>        NA
    ## 111                                       <NA>        <NA>        NA
    ## 112                                       <NA>        <NA>        NA
    ## 113                                       <NA>        <NA>        NA
    ##     CountyCode      AquiferName          FormationTypeText
    ## 1          086             <NA>                       <NA>
    ## 2          086             <NA>                       <NA>
    ## 3          086             <NA>                       <NA>
    ## 4          086 Biscayne aquifer Biscayne Limestone Aquifer
    ## 5          087             <NA>                       <NA>
    ## 6          087             <NA>                       <NA>
    ## 7          086             <NA>                       <NA>
    ## 8          086             <NA>                       <NA>
    ## 9          087             <NA>                       <NA>
    ## 10         086             <NA>                       <NA>
    ## 11         086             <NA>                       <NA>
    ## 12         086             <NA>                       <NA>
    ## 13         086 Biscayne aquifer Biscayne Limestone Aquifer
    ## 14         086 Biscayne aquifer Biscayne Limestone Aquifer
    ## 15         086 Biscayne aquifer Biscayne Limestone Aquifer
    ## 16         087             <NA>                       <NA>
    ## 17         086 Biscayne aquifer Biscayne Limestone Aquifer
    ## 18         087 Biscayne aquifer Biscayne Limestone Aquifer
    ## 19         086             <NA>                       <NA>
    ## 20         086             <NA>                       <NA>
    ## 21         086             <NA>                       <NA>
    ## 22         086             <NA>                       <NA>
    ## 23         087             <NA>                       <NA>
    ## 24         086             <NA>                       <NA>
    ## 25         086             <NA>                       <NA>
    ## 26         086             <NA>                       <NA>
    ## 27        <NA>             <NA>                       <NA>
    ## 28         086             <NA>                       <NA>
    ## 29         086             <NA>                       <NA>
    ## 30         086             <NA>                       <NA>
    ## 31         086             <NA>                       <NA>
    ## 32         086             <NA>                       <NA>
    ## 33         086             <NA>                       <NA>
    ## 34         086             <NA>                       <NA>
    ## 35         086             <NA>                       <NA>
    ## 36         086             <NA>                       <NA>
    ## 37         086             <NA>                       <NA>
    ## 38         086             <NA>                       <NA>
    ## 39         086             <NA>                       <NA>
    ## 40         086             <NA>                       <NA>
    ## 41         086             <NA>                       <NA>
    ## 42         086             <NA>                       <NA>
    ## 43         086             <NA>                       <NA>
    ## 44         086             <NA>                       <NA>
    ## 45         086             <NA>                       <NA>
    ## 46         086             <NA>                       <NA>
    ## 47         086             <NA>                       <NA>
    ## 48         086             <NA>                       <NA>
    ## 49         086             <NA>                       <NA>
    ## 50         086             <NA>                       <NA>
    ## 51        <NA>             <NA>                       <NA>
    ## 52         086             <NA>                       <NA>
    ## 53         086             <NA>                       <NA>
    ## 54         086             <NA>                       <NA>
    ## 55         086             <NA>                       <NA>
    ## 56         011             <NA>                       <NA>
    ## 57         086             <NA>                       <NA>
    ## 58         086             <NA>                       <NA>
    ## 59         086             <NA>                       <NA>
    ## 60        <NA>             <NA>                       <NA>
    ## 61        <NA>             <NA>                       <NA>
    ## 62         051             <NA>                       <NA>
    ## 63         086             <NA>                       <NA>
    ## 64         086             <NA>                       <NA>
    ## 65         086             <NA>                       <NA>
    ## 66        <NA>             <NA>                       <NA>
    ## 67        <NA>             <NA>                       <NA>
    ## 68        <NA>             <NA>                       <NA>
    ## 69        <NA>             <NA>                       <NA>
    ## 70         011             <NA>                       <NA>
    ## 71         021             <NA>                       <NA>
    ## 72         051             <NA>                       <NA>
    ## 73         099             <NA>                       <NA>
    ## 74         021             <NA>                       <NA>
    ## 75         011             <NA>                       <NA>
    ## 76         021             <NA>                       <NA>
    ## 77         011             <NA>                       <NA>
    ## 78         099             <NA>                       <NA>
    ## 79         011             <NA>                       <NA>
    ## 80         011             <NA>                       <NA>
    ## 81         086             <NA>                       <NA>
    ## 82         099             <NA>                       <NA>
    ## 83         086             <NA>                       <NA>
    ## 84         086             <NA>                       <NA>
    ## 85        <NA>             <NA>                       <NA>
    ## 86        <NA>             <NA>                       <NA>
    ## 87         086             <NA>                       <NA>
    ## 88         086             <NA>                       <NA>
    ## 89         086             <NA>                       <NA>
    ## 90         086             <NA>                       <NA>
    ## 91         086             <NA>                       <NA>
    ## 92         086             <NA>                       <NA>
    ## 93         086             <NA>                       <NA>
    ## 94         086             <NA>                       <NA>
    ## 95         086             <NA>                       <NA>
    ## 96         086             <NA>                       <NA>
    ## 97         086             <NA>                       <NA>
    ## 98         086             <NA>                       <NA>
    ## 99         086             <NA>                       <NA>
    ## 100        086             <NA>                       <NA>
    ## 101        011             <NA>                       <NA>
    ## 102        011             <NA>                       <NA>
    ## 103        099             <NA>                       <NA>
    ## 104        099             <NA>                       <NA>
    ## 105        011             <NA>                       <NA>
    ## 106        011             <NA>                       <NA>
    ## 107        011             <NA>                       <NA>
    ## 108       <NA>             <NA>                       <NA>
    ## 109       <NA>             <NA>                       <NA>
    ## 110       <NA>             <NA>                       <NA>
    ## 111       <NA>             <NA>                       <NA>
    ## 112       <NA>             <NA>                       <NA>
    ## 113       <NA>             <NA>                       <NA>
    ##               AquiferTypeName ConstructionDateText
    ## 1                        <NA>                   NA
    ## 2                        <NA>                   NA
    ## 3                        <NA>                   NA
    ## 4                        <NA>             20031015
    ## 5                        <NA>                   NA
    ## 6                        <NA>                   NA
    ## 7                        <NA>                   NA
    ## 8                        <NA>                   NA
    ## 9                        <NA>                   NA
    ## 10                       <NA>                   NA
    ## 11                       <NA>                   NA
    ## 12                       <NA>                   NA
    ## 13                       <NA>             20020130
    ## 14  Unconfined single aquifer                   NA
    ## 15                       <NA>             20121206
    ## 16                       <NA>                   NA
    ## 17  Unconfined single aquifer                   NA
    ## 18                       <NA>                   NA
    ## 19                       <NA>                   NA
    ## 20                       <NA>                   NA
    ## 21                       <NA>                   NA
    ## 22                       <NA>                   NA
    ## 23                       <NA>                   NA
    ## 24                       <NA>                   NA
    ## 25                       <NA>                   NA
    ## 26                       <NA>                   NA
    ## 27                       <NA>                   NA
    ## 28                       <NA>                   NA
    ## 29                       <NA>                   NA
    ## 30                       <NA>                   NA
    ## 31                       <NA>                   NA
    ## 32                       <NA>                   NA
    ## 33                       <NA>                   NA
    ## 34                       <NA>                   NA
    ## 35                       <NA>                   NA
    ## 36                       <NA>                   NA
    ## 37                       <NA>                   NA
    ## 38                       <NA>                   NA
    ## 39                       <NA>                   NA
    ## 40                       <NA>                   NA
    ## 41                       <NA>                   NA
    ## 42                       <NA>                   NA
    ## 43                       <NA>                   NA
    ## 44                       <NA>                   NA
    ## 45                       <NA>                   NA
    ## 46                       <NA>                   NA
    ## 47                       <NA>                   NA
    ## 48                       <NA>                   NA
    ## 49                       <NA>                   NA
    ## 50                       <NA>                   NA
    ## 51                       <NA>                   NA
    ## 52                       <NA>                   NA
    ## 53                       <NA>                   NA
    ## 54                       <NA>                   NA
    ## 55                       <NA>                   NA
    ## 56                       <NA>                   NA
    ## 57                       <NA>                   NA
    ## 58                       <NA>                   NA
    ## 59                       <NA>                   NA
    ## 60                       <NA>                   NA
    ## 61                       <NA>                   NA
    ## 62                       <NA>                   NA
    ## 63                       <NA>                   NA
    ## 64                       <NA>                   NA
    ## 65                       <NA>                   NA
    ## 66                       <NA>                   NA
    ## 67                       <NA>                   NA
    ## 68                       <NA>                   NA
    ## 69                       <NA>                   NA
    ## 70                       <NA>                   NA
    ## 71                       <NA>                   NA
    ## 72                       <NA>                   NA
    ## 73                       <NA>                   NA
    ## 74                       <NA>                   NA
    ## 75                       <NA>                   NA
    ## 76                       <NA>                   NA
    ## 77                       <NA>                   NA
    ## 78                       <NA>                   NA
    ## 79                       <NA>                   NA
    ## 80                       <NA>                   NA
    ## 81                       <NA>                   NA
    ## 82                       <NA>                   NA
    ## 83                       <NA>                   NA
    ## 84                       <NA>                   NA
    ## 85                       <NA>                   NA
    ## 86                       <NA>                   NA
    ## 87                       <NA>                   NA
    ## 88                       <NA>                   NA
    ## 89                       <NA>                   NA
    ## 90                       <NA>                   NA
    ## 91                       <NA>                   NA
    ## 92                       <NA>                   NA
    ## 93                       <NA>                   NA
    ## 94                       <NA>                   NA
    ## 95                       <NA>                   NA
    ## 96                       <NA>                   NA
    ## 97                       <NA>                   NA
    ## 98                       <NA>                   NA
    ## 99                       <NA>                   NA
    ## 100                      <NA>                   NA
    ## 101                      <NA>                   NA
    ## 102                      <NA>                   NA
    ## 103                      <NA>                   NA
    ## 104                      <NA>                   NA
    ## 105                      <NA>                   NA
    ## 106                      <NA>                   NA
    ## 107                      <NA>                   NA
    ## 108                      <NA>                   NA
    ## 109                      <NA>                   NA
    ## 110                      <NA>                   NA
    ## 111                      <NA>                   NA
    ## 112                      <NA>                   NA
    ## 113                      <NA>                   NA
    ##     WellDepthMeasure.MeasureValue WellDepthMeasure.MeasureUnitCode
    ## 1                              NA                             <NA>
    ## 2                              NA                             <NA>
    ## 3                              NA                             <NA>
    ## 4                           10.10                               ft
    ## 5                              NA                             <NA>
    ## 6                              NA                             <NA>
    ## 7                              NA                             <NA>
    ## 8                              NA                             <NA>
    ## 9                              NA                             <NA>
    ## 10                             NA                             <NA>
    ## 11                             NA                             <NA>
    ## 12                             NA                             <NA>
    ## 13                          12.77                               ft
    ## 14                          87.00                               ft
    ## 15                          10.70                               ft
    ## 16                             NA                             <NA>
    ## 17                          75.10                               ft
    ## 18                          10.20                               ft
    ## 19                             NA                             <NA>
    ## 20                             NA                             <NA>
    ## 21                             NA                             <NA>
    ## 22                             NA                             <NA>
    ## 23                             NA                             <NA>
    ## 24                             NA                             <NA>
    ## 25                             NA                             <NA>
    ## 26                             NA                             <NA>
    ## 27                             NA                             <NA>
    ## 28                             NA                             <NA>
    ## 29                             NA                             <NA>
    ## 30                             NA                             <NA>
    ## 31                             NA                             <NA>
    ## 32                             NA                             <NA>
    ## 33                             NA                             <NA>
    ## 34                             NA                             <NA>
    ## 35                             NA                             <NA>
    ## 36                             NA                             <NA>
    ## 37                             NA                             <NA>
    ## 38                             NA                             <NA>
    ## 39                             NA                             <NA>
    ## 40                             NA                             <NA>
    ## 41                             NA                             <NA>
    ## 42                             NA                             <NA>
    ## 43                             NA                             <NA>
    ## 44                             NA                             <NA>
    ## 45                             NA                             <NA>
    ## 46                             NA                             <NA>
    ## 47                             NA                             <NA>
    ## 48                             NA                             <NA>
    ## 49                             NA                             <NA>
    ## 50                             NA                             <NA>
    ## 51                             NA                             <NA>
    ## 52                             NA                             <NA>
    ## 53                             NA                             <NA>
    ## 54                             NA                             <NA>
    ## 55                             NA                             <NA>
    ## 56                             NA                             <NA>
    ## 57                             NA                             <NA>
    ## 58                             NA                             <NA>
    ## 59                             NA                             <NA>
    ## 60                             NA                             <NA>
    ## 61                             NA                             <NA>
    ## 62                             NA                             <NA>
    ## 63                             NA                             <NA>
    ## 64                             NA                             <NA>
    ## 65                             NA                             <NA>
    ## 66                             NA                             <NA>
    ## 67                             NA                             <NA>
    ## 68                             NA                             <NA>
    ## 69                             NA                             <NA>
    ## 70                             NA                             <NA>
    ## 71                             NA                             <NA>
    ## 72                             NA                             <NA>
    ## 73                             NA                             <NA>
    ## 74                             NA                             <NA>
    ## 75                             NA                             <NA>
    ## 76                             NA                             <NA>
    ## 77                             NA                             <NA>
    ## 78                             NA                             <NA>
    ## 79                             NA                             <NA>
    ## 80                             NA                             <NA>
    ## 81                             NA                             <NA>
    ## 82                             NA                             <NA>
    ## 83                             NA                             <NA>
    ## 84                             NA                             <NA>
    ## 85                             NA                             <NA>
    ## 86                             NA                             <NA>
    ## 87                             NA                             <NA>
    ## 88                             NA                             <NA>
    ## 89                             NA                             <NA>
    ## 90                             NA                             <NA>
    ## 91                             NA                             <NA>
    ## 92                             NA                             <NA>
    ## 93                             NA                             <NA>
    ## 94                             NA                             <NA>
    ## 95                             NA                             <NA>
    ## 96                             NA                             <NA>
    ## 97                             NA                             <NA>
    ## 98                             NA                             <NA>
    ## 99                             NA                             <NA>
    ## 100                            NA                             <NA>
    ## 101                            NA                             <NA>
    ## 102                            NA                             <NA>
    ## 103                            NA                             <NA>
    ## 104                            NA                             <NA>
    ## 105                            NA                             <NA>
    ## 106                            NA                             <NA>
    ## 107                            NA                             <NA>
    ## 108                            NA                             <NA>
    ## 109                            NA                             <NA>
    ## 110                            NA                             <NA>
    ## 111                            NA                             <NA>
    ## 112                            NA                             <NA>
    ## 113                            NA                             <NA>
    ##     WellHoleDepthMeasure.MeasureValue WellHoleDepthMeasure.MeasureUnitCode
    ## 1                                  NA                                 <NA>
    ## 2                                  NA                                 <NA>
    ## 3                                  NA                                 <NA>
    ## 4                                  NA                                 <NA>
    ## 5                                  NA                                 <NA>
    ## 6                                  NA                                 <NA>
    ## 7                                  NA                                 <NA>
    ## 8                                  NA                                 <NA>
    ## 9                                  NA                                 <NA>
    ## 10                                 NA                                 <NA>
    ## 11                                 NA                                 <NA>
    ## 12                                 NA                                 <NA>
    ## 13                                 NA                                 <NA>
    ## 14                                 99                                   ft
    ## 15                                 NA                                 <NA>
    ## 16                                 NA                                 <NA>
    ## 17                                 76                                   ft
    ## 18                                 NA                                 <NA>
    ## 19                                 NA                                 <NA>
    ## 20                                 NA                                 <NA>
    ## 21                                 NA                                 <NA>
    ## 22                                 NA                                 <NA>
    ## 23                                 NA                                 <NA>
    ## 24                                 NA                                 <NA>
    ## 25                                 NA                                 <NA>
    ## 26                                 NA                                 <NA>
    ## 27                                 NA                                 <NA>
    ## 28                                 NA                                 <NA>
    ## 29                                 NA                                 <NA>
    ## 30                                 NA                                 <NA>
    ## 31                                 NA                                 <NA>
    ## 32                                 NA                                 <NA>
    ## 33                                 NA                                 <NA>
    ## 34                                 NA                                 <NA>
    ## 35                                 NA                                 <NA>
    ## 36                                 NA                                 <NA>
    ## 37                                 NA                                 <NA>
    ## 38                                 NA                                 <NA>
    ## 39                                 NA                                 <NA>
    ## 40                                 NA                                 <NA>
    ## 41                                 NA                                 <NA>
    ## 42                                 NA                                 <NA>
    ## 43                                 NA                                 <NA>
    ## 44                                 NA                                 <NA>
    ## 45                                 NA                                 <NA>
    ## 46                                 NA                                 <NA>
    ## 47                                 NA                                 <NA>
    ## 48                                 NA                                 <NA>
    ## 49                                 NA                                 <NA>
    ## 50                                 NA                                 <NA>
    ## 51                                 NA                                 <NA>
    ## 52                                 NA                                 <NA>
    ## 53                                 NA                                 <NA>
    ## 54                                 NA                                 <NA>
    ## 55                                 NA                                 <NA>
    ## 56                                 NA                                 <NA>
    ## 57                                 NA                                 <NA>
    ## 58                                 NA                                 <NA>
    ## 59                                 NA                                 <NA>
    ## 60                                 NA                                 <NA>
    ## 61                                 NA                                 <NA>
    ## 62                                 NA                                 <NA>
    ## 63                                 NA                                 <NA>
    ## 64                                 NA                                 <NA>
    ## 65                                 NA                                 <NA>
    ## 66                                 NA                                 <NA>
    ## 67                                 NA                                 <NA>
    ## 68                                 NA                                 <NA>
    ## 69                                 NA                                 <NA>
    ## 70                                 NA                                 <NA>
    ## 71                                 NA                                 <NA>
    ## 72                                 NA                                 <NA>
    ## 73                                 NA                                 <NA>
    ## 74                                 NA                                 <NA>
    ## 75                                 NA                                 <NA>
    ## 76                                 NA                                 <NA>
    ## 77                                 NA                                 <NA>
    ## 78                                 NA                                 <NA>
    ## 79                                 NA                                 <NA>
    ## 80                                 NA                                 <NA>
    ## 81                                 NA                                 <NA>
    ## 82                                 NA                                 <NA>
    ## 83                                 NA                                 <NA>
    ## 84                                 NA                                 <NA>
    ## 85                                 NA                                 <NA>
    ## 86                                 NA                                 <NA>
    ## 87                                 NA                                 <NA>
    ## 88                                 NA                                 <NA>
    ## 89                                 NA                                 <NA>
    ## 90                                 NA                                 <NA>
    ## 91                                 NA                                 <NA>
    ## 92                                 NA                                 <NA>
    ## 93                                 NA                                 <NA>
    ## 94                                 NA                                 <NA>
    ## 95                                 NA                                 <NA>
    ## 96                                 NA                                 <NA>
    ## 97                                 NA                                 <NA>
    ## 98                                 NA                                 <NA>
    ## 99                                 NA                                 <NA>
    ## 100                                NA                                 <NA>
    ## 101                                NA                                 <NA>
    ## 102                                NA                                 <NA>
    ## 103                                NA                                 <NA>
    ## 104                                NA                                 <NA>
    ## 105                                NA                                 <NA>
    ## 106                                NA                                 <NA>
    ## 107                                NA                                 <NA>
    ## 108                                NA                                 <NA>
    ## 109                                NA                                 <NA>
    ## 110                                NA                                 <NA>
    ## 111                                NA                                 <NA>
    ## 112                                NA                                 <NA>
    ## 113                                NA                                 <NA>
    ##     ProviderName
    ## 1           NWIS
    ## 2           NWIS
    ## 3           NWIS
    ## 4           NWIS
    ## 5           NWIS
    ## 6           NWIS
    ## 7           NWIS
    ## 8           NWIS
    ## 9           NWIS
    ## 10          NWIS
    ## 11          NWIS
    ## 12          NWIS
    ## 13          NWIS
    ## 14          NWIS
    ## 15          NWIS
    ## 16          NWIS
    ## 17          NWIS
    ## 18          NWIS
    ## 19          NWIS
    ## 20        STORET
    ## 21        STORET
    ## 22        STORET
    ## 23        STORET
    ## 24        STORET
    ## 25        STORET
    ## 26        STORET
    ## 27        STORET
    ## 28        STORET
    ## 29        STORET
    ## 30        STORET
    ## 31        STORET
    ## 32        STORET
    ## 33        STORET
    ## 34        STORET
    ## 35        STORET
    ## 36        STORET
    ## 37        STORET
    ## 38        STORET
    ## 39        STORET
    ## 40        STORET
    ## 41        STORET
    ## 42        STORET
    ## 43        STORET
    ## 44        STORET
    ## 45        STORET
    ## 46        STORET
    ## 47        STORET
    ## 48        STORET
    ## 49        STORET
    ## 50        STORET
    ## 51        STORET
    ## 52        STORET
    ## 53        STORET
    ## 54        STORET
    ## 55        STORET
    ## 56        STORET
    ## 57        STORET
    ## 58        STORET
    ## 59        STORET
    ## 60        STORET
    ## 61        STORET
    ## 62        STORET
    ## 63        STORET
    ## 64        STORET
    ## 65        STORET
    ## 66        STORET
    ## 67        STORET
    ## 68        STORET
    ## 69        STORET
    ## 70        STORET
    ## 71        STORET
    ## 72        STORET
    ## 73        STORET
    ## 74        STORET
    ## 75        STORET
    ## 76        STORET
    ## 77        STORET
    ## 78        STORET
    ## 79        STORET
    ## 80        STORET
    ## 81        STORET
    ## 82        STORET
    ## 83        STORET
    ## 84        STORET
    ## 85        STORET
    ## 86        STORET
    ## 87        STORET
    ## 88        STORET
    ## 89        STORET
    ## 90        STORET
    ## 91        STORET
    ## 92        STORET
    ## 93        STORET
    ## 94        STORET
    ## 95        STORET
    ## 96        STORET
    ## 97        STORET
    ## 98        STORET
    ## 99        STORET
    ## 100       STORET
    ## 101       STORET
    ## 102       STORET
    ## 103       STORET
    ## 104       STORET
    ## 105       STORET
    ## 106       STORET
    ## 107       STORET
    ## 108       STORET
    ## 109       STORET
    ## 110       STORET
    ## 111       STORET
    ## 112       STORET
    ## 113       STORET

``` r
# Look at the variable information
attr(data, "variableInfo")
```

    ##     parameterCd characteristicName param_units valueType
    ## 1         00010 Temperature, water       deg C      <NA>
    ## 108        <NA> Temperature, water       deg C      <NA>
    ## 109        <NA> Temperature, water       deg C     Total
    ##                             description characteristicname measureunitcode
    ## 1   Temperature, water, degrees Celsius Temperature, water           deg C
    ## 108                                <NA>               <NA>            <NA>
    ## 109                                <NA>               <NA>            <NA>
    ##     resultsamplefraction resulttemperaturebasis resultstatisticalbasis
    ## 1                                                                     
    ## 108                 <NA>                   <NA>                   <NA>
    ## 109                 <NA>                   <NA>                   <NA>
    ##     resulttimebasis resultweightbasis resultparticlesizebasis last_rev_dt
    ## 1                                                              2008-02-21
    ## 108            <NA>              <NA>                    <NA>        <NA>
    ## 109            <NA>              <NA>                    <NA>        <NA>
    ##     parameter_group_nm                        parameter_nm casrn
    ## 1             Physical Temperature, water, degrees Celsius  <NA>
    ## 108               <NA>                                <NA>  <NA>
    ## 109               <NA>                                <NA>  <NA>
    ##                srsname parameter_units
    ## 1   Temperature, water           deg C
    ## 108               <NA>            <NA>
    ## 109               <NA>            <NA>

You can now find and download Water Quality Portal data from R!
