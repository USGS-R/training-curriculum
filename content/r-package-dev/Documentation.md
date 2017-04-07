---
author: Lindsay R. Carr
date: 9999-07-31
slug: doc
title: Documentation
draft: True
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
The quality of documentation for an R package can determine it's success or failure. Less documentation generally results in higher burdens for package developer's, so it's best add extensive documentation as early as possible. Consider 3 different audiences when writing pacakge documentation: the users, current or future developers, and future you. The better documented your package the less like you are to be burdened by answering user questions, helping onboard future developers, and spending time remembering details about the code.

Lesson Objectives
-----------------

1.  Distinguish the different types of documentation for R packages.
2.  Develop documentation for individual functions.
3.  Create a vignette to highlight the top-level package uses.
4.  Edit and update README files.

Components of package documentation
-----------------------------------

There are multiple components of package documentation.

-   **README:** In the README, you include directions for how to quickly get setup and started. It might include a simple workflow or call out specific functions that people might find interesting.
-   **Function help files:** Help files are the files that document the inputs and outputs of a function, references and links to related functions, define defaults for the user, and give examples of how to use the function. These files apply to functions at an individual level and are created using Roxygen syntax (we will use the [`roxygen2` package](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html).
-   **Vignettes:** Packages can have multiple vignettes to illustrate potential workflows or topics within the package. They generally are high-level, illustrating how to apply the package functions to complete an analysis.

The README was already discussed in [*What is a Package?*](/pkg-def), so we won't be covering it further here. Just remember that this is a useful way to give someone a brief introduction to your package.

Help files
----------

Vignettes
---------

Vignettes are PDF or HTML files made available to your users when they execute `help` and specify a package name, e.g. `help(package="dataRetrieval")`. Vignettes are typically used to explain information about the package that does not fit into the individual function documentation, such as common usages and workflows, background information, or statistical methods and references. It's a good rule of thumb to include at least one vignette to illustrate a typical workflow that someone might expect to use with your package.

Vignettes are created using [R Markdown](http://rmarkdown.rstudio.com/) files and the `rmarkdown` package. This course will not teach how to use R Markdown, so please refer to the following links for reference:

-   [R Markdown quick tour](http://rmarkdown.rstudio.com/authoring_quick_tour.html)
-   [R Markdown overview](http://rmarkdown.rstudio.com/lesson-1.html)
-   [R Markdown cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
-   [R Markdown examples](http://rmarkdown.rstudio.com/gallery.html)

To start, create a top-level directory called `vignettes` in your package. Using the `devtools` function `use_vignettes`, you can set up the vignette template. Try it by executing `devtools::use_vignettes("my-vignette")`. You should now see an `.Rmd` (R Markdown) file in your new `vignettes` folder with the name "my-vignette". When you open the file, you will see that the header includes the following:

``` r
title: "Vignette Title"
author: "Vignette Author"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
```

Including `Sys.Date()` in the date field is optional but highly recommended because anytime you update the vignette, it will automatically update. The default vignette also includes a lot of information about vignettes, so don't forget to delete this to make room for your content.

In the body of the R Markdown document, add a code chunk that loads the `rmarkdown` package (`library(rmarkdown)`). Populate the rest of the document as you would any other R Markdown file. Remember, if you are unfamiliar with R Markdown, visit the list of references from above.

Save your new R Markdown file. The next time you build your package, your vignette should now be available!
