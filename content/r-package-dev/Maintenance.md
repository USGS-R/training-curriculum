---
author: Jordan S. Read
date: 9999-06-30
slug: maintenance
title: Maintenance
draft: True
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 40
---
Package maintenance is the process of continuing to keep your package operating effectively over time, including keeping up with changes to R itself and the underlying packages that your package depends on. Additionally package maintainence often involves addressing minor bugs and optionally includes adding new features.

Lesson Objectives
-----------------

1.  Define various levels of maintenance and user groups.
2.  Discuss strategies for short- and long-term package maintenance.
3.  Explain how to communicate your level of support.

Introduction to package maintenance concepts
--------------------------------------------

So, what are you really on the hook for when creating a package? It depends on what audience your package was intended for, what level of support you have committed to, how complex it is, and how robust it is against external changes.

### User groups

-   Personal use (you are building this package for yourself, and future you)
-   Core group of knowledgeable users (a package created to capture common or shared processes within a group)
-   Mix of known users with various levels of skill (similar to above, but with users that may not understand R basics)
-   Unknown users with wide skill distribution (the typical case of CRAN)

#### **Personal use support**

If you are having trouble motivating yourself to fill in documentation and create tests because you are the only user of the package you are writing, remember that you are supporting future you. Future you doesn't remember the assumptions that you made when writing that package, and future you wishes you had dropped a few hints as to what that clever chunk of code was supposed to you. The "Personal use" user group is noted here because it is common (turning your scripts into a cohesize package gives you access to all of those general benefits of R packages), but our advice is to design and maintain a package for yourself in an identical fashion to supporing several knowledgeable users.

#### **Core group support**

When a package is created for a core group of collaborators that are familiar with R packages and the details of this particular package, you can raise expectations for their patience and willingness to make your maintanence job easier. If you are supporting this particular user tier, don't be afraid to expect more, and provide less. Core users should know how to find answers to their general R issues (and not ask you to solve it), be able to quickly navigate help files, and they should also be willing to take the time to provide good bug reports to you (which helps save you time in fixing them). This group should be able to understand that your time is limited and issues should be prioritized.

#### **Mixed user support**

Collaborations often involve diverse skill sets and when your package supports a group of mixed users (i.e., some users have the familiarity defined in "Core" but others are quite new to R), some of the expectations you can excercise when supporting "Core groups" will need to be dialed back initially. The goal of supporting a mixed user group should be to convert those users into a "Core group" that is more knowledgeable about solving some problems themselves and can learn how to request package changes or file thoughtful bug reports. Effort spent in the early days of package maintenance to teach users how to engage will be worth it.

#### **CRAN distribution support**

When your package is hosted on CRAN, it can be installed by a wide user group with variable skills. The contrast between this group and the "Mixed users" mentioned above is that there will be many more users, and you won't be able to reach the majority of them to apply the pre-emptive measures stated above. Instead, you will need to really on expanding documentation with clearn language and examples and (in some cases) limiting what functions are exposed to users to those that are robust, well tested, and aren't expected to change in major ways in the future. Widely distributing a package can be taken as a statement that you are confident the offering works as expected and that users can use the public functions without worry that they will disppear or be renamed in the next release.

### Level of support

Defining the level of support you offer can help you prioritize maintenance efforts and establish expectations for users. When defining and communicating a level of support, differentiate between R support for your package and general support for the R language. We consider three different levels of support that you can offer users:

-   no expectations of support
-   Fixes/changes only applied when in development mode
-   Changes agreed upon by committee

A note on support: Deferentiate between general R support and package support...

Setting expectations for package maintenance
--------------------------------------------

There are several approaches available for clearing communicating level of support (and targeted user groups) to users of your package. We recommend the followig techniques:

### Sunset dates and other disclaimers

Any important disclaimers should be communicated with a startup `message` when the package is loaded. Creating an `.onAttach()` will result in the function being called each time the package is loaded. It can perform startup activities and contain information:

``` r
#' @import methods
#' @keywords internal
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("This package is in development. We are using it for our own early applications and welcome flexible, resilient new users who can help us make the package better. Details of the user interface and model implementations will change. Please give us feedback at https://github.com/USGS-R/streamMetabolizer/issues/new.\n")
```

This example provides helpful information to users, including setting expectations for changes and making it clear how to provide information.

### Communicating through the package version

The package version is meaningful regardless of whether you are supporting one or one million users. We follow the [semantic versioning](http://semver.org/) for setting and changing package versions, which includes three numbers: the major version, the minor version, and the patch version. The string that stores the version number is in your package's DESCRIPTION file. Extracting the version of a package is as simple as

``` r
packageVersion('graphics')
```

    ## [1] '3.3.2'

When you start a package, the major version should remain at 0 and stay that way until the package and features are mature enough to represent a set of functions and data that users of your package can program against as expect consistency. Changes to the major version represent changes that are expected to *break* the code of users that are relying on your package. Using a major version of 0 communicates to users that are familiar with these guidelines that the package features are unstable and subject to change without warning.

The second number in the version string should be incremented when new features are added to the package, but these features don't alter the experience of features (or functions) that already existed in a previous version.

The third number is incremented when small bugs are fixed (in a way that is backwards compatable), documentation is updated or expanded, and other small changes to existing internal code are made (such as restructuring and commenting).

### Deprecation of functions or features

If you plan to get rid of a function that no longer is useful or is redundant with another part of the package, it helps to give your users a heads up. R's `.Deprecated()` function call can be placed inside the function that you want to get rid of and point users to a different function:

``` r
summarize_sim <- function(file, sim_outputs, fig_path){
  .Deprecated('plot_var')
  invisible(NULL)
}

summarize_sim()
```

    ## Warning: 'summarize_sim' is deprecated.
    ## Use 'plot_var' instead.
    ## See help("Deprecated")

Alternatively, you can warn users that a function may be changing in the future

``` r
summarize_sim <- function(...){
  warning(paste0('inputs to ', match.call()[[1]], ' are subject to change'))
  invisible(NULL)
}
summarize_sim()
```

    ## Warning in summarize_sim(): inputs to summarize_sim are subject to change

### Failing fast for unimplemented features

If there is an edge-case for a function that you haven't implemented, make sure you throw an error that let's the user know this part of your package isn't functional (note, this should only happen when someone is installing a development version of your code, and you shouldn't have incomplete features in a package version &gt; 1.0.0). One way to do this is to give a user a way to +1 finishing up this feature in the error:

``` r
summarize_sim <- function(..., fig_path = FALSE){
  if (is.character(fig_path)){
    stop('figure save not currently supported. Use fig_path = FALSE ',
         'if you need this feature, let us know at ','https://github.com/USGS-R/glmtools/issues/new',
         call. = FALSE)
  }
  plot(...)
}
summarize_sim(x=c(4,5), y=c(0,89), fig_path = '../my_figure.png')
```

    ## Error: figure save not currently supported. Use fig_path = FALSE if you need this feature, let us know at https://github.com/USGS-R/glmtools/issues/new

### Define *how* to engage with package developers

e.g., github, email, other

Maintaining your R package
--------------------------

From GH issue: **THIS IS PLACEHOLDER TEXT** \* Identify requirements of package maintenance. \* Organize tasks on GitHub in Milestones and Projects. \* Reference tasks in GitHub Pull Requests and Issues. \* Use reviewer requests on GitHub. \* Describe process to update packages on GRAN.

### Planning and priorotizing maintenance and improvements

Common pitfalls:

-   "This will be a fun feature to implement" wins over "Users need this"
-   death by a thousand commits

### Diversifying package support

add/recruit other maintainers rely on support forums or other engagement to help answer user questions

Common pitfalls: \* I can solve it quick

### The many benefits to simpler code

better for you, better for other (potential contributors) This includes how you write, and what other packages you rely on

Common pitfalls: \* clever vs clean \* Premature optimization

### Understanding the dependency tree

Common pitfalls: \* backwards compatibility \* Implicitly relying on key features of an dependency update

### Getting out ahead of incoming problems

Avoding the inconvienent scramble

### Creating a maintenance rhythmn

### How to gracefully throw in the towell

### Stepping up effort and expectations

Other useful resources
----------------------

-   [Semantic Versioning](http://semver.org/)
-   [R package Release](http://r-pkgs.had.co.nz/release.html)
