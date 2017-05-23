---
author: Lindsay R. Carr
date: 9999-11-01
slug: dataRetrieval-readNWIS
title: dataRetrieval - readNWIS
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 3
---
readNWIS functions
------------------

**The following material is IN DEVELOPMENT**

We have learned how to discover data available in NWIS, but now we will look at how to retrieve data. There are many functions to do this, see the table below for a description of each. Each variation of `readNWIS` is accessing a different web service. For a definition and more information on each of these services, please see <https://waterservices.usgs.gov/rest/>. Also, refer to the previous lesson for a description of the major arguments to `readNWIS` functions.

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="3" style="text-align: left;">
Table 1. readNWIS function definitions
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
<a href="#readnwisdata">readNWISdata</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Most general NWIS data import function. User must explicitly define the service parameter. More flexible than the other functions.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
..., asDateTime, convertType, tz
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
<a href="#readnwisdv">readNWISdv</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Returns time-series data summarized to a day. Default is mean daily.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
siteNumber, parameterCd, startDate, endDate, statCd
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readnwisgwl">readNWISgwl</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Groundwater levels.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
siteNumbers, startDate, endDate, convertType, tz
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
<a href="#readnwismeas">readNWISmeas</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Surface water measurements.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
siteNumbers, startDate, endDate, tz, expanded, convertType
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readnwispcode">readNWISpCode</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Metadata information for one or many parameter codes.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
parameterCd
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
<a href="#readnwispeak">readNWISpeak</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Annual maximum instantaneous streamflows and gage heights.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
siteNumbers, startDate, endDate, asDateTime, convertType
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readnwisqw">readNWISqw</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Discrete water quality data.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
siteNumbers, parameterCd, startDate, endDate, expanded, reshape, tz
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
<a href="#readnwisrating">readNWISrating</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Rating table information for active stream gages
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
siteNumber, type, convertType
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readnwissite">readNWISsite</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Site metadata information
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
siteNumbers
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
<a href="#readnwisstat">readNWISstat</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Daily, monthly, or annual statistics for time-series data. Default is mean daily.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
siteNumbers, parameterCd, startDate, endDate, convertType, statReportType, statType
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
<a href="#readnwisuse">readNWISuse</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Data from the USGS National Water Use Program.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
stateCd, countyCd, years, categories, convertType, transform
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
<a href="#readnwisuv">readNWISuv</a>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
Returns time-series data reported from the USGS Instantaneous Values Web Service.
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
siteNumbers, parameterCd, startDate, endDate, tz
</td>
</tr>
</tbody>
</table>

Each service-specific function is a wrapper for the more flexible `readNWISdata`. They set a default for the service argument and have limited user defined arguments. All `readNWIS` functions require a "major filter" as an argument, but `readNWISdata` can accept any major filter while others are limited to site numbers or state/county codes (see Table 1 for more info).

Other major filters that can be used in `readNWISdata` include hydrologic unit codes (`huc`) and bounding boxes (`bBox`). More information about major filters can be found in the [NWIS web services documentation](https://waterservices.usgs.gov/rest/Site-Service.html#Major_Filters).

The following are examples of how to use each of the readNWIS family of functions. Don't forget to load the `dataRetrieval` library if you are in a new session.

1.  [readNWISdata, county major filter](#readnwisdata-county)
2.  [readNWISdata, huc major filter](#readnwisdata-huc)
3.  [readNWISdata, bbox major filter](#readnwisdata-bbox)
4.  [readNWISdv](#readnwisdv)
5.  [readNWISgwl](#readnwisgwl)
6.  [readNWISmeas](#readnwismeas)
7.  [readNWISpCode](#readnwispcode)
8.  [readNWISpeak](#readnwispeak)
9.  [readNWISqw, multiple sites](#readnwisqw-multsite)
10. [readNWISqw, multiple parameters](#readnwisqw-multparm)
11. [readNWISrating, using base table](#readnwisrating-base)
12. [readNWISrating, corrected table](#readnwisrating-corr)
13. [readNWISrating, exsa?](#readnwisrating-exsa)
14. [readNWISsite](#readnwissite)
15. [readNWISstat](#readnwisstat)
16. [readNWISuse](#readnwisuse)
17. [readNWISuv](#readnwisuv)

### readNWISdata

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 2. readNWISdata argument definitions
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
see for a complete list of options. A list of arguments can also be supplied. One important argument to include is 'service'. Possible values are "iv" (for instantaneous), "dv" (for daily values), "gwlevels" (for groundwater levels), "site" (for site service), "qw" (water-quality),"measurement", and "stat" (for statistics service). Note: "qw" and "measurement" calls go to: for data requests, and use different call requests schemes. The statistics service has a limited selection of arguments (see ).
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
asDateTime
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
logical, if returns date and time as POSIXct, if , Date
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
logical, defaults to . If , the function will convert the data to dates, datetimes, numerics based on a standard algorithm. If false, everything is returned as a character
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
timezone as a character string. See for a list of possibilities.
</td>
</tr>
</tbody>
</table>
<a name="readnwisdata-county"></a>

**Historic mean daily streamflow for sites in Maui County, Hawaii.**

``` r
# Major filter: Maui County 
## need to also include the state when using counties as the major filter
# Service: daily value, dv
# Parameter code: streamflow in cfs, 00060

MauiCo_avgdailyQ <- readNWISdata(stateCd="Hawaii", countyCd="Maui", service="dv", parameterCd="00060")
head(MauiCo_avgdailyQ)
```

    ##   agency_cd  site_no   dateTime X_00060_00003 X_00060_00003_cd tz_cd
    ## 1      USGS 16400000 2017-04-17         184.0                P   UTC
    ## 2      USGS 16401000 1929-08-31          18.0                A   UTC
    ## 3      USGS 16402000 1957-07-31          51.0                A   UTC
    ## 4      USGS 16403000 1957-06-30           5.5                A   UTC
    ## 5      USGS 16403600 1970-09-30           2.4                A   UTC
    ## 6      USGS 16403900 1996-09-30           1.3                A   UTC

``` r
# How many sites are returned?
length(unique(MauiCo_avgdailyQ$site_no))
```

    ## [1] 128

<a name="readnwisdata-huc"></a>

**Historic minimum water temperatures for the HUC8 corresponding to the island of Maui, Hawaii.**

To see all HUCs available, visit <https://water.usgs.gov/GIS/huc_name.html>. The default statistic for daily values in `readNWISdata` is to return the max (00001), min (00002), and mean (00003). We will specify the minimum only for this example. You will need to use the statistic code, not the name. For all the available statistic codes, see the [statType web service documentation](https://waterservices.usgs.gov/rest/Statistics-Service.html#statType) and [NWIS table mapping statistic names to codes](https://help.waterdata.usgs.gov/stat_code). Caution! In `readNWISdata` and `readNWISdv` the argument is called `statCd`, but in `readNWISstat` the argument is `statType`.

``` r
# Major filter: HUC 8 for Maui, 20020000
# Service: daily value, dv
# Statistic: minimum, 00002
# Parameter code: water temperature in deg C, 00010

MauiHUC8_mindailyT <- readNWISdata(huc="20020000", service="dv", statCd="00002", parameterCd="00010")
head(MauiHUC8_mindailyT)
```

    ##   agency_cd  site_no   dateTime X_00010_00002 X_00010_00002_cd tz_cd
    ## 1      USGS 16508000 2003-11-24          17.4                A   UTC
    ## 2      USGS 16516000 2003-11-24          16.3                A   UTC
    ## 3      USGS 16520000 2004-04-14          17.5                A   UTC
    ## 4      USGS 16527000 2004-01-13          15.4                A   UTC
    ## 5      USGS 16555000 2004-01-13          16.4                A   UTC
    ## 6      USGS 16618000 2017-04-17          18.1                P   UTC

``` r
# How many sites are returned?
length(unique(MauiHUC8_mindailyT$site_no))
```

    ## [1] 47

<a name="readnwisdata-bbox"></a>

**Total nitrogen in mg/L for last 30 days around Great Salt Lake in Utah.**

This example uses `Sys.Date` to get the most recent date, so your dates will differ. To get any data around Great Salt Lake, we will use a bounding box as the major filter. The bounding box must be a vector of decimal numbers indicating the western longitude, southern latitude, eastern longitude, and then northern latitude. The vector must be in that order.

``` r
# Major filter: bounding box around Great Salt Lake 
# Service: water quality, qw
# Parameter code: total nitrogen in mg/L, 00600
# Beginning: this past 30 days, use Sys.Date()

prev30days <- Sys.Date() - 30
SaltLake_totalN <- readNWISdata(bBox=c(-113.0428, 40.6474, -112.0265, 41.7018), service="qw", 
                           parameterCd="00600", startDate=prev30days)
# This service returns a lot of columns:
names(SaltLake_totalN)
```

    ##  [1] "agency_cd"                          
    ##  [2] "site_no"                            
    ##  [3] "sample_dt"                          
    ##  [4] "sample_tm"                          
    ##  [5] "sample_end_dt"                      
    ##  [6] "sample_end_tm"                      
    ##  [7] "sample_start_time_datum_cd_reported"
    ##  [8] "tm_datum_rlbty_cd"                  
    ##  [9] "coll_ent_cd"                        
    ## [10] "medium_cd"                          
    ## [11] "tu_id"                              
    ## [12] "body_part_id"                       
    ## [13] "p00003"                             
    ## [14] "p00004"                             
    ## [15] "p00009"                             
    ## [16] "p00010"                             
    ## [17] "p00020"                             
    ## [18] "p00025"                             
    ## [19] "p00061"                             
    ## [20] "p00063"                             
    ## [21] "p00065"                             
    ## [22] "p00095"                             
    ## [23] "p00098"                             
    ## [24] "p00191"                             
    ## [25] "p00300"                             
    ## [26] "p00301"                             
    ## [27] "p00400"                             
    ## [28] "p30207"                             
    ## [29] "p30209"                             
    ## [30] "p50015"                             
    ## [31] "p50280"                             
    ## [32] "p70305"                             
    ## [33] "p71999"                             
    ## [34] "p72104"                             
    ## [35] "p72263"                             
    ## [36] "p81904"                             
    ## [37] "p82398"                             
    ## [38] "p84164"                             
    ## [39] "p84171"                             
    ## [40] "p99111"                             
    ## [41] "p99156"                             
    ## [42] "p99206"                             
    ## [43] "startDateTime"                      
    ## [44] "sample_start_time_datum_cd"

``` r
# How many sites are returned?
length(unique(SaltLake_totalN$site_no))
```

    ## [1] 6

### readNWISdv

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 3. readNWISdv argument definitions
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
siteNumber
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character USGS site number. This is usually an 8 digit number. Multiple sites can be requested with a character vector.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character of USGS parameter code(s). This is usually an 5 digit number. See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
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
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
statCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character USGS statistic code. This is usually 5 digits. Daily mean (00003) is the default. See [NWIS help for statistic codes](https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html).
</td>
</tr>
</tbody>
</table>
<a name="readnwisdv"></a>

**Minimum and maximum pH daily data for a site on the Missouri River near Townsend, MT.**

``` r
# Remember, you can always use whatNWISdata to see what is available at the site before querying
mt_available <- whatNWISdata(siteNumber="462107111312301", service="dv", parameterCd="00400")
head(mt_available)
```

    ##    parm_cd agency_cd         site_no
    ## 13   00400      USGS 462107111312301
    ## 14   00400      USGS 462107111312301
    ## 16   00400      USGS 462107111312301
    ##                                    station_nm site_tp_cd dec_lat_va
    ## 13 Missouri River ab Canyon Ferry nr Townsend         ST   46.35188
    ## 14 Missouri River ab Canyon Ferry nr Townsend         ST   46.35188
    ## 16 Missouri River ab Canyon Ferry nr Townsend         ST   46.35188
    ##    dec_long_va coord_acy_cd dec_coord_datum_cd alt_va alt_acy_va
    ## 13   -111.5239            S              NAD83   3790         20
    ## 14   -111.5239            S              NAD83   3790         20
    ## 16   -111.5239            S              NAD83   3790         20
    ##    alt_datum_cd   huc_cd data_type_cd stat_cd ts_id loc_web_ds
    ## 13       NGVD29 10030101           dv   00008 82220       <NA>
    ## 14       NGVD29 10030101           dv   00001 82218       <NA>
    ## 16       NGVD29 10030101           dv   00002 82219       <NA>
    ##    medium_grp_cd parm_grp_cd   srs_id access_cd begin_date   end_date
    ## 13           wat        <NA> 17028275         0 2010-08-18 2011-09-21
    ## 14           wat        <NA> 17028275         0 2010-08-18 2011-09-21
    ## 16           wat        <NA> 17028275         0 2010-08-18 2011-09-21
    ##    count_nu parameter_group_nm
    ## 13       72           Physical
    ## 14       72           Physical
    ## 16       72           Physical
    ##                                    parameter_nm casrn srsname
    ## 13 pH, water, unfiltered, field, standard units  <NA>      pH
    ## 14 pH, water, unfiltered, field, standard units  <NA>      pH
    ## 16 pH, water, unfiltered, field, standard units  <NA>      pH
    ##    parameter_units
    ## 13       std units
    ## 14       std units
    ## 16       std units

``` r
# Major filter: site number, 462107111312301
# Statistic: minimum and maximum, 00001 and 00002
# Parameter: pH, 00400
mt_site_pH <- readNWISdv(siteNumber="462107111312301", parameterCd="00400", 
                         statCd=c("00001", "00002"))
head(mt_site_pH)
```

    ##   agency_cd         site_no       Date X_00400_00001 X_00400_00001_cd
    ## 1      USGS 462107111312301 2010-08-18           8.9                A
    ## 2      USGS 462107111312301 2010-08-19           8.9                A
    ## 3      USGS 462107111312301 2010-08-20           8.9                A
    ## 4      USGS 462107111312301 2010-08-21           8.9                A
    ## 5      USGS 462107111312301 2010-08-22           8.8                A
    ## 6      USGS 462107111312301 2010-08-23           8.9                A
    ##   X_00400_00002 X_00400_00002_cd
    ## 1           8.3                A
    ## 2           8.3                A
    ## 3           8.4                A
    ## 4           8.4                A
    ## 5           8.4                A
    ## 6           8.4                A

### readNWISgwl

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 4. readNWISgwl argument definitions
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
character USGS site number (or multiple sites). This is usually an 8 digit number
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character starting date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the earliest possible record.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character ending date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
logical, defaults to . If , the function will convert the data to dates, datetimes, numerics based on a standard algorithm. If false, everything is returned as a character
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character to set timezone attribute of dateTime. Default is an empty quote, which converts the dateTimes to UTC (properly accounting for daylight savings times based on the data's provided tz\_cd column). Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage","America/Honolulu","America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla"
</td>
</tr>
</tbody>
</table>
<a name="readnwisgwl"></a>

**Historic groundwater levels for a site near Portland, Oregon.**

``` r
# Major filter: site number, 452840122302202
or_site_gwl <- readNWISgwl(siteNumbers="452840122302202")
head(or_site_gwl)
```

    ##   agency_cd         site_no site_tp_cd     lev_dt lev_tm
    ## 1      USGS 452840122302202         GW 1988-03-14   <NA>
    ## 2      USGS 452840122302202         GW 1988-04-05  10:50
    ## 3      USGS 452840122302202         GW 1988-06-16  15:00
    ## 4      USGS 452840122302202         GW 1988-07-19  15:33
    ## 5      USGS 452840122302202         GW 1988-08-30  15:20
    ## 6      USGS 452840122302202         GW 1988-10-03  14:39
    ##   lev_tz_cd_reported lev_va sl_lev_va sl_datum_cd lev_status_cd
    ## 1               <NA>   9.78      <NA>        <NA>          <NA>
    ## 2                PDT   8.77      <NA>        <NA>          <NA>
    ## 3                PDT  10.59      <NA>        <NA>          <NA>
    ## 4                PDT  11.62      <NA>        <NA>          <NA>
    ## 5                PDT  12.13      <NA>        <NA>          <NA>
    ## 6                PDT  12.25      <NA>        <NA>          <NA>
    ##   lev_agency_cd        lev_dateTime lev_tz_cd
    ## 1          <NA>                <NA>       UTC
    ## 2          <NA> 1988-04-05 17:50:00       UTC
    ## 3          <NA> 1988-06-16 22:00:00       UTC
    ## 4          <NA> 1988-07-19 22:33:00       UTC
    ## 5          <NA> 1988-08-30 22:20:00       UTC
    ## 6          <NA> 1988-10-03 21:39:00       UTC

### readNWISmeas

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 5. readNWISmeas argument definitions
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
character USGS site number (or multiple sites). This is usually an 8 digit number
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character starting date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the earliest possible record.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character ending date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character to set timezone attribute of dateTime. Default is an empty quote, which converts the dateTimes to UTC (properly accounting for daylight savings times based on the data's provided tz\_cd column). Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage","America/Honolulu","America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla"
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
expanded
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
logical. Whether or not (TRUE or FALSE) to call the expanded data.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
logical, defaults to . If , the function will convert the data to dates, datetimes, numerics based on a standard algorithm. If false, everything is returned as a character
</td>
</tr>
</tbody>
</table>
<a name="readnwismeas"></a>

**Historic surface water measurements for a site near Dade City, Florida.**

``` r
# Major filter: site number, 02311500
fl_site_meas <- readNWISmeas(siteNumbers="02311500")
# Names of columns returned:
names(fl_site_meas)
```

    ##  [1] "agency_cd"                 "site_no"                  
    ##  [3] "measurement_nu"            "measurement_dt"           
    ##  [5] "measurement_tm"            "tz_cd_reported"           
    ##  [7] "q_meas_used_fg"            "party_nm"                 
    ##  [9] "site_visit_coll_agency_cd" "gage_height_va"           
    ## [11] "discharge_va"              "current_rating_nu"        
    ## [13] "shift_adj_va"              "diff_from_rating_pc"      
    ## [15] "measured_rating_diff"      "gage_va_change"           
    ## [17] "gage_va_time"              "control_type_cd"          
    ## [19] "discharge_cd"              "measurement_dateTime"     
    ## [21] "tz_cd"

### readNWISpCode

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 6. readNWISpCode argument definitions
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
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character of USGS parameter codes (or multiple parameter codes). These are 5 digit number codes, more information can be found here: . To get a complete list of all current parameter codes in the USGS, use "all" as the input. See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
</td>
</tr>
</tbody>
</table>
<a name="readnwispcode"></a>

**Get information about the parameters gage height, specific conductance, and total phosphorus.**

This function only has one argument, the parameter code. You can supply one or multiple and you will get a dataframe with information about each parameter.

``` r
# gage height, 00065
readNWISpCode("00065")
```

    ##      parameter_cd parameter_group_nm      parameter_nm casrn      srsname
    ## 1405        00065           Physical Gage height, feet  <NA> Height, gage
    ##      parameter_units
    ## 1405              ft

``` r
# specific conductance and total phosphorus, 00095 and 00665
readNWISpCode(c("00095", "00665"))
```

    ##      parameter_cd parameter_group_nm
    ## 1420        00095           Physical
    ## 2553        00665           Nutrient
    ##                                                                                    parameter_nm
    ## 1420 Specific conductance, water, unfiltered, microsiemens per centimeter at 25 degrees Celsius
    ## 2553                          Phosphorus, water, unfiltered, milligrams per liter as phosphorus
    ##          casrn              srsname parameter_units
    ## 1420      <NA> Specific conductance      uS/cm @25C
    ## 2553 7723-14-0           Phosphorus       mg/l as P

### readNWISpeak

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 7. readNWISpeak argument definitions
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
character USGS site number(or multiple sites). This is usually an 8 digit number.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character starting date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the earliest possible record.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character ending date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
asDateTime
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
logical default to . When , the peak\_dt column is converted to a Date object, and incomplete dates are removed. When , no columns are removed, but no dates are converted.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
logical, defaults to . If , the function will convert the data to dates, datetimes, numerics based on a standard algorithm. If false, everything is returned as a character
</td>
</tr>
</tbody>
</table>
<a name="readnwispeak"></a>

**Peak flow values for a site near Cassia, Florida.**

The default settings will return data where the date of the peak flow is known. To see peak flows with incomplete dates, change `convertType` to `FALSE`.

``` r
# Major filter: site number, 02235200
fl_site_peak <- readNWISpeak(siteNumbers="02235200")
fl_site_peak$peak_dt
```

    ##  [1] "1962-10-06" "1964-09-13" "1965-08-11" "1966-08-15" "1967-08-30"
    ##  [6] "1968-09-01" "1968-10-22" "1969-10-05" "1971-02-10" "1972-04-02"
    ## [11] "1973-09-16" "1974-09-07" "1975-09-01" "1976-06-06" NA          
    ## [16] "1978-08-08" "1979-09-29" "1980-04-04" "1981-09-18" "1982-04-12"
    ## [21] "1983-04-24" "1984-04-11" "1985-09-21" "1986-01-14" "1987-04-01"
    ## [26] "1988-09-11" "1989-01-24" "1990-02-27" "1991-06-02" "1991-10-08"
    ## [31] "1993-03-27" "1994-09-12" "1994-11-18" "1995-10-12" "1996-10-12"
    ## [36] "1998-02-21" "1998-10-05" "1999-10-08" "2001-09-17" "2002-08-16"
    ## [41] "2003-03-10" "2004-09-13" "2004-10-01" "2005-10-25" "2007-07-21"
    ## [46] "2008-08-26" "2009-05-26" "2010-03-16" "2011-04-07" "2012-08-30"
    ## [51] "2012-10-08" "2014-07-31" "2015-09-20" "2016-02-06"

``` r
# Compare complete with incomplete days
fl_site_peak_incomp <- readNWISpeak(siteNumbers="02235200",convertType = FALSE)
fl_site_peak_incomp$peak_dt[is.na(fl_site_peak$peak_dt)]
```

    ## [1] "1977-00-00"

### readNWISqw

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 8. readNWISqw argument definitions
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
character of USGS site numbers. This is usually an 8 digit number
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character that contains the code for a parameter group, or a character vector of 5-digit parameter codes. See . See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
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
expanded
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
logical defaults to . If , retrieves additional information. Expanded data includes remark\_cd (remark code), result\_va (result value), val\_qual\_tx (result value qualifier code), meth\_cd (method code), dqi\_cd (data-quality indicator code), rpt\_lev\_va (reporting level), and rpt\_lev\_cd (reporting level type). If , only returns remark\_cd (remark code) and result\_va (result value). Expanded = will not give sufficient information for unbiased statistical analysis.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
reshape
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
logical, reshape the expanded data. If , then return a wide data frame with all water-quality in a single row for each sample. If (default), then return a long data frame with each water-quality result in a single row. This argument is only applicable to expanded data. Data requested using is always returned in the wide format.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character to set timezone attribute of output columns: startDateTime and endDateTime. Default is an empty quote, which converts the datetimes to UTC (properly accounting for daylight savings times). Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage","America/Honolulu","America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla"
</td>
</tr>
</tbody>
</table>
<a name="readnwisqw-multsite"></a>

**Dissolved oxygen for two sites near the Columbia River in Oregon for water year 2016**

``` r
# Major filter: site numbers, 455415119314601 and 454554119121801
# Parameter: dissolved oxygen in mg/L, 00300
# Begin date: October 1, 2015
# End date: September 30, 2016

or_site_do <- readNWISqw(siteNumbers=c("455415119314601", "454554119121801"), parameterCd="00300",
                        startDate="2015-10-01", endDate="2016-09-30")
ncol(or_site_do)
```

    ## [1] 35

``` r
head(or_site_do[,c("site_no","sample_dt","result_va")])
```

    ##           site_no  sample_dt result_va
    ## 1 455415119314601 2015-10-14       2.2
    ## 2 455415119314601 2015-10-28       0.7
    ## 3 455415119314601 2016-03-18       0.1
    ## 4 455415119314601 2016-04-21       0.4
    ## 5 455415119314601 2016-06-22       0.5
    ## 6 455415119314601 2016-07-28       0.0

<a name="readnwisqw-multparm"></a>

**Post Clean Water Act lead and mercury levels in McGaw, Ohio.**

``` r
# Major filter: site number, 03237280
# Parameter: mercury and lead in micrograms/liter, 71890 and 01049
# Begin date: January 1, 1972

oh_site_cwa <- readNWISqw(siteNumbers="03237280", 
                          parameterCd=c("71890", "01049"),
                          startDate="1972-01-01")
nrow(oh_site_cwa)
```

    ## [1] 76

``` r
ncol(oh_site_cwa)
```

    ## [1] 35

``` r
head(oh_site_cwa[,c("parm_cd","sample_dt","result_va")])
```

    ##   parm_cd  sample_dt result_va
    ## 1   01049 1972-06-20       0.0
    ## 2   01049 1973-06-21        NA
    ## 3   71890 1973-06-21       0.5
    ## 4   01049 1973-10-31        NA
    ## 5   71890 1973-10-31       0.5
    ## 6   01049 1980-03-04      10.0

### readNWISrating

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 9. readNWISrating argument definitions
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
siteNumber
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character USGS site number. This is usually an 8 digit number
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
type
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character can be "base", "corr", or "exsa"
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
logical, defaults to . If , the function will convert the data to dates, datetimes, numerics based on a standard algorithm. If false, everything is returned as a character
</td>
</tr>
</tbody>
</table>
<a name="readnwisrating"></a>

**Rating table for Mississippi River at St. Louis, MO**

There are three different types of rating table results that can be accessed using the argument `type`. They are `base`, `corr`, and `exsa`. For `type=="base"` (the default), the result is a data frame with 3 columns: `INDEP`, `DEP`, and `STOR`. For `type=="corr"`, the resulting data frame will have 3 columns: `INDEP`, `CORR`, and `CORRINDEP`. For `type=="exsa"`, the data frame will have 4 columns: `INDEP`, `DEP`, `STOR`, and `SHIFT`. See below for defintions of each column.

-   `INDEP` is the gage height in feet
-   `DEP` is the streamflow in cubic feet per second
-   `STOR` ?
-   `SHIFT` indicates shifting in rating for the corresponding `INDEP` value
-   `CORR` are the corrected values of `INDEP`
-   `CORRINDEP` are the corrected values of `CORR`

There are also a number of attributes associated with the data.frame returned - `url`, `queryTime`, `comment`, `siteInfo`, and `RATING`. `RATING` will only be included when `type` is `base`. See [this section](#accessing-attributes) for how to access attributes of `dataRetrieval` data frames.

``` r
# Major filter: site number, 07010000
# Type: default, base 

miss_rating_base <- readNWISrating(siteNumber="07010000")
head(miss_rating_base)
```

    ##    INDEP        DEP STOR
    ## 1 -10.01   31961.29    *
    ## 2  11.75  200384.50    *
    ## 3  25.00  400400.00    *
    ## 4  34.34  600000.00    *
    ## 5  45.18  919697.20    *
    ## 6  50.00 1100000.00    *

``` r
# Major filter: site number, 07010000
# Type: corr 

miss_rating_corr <- readNWISrating(siteNumber="07010000", type="corr")
head(miss_rating_corr)
```

    ##    INDEP CORR CORRINDEP
    ## 1 -10.01    0    -10.01
    ## 2 -10.00    0    -10.00
    ## 3  -9.99    0     -9.99
    ## 4  -9.98    0     -9.98
    ## 5  -9.97    0     -9.97
    ## 6  -9.96    0     -9.96

``` r
# Major filter: site number, 07010000
# Type: exsa 

miss_rating_exsa <- readNWISrating(siteNumber="07010000", type="exsa")
head(miss_rating_exsa)
```

    ##    INDEP SHIFT      DEP STOR
    ## 1 -10.01     0 31961.29    *
    ## 2 -10.00     0 32002.44 <NA>
    ## 3  -9.99     0 32043.63 <NA>
    ## 4  -9.98     0 32084.84 <NA>
    ## 5  -9.97     0 32126.08 <NA>
    ## 6  -9.96     0 32167.35 <NA>

### readNWISsite

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 10. readNWISsite argument definitions
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
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
siteNumbers
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character USGS site number (or multiple sites). This is usually an 8 digit number
</td>
</tr>
</tbody>
</table>
<a name="readnwissite"></a>

**Get metadata information for a site in Bronx, NY**

``` r
# site number, 01302020

readNWISsite(siteNumbers="01302020")
```

    ##   agency_cd  site_no                                     station_nm
    ## 1      USGS 01302020 BRONX RIVER AT NY BOTANICAL GARDEN AT BRONX NY
    ##   site_tp_cd   lat_va  long_va dec_lat_va dec_long_va coord_meth_cd
    ## 1         ST 405144.3 735227.8   40.86231   -73.87439             N
    ##   coord_acy_cd coord_datum_cd dec_coord_datum_cd district_cd state_cd
    ## 1            1          NAD83              NAD83          36       36
    ##   county_cd country_cd land_net_ds       map_nm map_scale_fc alt_va
    ## 1       005         US        <NA> FLUSHING, NY        24000     50
    ##   alt_meth_cd alt_acy_va alt_datum_cd   huc_cd basin_cd topo_cd
    ## 1           N        1.6       NAVD88 02030102     <NA>    <NA>
    ##                   instruments_cd construction_dt inventory_dt
    ## 1 YNNNYNNNNYNNNNNNNNNNNNNNNNNNNN            <NA>         <NA>
    ##   drain_area_va contrib_drain_area_va tz_cd local_time_fg reliability_cd
    ## 1          38.4                    NA   EST             N           <NA>
    ##   gw_file_cd nat_aqfr_cd aqfr_cd aqfr_type_cd well_depth_va hole_depth_va
    ## 1       <NA>        <NA>    <NA>         <NA>            NA            NA
    ##   depth_src_cd project_no
    ## 1         <NA>  44369RA00

### readNWISstat

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 11. readNWISstat argument definitions
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
character USGS site number (or multiple sites). This is usually an 8 digit number.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character USGS parameter code. This is usually a 5 digit number. See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character starting date for data retrieval in the form YYYY, YYYY-MM, or YYYY-MM-DD. Dates cannot be more specific than the statReportType, i.e. startDate for monthly statReportTypes cannot include days, and annual statReportTypes cannot include days or months. Months and days are optional for the daily statReportType. Default is "" which indicates retrieval for the earliest possible record. For daily data, this indicates the start of the period the statistics will be computed over.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character ending date for data retrieval in the form YYYY, YYYY-MM, or YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record. For daily data, this indicates the end of the period the statistics will be computed over. The same restrictions as startDate apply.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
logical, defaults to . If , the function will convert the data to numerics based on a standard algorithm. Years, months, and days (if appliccable) are also returned as numerics in separate columns. If convertType is false, everything is returned as a character.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
statReportType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character time division for statistics: daily, monthly, or annual. Default is daily. Note that daily provides statistics for each calendar day over the specified range of water years, i.e. no more than 366 data points will be returned for each site/parameter. Use readNWISdata or readNWISdv for daily averages. Also note that 'annual' returns statistics for the calendar year. Use readNWISdata for water years. Monthly and yearly provide statistics for each month and year within the range indivually.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
statType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character type(s) of statistics to output for daily values. Default is mean, which is the only option for monthly and yearly report types. See the statistics service documentation at for a full list of codes.
</td>
</tr>
</tbody>
</table>
<a name="readnwisstat"></a>

**Historic annual average discharge near Mississippi River outlet**

The [NWIS Statistics web service](https://waterservices.usgs.gov/rest/Statistics-Service.html) is currently in Beta mode, so use at your own discretion. Additionally, "mean" is the only `statType` that can be used for annual or monthly report types at this time.

``` r
# Major filter: site number, 07374525
# Parameter: discharge in cfs, 00060
# Time division: annual
# Statistic: average, "mean"

mississippi_avgQ <- readNWISstat(siteNumbers="07374525", parameterCd="00060", 
                                 statReportType="annual", statType="mean")
head(mississippi_avgQ)
```

    ##   agency_cd  site_no parameter_cd ts_id loc_web_ds year_nu mean_va
    ## 1      USGS 07374525        00060 61182       <NA>    2009  618800
    ## 2      USGS 07374525        00060 61182       <NA>    2010  563700
    ## 3      USGS 07374525        00060 61182       <NA>    2012  362100
    ## 4      USGS 07374525        00060 61182       <NA>    2014  489000
    ## 5      USGS 07374525        00060 61182       <NA>    2015  625800

### readNWISuse

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 12. readNWISuse argument definitions
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
stateCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
could be character (full name, abbreviation, id), or numeric (id). Only one is accepted per query.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
countyCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
could be character (name, with or without "County", or "ALL"), numeric (id), or codeNULL, which will return state or national data depending on the stateCd argument. may also be supplied, which will return data for every county in a state. Can be a vector of counties in the same state.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
years
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
integer Years for data retrieval. Must be years ending in 0 or 5. Default is all available years.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
categories
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character categories of water use. Defaults to . Specific categories must be supplied as two- letter abbreviations as seen in the URL when using the NWIS water use web interface.
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
convertType
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
logical defaults to . If , the function will convert the data to numerics based on a standard algorithm. Years, months, and days (if appliccable) are also returned as numerics in separate columns. If convertType is false, everything is returned as a character.
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
transform
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
logical only intended for use with national data. Defaults to , with data being returned as presented by the web service. If , data will be transformed and returned with column names, which will reformat national data to be similar to state data.
</td>
</tr>
</tbody>
</table>
The water use data web service requires a state and/or county as the major filter. The default will return all years and all categories available. The following table shows the water-use categories and their corresponding abbreviation for county and state data. Note that categories have changed over time, and vary by data sets requested. National and site-specific data sets exist, but only county/state data are available through this service. Please visit the [USGS National Water Use Information Program website](https://water.usgs.gov/watuse/) for more information.

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 3. Water-use category names and abbreviations.
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Name
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Abbreviation
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Aquaculture
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
AQ
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Commercial
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
CO
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Domestic
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
DO
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Hydroelectric Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
HY
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Irrigation, Crop
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
IC
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Irrigation, Golf Courses
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
IG
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Industrial
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
IN
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Total Irrigation
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
IT
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Livestock (Animal Specialties)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
LA
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Livestock
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
LI
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Livestock (Stock)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
LS
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Mining
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
MI
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Other Industrial
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
OI
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Thermoelectric Power (Closed-loop cooling)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
PC
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Fossil-fuel Thermoelectric Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
PF
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Geothermal Thermoelectric Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
PG
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Nuclear Thermoelectric Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
PN
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Thermoelectric Power (Once-through cooling)
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
PO
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Public Supply
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
PS
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Total Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
PT
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Total Thermoelectric Power
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
PT
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
Reservoir Evaporation
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
RE
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
Total Population
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
TP
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
Wastewater Treatment
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
WW
</td>
</tr>
</tbody>
</table>
<a name="readnwisuse"></a>

**Las Vegas historic water use**

``` r
# Major filter: Clark County, NV
# Water-use category: public supply, PS
vegas_wu <- readNWISuse(stateCd="NV", countyCd="Clark", categories="PS")
ncol(vegas_wu)
```

    ## [1] 26

``` r
names(vegas_wu)
```

    ##  [1] "state_cd"                                                                
    ##  [2] "state_name"                                                              
    ##  [3] "county_cd"                                                               
    ##  [4] "county_nm"                                                               
    ##  [5] "year"                                                                    
    ##  [6] "Public.Supply.population.served.by.groundwater..in.thousands"            
    ##  [7] "Public.Supply.population.served.by.surface.water..in.thousands"          
    ##  [8] "Public.Supply.total.population.served..in.thousands"                     
    ##  [9] "Public.Supply.self.supplied.groundwater.withdrawals..fresh..in.Mgal.d"   
    ## [10] "Public.Supply.self.supplied.groundwater.withdrawals..saline..in.Mgal.d"  
    ## [11] "Public.Supply.total.self.supplied.withdrawals..groundwater..in.Mgal.d"   
    ## [12] "Public.Supply.self.supplied.surface.water.withdrawals..fresh..in.Mgal.d" 
    ## [13] "Public.Supply.self.supplied.surface.water.withdrawals..saline..in.Mgal.d"
    ## [14] "Public.Supply.total.self.supplied.withdrawals..surface.water..in.Mgal.d" 
    ## [15] "Public.Supply.total.self.supplied.withdrawals..fresh..in.Mgal.d"         
    ## [16] "Public.Supply.total.self.supplied.withdrawals..saline..in.Mgal.d"        
    ## [17] "Public.Supply.total.self.supplied.withdrawals..total..in.Mgal.d"         
    ## [18] "Public.Supply.deliveries.to.domestic..in.Mgal.d"                         
    ## [19] "Public.Supply.deliveries.to.commercial..in.Mgal.d"                       
    ## [20] "Public.Supply.deliveries.to.industrial..in.Mgal.d"                       
    ## [21] "Public.Supply.deliveries.to.thermoelectric..in.Mgal.d"                   
    ## [22] "Public.Supply.total.deliveries..in.Mgal.d"                               
    ## [23] "Public.Supply.public.use.and.losses..in.Mgal.d"                          
    ## [24] "Public.Supply.per.capita.use..in.gallons.person.day"                     
    ## [25] "Public.Supply.reclaimed.wastewater..in.Mgal.d"                           
    ## [26] "Public.Supply.number.of.facilities"

``` r
head(vegas_wu[,1:7])
```

    ##   state_cd state_name county_cd    county_nm year
    ## 1       32     Nevada       003 Clark County 1985
    ## 2       32     Nevada       003 Clark County 1990
    ## 3       32     Nevada       003 Clark County 1995
    ## 4       32     Nevada       003 Clark County 2000
    ## 5       32     Nevada       003 Clark County 2005
    ## 6       32     Nevada       003 Clark County 2010
    ##   Public.Supply.population.served.by.groundwater..in.thousands
    ## 1                                                      149.770
    ## 2                                                      108.140
    ## 3                                                      128.010
    ## 4                                                      176.850
    ## 5                                                            -
    ## 6                                                            -
    ##   Public.Supply.population.served.by.surface.water..in.thousands
    ## 1                                                        402.210
    ## 2                                                        618.000
    ## 3                                                        844.060
    ## 4                                                       1169.600
    ## 5                                                              -
    ## 6                                                              -

### readNWISuv

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 13. readNWISuv argument definitions
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
character USGS site number (or multiple sites). This is usually an 8 digit number
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
parameterCd
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character USGS parameter code. This is usually an 5 digit number. See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
startDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
character starting date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the earliest possible record. Simple date arguments are specified in local time. See more information here: .
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
endDate
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
character ending date for data retrieval in the form YYYY-MM-DD. Default is "" which indicates retrieval for the latest possible record. Simple date arguments are specified in local time. See more information here: .
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
tz
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
character to set timezone attribute of dateTime. Default is an empty quote, which converts the dateTimes to UTC (properly accounting for daylight savings times based on the data's provided tz\_cd column). Possible values to provide are "America/New\_York","America/Chicago", "America/Denver","America/Los\_Angeles", "America/Anchorage","America/Honolulu","America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla"
</td>
</tr>
</tbody>
</table>
<a name="readnwisuv"></a>

**Turbidity and discharge for April 2016 near Lake Tahoe in California.**

``` r
# Major filter: site number, 10336676
# Parameter: discharge in cfs and turbidity in FNU, 00060 and 63680
# Begin date: April 1, 2016
# End date: April 30, 2016

ca_site_do <- readNWISuv(siteNumbers="10336676", parameterCd=c("00060", "63680"),
                         startDate="2016-04-01", endDate="2016-04-30")
nrow(ca_site_do)
```

    ## [1] 2880

``` r
head(ca_site_do)
```

    ##   agency_cd  site_no            dateTime X_00060_00000 X_00060_00000_cd
    ## 1      USGS 10336676 2016-04-01 07:00:00            29                A
    ## 2      USGS 10336676 2016-04-01 07:15:00            28                A
    ## 3      USGS 10336676 2016-04-01 07:30:00            28                A
    ## 4      USGS 10336676 2016-04-01 07:45:00            29                A
    ## 5      USGS 10336676 2016-04-01 08:00:00            29                A
    ## 6      USGS 10336676 2016-04-01 08:15:00            28                A
    ##   X_63680_00000 X_63680_00000_cd tz_cd
    ## 1           1.2                A   UTC
    ## 2           1.3                A   UTC
    ## 3           1.2                A   UTC
    ## 4           1.1                A   UTC
    ## 5           1.2                A   UTC
    ## 6           1.3                A   UTC

Additional Features
-------------------

### Accessing attributes

`dataRetrieval` returns a lot of useful information as "attributes" to the data returned. This includes site metadata information, the NWIS url used, date and time the query was performed, and more. First, you want to use `attributes()` to see what information is available. It returns a list of all the metadata information. Then you can use `attr()` to actually get that information. Let's use the base rating table example from before to illustrate this. It has a special attribute called "RATING".

``` r
# Major filter: site number, 07010000
# Type: default, base 
miss_rating_base <- readNWISrating(siteNumber="07010000")

# how many attributes are there and what are they?
length(attributes(miss_rating_base))
```

    ## [1] 9

``` r
names(attributes(miss_rating_base))
```

    ## [1] "class"     "row.names" "names"     "comment"   "queryTime" "url"      
    ## [7] "header"    "RATING"    "siteInfo"

``` r
# look at the site info
attr(miss_rating_base, "siteInfo")
```

    ##   agency_cd  site_no                         station_nm site_tp_cd
    ## 1      USGS 07010000 Mississippi River at St. Louis, MO         ST
    ##     lat_va  long_va dec_lat_va dec_long_va coord_meth_cd coord_acy_cd
    ## 1 383744.4 901047.2     38.629   -90.17978             N            5
    ##   coord_datum_cd dec_coord_datum_cd district_cd state_cd county_cd
    ## 1          NAD83              NAD83          29       29       510
    ##   country_cd             land_net_ds       map_nm map_scale_fc alt_va
    ## 1         US       S   T45N  R07E  5 GRANITE CITY        24000 379.58
    ##   alt_meth_cd alt_acy_va alt_datum_cd   huc_cd basin_cd topo_cd
    ## 1           L       0.05       NAVD88 07140101     <NA>    <NA>
    ##                   instruments_cd construction_dt inventory_dt
    ## 1 NNNNYNNNNNNNNNNNNNNNNNNNNNNNNN            <NA>     19891229
    ##   drain_area_va contrib_drain_area_va tz_cd local_time_fg reliability_cd
    ## 1        697000                    NA   CST             Y              C
    ##   gw_file_cd nat_aqfr_cd aqfr_cd aqfr_type_cd well_depth_va hole_depth_va
    ## 1   NNNNNNNN        <NA>    <NA>         <NA>            NA            NA
    ##   depth_src_cd project_no
    ## 1         <NA>       <NA>

``` r
# now look at the special RATING attribute
attr(miss_rating_base, "RATING")
```

    ## [1] "ID=18.0"                                                    
    ## [2] "TYPE=STGQ"                                                  
    ## [3] "NAME=stage-discharge"                                       
    ## [4] "AGING=Working"                                              
    ## [5] "REMARKS= developed for trend left of rating in the 35'range"
    ## [6] "EXPANSION=logarithmic"                                      
    ## [7] "OFFSET1=-2.800000E+01"

All attributes are an R object once you extract them. They can be lists, data.frames, vectors, etc. If we want to use information from one of the attributes, index it just like you would any other object of that type. For example, we want the drainage area for this Mississippi site:

``` r
# save site info metadata as its own object
miss_site_info <- attr(miss_rating_base, "siteInfo")
class(miss_site_info)
```

    ## [1] "data.frame"

``` r
# extract the drainage area
miss_site_info$drain_area_va
```

    ## [1] 697000

### Using lists as input

`readNWISdata` allows users to give a list of named arguments as the input to the call. This is especially handy if you would like to build up a list of arguments and use it in multiple calls. This only works in `readNWISdata`, none of the other `readNWIS...` functions have this ability.

``` r
chicago_q_args <- list(siteNumbers=c("05537500", "05536358", "05531045"),
                       startDate="2015-10-01",
                       endDate="2015-12-31",
                       parameterCd="00060")

# query for unit value data with those arguments
chicago_q_uv <- readNWISdata(chicago_q_args, service="uv")
nrow(chicago_q_uv)
```

    ## [1] 14488

``` r
# same query but for daily values
chicago_q_dv <- readNWISdata(chicago_q_args, service="dv")
nrow(chicago_q_dv)
```

    ## [1] 92

### Helper functions

There are currently 3 helper functions: renameNWIScolumns, addWaterYear, and zeroPad. `renameNWIScolumns` takes some of the default column names and makes them more human-readable (e.g. "X\_00060\_00000" becomes "Flow\_Inst"). `addWaterYear` adds an additional column of integers indicating the water year. `zeroPad` is used to add leading zeros to any string that is missing them, and is not restricted to `dataRetrieval` output.

**renameNWIScolumns**

`renameNWIScolumns` can be used in two ways: it can be a standalone function following the `dataRetrieval` call or it can be piped (as long as `magrittr` or `dplyr` are loaded). Both examples are shown below. Note that `renameNWIScolumns` is intended for use with columns named using pcodes. It does not work with all possible data returned.

``` r
# get discharge and temperature data for July 2016 in Ft Worth, TX
ftworth_qt_july <- readNWISuv(siteNumbers="08048000", parameterCd=c("00060", "00010"), 
                              startDate="2016-07-01", endDate="2016-07-31")
names(ftworth_qt_july)
```

    ## [1] "agency_cd"        "site_no"          "dateTime"        
    ## [4] "X_00010_00000"    "X_00010_00000_cd" "X_00060_00000"   
    ## [7] "X_00060_00000_cd" "tz_cd"

``` r
# now rename columns
ftworth_qt_july_renamed <- renameNWISColumns(ftworth_qt_july)
names(ftworth_qt_july_renamed)
```

    ## [1] "agency_cd"     "site_no"       "dateTime"      "Wtemp_Inst"   
    ## [5] "Wtemp_Inst_cd" "Flow_Inst"     "Flow_Inst_cd"  "tz_cd"

Now try with a pipe. Remember to load a packge that uses `%>%`.

``` r
library(magrittr)

# get discharge and temperature data for July 2016 in Ft Worth, TX
# pipe straight into rename function
ftworth_qt_july_pipe <- readNWISuv(siteNumbers="08048000", parameterCd=c("00060", "00010"), 
                                   startDate="2016-07-01", endDate="2016-07-31") %>% 
  renameNWISColumns()

names(ftworth_qt_july_pipe)
```

    ## [1] "agency_cd"     "site_no"       "dateTime"      "Wtemp_Inst"   
    ## [5] "Wtemp_Inst_cd" "Flow_Inst"     "Flow_Inst_cd"  "tz_cd"

**addWaterYear**

Similar to `renameNWIScolumns`, `addWaterYear` can be used as a standalone function or with a pipe. This function defines a water year as October 1 of the previous year to September 30 of the current year. Additionally, `addWaterYear` is limited to data.frames with date columns titled "dateTime", "Date", "ActivityStartDate", and "ActivityEndDate".

``` r
# mean daily discharge on the Colorado River in Grand Canyon National Park for fall of 2014
# The dates in Sept should be water year 2014, but the dates in Oct and Nov are water year 2015
co_river_q_fall <- readNWISdv(siteNumber="09403850", parameterCd="00060", 
                              startDate="2014-09-28", endDate="2014-11-30")
head(co_river_q_fall)
```

    ##   agency_cd  site_no       Date X_00060_00003 X_00060_00003_cd
    ## 1      USGS 09403850 2014-09-28         195.0                A
    ## 2      USGS 09403850 2014-09-29         241.0                A
    ## 3      USGS 09403850 2014-09-30         224.0                A
    ## 4      USGS 09403850 2014-10-01          37.0                A
    ## 5      USGS 09403850 2014-10-02          22.0                A
    ## 6      USGS 09403850 2014-10-03           9.2                A

``` r
# now add the water year column
co_river_q_fall_wy <- addWaterYear(co_river_q_fall)
head(co_river_q_fall_wy)
```

    ##   agency_cd  site_no       Date waterYear X_00060_00003 X_00060_00003_cd
    ## 1      USGS 09403850 2014-09-28      2014         195.0                A
    ## 2      USGS 09403850 2014-09-29      2014         241.0                A
    ## 3      USGS 09403850 2014-09-30      2014         224.0                A
    ## 4      USGS 09403850 2014-10-01      2015          37.0                A
    ## 5      USGS 09403850 2014-10-02      2015          22.0                A
    ## 6      USGS 09403850 2014-10-03      2015           9.2                A

``` r
unique(co_river_q_fall_wy$waterYear)
```

    ## [1] 2014 2015

Now try with a pipe.

``` r
# mean daily discharge on the Colorado River in Grand Canyon National Park for fall of 2014
# pipe straight into rename function
co_river_q_fall_pipe <- readNWISdv(siteNumber="09403850", parameterCd="00060", 
                              startDate="2014-09-01", endDate="2014-11-30") %>% 
  addWaterYear()

names(co_river_q_fall_pipe)
```

    ## [1] "agency_cd"        "site_no"          "Date"            
    ## [4] "waterYear"        "X_00060_00003"    "X_00060_00003_cd"

``` r
head(co_river_q_fall_pipe)
```

    ##   agency_cd  site_no       Date waterYear X_00060_00003 X_00060_00003_cd
    ## 1      USGS 09403850 2014-09-01      2014             4              A e
    ## 2      USGS 09403850 2014-09-02      2014             4              A e
    ## 3      USGS 09403850 2014-09-03      2014             4              A e
    ## 4      USGS 09403850 2014-09-04      2014             4              A e
    ## 5      USGS 09403850 2014-09-05      2014             4              A e
    ## 6      USGS 09403850 2014-09-06      2014             4              A e

**zeroPad**

`zeroPad` is designed to work on any string, so it is not specific to `dataRetrieval` data.frame output like the previous helper functions. Oftentimes, when reading in Excel or other local data, leading zeros are dropped from site numbers. This function allows you to put them back in. `x` is the string you would like to pad, and `padTo` is the total number of characters the string should have. For instance if an 8-digit site number was read in as numeric, we could pad that by:

``` r
siteNum <- 02121500
class(siteNum)
```

    ## [1] "numeric"

``` r
siteNum
```

    ## [1] 2121500

``` r
siteNum_fix <- zeroPad(siteNum, 8)
class(siteNum_fix)
```

    ## [1] "character"

``` r
siteNum_fix
```

    ## [1] "02121500"

The next lesson look at how to use `dataRetrieval` functions for Water Quality Portal retrievals.
