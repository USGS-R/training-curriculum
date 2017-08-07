---
author: Lindsay R. Carr
date: 9999-05-01
slug: app-part2
title: Application - Part 2, Download data.
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
In this section, we are going to use `dataRetrieval` and `geoknife` to get nitrogen, phosphorus, and precipitation data for the sites determined in the [previous section](/app-part1).

We are walking through the workflow in very distinct chunks, but this will be put together as a single script at the end. If you need a reminder, below is the code that we used to get the site and 8-digit HUC numbers.

<button class="ToggleButton" onclick="toggle_visibility('get-sb-sites')">
Show Answer
</button>
              <div id="get-sb-sites" style="display:none"></div>

Before downloading the data, make sure you select the time period that this should be created for. For this example, we are going to use water year 2016.

``` r
startDate <- "2015-10-01"
endDate <- "2016-09-30"
```

Now, use `dataRetrieval` functions to pull down data for nitrogen and phosphorus. You can choose your own parameter codes to define these nutrients using `parameterCdFile` or use the ones below.

``` r
pcodes_nitrogen <- c("00613", "00618", "00631")
pcodes_phosphorus <- c("00665")
```

Using your choice of `readNWIS` function, get a data frame with nitrogen data for all sites and a second data frame with phosphorus data for all sites. Expand the code below to once you've made an attempt.

<button class="ToggleButton" onclick="toggle_visibility('nutrient-data')">
Show Answer
</button>
              <div id="nutrient-data" style="display:none">

``` r
nitrogen_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_nitrogen,
                            startDate = startDate, endDate = endDate)
head(nitrogen_data)
```

    ##   agency_cd  site_no  sample_dt sample_tm sample_end_dt sample_end_tm
    ## 1      USGS 04208000 2015-10-01     15:00          <NA>          <NA>
    ## 2      USGS 04208000 2015-10-01     15:00          <NA>          <NA>
    ## 3      USGS 04208000 2015-10-01     15:00          <NA>          <NA>
    ## 4      USGS 04208000 2015-11-05     08:30          <NA>          <NA>
    ## 5      USGS 04208000 2015-11-05     08:30          <NA>          <NA>
    ## 6      USGS 04208000 2015-11-05     08:30          <NA>          <NA>
    ##   sample_start_time_datum_cd_reported tm_datum_rlbty_cd coll_ent_cd
    ## 1                                 EDT                 K        USGS
    ## 2                                 EDT                 K        USGS
    ## 3                                 EDT                 K        USGS
    ## 4                                 EST                 K        USGS
    ## 5                                 EST                 K        USGS
    ## 6                                 EST                 K        USGS
    ##   medium_cd project_cd aqfr_cd tu_id body_part_id hyd_cond_cd samp_type_cd
    ## 1        WS       <NA>    <NA>  <NA>         <NA>           4            7
    ## 2        WS       <NA>    <NA>  <NA>         <NA>           4            7
    ## 3        WS       <NA>    <NA>  <NA>         <NA>           4            7
    ## 4        WS  00FX45600    <NA>  <NA>         <NA>           4            9
    ## 5        WS  00FX45600    <NA>  <NA>         <NA>           4            9
    ## 6        WS  00FX45600    <NA>  <NA>         <NA>           4            9
    ##   hyd_event_cd sample_lab_cm_tx parm_cd remark_cd result_va val_qual_tx
    ## 1            9             <NA>   00613      <NA>     0.022        <NA>
    ## 2            9             <NA>   00618      <NA>     2.680        <NA>
    ## 3            9             <NA>   00631      <NA>     2.700        <NA>
    ## 4            9             <NA>   00613      <NA>     0.014        <NA>
    ## 5            9             <NA>   00618      <NA>     4.000        <NA>
    ## 6            9             <NA>   00631      <NA>     4.020        <NA>
    ##   meth_cd dqi_cd rpt_lev_va rpt_lev_cd lab_std_va prep_set_no prep_dt
    ## 1   DZ001      S      0.001      DLDQC       <NA>        <NA>    <NA>
    ## 2   ALGOR      S         NA       <NA>       <NA>        <NA>    <NA>
    ## 3   RED01      S      0.040      DLDQC       <NA>        <NA>    <NA>
    ## 4   DZ001      S      0.001      DLDQC       <NA>        <NA>    <NA>
    ## 5   ALGOR      S         NA       <NA>       <NA>        <NA>    <NA>
    ## 6   RED01      S      0.040      DLDQC       <NA>        <NA>    <NA>
    ##   anl_set_no   anl_dt result_lab_cm_tx anl_ent_cd       startDateTime
    ## 1 KONE15281A 20151008             <NA>   USGSNWQL 2015-10-01 19:00:00
    ## 2       <NA>       NA             <NA>       <NA> 2015-10-01 19:00:00
    ## 3 KNO315282A 20151009             <NA>   USGSNWQL 2015-10-01 19:00:00
    ## 4 KONE15320A 20151116             <NA>   USGSNWQL 2015-11-05 13:30:00
    ## 5       <NA>       NA             <NA>       <NA> 2015-11-05 13:30:00
    ## 6 KNO315313B 20151109             <NA>   USGSNWQL 2015-11-05 13:30:00
    ##   sample_start_time_datum_cd
    ## 1                        UTC
    ## 2                        UTC
    ## 3                        UTC
    ## 4                        UTC
    ## 5                        UTC
    ## 6                        UTC

``` r
phosphorus_data <- readNWISqw(siteNumbers = sites, parameterCd = pcodes_phosphorus,
                              startDate = startDate, endDate = endDate)
head(phosphorus_data)
```

    ##   agency_cd  site_no  sample_dt sample_tm sample_end_dt sample_end_tm
    ## 1      USGS 04208000 2015-10-01     15:00          <NA>          <NA>
    ## 2      USGS 04208000 2015-11-05     08:30          <NA>          <NA>
    ## 3      USGS 04208000 2015-12-02     09:00          <NA>          <NA>
    ## 4      USGS 04208000 2016-01-06     11:30          <NA>          <NA>
    ## 5      USGS 04208000 2016-02-01     12:00          <NA>          <NA>
    ## 6      USGS 04208000 2016-03-03     08:45          <NA>          <NA>
    ##   sample_start_time_datum_cd_reported tm_datum_rlbty_cd coll_ent_cd
    ## 1                                 EDT                 K        USGS
    ## 2                                 EST                 K        USGS
    ## 3                                 EST                 K        USGS
    ## 4                                 EST                 K        USGS
    ## 5                                 EST                 K        USGS
    ## 6                                 EST                 K        USGS
    ##   medium_cd project_cd aqfr_cd tu_id body_part_id hyd_cond_cd samp_type_cd
    ## 1        WS       <NA>    <NA>  <NA>         <NA>           4            7
    ## 2        WS  00FX45600    <NA>  <NA>         <NA>           4            9
    ## 3        WS  00FX45600    <NA>  <NA>         <NA>           9            9
    ## 4        WS  00FX45600    <NA>  <NA>         <NA>           9            9
    ## 5        WS  00FX45600    <NA>  <NA>         <NA>           9            9
    ## 6        WS  00FX45600    <NA>  <NA>         <NA>           6            9
    ##   hyd_event_cd sample_lab_cm_tx parm_cd remark_cd result_va val_qual_tx
    ## 1            9             <NA>   00665      <NA>     0.090        <NA>
    ## 2            9             <NA>   00665      <NA>     0.111        <NA>
    ## 3            9             <NA>   00665      <NA>     0.101        <NA>
    ## 4            9             <NA>   00665      <NA>     0.111        <NA>
    ## 5            9             <NA>   00665      <NA>     0.158        <NA>
    ## 6            9             <NA>   00665      <NA>     0.108        <NA>
    ##   meth_cd dqi_cd rpt_lev_va rpt_lev_cd lab_std_va prep_set_no prep_dt
    ## 1   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ## 2   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ## 3   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ## 4   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ## 5   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ## 6   CL021      S      0.004      DLDQC       <NA>        <NA>    <NA>
    ##   anl_set_no   anl_dt result_lab_cm_tx anl_ent_cd       startDateTime
    ## 1   PELW280A 20151007             <NA>   USGSNWQL 2015-10-01 19:00:00
    ## 2   PELW320C 20151118             <NA>   USGSNWQL 2015-11-05 13:30:00
    ## 3   PELW344B 20151229             <NA>   USGSNWQL 2015-12-02 14:00:00
    ## 4   PELW014A 20160114             <NA>   USGSNWQL 2016-01-06 16:30:00
    ## 5   PELW039C 20160210             <NA>   USGSNWQL 2016-02-01 17:00:00
    ## 6   PELW082A 20160329             <NA>   USGSNWQL 2016-03-03 13:45:00
    ##   sample_start_time_datum_cd
    ## 1                        UTC
    ## 2                        UTC
    ## 3                        UTC
    ## 4                        UTC
    ## 5                        UTC
    ## 6                        UTC

</div>
Now we need to download the precipitation data from GDP using `geoknife`. To do so, you will need the dataset (title: "United States Stage IV Quantitative Precipitation Archive") and appropriate HUCs. See `?webgeom` for an example of how to format the geom for 8-digit HUCs. Complete the steps to create and execute a geojob. Download the results of the process as a `data.frame`. See [geoknife discovery](geoknife-data) and [geoknife execute](geoknife-job) lessons for assistance.

<button class="ToggleButton" onclick="toggle_visibility('precip-data')">
Show Answer
</button>
              <div id="precip-data" style="display:none">

``` r
library(geoknife)
```

    ## 
    ## Attaching package: 'geoknife'

    ## The following object is masked from 'package:stats':
    ## 
    ##     start

    ## The following object is masked from 'package:graphics':
    ## 
    ##     title

    ## The following object is masked from 'package:base':
    ## 
    ##     url

``` r
# Create appropriate webgeom string for 8-digit hucs
huc8_geoknife_str <- paste0('HUC8::', paste(huc8s, collapse=","))
huc8_geoknife_str
```

    ## [1] "HUC8::04030108,04030101,04110002"

``` r
# Create the stencil and process
precip_stencil <- webgeom(huc8_geoknife_str)
precip_knife <- webprocess() # accept defaults for weighted average

# First find and initiate the fabric
all_webdata <- query("webdata")
precip_fabric <- webdata(all_webdata["United States Stage IV Quantitative Precipitation Archive"])

# Now find/add variables (there is only one)
precip_vars <- query(precip_fabric, 'variables')
variables(precip_fabric) <- precip_vars

# Add times to complete fabric
times(precip_fabric) <- c(startDate, endDate)

# Create geojob + get results
precip_geojob <- geoknife(precip_stencil, precip_fabric, precip_knife)
wait(precip_geojob, sleep.time = 10) # add `wait` when running scripts
precip_data <- result(precip_geojob)
```

</div>
