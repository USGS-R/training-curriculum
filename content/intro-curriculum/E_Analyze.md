---
author: Jeffrey W. Hollister & Emily Read
date: 2016-07-06
slug: Analyze
draft: True
title: E. Analyze
menu:
---
The focus of this workshop hasn't really been statistics, it's been more about R, the language. But it's pretty much impossible to talk a lot about R without getting into stats, as that is what draws most people to R in the first place. So we will spend a little bit of time on it. In this lesson we will touch on some very simple stats that we can do with base R.

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Compute basic statistics and build a simple model with USGS data

Lesson Goals
------------

-   Conduct basic statistical analyses with base R
-   Get a taste of a wide array of analyses in base R

Base statistics
---------------

The capabilities that come out of the box with R are actually quite good and used to (i.e. before R) cost you quite a bit to access. Now it all comes for free! Some things you can do in R without any additional packages include: logistic regression (and all manner of generalized linear models), correlation, principle components analysis, chi-squared tests, clustering, loess, ANOVA, MANOVA, ... In short, we can do a lot without moving out of base r and the `stats` package.

We will talk about a few analyses just to show the tip of the iceberg of what is available.

### t-tests

A t-test is done simply with `t.test()` and you control the specifics (paired, two-sided, etc.) with options. For the simple case of comparing the difference of two means we can use all of the defaults:

``` r
pop1 <- rnorm(30, mean=3, sd=2)
pop2 <- rnorm(30, mean=10, sd=5)
pop_ttest <- t.test(pop1, pop2)
pop_ttest
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  pop1 and pop2
    ## t = -7.5834, df = 37.108, p-value = 4.714e-09
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -9.847124 -5.694896
    ## sample estimates:
    ## mean of x mean of y 
    ##  3.022597 10.793608

`t.test()` can also take a formula specification as input. In R, a formula takes the form of `y ~ x`. The tilde is used in place of the equals sign, the dependent variable is on the left, and the independent variable\[s\] are on the right. For a t-test that is all we need to know.

``` r
#Load the data package!
library(smwrData)

#Let's choose a prefabricated dataset, MiningIron 
data("MiningIron")
rbind(head(MiningIron), tail(MiningIron))
```

    ##      Iron      Rock MineType C5
    ## 1    0.05 Sandstone  Unmined C5
    ## 2    0.39 Sandstone  Unmined C5
    ## 3    0.49 Sandstone  Unmined C5
    ## 4    0.60 Sandstone  Unmined C5
    ## 5    0.66 Sandstone  Unmined C5
    ## 6    0.71 Sandstone  Unmined C5
    ## 236  0.56 Limestone  Unmined   
    ## 237  0.68 Limestone  Unmined   
    ## 238  1.20 Limestone  Unmined C5
    ## 239  1.20 Limestone  Unmined   
    ## 240  4.50 Limestone  Unmined   
    ## 241 36.00 Limestone  Unmined C5

``` r
#Compare iron concentration between rock types
#There are two rock types, these serve as your two different populations 
#You cannot use this to compare more than two groups 
#Try using MineType instead of Rock and see what R tells you
t.test(MiningIron$Iron ~ MiningIron$Rock)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  MiningIron$Iron by MiningIron$Rock
    ## t = -2.2031, df = 120.76, p-value = 0.02948
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -200.59315  -10.70878
    ## sample estimates:
    ## mean in group Limestone mean in group Sandstone 
    ##                5.603583              111.254545

There's a lot more you can do with `t.test()`, but you'll have to rely on `?t.test` for more info.

### Correlation

Next let's take a look at correlations.

``` r
#Use the UraniumTDS data set from smwrData
data("UraniumTDS")

#A simple correlation
cor(UraniumTDS$TDS, UraniumTDS$Uranium)
```

    ## [1] 0.216127

``` r
#And a test of that correlation
cor.test(UraniumTDS$TDS, UraniumTDS$Uranium)
```

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  UraniumTDS$TDS and UraniumTDS$Uranium
    ## t = 1.4346, df = 42, p-value = 0.1588
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.08629011  0.48207551
    ## sample estimates:
    ##      cor 
    ## 0.216127

``` r
#A data frame as input to cor returns a correlation matrix
#Can't just do cor(UraniumTDS) because UraniumTDS has non-numeric columns:
# cor(UraniumTDS)
library(dplyr) # use dplyr to select the numeric columns of UraniumTDS
select(UraniumTDS, -HCO3) %>% 
  cor()
```

    ##              TDS  Uranium
    ## TDS     1.000000 0.216127
    ## Uranium 0.216127 1.000000

``` r
#This is especially useful for data frames with many columns that could correlate
#Create a correlation matrix for MiscGW (all columns are numeric)
data("MiscGW")
cor(MiscGW)
```

    ##                Calcium  Magnesium     Sodium   Potassium Carbonate
    ## Calcium      1.0000000 -0.6816989 -0.7861816 -0.15151515        NA
    ## Magnesium   -0.6816989  1.0000000  0.6628186  0.26995276        NA
    ## Sodium      -0.7861816  0.6628186  1.0000000 -0.41191071        NA
    ## Potassium   -0.1515152  0.2699528 -0.4119107  1.00000000        NA
    ## Carbonate           NA         NA         NA          NA         1
    ## Bicarbonate -0.9540554  0.7936118  0.9185587 -0.02902499        NA
    ## Sulfate     -0.8688535  0.5846284  0.9748508 -0.34681754        NA
    ## Chloride     0.3194320  0.3525794  0.2036404 -0.38904457        NA
    ## Fluoride    -0.9264085  0.8303799  0.6208948  0.45291081        NA
    ## Nitrate             NA         NA         NA          NA        NA
    ##             Bicarbonate     Sulfate    Chloride   Fluoride Nitrate
    ## Calcium     -0.95405535 -0.86885349  0.31943198 -0.9264085      NA
    ## Magnesium    0.79361181  0.58462845  0.35257942  0.8303799      NA
    ## Sodium       0.91855874  0.97485080  0.20364045  0.6208948      NA
    ## Potassium   -0.02902499 -0.34681754 -0.38904457  0.4529108      NA
    ## Carbonate            NA          NA          NA         NA      NA
    ## Bicarbonate  1.00000000  0.93915368 -0.02993281  0.8779472      NA
    ## Sulfate      0.93915368  1.00000000 -0.01903635  0.6730911      NA
    ## Chloride    -0.02993281 -0.01903635  1.00000000 -0.2244484      NA
    ## Fluoride     0.87794724  0.67309110 -0.22444842  1.0000000      NA
    ## Nitrate              NA          NA          NA         NA       1

If you look at the help for `cor()`, you'll see two main optional arguments. First is the `use` argument which allows you to use the entire dataset or select complete cases which is useful when you have `NA` values. There are several options. Also, the default correlation method is for Pearson's. If you would like to use non-parametric correlations (e.g. rank), you specify that here.

### Linear Regression

Next let's take a look at linear regression. One of the common ways of fitting linear regressions is with `lm()`. We have already seen the formula object so there isn't too much that is new here. Some of the options are new and useful, though. Let's take a look:

``` r
data("MenomineeMajorIons") #from smwrData

lm(Magnesium ~ HCO3, data=MenomineeMajorIons)
```

    ## 
    ## Call:
    ## lm(formula = Magnesium ~ HCO3, data = MenomineeMajorIons)
    ## 
    ## Coefficients:
    ## (Intercept)         HCO3  
    ##     2.51540      0.07566

``` r
#Not much info, so save to object and use summary
lm_gwq1 <- lm(Magnesium ~ HCO3, data=MenomineeMajorIons)
summary(lm_gwq1)
```

    ## 
    ## Call:
    ## lm(formula = Magnesium ~ HCO3, data = MenomineeMajorIons)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.5623 -0.5358 -0.2061  0.8753  1.7076 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 2.515404   1.042353   2.413   0.0212 *  
    ## HCO3        0.075664   0.008726   8.671 3.08e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.8979 on 35 degrees of freedom
    ## Multiple R-squared:  0.6823, Adjusted R-squared:  0.6733 
    ## F-statistic: 75.18 on 1 and 35 DF,  p-value: 3.083e-10

``` r
#And now a multiple linear regression
lm_gwq2 <- lm(Magnesium ~ HCO3 + Calcium + Sodium, data=MenomineeMajorIons)
summary(lm_gwq2)
```

    ## 
    ## Call:
    ## lm(formula = Magnesium ~ HCO3 + Calcium + Sodium, data = MenomineeMajorIons)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -1.81218 -0.26416 -0.06806  0.46821  1.47692 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  3.18904    0.98110   3.250 0.002654 ** 
    ## HCO3         0.04062    0.01089   3.728 0.000722 ***
    ## Calcium      0.08051    0.04816   1.671 0.104082    
    ## Sodium       0.21035    0.06843   3.074 0.004218 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.7276 on 33 degrees of freedom
    ## Multiple R-squared:  0.8033, Adjusted R-squared:  0.7855 
    ## F-statistic: 44.93 on 3 and 33 DF,  p-value: 9.394e-12

All of your standard modelling approaches (and then some) are available in R, including typical variable selection techniques (e.g. stepwise with AIC) and logistic regression, which is implemented with the rest of the generalized linear models in `glm()`. Interaction terms can be specified directly in the model, but there are several ways to do so (`x*y`, `x:y`, `x^y`). Lastly, if you are interested in more involved or newer approaches these are likely implemented in additional packages, beyond base R and `stats`, which you can find on a repository such as [CRAN](https://cran.rstudio.com), [GRAN](http://owi.usgs.gov/R/gran.html), or [Bioconductor](https://www.bioconductor.org/packages/release/BiocViews.html#___Software).

Exercise 1
----------

For this exercise, let's start to look at some of the statistical tests and relationships.

1.  First, let's take a look at the relationship between ammonia and organic nitrogen concentration across land-use types (`PrecipNitrogen` dataset from `smwrData`). Add a section to your script that tests for a difference in the mean value across these parameters between industrial sites and residential sites. What is the conclusion? Are the means statistically different?

2.  Challenge: Recreate step 1, but use a formula rather than two vectors as input to `t.test`. You should get the same results.

3.  Next, let's build a linear model that predicts phosphorus concentrations at a USGS site on Klamath River (`KlamathTP` dataset from `smwrData`). Use flow as the explanatory variable. Add a line to extract the r-squared value from the linear model.

4.  Challenge: Create a multivariate linear model relating total nitrogen to two or three explanatory variables in the `TNLoads` dataset from `smwrData`. Extract the adjusted r-squared value. If there's time, try to figure out which variables maximize the r-squared.
