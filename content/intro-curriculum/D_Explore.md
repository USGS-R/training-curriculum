---
author: Jeffrey W. Hollister & Emily Read
date: 2016-07-07
slug: Explore
draft: TRUE
title: D. Explore
menu:
  weight=1
image: img/main/intro-icons-300px/explore.png
---
Our next three lessons (Explore, Analyze, and Visualize) don't actually split neatly into groups. That being said, I will try my best, but there will be overlap. For this lesson we are going to focus on some of the first things you do when you start to explore a dataset including basic summary statistics and simple visualizations with base R.

Remember to load the NWIS dataset we have been use. If it's no longer loaded, load in the cleaned up version by downloading it from [here](/intro-curriculum/data), and using `read.csv` (remember that we named it `intro_df`, and don't forget `stringsAsFactors=FALSE`, and `colClasses`).

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

There are a number of ways to get at the basic summaries of a data frame in R. The easiest is to use `summary()` which for data frames will return a summary of each column. For numeric columns it gives quantiles, median, etc. and for factor a frequency of the terms. This was briefly introduced in the "Get" lesson, but let's use it again.

``` r
summary(intro_df)
```

    ##    site_no            dateTime           Flow_Inst       
    ##  Length:3000        Length:3000        Min.   :-90800.0  
    ##  Class :character   Class :character   1st Qu.:     5.1  
    ##  Mode  :character   Mode  :character   Median :    12.0  
    ##                                        Mean   :   488.2  
    ##                                        3rd Qu.:    25.0  
    ##                                        Max.   : 92100.0  
    ##                                        NA's   :90        
    ##  Flow_Inst_cd         Wtemp_Inst      pH_Inst         DO_Inst      
    ##  Length:3000        Min.   :11.9   Min.   :6.200   Min.   : 3.200  
    ##  Class :character   1st Qu.:18.2   1st Qu.:7.000   1st Qu.: 6.800  
    ##  Mode  :character   Median :21.2   Median :7.200   Median : 7.700  
    ##                     Mean   :20.7   Mean   :7.159   Mean   : 7.692  
    ##                     3rd Qu.:23.2   3rd Qu.:7.300   3rd Qu.: 8.600  
    ##                     Max.   :28.0   Max.   :9.100   Max.   :12.600  
    ##                     NA's   :90     NA's   :120     NA's   :90

If you want to look at the range, use `range()`, but it is looking for a numeric vector as input. Also, don't forget to tell it to ignore NAs!

``` r
range(intro_df$Flow_Inst, na.rm=TRUE)
```

    ## [1] -90800  92100

The interquartile range can be easily grabbed with `IQR()`, again a numeric vector is the input.

``` r
IQR(intro_df$Wtemp_Inst, na.rm=TRUE)
```

    ## [1] 5

Lastly, quantiles, at specific points, can be returned with, well, `quantile()`.

``` r
quantile(intro_df$pH_Inst, na.rm=TRUE)
```

    ##   0%  25%  50%  75% 100% 
    ##  6.2  7.0  7.2  7.3  9.1

I use quantile quite a bit, as it provides a bit more flexibility because you can specify the probabilities you want to return.

``` r
quantile(intro_df$pH_Inst, probs=c(0.025, 0.975), na.rm=TRUE)
```

    ##  2.5% 97.5% 
    ##   6.6   7.7

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

The workhorse function for plotting data in R is `plot()`. With this one command you can create almost any plot you can conceive of, but for this workshop we are just going to look at the very basics of the function. The most common way to use `plot()` is for scatterplots.

``` r
plot(intro_df$Wtemp_Inst, intro_df$DO_Inst)
```

<img src='/intro-curriculum/static/Explore/plot_examp-1.png'/>

Hey, a plot! Not bad. Let's customize a bit because those axis labels aren't terribly useful and we need a title. For that we can use the `main`, `xlab`, and `ylab` arguments.

``` r
plot(intro_df$Wtemp_Inst, intro_df$DO_Inst,
     main="Changes in D.O. concentration as function of water temperature",
     xlab="Water temperature, deg C", ylab="Dissolved oxygen concentration, mg/L")
```

<img src='/intro-curriculum/static/Explore/plot_examp_2-1.png'/>

Not sure if this will apply to everyone, but I use scatterplots ALL the time. So, for me I could almost (not really) stop here. But lets move on. Let's say we want to look at more than just one relationship at a time with a pairs plot. Again, `plot()` is our friend. If you pass a data frame to `plot()` instead of an x and y vector it will plot all possible pairs. Be careful though, as too many columns will produce an unintelligble plot.

``` r
#get a data frame with only the measured values
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
intro_df_data <- select(intro_df, -site_no, -dateTime, -Flow_Inst_cd)
plot(intro_df_data)
```

<img src='/intro-curriculum/static/Explore/pairs_examp-1.png'/>

Let's look at boxplots, histograms, and cumulative distribution functions.

Two great ways to use boxplots are straight up and then by groups in a factor. For this we will use `boxplot()` and in this case it is looking for a vector as input.

``` r
boxplot(intro_df$DO_Inst, main="Boxplot of D.O. Concentration", ylab="Concentration")
```

<img src='/intro-curriculum/static/Explore/boxplot_examp-1.png'/>

As plots go, well, um, not great. Let's try it with a bit more info and create a boxplot for each of the groups. Note the use of an R formula. In R, a formula takes the form of `y ~ x`. The tilde is used in place of the equals sign, the dependent variable is on the left, and the independent variable\[s\] are on the right. In boxplots, `y` is the numeric data variable, and `x` is the grouping variable (usually a factor).

``` r
boxplot(intro_df$DO_Inst ~ intro_df$site_no, 
        main="Boxplot of D.O. Concentration by Site", ylab="Concentration")
```

<img src='/intro-curriculum/static/Explore/boxplot_grps_examp-1.png'/>

Lastly, let's look at two other ways to plot our distributions. First, histograms.

``` r
hist(intro_df$pH_Inst)
```

<img src='/intro-curriculum/static/Explore/base_hist_examp-1.png'/>

``` r
hist(intro_df$pH_Inst, breaks=4)
```

<img src='/intro-curriculum/static/Explore/base_hist_examp-2.png'/>

And finally, cumulative distribution functions. Since CDF's are actually a function of the distribution we need to get that function first. This requires that we combine `plot()` and `ecdf()`, the emprical CDF function.

``` r
wtemp_ecdf <- ecdf(intro_df$Wtemp_Inst)
plot(wtemp_ecdf)
```

<img src='/intro-curriculum/static/Explore/cdf_examp-1.png'/>

Exercise 2
----------

Similar to before let's first just play around with some basic exploratory data visualization using the `TNLoads` dataset from `smwrData` for the first two steps.

1.  Make a scatter plot relating total nitrogen to drainage area.

2.  Create an impervious surface area histogram using the non-logged values. Explore different values for the argument `breaks`.

Now, use the dataset `MiningIron` from `smwrData` for step 3.

1.  Create a boxplot that compares iron concentrations based on stream rock types. If it is interpret the boxplot, try logging the iron concentrations.
