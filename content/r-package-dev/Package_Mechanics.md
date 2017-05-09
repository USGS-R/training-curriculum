---
author: 
date: 9999-11-15
slug: mechanics
draft: True
title: Package Mechanics
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
This lesson provides definitions and examples of

Lesson Objectives
-----------------

1.  What are the structural components of an R-package?
2.  How do packages depend on other packages?
3.  How can data be included?
4.  USGS-specific: License and Disclaimers
5.  How-to: build and check
6.  Why create internal functions?

Minimum Package Requirements
----------------------------

There are many excellent resources on how to create an R package. One of the most commenly referenced is [Hadley's R packages](http://r-pkgs.had.co.nz/). It is a very complete guide to the mechanics of R-packages. For more details and longer explainations, please see that page.

This section provides the briefest of introductions, but enough to get you started.

Package Skeleton
----------------

Let's build a bare-bones package from scratch, defining each section as we go. We are using RStudio as our working environment, so let's first create a new Project called "demoPackage". Note we could do all of this by hand as well.

Step 1: Open New Project:

<img class="sideBySide" src="../static/img/newProject.png" alt="New Project", title="New Project">

Step 2: Choose New Package option:

<img class="sideBySide" src="../static/img/newPackage.png" alt="New Package", title="New Package">

Step 3: Name your package:

<img class="sideBySide" src="../static/img/newPackageII.png" alt="Name Package", title="Name Package">

So now, let's look at what was created:

<img class="sideBySide" src="../static/img/packageSkeleton.png" alt="Minimum Package Requirements", title="Minimum Package Requirements">

Other useful resources
----------------------

There is no shortage of resources on R developers documenting how to create a package.

-   [Hadley's R packages](http://r-pkgs.had.co.nz/)
