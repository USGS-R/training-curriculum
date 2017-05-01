---
author: Jordan I. Walker
date: 9999-08-31
slug: writing-tests
title: Writing Tests
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
Formal software testing lays down a safety net to ensure that software performs the function it claims to. Not only will testing your packages improve the confidence level you have in your code, but it will make adding new functionality easier, improve the structure of your code, and save time that would otherwise be used to manually test. This lesson will go over general principles of testing and how to accomplish them in R using testthat.

Lesson Objectives
-----------------

1.  Recognize the purpose and value of writing tests
2.  Understand different types of testing and when to apply them
3.  Learn some test writing practices and how often to run them

Why should I test my code?
--------------------------

Formal testing of code is like showing your work on a hard math problem. You may come to the correct solution, but unless you show exactly how you got to that solution you may not get full credit. The same is true in software. Adding functionality to a package should be accompanied by code that exercises said functionality and asserts its validity. Tests are also meant to signal to future developers what the requirements of particular functionality are and to warn when those are not being met.

In developing a package, you will be adding code to perform certain functions. In order to prove that this code does what it claims to, write a test that runs the function with different inputs and verify the output (or side effects). Test edge cases and error conditions to make sure they are handled appropriately. Creating tests covering expected behavior and edge cases as part of a testing framework in your package ensures the following:

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

Applying these techniques where applicable will develop a solid suite of tests that will instill confidence in those developing on or against your package. It is helpful to gather code coverage metrics to quantify the level of testing that exists. The R package `covr` is available to generate these metrics and push them to a location to share the results.

How do I write tests?
---------------------

We are going to build on what was covered in the documentation section by writing some tests. Here is a reminder of the pH validity function we created earlier.

``` r
is.valid.pH <- function(pH){
  pH >= 0 & pH <= 14
}
```

The `testthat` package provides the functions we are going to use for testing. Files performing the testing should be placed in the `tests/testthat` directory and a `testhat.R` script should invoke `test_check()` on your package.

``` r
library(testthat)
test_that("pH values inside range return true", {
  expect_true(is.valid.pH(7))
})
```

The `test_that()` is provided the test name in BDD form. The second argment to this function is the code block containing the code to exercise the functionality and expectations of the results. The `expect_*()` calls are used to declare these expectations, and will fail when the expectation is not met.

For more information:

-   [Hadley Wickham on testing](http://r-pkgs.had.co.nz/tests.html)
-   [covr](https://cran.r-project.org/web/packages/covr/index.html)
