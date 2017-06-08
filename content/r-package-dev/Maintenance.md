---
author: Jordan S. Read
date: 9999-06-30
slug: maintenance
title: Maintenance
draft: FALSE 
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

**Personal use support**

If you are having trouble motivating yourself to fill in documentation and create tests because you are the only user of the package you are writing, remember that you are supporting future you. Future you doesn't remember the assumptions that you made when writing that package, and future you wishes you had dropped a few hints as to what that clever chunk of code was supposed to do. The "Personal use" user group is noted here because it is common (turning your scripts into a cohesize package gives you access to all of those general benefits of R packages), but our advice is to design and maintain a package for yourself in an identical fashion to supporting several knowledgeable users.

**Core group support**

When a package is created for a core group of collaborators that are familiar with R packages and the details of this particular package, you can raise expectations for their patience and willingness to make your maintanence job easier. If you are supporting this particular user tier, don't be afraid to expect more, and provide less. Core users should know how to find answers to their general R issues (and not ask you to solve them), be able to quickly navigate help files, and they should also be willing to take the time to provide good bug reports to you (which helps save you time in fixing them). This group should be able to understand that your time is limited and their issues and suggestions should be prioritized.

**Mixed user support**

Collaborations often involve diverse skill sets and when your package supports a group of mixed users (i.e., some users have the familiarity defined in "Core" but others are quite new to R), some of the expectations you can excercise when supporting "Core groups" will need to be dialed back initially. The goal of supporting a mixed user group should be to convert those users into a "Core group" that is more knowledgeable about solving some problems themselves and can learn how to request package changes or file thoughtful bug reports. Effort spent in the early days of package maintenance to teach users how to engage will be worth it.

**CRAN distribution support**

When your package is hosted on CRAN, it can be installed by a wide user group with variable skills. The contrast between this group and the "Mixed users" mentioned above is that there will be many more users, and you won't be able to reach the majority of them to apply the pre-emptive measures stated above. Instead, you will need to rely on expanding documentation with clean language and examples and (in some cases) limiting what functions are exposed to users to those that are robust, well tested, and aren't expected to change in major ways in the future. Widely distributing a package should be considered a statement that you are confident the offering works as expected and that users can use the public functions without worry that they will disppear or be renamed in the next release.

### Level of support

Defining the level of support you offer can help you prioritize maintenance efforts and establish expectations for users. When defining and communicating a level of support, differentiate between R support for your package and general support for the R language. We consider three different levels of support that you can offer users:

-   No expectations of support
-   Fixes/changes only applied when in development mode
-   Always on duty
-   Changes agreed upon by committee

Your level of support should be clear to users of the package if it differs from the expectation that someone will quickly answer emails sent to the package maintainer. If, for example, you are not offering any support (i.e., "Use at your own risk!"), that message should appear on package startup as a constant reminder that you will be AWOL when they come knocking.

*A note on support:* Deferentiate between general R support and package support. Letting users know you are answering their R question (that is not related to your package) as a colleague vs as the maintainer of the package is important for setting and managing expectations.

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

    ## [1] '3.4.0'

When you start a package, the major version should remain at 0 and stay that way until the package and features are mature enough to represent a set of functions and data that users of your package can program against as expect consistency. Changes to the major version represent changes that are expected to *break* the code of users that are relying on your package. Using a major version of 0 communicates to users that are familiar with these guidelines that the package features are unstable and subject to change without warning.

The second number in the version string should be incremented when new features are added to the package, but these features don't alter the experience of features (or functions) that already existed in a previous version.

The third number is incremented when small bugs are fixed (in a way that is backwards compatable), documentation is updated or expanded, and other small changes to existing internal code are made (such as restructuring and commenting).

*Note:* Many R users are not familiar with semantic versioning, so sharing this information with collaborators can be helpful both for you (as they use your package and see it evolve) and also as they navigate the bigger ecosystem of R packages and software in general.

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

Make sure you understand your preferred way of interacting with users of your package. This could be email, phone, or GitHub issues (among other things). We prefer GitHub issues because they are public and thus visible to other users who may have the same question or want to add to the discussion. You can also easily manage issues or questions in github by labeling them: ![Labeling github issues](../static/img/maintenance_labeled_issues.png#inline-img "using labels for github issues")

Maintaining your R package
--------------------------

Getting down to how to plan and execute the work of maintaining your package. We have a recommended pattern that works well for packages within the U.S. Geological Survey that are distributed via [GRAN](https://owi.usgs.gov/R/gran.html):

-   Identify requirements of package maintenance.
-   Organize tasks on GitHub in Milestones and Projects.
-   Reference tasks in GitHub Pull Requests and Issues.
-   Use reviewer requests on GitHub.
-   Updating packages on GRAN.

### Identify requirements of package maintenance

How do you decide on maintenance priorities? Unless you have a full time job to support a single package, you will often have to make hard decisions about what changes to prioritize over others. Priorities are decided in a number of different ways, and package developers and maintainers have different roles in that prioritization. In some cases, we take cues from a committee that decides what is important, and in other cases a single individual has full say over what the maintenance priorities are. Having a blended role can work out best, where there is oversight provided via collaboration, but the maintainer still have a clear seat at the table. Ultimately, deciding on priorities and requirements happens in different ways and we suggest formalizing the process of gathering this information in a way that is sustainable and includes clear expectations for all parties.

### Organize tasks on GitHub in Milestones and Projects

Organizing your planned or unplanned package work in a transparent fashion helps you keep track of things, but also keeps your users in the loop for what they can expect to see happen in the future. GitHub has two nice ways to organize existing issues (issues are a good way to capture the package tasks) in `milestones`: ![github milestones](../static/img/github_milestones.png#inline-img "github milestones")

GitHub also supports the more elaborate `projects`, which provide "swimlanes" for issues that you can define yourself. Presently, projects and milestones are specific to an individual code repository (e.g., you can't share a single milestone for two different R packages). A screenshot of a `project` for [streamMetabolizer](https://github.com/USGS-R/streamMetabolizer/projects/1): ![github projects](../static/img/github_projects.png#inline-img "github projects")

Both are good options for planning and orchestrating work, and can be used together (e.g., you can have several "milestones" targeted in a project). I use milestones for things like "initial release to partners" and each minor or major version update to CRAN.

### Reference tasks in GitHub Pull Requests and Issues

Linking comments in your pull request to the issue (or issues) that the change is fixing helps close the loop in the conversation contained in the issue, and also lets someone who is following the issue (or you, when you are looking back at it later) understand when and where the change to the code was made. ![issue number referenced in github PR](../static/img/issue_reference_PR.png#inline-img "issue number referenced in github PR") In the above example, [\#293](https://github.com/USGS-R/streamMetabolizer/issues/293) links directly to the issue and the conversation.

**Bonus:** *commenting in a pull request `fixes #293` will automatically close issue 293 and link to your pull request.*

### Use reviewer requests on GitHub

It is almost always a good idea to have some peer review on your code. We recommend this because it keeps you from getting too insolated in your development practices and helps expose others to your code, so that they can have an easier time contributing to it. This practice is made easier by requesting peer review on a github.com pull request: ![github reviewer requests](../static/img/github_reviewer_request.png#inline-img "using github reviewer requests")

### Updating packages on GRAN

Adding a package to GRAN has a basic workflow that is relatively simple to follow. First, "tag" a stable release of your package on github (e.g., of a [streamMetabolizer release](https://github.com/USGS-R/streamMetabolizer/releases/tag/v0.10.1). Tagging looks like this on GitHub: ![github release](../static/img/tagging_GRAN.png#inline-img "using tags for github release")

Next, if you don't already have a [fork](https://help.github.com/articles/fork-a-repo/) of the `grantools` R package, fork it [here](https://github.com/USGS-R/grantools): ![forking grantools](../static/img/fork_GRAN.png#inline-img "forking grantools")

Within the `grantools` package, there is a file at `inst/gran_src_list.tsv`. This is a tab-delimited file that contains the release version information and the repository for GRAN to grab the package from. Add your information to that file, but **make sure** that the tag name you used above is the same as the one you add to the file: ![grantools change source list](../static/img/change_src_list.png#inline-img "change source list")

Create a [`grantools` pull request](https://github.com/USGS-R/grantools/pulls) of your change *from your fork*: ![grantools GRAN pull request](../static/img/pr_GRAN.png#inline-img "GRAN pull request")

After you do this, GitHub kicks off a script that tests a few things related to the package you are adding, including making sure there is a release tag name on the repo you pointed to that is identical to the name in the `inst/gran_src_list.tsv`. The pull request will "fail" if one of these tests don't pass.

Helpful guidance for new developers
-----------------------------------

Below you will find a number of "lessions learned" in the process of developing and maintaining software packages

### Planning and prioritizing maintenance and improvements

Unless there is a formal process in place for determining what improvements should be added to a package, it is difficult to keep progress moving in a direction that is sustainable and meets the real priorities. Common pitfalls to lack of clear prioritization:

-   *"This will be a fun feature to implement" wins over "Users need this".* It is easy to pick off of the top of the issue list based on what you want to do over what you should do. Question to ask yourself "am I inventing a priority?"
-   *Death by a thousand commits.* It is easy to burn yourself out dealing with every request that comes in. When everything is a priority, nothing is.
-   *Loudest user wins.* Sometimes your package may have a number of users, but only one that is in direct communication with you for things like feature requests or bug reports. Does this user represent the breadth of your user group? If not, you may want to solicit additional opinions or priorities.
-   [*Premature optimization.*](http://wiki.c2.com/?PrematureOptimization) Spending time wisely can mean putting up with slower code in the early stages and avoiding the temptation to focus on speeding things up when you don't really know what parts of your package need to be fast.

### Diversifying package support

Being the single developer on a package is lonely, can lead to bad practices, and also creates a single point of failure. We know that this is still really common and we are guilty of it ourselves. But...it is often worthwhile to try to recruit additional contributions to your package from others. A number of folks have been using on-ramp labels to get new user contributions to packages that expose the process of contribution code while keeping the task relatively simple: ![recruiting new helpers](../static/img/beginner_code_request_label.png#inline-img "recruiting new development help")

Once others are onboarded, they may realize they can contribute that feature they have been asking for and as long as you have good tests in place (*hint, hint, see* [writing tests](/r-package-dev/writing-tests))

If you are supporting a popular package, you can also set up support forums, feed an active stackoverflow community, or encourage other engagement to help answer user questions.

Common pitfalls to diversifying package support:

-   *I can solve it quick.* Yes, the maintainer can often answer a question or code a solution an order of magnitude faster than another user or contributor, but this doesn't help you deal with the long term support burden.
-   *Others don't follow the same coding practices.* Set up a style guide for the code, and make sure your tests are implemented. Also see [goodpractice](https://github.com/MangoTheCat/goodpractice) package for design testers.

Check out this onboarding activity in the wild that happened on the [remake](https://github.com/richfitz/remake/issues/152) package: ![remake conversation](../static/img/remake_convo.png#inline-img "remake feature addition")

### The many benefits to simpler code

Oh my do you want to keep it simple if you can. It may seem clever to take advantage of a brand new package's features and pull some of their functions in, but better for you, better for other (potential contributors). This includes how you write, and what other packages you rely on, and whether or not you follow a common pattern that others in your group use too.

Common pitfalls:

-   *Clever vs clean.* Code clarity at the cost of speed is worth it in many (most) conditions.
-   *Premature optimization.* see above, but often we add complexity with unnecessary optimization
-   *S4 methods.* [geoknife](https://github.com/USGS-R/geoknife) uses `S4` objects/methods, and while they are helpful for that package, it is the only package our group maintains that uses S4. Is it worth it? Not sure.

### Understanding the dependency tree

What otehr packages does your package depend on? And what packages do those packages depend on? And so on...

The dependency tree in R is hard to lock down (although see [packrat](https://rstudio.github.io/packrat/), [MRAN](https://mran.microsoft.com/documents/rro/reproducibility/), [miniCRAN](https://cran.r-project.org/web/packages/miniCRAN/vignettes/miniCRAN-dependency-graph.html), and others). It makes sense understand your dependency tree and weaknesses in it.

Common pitfalls:

-   *Depending on an errorprone package.* The [XML](https://cran.r-project.org/package=XML) package is an excellent example. This package hurts.
-   *Implicitly relying on key features of an dependency update.* You updated your local version of a package dependency when you build your new changes in, but did your users? Communicating when a user needs to update a package version of a package you depend on is important. Cleanest way to do this is to update the requirement for that package in the DESCRIPTION file (e.g., `httr (>= 1.0.2)`).

### Getting out ahead of incoming problems

It is nice to avoid the inconvienent scramble by knowing when changes in other packages (or the R language) are happening. So, it makes sense to run your tests against various versions of R: [Setting up travis to test different versions of R:](https://docs.travis-ci.com/user/languages/r#R-Versions)

``` yaml
language: r
r:
  - oldrel
  - release
  - devel
```

And also it makes sence to test against development versions of the packages you heavily rely on.

Other useful resources
----------------------

-   [Semantic Versioning](http://semver.org/)
-   [Forking a repository](https://help.github.com/articles/fork-a-repo/)
-   [R package Release](http://r-pkgs.had.co.nz/release.html)
