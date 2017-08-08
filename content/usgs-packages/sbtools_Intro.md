---
author: Lindsay R. Carr
date: 9999-08-01
slug: sbtools-intro
title: sbtools - Introduction
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 4
---
Lesson Summary
--------------

`sbtools` is an R package that enables access to the USGS web platform for data storage, [ScienceBase](https://www.sciencebase.gov). In this lesson, will teach how to interact with ScienceBase from the R console in order to create reproducible workflows.

ScienceBase is collaborative scientific data and information management platform used by USGS scientists and their collaborators. Account holders can upload data and metadata, and choose to share the content publically or keep it private. An account is not needed to download publically available data, so the platform is a great way to share data released with publications.

In addition to the ability to share information publically, ScienceBase enhances traditional collaborative research analyses. Scientific collaborators generally share their data and content by emailing files or using a shared drive. These methods have many limitations, especially when it comes to file size and working with non-USGS participants. By hosting files in the cloud, ScienceBase enables groups to quickly share large files with internal or external partners.

For more information about how to start using ScienceBase, visit their ["About" page](https://www.sciencebase.gov/about/) or ["Frequently Asked Questions" page](https://www.sciencebase.gov/about/faq).

Lesson Objectives
-----------------

By the end of this lesson, the learner will be able to:

1.  Query ScienceBase for data from R.
2.  Manage ScienceBase files from R.
3.  Import files from ScienceBase into usable R objects.

Lesson Resources
----------------

-   USGS publication: [sbtools: A Package Connecting R to Cloud-based Data for Collaborative Online Research](https://journal.r-project.org/archive/2016-1/winslow-chamberlain-appling-etal.pdf)
-   Source code: [sbtools on GitHub](https://github.com/USGS-R/sbtools)
-   Report a bug or suggest a feature: [sbtools issues on GitHub](https://github.com/USGS-R/sbtools/issues)
-   ScienceBase Website: [ScienceBase home page](https://www.sciencebase.gov/catalog/)
-   Data release guidance: [How to release data through ScienceBase](https://www.sciencebase.gov/about/content/data-release)
