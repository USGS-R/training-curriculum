---
author: David Watkins
date: 9999-04-30
slug: debugging
title: Debugging
draft: True
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
Debugging is an integral part of package development and maintenance. As you write more complex code, errors can often happen several functions deep. Unlike in a script, you don't by default have access to the R variables where the error occured. Fortunately, RStudio provides many useful tools to help.

Lesson Objectives
-----------------

1.  Understand and be able to use the debugging tools in R and RStudio, namely `traceback()`, `debug`, and breakpoints.
2.  Be able to track down an error to a particular line in an unfamiliar function, and view the environment where the error occurred

Types of errors
---------------

Broadly speaking, there are three ways your code can fail:

-   *syntax* - Syntax errors are generally typos that prevent your code from running in the first place, such as a missing closing parenthesis. We won't deal with these much in this material. Rstudio's syntax highlighting features should make these relatively obvious, with a red squiggly line or 'x' icon on the offending line.

-   *runtime* - Runtime errors occur when the program begins to execute, but fails part way through.

-   *logical* - Logical errors are the most insidious, as the program runs to completion but does not produce the desired results.

If you have done a good job with testing and defensive programming **(LINK TO SECTIONS HERE)**, most logic problems should result in explicit run-time errors.

The debugging process
---------------------

Firstly, you need to determine where the error occured. Note that this only means the *line where the function failed* -- this is not necessarily the problem line of code, only where it was caught. However, knowing where the error happened gives you a starting point you can work backwards from to the real source of the problem. For instance, a data frame could lose a column you weren't expecting during a join, but a failure doesn't occur until much later when that missing column is actually used.

To start, lets create some simple functions ourselves. This example is modified from [Hadley Wickham's page on debugging.](http://adv-r.had.co.nz/Exceptions-Debugging.html#debugging-tools) We know `func4` will fail since it is adding a numeric and a character, but lets see how we would approach it if we didn't know this.

``` r
func1 <- function(x){func2(x)}
func2 <- function(x){func3(x + 1)}
func3 <- function(x){func4(x + 4)}
func4 <- function(x){
  y = "a"
  x <- x + y
  return(x)
}

func1(7)
```

    ## Error in x + y: non-numeric argument to binary operator

The error message "non-numeric argument to a binary operator" tells us R was expecting a numeric object but got something else. We don't know where this happened though. To show the sequence of function calls that led to the error, click the `Show Traceback` button.
![](../static/img/traceback_1st_example.png) Now we can see that the last function called was `func4(x + 4)`. To see what happened inside this function, click the "Rerun with Debug" button, just below "Hide Traceback", or with the commands

``` r
debugonce(func4)
func1(7)
```

    ## debugging in: func4(x + 4)
    ## debug at <text>#4: {
    ##     y = "a"
    ##     x <- x + y
    ##     return(x)
    ## }
    ## debug at <text>#5: y = "a"
    ## debug at <text>#6: x <- x + y

    ## Error in x + y: non-numeric argument to binary operator

Notice that the drop down menu in the environment pane now indicates we are in the function environment. We can now view any objects that currently exist here the same we normally would. You can run code in the console to test things. Note if you modify an object here, it could affect the function if you continue to run it. You have several options to continue executing the function, accessible by the buttons above the console, or their corresponding keyboard shortcuts `n`, `s`, `f`, `c` and `Q`:

![](../static/img/debug_buttonsOnly.png)

They will respectively execute the next line of code, step into a function call (going a level deeper), execute the remainder of the function or loop, continue executing everything until a breakpoint is encountered, or exit debugging. You can see these descriptions by hovering over the buttons.

Now you can see what the `x` and `y` objects contain, and see what caused the error.

### Challenge

Use `debugonce` or `debug` and the associated commands to follow the function call we just made all the way from `func1()` to `func4()`.

Debugging an unfamiliar function
--------------------------------

For a more complex example, let's look use a function from the `dataRetrieval` package as an example, by supplying an invalid site number that will cause an error.

``` r
#install.packages('dataRetrieval') #if you don't already have it installed
library(dataRetrieval)
notASite <- "notASiteNumber"
readNWISsite(siteNumbers = notASite)
```

![](../static/img/error.png)

We can see that this command failed inside the function `getWebServiceData`. We didn't call this function directly, so we don't know where it is. However, we can click on the `Show Traceback` button to show the sequence of function calls that led to `getWebServiceData`.

![](../static/img/error_traceback.png)

The traceback printout reads from bottom to top, and is numbered by the order of the function calls. We can see that our `readNWISsite` call in turn called `importRDB1`, which then called `getWebServiceData`. Traceback gives the lines where these calls happen. Note that these numbers correspond to the line number of the *function*, not the line number of the file, which may be different.

Now we know where the actual error happened, but what if we want to see what led up to it? Click on the text `getWebServiceData.R#36` in the traceback output to open up the file that contains `getWebServiceData`. We can set a *breakpoint* in `getWebServiceData` by clicking to the left of the line number where we want it.

![](../static/img/breakpoint.png)

Breakpoints pause the function before the line executes, allowing you to inspect environment variables, experiment with other code, etc. Make the same `readNWISsites` call to see it work.

``` r
readNWISsites(siteNumbers = notASite)
```

![](../static/img/breakpoint_environment.png)

Now we can use the same debug buttons or key commands shown above to execute specific lines or blocks of code, or continue. ![](../static/img/debugButtons.png)

Click the red breakpoint dot to make it go away.

Note that when you are working on a package from source \[better wording here?\], you will often need to rebuild it to make breakpoints take effect. A somewhat more explicit (and non-RStudio-dependent) way to accomplish the same thing is to insert a `browser()` call inside your function. However, it is important to remember to delete `browser()` statements when you are done with them, so they don't find their way onto your repository!

What if we have a logical error (i.e. the code runs, but doesn't produce the correct result), and therefore don't have a particular line to key in on from `traceback()`? We can use the `debug()` or `debugonce()` functions. These functions insert a `browser` call behind the scenes at the start of a function. Then you can step through the entire function by individual blocks or lines, using the debugging buttons on the console or the corresponding key commands as shown above. Logic errors can be harder to pin down, since there isn't an obvious starting point. To be most thorough, you could start by running `debug()` on the function you call directly, and follow it through step-by-step. Or if you have a suspicion of what function is causing the problem, run `debug()` on it and then execute, so you can jump straight to where you want.

When you find the cause of a logic error, it is a good idea to implement a test that will catch it if turns up again in the future.

Note that if you use `debug` instead of `debugonce`, you will need to use `undebug` when you are done to turn of debugging mode. If you click the "Rerun with Debug" button on the error window it will use `debugonce` on the function where there error occured. However, this frequently occurs deep in a base R function, not your code where the actual bug is, and can therefore be less useful than `traceback` or using `debug` yourself.

More Examples and Details
-------------------------

-   [Debugging with RStudio](https://support.rstudio.com/hc/en-us/articles/205612627-Debugging-with-RStudio)

-   [Hadley Wickham on debugging](http://adv-r.had.co.nz/Exceptions-Debugging.html)
