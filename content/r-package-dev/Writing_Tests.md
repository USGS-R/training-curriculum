---
author: Jordan I. Walker
date: 9999-08-31
slug: writing-tests
title: Writing Tests
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 35
---
Formal software testing lays down a safety net to ensure that software performs the function it claims to. Not only will testing your packages improve the confidence level you have in your code, but it will make adding new functionality easier, improve the structure of your code, and save time that would otherwise be used to manually test. This lesson will go over general principles of testing and how to accomplish them in R using testthat.

Lesson Objectives
-----------------

1.  Recognize the purpose and value of writing tests.
2.  Understand different types of testing and when to apply them.
3.  Describe good test writing practices.
4.  Identify appropriate testing frequency.

Why should I test my code?
--------------------------

You've learned the language and some techniques for writing good code in R, so there is a good chance that your code will perform the task it sets out to do correctly and efficiently. It is natural to be confident that code will just work, but it is critical to follow a strategy of "trust, but verify". Trust that the code you are writing will do what you intend, then verify that that is truly the case by writing a test for that piece of functionality. Adding functionality to a package should be accompanied by code that exercises said functionality and asserts its validity.

In developing a package, you will be adding code to perform certain functions. In order to verify that this code does what it claims to, write a test that runs the function with different inputs and verify the output (or side effects). Test edge cases and error conditions to make sure they are handled appropriately. Tests are also meant to signal to future developers what the requirements of particular functionality are and to warn when those are not being met. Creating tests covering expected behavior and edge cases as part of a testing framework in your package ensures the following:

**Document expected behavior:** Tests should clearly indicate what, given certain inputs, is expected to result from a given function. This lays out the requirements for a piece of code and shows that it performs as specified.

**Prevent regressions:** Everything is working right now, but in a month or so a new feature might be requested. When adding this functionality there is a chance that interactions with other code might break an existing piece of functionality. Having good tests in place will catch this quickly.

Along with these benefits, testing can help guide a better code structure. In order to make code more testable it will need to be written as smaller chunks with clear delineation of the features. This will make future development and maintenance easier. As we will learn shortly, tests can be used as a starting point to drive the development process, added to improve confidence in the code base, or added to an existing code base without tests in order to characterize its behavior.

What types of tests should I write?
-----------------------------------

There are many terms to tackle when discussing software testing. It is useful to look at several types of tests, as well as different approaches to writing tests. To build a package with confidence that the features are implemented correctly and will stay that way, combine these techniques where they apply and run them often.

**Test-driven development (TDD):** The technique of using testing integrated in the development process where it influences the design to be more testable. Tests should be part of a feedback loop that is run often when changes are made to the code and alerts the developer to issues before they make it into the wild.

**Test first development:** One test-driven approach where tests are written first, and the feature in question is only complete when the tests are passing. This is particularly useful when the interface can be determined beforehand and the implementation only needs to perform the task defined by that interface.

**Behavior driven development (BDD):** Functionality is declared in clear language, specifying the requirements of the functionality. Tests are then written, tied to this language, to verify that this behavior is met.

**Unit testing:** Testing the individual units of functionality isolated from the system to ensure that those units perform the required functionality correctly. This level of testing forms the safety net that ensures new code can be added with little risk of effecting other parts of the system, or old code can be modified while maintaining its intended function.

**Integration testing:** Testing several units in combination to make sure they integrate properly. This involves testing higher level functionality that touches several components and ensuring that it is correct. This testing often takes more setup and time to run, but is valuable to ensure proper testing of the system as a whole.

**Characterization testing:** Testing the behavior of code as it exists to ensure that it continues to behave in that way. This technique is often used on older code where the expected functionality is not fully clear. Write tests that exercise the functions as they exist and use the result as the expectation. Changes can then be made to the code without changing the behavior, and new tests can be written to better explain the functions.

**Data testing:** Data is often treated differently than code, but it can be tested in quite similar ways. Assumptions about data types, valid ranges, and other aspects of the data should be explicitly tested for to ensure validity.

Applying these techniques where applicable will develop a solid suite of tests that will instill confidence in those developing on or against your package. It is helpful to gather code coverage metrics to quantify the level of testing that exists. Code coverage measures percentage of code in a package that are hit in some way by the tests. The R package `covr` is available to generate these metrics and push them to a location to share the results. The resulting badge can be placed in your README.md file to show users of your package the level of effort placed in testing they can expect.

![Coveralls badge](../static/img/coveralls.png#inline-img "100% coverage")

How do I write tests?
---------------------

We are going to add a test to the pH function from the [documentation section](../doc). As a reminder this function was defined as:

``` r
is.valid.pH <- function(pH){
  pH >= 0 & pH <= 14
}
```

The `testthat` package provides the functions we are going to use for testing. A `testhat.R` script should be placed in the `tests` directory off your package root. Running `devtools::use_testthat()` will automate some of this setup. This file is used to run `testthat` tests and should take this form (with myPackage replaced by your package name):

``` r
library(testhat)
library(myPackage)

test_check("myPackage")
```

Files performing the testing should be placed in the `tests/testthat` directory and test file names must begin with `test`. If there is shared code that is needed across test files, this code should be placed in files named `helper-*.R`. The initial case here doesn't require any helpers, so the first test would look like:

``` r
library(testthat)
context("Valid pH values")
test_that("pH values inside valid range return true", {
  expect_true(is.valid.pH(7))
})
```

The `test_that()` is provided the test name in BDD form. The second argument to this function is the code block containing the code to exercise the functionality and expectations of the results. The `expect_*()` calls are used to declare these expectations, and will fail when the expectation is not met. You'll also note that `context()` is called before running the test case, this groups a number of test cases together into logical chunks to add a bit more information to the test reporting.

We also want to make sure that non-valid pH values are correctly identified.

``` r
test_that("pH values outside valid range return false", {
  expect_false(is.valid.pH(-3))
  expect_false(is.valid.pH(15))
})
```

We are able to make several assertions in one test, but this should not be overused as we want the assertions to match the BDD description as much as possible. Lastly, we are going to add edge cases to this test to verify that they are correct

``` r
test_that("pH edge cases return true", {
  expect_true(is.valid.pH(0))
  expect_true(is.valid.pH(14))
})
```

Through a bit of magic we can look at the results of these tests. Normally this will happen by running "Build &gt; Test Package" through RStudio (Ctrl+Shift+T shortcut).

One final set of tools in the testing toolbox are mocks. Mocks are used to isolate code so it isn't effected by other pieces that it depends on. As an example, really long running code is not good to have in tests since it is best to run tests often. So we will create a function that calls another function that takes a long time to return, but then mock that function in order to isolate the behavior.

``` r
  really_long_running_function <- function() {
    Sys.sleep(60) # calculating the answer to life, the universe, and everything
    return(42)
  }
  unit_to_test <- function() {
    answer <- really_long_running_function()
    return(answer/6)
  }
  test_that("answer is seven", {
    print(system.time({
      with_mock(
        really_long_running_function = function() 42,
        expect_equal(unit_to_test(), 7)
      )
    }))
  })
```

    ##    user  system elapsed 
    ##       0       0       0

For more information:

-   [Hadley Wickham on testing](http://r-pkgs.had.co.nz/tests.html)
-   [covr](https://cran.r-project.org/web/packages/covr/index.html)
