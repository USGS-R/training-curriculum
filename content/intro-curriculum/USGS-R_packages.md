---
author: Lindsay R. Carr
slug: USGS
title: USGS-R Packages
menu:
  weight=2
---
### Find USGS-R package information

Visit the [R Community website to see](http://owi.usgs.gov/R/) a list of released and in-development packages. There is also the [USGS-R GitHub community](https://github.com/USGS-R) where you can watch or participate in the development of packages. Lastly, you can run the following commands in R to see what packages exist on [GRAN (**G**eological Survey **R** **A**rchive **N**etwork)](GRAN_pkg%20%3C-%20available.packages(contrib.url(%22http://owi.usgs.gov/R%22))%20names(GRAN_pkg%5B,1:2%5D)).

``` r
GRAN_pkg <- available.packages(contrib.url("http://owi.usgs.gov/R"))
names(GRAN_pkg[,1:2])
```

### Ready/Published

[dataRetrieval](https://github.com/USGS-R/dataRetrieval)

-   For downloading and importing USGS and EPA water data (NWIS and WQP, respectively)
-   <http://pubs.usgs.gov/tm/04/a10/>

[EGRET](https://github.com/USGS-R/EGRET)

-   For the analysis of long term changes in water quality and streamflow
    -   Weighted Regressions on Time, Discharge, and Season (WRTDS)
    -   Includes time trend and seasonal component
-   <http://pubs.usgs.gov/tm/04/a10/>
-   <https://github.com/USGS-R/EGRET/wiki>

[EGRETci](https://github.com/USGS-R/EGRETci)

-   A bootstrap method for estimating uncertainty of water quality trends
-   <http://www.sciencedirect.com/science/article/pii/S1364815215300220>

[geoknife](https://github.com/USGS-R/geoknife)

-   For web-based geoprocessing of gridded data, especially that available through the USGS Geo Data Portal
-   <http://onlinelibrary.wiley.com/doi/10.1111/ecog.01880/abstract>
-   <http://www.ecography.org/blog/slicing-gridded-data-geoknife>
-   <http://usgs-r.github.io/geoknife/>

[WQ-Review](https://github.com/USGS-R/WQ-Review)

-   Toolbox for discrete water-quality data review and exploration

### Under Development

[EflowStats](https://github.com/USGS-R/EflowStats)

-   Calculate hydrologic indicator statistics and fundamental properties of daily streamflow
-   Updates National Hydrologic Assessment Tool (NAHAT)
-   <http://www.fort.usgs.gov/products/publications/21598/21598.pdf>
-   <http://onlinelibrary.wiley.com/doi/10.1002/rra.2710/abstract>

[rloadest](https://github.com/USGS-R/rloadest)

-   For load estimation of constituents in rivers and streams
-   <https://github.com/USGS-R/rloadest/tree/master/vignettes>

[gsplot](https://github.com/USGS-R/gsplot)

-   SPN-compatible, customizable plotting system for water data
-   <https://github.com/USGS-R/gsplot>

[sbtools](https://github.com/USGS-R/sbtools)

-   Tools for interfacing R with ScienceBase data services

[streamMetabolizer](https://github.com/USGS-R/streamMetabolizer)

-   Models for estimating stream/river production and respiration from dissolved oxygen data
-   see also [LakeMetabolizer](https://github.com/GLEON/LakeMetabolizer) for lakes

[sensorQC](https://github.com/USGS-R/sensorQC)

-   Tools for QA/QC of sensor data

### Supporting Packages

-   [repgen](https://github.com/USGS-R/repgen): Tools for automated report generation (behind the scenes package)
-   smwrBase
-   smwrData
-   smwrGraphs
-   smwrQW
-   smwrStats
-   grantools
-   unitted

### Project-Specific Packages

-   gsintroR
-   EGRETextra
-   GLMr
-   glmtools
-   GSqwsr
-   hazardItems
-   htcTrends
-   hydroMap
-   mda.streams
-   powstreams
-   restrend
-   SampleSplitting
-   toxEval
-   USGSHydroOpt
