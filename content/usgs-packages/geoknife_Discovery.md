---
author: Lindsay R. Carr
date: 9999-09-30
slug: geoknife-data
title: geoknife - accessible data
image: img/main/intro-icons-300px/r-logo.png
identifier: 
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
draft: true
---
Remote processing
-----------------

The USGS Geo Data Portal is designed to perform web-service processing on large gridded datasets. `geoknife` allows R users to take advantage of these services by processing large data, such as data available in the GDP catalog or a user-defined dataset, on the web. This type of workflow has three main advantages:

1.  it allows the user to avoid downloading large datasets,
2.  it avoids reinventing the wheel for the creation and optimization of complex geoprocessing algorithms, and
3.  computing resources are dedicated elsewhere, so geoknife operations do not have much of an impact on a local computer.

geoknife components: fabric, stencil, knife
-------------------------------------------

The main components of a geoknife workflow are the fabric, stencil, and knife. These three components go into the final element, the geoknife "job" (geojob), which returns the processed data. The fabric is the gridded web dataset to be processed, the stencil is the feature of interest, and the knife is the processing algorithm parameters. Each of the `geoknife` components is created using a corresponding function: fabrics are created using `webdata()`, stencils are created using `webgeom()`, and knives are created using `webprocess()`.

This lesson will focus on discovering what options exist for each of those components. The next lesson will teach you how to construct each component and put it together to get the processed data. Before continuing this lesson, load the geoknife library (install if necessary).

``` r
# load the geoknife package
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

Available webdata
-----------------

### GDP datasets

To learn what data is available through GDP, you can explore the [online catalog](https://cida.usgs.gov/gdp/) or use the function `query`. Note that the access pattern for determining available fabrics differs slightly from stencils and knives. Running `query("webdata")` will return every dataset available through GDP:

``` r
all_webdata <- query("webdata")
head(all_webdata)
```

    ## An object of class "datagroup":
    ## [1] 4km Monthly Parameter-elevation Regressions on Independent Slopes Model Monthly Climate Data for the Continental United States. January 2012 Shapshot 
    ##   url: https://cida.usgs.gov/thredds/dodsC/prism 
    ## [2] 4km Monthly Parameter-elevation Regressions on Independent Slopes Model Monthly Climate Data for the Continental United States. October 2015 Snapshot 
    ##   url: https://cida.usgs.gov/thredds/dodsC/prism_v2 
    ## [3] Bias Corrected Constructed Analogs V2 Daily Future CMIP5 Climate Projections 
    ##   url: https://cida.usgs.gov/thredds/dodsC/cmip5_bcca/future 
    ## [4] Bias Corrected Constructed Analogs V2 Daily Historical CMIP5 Climate Projections 
    ##   url: https://cida.usgs.gov/thredds/dodsC/cmip5_bcca/historical 
    ## [5] Bias Corrected Spatially Downscaled Monthly Climate Predictions 
    ##   url: https://cida.usgs.gov/thredds/dodsC/maurer/maurer_brekke_w_meta.ncml 
    ## [6] Bias Corrected Spatially Downscaled Monthly CMIP5 Climate Projections 01-1950 - 11-2005 
    ##   url: https://cida.usgs.gov/thredds/dodsC/cmip5_bcsd/historical_2

``` r
length(all_webdata)
```

    ## [1] 173

Notice that the object returned is a special `geoknife` class of `datagroup`. There are specific `geoknife` functions that only operate on an object of this class, see `?title` and `?abstract`. These two functions are used to extract metadata information about each of the available GDP datasets. With 173 datasets available, it is likely that reading through each to find ones that are of interest to you would be time consuming. You can use `grep` along with the accessor functions `title` and `abstract` to figure out which datasets you would like to use for processing.

Let's say that we were interested in evapotranspiration data. To search for which GDP datasets might contain evapotranspiration data, you can use the titles and abstracts.

``` r
# notice that you cannot perform a grep on all_webdata - it is because it is a special class
# you need to perform pattern matching on vectors
# grep("evapotranspiration", all_webdata)

all_titles <- title(all_webdata)
which_titles <- grep("evapotranspiration", all_titles)
evap_titles <- all_titles[which_titles]
head(evap_titles)
```

    ## [1] "Monthly Conterminous U.S. actual evapotranspiration data"
    ## [2] "Yearly Conterminous U.S. actual evapotranspiration data"

``` r
all_abstracts <- abstract(all_webdata)
which_abstracts <- grep("evapotranspiration", all_abstracts)
evap_abstracts <- all_abstracts[which_abstracts]
evap_abstracts[1]
```

    ## [1] "The California Basin Characterization Model (CA-BCM 2014) dataset provides historical and projected climate and hydrologic surfaces for the region that encompasses the state of California and all the streams that flow into it (California hydrologic region ). The CA-BCM 2014 applies a monthly regional water-balance model to simulate hydrologic responses to climate at the spatial resolution of a 270-m grid. The model has been calibrated using a total of 159 relatively unimpaired watersheds for the California region. The historical data is based on 800m PRISM data spatially downscaled to 270 m using the gradient-inverse distance squared approach (GIDS), and the projected climate surfaces include five CMIP-3 (GFDL, PCM, MIROC3_2, CSIRO, GISS_AOM) and nine CMIP-5 (MIROC5, MIROC , GISS, MRI, MPI, CCSM4, IPSL, CNRM, FGOALS) General Circulation Models under a range of emission scenarios or representative concentration pathways (RCPs) for a total of 18 futures that have been statistically downscaled using BCSD to 800 m and further downscaled using GIDS to 270 m for model application.   The BCM approach uses a regional water balance model based on this high resolution precipitation and temperature as well as elevation, geology, and soils to produce surfaces for the following variables: precipitation, air temperature, recharge, runoff, potential evapotranspiration (PET), actual evapotranspiration, and climatic water deficit, a parameter that is calculated as PET minus actual evapotranspiration.   The following data are available in this archive: Raw, monthly model output for historical and future periods. Projected data is available for the following GCM and emission scenario or RCP combinations: GFDL-B1, GFDL-A2 PCM-B1, PCM-A2 MIROC3_2-A2 CSIRO-A1B GISS_AOM-A1B, MIROC5-RCP2.6, MIROC-RCP4.5, MIROC-RCP6.0, MIROC-RCP8.5 GISS-RCP2.6, MRI-RCP2.6, MPI- RCP4.5, CCSM4-RCP8.5, IPSL-RCP8.5, CNRM-RCP8.5, FGOALS-RCP8.5. Data variables: Actual evapotranspiration - water available between wilting point and field capacity, mm (aet); Climatic water deficit - Potential minus actual evapotranspiration, mm (cwd); Maximum monthly temperature, degrees C - (tmx); Minimum monthly temperature, degrees C - (tmn); Potential evapotranspiration - Water that could evaporate or transpire from plants if available, mm (pet); Recharge - Amount of water that penetrates below the root zone, mm (rch); Runoff - Amount of water that becomes stream flow, mm (run); Precipitation, mm - (ppt). Note that another archive, hosted by the California Climate Commons contains various climatological summaries of these data. That archive can be found at: http://climate.calcommons.org/"

10 possible datasets to look through is a lot more manageable than 173. Let's say the dataset titled "Yearly Conterminous U.S. actual evapotranspiration data" interested us enough to explore more. We have now identified a fabric of interest.

We might want to know more about the dataset, such as what variables and time period is available. To actually create the fabric, you will need to use `webdata` and supply the appropriate datagroup object as the input. This should result in an object with a class of `webdata`. The following query and accessor functions will operate only on an object of class `webdata`.

``` r
evap_fabric <- webdata(all_webdata["Yearly Conterminous U.S. actual evapotranspiration data"])
class(evap_fabric)
```

    ## [1] "webdata"
    ## attr(,"package")
    ## [1] "geoknife"

Now that we have a defined fabric, we can explore what variables and time period are within that data. First, we use `query` to determine what variables exist. You'll notice that the accessor function `variable` returns NA. This is fine when you are just exploring available data; however, exploring avaialble times requires that the variable be defined. Thus, we need to set which variable from the dataset will be used. Then, we can explore times that are available in the data.

``` r
# no variables defined yet
variables(evap_fabric)
```

    ## [1] NA

``` r
# find what variables are available
query(evap_fabric, "variables")
```

    ## [1] "et"

``` r
# trying to find available times before setting the variable results in an error
# query(evap_fabric, "times")

# only one variable, "et"
variables(evap_fabric) <- "et"
variables(evap_fabric)
```

    ## [1] "et"

``` r
# now that the variable is set, we can explore available times
query(evap_fabric, "times")
```

    ## [1] "2000-01-01 UTC" "2015-01-01 UTC"

### Datasets not in GDP

Any dataset available online that follows OPeNDAP protocol can be used with `geoknife`. These datasets can be found through web searches or other catalogs and require finding out the OPeNDAP endpoint (URL) for the dataset. This url is used as the input to the argument `url` in `webdata`.

We searched [NOAA's OPenDAP data catalog](https://opendap.co-ops.nos.noaa.gov/) and found this data from the Center for Operational Oceanographic Products and Services THREDDS server. It includes forecasts for water levels, water currents, water temperatures, and salinity levels for Delaware Bay. Since it is forecast data, the times associated with the data will change. To create a webdata object from this dataset, just use the OPeNDAP url. Then query variables and time as we did before.

``` r
DelBay_fabric <- webdata(url="http://opendap.co-ops.nos.noaa.gov/thredds/dodsC/DBOFS/fmrc/Aggregated_7_day_DBOFS_Fields_Forecast_best.ncd")
query(DelBay_fabric, "variables")
```

    ##  [1] "zeta"  "Pair"  "Uwind" "Vwind" "u"     "v"     "w"     "temp" 
    ##  [9] "h"     "f"     "pm"    "pn"    "angle"

``` r
# need to set the variable(s) in order to query the times
variables(DelBay_fabric) <- c("Vwind", "temp")
query(DelBay_fabric, "times")
```

    ## [1] "2017-02-23 UTC" "2017-03-03 UTC"

Here is a second example of using a non-GDP dataset. This data was found under the [data section on Unidata's website](http://www.unidata.ucar.edu/data/#home). This is aggregated UNIWISC satellite data for Earth's "surface skin" temperature.

``` r
skinT_fabric <- webdata(url="http://thredds.ucar.edu/thredds/dodsC/satellite/SFC-T/SUPER-NATIONAL_1km")
skinT_var <- query(skinT_fabric, "variables")

# need to set the variable(s) in order to query the times
variables(skinT_fabric) <- skinT_var
query(skinT_fabric, "times") # your times might be different because this is forecast data
```

    ## [1] "2017-01-31 UTC" "2017-03-01 UTC"

Both examples we've included here use aggregated data, meaning there is a different file for each year. Some data that you encounter might not be aggregated. In these cases, you will need to create more than one geojob and join data at the end.

Now that we have explored options for our webdata, let's look at what options exist for geospatial features.

Available webgeoms
------------------

The next component to `geonkife` jobs is the spatial extent of the data, a.k.a. the stencil. The stencil is defined by using either of the functions `simplegeom` or `webgeom`. `simplegeom` is used to explicitly define an area by the user, but `webgeom` is used to specify an existing web feature service (WFS) as the geospatial extent. Defining your stencil using `simplegeom` will be covered in the next lesson. This lesson will just show how to learn what available webgeoms exist. Users can use any WFS url to create their stencil, but there are a number of features that exist through GDP already. To determine what features exist, you can create a default webgeom object and then query its geom name, attributes, and values. This will return all available GDP default features.

``` r
# setup a default stencil by using webgeom and not supplying any arguments
default_stencil <- webgeom()

# now determine what geoms are available with the default
default_geoms <- query(default_stencil, "geoms")
length(default_geoms)
```

    ## [1] 68

``` r
head(default_geoms)
```

    ## [1] "upload:AZ"          "sample:Alaska"      "upload:Arizona"    
    ## [4] "upload:Arizona05"   "upload:ArizonaGrid" "upload:Bluff_Creek"

You will notice a pattern with the names of the geoms: a category followed by `:`, and then a specific name. See the table below for definitions of the categories. These category-name combinations are the strings you would use to define your geom.

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Category
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
upload
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
upload
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
sample
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
sample
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
draw
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
draw
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
derivative
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
derivative
</td>
</tr>
</tbody>
</table>
Similar to fabrics where you could not query times without setting the variables, you cannot query attributes of stencils before defining the geoms. Likewise, you cannot query for values of a stencil until you have set the attributes. Attributes give the metadata associated with the stencil and it's geom. Values tell you the individual spatial features available in that attribute of the geom.

``` r
# add a geom to see what values are available
geom(default_stencil)
```

    ## [1] NA

``` r
geom(default_stencil) <- "sample:CONUS_states"

# now that geom is set, you can query for available attributes
query(default_stencil, "attributes")
```

    ## [1] "STATE" "FIPS"

``` r
attribute(default_stencil) <- "STATE"

# now that attribute is set, you can query for available values
STATE_values <- query(default_stencil, "values")
head(STATE_values)
```

    ## [1] "Alabama"     "Arizona"     "Arkansas"    "California"  "Colorado"   
    ## [6] "Connecticut"

``` r
# switch the stencil to see the differences
ecoreg_stencil <- default_stencil
geom(ecoreg_stencil) <- "sample:Ecoregions_Level_III"
query(ecoreg_stencil, "attributes")
```

    ## [1] "LEVEL3_NAM"

``` r
attribute(ecoreg_stencil) <- "LEVEL3_NAM"
ecoreg_values <- query(ecoreg_stencil, "values")
head(ecoreg_values)
```

    ## [1] "Ahklun And Kilbuck Mountains" "Alaska Peninsula Mountains"  
    ## [3] "Alaska Range"                 "Aleutian Islands"            
    ## [5] "Arctic Coastal Plain"         "Arctic Foothills"

There are some built-in templates that allow stencils to be defined more specifically. Currently, the package only supports US States, Level III Ecoregions, or HUC8s.

``` r
# creating geoms from the available templates
webgeom('state::Wisconsin')
```

    ## An object of class "webgeom":
    ## url: https://cida.usgs.gov/gdp/geoserver/wfs 
    ## geom: sample:CONUS_states 
    ## attribute: STATE 
    ## values: Wisconsin 
    ## wfs version: 1.1.0

``` r
webgeom('state::Wisconsin,Maine') # multiple states separated by comma
```

    ## An object of class "webgeom":
    ## url: https://cida.usgs.gov/gdp/geoserver/wfs 
    ## geom: sample:CONUS_states 
    ## attribute: STATE 
    ## values: Wisconsin, Maine 
    ## wfs version: 1.1.0

``` r
webgeom('HUC8::09020306,14060009') # multiple HUCs separated by comma
```

    ## An object of class "webgeom":
    ## url: https://cida.usgs.gov/gdp/geoserver/wfs 
    ## geom: sample:simplified_huc8 
    ## attribute: HUC_8 
    ## values: 09020306, 14060009 
    ## wfs version: 1.1.0

``` r
webgeom('ecoregion::Colorado Plateaus,Driftless Area') # multiple regions separated by comma
```

    ## An object of class "webgeom":
    ## url: https://cida.usgs.gov/gdp/geoserver/wfs 
    ## geom: sample:Ecoregions_Level_III 
    ## attribute: LEVEL3_NAM 
    ## values: Colorado Plateaus, Driftless Area 
    ## wfs version: 1.1.0

Available webprocesses
----------------------

The final component to a geojob is the process algorithm used to aggregate the data across the defined stencil. Web process algorithms can be defined by the user, but let's explore the defaults available through GDP.

``` r
# setup a default knife by using webprocess and not supplying any arguments
default_knife <- webprocess()

# now determine what web processing algorithms are available with the default
default_algorithms <- query(default_knife, 'algorithms')
length(default_algorithms)
```

    ## [1] 6

``` r
head(default_algorithms)
```

    ## $`OPeNDAP Subset`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureTimeSeriesAlgorithm"
    ## 
    ## $`Categorical Coverage Fraction`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureCategoricalGridCoverageAlgorithm"
    ## 
    ## $`OPeNDAP Subset`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureCoverageOPeNDAPIntersectionAlgorithm"
    ## 
    ## $`Area Grid Statistics (unweighted)`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureGridStatisticsAlgorithm"
    ## 
    ## $`Area Grid Statistics (weighted)`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureWeightedGridStatisticsAlgorithm"
    ## 
    ## $`WCS Subset`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureCoverageIntersectionAlgorithm"

From this list, you can define which algorithm you would like the webprocess component to use. For example, we want our data to be returned as the unweighted average across each geospatial feature, so we need to use "Area Grid Statistics (weighted)".

``` r
# algorithm actually has a default of the weighted average
algorithm(default_knife)
```

    ## $`Area Grid Statistics (weighted)`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureWeightedGridStatisticsAlgorithm"

``` r
# change the algorithm to unweighted
algorithm(default_knife) <- default_algorithms['Area Grid Statistics (unweighted)']
algorithm(default_knife)
```

    ## $`Area Grid Statistics (unweighted)`
    ## [1] "gov.usgs.cida.gdp.wps.algorithm.FeatureGridStatisticsAlgorithm"

Now that we can explore all of our options, we will learn how to construct each component and execute a geojob in the next lesson.
