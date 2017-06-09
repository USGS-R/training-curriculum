---
author: Lindsay R. Carr
date: 9999-10-20
slug: doc
title: Documentation
draft: FALSE 
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 20
---
The quality of documentation for an R package can determine success or failure. Less documentation generally results in higher burdens, so it's best add extensive documentation as early as possible. Consider different audiences when writing package documentation: the users, current or future developers, and future you. The better documented your package, the less like you are to be burdened by answering user questions, helping onboard future developers, and spending time remembering details about the code.

Lesson Objectives
-----------------

1.  Distinguish the types of documentation for R packages.
2.  Develop documentation for individual functions.
3.  Create a vignette to highlight the top-level package uses.
4.  Edit and update README files.

Components of package documentation
-----------------------------------

Here are the components of package documentation.

-   **Function help files:** Help files are the files that document functions at an individual level and are created using Roxygen syntax (we will use the [`roxygen2` package](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html)). Roxygen allows your code and documentation to be co-located, which makes remembering to update documentation with code changes much easier.

-   **Vignettes:** HTML or PDF files that illustrate potential workflows or topics within the package. They generally are high-level, illustrating how to apply the package functions to complete an analysis.

-   **README:** This is a single file that includes directions for how to quickly get setup and started. It might include a simple workflow or call out specific functions that people might find interesting. It is essentially your chance to advertise why people should use your package.

Help files
----------

Help files are accessed when users run `?functionName`, e.g. `?mean` brings you to the help file for the function `mean`. Help files describe a function, provide the arguments and argument definitions, show default arguments when applicable, describe what the function returns to the user, points to additional resources or related functions, provides reproducible examples, and documents statistical methods and references. You can also create a [package-level help file](#pkg-level). We create these help files using Roxygen syntax, where documentation lives with the code it corresponds to. Roxygen comments are added to the same file the function is declared. When the package source files are "roxygenized", the roxygen-formatted comments are converted into `.Rd` files and added to the folder `man`. Although, the `.Rd` files look complex, R converts them to human readable formats to show when the `?` or `help` functions are used.

Roxygen style documentation requires the R package `roxygen2`. This package needs to be installed in order to generate the `.Rd` files, but does not need to be listed as a dependency in the `DESCRIPTION` file. When you build roxygen documentation, `RoxygenNote:` and a version number is automatically added at the end of your `DESCRIPTION` file.

Another note for help files: if you plan to submit your package to CRAN (see the [package maintenance](/r-package-dev/maintenance) section to learn more about considerations for CRAN), you cannot use `#` in any help file URLs.

### Function-level help files

Roxygen comments always begin with an apostrophe after the regular R comment symbol. They are followed by an `@` and then the tag specifying what section of the help file is being described. Then, details about that section are added. The roxygen comments go directly above the function you are documenting.

If you have the following function,

``` r
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

the roxygen comments would be added directly above it:

``` r
#' Location of Roxygen comments
#' 
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

The main elements to include in the roxygen comments are the title, description, arguments, returned values, and examples. See [the RStudio devtools Cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/03/devtools-cheatsheet.pdf) for a more complete list of roxygen comment and formatting elements. Note that the "Usage" field in the help file is automatically added based on your function signature.

To add the title and description, use `@title` and `@description`. Note: you can just hit enter at the end of a Roxygen line and it will automatically add `#'` at the start of the next line. Just use backspace to delete if you don't want the Roxygen syntax.

``` r
#' @title Determine if a pH value is valid.
#' @description Test to see if the pH value is greater than or equal 
#' to zero and less than or equal to fourteen.
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

The title, description, and details fields do not require the roxygen `@` tags as long as they are specified in order (title, then description, then details). All other elements require the appropriate roxygen tag.

To add arguments, use the tag `@param` followed by the argument name, and then the argument description. Building on our documentation example,

``` r
#' @title Determine if a pH value is valid.
#' @description Test to see if the pH value is greater than or equal 
#' to zero and less than or equal to fourteen.
#' @param pH a numeric vector indicating the pH. Characters will return `FALSE`.
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

This function only has one argument, but if there were more they would be added starting on the next line using the same syntax. In the argument descriptions, it is best to say what class and lengths are expected, consider the following:

-   What data structure is expected? Data frame, vector, list, length 1 vector?
-   What class is required? Numeric, logical, character?

This is your opportunity to tell the user exactly what they need to know in order to effectively use your function. You can also use [markdown formatting](https://en.support.wordpress.com/markdown-quick-reference/) to make words bold, italic, code (as shown in this example), or links to web or other help pages. You can also reference the [RStudio devtools Cheatsheet for examples](https://www.rstudio.com/wp-content/uploads/2015/03/devtools-cheatsheet.pdf).

If you are using Markdown syntax, you will need to be using `roxygen2` version 6.0 or greater. In addition, add `Roxygen: list(markdown=TRUE)` to your `DESCRIPTION` file to make that syntax available for all of your Roxygen documentation. Otherwise, add the tag `@md` in your function documentation to use it for just that function.

Next, you should describe the output of this function using the tag `@return`.

``` r
#' @title Determine if a pH value is valid.
#' @description Test to see if the pH value is greater than or equal 
#' to zero and less than or equal to fourteen.
#' @param pH a numeric vector indicating the pH. Characters will return \code{FALSE}.
#' @return a vector of logicals indicating whether the pH value was between 0 and 14
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

Similar to the argument descriptions, your description of what the function returns should include data structure and class information.

The final function documentation element we are going to discuss is the example section. Examples are arguably the most important piece to include in your function documentation. Users should be able to copy and paste your examples, get an idea of what the function does, and then amend them for their own purposes. You can add examples of a function by using the roxygen tag `@examples` followed by R code. The code should still follow the roxygen comment symbol `#'`.

``` r
#' @title Determine if a pH value is valid.
#' @description Test to see if the pH value is greater than or equal 
#' to zero and less than or equal to fourteen.
#' @param pH a numeric vector indicating the pH. Characters will return \code{FALSE}.
#' @return a vector of logicals indicating whether the pH value was between 0 and 14
#' @examples
#' is.valid.pH(5)
#' is.valid.pH(-5)
#' is.valid.pH(1:15)
#' is.valid.pH("4")
#'  
#' set.seed(5)
#' pH_vals <- runif(5, -3, 20)
#' is.valid.pH(pH_vals)
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

There is another option in the example section: `\dontrun{}`. Examples found within the `\dontrun{}` tag are examples that the package maintainer does not want CRAN to run. CRAN has specific requirements that examples cannot run too long. Also, CRAN requires every example to run without error. So, if you want to show your users an example that takes a long time to run, or if the example relies on external web services (which could introduce an error for a wide variety of uncontrollable reasons), surround that example chunk with `\dontrun{}`. CRAN specifically recommends that code within the `\dontrun{}` tag **should** be able to be run by users, it is just ignored on the package "CHECK":

[CRAN policy](https://cran.r-project.org/web/packages/policies.html): "Checking the package should take as little CPU time as possible, as the CRAN check farm is a very limited resource and there are thousands of packages. Long-running tests and vignette code can be made optional for checking, but do ensure that the checks that are left do exercise all the features of the package."

NOTE: This is a good reminder that nearly all of the examples in the `dataRetrieval` package are surrounded by `\dontrun{}`, but **all** of those examples should be considered useful, working, examples.

Now that your roxygen comments have been added, you need to build the resulting `.Rd` files. To manually build your help files, execute `roxygen2::roxygenize()`. To setup your *Build Tools* to automatically convert roxygen to `.Rd` each time you build and reload the package:

1.  Go to the *Build Tab*, click *More*, and then *Configure Build Tools*.
2.  Click the check mark next to *Generate documentation with Roxygen*.
3.  Next to *Generate documentation with Roxygen*, click *Configure...* and make sure that everything is checked. Caveat: if you create long-running [vignettes](#vignettes), you might want to uncheck that field so that they don't knit every time you build the package. Also, this configuration won't complete all the steps necessary to build the vignettes. It will only create the correct files, but not move them to the correct folders. See how to robustly build vignettes [here](#build-vignettes).

Once you build your `.Rd` files, you will see them appear in the `man` folder. Each function will have its own `.Rd`. You should now be able to use `?functionName` and see your help file. For the example we have been following, we should be able to see our help file by executing `?is.valid.pH`. You will also see a new file, `NAMESPACE` in your top-level directory. This is automatically generated from the roxygen comments - don't edit it.

<a name="pkg-level"></a>

### Package-level help file

It is optional, but nice to the user to have a "package-level" help file. Users are accustomed to looking for help by typing a `?` and function name, but if they type `?` and the package name, it's nice to give them information on the package. Here is a modified example of the `dataRetrieval` package-level help file:

``` r
#' Retrieval functions for USGS and EPA data
#'
#' \tabular{ll}{
#' Package: \tab dataRetrieval\cr
#' Type: \tab Package\cr
#' License: \tab Unlimited for this package, dependencies have more restrictive licensing.\cr
#' Copyright: \tab This software is in the public domain because it contains materials
#' that originally came from the United States Geological Survey, an agency of
#' the United States Department of Interior. For more information, see the
#' official USGS copyright policy at
#' https://www.usgs.gov/visual-id/credit_usgs.html#copyright\cr
#' LazyLoad: \tab yes\cr
#' }
#'
#' Retrieval functions for USGS and EPA hydrologic and water quality data. 
#' 
#' Please see \url{https://pubs.er.usgs.gov/publication/tm4A10} for more information.
#'
#' @name dataRetrieval
#' @docType package
#' @author Laura De Cicco \email{ldecicco@@usgs.gov}
#' @keywords USGS, web services
NULL
```

Make sure the end of the `roxygen2` code ends with a `NULL` line as shown above.

<a name="data"></a>

Exposed Data
------------

If you want to expose data sets in a package from sysdata.rda, you need to export that data. Since we are using `roxygen2` to create our NAMESPACE file, we must then create an roxygen entry for the data to be exported. For example, in the `dataRetrieval` package, there is a US county code look-up table. To export this data so that users can use it:

    #' US County Code Lookup Table
    #'
    #' Data pulled from \url{http://www2.census.gov/geo/docs/reference/codes/files/national_county.txt}
    #' on April 1, 2015. 
    #'
    #' @name countyCd
    #' @return countyCd data frame.
    #'
    #' \tabular{lll}{
    #' Name \tab Type \tab Description\cr
    #' STUSAB \tab character \tab State abbreviation \cr
    #' STATE \tab character \tab two-digit ANSI code  \cr
    #' COUNTY \tab character \tab three-digit county code \cr
    #' COUNTY_NAME \tab character \tab County full name \cr
    #' COUNTY_ID \tab character \tab County id \cr
    #' }
    #' @docType data
    #' @export countyCd
    #' @keywords USGS countyCd
    #' @examples
    #' head(countyCd)
    NULL

On the other-hand, if you simply want to create a reference for a data set that is in the "data" sub-directory (that can be loaded by the users), there's no reason to `@export` (it is simply available via lazy loading). An example from the `EGRET` package (notice, no `@export`):

    #' Example eList
    #'
    #' Example data representing data from the Choptank River at Greensboro, MD,  USGS data
    #' Data is a named list of the Daily, Sample, INFO dataframes, and the surface matrix.
    #'
    #' @name Choptank_eList
    #' @rdname sampleData
    #' @docType data
    #' @keywords water quality data
    #' @examples 
    #' head(Choptank_eList$Daily)
    NULL

<a name="vignettes"></a>

Vignettes
---------

Vignettes are PDF or HTML files made available to your users when they execute `help` and specify a package name, e.g. `help(package="dataRetrieval")`. Vignettes are typically used to explain information about the package that does not fit into the individual function documentation, such as common usages and workflows, or background information. It's a good rule of thumb to include at least one vignette to illustrate a typical workflow that someone might expect to use with your package.

Vignettes are often created using [R Markdown](http://rmarkdown.rstudio.com/) files and the `rmarkdown` package. This course will not teach how to use R Markdown, so please refer to the following links for reference:

-   [R Markdown quick tour](http://rmarkdown.rstudio.com/authoring_quick_tour.html)
-   [R Markdown overview](http://rmarkdown.rstudio.com/lesson-1.html)
-   [R Markdown cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
-   [R Markdown examples](http://rmarkdown.rstudio.com/gallery.html)

We will only show how to create HTML vignettes here. To start, create a top-level directory called `vignettes` in your package. Using the `devtools` function `use_vignettes`, you can set up the vignette template. Try it by executing `devtools::use_vignettes("my-vignette")`. You should now see an `.Rmd` (R Markdown) file in your new `vignettes` folder with the name "my-vignette". When you open the file, you will see that the header includes the following:

    title: "Vignette Title"
    author: "Vignette Author"
    date: "2017-06-09"
    output: rmarkdown::html_vignette
    vignette: >
      %\VignetteIndexEntry{Vignette Title}
      %\VignetteEngine{knitr::rmarkdown}
      %\VignetteEncoding{UTF-8}

Including `Sys.Date()` in the date field is optional but highly recommended because anytime you update the vignette, it will automatically update. The default vignette also includes a lot of information about vignettes, so don't forget to delete this to make room for your content.

In the body of the R Markdown document, add a code chunk that loads the `rmarkdown` package (`library(rmarkdown)`). Populate the rest of the document as you would any other R Markdown file. Remember, if you are unfamiliar with R Markdown, visit the list of references from above. Here's a quick example of what the .Rmd would look like:

    ---
    title: "Basic workflow of `myAwesomePackage`"
    author: "Vignette Author"
    date: "2017-06-09"
    output: rmarkdown::html_vignette
    vignette: >
      %\VignetteIndexEntry{Vignette Title}
      %\VignetteEngine{knitr::rmarkdown}
      %\VignetteEncoding{UTF-8}
    ---

    # `myAwesomePackage`

    This package is really great. It does a bunch of cool stuff. This vignette walks you through the most basic implementation.

    ## Getting data

    etc ...

<a name="build-vignettes"></a>

Save your new R Markdown file. To get the vignette to show up in your R package, you then need to:

``` r
devtools::build_vignettes()
```

This will create the html output, an R script that is just the executable R code in the vignette, and a copy of the markdown file, moving all 3 of those files into the inst/doc folder. Don't rely on your build configurations to automatically do these steps for you - it will only create the `.R` and `.html` files, but not move them to the correct folders.

READMEs
-------

The README file is a top-level markdown file that usually contains information about how to install the package, how to get started on some basic functions, where to go for reporting bugs or feature requests, and a disclaimer or copyright information about the open source software. All USGS packages should have the Disclaimer field in the README that points to [the official USGS copyright policy](https://www2.usgs.gov/visual-id/credit_usgs.html#copyright/). Note that README files are shown on the home page of a GitHub repository, and is a good way to summarize why people should use your package.

![What README files look like on GitHub](../static/img/README_on_github.png "readme file")

The previous section discussed how to format R Markdown (`.Rmd` ) files and knit them to Markdown files (`.md`). README files are created in a similar way, you just need to include the following as your R Markdown header:

    title: "README"
    author: "R"
    date: "09 June, 2017"
    output:
      md_document:
        variant: markdown_github

Here is an example `README.Rmd`:

    ---
    title: "README"
    author: "R"
    date: "09 June, 2017"
    output:
      md_document:
        variant: markdown_github
    ---

    #`myAwesomePackage`

    A package with really awesome functions that are used to help creating amazingly reproducible workflows.

    ##Installation

    To install the myAwesomePackage package, you must be using R 3.0 or greater and run the following command: `install.packages("myAwesomePackage")`.
      
    ##Reporting bugs

    Please consider reporting bugs and asking questions on the Issues page.

    ##Disclaimer

    This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey, an agency of the United States Department of Interior. For more information, see the [official USGS copyright policy](https://www2.usgs.gov/visual-id/credit_usgs.html#copyright)

    Although this software program has been used by the U.S. Geological Survey (USGS), no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

    This software is provided "AS IS."

    [![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)](http://creativecommons.org/publicdomain/zero/1.0/)
