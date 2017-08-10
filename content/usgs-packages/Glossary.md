---
author: Lindsay R. Carr
date: 9999-03-01
slug: glossary-usgs
title: Glossary of terms and functions
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 50
---
Below are lists of terms or functions introduced in this curriculum. Each links to the first time it is used, or the section that contains the most description.

Terms
-----

1.  [fabric](/usgs-packages/geoknife-data/#geoknife-components-fabric-stencil-knife)
2.  [Geo Data Portal (GDP)](/usgs-packages/geoknife-intro/)
3.  [geojob](/usgs-packages/geoknife-data/#geoknife-components-fabric-stencil-knife)
4.  [knife](/usgs-packages/geoknife-data/#geoknife-components-fabric-stencil-knife)
5.  [modular workflow](/usgs-packages/app-intro/)
6.  [National Water Information System (NWIS)](/usgs-packages/dataRetrieval-intro/)
7.  [R package](/usgs-packages/GettingStartedUSGS/)
8.  [reproducible](/usgs-packages/app-intro/)
9.  [sbitem](/usgs-packages/sbtools-sbitem/)
10. [ScienceBase](/usgs-packages/sbtools-intro/)
11. [stencil](/usgs-packages/geoknife-data/#geoknife-components-fabric-stencil-knife)
12. [Water Quality Portal (WQP)](/usgs-packages/dataRetrieval-intro/)

Functions
---------

### dataRetrieval

1.  [addWaterYear](/usgs-packages/dataRetrieval-readNWIS/#helper-functions)
2.  [attribute](/usgs-packages/dataRetrieval-readNWIS/#accessing-attributes)
3.  [readNWISdata](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
4.  [readNWISdv](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
5.  [readNWISgwl](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
6.  [readNWISmeas](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
7.  [readNWISpCode](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
8.  [readNWISpeak](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
9.  [readNWISqw](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
10. [readNWISrating](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
11. [readNWISsite](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
12. [readNWISstat](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
13. [readNWISuse](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
14. [readNWISuv](/usgs-packages/dataRetrieval-readNWIS/#readnwis-functions)
15. [readWQPdata](/usgs-packages/dataRetrieval-readWQP/#readwqp-functions)
16. [readWQPdata + querySummary](/usgs-packages/dataRetrieval-discovery/#readwqpdata-querysummary)
17. [readWQPqw](/usgs-packages/dataRetrieval-readWQP/#readwqp-functions)
18. [renameNWIScolumns](/usgs-packages/dataRetrieval-readNWIS/#helper-functions)
19. [whatNWISdata](/usgs-packages/dataRetrieval-discovery/#whatnwisdata)
20. [whatNWISsites](/usgs-packages/dataRetrieval-discovery/#whatnwissites)
21. [whatWQPsites](/usgs-packages/dataRetrieval-discovery/#whatwqpsites)
22. [zeroPad](/usgs-packages/dataRetrieval-readNWIS/#helper-functions)

### geoknife

1.  [abstract](/usgs-packages/geoknife-data/#gdp-datasets)
2.  [algorithm](/usgs-packages/geoknife-data/#available-webprocesses)
3.  [attribute](/usgs-packages/geoknife-data/#available-webgeoms)
4.  [check](/usgs-packages/geoknife-job/#checking-the-geojob-status)
5.  [download](/usgs-packages/geoknife-job/#getting-geojob-data)
6.  [error](/usgs-packages/geoknife-job/#checking-the-geojob-status)
7.  [geoknife](/usgs-packages/geoknife-job/#setting-up-a-geojob)
8.  [geom](/usgs-packages/geoknife-data/#available-webgeoms)
9.  [query](/usgs-packages/geoknife-data/#gdp-datasets)
10. [result](/usgs-packages/geoknife-job/#getting-geojob-data)
11. [running](/usgs-packages/geoknife-job/#checking-the-geojob-status)
12. [successful](/usgs-packages/geoknife-job/#checking-the-geojob-status)
13. [title](/usgs-packages/geoknife-data/#gdp-datasets)
14. [values](/usgs-packages/geoknife-data/#available-webgeoms)
15. [variables](/usgs-packages/geoknife-data/#gdp-datasets)
16. [wait](/usgs-packages/geoknife-job/#wait-and-email)
17. [webdata](/usgs-packages/geoknife-data/#gdp-datasets)
18. [webgeom](/usgs-packages/geoknife-data/#available-webgeoms)
19. [webprocess](/usgs-packages/geoknife-data/#available-webprocesses)

### sbtools

1.  [authenticate\_sb](/usgs-packages/sbtools-get/#authentication)
2.  [folder\_create](/usgs-packages/sbtools-modify/#creating-sciencebase-items)
3.  [identifier\_exists](/usgs-packages/sbtools-get/#inspect-and-download-items)
4.  [is\_logged\_in](/usgs-packages/sbtools-get/#authentication)
5.  [is.sbitem](/usgs-packages/sbtools-sbitem/#what-is-an-sbitem)
6.  [item\_append\_files](/usgs-packages/sbtools-modify/#uploading-your-files)
7.  [item\_create](/usgs-packages/sbtools-modify/#creating-sciencebase-items)
8.  [item\_exists](/usgs-packages/sbtools-get/#inspect-and-download-items)
9.  [item\_get](/usgs-packages/sbtools-get/#inspect-and-download-items)
10. [item\_get\_fields](/usgs-packages/sbtools-get/#inspect-and-download-items)
11. [item\_get\_parent](/usgs-packages/sbtools-get/#inspect-and-download-items)
12. [item\_get\_wfs](/usgs-packages/sbtools-get/#web-feature-services-to-visualize-spatial-data)
13. [item\_list\_children](/usgs-packages/sbtools-get/#inspect-and-download-items)
14. [item\_list\_files](/usgs-packages/sbtools-get/#inspect-and-download-items)
15. [item\_move](/usgs-packages/sbtools-modify/#moving-and-removing-items)
16. [item\_rename\_files](/usgs-packages/sbtools-modify/#managing-and-removing-your-files)
17. [item\_replace\_files](/usgs-packages/sbtools-modify/#managing-and-removing-your-files)
18. [item\_rm](/usgs-packages/sbtools-modify/#moving-and-removing-items)
19. [item\_rm\_files](/usgs-packages/sbtools-modify/#managing-and-removing-your-files)
20. [item\_update](/usgs-packages/sbtools-modify/#editing-your-items)
21. [item\_update\_identifier](/usgs-packages/sbtools-modify/#editing-your-items)
22. [item\_upload\_create](/usgs-packages/sbtools-modify/#uploading-your-files)
23. [item\_upsert](/usgs-packages/sbtools-modify/#editing-your-items)
24. [items\_create](/usgs-packages/sbtools-modify/#creating-sciencebase-items)
25. [items\_update](/usgs-packages/sbtools-modify/#editing-your-items)
26. [items\_upsert](/usgs-packages/sbtools-modify/#editing-your-items)
27. [query\_sb](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
28. [query\_sb\_datatype](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
29. [query\_sb\_date](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
30. [query\_sb\_doi](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
31. [query\_sb\_spatial](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
32. [query\_sb\_text](/usgs-packages/sbtools-discovery/#discovering-data-via-sbtools)
33. [sb\_datatypes](/usgs-packages/sbtools-discovery/#using-query-sb-datatype)
34. [user\_id](/usgs-packages/sbtools-get/#authentication)
