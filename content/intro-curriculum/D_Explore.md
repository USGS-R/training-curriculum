---
author: Jeffrey W. Hollister, Emily Read, Lindsay Carr
date: 9999-01-07
slug: Explore
title: D. Explore
image: img/main/intro-icons-300px/explore.png
menu:
  main:
    parent: Introduction to R Course
    weight: 1
---
Our next three lessons (Explore, Analyze, and Visualize) don't actually split neatly into groups. That being said, I will try my best, but there will be overlap. For this lesson we are going to focus on some of the first things you do when you start to explore a dataset including basic summary statistics and simple visualizations with base R.

Remember that we are using the NWIS dataset for all of these lessons. If you successfully completed the [Clean](/intro-curriculum/clean) lesson, then you should have the cleaned up version of the data frame. If you did not complete the Clean lesson (or are starting in a new R session), just load in the cleaned csv by downloading it from [here](/intro-curriculum/data), saving it in a folder called "data", and using `read.csv` (see below).

``` r
intro_df <- read.csv("data/course_NWISdata_cleaned.csv", stringsAsFactors = FALSE, 
                     colClasses = c("character", rep(NA, 7)))
```

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Exploring data with basic summary statistics
-   [Exercise 2](#exercise-2): Using base R graphics for exploratory data analysis
-   [Exercise 3](#exercise-3): Using `dplyr` to summarize data.

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

    ##    site_no            dateTime              Flow         
    ##  Length:1950        Length:1950        Min.   :   0.650  
    ##  Class :character   Class :character   1st Qu.:   5.125  
    ##  Mode  :character   Mode  :character   Median :  11.000  
    ##                                        Mean   : 302.636  
    ##                                        3rd Qu.:  21.000  
    ##                                        Max.   :7840.000  
    ##                                                          
    ##    Flow_cd              Wtemp             pH              DO        
    ##  Length:1950        Min.   :12.20   Min.   :6.200   Min.   : 3.300  
    ##  Class :character   1st Qu.:17.80   1st Qu.:7.000   1st Qu.: 7.000  
    ##  Mode  :character   Median :20.70   Median :7.100   Median : 7.800  
    ##                     Mean   :20.39   Mean   :7.151   Mean   : 7.806  
    ##                     3rd Qu.:22.80   3rd Qu.:7.300   3rd Qu.: 8.600  
    ##                     Max.   :27.40   Max.   :9.100   Max.   :12.800  
    ##                     NA's   :66      NA's   :63      NA's   :61      
    ##     Wtemp_F     
    ##  Min.   :53.96  
    ##  1st Qu.:64.04  
    ##  Median :69.26  
    ##  Mean   :68.70  
    ##  3rd Qu.:73.04  
    ##  Max.   :81.32  
    ##  NA's   :66

If you want to look at the range, use `range()`, but it is looking for a numeric vector as input. There shouldn't be any NAs in the flow column, but don't forget to ignore them for others!

``` r
range(intro_df$Flow)
```

    ## [1]    0.65 7840.00

The interquartile range can be easily grabbed with `IQR()`, again a numeric vector is the input.

``` r
IQR(intro_df$Wtemp, na.rm=TRUE)
```

    ## [1] 5

``` r
IQR(intro_df$Wtemp_F, na.rm=TRUE)
```

    ## [1] 9

Lastly, quantiles, at specific points, can be returned with, well, `quantile()`.

``` r
quantile(intro_df$pH, na.rm=TRUE)
```

    ##   0%  25%  50%  75% 100% 
    ##  6.2  7.0  7.1  7.3  9.1

I use quantile quite a bit, as it provides a bit more flexibility because you can specify the probabilities you want to return.

``` r
quantile(intro_df$pH, probs=c(0.025, 0.975), na.rm=TRUE)
```

    ##  2.5% 97.5% 
    ##   6.6   8.0

Exercise 1
----------

Next, we're going to explore `intro_df` using base R statistical functions. We want a data frame that has mean, median, and IQR for each of the measured values in this data set. We will use `dplyr` to help make this easier.

1.  Summarize DO and pH by the summary statistics mean, median, and interquartile range. Hint: don't forget the argument `na.rm=TRUE` for the stats functions!

2.  Add a step to calculate the 90th percentile for pH and DO. Hint: this requires an additional argument to the `quantile` function.

*To get summary statistics for each variable, use the dplyr `summarize_at` function. The arguments for this function can be pretty tricky, so try to follow the examples in the help file. See `?summarize_at`*

Basic Visualization
-------------------

Exploratory data analysis tends to be a little bit about stats and a lot about visualization. Later we are going to go into more detail on advanced plotting with both base R and `ggplot2`, but for now we will look at some of the simple, yet very useful, plots that come with base R. I find these to be great ways to quickly explore data.

The workhorse function for plotting data in R is `plot()`. With this one command you can create almost any plot you can conceive of, but for this workshop we are just going to look at the very basics of the function. The most common way to use `plot()` is for scatterplots.

``` r
plot(intro_df$Wtemp, intro_df$DO)
```

<img src='../static/Explore/plot_examp-1.png'/ title='Scatter plot of dissolved oxygen vs water temperature'/>

Hey, a plot! Not bad. Let's customize a bit because those axis labels aren't terribly useful and we need a title. For that we can use the `main`, `xlab`, and `ylab` arguments.

``` r
plot(intro_df$Wtemp, intro_df$DO,
     main="Changes in D.O. concentration as function of water temperature",
     xlab="Water temperature, deg C", ylab="Dissolved oxygen concentration, mg/L")
```

<img src='../static/Explore/plot_examp_2-1.png'/ title='Basic scatter plot with title and xy axis labels'/>

Let's say we want to look at more than just one relationship at a time with a pairs plot. Again, `plot()` is our friend. If you pass a data frame to `plot()` instead of an x and y vector it will plot all possible pairs. Be careful though, as too many columns will produce an unintelligble plot.

``` r
#get a data frame with only the measured values (ignore Wtemp_F since only units differ from Wtemp)
library(dplyr)
intro_df_data <- select(intro_df, -site_no, -dateTime, -Flow_cd, -Wtemp_F)
plot(intro_df_data)
```

<img src='../static/Explore/pairs_examp-1.png'/ title='Pairs plot using intro_df'/>

The plots look a bit strange - we'd expect to see a stronger relationship between water temperature and dissolved oxygen. Let's explore the data to figure out why. Using `head(intro_df)`, I immediately notice that the site numbers are different. That is already a good explanation for why some of these plots are not turning out as we'd expect. Let's try to do a pairs plot for a single site.

``` r
#get a data frame with only the first site values
sites <- unique(intro_df$site_no)
intro_df_site1 <- filter(intro_df, site_no == sites[1])

#now keep only measured values
intro_df_site1_data <- select(intro_df_site1, -site_no, -dateTime, -Flow_cd)

#create the pairs plot
plot(intro_df_site1_data)
```

<img src='../static/Explore/pairs_examp_single_site-1.png'/ title='Pairs plot for one site'/>

Ah! Now that water temperature and DO plot makes a bit more sense.

Let's move on to boxplots, histograms, and cumulative distribution functions.

Two great ways to use boxplots are straight up and then by groups in a factor. For this we will use `boxplot()` and in this case it is looking for a vector as input.

``` r
boxplot(intro_df$DO, main="Boxplot of D.O. Concentration", ylab="Concentration")
```

<img src='../static/Explore/boxplot_examp-1.png'/ title='Boxplot of dissolved oxygen concentration'/>

As plots go, well, um, not great. Let's try it with a bit more info and create a boxplot for each of the groups. Note the use of an R formula. In R, a formula takes the form of `y ~ x`. The tilde is used in place of the equals sign, the dependent variable is on the left, and the independent variable\[s\] are on the right. In boxplots, `y` is the numeric data variable, and `x` is the grouping variable (usually a factor).

``` r
boxplot(intro_df$DO ~ intro_df$site_no, 
        main="Boxplot of D.O. Concentration by Site", ylab="Concentration")
```

<img src='../static/Explore/boxplot_grps_examp-1.png'/ title='Boxplot of dissolved oxygen grouped by site'/>

Lastly, let's look at two other ways to plot our distributions. First, histograms.

``` r
hist(intro_df$pH)
```

<img src='../static/Explore/base_hist_examp-1.png'/ title='Histogram of pH'/>

``` r
hist(intro_df$pH, breaks=4)
```

<img src='../static/Explore/base_hist_examp-2.png'/ title='Histogram of pH specifying 4 breaks'/>

And finally, cumulative distribution functions. Since CDF's are actually a function of the distribution we need to get that function first. This requires that we combine `plot()` and `ecdf()`, the empirical CDF function.

``` r
wtemp_ecdf <- ecdf(intro_df$Wtemp)
plot(wtemp_ecdf)
```

<img src='../static/Explore/cdf_examp-1.png'/ title='Empirical cumulative distribution plot for water temperature'/>

Exercise 2
----------

Similar to before let's first just play around with some basic exploratory data visualization using the `intro_df` dataset.

1.  Make a scatter plot relating pH to water temperature.

2.  Create a discharge histogram. Explore different values for the argument `breaks`.

3.  Create a boxplot that compares flows by flow approval codes. If it is difficult to interpret the boxplot, try logging the flow.

Summarize using `dplyr`
-----------------------

In this lesson, we have shown how to use base R statistics functions to explore data. Now let's talk about how `dplyr` can help with this. One area where `dplyr` really shines is in modifying and summarizing. We'll look at an example of grouping a data frame and summarizing the data within those groups. We do this with `group_by()` and `summarize()`. You won't notice much of change between this new data frame and the original because `group_by` is changing the class of the data frame so that `dplyr` handles it appropriately in the next function. Let's look at the average discharge and water temperature by site.

``` r
library(dplyr)

class(intro_df)
```

    ## [1] "data.frame"

``` r
# Group the data frame
intro_df_grouped <- group_by(intro_df, site_no)
class(intro_df_grouped)
```

    ## [1] "grouped_df" "tbl_df"     "tbl"        "data.frame"

Now we can summarize the data frame by the groups established previously.

``` r
intro_df_summary <- summarize(intro_df_grouped, mean(Flow), mean(Wtemp))
intro_df_summary
```

    ## # A tibble: 11 × 3
    ##     site_no `mean(Flow)` `mean(Wtemp)`
    ##       <chr>        <dbl>         <dbl>
    ## 1  02203655   18.4972028            NA
    ## 2  02203700    6.3183908            NA
    ## 3  02336120   35.7286364            NA
    ## 4  02336240   58.5893048            NA
    ## 5  02336300   32.0000000            NA
    ## 6  02336313    0.9964894            NA
    ## 7  02336360   21.1109290            NA
    ## 8  02336410   28.6847826            NA
    ## 9  02336526   21.0222727            NA
    ## 10 02336728   33.8584615            NA
    ## 11 02337170 3318.2926829            NA

Notice that this summary just returns NAs. We need the mean calculations to ignore the NA values. We could remove the NAs using `filter()` and then pass that data.frame into `summarize`, or we can tell the mean function to ignore the NAs using the argument `na.rm=TRUE` in the `mean` function. See `?mean` to learn more about this argument.

``` r
intro_df_summary <- summarize(intro_df_grouped, mean(Flow, na.rm=TRUE), mean(Wtemp, na.rm=TRUE))
intro_df_summary
```

    ## # A tibble: 11 × 3
    ##     site_no `mean(Flow, na.rm = TRUE)` `mean(Wtemp, na.rm = TRUE)`
    ##       <chr>                      <dbl>                       <dbl>
    ## 1  02203655                 18.4972028                    20.11838
    ## 2  02203700                  6.3183908                    20.25210
    ## 3  02336120                 35.7286364                    20.52269
    ## 4  02336240                 58.5893048                    20.17676
    ## 5  02336300                 32.0000000                    20.59597
    ## 6  02336313                  0.9964894                    20.86133
    ## 7  02336360                 21.1109290                    21.14540
    ## 8  02336410                 28.6847826                    20.58136
    ## 9  02336526                 21.0222727                    20.67850
    ## 10 02336728                 33.8584615                    21.17165
    ## 11 02337170               3318.2926829                    18.05253

Lastly, one more function, `rowwise()`, allows us to run rowwise, operations. Let's say we had two dissolved oxygen columns, and we only wanted to keep the maximum value out of the two for each observation. This can easily be accomplished using`rowwise`. First, add a new dissolved oxygen column with random values (see `?runif`).

``` r
intro_df_2DO <- mutate(intro_df, DO_2 = runif(n=nrow(intro_df), min = 5.0, max = 18.0))
head(intro_df_2DO)
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02203700 2011-05-20 16:45:00  4.0     A e    NA 7.0 8.6      NA
    ## 2 02336410 2011-05-28 08:15:00 35.0       A  21.8 6.9 6.9   71.24
    ## 3 02203655 2011-05-22 09:30:00  7.8       A  20.6 7.0 6.6   69.08
    ## 4 02336313 2011-05-22 12:00:00  1.3       A  19.3 7.2 7.3   66.74
    ## 5 02203700 2011-05-09 10:30:00  4.9       A  18.0 7.2 4.4   64.40
    ## 6 02336313 2011-05-13 12:15:00  1.0       A  20.4 7.2 7.1   68.72
    ##        DO_2
    ## 1 16.753975
    ## 2 17.559066
    ## 3  7.847835
    ## 4 16.889220
    ## 5  7.331214
    ## 6  7.642675

Now, let's use `rowwise` to find the maximum dissolved oxygen for each observation.

``` r
head(mutate(intro_df_2DO, max_DO = max(DO, DO_2)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02203700 2011-05-20 16:45:00  4.0     A e    NA 7.0 8.6      NA
    ## 2 02336410 2011-05-28 08:15:00 35.0       A  21.8 6.9 6.9   71.24
    ## 3 02203655 2011-05-22 09:30:00  7.8       A  20.6 7.0 6.6   69.08
    ## 4 02336313 2011-05-22 12:00:00  1.3       A  19.3 7.2 7.3   66.74
    ## 5 02203700 2011-05-09 10:30:00  4.9       A  18.0 7.2 4.4   64.40
    ## 6 02336313 2011-05-13 12:15:00  1.0       A  20.4 7.2 7.1   68.72
    ##        DO_2 max_DO
    ## 1 16.753975     NA
    ## 2 17.559066     NA
    ## 3  7.847835     NA
    ## 4 16.889220     NA
    ## 5  7.331214     NA
    ## 6  7.642675     NA

The max is always NA because it is treating the arguments as vectors. It would be similar to running `max(intro_df_2DO$Flow, intro_df_2DO$DO_2)`. So we need to group by row. `rowwise()`, like `group_by` will only change the class of the data frame in preparation for the next `dplyr` function.

``` r
class(intro_df_2DO)
```

    ## [1] "data.frame"

``` r
intro_df_2DO_byrow <- rowwise(intro_df_2DO)
class(intro_df_2DO_byrow)
```

    ## [1] "rowwise_df" "tbl_df"     "tbl"        "data.frame"

``` r
#Add a column that gives max DO
intro_df_DO_max <- mutate(intro_df_2DO_byrow, max_DO = max(DO, DO_2))
head(intro_df_DO_max)
```

    ## # A tibble: 6 × 10
    ##    site_no            dateTime  Flow Flow_cd Wtemp    pH    DO Wtemp_F
    ##      <chr>               <chr> <dbl>   <chr> <dbl> <dbl> <dbl>   <dbl>
    ## 1 02203700 2011-05-20 16:45:00   4.0     A e    NA   7.0   8.6      NA
    ## 2 02336410 2011-05-28 08:15:00  35.0       A  21.8   6.9   6.9   71.24
    ## 3 02203655 2011-05-22 09:30:00   7.8       A  20.6   7.0   6.6   69.08
    ## 4 02336313 2011-05-22 12:00:00   1.3       A  19.3   7.2   7.3   66.74
    ## 5 02203700 2011-05-09 10:30:00   4.9       A  18.0   7.2   4.4   64.40
    ## 6 02336313 2011-05-13 12:15:00   1.0       A  20.4   7.2   7.1   68.72
    ## # ... with 2 more variables: DO_2 <dbl>, max_DO <dbl>

Let's practice using `group_by` and `summarize`.

Exercise 3
----------

We're going to practice summarizing large datasets (using `intro_df`). If you complete a step and notice that your neighbor has not, see if you can answer any questions to help them get it done.

1.  Create a new data.frame that gives the maximum water temperature (`Wtemp`) for each site and name it `intro_df_max_site_temp`. Hint: don't forget about `group_by()`, and use `na.rm=TRUE` in statistics functions when appropriate!

2.  Next, create a new data.frame that gives the average water temperature (`Wtemp`) for each pH value and name it `intro_df_mean_pH_temp`.
