---
author: Lindsay R. Carr
date: 9999-12-01
slug: dataRetrieval-intro
title: dataRetrieval - Introduction
image: img/main/intro-icons-300px/r-logo.png
identifier: 
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
draft: true
---
Lesson Summary
--------------

This lesson will focus on finding and retrieving hydrologic time series data using the USGS R package, `dataRetrieval`. The package was created to make querying and downloading hydrologic data from the web easier and less error-prone. The package allows users to easily access data stored in the USGS National Water Information System (NWIS) and the multi-agency database, Water Quality Portal (WQP). NWIS only contains data collected by or for the USGS. Conversely, WQP is a database that aggregates water quality data from multiple agencies, including USGS, Environmental Protection Agency (EPA), US Department of Agriculture (USDA), and many state, tribal, and local agencies.

`dataRetrieval` functions take user-defined arguments and construct web service calls. The web service returns the data as XML (a standard data structure), and `dataRetrieval` takes care of parsing that into a useable R data.frame, complete with metadata. When web services change, `dataRetrieval` users aren't affected because the package maintainers will update the functions to handle these modifications. This is what makes `dataRetrieval` so user-friendly.

Neither NWIS nor WQP are static databases. Users should be aware that data is constantly being added, so a query one week might return differing amounts of data from the next. For more information about NWIS, please visit [waterdata.usgs.gov/nwis](waterdata.usgs.gov/nwis). For more information about WQP, visit their site www.waterqualitydata.us or read about WQP for aquatic research applications in the publication, **[LINK TO geolakes PAPER ONCE RELEASED]()**.

Lesson Objectives
-----------------

Learn about data available in the National Water Information System (NWIS) and Water Quality Portal (WQP). Discover how to construct your retrieval calls to get exactly what you are looking for, and access information stored as metadata in the R object.

By the end of this lesson, the learner will be able to:

1.  Investigate what data is available in National Water Information System (NWIS) and Water Quality Portal (WQP) through package functions.
2.  Construct function calls to pull a variety of NWIS and WQP data.
3.  Access metadata information from retrieval call output.

Lesson Resources
----------------

-   USGS publication: [The dataRetrieval R package](https://pubs.usgs.gov/tm/04/a10/pdf/tm4A10_appendix_1.pdf)
-   Source code: [dataRetrieval on GitHub](https://github.com/USGS-R/dataRetrieval)
-   Report a bug or suggest a feature: [dataRetrieval issues on GitHub](https://github.com/USGS-R/dataRetrieval/issues)
-   USGS Presentation: [dataRetrieval Tutorial](https://owi.usgs.gov/R/dataRetrieval.html#1)
