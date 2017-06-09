---
author: Lindsay R. Carr
date: 9999-12-31
slug: getting-started
title: Getting Started
draft: FALSE 
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

Software installation:

-   [R](https://cran.rstudio.com/bin/windows/base/) (latest version)
-   [RStudio](https://www.rstudio.com/products/rstudio/download2/) (&gt;1.0)
-   [RTools](https://cran.r-project.org/bin/windows/Rtools/) (compatible with your version of R)
-   R packages: devtools, roxygen2, testthat, knitr

Suggested prerequisite knowledge
--------------------------------

This course discusses advanced topics in programming. Transitioning from a scripting mentality to package development can be challenging; we recommend you have advanced knowledge of R programming to use this curriculum. Please refer to the list below to see if you qualify. In addition, putting time and effort into package development is more useful if you have an existing script that could be useful to yourself and others if it were turned into a package.

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
-   writing and using my own functions.

Course overview
---------------

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 1. Summary of available modules.
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Module
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Objectives
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
What Is a Package?
</td>
<td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;'>
1.  Distinguish scripts and packages.<br/>2. Compare benefits and challenges of package creation.<br/>3. Identify alternatives to packages.<br/>4. Recall USGS and DOI policies related to publishing and maintaining code.
    </td>
    </tr>
    <tr style='background-color: #f7f7f7;'>
    <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
    Package Mechanics
    </td>
    <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;'>
    1.  List the structural components of an R-package.<br/>2. Understand package dependency trees.<br/>3. Be familiar with different ways data can be included in packages.<br/>4. Correctly define what licenses and disclaimers are needed for USGS software.<br/>5. Apply the build and check features to a package.<br/>6. Define internal functions and know their benefits.
        </td>
        </tr>
        <tr>
        <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
        Version Control
        </td>
        <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;'>
        1.  Define version control and give examples of how it is useful.<br/>2. Navigate the GitHub interface.<br/>3. Summarize a typical GitHub-to-R workflow.
            </td>
            </tr>
            <tr style='background-color: #f7f7f7;'>
            <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
            Documentation
            </td>
            <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;'>
            1.  Distinguish the types of documentation for R packages.<br/>2. Develop documentation for individual functions.<br/>3. Create a vignette to highlight the top-level package uses.<br/>4. Edit and update README files.
                </td>
                </tr>
                <tr>
                <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
                Debugging
                </td>
                <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;'>
                1.  Identify different types of errors.<br/>2. Describe the available debugging tools in R and RStudio, namely `traceback()`, `debug()`, breakpoints, and `browser()`. <br/>3. Apply debugging tools to locate a particular error in your code.<br/>4. Use debugging tools to find errors in unfamiliar functions.
                    </td>
                    </tr>
                    <tr style='background-color: #f7f7f7;'>
                    <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
                    Defensive Programming
                    </td>
                    <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;'>
                    1.  Define defensive programming and give examples of problems to defend against.<br/>2. List common techniques for defensive programming.<br/>3. Construct and execute defensive programming functions.
                        </td>
                        </tr>
                        <tr>
                        <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
                        Writing Tests
                        </td>
                        <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;'>
                        1.  Recognize the purpose and value of writing tests.<br/>2. Understand different types of testing and when to apply them.<br/>3. Describe good test writing practices.<br/>4. Identify appropriate testing frequency.
                            </td>
                            </tr>
                            <tr style='background-color: #f7f7f7;'>
                            <td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
                            Maintenance
                            </td>
                            <td style='padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;'>
                            1.  Define various levels of maintenance and user groups.<br/>2. Discuss strategies for short- and long-term package maintenance.<br/>3. Explain how to communicate your level of support.
                                </td>
                                </tr>
                                </tbody>
                                </table>
