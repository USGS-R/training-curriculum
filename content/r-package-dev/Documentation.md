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

Help files are accessed when users run `?functionName`, e.g. `?mean` brings you to the help file for the function `mean`. Help files describe a function, provide the arguments and argument definitions, show default arguments when applicable, describe what the function returns to the user, points to additional resources or related functions, and provides reproducible examples. Roxygen comments are added to the same file the function is declared. When the package source files are "roxygenized", the roxygen-formatted comments are converted into `.Rd` files and added to the folder `man`. Although, the `.Rd` files look complex, R converts them to human readable formats to show when the `?` or `help` functions are used.

Roxygen style documentation requires the R package `roxygen2`. This package needs to be installed in order to generate the `.Rd` files, but does not need to be listed as a dependency in the `DESCRIPTION` file. **RoxygenNote: 6.0.1 ?!?! in dataRetrieval**

Roxygen comments always begin with a `#'`, notice the apostrophe after the regular R comment symbol. They are followed by an `@` and then the tag specifying what section of the help file is being described. Then, details about that section are added. The roxygen comments go directly above the function you are documenting.

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

The main elements to include in the roxygen comments are the title, description, arguments, returned values, and examples. See (the RStudio devtools Cheatsheet)\[<https://www.rstudio.com/wp-content/uploads/2015/03/devtools-cheatsheet.pdf>\] for a more complete list of roxygen comment and formatting elements. Note that the "Usage" field in the help file is automatically added based on your function signature.

To add the title and description, use `@title` and `@description`:

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
#' @param pH a numeric vector indicating the pH. Characters will return \code{FALSE}.
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

This function only has one argument, but if there were more they would be added starting on the next line using the same syntax. In the argument descriptions, it is best to say what class and lengths are expected, consider the following:

-   What data structure is expected? Data frame, vector, list, length 1 vector?
-   What class is required? Numeric, logical, character?

This is your opportunity to tell the user exactly what they need to know in order to effectively use your function. You can also use other roxygen formatting to make words bold, italic, code (as shown in this example), or links to web or other help pages. See the (RStudio devtools Cheatsheet for examples)\[<https://www.rstudio.com/wp-content/uploads/2015/03/devtools-cheatsheet.pdf>\].

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

The final function documentation element we are going to discuss is the example section. Show users examples of a function by using the roxygen tag `@examples` followed by R code. The code should still follow the roxygen comment symbol `#'`.

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

Sometimes people using `\dontrun{}` to show examples of code that will cause in error. To use this, add your example code that will cause an error inside of the `{ }`.

``` r
#' @title Determine if a pH value is valid.
#' @description Test to see if the pH value is greater than or equal 
#' to zero and less than or equal to fourteen.
#' @param pH a numeric vector indicating the pH
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
#' \dontrun{
#' is.valid.pH()
#' }
#'
is.valid.pH <- function(pH){
    pH >= 0 & pH <= 14
}
```

Now that your roxygen comments have been added, you need to build the resulting `.Rd` files. There are a few ways to do this:

1.  Run `devtools::document()`.
2.  Run `roxygen2::roxygenise()`.
3.  Setup your *Build Tools* to automatically convert roxygen to `.Rd` each time you build and reload the package. Go to the *Build Tab*, click *More*, then *Configure Build Tools*, and then click the checkmark next to *Generate documentation with Roxygen*. Next to *Generate documentation with Roxygen*, click *Configure* and make sure that everything is checked.

Once you build your `.Rd` files, you will see them appear in the `man` folder. Each function will have it's own `.Rd`. You should now be able to use `?functionName` and see your help file. For the example we have been following, we should be able to see our help file by executing `?is.valid.pH`.

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

**NEED `VignetteBuilder: knitr` or `BuildVignettes: true` in DESCRIPTION ?!?! **
