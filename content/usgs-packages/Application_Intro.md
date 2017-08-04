---
author: Lindsay R. Carr
date: 9999-06-01
slug: app-intro
title: Application - Introduction
draft: true 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: Introduction to USGS R Packages
    weight: 2
---
Lesson Summary
--------------

This lesson will revisit the packages taught in previous lessons and use some of their functions to create a common data analysis workflow in a modular and reproducible manner.

What is modularity and why is it more reproducible?

Modularity is the idea that your workflow leverages other tools to do some of the more general tasks. You can think of it as a sort of "plug-and-play" approach, where you are relying on functionality from another developer to perform pieces of your analysis. This also means that you should choose your tools wisely and scrutinize the tools you plan to use in your analyses.

This type of workflow is more reproducible than general scripted workflows because your maintenance responsibilities are reduced by relying on other tool maintainers to keep their code up-to-date with changing dependencies. Modularity is also more reproducible because you have outsourced some of the code complexity which makes your own code easier for someone else to understand and make contributions.

Lesson Objectives
-----------------

Use the packages and some of their functions to create a common data analysis workflow in a modular and reproducible manner.

By the end of this lesson, the learner will be able to:

1.  Automate retrieval of data via NWIS Web, ScienceBase, and the GDP through scripted, reproducible code.
2.  Use USGS packages within an overall data analysis workflow (apply modularity).
3.  Contribute to and seek help within the USGS-R community.

The Challenge
-------------

You want to produce a monthly report that summarizes the rainfall, and nutrient concentrations for your local partners. Your local partners provide an updated list of sites they want to see in the report through ScienceBase. Using the packages taught in this course, create a reproducible, modular workflow that pulls in the correct data and produces a useful summary. Have your workflow automatically "publish" the report on ScienceBase. The following lessons will walk you through the process.
