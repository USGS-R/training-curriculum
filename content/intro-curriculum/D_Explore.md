---
author: Jeffrey W. Hollister & Emily Read
date: 2016-07-07
slug: Explore
draft: True
title: D. Explore
menu:
image: img/main/intro-icons-300px/explore.png
---
Our next three lessons (Explore, Analyze, and Visualize) don't actually split neatly into groups. That being said, I will try my best, but there will be overlap. For this lesson we are going to focus on some of the first things you do when you start to explore a dataset including basic summary statistics and simple visualizations with base R.

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Exploring data with basic summary statistics
-   [Exercise 2](#exercise-2): Using base R graphics for exploratory data analysis

Lesson Goals
------------

-   Be able to calculate a variety of summary statistics
-   Continue building familiarity with `dplyr` and base R for summarizing groups
-   Create a variety of simple exploratory plots

Summary Statistics
------------------

There are a number of ways to get at the basic summaries of a data frame in R. The easiest is to use `summary()` which for data frames will return a summary of each column. For numeric columns it gives quantiles, median, etc. and for factor a frequency of the terms. Let's use a data frame of major ion concentrations in the Menominee River, `MenomineeMajorIons` from the `smwrData` package.

``` r
#Load the data package!
library(smwrData)

#load the dataset and take a quick look
data("MenomineeMajorIons")
summary(MenomineeMajorIons)
```

    ##   agency.cd           site.no            sample.dt         
    ##  Length:37          Length:37          Min.   :1985-11-14  
    ##  Class :character   Class :character   1st Qu.:1993-05-20  
    ##  Mode  :character   Mode  :character   Median :1993-12-21  
    ##                                        Mean   :1992-12-23  
    ##                                        3rd Qu.:1994-09-20  
    ##                                        Max.   :1995-07-12  
    ##                                                            
    ##   medium.cd           CO3.rmk               CO3         
    ##  Length:37          Length:37          Min.   :0.00000  
    ##  Class :character   Class :character   1st Qu.:0.00000  
    ##  Mode  :character   Mode  :character   Median :0.00000  
    ##                                        Mean   :0.05405  
    ##                                        3rd Qu.:0.00000  
    ##                                        Max.   :2.00000  
    ##                                                         
    ##    HCO3.rmk              HCO3       Nitrate.rmk           Nitrate      
    ##  Length:37          Min.   : 80.0   Length:37          Min.   :0.0500  
    ##  Class :character   1st Qu.:106.0   Class :character   1st Qu.:0.0610  
    ##  Mode  :character   Median :118.0   Mode  :character   Median :0.1000  
    ##                     Mean   :118.2                      Mean   :0.1664  
    ##                     3rd Qu.:127.0                      3rd Qu.:0.1700  
    ##                     Max.   :151.0                      Max.   :2.0000  
    ##                                                                        
    ##  Calcium.rmk           Calcium      Magnesium.rmk        Magnesium    
    ##  Length:37          Min.   :18.00   Length:37          Min.   : 8.30  
    ##  Class :character   1st Qu.:23.00   Class :character   1st Qu.:10.00  
    ##  Mode  :character   Median :26.00   Mode  :character   Median :12.00  
    ##                     Mean   :25.68                      Mean   :11.46  
    ##                     3rd Qu.:28.00                      3rd Qu.:13.00  
    ##                     Max.   :41.00                      Max.   :14.00  
    ##                                                                       
    ##   Sodium.rmk            Sodium      Potassium.rmk        Potassium    
    ##  Length:37          Min.   : 2.20   Length:37          Min.   :0.800  
    ##  Class :character   1st Qu.: 4.20   Class :character   1st Qu.:1.100  
    ##  Mode  :character   Median : 6.40   Mode  :character   Median :1.300  
    ##                     Mean   : 6.67                      Mean   :1.314  
    ##                     3rd Qu.: 8.20                      3rd Qu.:1.500  
    ##                     Max.   :12.00                      Max.   :1.800  
    ##                                                                       
    ##  Chloride.rmk          Chloride      Sulfate.rmk           Sulfate      
    ##  Length:37          Min.   : 3.400   Length:37          Min.   : 6.100  
    ##  Class :character   1st Qu.: 4.975   Class :character   1st Qu.: 9.925  
    ##  Mode  :character   Median : 5.950   Mode  :character   Median :13.000  
    ##                     Mean   : 6.169                      Mean   :13.189  
    ##                     3rd Qu.: 7.450                      3rd Qu.:16.000  
    ##                     Max.   :11.000                      Max.   :21.000  
    ##                     NA's   :1                           NA's   :1       
    ##  Fluoride.rmk          Fluoride         season  
    ##  Length:37          Min.   :0.1000   summer:24  
    ##  Class :character   1st Qu.:0.1000   winter:13  
    ##  Mode  :character   Median :0.1000              
    ##                     Mean   :0.1027              
    ##                     3rd Qu.:0.1000              
    ##                     Max.   :0.2000              
    ## 

If you want to look at the range, use `range()`, but it is looking for a numeric vector as input.

``` r
range(MenomineeMajorIons$HCO3)
```

    ## [1]  80 151

The interquartile range can be easily grabbed with `IQR()`, again a numeric vector is the input.

``` r
IQR(MenomineeMajorIons$Potassium)
```

    ## [1] 0.4

Lastly, quantiles, at specific points, can be returned with, well, `quantile()`.

``` r
quantile(MenomineeMajorIons$Magnesium)
```

    ##   0%  25%  50%  75% 100% 
    ##  8.3 10.0 12.0 13.0 14.0

``` r
#try this with Sulfate instead 
#quantile(MenomineeMajorIons$Sulfate)
#there are missing values, so add the na.rm argument
quantile(MenomineeMajorIons$Sulfate, na.rm = TRUE)
```

    ##     0%    25%    50%    75%   100% 
    ##  6.100  9.925 13.000 16.000 21.000

I use quantile quite a bit, as it provides a bit more flexibility because you can specify the probabilities you want to return.

``` r
quantile(MenomineeMajorIons$Magnesium, probs=(c(0.025, 0.975)))
```

    ##  2.5% 97.5% 
    ##  8.39 13.10

Exercise 1
----------

Next, we're going to explore the distribution of the MenomineeMajorIons data from `smwrData` using base R statistical functions. We want a data frame that has mean, median, and IQR for four of the major ions in this data set. We will use `dplyr` to help make this easier.

1.  Create a new data.frame that has only these variables: HCO3, Calcium, Magnesium, and Chloride. Think `select()`. Don't forget to remove an missing values (`na.omit`)!

2.  Now, summarize each variable by the summary statistics mean, median, and interquartile range. In the end, you should have a data.frame with 1 row and 12 columns.

3.  Challenge: Add a calculation for the 90th percentile into your code for step 2. Hint: this requires an additional argument to the `quantile` function.

4.  Challenge: It is difficult to read a data.frame that has 12 columns (or 16 if you completed step 3) and only one row. Make the data.frame more readable by transposing it.

Basic Visualization
-------------------

Exploratory data analysis tends to be a little bit about stats and a lot about visualization. Later we are going to go into more detail on advanced plotting with both base R and `ggplot2`, but for now we will look at some of the simple, yet very useful, plots that come with base R. I find these to be great ways to quickly explore data.

The workhorse function for plotting data in R is `plot()`. With this one command you can create almost any plot you can conceive of, but for this workshop we are just going to look at the very basics of the function. The most common way to use `plot()` is for scatterplots. Let's look at the `MenomineeMajorIons` data from `smwrData`.

``` r
data("MenomineeMajorIons")
plot(MenomineeMajorIons$Sulfate, MenomineeMajorIons$HCO3)
```

<img src='/static/Explore/plot_examp-1.png'/>

Hey, a plot! Not bad. Let's customize a bit because those axis labels aren't terribly useful and we need a title. For that we can use the `main`, `xlab`, and `ylab` arguments.

``` r
plot(MenomineeMajorIons$Sulfate, MenomineeMajorIons$HCO3,
     main="Changes in bicarbonate concentration as function of sulfate concentration",
     xlab="Sulfate Concentration", ylab="Bicarbonate concentration")
```

<img src='/static/Explore/plot_examp_2-1.png'/>

Not sure if this will apply to everyone, but I use scatterplots ALL the time. So, for me I could almost (not really) stop here. But lets move on. Let's say we want to look at more than just one relationship at a time with a pairs plot. Again, `plot()` is our friend. If you pass a data frame to `plot()` instead of an x and y vector it will plot all possible pairs. Be careful though, as too many columns will produce an unintelligble plot. Let's go back to `MenomineeMajorIons`.

``` r
#get a data frame with concentrations of 4 major ions and the season
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
menominee_pairs <- MenomineeMajorIons %>% 
  select(HCO3, Nitrate, Potassium, Sulfate, season)
plot(menominee_pairs, main="Menominee Major Ions Pairs Plot")
```

<img src='/static/Explore/pairs_examp-1.png'/>

Last thing I will show with plot is how to add a line. The one I use most often for exploratory analysis is a straight line defined by slope and intercept. We do this with `abline()`.

We can add a horizontal line and vertical line easily with this as follows:

``` r
plot(MenomineeMajorIons$Sulfate, MenomineeMajorIons$HCO3)
#horizontal line at specified y value
abline(h=140)
#a vertical line
abline(v=15)
#Line with a slope and intercept
abline(55, 6)
```

<img src='/static/Explore/abline_examp-1.png'/>

This is useful if you have a known value that you want to compare to your data. Next example is putting a regression line on the plot. We haven't talked about regression in R yet, but this example is simple enough I think we can get away with introducing it.

``` r
plot(MenomineeMajorIons$Sulfate, MenomineeMajorIons$HCO3)
#abline accepts a linear model object as input
#linear model is done with lm, and uses a formula as input
abline(lm(HCO3 ~ Sulfate, data=MenomineeMajorIons))
```

<img src='/static/Explore/abline_examp_lm-1.png'/>

So, we detoured a bit. Let's get back to a few more examples of exploratory plots. We will look at boxplots, histograms, and cumulative distribution functions then call it quits on the exploratory analyis (and the first day, whew!)

Two great ways to use boxplots are straight up and then by groups in a factor. For this we will use `boxplot()` and in this case it is looking for a vector as input. Sticking with `MenomineeMajorIons`:

``` r
boxplot(MenomineeMajorIons$Chloride, main="Boxplot of Chloride Concentration", ylab="Concentration")
```

<img src='/static/Explore/boxplot_examp-1.png'/>

As plots go, well, um, not great. Let's try it with a bit more info and create a boxplot for each of the groups. Note the use of another R formula.

``` r
boxplot(MenomineeMajorIons$Chloride ~ MenomineeMajorIons$season, 
        main="Boxplot of Chloride Concentration by Season", ylab="Concentration")
```

<img src='/static/Explore/boxplot_grps_examp-1.png'/>

Lastly, let's look at two other ways to plot our distributions. First, histograms.

``` r
hist(MenomineeMajorIons$Magnesium)
```

<img src='/static/Explore/base_hist_examp-1.png'/>

``` r
hist(MenomineeMajorIons$Magnesium, breaks=4)
```

<img src='/static/Explore/base_hist_examp-2.png'/>

And finally, cumulative distribution functions. Since CDF's are actually a function of the distribution we need to get that function first. This requires that we combine `plot()` and `ecdf()`, the emprical CDF function.

``` r
calcium_ecdf <- ecdf(MenomineeMajorIons$Calcium)
plot(calcium_ecdf)
```

<img src='/static/Explore/cdf_examp-1.png'/>

Exercise 2
----------

Similar to before let's first just play around with some basic exploratory data visualization using the `TNLoads` dataset from `smwrData` for the first two steps.

1.  Make a scatter plot relating total nitrogen to drainage area. Try adding a regression line (hint: `lm`).

2.  Create an impervious surface area histogram using the non-logged values. Explore different values for the argument `breaks`.

Now, use the dataset `MiningIron` from `smwrData` for step 3.

1.  Create a boxplot that compares iron concentrations based on stream rock types. If it is interpret the boxplot, try logging the iron concentrations.
