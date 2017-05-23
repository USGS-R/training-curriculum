---
author: Lindsay R. Carr
date: 9999-12-31
slug: getting-started
title: Getting Started
draft: True
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
There are a number of advanced R developers across the USGS who write scripts to perform important analyses. They often want to share the workflows and steps associated with the analysis, but passing around scripts that require users to change hard-coded inputs can be cumbersome and inefficient. This course gives advanced R programmers the skills they need to turn their scripted workflows into an R package. R packages allow code to be bundled into functions and easily downloaded and installed by users. Packages contain documentation and help files that should minimize questions asked of package authors.

Course objectives
-----------------

1.  Improve R programming skills.
2.  Create a manageable, testable, and version-controlled codebase for your analysis.
3.  Easily and openly share your workflows and methods with others as R packages.

Software setup
--------------

Software installation: - [R](https://cran.rstudio.com/bin/windows/base/) (latest version) - [RStudio](https://www.rstudio.com/products/rstudio/download2/) (&gt;1.0) - [RTools](https://cran.r-project.org/bin/windows/Rtools/) (most recent frozen version) - R packages: devtools, roxygen2, testthat, knitr

Suggested prerequisite knowledge
--------------------------------

This course discusses advanced topics in programming. Transitioning from scripting mentality to package development can be challenging; we recommend you have advanced knowledge of R programming to use this curriculum. Please refer to the list below to see if you qualify. In addition, putting time and effort into package development is more useful if you have an existing script that could be useful to yourself and others if it were turned into a package.

I am comfortable ...

-   loading files into data.frames.
-   differentiating data structures and data types.
-   indexing vectors, data.frames, or lists.
-   creating scatter, line, or boxplots and saving the output as a PNG/JPG.
-   writing for loops.
-   using logical statements (&gt;, &gt;=, ==).
-   writing conditional statements (if, if-else).
-   installing, loading, and using additional packages.
-   troubleshooting/decrypting error messages.

Course overview
---------------

<table style="width:11%;">
<colgroup>
<col width="5%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th>Module</th>
<th>Objectives</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>What is a Package?</td>
<td>Distinguish scripts and packages; discuss situations where a package would be better than a script; define the required directories and files for a package; compare and contrast the package repositories GRAN and CRAN; and recall USGS and DOI policies related to publishing and maintaining code.</td>
</tr>
<tr class="even">
<td>Package mechanics</td>
<td>List the structural components of an R-package; understand package dependency trees; be familiar with different ways data can be included in packages; correctly define what licenses and disclaimers are needed for USGS software; apply the build and check features to a package; and define internal functions and know their benefits.</td>
</tr>
<tr class="odd">
<td>Version control</td>
<td>Define version control and give examples of how it is useful; navigate the GitHub interface; and summarize a typical GitHub-to-R workflow.</td>
</tr>
<tr class="even">
<td>Documentation</td>
<td>Distinguish the different types of documentation for R packages; develop documentation for individual functions; create a vignette to highlight the top-level package uses; and edit and update README files.</td>
</tr>
<tr class="odd">
<td>Debugging</td>
<td>Track down the source of an error; understand the different ways of debugging (browser, traceback, breakpoints); and learn how to use the different debug buttons in RStudio.</td>
</tr>
<tr class="even">
<td>Defensive programming</td>
<td>Define defensive programming; list common techniques for defensive programming; and construct and execute defensive programming functions.</td>
</tr>
<tr class="odd">
<td>Writing tests</td>
<td>Describe the importance of tests; explain test-driven development; and construct and execute simple tests using the testthat package.</td>
</tr>
<tr class="even">
<td>Maintenance</td>
<td>Organize tasks on GitHub in Milestones and Projects; reference tasks in GitHub Pull requests and Issues; use reviewer requests on GitHub; and describe process to update packages on GRAN.</td>
</tr>
<tr class="odd">
<td>Application/practice</td>
<td>Construct the directory skeleton of a package; design and develop functions, documentation, and tests from scratch; and integrate local changes with GitHub.</td>
</tr>
</tbody>
</table>
