---
author: Jeffrey W. Hollister & Luke Winslow
date: 2016-07-08
slug: Clean
draft: True
title: C. Clean
menu:
---
    ## Warning: package 'knitr' was built under R version 3.2.5

In this third lesson we are going to start working on manipulating and cleaning up our data frames. We are spending some time on this because, in my experience, most data analysis and statistics classes seem to assume that 95% of the time spent working with data is on the analysis and interpretation of that analysis and little time is spent getting data ready to analyze. However, in reality, the time spent is flipped with most time spent on cleaning up data and significantly less time on the analysis. We will just be scratching the surface of the many ways you can work with data in R. We will show the basics of subsetting, merging, modifying, and sumarizing data and our examples will all use Hadley Wickham and Romain Francois' `dplyr` package. There are many ways to do this type of work in R, many of which are available from base R, but I heard from many focusing on one way to do this is best, so `dplyr` it is!

Remember our NWIS data we loaded in the `Get` lesson? That's the dataset we will use here. If it's no longer loaded, go back to the "Reading data into R" section and read the data into R as a data frame (remember that we named it `intro_df`).

Before we jump into the lesson, quick links and lesson goals are:

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Subsetting data with `dplyr`.
-   [Exercise 2](#exercise-2): Merging two data frames together.
-   [Exercise 3](#exercise-3): Using `dplyr` to modify and summarize data.

Lesson Goals
------------

-   Show and tell on using base R for data manipulation
-   Better understand data cleaning through use of `dplyr`
-   Use conditional statements to further manipulate data
-   Use `merge()` to combine data frames by a common key
-   Do some basic reshaping and summarizing data frames
-   Know what pipes are and why you might want to use them

What is `dplyr`?
----------------

The package `dplyr` is a fairly new (2014) package that tries to provide easy tools for the most common data manipulation tasks. It is built to work directly with data frames. The thinking behind it was largely inspired by the package `plyr` which has been in use for some time but suffered from being slow in some cases. `dplyr` addresses this by porting much of the computation to C++. The result is a fast package that gets a lot done with very little code from you.

An additional feature is the ability to work with data stored directly in an external database. The benefits of doing this are that the data can be managed natively in a relational database, queries can be conducted on that database, and only the results of the query returned. This addresses a common problem with R in that all operations are conducted in memory and thus the amount of data you can work with is limited by available memory. The database connections essentially remove that limitation in that you can have a database of many 100s GB, conduct queries on it directly and pull back just what you need for analysis in R.

There is a lot of great info on `dplyr`. If you have an interest, I'd encourage you to look more. The vignettes are particulary good.

-   [`dplyr` GitHub repo](https://github.com/hadley/dplyr)
-   [CRAN page: vignettes here](http://cran.rstudio.com/web/packages/dplyr/)

Subsetting in base R
--------------------

In base R you can use indexing to select out rows and columns. You will see this quite often in other people's code, so I want to at least show it to you.

``` r
#Create a vector
x <- c(10:19)
x
```

    ##  [1] 10 11 12 13 14 15 16 17 18 19

``` r
#Positive indexing returns just the value in the ith place
x[7]
```

    ## [1] 16

``` r
#Negative indexing returns all values except the value in the ith place
x[-3]
```

    ## [1] 10 11 13 14 15 16 17 18 19

``` r
#Ranges work too
x[8:10]
```

    ## [1] 17 18 19

``` r
#A vector can be used to index
#Can be numeric
x[c(2,6,10)]
```

    ## [1] 11 15 19

``` r
#Can be boolean - will repeat the pattern 
x[c(TRUE,FALSE)]
```

    ## [1] 10 12 14 16 18

``` r
#Can even get fancy
x[x %% 2 == 0]
```

    ## [1] 10 12 14 16 18

You can also index a data frame or select individual columns of a data frame. Since a data frame has two dimensions, you need to specify an index for both the row and the column. You can specify both and get a single value like `data_frame[row,column]`, specify just the row and the get the whole row back like `data_frame[row,]` or get just the column with `data_frame[,column]`. These examples show that.

``` r
#Take a look at the data frame
head(intro_df)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst
    ## 1     8.1
    ## 2     7.1
    ## 3     7.6
    ## 4     6.2
    ## 5     7.6
    ## 6     8.1

``` r
#And grab the first site_no
intro_df[1,1]
```

    ## [1] "02336360"

``` r
#Get a whole column
intro_df[,7]
```

    ##    [1]  8.1  7.1  7.6  6.2  7.6  8.1  8.5  7.5  7.6  7.2  7.8  8.3  7.5
    ##   [14]  7.1  9.9  7.5  7.6  9.4  9.0  8.4  7.0  7.7  7.5  5.8  7.7  8.4
    ##   [27]  5.7  7.2   NA  8.9  7.5  5.9  9.0  7.8  7.6  5.6  6.7  7.8  4.2
    ##   [40]  7.7   NA  6.9  8.0  6.9  8.4  7.3  5.6  6.2  7.6  8.8  7.9  8.3
    ##   [53]  9.3  8.6  7.7  8.6  9.5  4.2  7.2  6.6  8.3  6.9  7.8  6.4  8.5
    ##   [66]  8.2  7.5  7.6  8.4  8.0  8.6  7.4 11.0  7.5  7.2   NA  8.6  7.4
    ##   [79]  6.3  6.0  7.7  7.1  6.5  7.3  7.1  9.0  8.8  9.8  9.0  5.8  6.8
    ##   [92]  5.5  5.4  7.6  6.5  8.0  7.3  8.8  6.8  8.3  9.5 10.1   NA  8.2
    ##  [105]  5.2  8.6  8.0  7.2  8.9  8.2  6.2  8.7  8.4 10.6  8.5  8.8  6.6
    ##  [118]  7.8  7.3  7.2  7.3  7.1  8.3  5.5  7.6  7.1  7.9  8.2  6.7  8.0
    ##  [131]  9.4  7.6  8.0  8.2  8.1  9.3  7.8  9.6  6.1  9.0   NA 11.4  6.8
    ##  [144]  6.1  7.8  7.7  8.6  7.4  6.7  6.7  8.6 10.5  8.3  6.7  5.9  8.3
    ##  [157]  8.4  8.4  8.0  6.0 10.6  7.7  6.8  9.5  5.8  7.7  6.2  8.7  6.7
    ##  [170]  8.6  8.0  8.2  8.3  7.9  7.4  7.0  7.5  6.2  6.8  6.3  8.0  7.1
    ##  [183]  4.3  5.7 11.1  8.9  9.0  5.6  7.0  7.2  6.2  6.6  6.6  8.4  6.7
    ##  [196]  5.4  8.8  7.4  9.0  8.4  6.6  7.4  7.8  8.1  6.8  8.2  6.7  3.5
    ##  [209] 10.2  7.7  5.4 10.2  5.7  5.4  7.8  6.3  7.6  7.7  7.0  7.7 10.0
    ##  [222] 10.0  8.4  8.3  7.7  8.6  5.4  7.3  8.0  8.6  4.0  8.6 10.4  9.1
    ##  [235]  5.4  7.8  5.4   NA  7.3  7.3  7.2  6.8  9.9  8.3  8.0  8.2  8.2
    ##  [248]  8.5 10.1  5.7  9.0  8.5   NA  7.7  8.3  8.3  6.4 10.2  6.8  8.3
    ##  [261]  6.0  8.3  5.9  6.8  8.3  8.0  9.1  8.1 10.0  9.2  6.6  6.9  8.5
    ##  [274]  8.6  7.4  7.3  9.6  9.0  7.0  8.3  8.0  9.8  6.0  6.4  7.4  8.3
    ##  [287]  8.4  5.7  8.7  5.2  5.8  8.0  6.7  6.9  6.2  7.1  9.1  5.8  9.0
    ##  [300]  5.5  5.1  8.8  6.8  7.0  7.1   NA  6.4  8.0  9.2  7.8  3.2  9.2
    ##  [313]  7.2  7.2  5.3  5.7  7.0  6.0  3.7  9.2  9.6  5.3  7.8  8.1  4.4
    ##  [326]  6.2  6.5  7.9  8.2  5.2  8.3  8.2  8.5  9.3  6.0  7.5  9.1  5.8
    ##  [339]  8.6  8.0  6.2  5.9  8.8  7.3  6.8  6.9  6.8  9.2  7.1  7.9  9.0
    ##  [352]   NA  6.4  8.3  8.0  9.5  8.7  7.6  7.7  8.2  6.6  8.7  3.7  7.8
    ##  [365]  6.5  7.8  7.3  6.8  9.8  9.3  6.6  8.2 11.2  9.0  6.8  8.5  8.8
    ##  [378]  8.8  7.8 11.7  7.9  7.5  7.0  7.1  7.4  9.5  7.5  6.8  9.2  8.4
    ##  [391]  7.8  6.2  8.6  8.7  7.3  7.4  9.0  6.9  7.3  7.4  9.8  6.8  9.0
    ##  [404]  7.3  6.3  7.6  8.0  7.4  8.5   NA  6.8  7.2  8.9  8.7  9.2  7.4
    ##  [417]  8.7  8.8  7.3  7.3  7.8  6.4  9.7  9.0  6.9  8.0  6.3  9.4  7.1
    ##  [430]  9.3  6.0  9.3  6.9  7.0  8.1  8.1  6.7  9.0  8.9  8.6   NA  9.6
    ##  [443]  8.3  8.8  7.6  7.4  8.1  7.2  7.9 10.4   NA  5.8  7.2  5.2  8.3
    ##  [456]  4.6  3.4  7.4  8.4  8.9  7.4  5.5  8.2 10.4  7.4 11.8  8.0  7.9
    ##  [469]  7.8  6.1  7.5  8.2  6.7  7.5  7.4  7.6  9.6  9.4  7.6  8.4  8.5
    ##  [482]  7.0  5.1  6.1  5.9  8.0  8.1  8.7  8.4  7.7  7.2  5.3  8.2  7.6
    ##  [495]  6.0  7.2  8.3  5.7  6.0  7.8 10.1  7.4  9.4  8.4  7.0  8.2  7.8
    ##  [508]  8.7  6.6  8.6  7.0  7.6  8.2  9.4  7.6  9.1  7.6   NA  6.4  6.7
    ##  [521]  9.3  6.8  7.4  7.5  8.5  6.8  7.8  6.7  7.2  9.1  6.8  8.5  7.8
    ##  [534]  9.8  8.2 10.0  4.0  6.1  6.7  7.9  8.6  8.1   NA  6.8 10.3  7.2
    ##  [547]  8.3  7.2  8.7  9.5  8.1  9.1  7.9  6.3  7.3  6.9  8.6  8.6  7.8
    ##  [560]  5.8  9.3  7.5  8.1  8.8  7.1  7.2  4.4  7.3  7.6  8.0  8.1  7.5
    ##  [573] 10.3   NA  8.8   NA  5.6   NA   NA  8.0  6.6  4.7  9.8  8.0  6.2
    ##  [586]   NA  7.9  7.7  8.1  5.7  8.8  7.7  6.0  3.4  8.3  9.4  7.4  7.4
    ##  [599] 10.5  8.6  5.4  6.6 10.1  9.9  9.4  7.0  7.9  5.6  8.7  7.0  7.9
    ##  [612]  9.0  6.8 11.3  9.6  8.6  6.4  6.9  6.6  7.7  6.6  7.5  8.6  6.9
    ##  [625]  8.8  6.6  8.7 11.1  9.1  6.6  8.5  8.9   NA  8.4  8.0  6.6  6.6
    ##  [638]  7.1  4.6  9.4  7.6  6.8  7.5  8.1  5.3  7.1   NA  6.8  7.8  6.7
    ##  [651]  7.9  6.2  8.8  7.0  8.6  8.3  6.4  6.9  8.7  8.0  7.9  8.5 10.4
    ##  [664]  6.8  6.9  4.2  8.4  9.5  6.5  4.1  7.2  9.8  8.0  6.1  8.5  8.2
    ##  [677]  8.1  7.6  7.4   NA  7.9  7.6 10.2  6.5  7.3  7.6  8.1  6.8  8.7
    ##  [690]  7.8  7.7  7.6  9.7  6.9  9.1  5.4  7.6  7.5  9.1 11.1  6.9  5.8
    ##  [703]  7.2  7.0  8.4  6.7  7.1  7.3  6.0  8.6  6.5   NA  6.1  7.4  6.6
    ##  [716]  6.9  7.1  7.6  8.9  6.4  8.4  8.9  8.7  7.2 10.2  6.0 10.0  5.6
    ##  [729]  7.3  7.5  6.3  8.7  7.3  7.0  6.5  6.2  7.0  5.3  7.4  7.7 10.2
    ##  [742]  5.9  7.4  5.8   NA  7.5  6.7  8.9  7.6  8.6  7.2  7.0  5.6 10.7
    ##  [755]  7.5  8.8  6.4  6.8  6.3  6.3  8.6  8.5  6.8  9.3  6.7  8.6  8.7
    ##  [768]  6.9  6.0  9.8  9.9  9.2  9.2 11.9  7.6  6.2   NA  8.0  7.8  6.3
    ##  [781]  7.3  7.3 10.2  6.2 10.8 10.0  8.2  6.4  9.9  7.0  5.4  9.0  6.1
    ##  [794]   NA  6.7  6.9  5.9  6.8  6.8  7.1  9.4  4.6  7.4  4.5  9.8  8.5
    ##  [807]   NA  6.5   NA  8.6  9.0  7.4  6.4  7.4  7.7  5.5  7.7  7.8  5.8
    ##  [820]  7.2  7.1   NA  8.2  9.9  8.5  7.3  6.9  8.5  6.1  8.7  5.8  8.8
    ##  [833]  8.2  7.2  7.4  3.3  9.4 11.2  9.0  5.0  8.8  4.0  9.9  8.3  4.9
    ##  [846]  8.6  7.1  6.3  6.0  8.5  8.7  4.2  8.5  9.7  9.8  9.0  8.2  8.4
    ##  [859]  6.8  8.0  9.5  6.1  9.1  5.9  9.0  8.8  9.0  7.7  9.4  7.5  8.1
    ##  [872]  8.0  8.9  9.6  8.0  6.2  6.1  3.3  4.8  7.8   NA  6.9  6.2  6.9
    ##  [885]  9.0  7.6  7.2  4.9  6.3  7.7  6.0  7.1  7.5  9.5  5.5  8.2  7.6
    ##  [898]  7.3  7.3  8.2  6.1  9.2  6.1  7.6  7.7  8.1 10.8  9.0  8.2 10.1
    ##  [911]  8.1  7.7  9.7  9.7  7.8  6.5  5.9  5.4  8.9  6.6  6.2  7.0  9.9
    ##  [924]  7.4  6.8  9.2  7.0  8.8  6.0  6.8  6.2  8.7  5.3  7.5  6.1  8.1
    ##  [937]  7.3  8.9  8.4  7.3  7.5  7.2  7.7  6.9  6.8  6.4  6.3  7.2  9.7
    ##  [950]   NA  9.6   NA 12.2  9.8  8.1  8.2  8.9 11.9  6.2  6.2  6.7  8.2
    ##  [963]  8.7  7.7  5.5   NA  4.7  9.1  7.4  8.4  8.0  4.8  7.5   NA  7.2
    ##  [976]  7.6  8.5  6.3  6.4 10.4  7.6  7.4  7.1  7.2  9.1  6.0  7.1  6.7
    ##  [989]  6.8  6.6  8.5  6.8  6.3  6.7  8.9  7.6  9.0  9.1  5.8  8.6  6.4
    ## [1002]  8.1  7.8  8.2 10.2  7.5  8.2  6.9  7.2  8.2  8.6  6.5  7.7  6.9
    ## [1015]   NA  8.8  9.6  6.5  6.9  9.9  9.2  5.6  7.0  7.8  7.6  6.9  7.4
    ## [1028]  8.0  8.2  8.3  7.3  7.3  7.4  8.3  8.5  8.7  8.9  7.5  8.1  7.1
    ## [1041]  4.3  8.8  6.8  7.7  9.1  6.6  9.2  7.5  6.1  7.1  8.6  6.3  7.2
    ## [1054]  9.6  6.3  7.1  9.1  8.8  7.3  7.9   NA  9.3  5.3  6.3  6.2  6.2
    ## [1067]  7.3  6.6  8.4 11.0  6.6  9.3  5.3  8.7   NA  8.2  8.7  7.8  9.0
    ## [1080]  7.0  7.6  8.0  8.2  7.5  8.2  8.4  8.7 10.0  8.5  6.6  9.0  6.1
    ## [1093]  6.1  7.4  6.4  4.8  7.5  7.0  8.2 10.1  6.6  7.2  7.7  7.3  8.8
    ## [1106]  8.2  6.8   NA  8.5  8.9  9.1  8.6  8.1  9.0  8.0  7.7  6.4  8.0
    ## [1119]  7.6  7.3  6.1  8.5  5.6  9.0  7.3  6.5  8.6  6.3  5.9  7.1   NA
    ## [1132]  6.8  8.0  6.5  4.3   NA  8.2   NA  9.4  8.4  9.8  5.9  7.0  7.2
    ## [1145]  9.1  7.2  6.5  5.8  4.2  6.5  6.7   NA  6.7  6.6  7.0  9.3  9.5
    ## [1158]  8.5  4.2  6.4  8.3  6.7  7.0  7.3  8.3 10.0  7.0   NA  7.5  7.5
    ## [1171]  8.8  6.8  8.3  3.4  8.8  8.3  9.1  8.5  8.7   NA  5.5   NA  7.3
    ## [1184]  7.1  7.9 10.0  6.7  8.0  9.0  6.8  9.0  8.9  5.2  7.7  8.2  7.8
    ## [1197]  8.9  8.3  5.1 10.0  6.6  9.1  5.9  9.8  7.4  8.3  7.2  9.3  7.2
    ## [1210]  7.9  8.6  8.6  7.9  5.5  8.2 11.0  7.2  8.4   NA  8.2  5.9  6.9
    ## [1223]  6.8  7.1 10.2  6.9 12.0  8.3  9.0  4.3  7.2 10.2   NA  7.8  7.4
    ## [1236]  7.7  8.5   NA  7.4  8.3  8.6  7.0 10.1  8.0  7.7  7.3  7.5  8.8
    ## [1249]  6.2  7.3  8.5  6.2  8.6  7.0  5.4  7.4  8.8  7.5  9.0  7.4  5.9
    ## [1262]  8.2  5.6 10.0  6.6  9.5  7.8  6.4 10.2  7.8  7.8  6.9  5.8  8.4
    ## [1275]  6.5  9.0  5.6   NA  4.6  5.6  7.5  8.7  7.3  8.6  7.0  7.9  9.1
    ## [1288]  5.2  8.9  9.1  9.0  8.4  9.3  5.6  7.0  7.0   NA  7.3  8.6  9.2
    ## [1301]  8.0  5.4  7.6  8.7  7.9  4.0  8.3  9.1  8.9  8.2  9.0  8.5  5.5
    ## [1314]  8.9  7.3  8.9   NA  7.5  5.4  8.6  7.4  4.3  5.9  7.6  8.3  4.7
    ## [1327]  7.7  5.7  9.3  7.0 10.5  9.5  8.2  8.8   NA  9.8  9.4  8.5  8.2
    ## [1340]   NA  7.2  6.8  9.3  7.9  6.7  6.3  6.0  7.8  7.2  8.7  9.0  6.9
    ## [1353]  5.9  5.9  7.7 10.2  8.4 11.8  9.3  7.6  6.3  9.8  7.8  8.1  8.7
    ## [1366]  6.4  8.4  7.6  9.0  8.3  9.1 10.2  7.9  8.3  6.8  9.6  8.5  8.2
    ## [1379]  5.2  8.3  7.5  7.8  7.1  8.5   NA  7.0  5.7  9.8  5.8  9.9  8.9
    ## [1392]  9.3  6.9  5.5  7.8  7.4  6.9  8.3  8.3  9.4  7.7  4.1  8.6  8.7
    ## [1405]  6.0  5.6  7.4 11.8  6.7  8.0  3.5  6.9  8.4  6.8  7.9  9.0  7.8
    ## [1418]  9.0  9.1  8.9  7.0  4.3  6.4  7.9  5.3  9.0  9.6  7.5  5.4  6.9
    ## [1431]  8.2  8.3  8.4  7.3  8.3  7.9  8.4  8.9 10.0  7.1  6.2  7.3  8.9
    ## [1444]  9.0  9.0  6.5  7.6  9.9  7.2  6.8  7.6   NA  8.0  8.7 11.8  7.3
    ## [1457] 10.7  9.4  7.1  6.0  5.2  7.5  9.2  7.8  7.5  7.5  5.0  8.5  6.8
    ## [1470]  6.7  8.2  7.6  7.0  7.0   NA  6.2  9.0  9.4  5.1  9.1  7.3  6.4
    ## [1483]  7.5  7.3  9.0  6.9  9.0  7.7  7.2 11.3  6.0  9.2  8.6 10.5  6.7
    ## [1496]  4.5  9.0  8.2  7.3  6.8  8.6  9.1  6.2  8.0  7.3  6.8  6.6  6.8
    ## [1509]  7.7  6.8  8.2  9.0  8.1  8.3  6.8  5.7  8.7  8.3  8.0  9.1  8.8
    ## [1522]  7.2  7.4  7.0  6.4 11.1  7.2   NA  6.2  4.3  8.6  6.9  7.4  6.1
    ## [1535]  7.8  8.0  7.0  8.9 12.0  8.7  8.0  8.0  7.8  5.0  8.7  9.9  7.5
    ## [1548]   NA  6.6  9.8  9.1  6.7  7.5  8.9  5.9  5.5  8.4  7.0  6.9 11.2
    ## [1561]  7.1  8.4  8.0  5.6  9.5  5.8  8.3  7.9  7.9  7.7  7.2  6.4  7.0
    ## [1574]  6.2  7.9  6.7  7.8  7.2  7.2  7.5  8.6  6.7  9.0  8.6  8.3  8.9
    ## [1587]  7.6  6.8  6.0  8.4  8.4  6.7  7.6  9.1  6.8  7.0  6.2  5.6  8.5
    ## [1600]  6.6  9.2  7.7  8.0  8.3   NA  7.2  6.2  7.9  8.7  9.6  7.8  6.6
    ## [1613]  7.9  7.9  8.2  6.9  6.9  7.6 11.8  8.3  7.9  8.6  7.0  8.3  7.0
    ## [1626]  6.3  6.7  8.9  9.2  7.6  8.9  8.5  7.4  7.6  8.4  8.3  7.2  6.6
    ## [1639]  8.3  6.9  6.9  9.0  7.3  7.1  8.1  6.9 10.1  8.5  7.7  8.3  6.4
    ## [1652]  7.8  8.1  8.3  5.6  7.8  9.7  5.7  8.1  8.5  5.8  7.9  8.0   NA
    ## [1665]  7.0  8.5  7.0 10.5  8.3  8.1  9.3  8.1  6.5  8.5 10.5  5.3  5.9
    ## [1678]  9.7 10.0  7.8  6.1  7.2  7.5  9.9  7.4  5.4  9.5  8.6  9.1  8.0
    ## [1691]  6.1  9.1  7.7  7.8  5.6  7.9  8.0  8.8  6.8  7.0  5.4  9.0  8.8
    ## [1704] 10.0  6.3  7.8  7.1  6.5  6.9  6.3 12.4  7.7  4.2  6.0  8.8  7.0
    ## [1717]  7.4  8.6  6.8  9.3  9.7  8.2  7.4  6.8  7.9  8.0  7.3  6.9  7.8
    ## [1730]  7.3  6.9  5.0  5.2  5.4  5.6  6.7  9.4  6.0  8.3  4.4  7.2  6.9
    ## [1743]  7.9  6.0  7.2  7.6  6.0  7.9  7.0  5.3  9.4  8.1  7.4  8.7  8.3
    ## [1756]  7.7  7.0  3.6  6.7  9.4  7.7  7.6  9.3   NA  6.9  7.3  5.9 10.1
    ## [1769]  6.5  7.2  5.1  9.0  8.2  8.0  7.1  8.8   NA  6.7  8.5  5.9  8.4
    ## [1782]  7.8  7.7  6.6  7.7  5.4  5.8  7.7  6.2  6.9  8.1  7.5  6.2  8.5
    ## [1795] 10.8  8.0  8.9  7.8   NA  8.8  6.3 11.0  9.8  6.1  6.5  7.0  8.1
    ## [1808]  8.4  9.1  4.0  8.9  8.8  7.0  6.4  8.7 10.1  6.8  7.6  6.5  7.9
    ## [1821]  8.1  7.9  7.9  8.2  6.9  7.1  8.2  8.5  9.0  7.5  7.3  7.2  8.3
    ## [1834]  8.2 10.3  6.5  7.8  8.4  6.5  7.2  6.1  8.0  9.1  6.2  7.4   NA
    ## [1847]  8.2  7.3  8.6 10.7  5.7  6.7 10.3  7.4  7.8  7.7  6.3  5.8  8.8
    ## [1860]  9.6  8.5  7.3  8.6  5.9  6.2  5.8  8.7  6.8  5.7  5.9  5.7  6.2
    ## [1873]  6.3  5.5  7.9  6.9  7.8  7.7 10.6  9.3  6.0  7.9  8.4  6.0  5.5
    ## [1886]  7.2  7.3  6.3  7.9  7.7  8.1  9.0  8.8  6.4  8.5  4.7  9.1  8.6
    ## [1899]  6.9 10.5  8.5  8.7  6.9  5.5  8.2  7.2  7.6  7.5  8.1  6.2 10.9
    ## [1912]  8.2  7.3 10.1  6.6  8.4  6.8  8.7  6.1 11.1  8.7  9.2  7.4  8.6
    ## [1925]  6.4  9.1  7.3  6.2  6.0  8.6 10.0  6.5  7.8  7.7  8.2  8.7  8.8
    ## [1938]  9.2  7.7  6.9 10.1  7.2  5.3  7.6  8.7  7.5  9.7  7.5  7.1  7.7
    ## [1951]  9.0  7.5  8.6  6.6  8.6 11.6  6.5  6.9  8.7  7.1  6.4  8.6 10.1
    ## [1964]   NA  7.3  5.9  9.3  8.5  6.8  6.7  6.5  7.9  8.0  7.3  7.7  7.8
    ## [1977]  7.4  7.0  8.8  6.6  9.0  3.5  6.4  8.0  9.3  8.1  8.7  5.7  7.3
    ## [1990]  7.4  9.0  6.9   NA  5.5  7.9  9.8 10.0  8.4   NA  7.1  7.6  6.3
    ## [2003]   NA  8.5  7.3  6.3  6.9  7.9  7.6  9.9  8.9  8.1  8.5  5.2  7.1
    ## [2016]  8.1  9.0  9.6  8.7  6.2  8.2 10.3  5.6  5.0  7.3  9.2  5.3  8.2
    ## [2029]  7.4  8.8  8.6  8.7  8.2  8.6  9.4  9.7  7.7  7.4  7.0  6.5  6.3
    ## [2042]  7.3 11.0  7.8  6.4  8.0  7.0  8.6  5.3  6.6  6.0  5.6  7.7  6.4
    ## [2055]  7.9  5.9  6.6  9.0  5.2  5.6  6.6  5.7  4.1  9.9   NA  7.7  5.8
    ## [2068]  6.0  7.2  9.0  6.4  8.2  7.5  8.3  7.6  9.8  9.9   NA  8.7  8.6
    ## [2081]  8.1 10.3  7.3  6.1  8.5  9.4  6.6  5.8  8.6  6.8  7.5  8.8  8.3
    ## [2094]  8.1  7.4  8.9  5.4  8.6  6.5  5.6  5.7  6.3  8.8  8.8  7.7  8.7
    ## [2107]  9.4  7.5  6.4  8.0  5.5  8.2  7.8  8.9  6.6  7.0  7.2  9.2  9.2
    ## [2120]  9.0  7.6  5.9  6.5  8.3  7.3  8.0  8.6  8.8  6.3  9.8  8.6  9.8
    ## [2133]  6.3  8.5  9.0  7.0  4.2  5.9  7.2 10.0  8.7  8.3  6.5  7.3  7.5
    ## [2146]  7.0  7.7  8.2  7.9  8.1  5.6  9.2   NA  7.3  7.7  7.4  8.2  8.1
    ## [2159]  8.5  8.8  7.5  6.7  9.9  8.2  6.7  7.5   NA  8.0  7.4  7.1  6.7
    ## [2172]  6.8  3.7  7.0  7.2  6.8  8.6  7.4  9.6  8.8  6.5  8.4  5.3  6.8
    ## [2185]  7.2  8.0  7.3  8.9  5.3  5.7  7.7  9.9  7.3  9.8  8.5  5.6  7.0
    ## [2198]  7.5  7.0  8.8  8.3  9.1  8.9  7.8  9.1  8.3  9.1   NA  8.5  7.5
    ## [2211]  8.5  8.4  8.4  8.7  8.9  5.1  8.8  7.6  7.5  7.0  3.8  7.6  8.4
    ## [2224]  5.6  6.2  6.9 10.9  7.7  6.8  6.6  5.4  8.5  9.6  7.8  8.8  8.7
    ## [2237]  8.2  7.4  7.4  7.5  9.2  7.8  7.4  6.2  6.4  8.4  6.6  7.3  8.8
    ## [2250]  6.5  6.7  6.9  8.3  8.3  6.5  7.4  9.8  7.0  6.7  5.1  6.2   NA
    ## [2263]  8.6  7.4  8.4  8.2  7.4  8.1  6.4  8.2  9.5  7.6  6.7 12.6  7.9
    ## [2276]  7.8  8.8  8.9 10.5  7.0  8.0  6.6  6.6  5.2  7.6  7.2  8.7  9.0
    ## [2289]  6.2  7.8  8.4  7.4  5.9  8.0  7.7  9.0  6.4  9.2  6.6  8.0   NA
    ## [2302]  8.7  8.6  8.6  6.2  9.1  6.6  8.6  8.1 11.7  9.0  7.6  8.1  8.8
    ## [2315]  7.6  8.1  8.7  7.1  3.3  8.9  9.4  7.7  7.1  5.2  8.3  8.7  8.5
    ## [2328]  7.3  8.8  6.7  5.3  6.0  5.9  7.9  6.8  9.2  7.8  7.6  7.2  7.4
    ## [2341]  5.3  5.9  8.6  7.4  5.5  7.7  7.5  8.0  7.7  8.3  8.8  9.6  9.1
    ## [2354]  7.6  6.4 10.1  5.9   NA  8.6  9.0  9.1  6.3  7.4  6.5  7.5  9.8
    ## [2367]  6.4  8.6  8.8  5.6  7.1  8.1  7.0  7.6  7.1  9.6  5.4  7.3  9.8
    ## [2380]  5.2  7.6  9.2 10.8  8.6  4.4  7.5  9.6  6.2  6.3  5.8   NA  7.3
    ## [2393]  9.2  6.1  8.6  8.6  8.8  5.6  7.6  6.7  5.0  8.3  8.3  7.3  7.0
    ## [2406]  7.9  8.5  9.5  7.7  8.5  8.5  8.1  5.0  6.8  8.1  9.9  8.2  8.9
    ## [2419] 10.0  9.0 12.2  7.1  6.8 10.4  8.7 10.0  8.1  7.8  8.9  7.1  8.2
    ## [2432]  8.5  9.5  6.3  5.6  8.2  8.9  9.9  8.2  6.7  9.6  6.7  9.5  5.4
    ## [2445]  8.9  6.8  7.1  9.2  6.4   NA  7.7  9.5  5.7 10.0  6.3  7.4  7.6
    ## [2458]  8.6  8.4  6.8  8.8  6.6  8.4  7.5  7.2  8.9  9.1  8.3  9.2  8.3
    ## [2471]  9.4  8.3  7.8  5.7  6.8  9.6  8.6 10.0  6.3  7.8  7.2  5.6  6.4
    ## [2484]  7.4  6.2  6.7  7.9 10.0  8.3  5.4  8.8  7.0  7.4  7.2  7.1  8.2
    ## [2497]  7.8  6.4  8.5  7.0  8.0  8.8  8.8  8.7  8.7  7.5  8.4  9.0  6.0
    ## [2510]  7.6  6.7 10.9   NA  6.9  5.7  8.6  7.7  7.8  9.0  8.9  6.7  6.9
    ## [2523]  6.3  8.3  5.3  8.2  8.7  7.4  8.1  8.5  7.4   NA  8.3  7.4  8.2
    ## [2536]  7.4  8.6  8.7  6.8  7.7  9.6  7.4  7.4  8.1  6.2 10.6  7.3  8.2
    ## [2549]  7.3  8.1 10.0  8.2  7.3 10.3  8.4  7.5  5.3  6.9  7.7  6.3  8.8
    ## [2562]  7.4   NA  8.6  8.4  8.7  6.9  5.8  5.9  8.2  9.2  7.5  7.3  7.3
    ## [2575]  7.5  9.3  6.6  5.0  9.8  7.9 10.2  9.9  6.9  9.4  8.3  8.1  7.2
    ## [2588]  9.0  7.3  8.5   NA  7.4  7.5  6.6  8.7  8.1  6.9  6.6  7.6  9.4
    ## [2601]  6.9  7.8  7.2  9.3  7.0  3.7  9.4  6.1  6.1  6.2  7.6  6.8  7.0
    ## [2614]  5.4  6.8  9.1  7.7  6.5  8.8  8.0  8.4  8.2  7.3  5.3  8.6  7.2
    ## [2627]  8.0  8.2 10.0  7.0  8.0  7.1  7.8  6.5  7.2  8.3  7.8 10.8  8.0
    ## [2640] 10.3  7.5  9.7  7.7  8.5  8.8  8.9  9.4  8.3  5.2  6.6  7.6  8.7
    ## [2653]  7.6  6.3  6.1 10.0  7.4  6.3  7.6  7.1  5.3  9.1  8.5   NA  6.8
    ## [2666] 10.1  5.3  7.4  6.7  7.4  7.9  7.3  8.4  8.4  9.4  7.8  9.0  6.3
    ## [2679]  6.2  6.9  6.2  6.4  6.7 10.8  7.9  7.4  7.6  9.3  8.9  7.9  5.6
    ## [2692]  8.9  9.1  7.5  9.4  9.8  8.1  6.2 10.7  7.9  5.4  7.8  7.8  8.5
    ## [2705]  6.2  6.5  7.2  8.9  8.5  8.2  8.5  6.9  6.8  8.3  9.1  6.6  7.0
    ## [2718]  7.4  7.7  8.2  6.3  6.7  7.2  8.7  8.2  7.5  7.4  6.5  9.1  5.6
    ## [2731]  4.4  7.5  6.5  8.3  7.2  8.6  5.7  8.2  8.7  8.0  9.4 10.5  7.2
    ## [2744]  8.0  9.1  9.6   NA  6.4 10.0  9.8  8.0  8.1  7.6 10.8  7.9  7.5
    ## [2757]  7.8  9.4  9.8  6.4  8.5 10.3  7.4  6.7 10.0  6.6  9.7  8.9  8.2
    ## [2770]  7.3  8.4  7.6  8.4  6.9  8.9  9.4  6.8  6.4  6.6  8.3  5.4  5.7
    ## [2783]  9.0  8.0  8.6  7.8  9.4  6.9  7.2  5.8  7.6  7.3  7.9  7.0  6.3
    ## [2796]  6.4  6.5  5.5  7.9  6.8  6.7  6.8  6.3  7.6  5.5  7.9  7.4  8.2
    ## [2809]  7.7  8.5  7.7  6.5  8.9  9.1  8.5  7.6  8.4  7.3  6.2  8.2  6.3
    ## [2822]  6.4  7.2  6.4  5.4  8.2  7.8  8.3  7.9  4.4  8.6  5.3  8.2  6.6
    ## [2835]  8.8  5.3  9.5  6.9  7.4  8.4  6.5  9.8  8.7  6.0  7.9  7.6   NA
    ## [2848]  8.2   NA  9.6  8.9  7.5  5.8 10.3  8.2  9.2  5.2  8.0  9.4  7.2
    ## [2861] 11.5  7.8  8.3  8.8  6.9  7.3  9.1  7.3  6.0  8.5  8.0  8.4  7.0
    ## [2874]  7.1  8.7  7.6  6.0  6.2  8.4  7.7  9.5  8.5  9.7  6.3 11.2  7.7
    ## [2887]  8.1  6.9  7.5  8.8  5.6  8.4  6.3  6.7  6.5  6.3  5.3  8.5  8.9
    ## [2900]  8.2  7.7  8.8  7.4  7.2  5.7  8.9  7.4  7.2  6.9  8.0  8.4  5.8
    ## [2913]  7.6  7.5  9.3  6.5  6.3  6.3  8.0  8.3  6.4  7.6  7.4 11.8  6.8
    ## [2926]  8.6  6.8  7.3  6.2  6.0  9.4 10.0   NA  6.1  7.3  8.0 10.0  7.8
    ## [2939]  7.9  5.3 12.4  8.7  8.1  7.6   NA  7.4  9.7  6.2  9.8  7.4  8.3
    ## [2952]  8.0  7.9  8.6  7.2  6.9  8.5  7.6  8.6  6.7  8.1  9.4  8.4  8.9
    ## [2965]  5.4  8.3  6.2  7.3  7.3  8.1  6.5  7.6  8.0  7.8   NA  8.7  7.9
    ## [2978]  6.8 10.6  8.0  9.6  7.0 10.5  6.9  8.4  7.9   NA  8.8  8.0  6.5
    ## [2991]  8.7  7.8  7.0  6.3  7.8  8.4  7.5  8.0  9.9  8.4

``` r
#Get a single row
intro_df[15,]
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 15 02337170 2011-05-05 02:45:00      6700            A         NA     6.7
    ##    DO_Inst
    ## 15     9.9

``` r
#Grab multiple rows
intro_df[3:7,]
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ## 7 02336120 2011-05-12 18:00:00      14.0            A       23.4     7.3
    ##   DO_Inst
    ## 3     7.6
    ## 4     6.2
    ## 5     7.6
    ## 6     8.1
    ## 7     8.5

Did you notice the difference between subsetting by a row and subsetting by a column? Subsetting a column returns a vector, but subsetting a row returns a data.frame. This is because columns (like vectors) contain a single data type, but rows can contain multiple data types, so it could not become a vector.

Also remember that data frames have column names. We can use those too. Let's try it.

``` r
#First, there are a couple of ways to use the column names
head(intro_df$site_no)
```

    ## [1] "02336360" "02336300" "02337170" "02203655" "02336120" "02336120"

``` r
head(intro_df["site_no"])
```

    ##    site_no
    ## 1 02336360
    ## 2 02336300
    ## 3 02337170
    ## 4 02203655
    ## 5 02336120
    ## 6 02336120

``` r
head(intro_df[["site_no"]])
```

    ## [1] "02336360" "02336300" "02337170" "02203655" "02336120" "02336120"

``` r
#Multiple colums
head(intro_df[c("dateTime","Flow_Inst")])
```

    ##              dateTime Flow_Inst
    ## 1 2011-05-03 21:45:00      14.0
    ## 2 2011-05-01 08:00:00      32.0
    ## 3 2011-05-29 22:45:00    1470.0
    ## 4 2011-05-25 01:30:00       7.5
    ## 5 2011-05-02 07:30:00      16.0
    ## 6 2011-05-12 16:15:00      14.0

``` r
#Now we can combine what we have seen to do some more complex queries
#Get all the data where water temperature is greater than 15
high_temp <- intro_df[intro_df$Wtemp_Inst > 15,]
head(high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst
    ## 1     8.1
    ## 2     7.1
    ## 3     7.6
    ## 4     6.2
    ## 5     7.6
    ## 6     8.1

``` r
#Or maybe we want just the discharge that was estimated (code is "E")
estimated_q <- intro_df$Flow_Inst[intro_df$Flow_Inst_cd == "E"]
head(estimated_q)
```

    ## [1] 162  13  18  22  11  12

Data Manipulation in `dplyr`
----------------------------

So, base R can do what you need, but it is a bit complicated and the syntax is a bit dense. In `dplyr` this can be done with two functions, `select()` and `filter()`. The code can be a bit more verbose, but it allows you to write code that is much more readable. Before we start we need to make sure we've got everything installed and loaded. If you do not have R Version 3.0.2 or greater you will have some problems (i.e. no `dplyr` for you).

``` r
install.packages("dplyr")
library("dplyr")
```

I am going to repeat some of what I showed above on data frames but now with `dplyr`. This is what we will be using in the exercises.

``` r
#First, select some columns
dplyr_sel <- select(intro_df, site_no, dateTime, DO_Inst)
head(dplyr_sel)
```

    ##    site_no            dateTime DO_Inst
    ## 1 02336360 2011-05-03 21:45:00     8.1
    ## 2 02336300 2011-05-01 08:00:00     7.1
    ## 3 02337170 2011-05-29 22:45:00     7.6
    ## 4 02203655 2011-05-25 01:30:00     6.2
    ## 5 02336120 2011-05-02 07:30:00     7.6
    ## 6 02336120 2011-05-12 16:15:00     8.1

``` r
#Now select some observations, like before
dplyr_high_temp <- filter(intro_df, Wtemp_Inst > 15)
head(dplyr_high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst
    ## 1     8.1
    ## 2     7.1
    ## 3     7.6
    ## 4     6.2
    ## 5     7.6
    ## 6     8.1

``` r
#Find just observations with estimated flows (as above)
dplyr_estimated_q <- filter(intro_df, Flow_Inst_cd == "E")
head(dplyr_estimated_q)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-27 17:30:00       162            E       21.2     6.4
    ## 2 02336360 2011-05-08 12:30:00        13            E       16.6     7.1
    ## 3 02203655 2011-05-05 05:00:00        18            E       16.9     7.1
    ## 4 02336410 2011-05-01 10:45:00        22            E       18.4     6.8
    ## 5 02336360 2011-05-16 06:15:00        11            E       17.6     7.1
    ## 6 02336360 2011-05-09 21:15:00        12            E       22.7     7.4
    ##   DO_Inst
    ## 1     7.2
    ## 2     8.3
    ## 3     7.5
    ## 4     7.7
    ## 5     8.0
    ## 6     8.8

Now we have seen how to filter observations and select columns within a data frame. Now I want to add a new column. In dplyr, `mutate()` allows us to add new columns. These can be vectors you are adding or based on expressions applied to existing columns. For instance, we have a column of dissolved oxygen in milligrams per liter (mg/L), but we would like to add a column with dissolved oxygen in milligrams per milliliter (mg/mL).

``` r
#Add a column with dissolved oxygen in mg/mL instead of mg/L
intro_df_newcolumn <- mutate(intro_df, DO_mgmL = DO_Inst/1000)
head(intro_df_newcolumn)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst DO_mgmL
    ## 1     8.1  0.0081
    ## 2     7.1  0.0071
    ## 3     7.6  0.0076
    ## 4     6.2  0.0062
    ## 5     7.6  0.0076
    ## 6     8.1  0.0081

Let's take a quick detour and learn about how to apply conditional statements to our data cleaning workflows.

Using if-else statements with dplyr
-----------------------------------

If you have done any programing in any language, then `if-else` statements are not new to you. All they do is tell your code how to make decisions, and they come in handy when cleaning up data frames. For instance, you might want to make a new column of data based on some condition applied to an existing column. That's easy with if-else control structures. Here's the basic syntax of an if-else statement:

    if(some condition){
      do something
    } else {
      do something different
    }

Let's first go through basic if-else structures before using them with data frame manipulation.

``` r
x <- 2

# logical statement inside of () needs to return ONE logical value - TRUE or FALSE. TRUE means it will enter the following {}, FALSE means it won't.
if(x < 0){
  print("negative")
} 

# you can also specify something to do when the logical statement is FALSE by adding `else`
if(x < 0){
  print("negative")
} else {
  print("positive")
}
```

    ## [1] "positive"

The key to if-else is using a logical statement that only returns a single TRUE or FALSE, not a vector of trues or falses. The if statement needs to know if it should enter the `{}` or not, and therefore needs a single answer - yes or no. Here are some useful functions that allow you to use vectors in if-else:

``` r
y <- 1:7

# use "any" if you want to see if at least one of the values meets a condition
any(y > 5)
```

    ## [1] TRUE

``` r
# use "!any" if you don't want any of the values to meet some condition (e.g. vector can't have negatives)
!any(y < 0) 
```

    ## [1] TRUE

``` r
# use "all" when every value in a vector must meet a condition
all(y > 5)
```

    ## [1] FALSE

``` r
# using these in the if-else statement
if(any(y < 0)){
  print("some values are negative")
} 
```

And you can you use multiple `if` statements by stringing them together with `else`

``` r
num <- 198

if(num > 0) {
  print("positive")
} else if (num < 0) {
  print("negative")
} else {
  print("zero")
}
```

    ## [1] "positive"

Now that you have a basic understanding of if-else structures, let's use them with `dplyr` to manipulate a data frame. We want to add a new column if some condition is met, or filter a column if the condition is not met. We can use the `if-else` structure along with `mutate` and `select` from `dplyr` to accomplish this.

``` r
# if the column "DO_mgmL" (dissolved oxygen in mg/mL) does not exist, we want to add it
if(!'DO_mgmL' %in% names(intro_df)){
  mutate(intro_df, DO_mgmL = DO_Inst/1000)
} 
```

    ##        site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst
    ## 1     02336360 2011-05-03 21:45:00     14.00            X       21.4
    ## 2     02336300 2011-05-01 08:00:00     32.00            X       19.1
    ## 3     02337170 2011-05-29 22:45:00   1470.00            A       24.0
    ## 4     02203655 2011-05-25 01:30:00      7.50          A e       23.1
    ## 5     02336120 2011-05-02 07:30:00     16.00            A       19.7
    ## 6     02336120 2011-05-12 16:15:00     14.00          A e       22.3
    ## 7     02336120 2011-05-12 18:00:00     14.00            A       23.4
    ## 8     02336300 2011-05-03 00:15:00     32.00            X       22.3
    ## 9     02336360 2011-05-27 08:15:00    162.00          A e       21.0
    ## 10    02336120 2011-05-27 17:30:00    162.00            E       21.2
    ## 11    02336728 2011-05-15 00:15:00     12.00            A       22.1
    ## 12    02336360 2011-05-08 12:30:00     13.00            E       16.6
    ## 13    02203655 2011-05-05 05:00:00     18.00            E       16.9
    ## 14    02336120 2011-05-27 14:45:00    338.00            A       20.4
    ## 15    02337170 2011-05-05 02:45:00   6700.00            A         NA
    ## 16    02336526 2011-05-03 14:00:00      4.00            A       19.7
    ## 17    02336728 2011-05-22 03:30:00      9.70            X       21.2
    ## 18    02336728 2011-05-16 19:15:00     12.00            A       17.9
    ## 19    02337170 2011-05-17 00:45:00   1840.00            A       16.5
    ## 20    02203700 2011-05-07 15:15:00      5.30          A e       16.8
    ## 21    02336360 2011-06-01 00:15:00      7.20            X       26.5
    ## 22    02336410 2011-05-01 10:45:00     22.00            E       18.4
    ## 23    02336240 2011-05-30 21:00:00     11.00            A       26.1
    ## 24   021989773 2011-05-29 04:30:00  23000.00            A       26.4
    ## 25    02336526 2011-05-23 14:15:00      3.60          A e       21.2
    ## 26    02336313 2011-05-24 19:45:00      0.93            A       25.1
    ## 27   021989773 2011-05-29 05:00:00  19200.00          A e       26.4
    ## 28    02336410 2011-05-14 02:30:00     16.00            X       22.6
    ## 29   021989773 2011-05-22 15:00:00 -68600.00            A       24.0
    ## 30    02336360 2011-05-08 16:15:00     13.00            A       18.0
    ## 31    02336313 2011-05-16 09:00:00      1.00            A         NA
    ## 32    02203655 2011-05-26 15:00:00      6.80          A e       22.1
    ## 33    02336728 2011-05-19 06:00:00     11.00          A e       14.5
    ## 34    02336526 2011-05-27 17:45:00     31.00            A       21.4
    ## 35    02336300 2011-05-16 08:45:00     25.00            A       17.1
    ## 36    02336313 2011-05-30 01:15:00      0.73          A e       25.5
    ## 37    02203655 2011-05-30 17:45:00     10.00            X       23.1
    ## 38    02337170 2011-05-10 08:15:00   1350.00            X       21.0
    ## 39    02203700 2011-05-23 08:15:00      3.70            X       21.1
    ## 40    02336728 2011-05-29 14:45:00     20.00            A       22.0
    ## 41    02336728 2011-05-19 18:00:00     11.00            A       18.4
    ## 42   021989773 2011-05-25 23:30:00  51200.00            A       26.3
    ## 43    02336360 2011-05-16 06:15:00     11.00            E       17.6
    ## 44    02336360 2011-05-22 06:15:00      9.80            X       21.4
    ## 45    02336728 2011-05-25 15:15:00      8.20          A e       21.9
    ## 46    02336240 2011-05-29 12:45:00     14.00            A       21.0
    ## 47    02203700 2011-05-07 06:30:00      5.30            X       16.4
    ## 48    02203655 2011-06-01 02:00:00      8.80            A       25.0
    ## 49    02203700 2011-05-04 01:15:00     48.00            A       19.9
    ## 50    02336360 2011-05-09 21:15:00     12.00            E       22.7
    ## 51    02336240 2011-05-12 22:15:00     11.00          A e       24.9
    ## 52    02336240 2011-05-09 22:15:00     12.00            A       22.5
    ## 53    02337170 2011-05-20 22:30:00   4510.00            A       16.9
    ## 54    02336410 2011-05-12 20:30:00     16.00            A       25.3
    ## 55    02336300 2011-05-20 07:00:00     26.00          A e         NA
    ## 56    02336240 2011-05-04 04:15:00    449.00            A       17.8
    ## 57    02336120 2011-05-18 18:45:00     13.00          A e       16.5
    ## 58    02203700 2011-05-24 06:45:00      3.70            A       22.0
    ## 59    02203700 2011-05-04 21:15:00     24.00            A       20.0
    ## 60    02336300 2011-05-23 09:15:00     22.00            A       22.2
    ## 61    02336728 2011-05-04 11:00:00    117.00            A       16.8
    ## 62    02336240 2011-05-30 04:45:00     12.00            A       23.1
    ## 63    02336120 2011-05-09 07:45:00     16.00            E       18.8
    ## 64    02203655 2011-06-01 01:15:00      8.80          A e       24.9
    ## 65    02336240 2011-05-22 15:00:00      8.90          A e       20.7
    ## 66    02336120 2011-05-08 02:00:00     17.00            X       18.9
    ## 67    02336120 2011-05-21 11:00:00     12.00            A       18.8
    ## 68    02336120 2011-05-03 12:00:00     16.00          A e       19.7
    ## 69    02336240 2011-05-08 14:00:00     12.00            E       16.7
    ## 70    02336410 2011-05-08 11:30:00     22.00            X       17.1
    ## 71    02336313 2011-05-08 21:00:00      1.00            X       21.8
    ## 72    02336728 2011-05-30 03:30:00     17.00            A       22.9
    ## 73    02336526 2011-05-21 00:30:00      3.60            E       22.5
    ## 74    02336300 2011-05-03 23:45:00    108.00            A       19.1
    ## 75    02203655 2011-05-28 14:15:00     20.00            E         NA
    ## 76    02336410 2011-05-27 16:15:00    139.00            X       21.2
    ## 77    02336526 2011-05-31 15:45:00      4.60            X       23.4
    ## 78    02336300 2011-05-01 13:00:00     31.00            X       18.2
    ## 79    02336120 2011-05-27 06:30:00    374.00          A e       21.8
    ## 80   021989773 2011-05-24 12:30:00  46200.00            A       24.8
    ## 81    02336410 2011-05-23 15:30:00     13.00            A       22.0
    ## 82    02336120 2011-05-12 10:00:00     14.00            X       21.6
    ## 83    02337170 2011-05-27 21:00:00        NA            X       20.6
    ## 84    02336728 2011-05-31 10:30:00     13.00            A       22.7
    ## 85    02336240 2011-05-22 06:45:00      8.50            A       20.4
    ## 86    02336240 2011-05-20 21:45:00      9.50            A       21.7
    ## 87    02336526 2011-05-06 12:30:00      5.20            A       13.9
    ## 88    02337170 2011-05-21 04:15:00   4220.00            A       15.5
    ## 89    02337170 2011-05-11 17:15:00   2460.00            A       18.1
    ## 90    02203655 2011-05-23 09:00:00      7.50          A e       21.7
    ## 91    02336360 2011-05-13 04:15:00     11.00            A       23.0
    ## 92   021989773 2011-05-24 05:45:00 -39900.00            A       24.9
    ## 93   021989773 2011-05-14 23:15:00 -48300.00            A       24.5
    ## 94    02336240 2011-05-30 17:00:00     12.00            A       24.6
    ## 95    02336360 2011-05-30 08:30:00      6.90            E       23.6
    ## 96    02336313 2011-05-08 23:00:00      0.98            E       21.8
    ## 97    02203655 2011-05-02 17:45:00     12.00            E       20.1
    ## 98    02203700 2011-05-26 17:15:00      3.70          A e       23.9
    ## 99    02336360 2011-05-28 09:00:00     14.00            A       21.6
    ## 100   02336526 2011-05-13 01:00:00      3.60            E       25.5
    ## 101   02336120 2011-05-18 21:15:00     15.00          A e       17.8
    ## 102   02337170 2011-05-07 08:15:00   5990.00            X       14.1
    ## 103   02336120 2011-05-29 05:00:00     20.00            X       22.9
    ## 104   02336526 2011-05-06 05:45:00      5.20            A       16.2
    ## 105  021989773 2011-05-22 17:30:00 -23200.00          A e       24.2
    ## 106   02203700 2011-05-11 15:00:00      4.90            A       21.7
    ## 107   02203700 2011-05-02 00:30:00        NA            E       22.3
    ## 108   02337170 2011-05-30 15:15:00   1330.00            A       22.7
    ## 109   02336313 2011-05-17 19:15:00      1.00          A e       16.6
    ## 110   02336526 2011-05-27 10:00:00    472.00            A       19.6
    ## 111   02203700 2011-05-03 06:30:00      6.10          A e       19.8
    ## 112   02336360 2011-05-24 21:15:00      9.10          A e       25.8
    ## 113   02337170 2011-05-25 07:45:00   2110.00            A       20.7
    ## 114   02337170 2011-05-06 15:45:00   7830.00            X       11.9
    ## 115   02203655 2011-05-18 01:15:00      9.20            A       15.9
    ## 116   02337170 2011-05-25 17:45:00   1560.00          A e       20.3
    ## 117   02337170 2011-05-27 12:15:00   5300.00            A       20.7
    ## 118   02336120 2011-05-09 05:15:00     16.00            A       19.2
    ## 119   02336410 2011-05-03 11:45:00     20.00            E       20.2
    ## 120   02336360 2011-05-15 06:30:00     11.00            A       20.4
    ## 121   02336360 2011-05-13 00:45:00     11.00            A       24.2
    ## 122   02336313 2011-05-10 12:30:00      1.10            A       19.3
    ## 123   02336526 2011-05-04 03:00:00    377.00            A       17.8
    ## 124  021989773 2011-05-14 22:00:00 -62300.00            A       24.4
    ## 125   02336728 2011-05-15 03:00:00     12.00            A         NA
    ## 126   02336313 2011-05-30 18:15:00      0.73            E       25.7
    ## 127   02336360 2011-05-20 05:45:00     10.00            A       17.9
    ## 128   02336728 2011-05-04 09:30:00    162.00            E       17.2
    ## 129  021989773 2011-05-08 18:30:00  64900.00            X       23.1
    ## 130   02336120 2011-05-22 22:45:00     11.00            A       25.1
    ## 131   02337170 2011-05-14 16:15:00   3900.00            A       15.2
    ## 132   02336313 2011-05-16 10:00:00      1.00            A       16.5
    ## 133   02203700 2011-05-26 16:15:00      3.50            A         NA
    ## 134   02336526 2011-05-04 00:45:00    192.00            A       19.2
    ## 135   02336120 2011-05-16 10:30:00     13.00            X       16.9
    ## 136   02337170 2011-05-22 03:00:00   3330.00            X         NA
    ## 137   02336728 2011-05-03 00:45:00     15.00          A e       21.3
    ## 138   02336300 2011-05-19 18:00:00     25.00            X       18.9
    ## 139   02203655 2011-05-03 06:00:00     11.00            A       20.9
    ## 140   02337170 2011-05-08 17:15:00   1440.00            A       16.5
    ## 141   02336728 2011-05-30 15:15:00     15.00            E       23.8
    ## 142   02336526 2011-05-22 23:15:00      3.50            A       25.4
    ## 143   02336360 2011-05-28 00:30:00     19.00            A       23.6
    ## 144  021989773 2011-05-12 09:30:00  11400.00          A e       23.6
    ## 145   02336120 2011-05-01 07:15:00     17.00          A e       18.8
    ## 146   02203655 2011-05-07 09:45:00     12.00          A e       15.9
    ## 147   02336410 2011-05-11 18:45:00     17.00            A       24.6
    ## 148   02336240 2011-05-15 09:15:00     10.00            X       18.9
    ## 149   02336313 2011-05-10 03:15:00      1.20          A e       22.1
    ## 150   02203655 2011-05-25 15:45:00      7.50          A e       21.5
    ## 151   02336728 2011-05-20 13:30:00     10.00          A e       16.8
    ## 152   02336360 2011-05-17 19:00:00     10.00          A e       16.5
    ## 153   02336300 2011-05-02 19:45:00     31.00            E       22.8
    ## 154   02336300 2011-05-12 11:30:00     28.00          A e       21.7
    ## 155  021989773 2011-05-25 20:15:00 -30100.00            E       25.8
    ## 156   02336360 2011-05-10 15:45:00     12.00            E       20.8
    ## 157   02336410 2011-05-25 17:00:00     11.00          A e       23.4
    ## 158   02336120 2011-05-21 21:00:00     12.00            A       23.3
    ## 159   02203655 2011-05-07 12:00:00     12.00          A e       15.2
    ## 160  021989773 2011-05-06 15:45:00   2990.00          A e       23.2
    ## 161   02337170 2011-05-06 16:15:00   7860.00            E       12.0
    ## 162   02203655 2011-05-06 04:30:00     13.00            A       17.1
    ## 163   02203655 2011-05-21 04:15:00      8.20            A       20.5
    ## 164   02336410 2011-05-20 17:00:00     14.00            A       19.1
    ## 165  021989773 2011-05-25 12:00:00  61400.00            X       25.1
    ## 166   02336526 2011-05-10 01:45:00      4.00          A e       23.7
    ## 167  021989773 2011-05-05 06:15:00  85800.00            X       23.3
    ## 168   02336728 2011-05-24 21:15:00      8.90            E       25.7
    ## 169   02336300 2011-05-14 05:15:00     27.00            E       22.2
    ## 170   02336728 2011-05-20 22:30:00     10.00            E       22.7
    ## 171   02337170 2011-05-10 14:00:00   2550.00            X       20.3
    ## 172   02336526 2011-05-28 16:00:00      9.10          A e       21.1
    ## 173   02337170 2011-05-24 04:00:00   1920.00            E       20.5
    ## 174   02203655 2011-05-05 10:00:00     15.00            A       15.0
    ## 175   02337170 2011-05-29 00:45:00   2570.00            A       21.6
    ## 176   02336526 2011-05-26 14:45:00      2.80            A       22.5
    ## 177   02336728 2011-05-29 12:45:00     20.00            A       21.6
    ## 178   02203655 2011-05-03 22:45:00     59.00            E       20.2
    ## 179   02336313 2011-05-14 12:00:00      1.00            A       20.2
    ## 180  021989773 2011-05-09 02:30:00 -70200.00          A e       22.7
    ## 181   02336240 2011-05-16 09:00:00     10.00            X         NA
    ## 182   02337170 2011-06-01 02:45:00   1260.00            X       26.2
    ## 183   02203700 2011-05-13 02:30:00      4.60            A       23.8
    ## 184   02203655 2011-05-25 10:30:00      7.20            A       21.4
    ## 185   02336526 2011-05-26 19:30:00      2.80            A       24.6
    ## 186   02203655 2011-05-19 21:15:00      8.80            A       17.6
    ## 187   02336360 2011-05-08 20:00:00     13.00            A       19.9
    ## 188  021989773 2011-05-29 20:30:00 -87100.00            A       26.9
    ## 189   02336410 2011-05-26 14:15:00     11.00            A       22.6
    ## 190   02336300 2011-05-25 01:00:00     20.00            A       25.4
    ## 191  021989773 2011-05-31 21:15:00        NA            E       28.0
    ## 192   02203655 2011-05-31 15:15:00      9.60            A       22.6
    ## 193   02336360 2011-05-24 04:45:00      9.10          A e       22.9
    ## 194   02203655 2011-05-18 01:30:00      9.20            E       15.9
    ## 195   02336240 2011-05-31 02:15:00     11.00            A       24.6
    ## 196   02336313 2011-05-31 01:15:00      0.69            A       25.7
    ## 197   02336360 2011-05-10 21:00:00     12.00            X       24.6
    ## 198   02337170 2011-05-29 07:00:00   2070.00            A       21.5
    ## 199   02336360 2011-05-07 19:45:00     13.00          A e       19.7
    ## 200   02336410 2011-05-06 02:30:00     27.00          A e       17.2
    ## 201   02336300 2011-05-23 09:00:00     22.00            A       22.3
    ## 202   02203700 2011-05-04 17:45:00     26.00            A       20.2
    ## 203   02336313 2011-05-18 00:45:00      1.00          A e       16.4
    ## 204   02336728 2011-05-21 00:15:00     10.00            A       21.8
    ## 205   02336120 2011-05-26 12:30:00      8.90            X       22.4
    ## 206   02336120 2011-05-05 00:30:00     36.00          A e       17.9
    ## 207   02203655 2011-05-31 15:00:00      9.60          A e       22.6
    ## 208   02203700 2011-05-12 09:45:00      4.40            X       20.6
    ## 209   02337170 2011-05-19 04:30:00   3850.00            A       13.2
    ## 210   02336410 2011-05-22 01:15:00        NA            A       22.3
    ## 211   02336313 2011-05-31 04:15:00      0.69            A       24.6
    ## 212   02203700 2011-05-03 15:30:00      6.10            X       20.8
    ## 213  021989773 2011-05-28 16:45:00   3660.00            A       26.7
    ## 214  021989773 2011-05-29 10:30:00 -26300.00            X       26.4
    ## 215   02336313 2011-05-07 06:15:00      1.10            A       16.0
    ## 216   02336313 2011-05-11 08:45:00      1.00            A       20.9
    ## 217   02336526 2011-05-12 01:30:00      3.80          A e       25.3
    ## 218   02203655 2011-05-07 08:45:00     12.00            A         NA
    ## 219   02336410 2011-05-12 08:00:00     17.00            A       22.5
    ## 220   02336728 2011-05-02 10:00:00     16.00            A       19.4
    ## 221   02336526 2011-05-18 15:45:00      3.80          A e       14.4
    ## 222   02337170 2011-05-03 03:00:00   4290.00            E       15.4
    ## 223   02336240 2011-05-06 07:30:00     14.00            A       15.0
    ## 224   02336300 2011-05-20 01:45:00     25.00          A e       19.4
    ## 225   02336313 2011-05-19 00:45:00      1.00            A       17.6
    ## 226   02336728 2011-05-17 03:15:00     12.00            A       16.4
    ## 227  021989773 2011-05-14 22:30:00 -48400.00            E       24.4
    ## 228   02337170 2011-05-28 06:45:00   3310.00            A       20.4
    ## 229   02336526 2011-05-05 02:45:00      7.20            A       17.5
    ## 230   02336360 2011-05-19 08:45:00     10.00            A       15.1
    ## 231   02203700 2011-05-09 09:00:00      4.90            E       18.4
    ## 232   02336410 2011-05-14 20:00:00     16.00            X       22.7
    ## 233   02336360 2011-05-17 20:30:00     10.00            A       16.5
    ## 234   02336410 2011-05-05 20:00:00     29.00            A       17.3
    ## 235  021989773 2011-05-15 09:30:00 -84200.00            X       24.0
    ## 236   02336300 2011-05-13 23:45:00     26.00            X       23.9
    ## 237  021989773 2011-05-17 00:00:00 -69700.00            A       23.9
    ## 238  021989773 2011-05-28 00:15:00  76000.00            A       26.2
    ## 239   02336120 2011-05-14 04:15:00     13.00            A       22.1
    ## 240   02336313 2011-05-18 10:00:00      1.00            A       13.6
    ## 241   02336526 2011-05-15 13:00:00      3.60            A       18.6
    ## 242   02336240 2011-05-31 06:00:00     11.00          A e       23.5
    ## 243   02336240 2011-05-18 16:15:00     11.00            X       15.7
    ## 244   02336360 2011-05-04 20:45:00     25.00            E       19.6
    ## 245   02336240 2011-05-04 00:45:00    182.00            A       19.0
    ## 246   02336360 2011-05-06 07:00:00     15.00            X       16.1
    ## 247   02203655 2011-05-21 18:15:00      8.80            A       20.6
    ## 248   02336410 2011-05-17 07:45:00     16.00            A       16.3
    ## 249   02336410 2011-05-18 22:00:00     15.00          A e       17.0
    ## 250  021989773 2011-05-20 21:00:00  53400.00            A       23.9
    ## 251   02336360 2011-05-15 16:00:00     10.00            A       19.2
    ## 252   02336120 2011-05-06 01:30:00     21.00            X       17.2
    ## 253   02336313 2011-05-20 12:45:00        NA            E         NA
    ## 254   02336360 2011-05-13 14:15:00     11.00            X       21.3
    ## 255   02336120 2011-05-20 02:30:00     12.00            A       18.9
    ## 256   02336120 2011-05-14 18:00:00     13.00            A       21.5
    ## 257   02336410 2011-05-30 06:30:00     15.00            A       23.9
    ## 258   02336526 2011-05-24 17:15:00      3.10            A       23.0
    ## 259   02203655 2011-05-21 05:00:00      7.80            A       20.3
    ## 260   02336728 2011-05-05 01:30:00     31.00          A e       17.4
    ## 261  021989773 2011-05-24 08:45:00  70100.00            X       24.8
    ## 262   02336728 2011-05-13 20:45:00     12.00            E       24.2
    ## 263  021989773 2011-05-24 14:30:00 -19200.00            X       25.2
    ## 264   02203655 2011-05-29 21:45:00     11.00          A e       23.3
    ## 265   02203700 2011-05-04 07:00:00        NA            E       16.6
    ## 266   02336120 2011-05-10 14:30:00     15.00            E       20.2
    ## 267   02337170 2011-05-13 18:15:00   5050.00          A e       16.9
    ## 268   02336526 2011-05-04 00:15:00     57.00            A       19.7
    ## 269   02336240 2011-05-20 17:30:00      9.50            A       20.6
    ## 270   02336526 2011-05-04 20:15:00      9.10            A       19.9
    ## 271   02336313 2011-05-21 03:30:00      0.93          A e       20.7
    ## 272   02336313 2011-05-30 19:15:00      0.73            E       26.2
    ## 273   02336360 2011-05-04 16:15:00     31.00          A e       17.3
    ## 274   02336526 2011-05-05 11:00:00      5.70            A       13.6
    ## 275   02336728 2011-05-31 12:45:00     13.00            A       22.7
    ## 276   02336360 2011-05-29 22:00:00      7.50            E       25.7
    ## 277   02336240 2011-05-20 20:30:00      9.50            X       22.0
    ## 278   02337170 2011-05-17 01:00:00   1830.00            A       16.5
    ## 279   02336120 2011-05-27 12:00:00    995.00            X       20.5
    ## 280   02336728 2011-05-25 15:00:00      8.20            A       21.7
    ## 281   02336360 2011-05-10 15:00:00        NA            A       20.3
    ## 282   02337170 2011-05-03 12:15:00   4710.00            E       15.4
    ## 283  021989773 2011-05-01 20:00:00 -81400.00            A       24.1
    ## 284  021989773 2011-05-11 11:00:00  65300.00            A       23.0
    ## 285   02336360 2011-05-27 11:30:00    274.00            A       20.9
    ## 286   02336728 2011-05-26 21:15:00      8.20            A       25.2
    ## 287   02336410 2011-05-09 21:15:00     20.00            A       22.2
    ## 288   02336313 2011-05-03 03:30:00      1.00          A e       21.7
    ## 289   02336360 2011-05-05 14:30:00     17.00            X       14.8
    ## 290   02203655 2011-05-26 05:45:00        NA            A       23.3
    ## 291  021989773 2011-05-04 08:00:00  34500.00            E         NA
    ## 292   02203700 2011-05-04 12:15:00      9.80            A       15.1
    ## 293   02336240 2011-05-31 03:45:00     11.00            A       24.1
    ## 294   02336410 2011-05-31 15:45:00     12.00            E       24.2
    ## 295   02337170 2011-05-27 19:15:00   7200.00          A e       20.6
    ## 296   02337170 2011-06-01 03:15:00   1260.00            A       26.1
    ## 297   02336410 2011-05-05 15:45:00     31.00            E       15.3
    ## 298  021989773 2011-05-30 12:30:00  18200.00            X       26.8
    ## 299   02336728 2011-05-19 10:15:00     11.00            A       14.0
    ## 300  021989773 2011-05-16 18:15:00  46900.00            X       24.0
    ## 301  021989773 2011-05-18 13:30:00 -49500.00            X       23.1
    ## 302   02336120 2011-05-19 01:15:00     13.00            E       17.1
    ## 303   02336313 2011-05-01 23:15:00        NA            A       22.4
    ## 304   02336360 2011-05-22 10:45:00      9.80            E       20.4
    ## 305   02336240 2011-05-29 07:45:00     15.00            X       21.3
    ## 306   02336728 2011-05-17 03:45:00     12.00            A       16.3
    ## 307  021989773 2011-05-31 08:00:00 -49400.00          A e       27.0
    ## 308   02336240 2011-05-08 01:15:00     13.00            A       18.5
    ## 309   02336300 2011-05-16 19:00:00     27.00            A       18.3
    ## 310   02336300 2011-05-08 03:45:00     34.00            X       18.6
    ## 311   02203700 2011-05-11 07:15:00      4.60          A e       21.4
    ## 312   02336360 2011-05-23 18:45:00     11.00            A       24.2
    ## 313   02336120 2011-05-22 03:30:00     12.00            A       22.2
    ## 314   02336120 2011-05-22 10:15:00     11.00            X       20.4
    ## 315  021989773 2011-05-17 00:15:00 -67500.00            X       23.9
    ## 316  021989773 2011-05-17 21:30:00 -48500.00            A       23.8
    ## 317   02203655 2011-05-31 19:00:00      9.60            X       24.0
    ## 318   02203655 2011-05-25 03:30:00      7.20            E       23.0
    ## 319   02203700 2011-05-10 02:00:00      5.10            X       22.8
    ## 320   02336313 2011-05-07 15:15:00      1.20            A       17.3
    ## 321   02337170 2011-05-13 22:30:00   6370.00            A       15.4
    ## 322  021989773 2011-05-21 01:15:00 -75700.00            X       23.6
    ## 323   02203700 2011-05-26 21:15:00      3.50            A       25.0
    ## 324   02336120 2011-05-21 00:15:00     12.00          A e       21.6
    ## 325   02203700 2011-05-25 03:30:00      3.70          A e       23.4
    ## 326  021989773 2011-05-24 03:30:00 -64900.00            X       25.0
    ## 327   02336410 2011-05-31 10:00:00     13.00            X       23.8
    ## 328   02203655 2011-05-07 16:00:00        NA            A       16.2
    ## 329   02336526 2011-05-06 03:30:00      5.50          A e       17.2
    ## 330  021989773 2011-05-20 14:45:00 -52000.00            A       23.3
    ## 331   02203700 2011-05-11 14:45:00      4.90            A       21.4
    ## 332   02336360 2011-05-07 00:45:00     14.00            E       18.4
    ## 333   02336410 2011-05-01 20:45:00     22.00            A       21.6
    ## 334   02336313 2011-05-05 15:45:00      1.30            A       15.6
    ## 335  021989773 2011-05-08 17:15:00  17700.00            X       22.7
    ## 336   02336728 2011-05-27 12:30:00    749.00            A       19.7
    ## 337   02336360 2011-05-22 17:45:00      9.80          A e       23.3
    ## 338   02203655 2011-05-30 03:15:00     11.00            X       24.4
    ## 339   02336240 2011-05-05 11:30:00     16.00            A         NA
    ## 340   02336300 2011-05-07 01:15:00     38.00            A       17.8
    ## 341   02203655 2011-05-25 01:15:00      7.20          A e       23.2
    ## 342   02203700 2011-05-17 12:30:00      4.40          A e       14.7
    ## 343   02336360 2011-05-07 14:45:00     14.00            A       15.7
    ## 344   02336360 2011-05-28 15:45:00     11.00            X       22.0
    ## 345   02336120 2011-05-24 08:00:00     10.00            X       22.2
    ## 346   02336300 2011-05-15 08:15:00     26.00            A       19.9
    ## 347   02337170 2011-05-31 10:30:00   1270.00            A       24.2
    ## 348   02336240 2011-05-23 16:45:00      8.20            A       23.1
    ## 349   02203655 2011-05-28 01:45:00     41.00            X       22.1
    ## 350   02336728 2011-05-01 09:00:00     16.00          A e       18.2
    ## 351   02336410 2011-05-08 18:00:00     21.00            A       19.6
    ## 352   02336410 2011-05-19 09:00:00     16.00            A       15.1
    ## 353   02336526 2011-05-26 06:00:00      3.50            X       23.6
    ## 354   02336240 2011-05-24 15:15:00      8.20          A e       22.2
    ## 355   02336313 2011-05-08 12:30:00      1.10            A       15.9
    ## 356   02337170 2011-05-18 01:00:00   3440.00            A       14.8
    ## 357   02336240 2011-05-04 10:15:00     89.00            X       16.3
    ## 358   02336240 2011-05-28 14:30:00     22.00            E       20.6
    ## 359   02336410 2011-05-31 20:00:00     11.00            A       27.1
    ## 360   02336360 2011-05-01 14:30:00        NA          A e       17.9
    ## 361   02336313 2011-05-13 11:00:00      1.00            A       20.4
    ## 362   02336728 2011-05-14 19:45:00     12.00            X       23.3
    ## 363   02203700 2011-05-13 08:15:00      4.40            A       20.9
    ## 364   02336728 2011-05-30 18:45:00     15.00            A       25.9
    ## 365   02336300 2011-05-24 06:15:00     22.00            E       23.1
    ## 366   02203655 2011-05-06 07:30:00     12.00            E       15.9
    ## 367   02336360 2011-05-11 12:00:00     12.00            X       21.0
    ## 368   02336120 2011-05-26 03:00:00     11.00            A       24.6
    ## 369   02336410 2011-05-19 15:45:00     15.00            X       15.6
    ## 370   02203655 2011-05-18 20:45:00      8.80          A e       16.0
    ## 371   02336313 2011-05-02 21:45:00      1.00            A       23.3
    ## 372   02336313 2011-05-02 15:45:00      1.00            A       21.0
    ## 373   02336526 2011-05-25 00:00:00      3.10          A e       25.3
    ## 374   02337170 2011-05-11 06:15:00   3250.00            A       17.8
    ## 375   02336300 2011-05-14 11:30:00     27.00            E       21.1
    ## 376   02337170 2011-05-04 17:45:00   6280.00            E       16.3
    ## 377   02203700 2011-05-24 17:45:00      3.70            E       24.1
    ## 378   02336410 2011-05-06 12:45:00     26.00            A       15.0
    ## 379   02336360 2011-05-09 04:30:00     13.00            X       19.5
    ## 380   02336526 2011-05-16 22:15:00      5.00            X       18.2
    ## 381   02336120 2011-05-04 02:30:00    504.00            E       18.5
    ## 382   02336120 2011-05-21 05:45:00     12.00          A e         NA
    ## 383   02336240 2011-05-30 08:15:00     12.00            E       22.6
    ## 384   02336410 2011-05-11 03:30:00     19.00            E       23.0
    ## 385   02336120 2011-05-15 07:15:00        NA            A       19.9
    ## 386   02337170 2011-05-12 12:30:00   4480.00          A e       16.1
    ## 387   02336240 2011-05-10 00:45:00     11.00            A       21.8
    ## 388   02336240 2011-05-23 06:30:00      8.50            X       21.6
    ## 389   02337170 2011-05-21 21:45:00   3390.00            X       17.8
    ## 390   02336240 2011-05-10 20:45:00     11.00            A       24.4
    ## 391   02336410 2011-05-21 11:00:00     14.00            E       19.1
    ## 392  021989773 2011-05-06 07:45:00  45800.00            X       23.1
    ## 393   02336728 2011-05-20 01:45:00     11.00            X       18.1
    ## 394   02336300 2011-05-24 21:30:00        NA            A       26.7
    ## 395   02336728 2011-05-31 06:45:00     13.00            X       23.2
    ## 396   02336728 2011-05-30 05:00:00     16.00            X       22.7
    ## 397   02336360 2011-05-05 18:00:00     16.00            A       17.0
    ## 398  021989773 2011-05-31 01:15:00  23600.00            A       27.4
    ## 399   02336120 2011-05-12 02:15:00     15.00            A       23.8
    ## 400   02336360 2011-05-10 03:00:00     12.00            X       21.7
    ## 401   02203700 2011-05-15 17:30:00      4.40            E       19.2
    ## 402   02336300 2011-05-24 02:45:00     21.00            E       24.1
    ## 403   02203700 2011-05-20 17:30:00      4.20            E       20.9
    ## 404   02336410 2011-05-02 07:15:00     21.00            X       20.2
    ## 405  021989773 2011-05-08 12:45:00 -44400.00            A       22.2
    ## 406   02336728 2011-05-03 09:45:00     15.00            A       20.1
    ## 407   02336240 2011-05-01 13:15:00     13.00            A       17.5
    ## 408   02336410 2011-05-31 17:15:00     12.00          A e       25.3
    ## 409   02336240 2011-05-18 01:45:00     11.00            A       15.3
    ## 410   02336360 2011-05-13 23:45:00     11.00            E       23.0
    ## 411  021989773 2011-05-08 22:45:00  41600.00            A       23.0
    ## 412   02336120 2011-05-11 10:15:00     15.00            A       21.2
    ## 413   02336240 2011-05-12 17:15:00     11.00            X       23.8
    ## 414   02336120 2011-05-10 19:30:00     16.00            A       23.1
    ## 415   02336360 2011-05-22 18:45:00      9.80            X       24.3
    ## 416   02336728 2011-05-29 10:45:00     21.00            X       21.8
    ## 417   02336410 2011-05-12 20:15:00     17.00            A       25.3
    ## 418   02336240 2011-05-04 07:45:00    195.00            A         NA
    ## 419   02336360 2011-05-29 15:00:00      8.10            A       22.3
    ## 420   02336300 2011-05-03 23:00:00     47.00            E       20.2
    ## 421   02336240 2011-05-16 05:15:00      9.90            X       17.3
    ## 422   02336360 2011-05-29 05:00:00      8.70            E       23.2
    ## 423   02336526 2011-05-22 01:30:00      3.60            A       23.6
    ## 424   02336360 2011-05-11 18:45:00     12.00            E       24.6
    ## 425   02203700 2011-05-02 02:15:00      6.10            A       21.3
    ## 426   02203700 2011-05-18 23:15:00      4.20            A       18.4
    ## 427   02203655 2011-05-02 07:45:00     11.00            A       20.0
    ## 428   02336728 2011-05-16 19:45:00     12.00            A       18.0
    ## 429   02337170 2011-05-30 10:00:00   1390.00            A       22.9
    ## 430   02203700 2011-05-18 21:45:00      4.00            E       18.7
    ## 431   02203655 2011-05-31 07:45:00      9.20            X       24.0
    ## 432   02337170 2011-05-14 20:30:00   5450.00            X       16.0
    ## 433   02336300 2011-05-12 02:30:00     30.00            A       24.0
    ## 434   02336240 2011-05-24 01:00:00      8.20          A e       23.6
    ## 435   02336120 2011-05-11 23:15:00     15.00            E       24.8
    ## 436   02336410 2011-05-08 11:45:00     21.00            E       17.0
    ## 437   02336410 2011-05-12 07:45:00     17.00            A       22.5
    ## 438   02336313 2011-05-06 19:00:00      1.20            E       19.4
    ## 439   02336360 2011-05-23 17:30:00     11.00            E       23.3
    ## 440   02336410 2011-05-06 11:00:00     26.00          A e       15.2
    ## 441   02336728 2011-05-04 14:00:00     72.00            A       16.5
    ## 442   02337170 2011-05-22 11:00:00   2240.00            X       16.6
    ## 443   02337170 2011-05-24 05:00:00   1840.00            X       20.3
    ## 444   02336526 2011-05-08 00:45:00      4.80          A e       20.8
    ## 445   02336410 2011-05-24 14:45:00     13.00            A       21.9
    ## 446   02336728 2011-05-28 05:30:00     47.00            A       21.8
    ## 447   02336313 2011-05-06 05:45:00      1.20            A       15.5
    ## 448   02337170 2011-05-27 10:45:00   4000.00            A       20.8
    ## 449   02203655 2011-05-07 18:15:00     12.00            E       17.6
    ## 450   02336526 2011-05-11 18:00:00      4.00            E       23.6
    ## 451   02336313 2011-05-29 08:30:00      0.77            X       21.3
    ## 452  021989773 2011-05-01 14:30:00  76200.00            E       23.5
    ## 453   02336410 2011-05-14 02:45:00     16.00            A       22.6
    ## 454  021989773 2011-05-21 04:30:00 -44300.00          A e       23.7
    ## 455   02336120 2011-05-05 02:30:00     33.00          A e       17.3
    ## 456   02203700 2011-05-24 02:00:00      3.70            A       24.1
    ## 457   02203700 2011-05-12 06:45:00      4.60            A       21.9
    ## 458   02336120 2011-05-15 07:30:00     13.00            X       19.8
    ## 459   02336313 2011-05-23 20:00:00      0.98            E       24.8
    ## 460   02337170 2011-05-26 00:30:00   1690.00            A       21.1
    ## 461   02336120 2011-05-15 04:30:00     13.00          A e       20.8
    ## 462  021989773 2011-05-27 08:30:00 -28800.00            E       25.9
    ## 463   02336410 2011-05-05 03:15:00     43.00            A       17.7
    ## 464   02336360 2011-05-19 20:30:00     10.00            X       20.0
    ## 465   02203700 2011-05-05 16:30:00     21.00            X       18.9
    ## 466   02336526 2011-05-20 00:15:00      3.80          A e       20.0
    ## 467   02336728 2011-05-04 03:15:00    284.00            E       19.3
    ## 468   02336300 2011-05-17 09:30:00     27.00            A       15.8
    ## 469   02336240 2011-05-27 20:30:00        NA            A       21.8
    ## 470   02203655 2011-05-02 03:00:00     11.00            A       20.9
    ## 471   02337170 2011-05-29 14:45:00   1620.00            E       21.3
    ## 472   02336313 2011-05-14 16:15:00      1.00            A       21.1
    ## 473  021989773 2011-05-12 01:30:00  52100.00            A       23.5
    ## 474   02336120 2011-05-21 08:30:00     12.00          A e       19.2
    ## 475   02336360 2011-05-02 06:15:00     13.00            A       20.0
    ## 476   02203700 2011-05-26 15:45:00      3.70            A       22.7
    ## 477   02337170 2011-05-18 02:15:00   3470.00            A       14.7
    ## 478   02203700 2011-05-12 15:45:00      5.10            A       22.4
    ## 479   02336300 2011-05-24 14:45:00     21.00            A       22.7
    ## 480   02336526 2011-05-01 15:00:00      4.40          A e       17.8
    ## 481   02336300 2011-05-07 21:30:00        NA          A e         NA
    ## 482   02336313 2011-05-20 11:45:00      1.00            X       16.1
    ## 483  021989773 2011-05-16 11:15:00 -55200.00            A       24.0
    ## 484   02203655 2011-05-25 23:00:00      7.50            A       23.4
    ## 485   02336313 2011-05-24 03:45:00      0.87            E       23.1
    ## 486   02336728 2011-05-21 10:00:00      9.70            A       18.1
    ## 487   02336728 2011-05-01 23:30:00     16.00            X       21.0
    ## 488   02336728 2011-05-17 07:00:00     13.00            A         NA
    ## 489   02336526 2011-05-31 15:15:00      4.60            E       23.1
    ## 490   02336300 2011-05-20 09:00:00     25.00            A       17.7
    ## 491   02336313 2011-05-28 15:45:00      0.93          A e       21.8
    ## 492   02203700 2011-05-16 01:15:00      4.40            A       18.1
    ## 493   02336410 2011-05-07 05:45:00     23.00            A       17.1
    ## 494   02336728 2011-05-27 14:30:00    268.00            A       19.8
    ## 495   02203655 2011-05-26 20:30:00      7.50          A e       23.5
    ## 496   02336410 2011-05-03 11:15:00        NA            A       20.2
    ## 497   02337170 2011-05-09 03:15:00   1390.00            A       18.8
    ## 498  021989773 2011-05-03 23:45:00 -73900.00            X       24.0
    ## 499   02336313 2011-05-12 03:30:00      0.98          A e       23.4
    ## 500   02336300 2011-05-09 01:00:00     32.00            A       20.5
    ## 501   02337170 2011-05-19 02:45:00   4020.00            E       13.3
    ## 502   02336240 2011-05-28 07:00:00     28.00            A       20.9
    ## 503   02337170 2011-05-20 20:00:00   3450.00            E       16.8
    ## 504   02336240 2011-05-12 15:45:00     11.00            A         NA
    ## 505   02336120 2011-05-28 05:00:00     44.00            X       22.0
    ## 506   02336526 2011-05-24 15:00:00      3.10            A       21.7
    ## 507   02336410 2011-05-22 14:00:00     14.00            A       20.7
    ## 508   02336313 2011-05-05 12:15:00      1.40            A         NA
    ## 509   02336313 2011-05-10 01:45:00      0.98            A       22.7
    ## 510   02336360 2011-05-23 21:30:00     10.00            A       24.8
    ## 511   02336360 2011-05-30 23:45:00      6.60            X       26.4
    ## 512   02336410 2011-05-21 10:00:00     14.00          A e       19.3
    ## 513   02336526 2011-05-20 04:45:00      3.80            E       19.1
    ## 514   02337170 2011-05-14 21:00:00   5540.00            A       15.9
    ## 515   02203655 2011-05-06 04:00:00     13.00            A       17.4
    ## 516   02203700 2011-05-24 18:30:00      3.70            E       24.6
    ## 517   02336526 2011-05-16 12:15:00      3.80            A       16.5
    ## 518   02336313 2011-05-09 17:30:00      1.10            A       22.8
    ## 519   02336526 2011-05-23 11:45:00      3.60          A e       21.1
    ## 520   02336526 2011-05-15 05:45:00      3.60          A e       21.1
    ## 521   02336240 2011-05-15 17:45:00     10.00            A       19.3
    ## 522   02336240 2011-05-31 08:00:00     11.00            E       23.0
    ## 523   02336728 2011-05-29 05:30:00     23.00            A       21.9
    ## 524   02336240 2011-05-22 12:00:00      8.90            A       19.5
    ## 525   02336240 2011-05-20 13:45:00      9.50            A       16.6
    ## 526   02336313 2011-05-15 06:00:00      0.93            E       20.0
    ## 527   02337170 2011-05-10 07:30:00   1350.00            X       21.0
    ## 528   02203655 2011-05-30 20:15:00     10.00            A       23.9
    ## 529   02336360 2011-05-13 12:15:00     11.00            A       21.0
    ## 530   02336360 2011-05-18 11:45:00     11.00            A       13.8
    ## 531  021989773 2011-05-12 00:15:00  52200.00          A e       23.8
    ## 532   02203700 2011-05-04 15:15:00     25.00            A       15.9
    ## 533   02336728 2011-05-03 13:15:00     15.00            E       20.3
    ## 534   02337170 2011-05-07 16:00:00   4440.00            A       13.9
    ## 535   02336360 2011-05-31 19:00:00      6.30            A       27.0
    ## 536   02337170 2011-05-03 03:30:00   4190.00            A       15.4
    ## 537   02203700 2011-05-13 10:15:00      4.40            A       20.2
    ## 538   02203700 2011-05-22 14:30:00      3.90          A e       20.4
    ## 539   02336360 2011-05-27 05:45:00     89.00            E       22.1
    ## 540   02336300 2011-05-16 01:15:00        NA            A       18.3
    ## 541   02336120 2011-05-06 00:00:00     22.00          A e       17.7
    ## 542   02336410 2011-05-09 00:15:00     21.00            A       20.1
    ## 543   02336300 2011-05-25 12:30:00     19.00            X       21.9
    ## 544   02336526 2011-05-14 13:15:00      3.60            A       20.5
    ## 545   02203700 2011-05-16 19:15:00      6.70          A e       18.5
    ## 546   02336410 2011-05-10 04:45:00     19.00            X       21.4
    ## 547   02336410 2011-05-07 04:00:00     23.00            A       17.4
    ## 548   02337170 2011-05-31 02:15:00   1270.00            E       25.5
    ## 549   02336300 2011-05-06 15:15:00     39.00            X       15.4
    ## 550   02336360 2011-05-20 21:30:00     10.00            E       22.3
    ## 551   02336300 2011-05-21 00:45:00     25.00            A       22.2
    ## 552   02336526 2011-05-11 16:00:00      4.00          A e       21.7
    ## 553   02336300 2011-05-03 20:45:00        NA          A e       22.8
    ## 554   02203655 2011-05-02 04:15:00     11.00            A       20.8
    ## 555   02336728 2011-05-24 05:00:00      8.90            E       22.1
    ## 556   02336360 2011-05-12 06:45:00     11.00            E       22.5
    ## 557   02336313 2011-05-01 17:15:00      1.10          A e       21.3
    ## 558   02336728 2011-05-04 14:15:00     68.00            A       16.5
    ## 559   02336360 2011-05-09 05:00:00     12.00            A       19.4
    ## 560  021989773 2011-05-02 23:15:00 -70600.00          A e       24.0
    ## 561   02336526 2011-05-02 23:00:00      4.20            A       23.7
    ## 562   02336410 2011-05-15 09:30:00     17.00            X       19.7
    ## 563   02336526 2011-05-27 11:00:00    184.00          A e       19.7
    ## 564   02336360 2011-05-05 16:00:00     17.00          A e       15.4
    ## 565   02336120 2011-05-23 12:30:00     11.00            X       21.2
    ## 566   02336728 2011-05-25 07:15:00      8.20          A e       21.6
    ## 567   02203700 2011-05-22 02:30:00      3.90            A       22.9
    ## 568   02336526 2011-05-28 04:15:00     14.00            E       21.8
    ## 569   02336526 2011-05-26 15:15:00      2.80            A       22.6
    ## 570   02336360 2011-05-11 22:45:00     11.00            A       24.9
    ## 571   02336313 2011-05-13 22:15:00      0.98          A e       24.1
    ## 572   02337170 2011-05-29 02:15:00   2480.00            A       21.6
    ## 573   02337170 2011-05-07 03:15:00   6000.00            A       13.3
    ## 574   02336526 2011-05-30 23:30:00      4.60            A       27.2
    ## 575   02203700 2011-05-25 17:30:00      3.70            X       24.0
    ## 576   02336120 2011-05-07 13:15:00     17.00          A e       15.7
    ## 577   02203700 2011-05-19 10:15:00      4.00            E       14.3
    ## 578   02336240 2011-05-24 00:15:00      8.20            A       23.8
    ## 579   02336300 2011-05-06 14:45:00     39.00            A       15.2
    ## 580   02336240 2011-05-10 22:00:00     11.00            A       24.0
    ## 581   02336120 2011-05-31 02:15:00     13.00            E       25.6
    ## 582   02203700 2011-05-15 01:00:00      4.20            A       21.7
    ## 583   02337170 2011-05-02 12:00:00   2850.00            A       15.5
    ## 584   02336360 2011-05-21 01:00:00     10.00            A       21.1
    ## 585  021989773 2011-05-30 06:15:00  26100.00            A       26.8
    ## 586   02336313 2011-05-10 12:45:00      1.10          A e       19.4
    ## 587   02203655 2011-05-20 02:15:00      8.80            A       18.5
    ## 588   02336728 2011-05-02 10:15:00     15.00          A e       19.5
    ## 589   02336360 2011-05-11 15:15:00     12.00          A e       21.6
    ## 590  021989773 2011-05-14 11:45:00  30400.00            A       24.1
    ## 591   02336410 2011-05-20 23:15:00     14.00            A       21.3
    ## 592   02203700 2011-05-21 15:30:00      4.00            A       19.9
    ## 593   02203655 2011-05-26 15:30:00      7.20            A       22.2
    ## 594   02203700 2011-05-10 06:00:00      4.90          A e       20.8
    ## 595   02336313 2011-05-18 22:15:00      1.00            X       18.2
    ## 596   02337170 2011-05-17 17:45:00   2670.00            E       15.7
    ## 597   02336728 2011-05-28 03:30:00     52.00          A e         NA
    ## 598   02336360 2011-05-28 17:45:00     11.00            X       23.7
    ## 599   02336526 2011-05-06 18:15:00      5.20          A e       17.9
    ## 600   02336240 2011-05-16 14:30:00     10.00            A       16.5
    ## 601  021989773 2011-05-14 21:45:00 -67500.00            A       24.4
    ## 602   02203655 2011-05-02 10:30:00     11.00            A       19.1
    ## 603   02337170 2011-05-20 06:45:00   3780.00            X         NA
    ## 604   02336526 2011-05-01 20:45:00      4.20            A       22.7
    ## 605   02203700 2011-05-15 21:15:00      4.60            A       19.0
    ## 606   02336728 2011-05-26 05:15:00      8.20            A       22.6
    ## 607   02336360 2011-05-05 02:15:00     21.00          A e       18.3
    ## 608   02203700 2011-05-21 12:00:00      4.20            X       17.8
    ## 609   02336410 2011-05-08 21:30:00     21.00            A       20.2
    ## 610   02336120 2011-05-28 04:15:00     46.00          A e       22.1
    ## 611   02336410 2011-05-04 09:45:00    159.00            A       17.5
    ## 612   02337170 2011-05-17 01:45:00   1790.00          A e       16.4
    ## 613   02336360 2011-05-13 05:45:00     11.00            A         NA
    ## 614   02336526 2011-05-12 20:00:00      3.60            A       25.5
    ## 615   02337170 2011-05-12 10:30:00   4010.00            A       16.3
    ## 616   02336313 2011-05-01 17:00:00      1.10            A       21.1
    ## 617   02203700 2011-05-17 13:15:00      4.40            A       14.8
    ## 618   02336410 2011-05-28 10:30:00     33.00          A e       21.4
    ## 619   02336526 2011-05-15 10:45:00      3.60            X       19.2
    ## 620   02337170 2011-05-10 10:15:00   1430.00            A       20.7
    ## 621   02336526 2011-05-13 11:45:00      3.60            A         NA
    ## 622   02336240 2011-05-21 01:00:00      9.20            A       20.7
    ## 623   02336360 2011-05-05 22:00:00     16.00            A       18.0
    ## 624   02336410 2011-05-03 02:00:00     21.00            A       21.5
    ## 625   02203700 2011-05-24 21:15:00      3.90          A e       25.9
    ## 626   02336360 2011-05-30 07:15:00        NA            A       23.8
    ## 627   02336410 2011-05-15 23:30:00     16.00            A       18.7
    ## 628   02336526 2011-05-15 19:45:00      3.60          A e       18.9
    ## 629   02337170 2011-05-08 13:00:00   1540.00            E       15.4
    ## 630  021989773 2011-05-30 23:15:00 -46200.00            A       27.5
    ## 631   02336300 2011-05-18 13:45:00     26.00            A       14.2
    ## 632   02336120 2011-05-09 20:00:00     16.00            A       21.9
    ## 633   02336526 2011-05-20 16:00:00      3.60            E       17.9
    ## 634   02336313 2011-05-06 11:00:00      1.20            X       13.9
    ## 635   02336728 2011-05-03 21:45:00     32.00            X       21.6
    ## 636   02336526 2011-05-11 12:00:00      4.00            A       20.7
    ## 637  021989773 2011-05-07 21:45:00  45900.00            A       23.0
    ## 638  021989773 2011-05-31 02:15:00        NA            E       27.4
    ## 639   02203700 2011-05-14 11:00:00      4.60            X       20.2
    ## 640   02336526 2011-05-30 20:15:00      4.80            A       26.7
    ## 641   02336410 2011-05-28 19:00:00     25.00            A       24.1
    ## 642   02203700 2011-05-06 22:00:00      5.30          A e       21.0
    ## 643   02336240 2011-05-02 05:30:00     13.00            X       19.3
    ## 644   02336728 2011-05-01 04:15:00     17.00            E       18.1
    ## 645  021989773 2011-05-15 12:15:00   6240.00            A       24.1
    ## 646   02203700 2011-05-27 00:15:00    115.00            A       23.2
    ## 647   02336526 2011-05-01 08:30:00      4.20            A       18.5
    ## 648   02337170 2011-05-27 23:15:00   6190.00            X       20.6
    ## 649   02203700 2011-05-17 20:00:00      4.40            X       16.9
    ## 650   02336360 2011-06-01 01:45:00      7.20            A       26.0
    ## 651   02336728 2011-05-04 03:30:00    314.00            E       19.3
    ## 652   02203700 2011-05-03 05:30:00      6.10            A       20.2
    ## 653   02203700 2011-05-15 15:45:00      4.20            E       19.0
    ## 654   02336313 2011-05-09 08:30:00      1.00            A       18.5
    ## 655   02336240 2011-05-15 22:15:00     10.00          A e       18.6
    ## 656   02336300 2011-05-17 00:30:00     27.00            A       17.8
    ## 657   02336410 2011-05-27 07:30:00    207.00            X       21.7
    ## 658  021989773 2011-05-11 23:45:00  66500.00            A       23.9
    ## 659   02336410 2011-05-05 20:45:00     28.00            A       17.4
    ## 660   02203655 2011-05-04 09:30:00     81.00          A e       16.3
    ## 661   02336240 2011-05-02 13:45:00     13.00            E       18.8
    ## 662   02336120 2011-05-15 23:00:00     13.00          A e       18.8
    ## 663   02336410 2011-05-18 18:45:00     16.00            A       16.7
    ## 664   02203700 2011-05-01 09:45:00      6.10            A       17.3
    ## 665   02337170 2011-05-31 06:45:00   1270.00            E       24.7
    ## 666   02203700 2011-05-22 05:00:00      3.70            X       21.7
    ## 667   02336526 2011-05-20 04:30:00      3.80          A e       19.2
    ## 668   02336300 2011-05-17 19:00:00     29.00            A       16.8
    ## 669   02336300 2011-05-24 07:00:00     21.00          A e       22.9
    ## 670   02203700 2011-05-10 00:45:00      4.90          A e       23.4
    ## 671   02336360 2011-05-11 11:45:00     12.00            A       21.1
    ## 672   02336728 2011-05-19 17:15:00     10.00            E         NA
    ## 673   02336300 2011-05-03 16:45:00     31.00            E       22.0
    ## 674  021989773 2011-05-07 05:00:00  42500.00            X       23.0
    ## 675   02336120 2011-05-04 18:15:00     55.00          A e       18.0
    ## 676   02336526 2011-05-28 20:30:00      8.00          A e       25.3
    ## 677   02336313 2011-05-05 23:00:00      1.20            A       18.5
    ## 678   02336526 2011-05-27 21:00:00     22.00            A       23.6
    ## 679   02336526 2011-05-29 12:00:00      6.40            X       20.7
    ## 680   02337170 2011-05-30 11:30:00   1370.00            A       22.7
    ## 681   02336240 2011-05-16 02:00:00     10.00            A       17.8
    ## 682   02336728 2011-05-03 09:15:00     15.00            X       20.0
    ## 683   02337170 2011-05-18 08:45:00   3270.00            A       13.3
    ## 684  021989773 2011-05-07 23:00:00  -4550.00            A       22.8
    ## 685   02336240 2011-05-03 06:30:00     12.00            A       19.9
    ## 686   02203655 2011-05-20 05:45:00      8.20            X       18.3
    ## 687   02336526 2011-05-01 14:30:00      4.40          A e       17.6
    ## 688   02336120 2011-05-30 11:00:00     14.00            A       23.1
    ## 689   02336240 2011-05-24 16:00:00      8.20            A       22.8
    ## 690   02336728 2011-05-15 08:30:00     11.00            E       19.1
    ## 691   02336728 2011-05-24 13:00:00      8.90            X       20.8
    ## 692   02336120 2011-05-03 02:15:00     16.00            X       21.5
    ## 693   02336240 2011-05-23 18:45:00      8.50            E       24.9
    ## 694   02203655 2011-05-22 01:15:00      8.20            X       21.8
    ## 695   02336240 2011-05-05 17:45:00     15.00            A       17.4
    ## 696   02203700 2011-05-19 09:30:00      4.20            E       14.5
    ## 697   02337170 2011-05-28 18:45:00   2400.00            A       21.2
    ## 698   02336728 2011-05-24 11:30:00      8.90          A e       20.6
    ## 699   02336120 2011-05-06 17:30:00     19.00            A       16.4
    ## 700   02336526 2011-05-22 18:00:00      3.50            X       23.0
    ## 701   02337170 2011-05-31 14:45:00   1270.00            X       23.9
    ## 702  021989773 2011-05-28 04:45:00 -11000.00          A e       26.0
    ## 703   02336360 2011-05-28 15:00:00     11.00            E       21.6
    ## 704   02203655 2011-05-03 19:45:00     11.00            A       20.8
    ## 705   02203655 2011-05-05 18:00:00     14.00          A e       16.0
    ## 706   02336120 2011-05-31 12:15:00     12.00          A e       23.2
    ## 707   02203655 2011-05-05 01:45:00     18.00            A       18.3
    ## 708   02336240 2011-05-10 02:15:00     11.00            A       21.2
    ## 709   02203655 2011-05-25 04:00:00      7.20            X       22.9
    ## 710   02336313 2011-05-13 15:00:00      1.00            A       22.1
    ## 711  021989773 2011-05-11 02:30:00 -35400.00          A e       23.1
    ## 712   02203700 2011-05-23 14:30:00      3.90          A e       20.9
    ## 713  021989773 2011-05-11 18:00:00 -61700.00          A e       23.4
    ## 714   02336728 2011-05-30 08:30:00     16.00          A e       22.6
    ## 715   02336526 2011-05-03 06:30:00      4.20            X       21.3
    ## 716   02336240 2011-05-30 02:30:00     12.00            E       23.7
    ## 717   02336526 2011-05-01 10:30:00      4.20            E       17.8
    ## 718   02336300 2011-05-03 22:00:00     33.00          A e         NA
    ## 719   02336526 2011-05-16 02:00:00      3.80            A       18.2
    ## 720   02336313 2011-05-28 09:45:00      0.98            E       20.1
    ## 721   02336313 2011-05-18 14:15:00      1.10          A e       14.8
    ## 722   02336240 2011-05-18 23:45:00      9.90            E       16.9
    ## 723   02336240 2011-05-19 11:45:00      9.50            A       14.2
    ## 724   02336240 2011-05-14 00:45:00     10.00            A       22.8
    ## 725   02336526 2011-05-05 18:45:00      5.70            A       17.2
    ## 726  021989773 2011-05-04 05:00:00  85700.00            A       23.8
    ## 727   02336526 2011-05-03 19:00:00      4.00            A       22.9
    ## 728  021989773 2011-05-23 08:45:00  79100.00            A       24.5
    ## 729   02336240 2011-05-15 00:45:00     11.00          A e       21.4
    ## 730   02336240 2011-05-29 14:45:00     14.00            A       21.9
    ## 731   02336526 2011-05-22 09:00:00      3.30            A       21.3
    ## 732   02337170 2011-05-25 14:30:00   1560.00            A       19.7
    ## 733   02336313 2011-05-20 01:00:00      0.98            X       19.6
    ## 734   02203655 2011-05-28 05:15:00     32.00          A e       21.3
    ## 735   02336313 2011-05-22 01:45:00      0.93            A       22.7
    ## 736   02336313 2011-05-28 09:00:00      1.00            E       20.3
    ## 737   02336728 2011-05-26 05:30:00      8.20            X       22.5
    ## 738  021989773 2011-05-17 14:15:00  18300.00            A       23.5
    ## 739   02336410 2011-05-15 03:45:00     16.00          A e       21.1
    ## 740   02336300 2011-05-08 08:00:00     33.00            A       17.6
    ## 741   02337170 2011-05-18 13:15:00        NA            A       12.7
    ## 742  021989773 2011-05-25 08:15:00   3590.00            A       25.3
    ## 743   02336313 2011-05-19 07:45:00      0.98            A       14.8
    ## 744  021989773 2011-05-13 20:15:00 -67400.00            A       24.6
    ## 745   02203655 2011-05-01 16:15:00     11.00            A       18.5
    ## 746   02336360 2011-05-13 00:15:00     11.00            X       24.4
    ## 747  021989773 2011-05-05 19:00:00  73800.00            X       23.4
    ## 748   02336410 2011-05-08 17:15:00     21.00            X       19.0
    ## 749   02336240 2011-05-11 22:45:00     11.00            X       24.4
    ## 750   02336410 2011-05-17 10:00:00     16.00            A       15.9
    ## 751   02203655 2011-05-22 21:45:00      8.20            X       22.6
    ## 752   02336300 2011-05-02 05:30:00     32.00            A       20.5
    ## 753   02336313 2011-05-31 22:45:00      0.65            E       26.7
    ## 754   02203700 2011-05-13 16:30:00      4.40            A       22.8
    ## 755   02203700 2011-05-07 21:00:00      5.30            E       22.3
    ## 756   02203700 2011-05-25 21:15:00      3.70            E       26.1
    ## 757   02336410 2011-06-01 03:15:00     12.00            E       25.5
    ## 758   02203655 2011-05-21 03:30:00      8.20            A       20.6
    ## 759   02336313 2011-05-01 06:30:00      1.00          A e       18.4
    ## 760  021989773 2011-05-12 15:45:00 -19300.00            E       23.6
    ## 761   02336526 2011-05-29 17:30:00      5.90            A       23.5
    ## 762   02337170 2011-05-25 02:45:00   2120.00            A       21.0
    ## 763   02336526 2011-05-03 09:30:00      4.00          A e       20.3
    ## 764   02336526 2011-05-05 14:30:00      5.70            X       13.6
    ## 765   02336120 2011-05-30 09:30:00     15.00          A e       23.4
    ## 766   02336313 2011-05-01 17:45:00      1.10            E       21.7
    ## 767   02336728 2011-05-17 08:15:00     13.00            A       15.6
    ## 768   02336410 2011-05-26 11:45:00     11.00            A       22.6
    ## 769   02337170 2011-05-27 14:45:00   6860.00            E       20.4
    ## 770   02337170 2011-05-07 13:15:00   5290.00            A       13.8
    ## 771   02336526 2011-05-22 16:45:00      3.60          A e       21.8
    ## 772   02336526 2011-05-14 00:30:00      3.60            A       23.7
    ## 773   02203700 2011-05-10 16:00:00      4.90            A       21.8
    ## 774   02336526 2011-05-24 22:45:00      3.30            A       25.4
    ## 775   02336240 2011-05-02 00:00:00     13.00            A       20.9
    ## 776  021989773 2011-05-25 03:15:00 -42700.00            A       25.4
    ## 777   02337170 2011-05-27 00:45:00   1720.00            A       21.4
    ## 778   02336728 2011-05-21 09:45:00        NA            A       18.1
    ## 779   02336120 2011-05-13 15:00:00     13.00            E       21.7
    ## 780   02203655 2011-05-02 07:15:00     11.00          A e       20.1
    ## 781   02336360 2011-05-10 09:30:00     12.00            A       20.4
    ## 782   02336120 2011-05-28 20:15:00     25.00            A       24.6
    ## 783   02336526 2011-05-12 17:15:00      3.80            A       23.1
    ## 784   02336313 2011-05-02 08:30:00      1.00            A       19.2
    ## 785   02203700 2011-05-01 17:30:00      6.10            E       21.8
    ## 786   02336410 2011-05-19 21:00:00     14.00            A       19.4
    ## 787   02203655 2011-05-18 10:00:00      9.20          A e       14.6
    ## 788   02336120 2011-05-27 02:45:00    580.00            E       22.6
    ## 789   02203700 2011-05-01 16:00:00      6.10            A       19.7
    ## 790   02336526 2011-05-30 02:30:00      6.40            E       25.8
    ## 791   02203700 2011-05-17 07:00:00      4.60            A       15.8
    ## 792   02336313 2011-05-22 16:00:00      1.10            A       22.8
    ## 793  021989773 2011-05-06 16:00:00  13400.00            E       23.2
    ## 794   02203655 2011-05-28 08:15:00     25.00            X       20.7
    ## 795   02203655 2011-05-02 12:00:00     11.00            X       18.7
    ## 796   02336120 2011-05-31 13:15:00     12.00            E       23.3
    ## 797  021989773 2011-05-04 10:15:00 -36700.00          A e       23.4
    ## 798   02336120 2011-05-25 04:30:00      9.90          A e       23.7
    ## 799   02336313 2011-05-20 08:30:00      0.98            A       16.9
    ## 800   02336526 2011-05-15 03:45:00      3.80            A       21.9
    ## 801   02337170 2011-05-14 15:30:00   3700.00            A       15.2
    ## 802   02203700 2011-05-26 02:30:00      3.70            A       24.3
    ## 803   02336240 2011-05-03 11:15:00     13.00          A e       19.3
    ## 804   02203700 2011-05-26 03:30:00      3.50            A       23.9
    ## 805   02336728 2011-05-19 16:30:00        NA          A e       17.0
    ## 806   02336313 2011-05-15 16:00:00      1.00            E       18.8
    ## 807   02337170 2011-05-06 15:15:00   7800.00            A       11.9
    ## 808  021989773 2011-05-04 19:45:00  53600.00          A e       23.6
    ## 809   02336410 2011-05-24 14:00:00     13.00            A       21.7
    ## 810   02336360 2011-05-20 01:30:00     10.00            X       18.7
    ## 811   02336313 2011-05-06 19:15:00        NA            E       19.6
    ## 812   02336120 2011-05-24 14:30:00     11.00            A       21.8
    ## 813   02336410 2011-05-31 05:15:00     13.00            A       24.6
    ## 814   02336728 2011-05-28 04:15:00     51.00            A       22.0
    ## 815   02336526 2011-05-08 07:30:00      4.60          A e       17.7
    ## 816  021989773 2011-05-15 21:45:00 -70400.00            X       24.5
    ## 817   02336360 2011-05-22 14:15:00      9.80            X       20.4
    ## 818   02336410 2011-05-14 00:00:00     16.00            E       23.0
    ## 819   02336313 2011-05-28 21:30:00        NA            X       24.9
    ## 820   02336360 2011-05-30 22:45:00      6.60            A       26.8
    ## 821   02336313 2011-05-20 04:30:00      0.98            A       18.3
    ## 822   02336410 2011-05-25 07:00:00     13.00            A       22.7
    ## 823   02336410 2011-05-16 02:30:00     16.00            A       18.2
    ## 824   02337170 2011-05-07 10:30:00   5880.00            A       14.0
    ## 825   02203700 2011-05-04 15:00:00     24.00            A       15.8
    ## 826   02336313 2011-05-22 22:15:00      0.93            A       24.9
    ## 827   02337170 2011-05-31 15:15:00   1270.00          A e         NA
    ## 828   02336120 2011-05-02 21:15:00     17.00            A       22.2
    ## 829   02203700 2011-05-19 01:15:00      4.20            A       17.6
    ## 830   02337170 2011-05-24 22:30:00   2270.00            A       20.5
    ## 831  021989773 2011-05-14 07:00:00 -63600.00            A       23.9
    ## 832   02336300 2011-05-24 19:00:00     21.00          A e       25.7
    ## 833   02336360 2011-05-05 09:00:00     18.00          A e       15.9
    ## 834   02203655 2011-05-27 11:15:00   1170.00            E       19.7
    ## 835   02203700 2011-05-03 13:00:00      6.10            A       18.9
    ## 836   02203700 2011-05-11 09:15:00      4.60            A       20.6
    ## 837   02337170 2011-05-04 22:45:00   7340.00            A       15.1
    ## 838   02336526 2011-05-14 20:30:00      3.60            A       23.5
    ## 839   02336240 2011-05-20 15:00:00      9.50            A       17.5
    ## 840   02203700 2011-05-09 11:45:00      4.90            E       17.8
    ## 841   02336120 2011-05-05 22:00:00     22.00            A       17.9
    ## 842   02203700 2011-05-23 06:00:00      3.70            A       22.1
    ## 843   02336410 2011-05-18 23:00:00     15.00            E       16.8
    ## 844   02337170 2011-05-24 11:15:00   1940.00            X       20.2
    ## 845   02203700 2011-05-24 12:15:00      3.90            A       20.3
    ## 846   02336240 2011-05-06 21:30:00     14.00            A       18.6
    ## 847   02336240 2011-05-22 06:15:00      8.90            E       20.6
    ## 848  021989773 2011-05-30 20:45:00 -80800.00            A       27.4
    ## 849  021989773 2011-05-13 18:00:00 -59600.00            A       24.6
    ## 850   02336410 2011-05-20 03:15:00     15.00            E       18.2
    ## 851   02336240 2011-05-04 17:15:00     33.00            A       17.5
    ## 852   02203700 2011-05-24 05:45:00      3.90            X       22.4
    ## 853   02337170 2011-05-25 02:15:00   2070.00            A       21.0
    ## 854   02336526 2011-05-24 16:45:00      3.10            A       22.6
    ## 855   02337170 2011-05-07 15:45:00   4520.00            A       13.8
    ## 856   02336410 2011-05-05 18:45:00     30.00            A       17.1
    ## 857   02336240 2011-05-07 05:15:00     13.00            X       16.1
    ## 858   02336120 2011-05-03 17:30:00     17.00            A       21.2
    ## 859   02336526 2011-05-03 03:45:00      4.20            E       22.3
    ## 860   02336728 2011-05-31 19:30:00     13.00            A       26.4
    ## 861   02336360 2011-05-19 00:15:00     10.00            A       16.8
    ## 862   02336313 2011-05-25 04:30:00      0.87            A         NA
    ## 863   02336410 2011-05-18 02:30:00     16.00            A       15.6
    ## 864   02203655 2011-05-23 04:30:00      7.50          A e       22.8
    ## 865   02336728 2011-05-24 17:15:00      8.90            A       23.9
    ## 866   02336313 2011-05-21 19:15:00        NA          A e       23.6
    ## 867   02336410 2011-05-21 16:45:00     14.00            E       20.7
    ## 868   02336313 2011-05-20 13:30:00      1.00          A e       16.8
    ## 869   02203700 2011-05-19 17:45:00      4.20            A       18.9
    ## 870   02336120 2011-05-21 10:15:00     12.00            A       18.9
    ## 871   02336120 2011-05-25 18:45:00     10.00            A       23.9
    ## 872   02336240 2011-05-09 23:00:00     12.00            X       22.3
    ## 873   02336360 2011-05-18 06:45:00     10.00            E       14.7
    ## 874   02337170 2011-05-22 09:00:00   2520.00            E       16.8
    ## 875   02336410 2011-05-02 16:15:00     21.00            A       20.2
    ## 876  021989773 2011-05-14 02:15:00  90600.00            X       24.3
    ## 877  021989773 2011-05-27 03:15:00  20800.00            X       25.9
    ## 878   02203700 2011-05-11 07:00:00      4.60          A e       21.5
    ## 879  021989773 2011-05-22 17:15:00 -36300.00            E       24.1
    ## 880   02203655 2011-05-06 22:15:00     12.00            A       17.8
    ## 881   02336300 2011-05-15 11:30:00     26.00          A e       19.1
    ## 882   02203655 2011-05-27 03:30:00    148.00            A       21.4
    ## 883   02336526 2011-05-25 08:15:00      3.10            E       22.2
    ## 884   02336360 2011-05-11 07:15:00     12.00            A       22.1
    ## 885   02336360 2011-05-14 20:30:00     11.00          A e       23.3
    ## 886   02203655 2011-05-07 20:30:00     11.00            A       18.2
    ## 887   02203655 2011-05-02 18:30:00     11.00            A       20.3
    ## 888  021989773 2011-05-22 03:30:00 -60600.00            A       24.0
    ## 889   02203700 2011-05-20 00:45:00      4.00          A e       20.4
    ## 890   02336313 2011-05-07 02:30:00      1.10            A       17.8
    ## 891  021989773 2011-05-07 11:15:00 -18500.00            X       22.3
    ## 892   02336313 2011-05-18 09:45:00      1.00            A       13.7
    ## 893   02337170 2011-05-31 22:00:00   1260.00            A       26.1
    ## 894   02337170 2011-05-12 05:45:00   4320.00            A       16.4
    ## 895   02336313 2011-05-31 00:45:00      0.73          A e       25.9
    ## 896   02336120 2011-05-08 07:30:00     17.00            A         NA
    ## 897   02336410 2011-05-12 14:30:00     17.00            A       21.9
    ## 898   02336313 2011-05-17 04:00:00      1.10          A e       16.4
    ## 899   02336526 2011-05-28 00:15:00     17.00            E       23.3
    ## 900   02336728 2011-05-01 13:45:00     16.00            E       18.4
    ## 901  021989773 2011-05-05 03:30:00        NA            A       23.6
    ## 902   02203700 2011-05-01 15:00:00      6.10          A e       18.5
    ## 903   02336313 2011-05-28 22:30:00      0.82            A       24.8
    ## 904   02336120 2011-05-21 02:45:00     12.00            A       20.8
    ## 905   02336120 2011-05-01 04:15:00     17.00            A       19.4
    ## 906   02336360 2011-05-03 15:30:00     13.00            A       20.3
    ## 907   02336360 2011-05-18 19:30:00     10.00            A       17.6
    ## 908   02336360 2011-05-09 20:15:00     12.00            A       22.7
    ## 909   02336360 2011-05-07 08:15:00     14.00            A       16.3
    ## 910   02337170 2011-05-18 13:45:00   2670.00            A       12.7
    ## 911   02336240 2011-05-16 12:00:00        NA          A e       16.5
    ## 912   02336240 2011-05-10 13:15:00     11.00            A       19.6
    ## 913   02203700 2011-05-18 20:45:00      4.00          A e       18.8
    ## 914   02337170 2011-05-05 00:45:00   7110.00          A e       14.8
    ## 915   02336120 2011-05-23 23:00:00     11.00            A         NA
    ## 916   02203655 2011-05-03 21:45:00     14.00            A       20.8
    ## 917  021989773 2011-05-04 14:45:00  30800.00            E       23.6
    ## 918  021989773 2011-05-20 20:15:00  61700.00            A       23.8
    ## 919   02336313 2011-05-12 17:00:00      1.00          A e       24.5
    ## 920   02336360 2011-05-23 07:30:00      9.40            E       22.1
    ## 921  021989773 2011-05-05 15:45:00  34300.00            A       23.4
    ## 922   02336300 2011-05-22 04:15:00     24.00            E       22.3
    ## 923   02337170 2011-05-18 18:45:00   3720.00            A       13.6
    ## 924   02336360 2011-05-01 05:30:00     14.00            A       19.2
    ## 925   02336313 2011-05-09 06:45:00      1.00            A       19.0
    ## 926   02336240 2011-05-18 14:00:00     11.00            E       13.8
    ## 927   02336240 2011-05-29 23:30:00     13.00            A       24.7
    ## 928   02336360 2011-05-14 17:15:00        NA            X         NA
    ## 929  021989773 2011-05-05 02:45:00  -7900.00            A       23.8
    ## 930   02336360 2011-05-30 01:00:00      7.20            A       25.0
    ## 931  021989773 2011-05-30 07:00:00  -7050.00          A e       26.8
    ## 932   02336120 2011-05-16 23:45:00     13.00            A       17.8
    ## 933  021989773 2011-05-16 09:00:00 -68600.00            E       23.8
    ## 934   02336313 2011-05-14 13:30:00      1.00            A       20.4
    ## 935  021989773 2011-05-05 11:00:00 -49500.00            A       22.9
    ## 936   02203700 2011-05-04 03:00:00    132.00            E       18.8
    ## 937   02336728 2011-05-24 06:30:00      8.90          A e       21.6
    ## 938   02336120 2011-05-08 19:15:00     17.00          A e       19.5
    ## 939   02336300 2011-05-07 22:45:00     34.00            A       20.1
    ## 940   02336360 2011-05-27 15:45:00     50.00          A e       21.2
    ## 941   02336360 2011-05-10 02:15:00     12.00            E       21.9
    ## 942   02336240 2011-05-13 00:00:00     11.00          A e       24.2
    ## 943   02336526 2011-05-17 09:45:00      4.00            E       15.6
    ## 944   02336360 2011-05-29 12:45:00      8.10            X       21.8
    ## 945   02336410 2011-05-27 00:30:00     65.00            A       22.9
    ## 946   02203655 2011-05-29 05:15:00     14.00            A       22.9
    ## 947   02203655 2011-05-02 01:30:00     11.00            X       21.1
    ## 948   02203700 2011-05-17 21:45:00      4.40            X       16.8
    ## 949   02336410 2011-05-20 19:30:00     14.00          A e       21.5
    ## 950   02336120 2011-05-09 09:30:00     16.00            X       18.6
    ## 951   02336410 2011-05-19 15:00:00     15.00            A       15.2
    ## 952   02336360 2011-05-21 12:45:00      9.80            E       18.8
    ## 953   02336526 2011-05-24 20:00:00      3.00            A       25.0
    ## 954   02336240 2011-05-21 20:00:00      9.20          A e       24.0
    ## 955   02336120 2011-05-04 10:15:00    168.00            A       16.9
    ## 956   02336120 2011-05-25 20:15:00        NA            X       24.9
    ## 957   02336410 2011-05-19 05:30:00     15.00          A e       15.7
    ## 958   02336526 2011-05-19 00:30:00      3.80            X       17.5
    ## 959  021989773 2011-05-05 04:00:00  53300.00            X       23.6
    ## 960   02203700 2011-05-03 08:00:00      6.10            A       19.5
    ## 961  021989773 2011-05-10 00:45:00   2060.00            A       23.0
    ## 962   02336410 2011-05-16 07:15:00     16.00          A e       17.5
    ## 963   02336360 2011-05-22 16:45:00      9.80            X       22.2
    ## 964   02336300 2011-05-20 08:30:00     27.00            X       17.8
    ## 965  021989773 2011-05-15 17:15:00  50300.00            A       24.4
    ## 966   02336120 2011-05-13 17:45:00     13.00          A e       22.8
    ## 967   02203700 2011-05-12 01:15:00      4.60            A       24.7
    ## 968   02203700 2011-05-02 14:45:00      6.10            A       19.4
    ## 969   02336240 2011-05-30 21:15:00     11.00            E       26.1
    ## 970   02336410 2011-05-06 05:45:00     26.00          A e       16.6
    ## 971   02336526 2011-05-08 11:45:00      4.60            X       16.2
    ## 972   02203700 2011-05-16 05:45:00      4.20            E       17.2
    ## 973   02337170 2011-05-28 20:45:00   2560.00            A       21.7
    ## 974   02336410 2011-05-24 11:45:00     13.00            E       21.6
    ## 975   02336728 2011-05-25 05:15:00      8.60          A e       22.3
    ## 976   02336728 2011-05-27 19:15:00    111.00            X       21.4
    ## 977   02336410 2011-05-26 19:30:00     10.00            A       24.9
    ## 978  021989773 2011-05-11 15:30:00 -45100.00            A       23.4
    ## 979   02203700 2011-05-02 11:00:00      6.10            X       18.3
    ## 980   02336526 2011-05-22 17:15:00      3.60            A       22.4
    ## 981   02336526 2011-05-08 05:00:00      4.60            A       18.8
    ## 982   02336120 2011-05-13 01:15:00     14.00          A e       24.3
    ## 983   02336240 2011-05-14 07:30:00     10.00            A       21.0
    ## 984   02336360 2011-05-28 14:00:00     12.00            E       21.4
    ## 985   02336728 2011-05-20 15:30:00     10.00            X       18.6
    ## 986   02203655 2011-05-31 10:30:00      9.20            E       23.2
    ## 987   02203655 2011-05-28 02:00:00     40.00            A       22.0
    ## 988   02336240 2011-05-24 06:45:00      8.20            X       22.0
    ## 989   02336526 2011-05-10 04:30:00      4.00            X       22.6
    ## 990   02203700 2011-05-11 13:45:00      4.60            X       20.6
    ## 991   02336728 2011-05-01 15:30:00     16.00            E       19.4
    ## 992   02336300 2011-05-23 12:15:00     21.00            A       21.6
    ## 993  021989773 2011-05-04 17:00:00  74300.00            X       23.5
    ## 994   02336120 2011-05-25 05:15:00      9.90          A e       23.5
    ## 995   02336313 2011-05-14 18:45:00      1.00          A e       22.8
    ## 996   02336360 2011-05-31 22:00:00      6.60            X       27.2
    ## 997   02336728 2011-05-20 20:45:00     11.00            X       22.7
    ## 998   02336300 2011-05-21 18:30:00     23.00          A e       23.3
    ## 999  021989773 2011-05-13 10:30:00  -2120.00          A e       23.9
    ## 1000  02336360 2011-05-13 22:15:00     11.00            A       23.5
    ## 1001  02336300 2011-05-25 07:15:00     20.00            E       23.1
    ## 1002  02336728 2011-05-23 14:30:00      8.90            A       21.2
    ## 1003  02336526 2011-05-27 07:15:00     68.00          A e       20.4
    ## 1004  02336410 2011-05-24 16:30:00     13.00            A       22.9
    ## 1005  02336360 2011-05-17 16:30:00     10.00            E       15.9
    ## 1006  02336410 2011-05-24 00:30:00     15.00            X       24.0
    ## 1007  02336410 2011-05-05 07:00:00        NA            A       16.6
    ## 1008  02336360 2011-05-14 05:45:00     11.00          A e       21.9
    ## 1009  02336120 2011-05-27 21:45:00     79.00            X       22.7
    ## 1010  02336120 2011-05-01 23:30:00     17.00          A e       21.6
    ## 1011  02336300 2011-05-07 19:00:00     34.00            E       19.9
    ## 1012  02336410 2011-05-27 02:15:00    150.00            X       22.4
    ## 1013  02336728 2011-05-15 01:15:00     12.00            E       21.5
    ## 1014  02336410 2011-05-13 04:45:00     17.00            E       23.0
    ## 1015  02336120 2011-05-07 21:00:00     18.00            X       19.6
    ## 1016  02336300 2011-05-23 18:45:00     21.00            A       25.1
    ## 1017  02336300 2011-05-19 21:00:00     26.00            A       21.1
    ## 1018 021989773 2011-05-09 09:30:00  52000.00            E       22.5
    ## 1019  02336360 2011-05-12 09:30:00     11.00            E       21.8
    ## 1020  02336526 2011-05-05 16:45:00      5.70            X       15.4
    ## 1021  02336526 2011-05-05 14:15:00      5.70            A       13.5
    ## 1022  02203655 2011-05-26 01:45:00      6.80            A       23.5
    ## 1023  02336313 2011-05-22 23:15:00      0.93          A e       24.7
    ## 1024  02203700 2011-05-17 14:45:00      4.90            A       15.3
    ## 1025  02336728 2011-05-15 01:45:00     12.00            A       21.2
    ## 1026  02336120 2011-05-29 10:00:00     18.00          A e       22.0
    ## 1027  02336410 2011-05-15 05:30:00     16.00            A       20.7
    ## 1028  02336120 2011-05-09 01:30:00     16.00            A       20.0
    ## 1029  02336360 2011-05-07 07:45:00     14.00            E       16.4
    ## 1030  02203700 2011-05-08 15:30:00      4.90            A       18.5
    ## 1031  02336240 2011-05-11 12:30:00     11.00            A       20.5
    ## 1032  02336360 2011-05-21 10:45:00      9.80            A       19.0
    ## 1033  02336300 2011-05-21 03:45:00     25.00            E       20.9
    ## 1034  02336120 2011-05-04 22:45:00     40.00          A e       18.6
    ## 1035  02337170 2011-05-27 00:30:00   1720.00            X       21.4
    ## 1036  02336313 2011-05-11 18:45:00      0.98            A       25.4
    ## 1037  02336300 2011-05-20 16:00:00     25.00            E       19.0
    ## 1038  02336360 2011-05-13 13:45:00     11.00            A       21.1
    ## 1039  02336728 2011-05-02 14:15:00     16.00            A       19.9
    ## 1040  02336300 2011-05-10 11:45:00     31.00          A e       20.2
    ## 1041  02203700 2011-05-25 06:00:00      3.70          A e       22.3
    ## 1042  02336240 2011-05-08 20:15:00     12.00            E       20.2
    ## 1043  02336526 2011-05-31 10:45:00        NA            A       22.8
    ## 1044  02336728 2011-05-22 09:00:00      9.30            A       19.6
    ## 1045  02336360 2011-05-18 11:30:00     11.00            A       13.9
    ## 1046  02336313 2011-05-14 09:15:00      0.98          A e       20.6
    ## 1047  02336728 2011-05-17 14:30:00     12.00            X       15.7
    ## 1048  02203655 2011-05-27 15:15:00    201.00            X       19.8
    ## 1049 021989773 2011-05-04 15:30:00  56700.00            E       23.6
    ## 1050  02336360 2011-05-14 11:15:00        NA          A e       20.9
    ## 1051  02336240 2011-05-06 11:45:00     14.00            A       14.2
    ## 1052 021989773 2011-05-10 15:30:00 -51900.00            E       23.0
    ## 1053  02336300 2011-05-21 10:00:00     25.00            E       19.6
    ## 1054  02336120 2011-05-18 19:00:00     13.00            A       16.7
    ## 1055 021989773 2011-05-27 21:00:00 -42600.00          A e       26.3
    ## 1056  02336300 2011-05-14 02:00:00     27.00            E         NA
    ## 1057  02336240 2011-05-06 17:15:00     14.00            X       17.5
    ## 1058  02336120 2011-05-20 20:45:00     13.00          A e       21.4
    ## 1059  02336410 2011-05-13 12:15:00     17.00            E       21.4
    ## 1060  02336240 2011-05-27 06:45:00    292.00            E       20.9
    ## 1061  02336360 2011-05-14 12:45:00     11.00            E       20.8
    ## 1062  02336300 2011-05-17 20:30:00     29.00            E       16.7
    ## 1063 021989773 2011-05-16 09:45:00 -65800.00            A       23.8
    ## 1064 021989773 2011-05-04 16:30:00  79500.00            X       23.6
    ## 1065  02336526 2011-05-24 09:00:00      3.10          A e       22.0
    ## 1066  02336313 2011-05-02 08:15:00      1.00            A       19.3
    ## 1067  02203655 2011-05-27 00:45:00    330.00            A       22.8
    ## 1068  02203655 2011-05-30 17:30:00     10.00            A       23.0
    ## 1069  02203655 2011-05-18 03:15:00      9.20            E       15.7
    ## 1070  02203700 2011-05-12 19:30:00      4.60            A       26.1
    ## 1071  02336360 2011-05-26 02:30:00      8.40            A       24.3
    ## 1072  02336360 2011-05-19 01:00:00     10.00            X       16.6
    ## 1073 021989773 2011-05-02 12:30:00 -27200.00            A       23.8
    ## 1074  02203700 2011-05-03 00:00:00      6.10            A       22.7
    ## 1075 021989773 2011-05-31 15:00:00  70800.00            X       27.2
    ## 1076  02336526 2011-05-18 12:00:00      3.80            X       13.6
    ## 1077  02336410 2011-05-13 18:00:00     16.00            A       23.6
    ## 1078  02336240 2011-05-22 13:15:00      8.90            A       19.7
    ## 1079  02336313 2011-05-22 18:30:00      1.00            A       24.9
    ## 1080  02336120 2011-05-28 06:15:00     41.00            E       21.8
    ## 1081  02336313 2011-05-19 02:15:00      1.00            X       17.0
    ## 1082  02336360 2011-05-26 16:00:00      8.10            A       23.2
    ## 1083  02336120 2011-05-20 05:30:00     12.00            A       18.0
    ## 1084  02336360 2011-05-28 18:00:00     11.00            A       23.9
    ## 1085  02336360 2011-05-23 15:45:00     10.00            A       22.0
    ## 1086  02336410 2011-05-07 07:30:00     23.00            X       16.7
    ## 1087  02336360 2011-05-26 19:00:00      8.40            E       25.2
    ## 1088  02337170 2011-05-14 01:15:00   5840.00            A       14.3
    ## 1089  02337170 2011-05-27 01:15:00   1710.00            A       21.3
    ## 1090  02336300 2011-05-13 09:15:00     27.00            A       22.0
    ## 1091  02336360 2011-05-08 19:15:00     13.00            X       19.8
    ## 1092  02203655 2011-05-24 10:45:00      7.80            E       21.3
    ## 1093 021989773 2011-05-06 03:45:00 -10200.00            E       23.6
    ## 1094  02336300 2011-05-26 00:15:00     19.00            X         NA
    ## 1095  02336360 2011-05-29 02:15:00      9.10            E       23.9
    ## 1096  02203700 2011-05-14 12:15:00      4.60            X       20.1
    ## 1097  02336360 2011-05-27 12:30:00    170.00            X       20.8
    ## 1098  02203655 2011-05-03 17:00:00     11.00            X       20.6
    ## 1099  02336300 2011-05-07 23:30:00     32.00            A       19.8
    ## 1100  02337170 2011-05-20 10:15:00   3080.00            A       14.4
    ## 1101  02336410 2011-05-31 12:15:00     12.00            A       23.4
    ## 1102  02336120 2011-05-27 17:45:00    156.00            A       21.2
    ## 1103  02336120 2011-05-21 13:30:00     12.00            X       18.9
    ## 1104  02336728 2011-05-13 09:45:00     12.00            A       20.9
    ## 1105  02336313 2011-05-20 18:15:00      1.00            A       21.6
    ## 1106  02336120 2011-05-14 17:45:00     13.00            E       21.4
    ## 1107  02336240 2011-05-31 05:15:00     11.00          A e       23.7
    ## 1108  02203655 2011-05-29 19:15:00     12.00          A e       22.6
    ## 1109  02336526 2011-05-04 04:15:00    152.00            A       17.1
    ## 1110  02336360 2011-05-20 00:45:00     10.00            A       19.0
    ## 1111  02336410 2011-05-19 12:00:00     15.00            A       14.7
    ## 1112  02336240 2011-05-18 06:30:00     11.00            X       14.3
    ## 1113  02336728 2011-05-21 23:15:00      9.70            A       23.8
    ## 1114  02336526 2011-05-01 16:45:00      4.40            A       19.1
    ## 1115  02336360 2011-05-05 05:15:00     20.00          A e       17.2
    ## 1116  02336728 2011-05-03 07:00:00        NA            A       19.9
    ## 1117  02203655 2011-05-30 10:00:00     10.00            A       22.8
    ## 1118  02336728 2011-05-03 14:15:00     15.00            A       20.7
    ## 1119  02336120 2011-05-02 07:15:00     16.00            A       19.7
    ## 1120  02336300 2011-05-10 02:30:00     31.00          A e       21.9
    ## 1121 021989773 2011-05-02 18:00:00  50500.00            A       23.8
    ## 1122  02336120 2011-05-15 23:15:00     13.00            A       18.7
    ## 1123 021989773 2011-05-26 08:15:00 -17500.00            E       25.6
    ## 1124  02336313 2011-05-09 16:15:00      1.10            A       21.7
    ## 1125  02336728 2011-05-31 06:30:00     13.00            A       23.2
    ## 1126  02336360 2011-05-25 06:45:00      9.10            X       22.7
    ## 1127  02336410 2011-05-06 10:00:00     26.00            A       15.5
    ## 1128  02203655 2011-05-30 09:15:00     10.00            A       23.1
    ## 1129 021989773 2011-05-26 11:00:00  71700.00          A e       25.3
    ## 1130  02336300 2011-05-01 07:00:00     34.00            A       19.4
    ## 1131  02336313 2011-05-11 02:00:00      0.98            E       23.7
    ## 1132  02336526 2011-05-03 10:15:00      4.00            E       20.1
    ## 1133  02336300 2011-05-25 16:30:00     20.00            E       24.0
    ## 1134 021989773 2011-05-24 20:45:00  39800.00          A e       26.1
    ## 1135  02203700 2011-05-25 05:00:00      3.50            A       22.8
    ## 1136  02336728 2011-05-29 03:15:00     24.00            A       22.0
    ## 1137  02336410 2011-05-06 00:15:00     28.00            A       17.5
    ## 1138  02336240 2011-05-01 21:30:00     13.00            X       21.7
    ## 1139  02203700 2011-05-09 19:30:00      5.10            X       24.3
    ## 1140  02336410 2011-05-23 16:30:00     13.00            X       22.5
    ## 1141  02337170 2011-05-13 04:45:00   4120.00            E       15.4
    ## 1142 021989773 2011-05-25 18:15:00 -62700.00          A e       26.2
    ## 1143  02336240 2011-05-12 09:15:00     11.00            A       21.1
    ## 1144  02336240 2011-05-22 07:15:00      8.50            A       20.3
    ## 1145  02336313 2011-05-09 18:45:00      1.00            E       23.5
    ## 1146  02337170 2011-05-30 14:30:00   1350.00            A       22.6
    ## 1147  02336313 2011-05-23 00:45:00      0.93          A e       24.3
    ## 1148  02336526 2011-05-26 10:30:00      3.00            A       22.7
    ## 1149  02203700 2011-05-13 03:15:00      4.60            X       23.4
    ## 1150  02203655 2011-05-30 11:30:00     10.00            A       22.5
    ## 1151 021989773 2011-05-26 20:00:00 -48100.00            A       26.6
    ## 1152  02336410 2011-05-02 13:30:00     21.00            X       19.4
    ## 1153  02203655 2011-05-01 05:15:00     12.00            E       19.6
    ## 1154  02336313 2011-05-11 11:00:00      1.00          A e       20.3
    ## 1155  02336360 2011-05-25 13:15:00      8.70            X       21.4
    ## 1156  02203700 2011-05-09 16:45:00      5.10            A       21.7
    ## 1157  02336300 2011-05-19 22:00:00     24.00            A       21.1
    ## 1158  02336120 2011-05-01 21:30:00     17.00            E         NA
    ## 1159  02203700 2011-05-22 05:30:00      3.90            X       21.5
    ## 1160  02336526 2011-05-13 11:00:00      3.60          A e       21.1
    ## 1161  02336360 2011-05-05 23:45:00     15.00            A       17.8
    ## 1162  02336300 2011-05-14 08:00:00     27.00            A       21.6
    ## 1163  02337170 2011-05-31 05:30:00   1270.00            X       24.9
    ## 1164  02203655 2011-05-04 23:30:00     20.00          A e       19.0
    ## 1165  02203655 2011-05-20 19:30:00      8.80            E       19.6
    ## 1166  02337170 2011-05-05 03:45:00   6420.00            A       14.3
    ## 1167  02203655 2011-05-27 06:45:00     86.00            A       20.9
    ## 1168  02337170 2011-05-25 05:15:00   2230.00            A       21.0
    ## 1169  02336120 2011-05-03 10:15:00     16.00            A       19.8
    ## 1170  02336728 2011-05-27 13:00:00    523.00          A e       19.7
    ## 1171  02336300 2011-05-22 18:30:00     23.00            X       25.0
    ## 1172  02336526 2011-05-31 05:00:00      6.90            A       25.0
    ## 1173  02336120 2011-05-04 23:00:00     39.00            A       18.5
    ## 1174  02203700 2011-05-12 09:00:00      4.40            E       20.9
    ## 1175  02336240 2011-05-02 18:00:00     13.00            A       21.8
    ## 1176  02336410 2011-05-04 13:45:00     95.00            A       16.7
    ## 1177  02336728 2011-05-25 18:45:00      9.70            A       25.1
    ## 1178  02336410 2011-05-17 08:30:00     16.00            X       16.2
    ## 1179  02336410 2011-05-01 19:15:00     22.00            E       21.4
    ## 1180  02336300 2011-05-25 13:45:00     20.00          A e       22.2
    ## 1181 021989773 2011-05-14 21:00:00 -81900.00            A       24.3
    ## 1182  02336120 2011-05-14 17:15:00     13.00          A e       21.3
    ## 1183  02203700 2011-05-27 02:30:00     64.00            A       21.9
    ## 1184  02336300 2011-05-10 03:45:00     31.00            A       21.6
    ## 1185  02336728 2011-05-22 13:30:00      9.30            E       19.8
    ## 1186  02336526 2011-05-02 20:45:00      4.20            E       23.1
    ## 1187  02203655 2011-05-31 15:30:00      9.60            A       22.6
    ## 1188  02336410 2011-05-26 20:45:00     10.00            X       25.2
    ## 1189  02336120 2011-05-06 15:30:00     19.00            A       15.3
    ## 1190  02336120 2011-05-30 01:15:00     16.00            E       25.4
    ## 1191  02336728 2011-05-19 23:15:00     11.00            X       19.6
    ## 1192  02337170 2011-05-08 18:30:00   1430.00            A       17.0
    ## 1193 021989773 2011-05-19 09:30:00  35000.00            A       23.0
    ## 1194  02336410 2011-05-01 09:15:00     22.00            X       18.7
    ## 1195  02336300 2011-05-09 15:00:00     32.00            A       19.7
    ## 1196  02336120 2011-05-09 02:30:00     16.00            A       19.8
    ## 1197  02336240 2011-05-23 21:15:00      8.50            A       24.9
    ## 1198  02337170 2011-05-09 18:15:00   1350.00            A       19.4
    ## 1199 021989773 2011-05-21 04:00:00 -51600.00            E         NA
    ## 1200  02337170 2011-05-14 04:15:00   4920.00            A       14.4
    ## 1201  02336120 2011-06-01 02:45:00     12.00            A       25.9
    ## 1202  02336120 2011-05-16 19:45:00     13.00          A e       17.8
    ## 1203  02336313 2011-05-29 06:00:00      0.82            A       22.1
    ## 1204  02336300 2011-05-18 19:15:00     27.00            A       17.9
    ## 1205  02336410 2011-05-10 10:30:00     19.00            A       20.6
    ## 1206  02336728 2011-05-24 14:45:00      8.90            A         NA
    ## 1207  02336120 2011-05-12 03:30:00     14.00            A       23.4
    ## 1208  02203655 2011-05-18 21:00:00      8.80            E       16.1
    ## 1209  02336526 2011-05-14 14:15:00      3.60            A       20.5
    ## 1210  02336360 2011-05-05 04:15:00     20.00            A       17.6
    ## 1211  02336313 2011-05-13 20:30:00      1.00            A       24.5
    ## 1212  02336410 2011-05-09 17:30:00     20.00            A       21.0
    ## 1213  02336410 2011-05-21 12:30:00     14.00            E       19.0
    ## 1214 021989773 2011-05-19 05:30:00  84500.00            A       23.1
    ## 1215  02336300 2011-05-19 09:15:00     26.00          A e       15.5
    ## 1216  02336526 2011-05-08 20:45:00      4.60            A       21.7
    ## 1217  02336410 2011-05-11 10:30:00     19.00            A       21.7
    ## 1218  02336313 2011-05-16 15:15:00      1.10            A       16.5
    ## 1219  02203655 2011-05-05 21:45:00     13.00            A       17.2
    ## 1220  02336410 2011-05-11 21:15:00     17.00            X       25.0
    ## 1221 021989773 2011-05-30 09:45:00 -46600.00            E       26.7
    ## 1222  02336300 2011-05-03 05:15:00     31.00            A       21.2
    ## 1223  02336526 2011-05-15 12:15:00      3.60          A e       18.8
    ## 1224  02336526 2011-05-10 03:00:00      4.00            X       23.2
    ## 1225  02336526 2011-05-07 16:45:00      4.80            E       16.9
    ## 1226  02336240 2011-05-13 00:45:00     11.00            A       23.9
    ## 1227  02336526 2011-05-23 19:15:00      3.50            A       24.1
    ## 1228  02337170 2011-05-24 08:45:00   1720.00            A       20.1
    ## 1229  02336240 2011-05-05 19:00:00     15.00            E       17.6
    ## 1230  02203700 2011-05-22 04:45:00      3.90            A       21.8
    ## 1231  02336300 2011-05-03 13:30:00     30.00            E       20.0
    ## 1232  02337170 2011-05-19 04:15:00   3870.00            A         NA
    ## 1233  02336410 2011-05-29 14:15:00     18.00            A       22.1
    ## 1234  02336410 2011-05-25 23:15:00     11.00            A       25.3
    ## 1235  02337170 2011-05-29 12:15:00   1710.00            A       21.2
    ## 1236  02336410 2011-05-02 00:00:00     22.00            A       21.0
    ## 1237  02336526 2011-05-27 09:00:00   2250.00          A e       19.4
    ## 1238  02337170 2011-06-01 03:45:00   1260.00          A e       26.1
    ## 1239  02336728 2011-05-24 09:30:00      8.90            E       20.8
    ## 1240  02336120 2011-05-08 12:30:00     17.00            A       16.9
    ## 1241  02336410 2011-05-16 13:30:00     15.00            A       16.8
    ## 1242  02336120 2011-05-27 12:30:00    900.00            A       20.4
    ## 1243  02337170 2011-05-07 06:45:00   5920.00            X       14.0
    ## 1244  02336300 2011-05-12 15:00:00     27.00            X       22.5
    ## 1245  02336240 2011-05-09 07:45:00     12.00            A       18.5
    ## 1246  02336360 2011-05-15 08:45:00     11.00            A         NA
    ## 1247  02336728 2011-05-23 09:30:00      8.90            X       20.5
    ## 1248  02336410 2011-05-13 18:15:00     16.00            A       23.7
    ## 1249 021989773 2011-05-10 04:00:00 -70600.00          A e       22.8
    ## 1250  02203655 2011-05-27 22:15:00     60.00            A       22.4
    ## 1251  02336360 2011-05-01 22:15:00     14.00            A       21.7
    ## 1252 021989773 2011-05-11 20:00:00 -45000.00            X       23.7
    ## 1253  02336300 2011-05-14 19:45:00     27.00          A e       23.5
    ## 1254  02336410 2011-05-31 16:15:00     12.00          A e       24.5
    ## 1255 021989773 2011-05-20 05:45:00  72400.00            E       23.2
    ## 1256  02336728 2011-05-30 02:30:00     17.00            A       23.1
    ## 1257  02336313 2011-05-06 20:00:00      1.20            E       19.6
    ## 1258  02336728 2011-05-23 11:30:00      8.90            E       20.3
    ## 1259  02336410 2011-05-20 22:45:00     14.00            E       21.6
    ## 1260  02336526 2011-05-28 23:15:00      7.40            X         NA
    ## 1261  02336313 2011-05-23 11:30:00      0.93            A       20.2
    ## 1262  02336728 2011-05-05 02:45:00     29.00            A       17.4
    ## 1263  02336313 2011-05-30 23:30:00      0.69            E       26.2
    ## 1264  02336240 2011-05-21 18:45:00      9.20          A e       23.4
    ## 1265 021989773 2011-05-27 01:30:00  39100.00            E       26.2
    ## 1266  02336240 2011-05-24 20:00:00      8.20            A       26.0
    ## 1267  02336360 2011-05-10 01:00:00     12.00            A       22.1
    ## 1268 021989773 2011-05-13 00:45:00  74600.00            X       24.0
    ## 1269  02336526 2011-05-06 21:45:00      5.00            E       19.9
    ## 1270  02336728 2011-05-22 13:00:00      9.30            A       19.6
    ## 1271  02336240 2011-05-11 14:00:00     11.00            A       20.9
    ## 1272  02336120 2011-05-26 02:15:00     11.00            X       24.8
    ## 1273 021989773 2011-05-01 14:15:00  72300.00            X       23.5
    ## 1274  02336240 2011-05-20 13:15:00      9.50            A       16.4
    ## 1275  02336313 2011-05-14 03:30:00      0.93            A       22.4
    ## 1276  02336313 2011-05-20 18:45:00      1.00            E       21.9
    ## 1277 021989773 2011-05-04 00:30:00 -60300.00            E       24.1
    ## 1278  02336728 2011-05-26 04:00:00      8.20          A e       23.1
    ## 1279  02203700 2011-05-14 04:15:00      4.40            A       21.8
    ## 1280 021989773 2011-05-26 09:30:00  13200.00            A       25.5
    ## 1281  02203700 2011-05-09 22:00:00      4.90            A       24.7
    ## 1282  02336300 2011-05-22 21:45:00     22.00          A e         NA
    ## 1283  02336526 2011-05-28 05:00:00        NA            A       21.6
    ## 1284  02336120 2011-05-13 20:15:00     13.00            X       23.8
    ## 1285  02336410 2011-05-23 10:45:00     14.00            A       21.6
    ## 1286  02336120 2011-05-03 00:15:00     16.00          A e       21.9
    ## 1287  02336526 2011-05-04 21:00:00      8.90            A         NA
    ## 1288 021989773 2011-05-16 11:45:00 -53600.00            X       24.1
    ## 1289  02336240 2011-05-05 15:15:00     15.00            A       14.9
    ## 1290  02336526 2011-05-20 15:00:00      3.60            E       17.3
    ## 1291  02336313 2011-05-22 17:15:00      1.10            A       23.9
    ## 1292  02336313 2011-05-17 15:00:00      1.00            X       15.5
    ## 1293  02336360 2011-05-15 17:30:00     10.00            A       19.4
    ## 1294  02336313 2011-05-31 23:30:00      0.65            A       26.6
    ## 1295  02203655 2011-05-21 11:15:00      8.20            X       18.7
    ## 1296  02336410 2011-05-12 02:45:00     17.00            X       23.6
    ## 1297  02336526 2011-05-12 11:15:00      3.80            A       21.2
    ## 1298  02336313 2011-05-30 17:00:00      0.73            A       25.4
    ## 1299  02336240 2011-05-18 01:15:00        NA            E       15.4
    ## 1300  02337170 2011-05-08 12:00:00   1580.00            A       15.4
    ## 1301  02336410 2011-05-08 01:45:00     22.00            E       18.8
    ## 1302  02203700 2011-05-19 08:00:00      4.20          A e       14.9
    ## 1303  02336410 2011-05-01 07:45:00     22.00            A         NA
    ## 1304  02336240 2011-05-18 10:15:00     11.00            X       13.7
    ## 1305  02336120 2011-05-01 12:00:00     18.00            X       18.1
    ## 1306  02203700 2011-05-12 05:00:00      4.90            X       22.8
    ## 1307  02336240 2011-05-01 20:45:00     13.00          A e       21.9
    ## 1308  02336120 2011-05-06 18:30:00     19.00            A       17.3
    ## 1309  02203700 2011-05-14 21:30:00      4.40            E       23.5
    ## 1310  02336526 2011-05-04 02:45:00    411.00            X       17.8
    ## 1311  02336120 2011-05-06 15:15:00     19.00            X       15.2
    ## 1312  02336120 2011-05-06 09:15:00     19.00            A       15.5
    ## 1313 021989773 2011-05-15 08:00:00 -57800.00          A e       24.0
    ## 1314  02336313 2011-05-13 15:45:00      1.00            A       22.7
    ## 1315  02336410 2011-05-31 21:30:00     11.00            X       27.1
    ## 1316  02336300 2011-05-11 19:30:00     29.00            A       25.6
    ## 1317  02336240 2011-05-22 14:45:00      8.90            A       20.5
    ## 1318  02336120 2011-05-15 09:00:00     13.00            A       19.4
    ## 1319 021989773 2011-05-18 11:30:00 -81000.00            A       23.1
    ## 1320  02336300 2011-05-16 16:00:00     27.00            X       17.0
    ## 1321  02336728 2011-05-29 06:00:00     22.00          A e       21.9
    ## 1322  02203700 2011-05-23 10:00:00      3.90            A       20.5
    ## 1323  02203700 2011-05-15 13:00:00      4.20            X       17.9
    ## 1324  02336240 2011-05-29 17:00:00     14.00            X       23.8
    ## 1325  02336728 2011-05-16 06:30:00     11.00            X       17.1
    ## 1326  02203700 2011-05-25 11:45:00      3.70            X       20.1
    ## 1327  02336728 2011-05-14 00:00:00     12.00            A       22.8
    ## 1328  02203655 2011-05-30 06:15:00     10.00            A       24.0
    ## 1329  02336240 2011-05-15 18:00:00     10.00          A e       19.3
    ## 1330  02336240 2011-05-14 06:30:00     11.00            A       21.2
    ## 1331  02336360 2011-05-18 17:15:00     10.00            X       15.9
    ## 1332  02336410 2011-05-20 20:45:00     14.00            A       21.9
    ## 1333  02203655 2011-05-06 14:00:00     12.00          A e       14.6
    ## 1334  02336240 2011-05-04 07:15:00    222.00            A       17.1
    ## 1335  02336410 2011-05-04 00:15:00    134.00          A e       19.7
    ## 1336  02336526 2011-05-07 15:30:00      4.80            X       15.8
    ## 1337  02337170 2011-05-17 19:30:00   2910.00          A e       15.3
    ## 1338  02336313 2011-05-20 15:45:00      1.20            A       19.9
    ## 1339  02336526 2011-05-08 01:45:00      4.80            A       20.3
    ## 1340  02203655 2011-05-02 01:15:00     11.00          A e       21.0
    ## 1341  02336120 2011-05-11 09:45:00     15.00            X         NA
    ## 1342  02336300 2011-05-08 22:15:00     31.00            A       21.3
    ## 1343  02203655 2011-05-19 16:15:00      9.20            E       15.7
    ## 1344  02336300 2011-05-20 12:30:00     26.00          A e       17.2
    ## 1345  02336313 2011-05-31 14:15:00      0.77            A       22.9
    ## 1346  02203700 2011-05-02 05:45:00      6.10            X       19.9
    ## 1347  02203700 2011-05-06 01:30:00      5.60            A       18.6
    ## 1348  02336313 2011-05-17 02:00:00      1.20            E       16.9
    ## 1349  02203655 2011-05-01 18:30:00     11.00          A e       19.7
    ## 1350  02336728 2011-05-02 18:00:00     16.00            E       22.0
    ## 1351  02336120 2011-05-06 20:30:00     19.00            A       18.6
    ## 1352  02203655 2011-05-02 14:00:00     11.00            E       18.6
    ## 1353 021989773 2011-05-02 22:15:00 -82200.00            A       24.1
    ## 1354 021989773 2011-05-26 11:45:00  72800.00            E       25.3
    ## 1355  02336526 2011-05-02 01:30:00      4.20          A e       22.5
    ## 1356  02337170 2011-05-18 10:30:00   3000.00            E       12.9
    ## 1357  02336360 2011-05-17 08:00:00     11.00            A       16.1
    ## 1358  02203700 2011-05-13 20:30:00      4.40            A       25.0
    ## 1359  02336526 2011-05-31 17:15:00      4.60            A       24.7
    ## 1360  02336300 2011-05-09 02:00:00     32.00            A       20.3
    ## 1361 021989773 2011-05-10 14:00:00 -19700.00            A       22.9
    ## 1362  02336526 2011-05-16 16:45:00      3.80            E       16.7
    ## 1363  02336300 2011-05-20 10:45:00     26.00            E       17.4
    ## 1364  02336360 2011-05-01 13:45:00     14.00            E       17.8
    ## 1365  02336360 2011-05-19 03:30:00     10.00            A       16.1
    ## 1366  02336360 2011-05-29 02:45:00      9.10          A e       23.8
    ## 1367  02336300 2011-05-15 16:15:00     26.00            X       19.4
    ## 1368  02336526 2011-05-27 21:30:00     21.00            X       23.6
    ## 1369  02336120 2011-05-16 21:00:00     13.00            A       17.8
    ## 1370  02336300 2011-05-01 19:15:00     32.00            A       22.3
    ## 1371  02336728 2011-05-24 19:00:00        NA            X       24.8
    ## 1372  02336526 2011-05-05 20:30:00      5.50            E       18.5
    ## 1373  02336728 2011-05-13 23:00:00     12.00          A e         NA
    ## 1374  02336410 2011-05-01 21:45:00        NA            A       21.4
    ## 1375  02336526 2011-05-21 10:00:00      3.50          A e       19.5
    ## 1376  02336526 2011-05-02 22:30:00      4.20            A       23.6
    ## 1377  02336360 2011-05-04 18:15:00     28.00            E         NA
    ## 1378  02336360 2011-05-09 13:45:00     12.00            A       18.4
    ## 1379  02203655 2011-05-26 06:30:00      6.80          A e       23.2
    ## 1380  02336410 2011-05-13 21:00:00     16.00          A e       24.0
    ## 1381  02336240 2011-05-29 18:45:00     14.00            A       25.3
    ## 1382  02336728 2011-05-03 03:30:00     15.00            A       20.3
    ## 1383  02336313 2011-05-21 23:30:00      0.93            A       23.4
    ## 1384  02336313 2011-05-18 21:30:00      1.00            A       18.3
    ## 1385  02203700 2011-05-23 15:00:00      3.70            A       21.3
    ## 1386  02336120 2011-05-29 00:15:00     23.00            A       24.4
    ## 1387 021989773 2011-05-25 19:00:00 -49000.00            A       25.7
    ## 1388  02337170 2011-05-07 17:00:00   4120.00            X       14.0
    ## 1389 021989773 2011-05-15 01:45:00  92100.00            X       24.2
    ## 1390  02337170 2011-05-20 14:15:00        NA            A       14.7
    ## 1391  02336410 2011-05-19 07:30:00     16.00            A       15.4
    ## 1392  02336300 2011-05-20 21:15:00     25.00            A         NA
    ## 1393  02336313 2011-05-11 23:15:00      0.93            A       25.0
    ## 1394 021989773 2011-05-23 12:45:00  10700.00          A e       24.4
    ## 1395  02336240 2011-05-01 23:15:00     13.00            A       21.1
    ## 1396  02336360 2011-05-15 10:00:00     11.00          A e       19.5
    ## 1397  02336300 2011-05-08 12:30:00     33.00            A       16.8
    ## 1398  02336120 2011-05-08 01:15:00     17.00            X       19.1
    ## 1399  02336526 2011-05-07 11:00:00      4.80          A e         NA
    ## 1400  02337170 2011-05-15 16:30:00   2200.00            A       15.6
    ## 1401  02336360 2011-05-10 01:15:00     12.00            A       22.0
    ## 1402  02203700 2011-05-15 02:45:00      4.40            A       21.2
    ## 1403  02203700 2011-05-19 16:15:00      4.00            X       17.1
    ## 1404  02336240 2011-05-05 12:15:00     16.00            E       14.0
    ## 1405 021989773 2011-05-13 19:30:00 -81000.00          A e       24.7
    ## 1406  02336313 2011-05-24 02:45:00      0.87            A         NA
    ## 1407  02337170 2011-05-30 23:45:00   1270.00          A e       25.6
    ## 1408  02336526 2011-05-20 18:45:00      3.60            A       20.6
    ## 1409  02336526 2011-05-21 10:30:00      3.50            A       19.4
    ## 1410  02337170 2011-05-10 01:00:00   1350.00            A       21.6
    ## 1411  02203700 2011-05-11 05:30:00      4.90            E       22.2
    ## 1412  02336300 2011-05-03 11:45:00     31.00            A       20.0
    ## 1413  02336526 2011-05-29 16:30:00      5.90          A e       22.4
    ## 1414  02336410 2011-05-27 13:30:00    288.00            A       21.4
    ## 1415  02336410 2011-05-11 15:15:00     17.00            A       21.9
    ## 1416  02337170 2011-05-08 17:00:00   1440.00            X       16.4
    ## 1417  02336526 2011-05-04 02:15:00    427.00          A e       18.4
    ## 1418  02336360 2011-05-06 18:30:00     14.00            E       18.1
    ## 1419  02336120 2011-05-19 23:00:00     12.00            A       19.8
    ## 1420  02336360 2011-05-19 12:45:00     10.00            A       14.6
    ## 1421  02336240 2011-05-22 02:45:00        NA            X       21.6
    ## 1422  02203700 2011-05-22 07:45:00      3.90            A       20.6
    ## 1423 021989773 2011-05-08 00:30:00 -65600.00            A       22.7
    ## 1424  02336728 2011-05-01 11:15:00     16.00            E       18.3
    ## 1425  02203655 2011-05-26 07:15:00      6.80            A       23.1
    ## 1426  02336313 2011-05-07 19:15:00      1.00            E       20.6
    ## 1427  02336240 2011-05-22 17:45:00      9.20            E       24.0
    ## 1428  02336728 2011-05-13 06:30:00     12.00          A e       21.4
    ## 1429  02336313 2011-05-23 07:45:00      0.87            A       21.4
    ## 1430  02336313 2011-05-28 14:30:00      0.93            A       20.2
    ## 1431  02336240 2011-05-16 00:00:00     10.00            E       18.2
    ## 1432  02336728 2011-05-20 23:30:00     11.00          A e       22.3
    ## 1433  02203655 2011-05-05 15:30:00     14.00            X       14.8
    ## 1434  02336240 2011-05-03 01:15:00     13.00            A       21.0
    ## 1435  02336120 2011-05-05 03:30:00     32.00            A       17.0
    ## 1436  02337170 2011-05-10 02:45:00   1340.00          A e       21.6
    ## 1437  02336728 2011-05-25 21:45:00      9.30            A       26.0
    ## 1438  02336360 2011-05-07 21:45:00     13.00            E       19.7
    ## 1439  02337170 2011-05-18 20:30:00   4380.00          A e       13.6
    ## 1440  02336120 2011-05-26 14:15:00      8.90            X       22.5
    ## 1441  02336313 2011-05-23 01:15:00      0.87          A e       24.1
    ## 1442  02336240 2011-05-22 10:45:00      8.90            X       19.6
    ## 1443  02336526 2011-05-17 14:15:00      3.80            A       15.1
    ## 1444  02336728 2011-05-24 20:00:00      8.90            A       25.3
    ## 1445  02336526 2011-05-07 00:15:00      4.80          A e       19.9
    ## 1446  02336360 2011-05-30 07:30:00      6.90            X       23.8
    ## 1447  02336360 2011-05-02 01:45:00     14.00            A       20.9
    ## 1448  02203700 2011-05-03 21:15:00      6.70            X       22.2
    ## 1449  02336120 2011-05-11 06:00:00     15.00            X       22.0
    ## 1450  02336300 2011-05-14 04:00:00     27.00            A       22.4
    ## 1451  02336410 2011-05-04 01:45:00    176.00            A       19.2
    ## 1452  02336240 2011-05-30 03:00:00     12.00            A       23.6
    ## 1453  02336410 2011-05-04 20:00:00     59.00            A       18.7
    ## 1454  02336120 2011-05-18 04:15:00     14.00            X       15.3
    ## 1455  02203700 2011-05-02 19:00:00      6.10            A       23.2
    ## 1456  02336360 2011-05-29 15:30:00        NA          A e       22.6
    ## 1457  02336360 2011-05-18 20:30:00     10.00            A       17.7
    ## 1458  02336300 2011-05-20 20:00:00     24.00            X       22.8
    ## 1459 021989773 2011-05-10 22:30:00  48300.00            A       23.6
    ## 1460  02203700 2011-05-08 12:00:00      4.90            X       16.0
    ## 1461 021989773 2011-05-19 12:30:00 -72500.00            E       23.0
    ## 1462  02336120 2011-05-29 17:00:00        NA            A       23.1
    ## 1463  02336300 2011-05-16 20:15:00     29.00          A e       18.8
    ## 1464  02336300 2011-05-20 06:15:00     26.00            A       18.2
    ## 1465  02336120 2011-05-03 09:45:00     16.00            A       19.9
    ## 1466  02203655 2011-05-22 20:15:00      8.20          A e       22.5
    ## 1467 021989773 2011-05-17 12:00:00 -56100.00            A       23.5
    ## 1468  02336360 2011-05-17 04:45:00     11.00          A e       16.5
    ## 1469  02336120 2011-05-29 04:00:00     21.00          A e       23.1
    ## 1470  02336360 2011-05-28 06:15:00     15.00            A       22.2
    ## 1471  02336300 2011-05-18 12:15:00     27.00            E       14.0
    ## 1472  02336120 2011-05-31 22:15:00     12.00            A       27.2
    ## 1473  02336240 2011-05-30 11:30:00     12.00            A       22.2
    ## 1474  02336526 2011-05-02 10:30:00      4.20            X       19.3
    ## 1475  02337170 2011-05-04 00:00:00   6350.00            X         NA
    ## 1476 021989773 2011-05-05 09:30:00  -4820.00            A       22.9
    ## 1477  02336410 2011-05-18 08:00:00     16.00            A       14.7
    ## 1478  02336300 2011-05-17 17:45:00     29.00          A e       16.6
    ## 1479 021989773 2011-05-22 06:00:00   7220.00            X       24.1
    ## 1480  02336526 2011-05-10 15:45:00      4.20            X       20.7
    ## 1481  02203655 2011-05-07 04:00:00     12.00            A       17.9
    ## 1482 021989773 2011-05-23 21:00:00  77100.00            A       25.8
    ## 1483  02337170 2011-05-29 00:30:00   2580.00          A e       21.7
    ## 1484  02203655 2011-05-22 21:15:00      8.20          A e       22.6
    ## 1485  02336120 2011-05-19 14:45:00     12.00            A       15.4
    ## 1486  02336526 2011-05-26 14:30:00      2.80            A         NA
    ## 1487  02336360 2011-05-08 17:30:00     13.00          A e       18.8
    ## 1488  02336240 2011-05-27 06:00:00    247.00            E       21.1
    ## 1489  02203700 2011-05-05 14:30:00     21.00            A       16.9
    ## 1490  02336526 2011-05-20 18:00:00      3.60            E       19.8
    ## 1491  02336313 2011-05-13 07:45:00      0.98            X       21.4
    ## 1492  02336360 2011-05-22 20:00:00      9.80            E       25.3
    ## 1493  02203700 2011-05-17 15:45:00      4.90            A       15.7
    ## 1494  02337170 2011-05-06 15:00:00   7790.00            X       11.9
    ## 1495  02336526 2011-05-30 06:45:00      5.90            E       24.1
    ## 1496  02203700 2011-05-22 09:15:00        NA          A e       20.0
    ## 1497  02336300 2011-05-20 22:00:00     25.00          A e       23.4
    ## 1498  02336300 2011-05-14 17:00:00     26.00            A       21.8
    ## 1499  02336410 2011-05-02 07:45:00        NA            A       20.2
    ## 1500 021989773 2011-05-10 23:30:00  58700.00            A       23.3
    ## 1501  02336313 2011-05-05 11:45:00      1.30            E       13.1
    ## 1502  02337170 2011-05-13 20:15:00   6100.00            X       16.8
    ## 1503  02203700 2011-05-17 13:00:00      4.20            E       14.7
    ## 1504  02336120 2011-05-23 22:15:00     11.00            A       24.8
    ## 1505  02336240 2011-05-10 04:45:00     11.00            A       20.5
    ## 1506  02336240 2011-05-23 05:15:00      8.20            E       22.1
    ## 1507  02336526 2011-05-12 12:15:00      3.80            A       21.0
    ## 1508  02336360 2011-05-24 03:15:00      9.40            A       23.1
    ## 1509  02336240 2011-05-27 05:00:00        NA            X       21.5
    ## 1510  02337170 2011-05-31 09:15:00   1270.00            A       24.4
    ## 1511  02336360 2011-05-06 01:30:00     15.00            A       17.4
    ## 1512  02336300 2011-05-16 18:15:00     25.00            A       17.6
    ## 1513  02336360 2011-05-04 22:15:00     24.00            E       19.3
    ## 1514  02337170 2011-05-24 08:00:00   1710.00            E       20.1
    ## 1515  02336300 2011-05-24 12:45:00     21.00            A       21.9
    ## 1516  02336313 2011-05-24 09:30:00      0.93            A       21.1
    ## 1517  02337170 2011-05-16 12:30:00   1400.00            A       16.1
    ## 1518  02336728 2011-05-03 23:30:00     62.00            A       20.0
    ## 1519  02337170 2011-05-27 05:30:00   2070.00            A       20.6
    ## 1520  02336410 2011-05-18 11:30:00     16.00            A       14.0
    ## 1521  02336120 2011-05-15 20:15:00     13.00            X       19.1
    ## 1522  02336120 2011-05-14 07:30:00     13.00            A       21.4
    ## 1523  02336526 2011-05-27 22:15:00     19.00            A       23.6
    ## 1524  02336410 2011-05-24 08:45:00        NA            A       22.2
    ## 1525  02336313 2011-05-12 09:45:00      1.00            E       20.9
    ## 1526  02336526 2011-05-08 19:45:00      4.60            E       21.3
    ## 1527  02336410 2011-05-03 03:30:00     21.00          A e       21.4
    ## 1528  02336313 2011-05-24 04:15:00      0.87            X       22.9
    ## 1529  02336313 2011-05-28 10:45:00      0.98            E       19.9
    ## 1530  02203700 2011-05-09 00:00:00      5.10          A e       21.8
    ## 1531  02336120 2011-05-07 23:45:00     17.00            E       19.5
    ## 1532  02336120 2011-05-31 13:30:00     12.00            A       23.3
    ## 1533  02336120 2011-05-30 17:15:00     14.00            A       24.4
    ## 1534 021989773 2011-05-31 13:30:00  29000.00            A       27.1
    ## 1535  02203700 2011-05-17 20:15:00      4.60          A e       17.0
    ## 1536  02336313 2011-05-01 19:45:00      1.00            A       22.6
    ## 1537  02336313 2011-05-01 23:45:00      1.00            A       22.3
    ## 1538  02336300 2011-05-22 20:45:00     22.00          A e       26.5
    ## 1539  02336526 2011-05-17 19:00:00      3.80            A       16.5
    ## 1540  02336360 2011-05-17 12:45:00        NA            A       15.2
    ## 1541  02336240 2011-05-08 07:15:00     12.00            A       16.9
    ## 1542  02336360 2011-05-02 23:45:00     14.00            X       22.0
    ## 1543  02336300 2011-05-01 14:45:00     33.00            X       18.7
    ## 1544  02203700 2011-05-16 02:00:00      4.40            E       17.9
    ## 1545  02336120 2011-05-19 02:15:00     13.00            A       16.9
    ## 1546  02337170 2011-05-15 03:45:00   4440.00            A       14.4
    ## 1547  02336313 2011-05-08 06:15:00      1.10            X       17.3
    ## 1548  02336313 2011-05-20 23:30:00      0.98            A       22.2
    ## 1549  02203655 2011-05-23 23:45:00      8.50            A       23.0
    ## 1550  02337170 2011-05-05 01:30:00   6980.00            X       14.6
    ## 1551  02336410 2011-05-21 20:30:00     14.00          A e       23.5
    ## 1552  02203655 2011-05-01 04:30:00     11.00            E         NA
    ## 1553  02336300 2011-05-15 13:30:00     26.00            A       19.0
    ## 1554  02336313 2011-05-19 15:00:00      1.00            A       16.6
    ## 1555 021989773 2011-05-04 08:15:00  28600.00            A       23.5
    ## 1556 021989773 2011-05-28 20:30:00 -69500.00          A e       26.6
    ## 1557  02336120 2011-05-10 22:30:00     16.00          A e       24.1
    ## 1558  02336410 2011-05-14 05:30:00     16.00            A       22.0
    ## 1559  02203655 2011-05-21 04:00:00      8.20            A       20.5
    ## 1560  02203700 2011-05-03 16:45:00      6.10            A       22.1
    ## 1561  02336360 2011-05-11 09:00:00     12.00            E       21.7
    ## 1562  02336526 2011-05-04 10:30:00     23.00            A       15.4
    ## 1563  02336728 2011-05-23 14:15:00      8.90            E       21.0
    ## 1564 021989773 2011-05-23 08:00:00  72900.00            A       24.5
    ## 1565  02337170 2011-05-20 18:30:00   2770.00            A       16.3
    ## 1566  02203655 2011-05-25 13:00:00      7.20            A       20.9
    ## 1567  02336120 2011-05-20 23:30:00     12.00            X       21.8
    ## 1568  02336120 2011-05-25 17:30:00     10.00            A       23.1
    ## 1569  02336728 2011-05-22 23:00:00      9.70            A       25.3
    ## 1570  02336526 2011-05-08 03:30:00      4.80            A       19.5
    ## 1571  02336300 2011-05-01 11:30:00     32.00            A       18.1
    ## 1572  02336526 2011-05-23 06:45:00      3.80            A       22.8
    ## 1573  02336526 2011-05-29 02:30:00      6.90            A       24.2
    ## 1574 021989773 2011-05-30 13:45:00        NA            A       26.8
    ## 1575  02336120 2011-05-15 00:00:00     13.00          A e       22.3
    ## 1576 021989773 2011-05-09 19:45:00  56500.00            E       23.5
    ## 1577  02336120 2011-05-25 17:00:00     11.00            A       22.8
    ## 1578  02336410 2011-05-10 06:00:00     19.00            X       21.2
    ## 1579  02336240 2011-05-29 10:15:00     14.00            X       21.0
    ## 1580  02337170 2011-05-30 00:00:00   1450.00            A       24.0
    ## 1581  02336728 2011-05-20 12:45:00     10.00            E       16.5
    ## 1582  02336240 2011-05-24 05:45:00      8.20            A       22.2
    ## 1583  02336526 2011-05-16 01:45:00      3.80            A       18.3
    ## 1584  02336728 2011-05-03 17:45:00     16.00          A e       22.8
    ## 1585  02336360 2011-05-05 10:30:00     18.00            E       15.4
    ## 1586  02336300 2011-05-10 19:15:00     31.00            X       24.5
    ## 1587  02336728 2011-05-30 14:45:00     15.00            E       23.6
    ## 1588 021989773 2011-06-01 00:30:00 -28200.00            A       27.7
    ## 1589  02203655 2011-05-30 04:00:00     10.00            E       24.4
    ## 1590  02336300 2011-05-06 12:30:00     40.00            E       14.5
    ## 1591  02336120 2011-05-14 19:00:00        NA            A       21.9
    ## 1592  02336526 2011-05-02 05:45:00      4.00            A       20.9
    ## 1593  02336360 2011-05-29 18:45:00      8.10            A       25.2
    ## 1594  02336313 2011-05-09 18:30:00      1.00          A e       23.3
    ## 1595  02336300 2011-05-08 10:45:00     32.00            X       17.0
    ## 1596  02336120 2011-05-28 09:45:00        NA            A       21.3
    ## 1597  02336313 2011-05-28 06:15:00      1.10            A       20.9
    ## 1598 021989773 2011-05-25 14:30:00  -4490.00            A       25.5
    ## 1599  02336120 2011-05-04 15:30:00     69.00            A       16.7
    ## 1600  02336120 2011-05-31 07:45:00     12.00          A e       23.9
    ## 1601  02336240 2011-05-16 21:15:00     10.00            A       17.7
    ## 1602  02336120 2011-05-25 16:15:00     11.00            X       22.5
    ## 1603  02336360 2011-05-08 06:15:00     13.00            E       17.8
    ## 1604  02203655 2011-05-17 12:15:00      9.60            X       15.5
    ## 1605  02337170 2011-05-07 14:30:00   4920.00          A e       13.8
    ## 1606  02336360 2011-05-22 02:45:00      9.80            A       22.1
    ## 1607  02336313 2011-05-25 04:15:00      0.82            A         NA
    ## 1608  02336240 2011-05-14 23:00:00     10.00            E       22.1
    ## 1609  02336313 2011-05-09 14:45:00      1.00            A       19.9
    ## 1610  02336410 2011-05-16 21:30:00     16.00            A       18.2
    ## 1611  02336526 2011-05-27 18:00:00     30.00            A       21.6
    ## 1612  02336360 2011-05-30 06:45:00      7.50            A       23.9
    ## 1613  02336728 2011-05-21 02:30:00     10.00            A         NA
    ## 1614  02336728 2011-05-13 14:15:00     12.00            A       21.6
    ## 1615  02336120 2011-05-23 19:45:00     11.00            A       24.0
    ## 1616  02336313 2011-05-17 08:00:00        NA            E       15.4
    ## 1617  02203700 2011-05-06 21:15:00      5.30            E       21.3
    ## 1618  02336240 2011-05-03 13:00:00     12.00            X       19.3
    ## 1619  02336526 2011-05-24 23:15:00      3.30            A       25.4
    ## 1620  02336360 2011-05-13 15:30:00     11.00            E       21.7
    ## 1621  02336313 2011-05-06 06:00:00      1.20          A e       15.4
    ## 1622  02203700 2011-05-26 17:00:00      3.70            A       23.7
    ## 1623  02336360 2011-05-23 02:00:00      9.80            E       23.6
    ## 1624  02336410 2011-05-07 06:15:00     23.00            A       17.0
    ## 1625  02336240 2011-05-29 01:30:00     16.00            A         NA
    ## 1626  02336526 2011-05-14 08:45:00        NA            E       21.4
    ## 1627  02336526 2011-05-03 04:30:00      4.20            E       22.0
    ## 1628  02336360 2011-05-25 20:15:00      8.40            A       26.1
    ## 1629  02336300 2011-05-16 19:15:00     29.00            X       18.5
    ## 1630  02336240 2011-05-02 10:15:00     13.00            E       18.8
    ## 1631  02336360 2011-05-18 06:15:00     11.00          A e       14.8
    ## 1632  02337170 2011-05-27 01:00:00   1710.00          A e       21.3
    ## 1633  02337170 2011-05-31 22:15:00   1260.00            E       26.1
    ## 1634  02336120 2011-05-26 21:45:00     98.00            A       24.8
    ## 1635  02336410 2011-05-05 09:30:00     36.00            E       15.8
    ## 1636  02337170 2011-05-10 21:45:00   4300.00            A       20.9
    ## 1637  02336240 2011-05-31 23:30:00     10.00            A       25.8
    ## 1638  02336360 2011-05-27 03:15:00    265.00            A       22.4
    ## 1639  02336313 2011-05-01 15:30:00      1.00          A e       19.7
    ## 1640  02336360 2011-05-11 05:00:00     12.00          A e       22.6
    ## 1641  02336410 2011-05-03 08:00:00     21.00            X       20.7
    ## 1642  02336526 2011-05-04 21:30:00      8.60            A       20.2
    ## 1643  02336360 2011-05-21 09:15:00      9.80            A       19.3
    ## 1644  02336410 2011-05-15 02:00:00     16.00            X       21.5
    ## 1645  02203655 2011-05-04 14:00:00     39.00            E       15.9
    ## 1646  02336410 2011-05-25 03:45:00     12.00            X       23.4
    ## 1647  02336240 2011-05-18 16:45:00     11.00            X       16.3
    ## 1648  02336360 2011-05-05 12:00:00     18.00            A       14.9
    ## 1649  02336728 2011-05-03 07:30:00     15.00            A       19.9
    ## 1650  02336120 2011-05-17 04:45:00     13.00            E       16.7
    ## 1651 021989773 2011-05-11 15:45:00 -53700.00            E       23.4
    ## 1652  02336300 2011-05-10 00:15:00     33.00            X       22.8
    ## 1653  02336526 2011-05-05 06:00:00      6.40            A       15.8
    ## 1654  02336410 2011-05-20 10:30:00     15.00          A e       17.2
    ## 1655 021989773 2011-05-28 17:15:00  -9530.00            X       26.8
    ## 1656  02336300 2011-05-22 00:30:00     24.00            X       23.9
    ## 1657  02337170 2011-05-15 10:30:00   2490.00            A       15.0
    ## 1658 021989773 2011-05-05 13:15:00 -47600.00            X       23.4
    ## 1659  02336120 2011-05-16 06:45:00     13.00            A       17.4
    ## 1660  02336360 2011-05-17 11:00:00     11.00            E       15.5
    ## 1661 021989773 2011-05-16 20:00:00 -21600.00            E       23.9
    ## 1662  02336526 2011-05-08 09:45:00      4.60            A       16.8
    ## 1663  02336120 2011-05-26 19:15:00      8.90            E       24.2
    ## 1664 021989773 2011-05-14 20:15:00 -90800.00            A       24.2
    ## 1665  02336410 2011-05-12 10:15:00     17.00            E       22.0
    ## 1666  02336300 2011-05-19 13:00:00     26.00            A       15.2
    ## 1667  02336313 2011-05-15 08:15:00        NA          A e       19.0
    ## 1668  02337170 2011-05-07 01:30:00   6430.00            A       13.0
    ## 1669  02336120 2011-05-17 04:15:00     13.00            A       16.8
    ## 1670  02203655 2011-05-20 01:30:00      8.80            A       18.4
    ## 1671  02337170 2011-05-22 17:45:00   1550.00          A e       17.7
    ## 1672  02203655 2011-05-21 17:30:00      8.50            A       20.2
    ## 1673  02203700 2011-05-10 23:30:00      4.60            A       25.2
    ## 1674  02203700 2011-05-12 15:00:00      5.10          A e       21.7
    ## 1675  02336360 2011-05-17 19:15:00     10.00            A       16.5
    ## 1676 021989773 2011-05-20 01:30:00 -65200.00            E       23.4
    ## 1677 021989773 2011-05-26 06:15:00 -61100.00            E       25.4
    ## 1678  02337170 2011-05-02 12:45:00   2790.00          A e       15.6
    ## 1679  02337170 2011-05-14 05:15:00   4630.00            X       14.5
    ## 1680  02336313 2011-05-08 11:45:00      1.10            X       15.9
    ## 1681  02203655 2011-05-23 11:00:00      7.20            A       21.0
    ## 1682  02336728 2011-05-26 01:30:00      8.60            E       24.5
    ## 1683  02336313 2011-05-21 13:00:00      1.00            E       18.1
    ## 1684  02336240 2011-05-20 17:00:00      9.20          A e       19.8
    ## 1685  02336410 2011-05-11 13:00:00     18.00            X       21.4
    ## 1686  02203655 2011-05-26 11:15:00      6.80          A e       22.2
    ## 1687  02337170 2011-05-13 22:00:00   6390.00            X       15.7
    ## 1688  02336410 2011-05-11 18:15:00     17.00            A       24.2
    ## 1689  02336313 2011-05-22 16:45:00      1.10            A       23.5
    ## 1690  02336526 2011-05-14 02:00:00      3.60            X       23.3
    ## 1691 021989773 2011-05-04 09:30:00  -2060.00            A       23.3
    ## 1692  02336240 2011-05-15 16:30:00      9.90            A       19.2
    ## 1693  02203700 2011-05-04 02:00:00     67.00            A       19.9
    ## 1694  02336300 2011-05-11 23:45:00     29.00            E       25.2
    ## 1695 021989773 2011-05-18 20:00:00  42300.00            E       23.6
    ## 1696  02203700 2011-05-01 13:15:00      6.10            E       17.1
    ## 1697  02336410 2011-05-14 20:30:00     16.00            A       22.8
    ## 1698  02336410 2011-05-06 14:00:00     25.00            X       15.1
    ## 1699  02336120 2011-05-24 07:00:00     10.00            E       22.5
    ## 1700  02336300 2011-05-11 03:15:00     31.00            A       23.2
    ## 1701  02203655 2011-05-26 05:15:00      6.80            A       23.3
    ## 1702  02203655 2011-05-17 20:45:00      9.20            E       15.9
    ## 1703  02336410 2011-05-05 22:00:00     28.00            A       17.4
    ## 1704  02336526 2011-05-24 01:15:00      3.30            X       24.6
    ## 1705  02336313 2011-05-31 15:00:00      0.73            X       23.7
    ## 1706  02336313 2011-05-07 05:45:00      1.10            A       16.2
    ## 1707  02336120 2011-05-29 23:30:00     16.00          A e       25.8
    ## 1708  02203700 2011-05-05 23:15:00      5.60            A       19.8
    ## 1709  02336300 2011-05-13 02:00:00     28.00            X       24.3
    ## 1710  02203655 2011-05-31 00:45:00      9.20            E       24.7
    ## 1711  02336526 2011-05-24 20:15:00      3.00          A e       25.1
    ## 1712  02336410 2011-05-21 09:00:00     14.00            A       19.5
    ## 1713  02203700 2011-05-15 04:30:00      4.20            A       20.6
    ## 1714 021989773 2011-05-11 19:00:00 -59300.00            X       23.4
    ## 1715  02336410 2011-05-08 16:30:00     21.00            A       18.4
    ## 1716  02336410 2011-05-14 09:00:00     16.00            E       21.4
    ## 1717  02337170 2011-05-29 08:30:00   1940.00            X       21.4
    ## 1718  02336360 2011-05-22 22:00:00      9.80            X       25.2
    ## 1719  02336360 2011-05-23 03:15:00      9.80            A       23.2
    ## 1720  02337170 2011-05-13 15:15:00   2840.00            A       16.5
    ## 1721  02337170 2011-05-15 10:45:00   2460.00            A       15.0
    ## 1722  02336300 2011-05-01 21:00:00     32.00            A       22.8
    ## 1723  02336300 2011-05-09 10:15:00     31.00            A       18.9
    ## 1724  02336410 2011-05-31 14:30:00     12.00            E       23.7
    ## 1725  02336410 2011-05-03 18:00:00     20.00          A e       22.3
    ## 1726  02203700 2011-05-20 22:15:00      5.80            A       23.5
    ## 1727  02336360 2011-05-27 16:30:00     43.00          A e       21.4
    ## 1728  02336360 2011-05-28 12:00:00     12.00            A       21.2
    ## 1729  02336300 2011-05-10 14:15:00     30.00            A       20.6
    ## 1730  02336300 2011-05-21 05:00:00     25.00          A e       20.6
    ## 1731  02336240 2011-05-11 05:00:00     11.00            X       21.7
    ## 1732  02203700 2011-05-10 12:30:00      4.60            X       19.0
    ## 1733  02203700 2011-05-07 23:00:00      5.10            A         NA
    ## 1734  02336313 2011-05-31 02:45:00        NA            A       25.2
    ## 1735 021989773 2011-05-21 20:00:00  74500.00            X       24.4
    ## 1736  02336360 2011-05-28 07:30:00     14.00            A       21.9
    ## 1737  02336300 2011-05-17 17:15:00     28.00            A       16.6
    ## 1738  02336313 2011-05-24 04:00:00      0.87            X       23.0
    ## 1739  02336300 2011-05-09 16:15:00     32.00            A       20.6
    ## 1740  02203700 2011-05-26 09:45:00      3.70          A e       22.2
    ## 1741  02336313 2011-05-09 01:45:00      0.98          A e       20.8
    ## 1742  02203700 2011-05-14 00:15:00      4.20            E       23.6
    ## 1743  02336526 2011-05-07 03:45:00      4.80            A       18.2
    ## 1744 021989773 2011-05-03 17:15:00  53200.00            A       24.0
    ## 1745  02336120 2011-05-27 10:30:00   1030.00            E       21.0
    ## 1746  02336240 2011-05-21 10:15:00      9.20            A       18.3
    ## 1747 021989773 2011-05-29 21:15:00 -71700.00            E       27.0
    ## 1748  02336300 2011-05-24 23:30:00     20.00            A       26.1
    ## 1749  02336526 2011-05-31 11:30:00      4.80            X       22.6
    ## 1750  02203700 2011-05-18 05:45:00      4.20            A       14.9
    ## 1751  02336410 2011-05-20 20:15:00        NA            A       21.8
    ## 1752  02336410 2011-05-05 01:30:00     45.00            E       18.1
    ## 1753  02336728 2011-05-13 11:45:00     12.00          A e       20.9
    ## 1754  02337170 2011-05-26 21:30:00   1710.00            A       21.9
    ## 1755  02336120 2011-05-05 04:00:00     32.00            A       16.8
    ## 1756  02336526 2011-05-15 02:45:00      3.80            E       22.3
    ## 1757  02336360 2011-05-30 00:15:00      7.20            X       25.1
    ## 1758  02203700 2011-05-11 03:00:00      4.90            E       23.5
    ## 1759  02336526 2011-05-30 05:00:00      5.70            A       24.8
    ## 1760  02337170 2011-05-08 06:00:00   2020.00            X       15.4
    ## 1761  02336728 2011-05-22 10:00:00      9.30            X       19.5
    ## 1762  02336410 2011-05-22 12:45:00     14.00            A       20.5
    ## 1763  02336728 2011-05-20 19:15:00     10.00            A       22.1
    ## 1764  02336240 2011-05-02 12:30:00     13.00            E       18.6
    ## 1765  02203655 2011-05-01 08:45:00     12.00            A       18.3
    ## 1766  02336300 2011-05-02 13:15:00     31.00            E       19.3
    ## 1767 021989773 2011-05-26 09:15:00   7340.00            A       25.4
    ## 1768  02336526 2011-05-08 23:00:00      4.60          A e       22.2
    ## 1769 021989773 2011-05-08 09:15:00  61500.00          A e       22.2
    ## 1770  02336313 2011-05-18 09:00:00      1.00            A       13.9
    ## 1771 021989773 2011-05-19 13:00:00        NA            A       23.0
    ## 1772  02336240 2011-05-10 18:30:00     11.00            A       24.1
    ## 1773  02336120 2011-05-24 19:15:00     10.00            A       24.0
    ## 1774  02336240 2011-05-02 14:00:00     13.00            A       18.9
    ## 1775  02336728 2011-05-26 06:15:00      8.20            A       22.3
    ## 1776  02336360 2011-05-13 17:00:00     11.00            E       22.7
    ## 1777  02336728 2011-05-19 22:15:00     11.00            E       19.9
    ## 1778  02336526 2011-05-13 03:15:00      3.60            A       24.5
    ## 1779  02336240 2011-05-21 14:30:00      9.20            A       18.9
    ## 1780  02203655 2011-05-23 08:45:00      7.50            A       21.7
    ## 1781  02336120 2011-05-07 09:15:00     17.00            E       16.1
    ## 1782  02336240 2011-05-04 00:00:00        NA            A       19.8
    ## 1783  02336410 2011-05-09 05:30:00     21.00            A       19.7
    ## 1784  02336360 2011-05-23 06:00:00      9.40            X       22.5
    ## 1785  02336360 2011-05-02 12:45:00     14.00            X       19.0
    ## 1786 021989773 2011-05-15 15:15:00  91300.00            X       24.2
    ## 1787 021989773 2011-05-23 00:30:00  -2380.00            A       24.8
    ## 1788  02336410 2011-05-02 23:15:00     21.00            X       21.8
    ## 1789 021989773 2011-05-10 06:30:00 -26400.00            A       23.0
    ## 1790  02336120 2011-05-30 00:30:00     16.00            A       25.5
    ## 1791  02203700 2011-05-25 16:30:00      3.70            A       23.0
    ## 1792  02336120 2011-05-21 11:15:00     12.00            X       18.8
    ## 1793  02203700 2011-05-02 07:45:00      5.80            A       19.4
    ## 1794  02336240 2011-05-18 06:00:00     11.00            A       14.4
    ## 1795  02203700 2011-05-03 16:15:00      6.10            E       21.6
    ## 1796  02203700 2011-05-23 22:00:00      3.90          A e       25.5
    ## 1797  02336240 2011-05-10 17:30:00     11.00            A       23.2
    ## 1798  02336240 2011-05-02 23:30:00     13.00          A e       21.6
    ## 1799  02203700 2011-05-08 05:45:00      4.90            X       17.9
    ## 1800  02336240 2011-05-21 21:30:00      9.20            X       23.4
    ## 1801 021989773 2011-05-12 17:30:00 -80000.00            A       23.8
    ## 1802  02336526 2011-05-22 23:45:00      3.50          A e       25.3
    ## 1803  02337170 2011-05-15 08:15:00   3020.00            E       14.8
    ## 1804  02336526 2011-05-13 07:00:00      3.60            A       22.8
    ## 1805 021989773 2011-05-11 01:15:00  11800.00            X       23.2
    ## 1806  02336240 2011-05-23 11:30:00      8.50            A       20.5
    ## 1807  02336526 2011-05-21 03:45:00      3.60          A e       21.7
    ## 1808  02336410 2011-05-06 01:00:00     28.00            A       17.5
    ## 1809  02203655 2011-05-19 19:45:00      8.80            E       17.5
    ## 1810  02203700 2011-05-08 01:30:00      5.10            A       20.1
    ## 1811  02336410 2011-05-19 06:00:00     15.00            A       15.6
    ## 1812  02336313 2011-05-23 18:45:00      0.98            A       24.8
    ## 1813  02336240 2011-05-30 10:15:00     12.00            A       22.3
    ## 1814  02336313 2011-05-25 00:15:00      0.87          A e       24.6
    ## 1815  02203655 2011-05-17 23:45:00        NA            A       16.0
    ## 1816  02336410 2011-05-17 18:15:00     16.00          A e       16.4
    ## 1817 021989773 2011-06-01 01:15:00        NA            E       27.7
    ## 1818  02336240 2011-05-12 13:30:00     11.00            A       21.0
    ## 1819  02336313 2011-05-29 15:00:00      0.82            X         NA
    ## 1820  02336120 2011-05-09 07:15:00     16.00            A       18.9
    ## 1821  02336526 2011-05-29 15:00:00      5.90            A       21.4
    ## 1822  02336120 2011-05-02 00:45:00     17.00            X         NA
    ## 1823  02336728 2011-05-27 07:45:00    256.00          A e       20.8
    ## 1824  02336360 2011-05-08 10:15:00     13.00            E       16.9
    ## 1825  02336120 2011-05-23 09:00:00     11.00            A       21.7
    ## 1826  02336410 2011-05-27 21:00:00     72.00            X       22.7
    ## 1827  02336120 2011-05-25 20:00:00     10.00            X       24.8
    ## 1828  02336728 2011-05-24 21:45:00      8.90          A e       25.7
    ## 1829  02336360 2011-05-08 18:00:00     13.00            X         NA
    ## 1830  02336120 2011-05-10 08:30:00     15.00          A e       20.3
    ## 1831  02336360 2011-05-03 10:15:00     13.00          A e       20.1
    ## 1832  02336120 2011-05-27 16:45:00    191.00            E       20.9
    ## 1833  02336120 2011-05-13 22:00:00     14.00            A         NA
    ## 1834  02336526 2011-05-06 03:45:00      5.50            A       17.1
    ## 1835  02336526 2011-05-08 16:45:00      4.60          A e       18.4
    ## 1836  02336360 2011-05-25 07:15:00      8.70            X       22.6
    ## 1837  02336240 2011-05-02 13:15:00     13.00            X       18.7
    ## 1838  02336120 2011-05-07 09:45:00     17.00          A e       16.0
    ## 1839  02337170 2011-05-27 21:30:00   6790.00            A       20.6
    ## 1840  02336300 2011-05-10 03:15:00     31.00          A e       21.8
    ## 1841 021989773 2011-05-03 18:00:00  50000.00            X       24.0
    ## 1842  02203655 2011-05-07 17:15:00     12.00          A e       17.0
    ## 1843  02336313 2011-05-09 17:00:00      1.00            A       22.3
    ## 1844 021989773 2011-05-05 07:15:00  62200.00            X       23.2
    ## 1845  02336300 2011-05-16 04:00:00     25.00            A       17.8
    ## 1846  02203655 2011-05-30 12:15:00     10.00            A       22.2
    ## 1847  02336410 2011-05-21 23:30:00     14.00            A       22.9
    ## 1848  02203655 2011-05-23 18:00:00      7.80            A       22.4
    ## 1849  02336728 2011-05-16 13:15:00     11.00            A       16.7
    ## 1850  02336360 2011-05-18 20:15:00     10.00            E       17.7
    ## 1851 021989773 2011-05-07 16:00:00  -7160.00            X       22.8
    ## 1852  02336240 2011-05-31 01:15:00     11.00            A       24.9
    ## 1853  02336526 2011-05-24 01:00:00      3.30            A       24.6
    ## 1854  02336410 2011-05-14 13:00:00     17.00            A       21.0
    ## 1855  02336120 2011-05-13 00:00:00     14.00            A       24.7
    ## 1856  02336120 2011-05-02 11:30:00     16.00            A       19.1
    ## 1857  02336526 2011-05-23 11:30:00      3.60            E       21.2
    ## 1858 021989773 2011-05-19 20:15:00  57000.00            X       23.6
    ## 1859  02337170 2011-05-16 09:00:00   1350.00            X       16.1
    ## 1860  02336410 2011-05-18 14:45:00     16.00            E       14.2
    ## 1861  02336728 2011-05-20 12:15:00     10.00          A e       16.4
    ## 1862  02337170 2011-05-30 18:15:00   1290.00            A       23.7
    ## 1863  02336526 2011-05-04 23:00:00      8.30            A       19.8
    ## 1864 021989773 2011-05-28 23:00:00 -16200.00            A       26.7
    ## 1865  02336526 2011-05-24 11:15:00      3.10            X       21.4
    ## 1866  02203655 2011-05-26 22:00:00      8.50            A       23.1
    ## 1867  02336240 2011-05-15 22:00:00     10.00            A       18.6
    ## 1868  02336120 2011-05-31 13:00:00     12.00            E       23.3
    ## 1869 021989773 2011-05-07 13:45:00 -51200.00            A       22.7
    ## 1870 021989773 2011-05-01 17:15:00  44600.00            A       23.8
    ## 1871  02336313 2011-05-23 11:00:00      0.93            A       20.3
    ## 1872  02336313 2011-05-11 04:00:00      0.93            A       22.8
    ## 1873 021989773 2011-05-12 06:00:00 -68800.00            A       23.4
    ## 1874  02336120 2011-05-27 04:30:00    478.00            A       22.7
    ## 1875  02336360 2011-05-20 08:45:00     10.00            E       17.4
    ## 1876  02203655 2011-05-27 06:15:00     81.00            A       21.0
    ## 1877  02203700 2011-05-23 16:30:00      3.90            A       22.8
    ## 1878  02336410 2011-05-10 23:30:00     19.00          A e       23.5
    ## 1879  02337170 2011-05-04 00:30:00   6220.00            E       13.4
    ## 1880  02203700 2011-05-17 17:45:00      4.60          A e       17.0
    ## 1881 021989773 2011-05-28 03:30:00  37900.00          A e       26.0
    ## 1882  02337170 2011-05-27 07:15:00   2620.00            A       20.6
    ## 1883  02336410 2011-05-08 15:30:00     21.00            X       17.6
    ## 1884  02203655 2011-05-23 07:15:00      7.20          A e       22.1
    ## 1885 021989773 2011-05-15 05:00:00  64400.00            A       24.1
    ## 1886  02336526 2011-05-09 07:30:00      4.20          A e       19.8
    ## 1887  02336300 2011-05-21 05:15:00     25.00            E       20.6
    ## 1888  02336360 2011-05-31 05:00:00      6.30            E       24.7
    ## 1889  02336300 2011-05-07 04:30:00     38.00            A       17.1
    ## 1890  02336240 2011-05-09 08:00:00     12.00            A       18.5
    ## 1891  02336360 2011-05-20 03:45:00     10.00            A       18.3
    ## 1892  02336728 2011-05-24 19:45:00        NA            E       25.2
    ## 1893  02203700 2011-05-11 22:30:00      4.60          A e       26.2
    ## 1894 021989773 2011-05-07 18:00:00  78900.00            X       23.3
    ## 1895  02336313 2011-05-17 23:15:00      1.00          A e       16.8
    ## 1896  02203700 2011-05-25 02:00:00      3.50            A       24.0
    ## 1897  02337170 2011-05-04 11:15:00   6620.00            A       15.4
    ## 1898  02336300 2011-05-06 17:45:00     38.00            A       17.7
    ## 1899 021989773 2011-05-11 23:00:00  91200.00            A       23.9
    ## 1900  02337170 2011-05-07 00:15:00   6840.00            X       12.9
    ## 1901  02336120 2011-05-01 22:00:00     17.00            A       21.8
    ## 1902  02336120 2011-05-17 13:30:00     14.00            A       15.3
    ## 1903  02336526 2011-05-29 04:15:00      6.90            X       23.4
    ## 1904  02203700 2011-05-17 02:15:00      5.60          A e       17.2
    ## 1905  02336410 2011-05-06 00:30:00     28.00            A       17.5
    ## 1906  02336313 2011-05-10 00:00:00        NA            A       23.4
    ## 1907  02336728 2011-05-26 13:45:00      7.80            A       21.5
    ## 1908  02336120 2011-05-10 09:15:00     15.00            A       20.2
    ## 1909  02336360 2011-05-08 01:45:00     13.00            A         NA
    ## 1910  02203655 2011-05-30 08:45:00     10.00            A       23.3
    ## 1911  02203700 2011-05-01 17:45:00      6.10            E       22.1
    ## 1912  02336728 2011-05-20 23:45:00     10.00            A       22.1
    ## 1913  02336240 2011-05-03 01:30:00     13.00            A       21.0
    ## 1914  02337170 2011-05-20 11:30:00   2780.00          A e       14.4
    ## 1915  02336120 2011-05-31 03:15:00     13.00            A       25.2
    ## 1916  02336120 2011-05-16 14:15:00     13.00            A       16.7
    ## 1917  02336526 2011-05-30 07:45:00      5.50            A       23.8
    ## 1918  02336120 2011-05-10 21:00:00     16.00            A       24.0
    ## 1919  02336313 2011-05-28 21:15:00      0.87            A       24.8
    ## 1920  02336526 2011-05-12 18:45:00      3.80            X       24.5
    ## 1921  02336240 2011-05-04 05:30:00    339.00            A       17.5
    ## 1922  02203700 2011-05-13 15:15:00      4.40            E       21.6
    ## 1923  02336728 2011-05-28 02:30:00     55.00          A e       22.1
    ## 1924  02336526 2011-05-01 16:00:00      4.40            X       18.4
    ## 1925 021989773 2011-05-10 08:15:00  66400.00            A       22.8
    ## 1926  02203700 2011-05-26 19:45:00      3.70            A       25.3
    ## 1927  02336120 2011-05-11 02:45:00     15.00          A e       23.0
    ## 1928 021989773 2011-05-06 02:15:00 -48100.00            A       23.5
    ## 1929  02203655 2011-05-31 12:00:00      9.60            A       22.8
    ## 1930  02336240 2011-05-07 12:30:00     13.00          A e       14.9
    ## 1931  02337170 2011-05-07 09:15:00   5990.00            E       14.1
    ## 1932  02336313 2011-05-14 11:00:00      0.98            X       20.3
    ## 1933  02336240 2011-05-03 22:45:00    109.00            A       19.9
    ## 1934  02336728 2011-05-27 16:15:00    186.00            A       20.3
    ## 1935  02336728 2011-05-05 03:45:00     28.00            A       17.3
    ## 1936  02336120 2011-05-06 12:15:00     19.00            X       14.9
    ## 1937  02336313 2011-05-07 20:00:00      1.00            A         NA
    ## 1938  02337170 2011-05-11 13:45:00   2430.00            A       17.3
    ## 1939  02336300 2011-05-16 03:30:00     26.00            A       17.9
    ## 1940  02336120 2011-05-24 06:00:00     10.00            E       22.8
    ## 1941  02203700 2011-05-13 16:00:00      4.40            X       22.4
    ## 1942  02336410 2011-05-30 20:30:00     13.00            E       26.5
    ## 1943  02203700 2011-05-21 10:00:00      4.60            A       18.2
    ## 1944  02336410 2011-05-04 05:00:00    340.00            A       18.4
    ## 1945  02336300 2011-05-22 21:15:00     22.00            A       26.5
    ## 1946  02336300 2011-05-09 03:30:00     32.00            A       20.1
    ## 1947  02336410 2011-05-18 15:00:00     16.00            A       14.3
    ## 1948  02337170 2011-05-28 20:00:00   2510.00            X         NA
    ## 1949  02203700 2011-05-06 11:30:00      5.30            A       14.1
    ## 1950  02336410 2011-05-02 00:30:00     22.00            A       20.9
    ## 1951  02336120 2011-05-05 16:45:00     23.00            A       15.7
    ## 1952  02336240 2011-05-29 19:30:00     14.00            A       25.6
    ## 1953  02336526 2011-05-29 20:45:00      5.70            A       26.2
    ## 1954  02336300 2011-05-12 04:30:00     29.00            A       23.4
    ## 1955  02336313 2011-05-09 14:30:00      1.10            A       19.6
    ## 1956  02336526 2011-05-13 21:00:00      3.60            A       24.2
    ## 1957  02336360 2011-05-31 09:30:00        NA          A e       23.7
    ## 1958  02336240 2011-05-30 06:15:00     12.00            A       22.8
    ## 1959  02336240 2011-05-19 00:30:00      9.90            A       16.7
    ## 1960  02336240 2011-05-13 10:45:00        NA            A       20.8
    ## 1961  02203655 2011-05-04 00:15:00    174.00            A       20.8
    ## 1962  02336240 2011-05-27 11:15:00   1360.00            A       19.5
    ## 1963  02337170 2011-05-18 15:00:00   2720.00            X       12.9
    ## 1964  02336410 2011-05-06 06:45:00        NA            A       16.3
    ## 1965  02336120 2011-05-14 11:45:00     13.00          A e       20.7
    ## 1966 021989773 2011-05-24 15:45:00 -58800.00            A       25.3
    ## 1967  02203655 2011-05-19 17:30:00      9.20            A       16.6
    ## 1968  02336410 2011-05-17 03:30:00     16.00            A       17.0
    ## 1969  02336410 2011-05-31 00:15:00     13.00            E       25.7
    ## 1970  02336360 2011-05-24 04:30:00      9.10            X       22.9
    ## 1971 021989773 2011-05-04 19:00:00  64100.00            X       23.6
    ## 1972  02336410 2011-05-09 01:15:00     21.00          A e       20.1
    ## 1973  02336410 2011-05-03 19:15:00     20.00            A       22.6
    ## 1974  02336240 2011-05-31 23:00:00     10.00            E       25.9
    ## 1975  02336300 2011-05-08 08:30:00     34.00            A       17.5
    ## 1976  02336410 2011-05-04 08:45:00    194.00            E       17.8
    ## 1977  02336410 2011-05-04 03:15:00    224.00          A e       18.4
    ## 1978  02336410 2011-05-24 07:45:00     13.00            E       22.5
    ## 1979  02336360 2011-05-10 20:45:00     12.00            A       24.6
    ## 1980  02336120 2011-05-31 07:00:00     13.00            A       24.1
    ## 1981  02336728 2011-05-21 16:00:00      9.70            A       20.6
    ## 1982  02203700 2011-05-09 04:30:00      5.10          A e         NA
    ## 1983  02336300 2011-05-25 09:00:00     19.00            A       22.6
    ## 1984  02336728 2011-05-21 05:30:00      9.70            X       19.0
    ## 1985  02336313 2011-05-07 16:30:00      1.10            A       18.5
    ## 1986  02336120 2011-05-16 03:30:00     13.00            A       17.9
    ## 1987  02336120 2011-05-05 11:00:00     26.00            A       14.9
    ## 1988 021989773 2011-05-25 08:30:00   3590.00            A       25.3
    ## 1989  02336120 2011-05-26 23:30:00        NA            A       22.9
    ## 1990  02336240 2011-05-15 11:00:00     10.00          A e       18.5
    ## 1991  02336240 2011-05-06 16:00:00     14.00            X       16.0
    ## 1992  02336360 2011-05-12 07:00:00     11.00            X       22.5
    ## 1993  02336526 2011-05-01 06:00:00      4.20            A       19.6
    ## 1994 021989773 2011-05-02 07:00:00  25400.00            A       23.5
    ## 1995  02336526 2011-05-09 13:00:00        NA            X       18.3
    ## 1996  02336300 2011-05-18 19:00:00     27.00            E       17.8
    ## 1997  02336526 2011-05-26 18:00:00      2.80            E       23.8
    ## 1998  02336360 2011-05-20 02:30:00     10.00            A       18.5
    ## 1999  02336526 2011-05-28 09:30:00     11.00            E       20.2
    ## 2000  02336120 2011-05-12 07:30:00     14.00          A e       22.1
    ## 2001  02336410 2011-05-01 07:15:00     22.00            A       19.1
    ## 2002  02336526 2011-05-14 09:00:00      3.50            X       21.3
    ## 2003  02336360 2011-05-18 21:45:00     10.00            A       17.5
    ## 2004  02336240 2011-05-06 08:15:00     14.00            A       14.8
    ## 2005  02336300 2011-05-02 13:00:00     31.00          A e       19.3
    ## 2006  02336313 2011-05-28 21:45:00      0.87            A       24.9
    ## 2007  02336300 2011-05-22 09:00:00     23.00            A       21.2
    ## 2008  02336240 2011-05-01 12:15:00     13.00            E       17.4
    ## 2009  02336728 2011-05-30 21:30:00     15.00            A       26.5
    ## 2010  02336240 2011-05-19 16:15:00      9.50            A       16.7
    ## 2011  02336526 2011-05-26 16:45:00      2.80            A       23.2
    ## 2012  02336410 2011-05-21 13:45:00     14.00            A       19.1
    ## 2013  02336526 2011-05-08 01:15:00      4.80          A e       20.6
    ## 2014 021989773 2011-05-20 02:45:00 -59100.00          A e       23.4
    ## 2015  02336313 2011-05-20 10:15:00      0.98            A       16.4
    ## 2016  02203655 2011-05-04 13:15:00     43.00            X       15.9
    ## 2017  02337170 2011-05-17 07:15:00   1880.00            A       16.0
    ## 2018  02336526 2011-05-05 23:00:00      5.50            A       18.9
    ## 2019  02336410 2011-05-06 22:45:00     25.00          A e       18.1
    ## 2020  02336313 2011-05-02 05:30:00      1.00            A       20.1
    ## 2021  02336410 2011-05-16 03:45:00     16.00            X       18.0
    ## 2022  02337170 2011-05-06 07:00:00   7020.00          A e       13.2
    ## 2023 021989773 2011-05-23 12:00:00  35000.00            A       24.4
    ## 2024  02203700 2011-05-21 05:00:00      4.90            A       20.2
    ## 2025  02336313 2011-05-09 23:45:00      0.98          A e       23.5
    ## 2026  02337170 2011-05-13 21:00:00   6290.00            X       16.3
    ## 2027 021989773 2011-05-17 10:30:00 -73500.00          A e       23.4
    ## 2028  02336360 2011-05-22 22:45:00      9.80            A       24.9
    ## 2029  02336410 2011-05-31 21:15:00     11.00            A       27.1
    ## 2030  02336360 2011-05-07 15:30:00     14.00            A       16.1
    ## 2031  02336728 2011-05-14 17:30:00     12.00          A e       22.1
    ## 2032  02337170 2011-05-16 11:45:00   1370.00          A e       16.1
    ## 2033  02203655 2011-05-19 04:00:00      8.80            A       16.4
    ## 2034  02336728 2011-05-20 06:15:00     10.00            A       16.5
    ## 2035  02336728 2011-05-19 21:15:00     11.00            E       20.0
    ## 2036  02337170 2011-05-04 08:00:00   6450.00            E       15.2
    ## 2037  02336360 2011-05-11 14:15:00     12.00            A       21.2
    ## 2038  02336410 2011-05-10 10:45:00     19.00          A e       20.5
    ## 2039  02336313 2011-05-10 00:30:00      0.98          A e       23.2
    ## 2040 021989773 2011-05-10 19:00:00  -9740.00            X       23.5
    ## 2041  02203655 2011-05-29 02:45:00     14.00            A       23.6
    ## 2042  02336240 2011-05-10 02:45:00     11.00            E       21.1
    ## 2043  02336526 2011-05-10 20:15:00      6.40            X       24.9
    ## 2044  02336120 2011-05-11 14:45:00     15.00            X       21.4
    ## 2045 021989773 2011-05-31 14:30:00  71100.00            A       27.2
    ## 2046  02336300 2011-05-25 16:15:00     19.00            A       23.8
    ## 2047  02336360 2011-05-30 23:30:00      6.60            A       26.5
    ## 2048  02336120 2011-05-01 17:30:00     18.00          A e         NA
    ## 2049 021989773 2011-05-18 10:00:00 -46000.00            A       23.1
    ## 2050  02203700 2011-05-24 14:45:00      3.90            A       21.5
    ## 2051 021989773 2011-05-07 10:00:00  31400.00            A       22.5
    ## 2052 021989773 2011-05-26 17:30:00 -59800.00            A       26.1
    ## 2053  02336728 2011-05-22 07:45:00      9.30            A       19.9
    ## 2054  02336313 2011-05-01 04:00:00      1.00            A       19.6
    ## 2055  02336240 2011-05-20 08:00:00      9.50            A       16.8
    ## 2056 021989773 2011-05-25 16:30:00 -44800.00            X       26.0
    ## 2057  02336313 2011-05-29 16:00:00      0.82            A       23.1
    ## 2058  02203700 2011-05-07 16:45:00      5.60            A       18.7
    ## 2059  02203700 2011-05-21 08:45:00      4.60            E       18.6
    ## 2060 021989773 2011-05-03 01:45:00        NA            A       24.0
    ## 2061  02336300 2011-05-13 09:30:00     27.00            A       22.0
    ## 2062 021989773 2011-05-23 08:30:00  82400.00            A       24.5
    ## 2063  02203700 2011-05-09 09:30:00      4.90            E       18.3
    ## 2064  02336526 2011-05-07 23:15:00      4.80            A       21.2
    ## 2065  02203700 2011-05-09 16:00:00      5.10            E       20.8
    ## 2066  02336728 2011-05-03 12:15:00     15.00            X       20.2
    ## 2067  02336313 2011-05-29 02:00:00      0.77            A       23.8
    ## 2068 021989773 2011-05-27 12:15:00  70500.00          A e       25.7
    ## 2069  02336120 2011-05-11 09:00:00     14.00            A       21.5
    ## 2070  02337170 2011-05-25 21:45:00   1670.00            A       21.3
    ## 2071  02203655 2011-05-03 01:30:00     11.00            X       21.5
    ## 2072  02336300 2011-05-18 07:45:00     27.00          A e       14.6
    ## 2073  02336526 2011-05-31 01:00:00      6.70            A       26.6
    ## 2074  02336120 2011-05-02 22:00:00     17.00            A       22.3
    ## 2075  02336240 2011-05-29 18:15:00     14.00            A       25.0
    ## 2076  02337170 2011-05-13 05:15:00   4010.00          A e         NA
    ## 2077  02336526 2011-05-21 01:45:00      3.60            A       22.3
    ## 2078  02336313 2011-05-10 17:15:00      1.00            E       23.8
    ## 2079  02336526 2011-05-15 15:15:00      3.60          A e       18.7
    ## 2080  02336240 2011-05-20 22:30:00      9.20            A       21.4
    ## 2081  02336410 2011-05-04 11:30:00    125.00            E       17.1
    ## 2082  02337170 2011-05-06 07:15:00   7060.00            E       13.2
    ## 2083  02336120 2011-05-22 02:15:00     12.00            A       22.5
    ## 2084 021989773 2011-05-06 16:15:00  21600.00            A       23.1
    ## 2085  02336526 2011-05-03 15:45:00      4.20            X       20.5
    ## 2086  02336120 2011-05-17 19:00:00     14.00            A       16.3
    ## 2087  02336360 2011-05-26 12:30:00      8.10            A       22.4
    ## 2088 021989773 2011-05-14 20:00:00 -83400.00            X       24.2
    ## 2089  02336728 2011-05-25 21:15:00      9.70            A         NA
    ## 2090  02336120 2011-05-25 03:45:00      9.90            E       24.0
    ## 2091  02336728 2011-05-13 12:30:00     12.00            E       21.0
    ## 2092  02336313 2011-05-06 12:45:00      1.20            A       13.8
    ## 2093  02336526 2011-05-26 16:00:00      2.80          A e       22.9
    ## 2094  02336120 2011-05-16 08:30:00     13.00            A       17.1
    ## 2095  02336360 2011-05-10 03:30:00     12.00            A       21.6
    ## 2096  02336240 2011-05-09 17:00:00     12.00            A       21.3
    ## 2097 021989773 2011-05-03 12:45:00 -45000.00            A       23.7
    ## 2098  02336240 2011-05-13 21:00:00     10.00            X       24.1
    ## 2099 021989773 2011-05-06 05:15:00  78500.00            A       23.0
    ## 2100 021989773 2011-05-25 04:45:00 -52700.00            A       25.3
    ## 2101 021989773 2011-05-13 20:45:00 -61100.00            E       24.4
    ## 2102 021989773 2011-05-04 16:45:00  78100.00            A       23.6
    ## 2103  02336410 2011-05-22 19:45:00     14.00            X       24.8
    ## 2104  02336240 2011-05-20 22:00:00      9.20            X       21.6
    ## 2105  02336120 2011-05-24 16:00:00     11.00            E       22.3
    ## 2106  02336410 2011-05-01 18:00:00     22.00            A       20.6
    ## 2107  02336526 2011-05-19 14:30:00      3.80            A       14.6
    ## 2108  02336526 2011-05-15 03:00:00      3.80            X       22.2
    ## 2109 021989773 2011-05-31 14:15:00  59400.00            A       27.1
    ## 2110  02336728 2011-05-22 13:45:00      9.30            A       19.9
    ## 2111  02203700 2011-05-22 13:30:00      3.90          A e       19.7
    ## 2112  02336410 2011-05-07 04:45:00     23.00            A       17.3
    ## 2113  02336360 2011-05-09 10:00:00     12.00            E       18.6
    ## 2114  02336313 2011-05-21 16:15:00      1.00            X       21.7
    ## 2115 021989773 2011-05-12 04:15:00 -61700.00            E       23.4
    ## 2116  02336410 2011-05-23 04:45:00     13.00            A       22.9
    ## 2117  02336526 2011-05-10 02:45:00      4.00            A       23.3
    ## 2118  02336300 2011-05-17 21:45:00     29.00            A       16.6
    ## 2119  02336526 2011-05-25 16:30:00      3.10            X       22.4
    ## 2120  02336360 2011-05-08 19:45:00     13.00            E       19.8
    ## 2121  02336300 2011-05-21 13:15:00     25.00            A       19.4
    ## 2122  02203700 2011-05-16 00:30:00      4.40            A       18.3
    ## 2123  02336360 2011-05-26 02:45:00      8.40            A       24.2
    ## 2124  02337170 2011-05-09 15:15:00   1370.00            A       18.3
    ## 2125  02336240 2011-05-11 12:00:00     11.00            A       20.5
    ## 2126  02336360 2011-05-02 00:00:00     14.00            A       21.3
    ## 2127  02336120 2011-05-12 21:00:00        NA            X       25.0
    ## 2128  02336300 2011-05-15 19:30:00     26.00            X       19.5
    ## 2129  02336526 2011-05-13 09:45:00      3.60            X       21.6
    ## 2130  02337170 2011-05-14 08:30:00   3980.00          A e       15.0
    ## 2131  02336526 2011-05-17 13:45:00      3.80          A e       15.1
    ## 2132  02336300 2011-05-19 20:00:00     26.00            A       20.7
    ## 2133  02336728 2011-05-27 04:45:00    244.00          A e       22.4
    ## 2134  02336410 2011-05-04 17:30:00     67.00            A       17.7
    ## 2135  02336120 2011-05-08 18:15:00     17.00          A e       19.1
    ## 2136  02336300 2011-05-01 09:30:00        NA          A e       18.7
    ## 2137  02203700 2011-05-24 04:15:00      3.70          A e       23.0
    ## 2138 021989773 2011-05-29 16:15:00  53000.00            E       26.8
    ## 2139  02336240 2011-05-29 10:30:00     14.00            E       21.0
    ## 2140  02336240 2011-05-19 16:45:00      9.50            E         NA
    ## 2141  02336728 2011-05-20 22:15:00     10.00            X       22.8
    ## 2142  02336728 2011-05-03 19:15:00     16.00          A e         NA
    ## 2143  02336526 2011-05-11 10:30:00      4.00            A       21.1
    ## 2144  02336410 2011-05-22 05:00:00     14.00            A       21.7
    ## 2145  02336313 2011-05-17 03:15:00      1.20            E       16.6
    ## 2146  02336410 2011-05-24 04:45:00     14.00          A e       23.1
    ## 2147  02336526 2011-05-08 09:15:00      4.60            E       17.0
    ## 2148  02336526 2011-05-19 08:15:00      3.60            X       15.4
    ## 2149  02336526 2011-05-31 14:00:00      4.60            X       22.7
    ## 2150  02336120 2011-05-22 17:30:00     11.00            A       22.1
    ## 2151  02336313 2011-05-24 01:45:00      0.87            A       23.9
    ## 2152  02203700 2011-05-21 19:15:00      4.00          A e       23.8
    ## 2153  02336313 2011-05-21 22:30:00      0.98            A       23.5
    ## 2154  02336120 2011-05-11 02:30:00     15.00          A e       23.1
    ## 2155  02336313 2011-05-18 02:45:00      0.98            A       15.8
    ## 2156  02336120 2011-05-26 23:15:00    352.00            E       23.1
    ## 2157  02336360 2011-05-24 16:15:00      9.10            A       22.6
    ## 2158  02336120 2011-05-16 04:30:00     13.00            A       17.8
    ## 2159  02337170 2011-05-23 21:00:00   1980.00            A       22.4
    ## 2160  02336300 2011-05-13 20:45:00     27.00            A       25.0
    ## 2161  02336410 2011-05-02 12:45:00     21.00            A       19.4
    ## 2162  02203700 2011-05-06 22:30:00      5.30          A e       20.8
    ## 2163  02336526 2011-05-01 21:00:00      4.20            X       22.7
    ## 2164  02336120 2011-05-16 12:30:00     13.00            E       16.7
    ## 2165  02336313 2011-05-14 11:45:00      0.98            A       20.3
    ## 2166  02336313 2011-05-08 07:00:00      1.00            E       17.0
    ## 2167  02203700 2011-05-16 07:00:00      4.40            A       17.0
    ## 2168  02336410 2011-05-02 22:15:00     21.00            X       22.0
    ## 2169  02336728 2011-05-13 08:15:00     12.00            A       21.0
    ## 2170  02336240 2011-05-29 09:30:00     15.00          A e       21.1
    ## 2171  02336313 2011-05-12 12:00:00      1.00            A       20.5
    ## 2172  02336120 2011-05-25 04:00:00      9.90            E       23.9
    ## 2173  02203700 2011-05-13 08:30:00      4.40            A       20.8
    ## 2174  02336360 2011-05-27 07:15:00     76.00            A       21.9
    ## 2175  02336728 2011-05-26 11:00:00      7.80            X       21.3
    ## 2176  02336410 2011-05-25 08:45:00     13.00            A       22.3
    ## 2177  02336240 2011-05-06 11:30:00     14.00            X       14.2
    ## 2178  02336240 2011-05-15 09:30:00     10.00            E       18.8
    ## 2179  02336300 2011-05-19 17:30:00     26.00            A         NA
    ## 2180  02336360 2011-05-10 17:45:00     12.00            A         NA
    ## 2181 021989773 2011-05-04 19:30:00  55100.00            A       23.6
    ## 2182  02203655 2011-05-20 18:15:00      8.80            A       19.2
    ## 2183 021989773 2011-05-15 09:45:00        NA            A       24.1
    ## 2184  02336313 2011-05-31 15:45:00      0.73            A       24.6
    ## 2185  02203700 2011-05-05 09:30:00     22.00            X       16.1
    ## 2186  02336410 2011-05-21 13:00:00     14.00            A       19.0
    ## 2187  02336313 2011-05-15 00:00:00      1.00            X       22.0
    ## 2188  02336120 2011-05-18 13:30:00     13.00            E       14.1
    ## 2189 021989773 2011-05-01 10:00:00 -54600.00            X       23.5
    ## 2190 021989773 2011-05-14 16:00:00  55600.00            A       24.2
    ## 2191  02336300 2011-05-20 06:45:00     26.00            A       18.1
    ## 2192  02336240 2011-05-17 16:30:00     11.00          A e       16.0
    ## 2193  02336360 2011-05-27 10:45:00    319.00            A       21.1
    ## 2194  02203700 2011-05-13 15:45:00      4.40            E       22.2
    ## 2195  02336120 2011-05-12 21:45:00     14.00            A         NA
    ## 2196  02336313 2011-05-31 03:15:00      0.69            E       25.0
    ## 2197  02336526 2011-05-03 12:00:00      4.00            E       19.7
    ## 2198  02336360 2011-05-02 10:00:00     13.00            A       19.4
    ## 2199  02336240 2011-05-22 04:45:00      8.90            A       21.0
    ## 2200  02336300 2011-05-12 18:30:00     28.00            X       25.4
    ## 2201  02203700 2011-05-04 07:15:00     21.00            A       16.6
    ## 2202  02337170 2011-05-08 15:30:00   1470.00            A         NA
    ## 2203  02336728 2011-05-18 03:00:00     11.00            E       15.3
    ## 2204  02336360 2011-05-01 12:00:00     14.00            A       17.8
    ## 2205  02336120 2011-05-19 15:45:00     12.00            A       15.8
    ## 2206  02336360 2011-05-20 13:15:00        NA            X       16.8
    ## 2207  02336313 2011-05-07 19:00:00      1.10            A       20.5
    ## 2208  02336360 2011-05-26 16:30:00      8.10            A       23.5
    ## 2209  02336120 2011-05-01 21:45:00     17.00            A       21.8
    ## 2210  02336240 2011-05-24 13:45:00      8.20            A       21.3
    ## 2211  02336240 2011-05-05 23:30:00     14.00            A       17.1
    ## 2212  02337170 2011-05-26 12:00:00   1760.00            A       20.3
    ## 2213  02336410 2011-05-20 04:30:00     15.00          A e       18.0
    ## 2214  02336313 2011-05-07 21:00:00      1.00            A       20.8
    ## 2215  02336360 2011-05-10 18:30:00     12.00            X       23.4
    ## 2216 021989773 2011-05-21 05:15:00        NA          A e       23.7
    ## 2217  02336360 2011-05-12 17:30:00     11.00            X         NA
    ## 2218  02336728 2011-05-14 09:00:00     12.00            E       20.4
    ## 2219  02336526 2011-05-16 09:00:00      3.60          A e       17.0
    ## 2220  02336410 2011-05-27 14:30:00    230.00            A       21.1
    ## 2221  02203700 2011-05-13 07:30:00      4.40            E       21.2
    ## 2222  02336728 2011-05-27 14:00:00    313.00            A         NA
    ## 2223  02336410 2011-05-04 20:45:00     55.00            A       18.8
    ## 2224  02336120 2011-05-27 05:00:00    415.00          A e       22.6
    ## 2225  02203655 2011-05-23 02:45:00      7.80            A       23.0
    ## 2226  02203655 2011-05-21 11:00:00      8.20            X       18.8
    ## 2227  02336526 2011-05-11 20:45:00      3.80          A e       25.8
    ## 2228  02336313 2011-05-15 13:30:00      1.00            A       18.1
    ## 2229  02336313 2011-05-15 06:45:00      0.98          A e       19.7
    ## 2230  02336300 2011-05-12 09:30:00     29.00            A       22.2
    ## 2231  02203655 2011-05-25 07:45:00      7.20          A e       22.1
    ## 2232  02336410 2011-05-06 07:30:00     26.00            E       16.1
    ## 2233  02336526 2011-05-19 14:45:00      3.80            E       14.7
    ## 2234  02336240 2011-05-31 20:30:00     10.00            A       26.5
    ## 2235  02336300 2011-05-21 17:00:00     23.00            X       21.8
    ## 2236  02336360 2011-05-10 17:00:00     12.00            E       21.9
    ## 2237  02336410 2011-05-03 18:45:00     20.00            E       22.5
    ## 2238  02336728 2011-05-25 10:30:00      8.20            A       20.7
    ## 2239  02337170 2011-05-31 21:15:00   1260.00            A       25.8
    ## 2240  02337170 2011-05-29 02:45:00   2430.00            X       21.5
    ## 2241  02336410 2011-05-05 16:00:00     31.00            A       15.4
    ## 2242  02336240 2011-05-01 22:45:00     13.00            E       21.3
    ## 2243  02336410 2011-05-22 03:45:00     14.00            A       21.9
    ## 2244 021989773 2011-05-13 02:30:00  50600.00            X       23.8
    ## 2245  02336313 2011-05-28 11:00:00      0.98          A e       19.8
    ## 2246  02336360 2011-05-03 20:30:00     14.00            A       22.1
    ## 2247  02203700 2011-05-01 04:15:00      6.10            A       19.5
    ## 2248  02336240 2011-05-10 02:00:00     11.00            E       21.3
    ## 2249  02336526 2011-05-06 12:45:00      5.20            X       13.9
    ## 2250  02336313 2011-05-14 05:30:00      0.93            A       21.7
    ## 2251 021989773 2011-05-05 20:45:00  19500.00            A       23.4
    ## 2252  02336410 2011-05-23 04:00:00     13.00            A       23.1
    ## 2253  02337170 2011-05-24 11:00:00   1900.00          A e       20.2
    ## 2254  02336120 2011-05-17 03:15:00     13.00            A       17.1
    ## 2255  02336410 2011-05-30 06:45:00     15.00            A       23.9
    ## 2256  02336360 2011-05-28 19:15:00     10.00          A e       24.9
    ## 2257  02336728 2011-05-19 17:00:00     10.00            A       17.5
    ## 2258 021989773 2011-05-31 23:30:00        NA            A       27.8
    ## 2259  02336526 2011-05-03 04:45:00      4.20            E       22.0
    ## 2260 021989773 2011-05-20 13:00:00        NA          A e       23.2
    ## 2261 021989773 2011-05-03 19:00:00  44600.00          A e       24.1
    ## 2262  02336313 2011-05-20 09:15:00      0.98            X       16.6
    ## 2263  02336240 2011-05-02 16:45:00     13.00            A       20.7
    ## 2264  02203700 2011-05-12 14:15:00      4.60          A e       21.0
    ## 2265  02337170 2011-05-11 01:00:00   4120.00            A       20.5
    ## 2266  02337170 2011-05-23 08:45:00   1410.00            A       19.9
    ## 2267  02336526 2011-05-20 11:00:00      3.60            X       17.1
    ## 2268  02336526 2011-05-12 14:45:00      3.80          A e         NA
    ## 2269  02336360 2011-05-29 05:15:00      8.70            X       23.2
    ## 2270  02336410 2011-05-16 08:30:00        NA            A       17.3
    ## 2271  02336300 2011-05-20 20:15:00     25.00            E       23.1
    ## 2272  02336120 2011-05-10 11:00:00     15.00          A e       19.9
    ## 2273 021989773 2011-06-01 02:45:00  67000.00            X       27.6
    ## 2274  02336526 2011-05-19 22:00:00      3.60            A       19.8
    ## 2275  02336120 2011-05-24 17:00:00     11.00            A       22.8
    ## 2276  02336120 2011-05-31 20:15:00     12.00          A e       26.5
    ## 2277  02336240 2011-05-07 14:00:00     13.00            A       15.3
    ## 2278  02336410 2011-05-20 15:15:00     14.00          A e       17.7
    ## 2279  02336526 2011-05-19 16:15:00      3.80            A       15.6
    ## 2280  02336120 2011-05-28 01:45:00     56.00          A e       22.5
    ## 2281  02336410 2011-05-25 22:15:00     11.00            A       25.7
    ## 2282  02336360 2011-05-30 05:30:00      7.20            E       24.1
    ## 2283  02203655 2011-05-22 23:45:00      8.20            A       22.8
    ## 2284 021989773 2011-05-22 10:45:00  43800.00            X       23.9
    ## 2285  02336313 2011-05-16 01:00:00      1.00            A       18.2
    ## 2286  02336120 2011-05-29 22:30:00     16.00            X       25.9
    ## 2287  02336120 2011-05-19 13:00:00     12.00            A       15.0
    ## 2288  02336728 2011-05-19 05:00:00     11.00            A       14.8
    ## 2289  02336526 2011-05-12 09:15:00      3.80            A       22.0
    ## 2290  02203655 2011-05-07 19:15:00     11.00            A       17.9
    ## 2291  02336240 2011-05-09 22:00:00     12.00            A       22.5
    ## 2292  02336728 2011-05-27 00:15:00     25.00            E       23.6
    ## 2293  02336313 2011-05-23 11:15:00      0.93            A       20.3
    ## 2294  02336728 2011-05-21 07:30:00      9.70          A e       18.5
    ## 2295  02336300 2011-05-12 23:45:00     27.00          A e       25.6
    ## 2296  02336728 2011-05-19 11:00:00     11.00            A       14.0
    ## 2297 021989773 2011-05-05 18:00:00  80600.00            X       23.3
    ## 2298  02203655 2011-05-18 16:00:00      9.20            A       14.9
    ## 2299  02336410 2011-05-23 07:30:00     13.00            A       22.3
    ## 2300  02336120 2011-05-24 22:15:00     10.00            E       25.4
    ## 2301  02336240 2011-05-24 07:00:00      8.20            E       21.9
    ## 2302  02336360 2011-05-24 17:15:00      9.10            A       23.5
    ## 2303  02336300 2011-05-06 19:00:00     38.00            A       18.9
    ## 2304  02336313 2011-05-05 12:00:00      1.40            E       13.1
    ## 2305  02336526 2011-05-13 09:00:00      3.60          A e       21.9
    ## 2306  02336313 2011-05-13 17:15:00      1.00            A       23.8
    ## 2307  02336410 2011-05-31 01:15:00     13.00            A       25.4
    ## 2308  02336313 2011-05-08 21:15:00      1.00            A       21.9
    ## 2309  02336240 2011-05-02 14:30:00     13.00            A       19.2
    ## 2310  02336526 2011-05-19 00:45:00      3.80            E       17.5
    ## 2311  02337170 2011-05-25 22:45:00   1670.00            E       21.3
    ## 2312  02336120 2011-05-12 00:30:00     15.00            X       24.4
    ## 2313  02336240 2011-05-16 00:45:00     10.00            E         NA
    ## 2314  02336410 2011-05-15 15:45:00     16.00            X       19.1
    ## 2315  02336313 2011-05-16 11:30:00      1.00          A e       16.3
    ## 2316  02336300 2011-05-17 12:30:00     27.00            A       15.3
    ## 2317  02336728 2011-05-01 18:15:00     16.00            A         NA
    ## 2318  02203700 2011-05-15 14:00:00      4.40            E       18.2
    ## 2319  02203700 2011-05-12 08:00:00      4.60            A       21.3
    ## 2320  02336360 2011-05-19 02:30:00     10.00            A       16.2
    ## 2321  02336313 2011-05-16 20:45:00      2.60            A       17.9
    ## 2322  02336728 2011-05-15 05:45:00     11.00            A         NA
    ## 2323 021989773 2011-05-30 23:30:00 -47500.00          A e       27.5
    ## 2324 021989773 2011-05-19 08:15:00  65000.00            E       23.1
    ## 2325  02336360 2011-05-09 14:15:00     12.00          A e       18.5
    ## 2326  02336526 2011-05-16 15:00:00      3.80            A       16.5
    ## 2327  02336410 2011-05-06 23:45:00     24.00            E       18.1
    ## 2328  02336313 2011-05-20 13:00:00      1.00          A e       16.3
    ## 2329  02336728 2011-05-17 00:15:00     12.00            A       17.2
    ## 2330  02336120 2011-05-30 04:00:00     15.00            A       24.5
    ## 2331  02203700 2011-05-20 02:15:00      4.00          A e       19.7
    ## 2332 021989773 2011-05-08 05:45:00  29900.00          A e       22.9
    ## 2333  02203655 2011-05-26 21:45:00      8.50            X       23.2
    ## 2334  02203655 2011-05-07 13:15:00     12.00            A       15.1
    ## 2335  02336526 2011-05-02 08:45:00      4.00            A       19.8
    ## 2336  02336240 2011-05-19 14:15:00      9.90            A       14.8
    ## 2337  02336313 2011-05-18 02:00:00      1.00            A       16.1
    ## 2338  02336728 2011-05-31 22:45:00     13.00            A       26.5
    ## 2339  02203655 2011-05-05 02:45:00     18.00            X       17.9
    ## 2340  02336300 2011-05-13 14:00:00     27.00            A       21.9
    ## 2341 021989773 2011-05-29 09:30:00 -36400.00            A       26.3
    ## 2342 021989773 2011-05-06 13:45:00 -48400.00          A e       23.2
    ## 2343  02337170 2011-05-24 16:00:00   2870.00            A       20.6
    ## 2344  02336728 2011-05-30 04:00:00     17.00            E       22.8
    ## 2345  02336120 2011-05-27 04:15:00    499.00            A       22.7
    ## 2346  02336360 2011-05-01 11:15:00     14.00          A e       17.9
    ## 2347  02203655 2011-05-06 03:15:00     13.00          A e       17.5
    ## 2348  02336240 2011-05-21 13:15:00      9.20          A e       18.3
    ## 2349  02336728 2011-05-22 08:00:00      9.30            A       19.8
    ## 2350  02336360 2011-05-10 15:30:00     12.00            X       20.6
    ## 2351  02336360 2011-05-22 17:00:00      9.80            E       22.5
    ## 2352  02336526 2011-05-03 20:00:00        NA            A       22.8
    ## 2353  02336728 2011-05-16 22:00:00     12.00            A       17.8
    ## 2354  02203655 2011-05-07 20:45:00     11.00            A       18.1
    ## 2355 021989773 2011-05-27 23:45:00  55500.00            X       26.3
    ## 2356  02337170 2011-05-20 11:15:00   2850.00            E       14.4
    ## 2357  02336526 2011-05-26 09:15:00      3.10            A       23.0
    ## 2358  02203700 2011-05-06 04:30:00      5.60            A       17.0
    ## 2359  02336410 2011-05-07 22:45:00     22.00            A       19.0
    ## 2360  02336410 2011-05-05 14:15:00     32.00            A       14.8
    ## 2361  02336313 2011-05-09 16:45:00      1.10            E       22.1
    ## 2362 021989773 2011-05-12 23:30:00  55800.00            X       24.2
    ## 2363  02336120 2011-05-28 17:15:00     27.00            X       22.6
    ## 2364  02336313 2011-05-22 01:00:00      0.93            A       23.0
    ## 2365  02336728 2011-05-28 00:15:00     67.00          A e       22.1
    ## 2366  02336410 2011-05-19 22:00:00     15.00          A e       19.3
    ## 2367  02336313 2011-05-14 05:45:00      0.98            A       21.7
    ## 2368  02203655 2011-05-20 16:45:00      8.50            A       18.3
    ## 2369  02336313 2011-05-13 16:00:00      1.00            E       23.0
    ## 2370 021989773 2011-05-18 21:15:00  -4640.00            X       23.6
    ## 2371  02336360 2011-05-30 14:45:00      6.60          A e       23.2
    ## 2372  02203655 2011-05-06 16:00:00     12.00            X       15.5
    ## 2373 021989773 2011-05-24 21:45:00  88100.00          A e       26.3
    ## 2374  02336120 2011-05-10 06:15:00     15.00            X       20.7
    ## 2375  02203655 2011-05-28 12:45:00     21.00            A       20.0
    ## 2376  02337170 2011-05-12 09:15:00   3960.00            A       16.2
    ## 2377 021989773 2011-05-20 05:30:00  62800.00            A       23.3
    ## 2378  02336360 2011-05-27 18:15:00     34.00            A       22.5
    ## 2379  02336300 2011-05-18 18:45:00     27.00            A       17.7
    ## 2380  02203700 2011-05-20 10:15:00      4.00            A       16.8
    ## 2381  02336410 2011-05-29 20:45:00     17.00            E       25.6
    ## 2382  02336728 2011-05-17 23:45:00     11.00            E       16.1
    ## 2383  02203700 2011-05-14 19:00:00      4.60          A e       23.2
    ## 2384  02336360 2011-05-17 12:15:00     11.00            E       15.3
    ## 2385  02203700 2011-05-14 09:30:00      4.40            X       20.4
    ## 2386  02336360 2011-05-13 13:30:00     11.00            A       21.1
    ## 2387  02336360 2011-05-20 21:15:00     10.00            A       22.4
    ## 2388 021989773 2011-05-29 18:30:00 -23800.00          A e       27.2
    ## 2389  02203655 2011-05-26 18:30:00      7.50            X       23.2
    ## 2390 021989773 2011-05-27 14:45:00  45400.00            A       25.9
    ## 2391  02336360 2011-05-01 20:30:00     14.00          A e       22.0
    ## 2392  02336410 2011-05-04 02:45:00    220.00            A       18.6
    ## 2393  02336360 2011-05-20 15:45:00      9.80            A       17.9
    ## 2394  02336313 2011-05-02 02:15:00      0.98            A       21.4
    ## 2395  02336240 2011-05-27 12:15:00   1170.00            A       19.5
    ## 2396  02336120 2011-05-12 18:45:00     14.00            X       23.8
    ## 2397  02336120 2011-05-09 17:45:00     16.00            X       20.4
    ## 2398  02203700 2011-05-18 11:45:00      4.20          A e       13.5
    ## 2399  02336728 2011-05-30 21:00:00     15.00            A       26.4
    ## 2400  02336300 2011-05-11 07:30:00     31.00            E       22.3
    ## 2401  02336313 2011-06-01 02:45:00      0.65            E       25.6
    ## 2402  02336728 2011-05-16 07:30:00     11.00            A       17.0
    ## 2403  02336120 2011-05-04 12:45:00     99.00            X       16.5
    ## 2404  02336240 2011-05-21 05:30:00      9.20            A       19.3
    ## 2405  02336300 2011-05-15 09:15:00     27.00          A e       19.6
    ## 2406  02336313 2011-05-13 22:45:00      0.98          A e       24.1
    ## 2407  02336240 2011-05-06 10:00:00     14.00          A e       14.5
    ## 2408  02337170 2011-05-22 12:30:00   2040.00            A       16.6
    ## 2409  02336300 2011-05-24 15:00:00     21.00            X       22.8
    ## 2410  02337170 2011-05-04 17:15:00   6130.00            X       16.2
    ## 2411  02336120 2011-05-06 06:30:00     20.00          A e       16.0
    ## 2412  02336360 2011-05-24 15:45:00      8.70            E       22.2
    ## 2413 021989773 2011-05-22 16:30:00 -47300.00            A       24.4
    ## 2414  02336240 2011-05-23 01:30:00      8.50          A e       23.3
    ## 2415  02336360 2011-05-07 03:30:00     14.00            E       17.6
    ## 2416  02337170 2011-05-21 11:00:00   2640.00          A e       15.2
    ## 2417  02336728 2011-05-14 16:00:00     12.00            X       21.3
    ## 2418  02337170 2011-05-12 00:30:00   4870.00            A       18.5
    ## 2419  02337170 2011-05-03 04:45:00   3980.00            X       15.2
    ## 2420  02336240 2011-05-11 17:45:00     11.00            A       24.4
    ## 2421  02336526 2011-05-21 19:15:00      3.50            E       22.7
    ## 2422  02336410 2011-05-24 11:15:00     13.00          A e       21.7
    ## 2423  02336300 2011-05-11 11:00:00     29.00            A       21.5
    ## 2424  02336526 2011-05-06 21:00:00      5.20            A       19.7
    ## 2425  02336410 2011-05-23 18:00:00     13.00            A       23.8
    ## 2426  02337170 2011-05-14 03:30:00   5140.00            E       14.3
    ## 2427  02203700 2011-05-06 14:45:00      6.10            A       15.6
    ## 2428  02336120 2011-05-02 12:30:00     16.00            E       19.0
    ## 2429  02336300 2011-05-17 15:00:00     27.00            E         NA
    ## 2430  02203655 2011-05-27 07:00:00    111.00            A       21.0
    ## 2431  02336360 2011-05-04 09:15:00     65.00            X       17.5
    ## 2432  02337170 2011-05-24 15:30:00   2790.00            E       20.6
    ## 2433  02337170 2011-05-21 00:30:00   4710.00            X       16.4
    ## 2434  02336313 2011-05-02 23:00:00      0.98            A       23.2
    ## 2435  02336120 2011-05-27 03:45:00    557.00            A       22.9
    ## 2436  02336313 2011-05-05 22:45:00      1.20            E       18.6
    ## 2437  02336360 2011-05-08 20:45:00     13.00            A       19.8
    ## 2438  02337170 2011-05-18 17:15:00   3140.00            A       13.4
    ## 2439  02336120 2011-05-08 02:45:00     17.00            E       18.6
    ## 2440  02336313 2011-05-11 00:15:00      0.98            E       24.4
    ## 2441  02336410 2011-05-17 23:30:00     16.00            A       16.0
    ## 2442  02203700 2011-05-24 15:00:00      3.70            A       21.7
    ## 2443  02337170 2011-05-21 01:00:00   4690.00            A       16.3
    ## 2444  02336313 2011-05-23 10:30:00      0.93            X       20.4
    ## 2445  02336313 2011-05-15 18:00:00      1.00            A         NA
    ## 2446  02336410 2011-05-13 07:45:00     17.00            E       22.3
    ## 2447  02336240 2011-05-14 09:00:00     10.00            A       20.7
    ## 2448  02337170 2011-05-21 22:00:00   3410.00            E       17.8
    ## 2449 021989773 2011-05-23 23:15:00  49400.00            A       25.3
    ## 2450  02336526 2011-05-18 22:30:00      3.60            A       17.4
    ## 2451  02336300 2011-05-20 10:00:00     25.00            A       17.6
    ## 2452  02337170 2011-05-14 22:45:00   5590.00          A e       15.4
    ## 2453 021989773 2011-05-14 12:15:00  50700.00            A       24.1
    ## 2454  02337170 2011-05-12 21:15:00   6410.00            X       14.5
    ## 2455  02203655 2011-05-23 12:00:00      7.50            A       20.8
    ## 2456  02336360 2011-05-15 02:45:00     12.00            A       21.3
    ## 2457  02336300 2011-05-16 08:15:00     25.00          A e       17.2
    ## 2458  02336728 2011-05-21 14:45:00      9.70            E       19.5
    ## 2459  02336120 2011-05-05 07:45:00     28.00            E       15.9
    ## 2460  02336526 2011-05-02 04:45:00      4.00            A       21.2
    ## 2461  02203700 2011-05-23 18:15:00      3.90            A       24.4
    ## 2462  02336300 2011-05-25 03:15:00     21.00            A       24.4
    ## 2463  02336120 2011-05-04 14:15:00     80.00            A       16.5
    ## 2464  02336240 2011-05-10 23:30:00     11.00            X       23.5
    ## 2465  02336313 2011-05-19 06:45:00      1.00            X       15.2
    ## 2466  02336240 2011-05-06 14:30:00     14.00          A e       14.8
    ## 2467  02203700 2011-05-17 18:00:00      4.40          A e       17.0
    ## 2468  02336526 2011-05-27 09:45:00        NA            A       19.6
    ## 2469  02336410 2011-05-06 18:15:00     25.00          A e       17.7
    ## 2470  02337170 2011-05-24 12:30:00   2180.00            A       20.4
    ## 2471  02337170 2011-05-17 22:45:00   3300.00            A       15.0
    ## 2472  02336526 2011-05-03 22:45:00     12.00            A       21.3
    ## 2473  02336410 2011-05-08 11:15:00     21.00            A       17.1
    ## 2474 021989773 2011-05-30 09:00:00 -51500.00            A       26.7
    ## 2475  02336300 2011-05-03 08:45:00     31.00          A e       20.5
    ## 2476  02337170 2011-05-03 14:15:00   5800.00            E       15.4
    ## 2477  02337170 2011-05-26 22:45:00   1710.00            A       21.8
    ## 2478  02336526 2011-05-17 15:30:00      3.80            X       15.4
    ## 2479  02203655 2011-05-25 22:00:00      7.50          A e       23.4
    ## 2480  02336526 2011-05-31 00:45:00      6.40            A       26.7
    ## 2481  02336526 2011-05-28 00:45:00     16.00            E       23.1
    ## 2482  02336313 2011-05-03 01:45:00      1.00            X       22.3
    ## 2483  02203700 2011-05-18 13:45:00      4.20          A e       13.9
    ## 2484  02336526 2011-05-27 22:30:00     19.00            A       23.6
    ## 2485 021989773 2011-05-08 02:15:00 -71200.00          A e       22.8
    ## 2486  02336526 2011-05-02 05:30:00      4.00          A e       20.9
    ## 2487  02203655 2011-05-06 08:00:00     12.00            X       15.7
    ## 2488  02336526 2011-05-06 16:15:00      5.20            X       15.7
    ## 2489  02336728 2011-05-02 21:30:00     16.00          A e       22.8
    ## 2490  02336313 2011-05-31 10:00:00      0.82            A         NA
    ## 2491  02336240 2011-05-09 20:15:00     12.00            A       22.8
    ## 2492  02203700 2011-05-01 11:45:00      6.40          A e       16.7
    ## 2493  02336300 2011-05-09 09:00:00     32.00            A       19.2
    ## 2494  02336526 2011-05-29 09:00:00      6.70            A       21.4
    ## 2495  02336240 2011-05-29 06:15:00     15.00            E       21.5
    ## 2496  02336526 2011-05-06 05:15:00      5.20            X       16.4
    ## 2497  02336240 2011-05-16 03:30:00     10.00            A       17.5
    ## 2498  02203700 2011-05-17 00:00:00      7.00            E       18.2
    ## 2499  02336240 2011-05-18 05:00:00     11.00            A       14.6
    ## 2500  02336526 2011-05-31 11:45:00      4.60          A e       22.5
    ## 2501  02336360 2011-05-08 05:00:00     13.00          A e       18.0
    ## 2502  02336120 2011-05-08 21:45:00     17.00            A       20.4
    ## 2503  02336240 2011-05-05 21:00:00     15.00            E       17.7
    ## 2504  02336360 2011-05-05 21:30:00     16.00            A       18.0
    ## 2505  02336240 2011-05-13 16:15:00     10.00          A e       22.6
    ## 2506  02336410 2011-05-13 13:45:00     17.00            A       21.5
    ## 2507  02336240 2011-05-22 21:45:00      8.50            X       24.8
    ## 2508  02337170 2011-05-17 00:00:00   1880.00            A       16.7
    ## 2509  02203655 2011-05-23 10:00:00      7.20            A       21.3
    ## 2510  02336728 2011-05-27 15:15:00    231.00            X       19.9
    ## 2511  02336313 2011-05-15 08:45:00      0.98            A       18.8
    ## 2512  02336526 2011-05-15 22:00:00      3.80          A e       18.8
    ## 2513  02336526 2011-05-09 10:00:00      4.40            A       18.8
    ## 2514 021989773 2011-05-31 22:45:00 -64300.00            A       27.9
    ## 2515 021989773 2011-05-25 07:30:00 -23600.00            X       25.4
    ## 2516  02336240 2011-05-14 17:15:00     10.00            X       21.5
    ## 2517  02336120 2011-05-02 02:30:00     17.00            A       20.8
    ## 2518  02336728 2011-05-26 22:15:00      8.20            A       24.7
    ## 2519  02336313 2011-05-08 19:00:00      1.10            E       21.1
    ## 2520  02203700 2011-05-07 16:30:00      5.60            X       18.4
    ## 2521  02336526 2011-05-01 06:30:00      4.20            E       19.4
    ## 2522 021989773 2011-05-08 21:45:00  71400.00            E       23.0
    ## 2523  02203700 2011-05-06 03:30:00      5.80            A       17.5
    ## 2524  02336120 2011-05-12 17:00:00     14.00          A e       22.7
    ## 2525 021989773 2011-05-19 16:00:00  28000.00            A       23.3
    ## 2526  02203655 2011-05-18 06:00:00      9.20          A e       15.4
    ## 2527  02336300 2011-05-20 23:15:00     24.00            A       23.1
    ## 2528  02337170 2011-05-30 21:00:00   1280.00          A e       25.1
    ## 2529  02336120 2011-05-22 22:00:00     11.00          A e       25.1
    ## 2530  02336120 2011-05-05 09:00:00     27.00            E       15.5
    ## 2531  02203700 2011-05-04 19:30:00     25.00            A       20.8
    ## 2532  02203655 2011-05-23 17:00:00      7.80            X       22.0
    ## 2533  02337170 2011-05-10 23:30:00   4300.00            X       21.0
    ## 2534  02336120 2011-05-31 23:15:00     12.00          A e       26.9
    ## 2535  02336300 2011-05-18 06:30:00     27.00            A       14.9
    ## 2536  02336360 2011-05-03 02:30:00     13.00          A e       21.4
    ## 2537  02337170 2011-05-24 23:15:00   2170.00            A       20.6
    ## 2538  02336240 2011-05-06 12:15:00     14.00            A       14.2
    ## 2539  02336526 2011-05-02 06:30:00      4.00            A       20.6
    ## 2540  02336728 2011-05-15 00:30:00     12.00            A       21.9
    ## 2541  02337170 2011-05-12 17:30:00   6440.00            X       15.0
    ## 2542  02336360 2011-05-02 09:30:00     13.00            A       19.5
    ## 2543  02203700 2011-05-25 15:30:00      3.70            A       22.0
    ## 2544  02336240 2011-05-01 13:45:00     13.00            X       17.6
    ## 2545 021989773 2011-05-27 20:45:00 -47000.00            A         NA
    ## 2546  02337170 2011-05-03 22:15:00   6820.00            E       13.2
    ## 2547  02337170 2011-05-31 19:00:00   1260.00            A       25.0
    ## 2548  02336120 2011-05-08 09:00:00     17.00            A       17.3
    ## 2549  02336410 2011-05-28 21:15:00     24.00            A       24.4
    ## 2550  02336728 2011-05-26 21:45:00      7.80            A       25.0
    ## 2551  02337170 2011-05-21 08:30:00   3180.00            A       15.0
    ## 2552  02336410 2011-05-26 16:30:00     11.00            A       23.3
    ## 2553  02336728 2011-05-31 04:30:00     13.00            A       23.7
    ## 2554  02336360 2011-05-18 22:15:00     10.00          A e       17.4
    ## 2555  02336728 2011-05-16 00:30:00     12.00            A       18.3
    ## 2556  02336313 2011-05-19 10:45:00      1.00            A       14.1
    ## 2557 021989773 2011-05-23 13:30:00 -21000.00            A       24.6
    ## 2558  02336240 2011-05-30 01:30:00     13.00            E       24.0
    ## 2559  02336120 2011-05-25 23:15:00      9.90            X       25.7
    ## 2560  02336313 2011-05-13 04:00:00      0.98          A e       23.0
    ## 2561  02336240 2011-05-09 20:30:00     12.00            A       22.8
    ## 2562  02337170 2011-05-27 09:45:00   3550.00          A e       20.7
    ## 2563  02337170 2011-05-02 21:15:00   5010.00          A e       17.2
    ## 2564  02336728 2011-05-13 17:00:00     12.00          A e       23.4
    ## 2565  02203700 2011-05-22 21:00:00      3.90            E       26.2
    ## 2566  02336728 2011-05-15 22:30:00     11.00          A e       18.9
    ## 2567  02336240 2011-05-31 07:15:00     11.00          A e       23.2
    ## 2568  02336313 2011-05-24 02:00:00        NA          A e       23.8
    ## 2569 021989773 2011-05-27 13:00:00  56300.00            X       25.8
    ## 2570  02336300 2011-05-06 10:30:00     40.00            A       14.8
    ## 2571  02336313 2011-05-07 15:45:00      1.10            A       17.9
    ## 2572  02336120 2011-05-03 03:15:00     16.00          A e       21.2
    ## 2573  02336526 2011-05-31 12:30:00      4.80            A       22.5
    ## 2574  02336728 2011-05-26 12:00:00      7.80            X       21.2
    ## 2575  02203700 2011-05-11 14:15:00      4.60            X       21.0
    ## 2576  02336526 2011-05-26 17:15:00      2.80          A e       23.4
    ## 2577  02336120 2011-05-31 07:15:00     12.00            X       24.0
    ## 2578 021989773 2011-05-21 17:15:00   6810.00          A e       23.7
    ## 2579  02203700 2011-05-18 19:30:00      4.20            X       18.4
    ## 2580  02336360 2011-05-20 09:15:00     10.00            A       17.3
    ## 2581  02337170 2011-05-18 11:45:00   2790.00            E       12.7
    ## 2582  02337170 2011-05-18 18:00:00   3400.00            A       13.6
    ## 2583  02336300 2011-05-22 09:15:00     23.00            A       21.2
    ## 2584  02336360 2011-05-20 16:15:00      9.80            A       18.4
    ## 2585  02336360 2011-05-12 22:00:00     11.00            X       25.3
    ## 2586  02336300 2011-05-13 15:30:00     26.00            E       22.5
    ## 2587  02336728 2011-05-25 05:30:00      8.60          A e       22.2
    ## 2588  02336240 2011-05-13 19:30:00     11.00            X       24.7
    ## 2589  02336313 2011-05-22 11:45:00      1.30            E       19.3
    ## 2590  02336120 2011-05-03 18:15:00     17.00            A       21.6
    ## 2591  02336313 2011-05-23 04:00:00      0.87            A       23.0
    ## 2592  02336360 2011-05-03 11:15:00     13.00            A       19.9
    ## 2593  02336728 2011-05-27 13:15:00    442.00            X         NA
    ## 2594 021989773 2011-05-26 20:15:00 -42000.00            E       26.6
    ## 2595  02336120 2011-05-20 21:15:00     13.00            A       21.8
    ## 2596  02336360 2011-05-16 07:45:00     11.00            A       17.4
    ## 2597  02336240 2011-05-31 07:45:00     11.00          A e       23.1
    ## 2598  02203700 2011-05-09 13:45:00      4.90            A       18.5
    ## 2599  02336120 2011-05-21 03:00:00     12.00            A       20.8
    ## 2600  02336360 2011-05-19 14:45:00     10.00            A       15.1
    ## 2601  02336360 2011-05-14 07:00:00     11.00            A       21.6
    ## 2602  02336728 2011-05-26 14:30:00      7.80            E       21.6
    ## 2603  02336120 2011-05-14 04:30:00     13.00            A       22.0
    ## 2604  02203700 2011-05-17 17:30:00        NA            E       16.9
    ## 2605  02336410 2011-05-14 12:30:00     17.00            E       21.0
    ## 2606  02203700 2011-05-09 06:45:00      4.90            E       19.1
    ## 2607  02336360 2011-05-15 18:45:00     10.00            A       19.4
    ## 2608 021989773 2011-05-22 22:45:00  44500.00            A       24.9
    ## 2609 021989773 2011-05-29 01:45:00  61300.00            A       26.6
    ## 2610  02203700 2011-05-03 08:45:00      5.80            E         NA
    ## 2611  02203700 2011-05-02 01:00:00      6.10            A       21.9
    ## 2612  02336526 2011-05-29 03:15:00      6.90            A       23.9
    ## 2613  02203700 2011-05-19 00:15:00      4.00            A       18.1
    ## 2614 021989773 2011-05-23 13:15:00 -11700.00            E       24.5
    ## 2615  02203700 2011-05-05 22:00:00      6.10            A       20.4
    ## 2616  02336410 2011-05-07 19:00:00     22.00            A       19.1
    ## 2617  02336240 2011-05-30 19:15:00     12.00            X       26.0
    ## 2618  02336360 2011-05-31 09:45:00      6.00            E       23.7
    ## 2619  02336728 2011-05-17 12:15:00     12.00            A       15.3
    ## 2620  02336728 2011-05-21 00:45:00     10.00            A       21.5
    ## 2621  02203700 2011-05-03 00:15:00      6.10            A       22.6
    ## 2622  02336728 2011-05-21 23:00:00     10.00            A       23.9
    ## 2623  02203700 2011-05-06 19:00:00      5.60          A e       20.6
    ## 2624 021989773 2011-05-20 07:15:00  77600.00          A e       23.2
    ## 2625  02336728 2011-05-04 18:15:00     47.00          A e       18.1
    ## 2626  02336120 2011-05-11 05:15:00     15.00            X       22.2
    ## 2627  02336240 2011-05-02 22:15:00     13.00            E       21.9
    ## 2628  02336120 2011-05-08 10:15:00     17.00            X       17.1
    ## 2629  02337170 2011-05-21 07:00:00   3580.00            X       15.0
    ## 2630  02336728 2011-05-26 02:45:00      8.20            X       23.8
    ## 2631  02203655 2011-05-04 18:00:00     26.00            X       17.5
    ## 2632  02203700 2011-05-02 12:45:00      6.10            A       18.2
    ## 2633  02336120 2011-05-22 23:30:00     11.00            A       24.9
    ## 2634  02336526 2011-05-26 05:30:00      3.50            A       23.7
    ## 2635  02336240 2011-05-15 05:15:00      9.90          A e       20.0
    ## 2636  02337170 2011-05-09 14:00:00   1370.00            A       18.2
    ## 2637  02336410 2011-05-21 09:45:00     14.00          A e       19.4
    ## 2638  02336526 2011-05-21 00:45:00      3.60          A e       22.5
    ## 2639  02336313 2011-05-05 23:15:00      1.20            X       18.5
    ## 2640  02336526 2011-05-10 22:00:00      6.40            A       25.9
    ## 2641  02203655 2011-05-05 05:15:00     18.00            A       16.8
    ## 2642  02337170 2011-05-04 07:30:00   6340.00            A       15.2
    ## 2643  02336728 2011-05-03 06:45:00     15.00          A e       19.9
    ## 2644  02336526 2011-05-29 16:45:00      5.90          A e       22.7
    ## 2645  02203655 2011-05-19 13:30:00      8.80          A e       14.6
    ## 2646  02336360 2011-05-02 18:30:00        NA            E       21.5
    ## 2647  02336728 2011-05-19 21:30:00     11.00          A e       20.0
    ## 2648  02336300 2011-05-14 21:45:00     26.00            X       24.0
    ## 2649 021989773 2011-05-18 14:30:00 -16500.00            A       23.1
    ## 2650  02336410 2011-05-26 09:30:00     11.00            A       23.0
    ## 2651  02336526 2011-05-01 13:00:00      4.40            E         NA
    ## 2652  02336410 2011-05-17 12:00:00     16.00          A e       15.5
    ## 2653  02336313 2011-05-14 23:00:00      0.98            A       22.2
    ## 2654  02203655 2011-05-25 22:15:00      7.50            A       23.4
    ## 2655  02336526 2011-05-13 06:15:00      3.60            X       23.1
    ## 2656  02337170 2011-05-21 08:15:00   3240.00            A       15.0
    ## 2657  02336300 2011-05-25 00:30:00        NA            A       25.6
    ## 2658 021989773 2011-05-28 01:30:00  49900.00            A       26.2
    ## 2659  02336410 2011-05-01 12:15:00     22.00            A       18.2
    ## 2660  02337170 2011-05-31 16:45:00   1270.00            A       24.2
    ## 2661  02203700 2011-05-18 06:45:00      4.20            A       14.6
    ## 2662  02336410 2011-05-19 12:15:00     16.00            A       14.7
    ## 2663  02336410 2011-05-09 21:00:00     20.00            A       22.2
    ## 2664  02203700 2011-05-17 00:15:00      7.00            A       18.1
    ## 2665  02336526 2011-05-29 03:00:00      6.90            A       24.0
    ## 2666  02336526 2011-05-14 23:45:00      3.80            A       23.3
    ## 2667  02336313 2011-05-23 10:15:00      0.93            A       20.5
    ## 2668  02336728 2011-05-29 04:00:00     24.00            A       21.9
    ## 2669  02336313 2011-05-21 04:00:00      0.93          A e       20.5
    ## 2670  02203655 2011-05-22 15:30:00      8.50            E       20.4
    ## 2671  02336240 2011-05-31 19:30:00     11.00            A       26.6
    ## 2672  02336728 2011-05-30 13:00:00     15.00          A e       22.9
    ## 2673  02336240 2011-05-06 00:30:00     14.00            E       16.8
    ## 2674  02336313 2011-05-17 16:00:00      1.10            X       16.3
    ## 2675  02337170 2011-05-17 19:45:00   2950.00            A       15.3
    ## 2676  02336120 2011-05-14 00:15:00     13.00            X       23.2
    ## 2677  02336300 2011-05-20 16:15:00     24.00            A       19.3
    ## 2678 021989773 2011-05-24 00:00:00  34400.00            A       25.2
    ## 2679 021989773 2011-05-02 17:00:00  58300.00          A e       23.8
    ## 2680  02203655 2011-05-21 06:15:00      7.80            X       20.0
    ## 2681 021989773 2011-05-09 18:00:00 -18700.00            X       22.9
    ## 2682  02336410 2011-05-31 04:15:00     13.00            X       24.8
    ## 2683  02336526 2011-05-23 05:00:00      4.20            A       23.5
    ## 2684  02336526 2011-05-11 19:15:00      4.00          A e       24.9
    ## 2685  02336300 2011-05-17 05:15:00     27.00            A       16.7
    ## 2686  02336240 2011-05-10 01:30:00     11.00            A       21.5
    ## 2687  02336728 2011-05-24 12:30:00      8.90            A       20.6
    ## 2688  02336526 2011-05-15 00:45:00      3.80            X       23.0
    ## 2689  02336240 2011-05-21 21:15:00      9.20            A       23.5
    ## 2690  02336300 2011-05-16 02:00:00     27.00            A       18.2
    ## 2691  02336313 2011-05-31 23:15:00      0.65            E       26.6
    ## 2692  02336300 2011-05-24 19:30:00     20.00            A       26.0
    ## 2693  02203700 2011-05-23 20:15:00      3.70            A       25.6
    ## 2694  02336728 2011-05-23 09:45:00      8.90            E       20.5
    ## 2695  02336410 2011-05-17 14:45:00     16.00          A e       15.5
    ## 2696  02337170 2011-05-04 06:45:00   6130.00            E       15.2
    ## 2697  02336410 2011-05-24 16:00:00     13.00            A       22.5
    ## 2698 021989773 2011-05-11 19:45:00 -45900.00            E       23.7
    ## 2699  02336526 2011-05-24 17:45:00      3.10            A       23.3
    ## 2700  02336300 2011-05-25 23:30:00     19.00            A       26.6
    ## 2701 021989773 2011-05-15 00:00:00 -25400.00            A         NA
    ## 2702  02336526 2011-05-24 14:45:00      3.10            X       21.6
    ## 2703  02336120 2011-05-23 17:15:00     11.00            A       22.5
    ## 2704  02336120 2011-05-06 02:15:00     21.00          A e       17.0
    ## 2705 021989773 2011-05-30 14:00:00  75500.00            E       26.9
    ## 2706 021989773 2011-05-07 19:45:00  82300.00            E       23.0
    ## 2707  02203655 2011-05-28 19:45:00     17.00            A       22.1
    ## 2708  02336728 2011-05-18 03:15:00     11.00            A       15.2
    ## 2709  02336360 2011-05-05 22:45:00     16.00            E       18.0
    ## 2710  02336240 2011-05-17 06:45:00     11.00          A e       15.7
    ## 2711  02336120 2011-05-14 21:00:00     13.00            E       22.7
    ## 2712  02203655 2011-05-29 13:30:00     12.00            A         NA
    ## 2713  02336240 2011-05-12 02:45:00     11.00            A       22.9
    ## 2714  02336728 2011-05-14 16:15:00     12.00            X       21.4
    ## 2715  02336313 2011-05-05 19:15:00        NA            A       18.2
    ## 2716 021989773 2011-05-11 03:15:00 -54800.00            A       23.1
    ## 2717  02336526 2011-05-31 07:00:00      5.20            A       24.2
    ## 2718  02203700 2011-05-04 19:45:00     26.00            A       20.8
    ## 2719  02336240 2011-05-01 06:45:00     13.00            X       18.1
    ## 2720  02336300 2011-05-06 09:45:00     41.00            A       15.1
    ## 2721  02203700 2011-05-06 03:15:00      5.80            A       17.6
    ## 2722  02336526 2011-05-01 07:00:00        NA            E       19.1
    ## 2723  02203700 2011-05-05 14:00:00     22.00            E       16.6
    ## 2724  02336120 2011-05-19 12:45:00     12.00          A e       14.9
    ## 2725  02336410 2011-05-08 00:00:00     22.00            A       19.0
    ## 2726  02336728 2011-05-27 22:45:00     74.00            E       22.1
    ## 2727  02336360 2011-05-24 14:30:00      8.70            X       21.5
    ## 2728  02336360 2011-05-25 07:00:00      8.70            A       22.7
    ## 2729  02336728 2011-05-24 18:45:00      8.90            A       24.7
    ## 2730 021989773 2011-05-15 01:15:00  62000.00            A       24.3
    ## 2731  02203700 2011-05-14 09:00:00      4.20          A e       20.6
    ## 2732  02336360 2011-05-01 06:00:00     14.00            E       19.1
    ## 2733  02336120 2011-05-27 01:45:00    437.00            E       22.6
    ## 2734  02336240 2011-05-08 22:30:00     12.00            A       20.3
    ## 2735  02336526 2011-05-09 07:15:00      4.20          A e       19.8
    ## 2736  02336300 2011-05-12 17:45:00     27.00            E       24.6
    ## 2737 021989773 2011-05-25 04:15:00 -49400.00            X       25.3
    ## 2738  02336526 2011-05-16 14:00:00      3.80            E       16.4
    ## 2739  02336120 2011-05-15 19:45:00     13.00            A       19.1
    ## 2740  02336120 2011-05-10 15:00:00     15.00          A e       20.3
    ## 2741  02203700 2011-05-14 16:15:00      4.40            X       21.4
    ## 2742  02337170 2011-05-03 19:15:00   7220.00            A       13.5
    ## 2743  02336360 2011-05-23 01:00:00      9.80            X       24.0
    ## 2744  02336300 2011-05-02 16:30:00     31.00            X       20.7
    ## 2745  02336120 2011-05-07 18:45:00     18.00            A       18.3
    ## 2746  02337170 2011-05-20 17:30:00   2520.00            A       15.8
    ## 2747  02336120 2011-05-27 11:45:00   1030.00            A       20.6
    ## 2748  02336526 2011-05-22 07:45:00      3.50            A       21.7
    ## 2749  02337170 2011-05-05 03:30:00   6500.00            A       14.3
    ## 2750  02336240 2011-05-17 16:00:00     11.00            A       15.5
    ## 2751  02336300 2011-05-07 03:15:00     39.00            X       17.3
    ## 2752  02336410 2011-05-05 04:00:00     42.00          A e       17.5
    ## 2753  02203655 2011-05-20 23:45:00      8.50            A       20.3
    ## 2754  02336526 2011-05-10 21:00:00      6.40            E       25.4
    ## 2755  02336526 2011-05-27 14:30:00     55.00            A       20.1
    ## 2756  02336728 2011-05-27 12:15:00    894.00          A e       19.6
    ## 2757  02336728 2011-05-03 01:15:00     15.00          A e       21.0
    ## 2758  02337170 2011-05-20 23:45:00   4710.00            X       16.6
    ## 2759  02337170 2011-05-20 15:30:00   2290.00            E       15.0
    ## 2760  02336313 2011-05-30 21:45:00      0.73            A       26.4
    ## 2761  02336728 2011-05-15 15:30:00     11.00            X       19.3
    ## 2762  02337170 2011-05-03 18:15:00   7180.00            A       14.1
    ## 2763  02336728 2011-05-25 12:15:00      8.20            A       20.5
    ## 2764  02203700 2011-05-01 08:45:00      6.10            X       17.6
    ## 2765  02337170 2011-05-07 09:30:00   5980.00            A       14.1
    ## 2766  02336728 2011-05-27 05:45:00    195.00            A       22.3
    ## 2767  02203700 2011-05-08 18:30:00      5.60            A       21.7
    ## 2768  02336300 2011-05-11 19:15:00     30.00            A       25.5
    ## 2769  02336300 2011-05-18 11:45:00     28.00            E       14.0
    ## 2770  02336120 2011-05-28 19:30:00        NA          A e       24.2
    ## 2771  02336526 2011-05-28 17:30:00      8.90            A       22.5
    ## 2772  02336300 2011-05-15 00:00:00     26.00            A       23.0
    ## 2773  02336360 2011-05-08 13:30:00     13.00            A       16.7
    ## 2774  02336300 2011-05-15 06:00:00     27.00            E       20.6
    ## 2775  02336240 2011-05-18 00:00:00     11.00            E       15.7
    ## 2776  02337170 2011-05-17 16:00:00   2510.00            E       15.9
    ## 2777  02336360 2011-05-27 04:15:00        NA            A       22.3
    ## 2778  02336240 2011-05-25 04:30:00      7.90            E       22.8
    ## 2779  02336360 2011-05-30 08:00:00      6.90            E       23.7
    ## 2780  02336360 2011-05-06 11:00:00     15.00            E       15.1
    ## 2781 021989773 2011-05-15 16:15:00  66000.00            A       24.3
    ## 2782 021989773 2011-05-18 20:15:00  38200.00            A       23.6
    ## 2783  02336120 2011-05-06 19:30:00     19.00            X       18.1
    ## 2784  02336526 2011-05-05 03:45:00      6.90            A       16.9
    ## 2785  02336728 2011-05-21 21:45:00     10.00          A e       24.2
    ## 2786  02336300 2011-05-20 05:45:00     25.00            E       18.3
    ## 2787  02337170 2011-05-14 21:45:00   5610.00            A       15.7
    ## 2788  02336410 2011-05-25 07:45:00     13.00            A       22.5
    ## 2789  02336120 2011-05-12 12:00:00     14.00            A       21.3
    ## 2790  02336313 2011-05-29 01:45:00      0.77            A       23.9
    ## 2791  02336300 2011-05-01 14:00:00     32.00            E       18.4
    ## 2792  02336240 2011-05-22 11:15:00      8.90          A e       19.6
    ## 2793  02336313 2011-05-07 23:15:00      0.98            A       20.4
    ## 2794  02337170 2011-05-30 08:45:00   1400.00            A       23.1
    ## 2795  02336360 2011-05-26 10:00:00      8.40            A       22.8
    ## 2796  02203700 2011-05-02 10:30:00      5.80            A       18.5
    ## 2797 021989773 2011-05-12 04:00:00        NA          A e       23.4
    ## 2798 021989773 2011-05-17 19:30:00  39100.00            A       23.8
    ## 2799  02203655 2011-05-06 08:15:00     12.00            X       15.6
    ## 2800  02336313 2011-05-10 23:45:00      0.98            A       24.6
    ## 2801  02336300 2011-05-25 02:45:00     20.00            A       24.6
    ## 2802  02336313 2011-05-15 04:15:00      0.93            E       20.8
    ## 2803 021989773 2011-05-25 01:15:00  28600.00            A       25.5
    ## 2804  02336410 2011-05-03 21:00:00        NA            A       22.0
    ## 2805  02336313 2011-06-01 00:30:00      0.65            X       26.4
    ## 2806  02336728 2011-05-27 07:00:00    268.00          A e         NA
    ## 2807  02336300 2011-05-24 00:45:00     21.00          A e       25.0
    ## 2808  02336526 2011-05-18 11:30:00      3.60            A       13.6
    ## 2809  02336240 2011-05-01 07:30:00     13.00            A       18.0
    ## 2810  02337170 2011-05-23 19:15:00   1730.00            A       21.9
    ## 2811  02336313 2011-05-01 21:00:00      1.00          A e       22.7
    ## 2812  02336360 2011-05-31 07:00:00      6.30          A e       24.2
    ## 2813  02336120 2011-05-05 15:15:00     24.00            A       14.9
    ## 2814  02336240 2011-05-18 13:30:00     11.00            A       13.6
    ## 2815  02336240 2011-05-05 23:00:00     15.00          A e       17.2
    ## 2816  02336410 2011-05-30 18:30:00     14.00            A       25.8
    ## 2817  02336300 2011-05-06 22:15:00     37.00          A e       18.9
    ## 2818  02336360 2011-05-12 13:00:00     11.00            E       21.2
    ## 2819  02203700 2011-05-06 08:45:00      5.60            X       15.0
    ## 2820  02336120 2011-05-25 19:45:00      9.90            X       24.6
    ## 2821  02336360 2011-05-26 08:00:00      8.40            A       23.2
    ## 2822  02336526 2011-05-12 11:00:00      3.80            E       21.3
    ## 2823  02336120 2011-05-27 21:00:00     88.00            A       22.6
    ## 2824  02203655 2011-05-25 20:45:00      7.50            E       23.4
    ## 2825  02203700 2011-05-17 03:15:00      5.30            A       16.9
    ## 2826  02336120 2011-05-20 11:30:00     12.00            A       16.9
    ## 2827  02336300 2011-05-20 04:45:00     24.00            E       18.5
    ## 2828  02336240 2011-05-14 21:45:00     10.00            X       22.6
    ## 2829  02336120 2011-05-01 11:30:00     17.00          A e       18.1
    ## 2830  02203700 2011-05-23 11:15:00      3.70            E       20.1
    ## 2831  02337170 2011-05-26 05:15:00   1750.00            X       20.3
    ## 2832  02203700 2011-05-25 01:00:00      3.70            A       24.5
    ## 2833  02336728 2011-05-16 03:30:00     11.00            A       17.6
    ## 2834  02336526 2011-05-12 03:15:00      3.60            X       24.6
    ## 2835  02203700 2011-05-20 17:15:00      4.00            A       20.6
    ## 2836 021989773 2011-05-16 07:15:00  20500.00            X       23.9
    ## 2837  02336120 2011-05-18 18:00:00     13.00            A         NA
    ## 2838  02336120 2011-05-26 02:30:00     11.00            A       24.7
    ## 2839  02336240 2011-05-02 01:30:00        NA            A       20.4
    ## 2840  02336410 2011-05-20 03:45:00     15.00            A       18.2
    ## 2841  02336410 2011-05-29 09:00:00     19.00            E       22.5
    ## 2842  02337170 2011-05-07 12:15:00   5550.00            A       13.8
    ## 2843  02336728 2011-05-25 16:00:00      8.20            A       22.6
    ## 2844  02203700 2011-05-06 01:00:00      5.60            X       18.8
    ## 2845  02336526 2011-05-27 14:00:00     63.00          A e         NA
    ## 2846  02203655 2011-05-06 03:00:00     13.00            E       17.6
    ## 2847  02336360 2011-05-26 21:15:00      8.40          A e       25.6
    ## 2848  02203700 2011-05-24 16:45:00      3.90            E       23.3
    ## 2849  02203700 2011-05-20 04:15:00      4.00            X       18.8
    ## 2850  02336526 2011-05-09 16:00:00        NA            E       19.7
    ## 2851  02336728 2011-05-26 18:15:00      7.80            X       24.4
    ## 2852  02336360 2011-05-29 20:00:00      7.80            E       25.6
    ## 2853  02203655 2011-05-24 07:00:00      7.50            X       22.4
    ## 2854  02203700 2011-05-10 17:15:00      4.90          A e       23.4
    ## 2855  02336300 2011-05-19 09:30:00     26.00            A       15.4
    ## 2856  02336240 2011-05-16 22:00:00     11.00            E       17.7
    ## 2857 021989773 2011-05-21 04:45:00 -39400.00          A e       23.7
    ## 2858  02336526 2011-05-05 01:15:00      7.40            A       18.3
    ## 2859  02336300 2011-05-20 18:45:00     25.00            A       21.8
    ## 2860  02336410 2011-05-14 11:00:00     17.00            A       21.1
    ## 2861  02336526 2011-05-13 19:15:00      3.60            A       24.0
    ## 2862  02336313 2011-05-06 01:00:00      1.20            E       17.7
    ## 2863  02336120 2011-05-02 22:15:00     17.00            E       22.2
    ## 2864  02336410 2011-05-21 16:30:00     14.00            A       20.5
    ## 2865  02336410 2011-05-31 14:45:00     12.00            A       23.7
    ## 2866  02336360 2011-05-30 22:15:00      6.60            A       27.1
    ## 2867  02336526 2011-05-13 00:15:00      3.80            E       25.8
    ## 2868  02336526 2011-05-09 09:45:00      4.40            A       18.9
    ## 2869 021989773 2011-05-05 01:00:00 -61800.00            E       23.8
    ## 2870  02337170 2011-05-09 00:00:00   1400.00            A       18.7
    ## 2871  02336410 2011-05-23 23:00:00     14.00          A e       24.5
    ## 2872  02336300 2011-05-16 15:00:00     26.00            X       16.8
    ## 2873  02336360 2011-05-14 08:15:00     11.00            A       21.4
    ## 2874  02337170 2011-05-30 12:45:00   1360.00            A       22.6
    ## 2875  02203700 2011-05-22 20:15:00      3.90          A e       26.0
    ## 2876  02336313 2011-05-10 21:45:00      0.98            A       25.0
    ## 2877  02336313 2011-05-24 11:15:00      0.93          A e       20.6
    ## 2878  02203655 2011-05-03 07:45:00     10.00            A       20.4
    ## 2879  02336120 2011-05-17 02:30:00     13.00            A       17.2
    ## 2880  02336360 2011-05-11 00:15:00     12.00            A       23.8
    ## 2881  02337170 2011-05-17 23:45:00   3370.00            A       14.9
    ## 2882  02336526 2011-05-06 11:15:00      5.20            A       14.1
    ## 2883  02337170 2011-05-03 13:00:00   5100.00            E         NA
    ## 2884 021989773 2011-05-09 12:00:00   1200.00          A e       22.4
    ## 2885  02336526 2011-05-19 01:15:00      3.80            A       17.4
    ## 2886  02336360 2011-05-03 13:30:00     13.00            A       19.8
    ## 2887  02336300 2011-05-17 02:15:00     28.00            X       17.3
    ## 2888  02336410 2011-05-25 04:45:00     12.00            A       23.2
    ## 2889  02336120 2011-05-30 21:15:00     14.00            A       26.6
    ## 2890  02336526 2011-05-04 22:30:00      8.30            E       19.9
    ## 2891  02203655 2011-05-31 04:30:00      9.20            E       24.8
    ## 2892  02336360 2011-05-17 06:00:00     11.00            X       16.4
    ## 2893 021989773 2011-05-11 17:00:00 -82500.00            X       23.5
    ## 2894  02336410 2011-05-26 05:00:00     11.00            A       23.7
    ## 2895  02337170 2011-05-27 12:30:00   5540.00            A       20.7
    ## 2896  02203655 2011-05-02 02:45:00     11.00            E       21.0
    ## 2897  02336313 2011-05-24 08:00:00      0.93          A e       21.6
    ## 2898  02336360 2011-05-26 17:30:00      8.10            A       24.3
    ## 2899  02336360 2011-05-20 15:00:00     10.00          A e       17.4
    ## 2900  02336120 2011-05-02 22:45:00     17.00          A e       22.2
    ## 2901  02336300 2011-05-14 00:00:00     27.00            X       23.8
    ## 2902  02336360 2011-05-07 22:00:00     13.00            A       19.6
    ## 2903  02336313 2011-05-08 02:45:00      1.00          A e       18.9
    ## 2904  02336240 2011-05-11 11:30:00     11.00            A       20.5
    ## 2905 021989773 2011-05-27 17:00:00 -31500.00            A       26.5
    ## 2906  02336360 2011-05-18 04:30:00     11.00            A       15.1
    ## 2907  02336300 2011-05-08 10:00:00     34.00          A e       17.1
    ## 2908  02336240 2011-05-31 13:15:00     11.00            E         NA
    ## 2909  02336410 2011-05-23 09:30:00     14.00          A e       21.8
    ## 2910  02336120 2011-05-16 04:45:00     13.00            A       17.7
    ## 2911  02336120 2011-05-21 18:00:00     12.00            A       20.9
    ## 2912 021989773 2011-05-14 19:00:00 -60600.00            A       24.3
    ## 2913  02336240 2011-05-23 13:30:00      8.50            A       20.6
    ## 2914  02337170 2011-05-29 16:15:00   1590.00          A e       21.7
    ## 2915  02336120 2011-05-17 18:45:00     14.00            E       16.3
    ## 2916  02336360 2011-05-31 07:15:00      6.30            X       24.2
    ## 2917  02336728 2011-05-27 03:30:00    333.00            E       22.5
    ## 2918  02336360 2011-05-26 07:30:00      8.40            A       23.2
    ## 2919  02336410 2011-05-08 05:15:00     22.00          A e       18.2
    ## 2920  02336120 2011-05-09 14:45:00     16.00            X       18.9
    ## 2921  02336300 2011-05-25 05:00:00     20.00            A       23.8
    ## 2922  02336120 2011-05-26 16:15:00      8.90            A       23.1
    ## 2923  02336410 2011-05-30 20:45:00     13.00            A       26.5
    ## 2924  02336526 2011-05-16 21:45:00      4.80            A       18.3
    ## 2925  02336300 2011-05-24 12:30:00     21.00            A       21.9
    ## 2926  02336526 2011-05-18 13:15:00      3.80            A       13.6
    ## 2927  02336300 2011-05-11 09:30:00     30.00            A       21.8
    ## 2928  02336240 2011-05-03 05:45:00     12.00            A       20.0
    ## 2929 021989773 2011-05-29 22:45:00 -41900.00            X       27.1
    ## 2930 021989773 2011-05-28 03:45:00  35100.00            A       26.0
    ## 2931  02337170 2011-05-17 22:00:00   3240.00            E       15.1
    ## 2932  02203700 2011-05-14 16:45:00      4.60            E       21.7
    ## 2933  02336120 2011-05-22 20:00:00     11.00            A       23.9
    ## 2934 021989773 2011-05-04 08:45:00  24100.00            A       23.4
    ## 2935  02336300 2011-05-13 00:30:00     27.00            A       25.0
    ## 2936  02336120 2011-05-21 23:15:00     12.00            A       23.5
    ## 2937  02203700 2011-05-15 19:00:00      4.60            X       19.2
    ## 2938  02336526 2011-05-27 18:15:00     29.00          A e       21.8
    ## 2939  02336300 2011-05-09 00:30:00     32.00            A       20.7
    ## 2940 021989773 2011-05-22 07:30:00  88300.00            X       23.9
    ## 2941  02336526 2011-05-23 20:15:00      3.30            A       24.7
    ## 2942  02336360 2011-05-15 23:45:00     11.00            E       18.6
    ## 2943  02336526 2011-05-18 10:45:00      3.60            A       13.8
    ## 2944  02336360 2011-05-12 23:45:00        NA            A       24.6
    ## 2945  02336300 2011-05-19 02:45:00     28.00          A e       16.7
    ## 2946  02336120 2011-05-04 05:45:00    684.00            E       18.1
    ## 2947  02337170 2011-05-15 09:45:00   2630.00            X       15.0
    ## 2948 021989773 2011-05-11 21:00:00 -24100.00            E       23.7
    ## 2949  02336526 2011-05-02 21:30:00      4.20            A       23.5
    ## 2950  02336313 2011-05-18 04:30:00      1.00            E       15.2
    ## 2951  02336300 2011-05-06 11:45:00     41.00            X       14.7
    ## 2952  02336360 2011-05-16 04:30:00     11.00            A       17.8
    ## 2953  02336360 2011-05-05 00:45:00     23.00            A       18.6
    ## 2954  02336410 2011-05-07 11:45:00     22.00            A       15.7
    ## 2955  02336120 2011-05-29 23:15:00     16.00            A       25.8
    ## 2956  02203655 2011-05-22 01:45:00      8.20          A e       21.8
    ## 2957  02336120 2011-05-17 12:30:00     14.00            X       15.3
    ## 2958  02336120 2011-05-10 04:45:00     16.00            A       21.0
    ## 2959  02336728 2011-05-02 18:15:00     16.00            E       22.1
    ## 2960 021989773 2011-05-30 04:30:00  57600.00            E       27.0
    ## 2961  02336300 2011-05-07 13:00:00     36.00            A       15.4
    ## 2962  02337170 2011-05-12 16:15:00   6010.00            X       15.3
    ## 2963  02336526 2011-05-06 08:45:00      5.50            X       14.9
    ## 2964  02203700 2011-05-25 18:00:00      3.70            A       24.5
    ## 2965 021989773 2011-05-01 13:15:00  24900.00            A       23.6
    ## 2966  02337170 2011-05-10 21:00:00   4180.00            A       20.9
    ## 2967  02203700 2011-05-03 07:45:00      6.10            E       19.6
    ## 2968  02336410 2011-05-28 21:30:00     24.00            E       24.4
    ## 2969  02336240 2011-05-30 13:45:00     12.00            E       22.4
    ## 2970  02336526 2011-05-31 14:30:00      4.60            A       22.9
    ## 2971  02336313 2011-05-25 00:30:00      0.87            A       24.5
    ## 2972  02336728 2011-05-27 15:30:00    212.00            X       20.0
    ## 2973  02203655 2011-05-07 16:30:00     11.00            A       16.6
    ## 2974  02336360 2011-05-09 04:00:00     12.00            A       19.6
    ## 2975  02336360 2011-05-07 04:30:00     14.00            A       17.3
    ## 2976  02336410 2011-05-17 01:30:00     16.00            A       17.3
    ## 2977  02336300 2011-05-17 04:00:00     27.00            A       16.9
    ## 2978 021989773 2011-05-10 01:15:00 -21000.00            X       22.9
    ## 2979  02337170 2011-05-03 19:45:00   7200.00            E       13.3
    ## 2980  02336410 2011-05-16 07:45:00     16.00            A       17.4
    ## 2981  02337170 2011-05-12 10:45:00   4050.00          A e       16.3
    ## 2982  02336313 2011-05-20 05:00:00      0.98            E       18.1
    ## 2983  02336240 2011-05-19 18:30:00      9.90            A       19.7
    ## 2984  02203655 2011-05-31 21:45:00      9.20            X       24.4
    ## 2985  02336240 2011-05-09 14:45:00     12.00            A       19.0
    ## 2986  02336120 2011-05-15 13:45:00     13.00            A       18.7
    ## 2987  02336300 2011-05-11 06:00:00     30.00            X       22.7
    ## 2988  02336360 2011-05-19 02:45:00     10.00            A       16.2
    ## 2989  02203655 2011-05-06 20:45:00     12.00            A       17.3
    ## 2990  02203700 2011-05-20 23:45:00      5.60            A       22.9
    ## 2991  02336240 2011-05-04 12:45:00     53.00            A       15.8
    ## 2992  02336728 2011-05-04 04:15:00    363.00            X       18.5
    ## 2993  02336300 2011-05-03 02:30:00     31.00            A       21.7
    ## 2994  02336313 2011-05-22 06:30:00      0.93            A       20.9
    ## 2995  02203655 2011-05-07 14:45:00     11.00            X       15.5
    ## 2996  02337170 2011-05-27 02:30:00   1710.00            E       21.0
    ## 2997  02337170 2011-05-29 01:30:00   2520.00            A       21.6
    ## 2998  02336526 2011-05-07 02:45:00      4.80            A       18.7
    ## 2999  02336526 2011-05-14 17:45:00      3.80            E       21.9
    ## 3000  02336360 2011-05-17 05:00:00     11.00            A       16.5
    ##      pH_Inst DO_Inst DO_mgmL
    ## 1        7.2     8.1  0.0081
    ## 2        7.2     7.1  0.0071
    ## 3        6.9     7.6  0.0076
    ## 4          7     6.2  0.0062
    ## 5        7.1     7.6  0.0076
    ## 6        7.2     8.1  0.0081
    ## 7        7.3     8.5  0.0085
    ## 8        7.3     7.5  0.0075
    ## 9        6.6     7.6  0.0076
    ## 10       6.4     7.2  0.0072
    ## 11       7.2     7.8  0.0078
    ## 12       7.1     8.3  0.0083
    ## 13       7.1     7.5  0.0075
    ## 14       6.2     7.1  0.0071
    ## 15       6.7     9.9  0.0099
    ## 16         7     7.5  0.0075
    ## 17       7.1     7.6  0.0076
    ## 18       7.2     9.4  0.0094
    ## 19         7     9.0  0.0090
    ## 20       7.2     8.4  0.0084
    ## 21       7.1     7.0  0.0070
    ## 22       6.8     7.7  0.0077
    ## 23       7.1     7.5  0.0075
    ## 24       7.4     5.8  0.0058
    ## 25       7.6     7.7  0.0077
    ## 26       7.2     8.4  0.0084
    ## 27       7.4     5.7  0.0057
    ## 28       7.2     7.2  0.0072
    ## 29       7.3      NA      NA
    ## 30       7.2     8.9  0.0089
    ## 31       7.2     7.5  0.0075
    ## 32       6.9     5.9  0.0059
    ## 33       7.1     9.0  0.0090
    ## 34       6.8     7.8  0.0078
    ## 35       7.5     7.6  0.0076
    ## 36       7.3     5.6  0.0056
    ## 37       6.9     6.7  0.0067
    ## 38      <NA>     7.8  0.0078
    ## 39       6.8     4.2  0.0042
    ## 40         7     7.7  0.0077
    ## 41       7.3      NA      NA
    ## 42       7.5     6.9  0.0069
    ## 43       7.1     8.0  0.0080
    ## 44       7.1     6.9  0.0069
    ## 45       7.1     8.4  0.0084
    ## 46         7     7.3  0.0073
    ## 47         7     5.6  0.0056
    ## 48         7     6.2  0.0062
    ## 49       7.1     7.6  0.0076
    ## 50       7.4     8.8  0.0088
    ## 51       7.3     7.9  0.0079
    ## 52       7.3     8.3  0.0083
    ## 53       6.8     9.3  0.0093
    ## 54       7.4     8.6  0.0086
    ## 55       7.4     7.7  0.0077
    ## 56       6.9     8.6  0.0086
    ## 57       7.4     9.5  0.0095
    ## 58       6.8     4.2  0.0042
    ## 59       6.8     7.2  0.0072
    ## 60       7.3     6.6  0.0066
    ## 61      <NA>     8.3  0.0083
    ## 62         7     6.9  0.0069
    ## 63         7     7.8  0.0078
    ## 64         7     6.4  0.0064
    ## 65       7.3     8.5  0.0085
    ## 66       7.2     8.2  0.0082
    ## 67       7.1     7.5  0.0075
    ## 68       7.1     7.6  0.0076
    ## 69       7.2     8.4  0.0084
    ## 70         7     8.0  0.0080
    ## 71       7.3     8.6  0.0086
    ## 72         7     7.4  0.0074
    ## 73         9    11.0  0.0110
    ## 74       7.3     7.5  0.0075
    ## 75       6.4     7.2  0.0072
    ## 76       6.7      NA      NA
    ## 77       7.2     8.6  0.0086
    ## 78       7.2     7.4  0.0074
    ## 79      <NA>     6.3  0.0063
    ## 80       7.4     6.0  0.0060
    ## 81       7.3     7.7  0.0077
    ## 82       7.2     7.1  0.0071
    ## 83       6.4     6.5  0.0065
    ## 84         7     7.3  0.0073
    ## 85       7.2     7.1  0.0071
    ## 86       7.3     9.0  0.0090
    ## 87         7     8.8  0.0088
    ## 88       6.8     9.8  0.0098
    ## 89       6.9     9.0  0.0090
    ## 90       6.9     5.8  0.0058
    ## 91         7     6.8  0.0068
    ## 92       7.4     5.5  0.0055
    ## 93       7.5     5.4  0.0054
    ## 94       7.1     7.6  0.0076
    ## 95       6.9     6.5  0.0065
    ## 96       7.2     8.0  0.0080
    ## 97       7.1     7.3  0.0073
    ## 98       7.1     8.8  0.0088
    ## 99       6.8     6.8  0.0068
    ## 100      8.3     8.3  0.0083
    ## 101      7.3     9.5  0.0095
    ## 102      6.9    10.1  0.0101
    ## 103      6.8      NA      NA
    ## 104        7     8.2  0.0082
    ## 105      7.4     5.2  0.0052
    ## 106      7.4     8.6  0.0086
    ## 107      7.1     8.0  0.0080
    ## 108      6.8     7.2  0.0072
    ## 109      7.2     8.9  0.0089
    ## 110     <NA>     8.2  0.0082
    ## 111      7.1     6.2  0.0062
    ## 112      7.5     8.7  0.0087
    ## 113        7     8.4  0.0084
    ## 114      6.8    10.6  0.0106
    ## 115      7.1     8.5  0.0085
    ## 116      7.1     8.8  0.0088
    ## 117      6.5     6.6  0.0066
    ## 118      7.1     7.8  0.0078
    ## 119      6.8     7.3  0.0073
    ## 120      7.1     7.2  0.0072
    ## 121      7.2     7.3  0.0073
    ## 122      7.2     7.1  0.0071
    ## 123      6.5     8.3  0.0083
    ## 124      7.5     5.5  0.0055
    ## 125      7.2     7.6  0.0076
    ## 126      7.3     7.1  0.0071
    ## 127      7.1     7.9  0.0079
    ## 128      6.7     8.2  0.0082
    ## 129      7.4     6.7  0.0067
    ## 130      7.3     8.0  0.0080
    ## 131      6.8     9.4  0.0094
    ## 132      7.3     7.6  0.0076
    ## 133        7     8.0  0.0080
    ## 134      6.9     8.2  0.0082
    ## 135      7.2     8.1  0.0081
    ## 136      6.8     9.3  0.0093
    ## 137      7.1     7.8  0.0078
    ## 138      7.6     9.6  0.0096
    ## 139      7.1     6.1  0.0061
    ## 140        7     9.0  0.0090
    ## 141        7      NA      NA
    ## 142      9.1    11.4  0.0114
    ## 143      6.8     6.8  0.0068
    ## 144      7.6     6.1  0.0061
    ## 145      7.1     7.8  0.0078
    ## 146      7.2     7.7  0.0077
    ## 147      7.3     8.6  0.0086
    ## 148      7.2     7.4  0.0074
    ## 149      7.2     6.7  0.0067
    ## 150      6.9     6.7  0.0067
    ## 151      7.1     8.6  0.0086
    ## 152      7.4    10.5  0.0105
    ## 153      7.3     8.3  0.0083
    ## 154      7.4     6.7  0.0067
    ## 155      7.5     5.9  0.0059
    ## 156      7.1     8.3  0.0083
    ## 157      7.4     8.4  0.0084
    ## 158      7.4     8.4  0.0084
    ## 159      7.2     8.0  0.0080
    ## 160      7.4     6.0  0.0060
    ## 161      6.8    10.6  0.0106
    ## 162      7.2     7.7  0.0077
    ## 163        7     6.8  0.0068
    ## 164      7.3     9.5  0.0095
    ## 165      7.4     5.8  0.0058
    ## 166      7.7     7.7  0.0077
    ## 167      7.4     6.2  0.0062
    ## 168      7.3     8.7  0.0087
    ## 169      7.4     6.7  0.0067
    ## 170      7.3     8.6  0.0086
    ## 171      6.9     8.0  0.0080
    ## 172      7.1     8.2  0.0082
    ## 173      6.9     8.3  0.0083
    ## 174      7.1     7.9  0.0079
    ## 175      6.8     7.4  0.0074
    ## 176      7.5     7.0  0.0070
    ## 177        7     7.5  0.0075
    ## 178      7.1     6.2  0.0062
    ## 179      7.2     6.8  0.0068
    ## 180      7.4     6.3  0.0063
    ## 181     <NA>     8.0  0.0080
    ## 182      6.9     7.1  0.0071
    ## 183      6.8     4.3  0.0043
    ## 184      6.9     5.7  0.0057
    ## 185      8.4    11.1  0.0111
    ## 186      7.1     8.9  0.0089
    ## 187      7.3     9.0  0.0090
    ## 188      7.4     5.6  0.0056
    ## 189      7.2     7.0  0.0070
    ## 190      7.4     7.2  0.0072
    ## 191      7.4     6.2  0.0062
    ## 192      7.4     6.6  0.0066
    ## 193      7.1     6.6  0.0066
    ## 194      7.1     8.4  0.0084
    ## 195        7     6.7  0.0067
    ## 196      7.3     5.4  0.0054
    ## 197     <NA>     8.8  0.0088
    ## 198      6.8     7.4  0.0074
    ## 199      7.3     9.0  0.0090
    ## 200        7     8.4  0.0084
    ## 201      7.3     6.6  0.0066
    ## 202      7.1     7.4  0.0074
    ## 203      7.2     7.8  0.0078
    ## 204      7.2     8.1  0.0081
    ## 205      7.1     6.8  0.0068
    ## 206      6.8     8.2  0.0082
    ## 207      7.4     6.7  0.0067
    ## 208      6.8     3.5  0.0035
    ## 209      6.8    10.2  0.0102
    ## 210      7.2     7.7  0.0077
    ## 211      7.4     5.4  0.0054
    ## 212      7.2    10.2  0.0102
    ## 213     <NA>     5.7  0.0057
    ## 214      7.3     5.4  0.0054
    ## 215      7.2     7.8  0.0078
    ## 216      7.2     6.3  0.0063
    ## 217      8.1     7.6  0.0076
    ## 218      7.2     7.7  0.0077
    ## 219      7.1     7.0  0.0070
    ## 220        7     7.7  0.0077
    ## 221      7.3    10.0  0.0100
    ## 222      6.8    10.0  0.0100
    ## 223      7.2     8.4  0.0084
    ## 224      7.5     8.3  0.0083
    ## 225      7.2     7.7  0.0077
    ## 226      7.1     8.6  0.0086
    ## 227      7.5     5.4  0.0054
    ## 228      6.6     7.3  0.0073
    ## 229      6.9     8.0  0.0080
    ## 230      7.1     8.6  0.0086
    ## 231      7.2     4.0  0.0040
    ## 232      7.4     8.6  0.0086
    ## 233      7.4    10.4  0.0104
    ## 234      7.1     9.1  0.0091
    ## 235      7.2     5.4  0.0054
    ## 236      7.6     7.8  0.0078
    ## 237      7.4     5.4  0.0054
    ## 238      7.4      NA      NA
    ## 239      7.2     7.3  0.0073
    ## 240      7.1     7.3  0.0073
    ## 241      7.2     7.2  0.0072
    ## 242     <NA>     6.8  0.0068
    ## 243      7.4     9.9  0.0099
    ## 244        7     8.3  0.0083
    ## 245        7     8.0  0.0080
    ## 246        7     8.2  0.0082
    ## 247        7     8.2  0.0082
    ## 248      7.2     8.5  0.0085
    ## 249      7.5    10.1  0.0101
    ## 250      7.3     5.7  0.0057
    ## 251      7.3     9.0  0.0090
    ## 252      6.9     8.5  0.0085
    ## 253      7.2      NA      NA
    ## 254      7.1     7.7  0.0077
    ## 255      7.2     8.3  0.0083
    ## 256      7.3     8.3  0.0083
    ## 257        7     6.4  0.0064
    ## 258        8    10.2  0.0102
    ## 259        7     6.8  0.0068
    ## 260      6.9     8.3  0.0083
    ## 261      7.4     6.0  0.0060
    ## 262      7.3     8.3  0.0083
    ## 263      7.3     5.9  0.0059
    ## 264      6.7     6.8  0.0068
    ## 265      6.7     8.3  0.0083
    ## 266      7.2     8.0  0.0080
    ## 267      6.8     9.1  0.0091
    ## 268        7     8.1  0.0081
    ## 269      7.4    10.0  0.0100
    ## 270      6.9     9.2  0.0092
    ## 271      7.2     6.6  0.0066
    ## 272      7.3     6.9  0.0069
    ## 273      6.9     8.5  0.0085
    ## 274     <NA>     8.6  0.0086
    ## 275        7     7.4  0.0074
    ## 276     <NA>     7.3  0.0073
    ## 277      7.4     9.6  0.0096
    ## 278        7     9.0  0.0090
    ## 279      6.2     7.0  0.0070
    ## 280      7.1     8.3  0.0083
    ## 281        7     8.0  0.0080
    ## 282      6.9     9.8  0.0098
    ## 283      7.3     6.0  0.0060
    ## 284      7.4     6.4  0.0064
    ## 285      6.6     7.4  0.0074
    ## 286      7.2     8.3  0.0083
    ## 287      7.2     8.4  0.0084
    ## 288        7     5.7  0.0057
    ## 289        7     8.7  0.0087
    ## 290      6.9     5.2  0.0052
    ## 291      7.3     5.8  0.0058
    ## 292      6.7     8.0  0.0080
    ## 293        7     6.7  0.0067
    ## 294      7.1     6.9  0.0069
    ## 295      6.3     6.2  0.0062
    ## 296      6.9     7.1  0.0071
    ## 297        7     9.1  0.0091
    ## 298      7.5     5.8  0.0058
    ## 299      7.1     9.0  0.0090
    ## 300      7.3     5.5  0.0055
    ## 301      7.4     5.1  0.0051
    ## 302      7.3     8.8  0.0088
    ## 303        7     6.8  0.0068
    ## 304      7.1     7.0  0.0070
    ## 305        7     7.1  0.0071
    ## 306      7.1      NA      NA
    ## 307      7.4     6.4  0.0064
    ## 308     <NA>     8.0  0.0080
    ## 309      7.6     9.2  0.0092
    ## 310      7.3     7.8  0.0078
    ## 311      7.4     3.2  0.0032
    ## 312      7.4     9.2  0.0092
    ## 313      7.3     7.2  0.0072
    ## 314      7.1     7.2  0.0072
    ## 315      7.5     5.3  0.0053
    ## 316      7.3     5.7  0.0057
    ## 317      7.2     7.0  0.0070
    ## 318      6.9     6.0  0.0060
    ## 319      7.3     3.7  0.0037
    ## 320      7.2     9.2  0.0092
    ## 321      6.7     9.6  0.0096
    ## 322      7.3     5.3  0.0053
    ## 323        7     7.8  0.0078
    ## 324      6.9     8.1  0.0081
    ## 325      6.8     4.4  0.0044
    ## 326      7.4     6.2  0.0062
    ## 327        7     6.5  0.0065
    ## 328      7.2     7.9  0.0079
    ## 329        7     8.2  0.0082
    ## 330      7.4     5.2  0.0052
    ## 331      7.4     8.3  0.0083
    ## 332      7.2     8.2  0.0082
    ## 333      6.9     8.5  0.0085
    ## 334        7     9.3  0.0093
    ## 335      7.5     6.0  0.0060
    ## 336      6.3     7.5  0.0075
    ## 337      7.3     9.1  0.0091
    ## 338      6.7     5.8  0.0058
    ## 339      7.1     8.6  0.0086
    ## 340      7.3     8.0  0.0080
    ## 341      6.9     6.2  0.0062
    ## 342     None     5.9  0.0059
    ## 343      7.1     8.8  0.0088
    ## 344      6.9     7.3  0.0073
    ## 345      7.1     6.8  0.0068
    ## 346      7.4     6.9  0.0069
    ## 347      6.9     6.8  0.0068
    ## 348      7.3     9.2  0.0092
    ## 349     <NA>     7.1  0.0071
    ## 350        7     7.9  0.0079
    ## 351      7.2     9.0  0.0090
    ## 352      7.2      NA      NA
    ## 353      7.6     6.4  0.0064
    ## 354      7.2     8.3  0.0083
    ## 355      7.2     8.0  0.0080
    ## 356        7     9.5  0.0095
    ## 357        7     8.7  0.0087
    ## 358        7     7.6  0.0076
    ## 359      7.2     7.7  0.0077
    ## 360      7.1     8.2  0.0082
    ## 361      7.2     6.6  0.0066
    ## 362      7.3     8.7  0.0087
    ## 363      6.8     3.7  0.0037
    ## 364      7.1     7.8  0.0078
    ## 365      7.4     6.5  0.0065
    ## 366      7.2     7.8  0.0078
    ## 367        7     7.3  0.0073
    ## 368     <NA>     6.8  0.0068
    ## 369      7.3     9.8  0.0098
    ## 370      7.1     9.3  0.0093
    ## 371      7.1     6.6  0.0066
    ## 372        7     8.2  0.0082
    ## 373      9.1    11.2  0.0112
    ## 374      6.8     9.0  0.0090
    ## 375      7.4     6.8  0.0068
    ## 376      6.6     8.5  0.0085
    ## 377      7.1     8.8  0.0088
    ## 378        7     8.8  0.0088
    ## 379      7.1     7.8  0.0078
    ## 380      8.1    11.7  0.0117
    ## 381      6.7     7.9  0.0079
    ## 382      6.8     7.5  0.0075
    ## 383        7     7.0  0.0070
    ## 384      7.1     7.1  0.0071
    ## 385      7.2     7.4  0.0074
    ## 386      6.8     9.5  0.0095
    ## 387      7.2     7.5  0.0075
    ## 388      7.1     6.8  0.0068
    ## 389      6.9     9.2  0.0092
    ## 390      7.2     8.4  0.0084
    ## 391      7.2     7.8  0.0078
    ## 392      7.5     6.2  0.0062
    ## 393      7.2     8.6  0.0086
    ## 394      7.6     8.7  0.0087
    ## 395        7     7.3  0.0073
    ## 396        7     7.4  0.0074
    ## 397      7.1     9.0  0.0090
    ## 398      7.6     6.9  0.0069
    ## 399      7.2     7.3  0.0073
    ## 400      7.1     7.4  0.0074
    ## 401      7.1     9.8  0.0098
    ## 402      7.4     6.8  0.0068
    ## 403      7.1     9.0  0.0090
    ## 404      6.8     7.3  0.0073
    ## 405      7.4     6.3  0.0063
    ## 406        7     7.6  0.0076
    ## 407      7.2     8.0  0.0080
    ## 408      7.1     7.4  0.0074
    ## 409      7.3     8.5  0.0085
    ## 410      7.3      NA      NA
    ## 411      7.4     6.8  0.0068
    ## 412      7.2     7.2  0.0072
    ## 413      7.3     8.9  0.0089
    ## 414      7.3     8.7  0.0087
    ## 415      7.4     9.2  0.0092
    ## 416        7     7.4  0.0074
    ## 417      7.4     8.7  0.0087
    ## 418      6.9     8.8  0.0088
    ## 419      6.9     7.3  0.0073
    ## 420      7.3     7.3  0.0073
    ## 421      7.3     7.8  0.0078
    ## 422     <NA>     6.4  0.0064
    ## 423        9     9.7  0.0097
    ## 424      7.3     9.0  0.0090
    ## 425        7     6.9  0.0069
    ## 426        7     8.0  0.0080
    ## 427     None     6.3  0.0063
    ## 428      7.2     9.4  0.0094
    ## 429      6.8     7.1  0.0071
    ## 430        7     9.3  0.0093
    ## 431      7.2     6.0  0.0060
    ## 432      6.8     9.3  0.0093
    ## 433      7.4     6.9  0.0069
    ## 434      7.2     7.0  0.0070
    ## 435      7.3     8.1  0.0081
    ## 436        7     8.1  0.0081
    ## 437      7.1     6.7  0.0067
    ## 438      7.2     9.0  0.0090
    ## 439      7.3     8.9  0.0089
    ## 440        7     8.6  0.0086
    ## 441      6.8      NA      NA
    ## 442      6.9     9.6  0.0096
    ## 443      6.9     8.3  0.0083
    ## 444      7.5     8.8  0.0088
    ## 445      7.2     7.6  0.0076
    ## 446      6.8     7.4  0.0074
    ## 447        7     8.1  0.0081
    ## 448      6.7     7.2  0.0072
    ## 449      7.2     7.9  0.0079
    ## 450      7.6    10.4  0.0104
    ## 451      7.5      NA      NA
    ## 452      7.4     5.8  0.0058
    ## 453      7.2     7.2  0.0072
    ## 454      7.5     5.2  0.0052
    ## 455      6.8     8.3  0.0083
    ## 456      6.8     4.6  0.0046
    ## 457      6.8     3.4  0.0034
    ## 458      7.2     7.4  0.0074
    ## 459      7.2     8.4  0.0084
    ## 460      7.1     8.9  0.0089
    ## 461      7.2     7.4  0.0074
    ## 462     <NA>     5.5  0.0055
    ## 463      6.9     8.2  0.0082
    ## 464      7.4    10.4  0.0104
    ## 465      6.7     7.4  0.0074
    ## 466        9    11.8  0.0118
    ## 467      6.8     8.0  0.0080
    ## 468      7.5     7.9  0.0079
    ## 469      6.9     7.8  0.0078
    ## 470      7.1     6.1  0.0061
    ## 471      6.9     7.5  0.0075
    ## 472      7.2     8.2  0.0082
    ## 473      7.4     6.7  0.0067
    ## 474      7.1     7.5  0.0075
    ## 475        7     7.4  0.0074
    ## 476        7     7.6  0.0076
    ## 477        7     9.6  0.0096
    ## 478      7.1     9.4  0.0094
    ## 479      7.4     7.6  0.0076
    ## 480        7     8.4  0.0084
    ## 481      7.2     8.5  0.0085
    ## 482      7.2     7.0  0.0070
    ## 483      7.4     5.1  0.0051
    ## 484     <NA>     6.1  0.0061
    ## 485      7.1     5.9  0.0059
    ## 486      7.1     8.0  0.0080
    ## 487      7.1     8.1  0.0081
    ## 488      7.1     8.7  0.0087
    ## 489      7.2     8.4  0.0084
    ## 490      7.4     7.7  0.0077
    ## 491      7.1     7.2  0.0072
    ## 492      6.9     5.3  0.0053
    ## 493        7     8.2  0.0082
    ## 494      6.3     7.6  0.0076
    ## 495        7     6.0  0.0060
    ## 496      6.8     7.2  0.0072
    ## 497      6.9     8.3  0.0083
    ## 498      7.4     5.7  0.0057
    ## 499      7.2     6.0  0.0060
    ## 500      7.3     7.8  0.0078
    ## 501      6.9    10.1  0.0101
    ## 502      6.9     7.4  0.0074
    ## 503      6.9     9.4  0.0094
    ## 504      7.3     8.4  0.0084
    ## 505      6.6     7.0  0.0070
    ## 506      7.6     8.2  0.0082
    ## 507      7.2     7.8  0.0078
    ## 508        7     8.7  0.0087
    ## 509      7.2     6.6  0.0066
    ## 510      7.4     8.6  0.0086
    ## 511        7     7.0  0.0070
    ## 512      7.2     7.6  0.0076
    ## 513      8.2     8.2  0.0082
    ## 514      6.8     9.4  0.0094
    ## 515      7.2     7.6  0.0076
    ## 516      7.1     9.1  0.0091
    ## 517      7.2     7.6  0.0076
    ## 518      7.3      NA      NA
    ## 519      7.5     6.4  0.0064
    ## 520      7.5     6.7  0.0067
    ## 521      7.3     9.3  0.0093
    ## 522        7     6.8  0.0068
    ## 523      6.9     7.4  0.0074
    ## 524      7.2     7.5  0.0075
    ## 525      7.2     8.5  0.0085
    ## 526      7.2     6.8  0.0068
    ## 527      6.9     7.8  0.0078
    ## 528      6.8     6.7  0.0067
    ## 529        7     7.2  0.0072
    ## 530      7.1     9.1  0.0091
    ## 531      7.5     6.8  0.0068
    ## 532      6.8     8.5  0.0085
    ## 533        7     7.8  0.0078
    ## 534      6.8     9.8  0.0098
    ## 535      7.1     8.2  0.0082
    ## 536      6.8    10.0  0.0100
    ## 537      6.8     4.0  0.0040
    ## 538      6.9     6.1  0.0061
    ## 539      6.6     6.7  0.0067
    ## 540      7.5     7.9  0.0079
    ## 541        7     8.6  0.0086
    ## 542      7.1     8.1  0.0081
    ## 543      7.4      NA      NA
    ## 544      7.1     6.8  0.0068
    ## 545      7.1    10.3  0.0103
    ## 546     <NA>     7.2  0.0072
    ## 547        7     8.3  0.0083
    ## 548      6.8     7.2  0.0072
    ## 549      7.3     8.7  0.0087
    ## 550      7.4     9.5  0.0095
    ## 551      7.4     8.1  0.0081
    ## 552      7.2     9.1  0.0091
    ## 553      7.3     7.9  0.0079
    ## 554      7.1     6.3  0.0063
    ## 555      7.1     7.3  0.0073
    ## 556        7     6.9  0.0069
    ## 557        7     8.6  0.0086
    ## 558     <NA>     8.6  0.0086
    ## 559      7.1     7.8  0.0078
    ## 560      7.4     5.8  0.0058
    ## 561      7.4     9.3  0.0093
    ## 562      7.2     7.5  0.0075
    ## 563      6.6     8.1  0.0081
    ## 564      7.1     8.8  0.0088
    ## 565      7.1     7.1  0.0071
    ## 566        7     7.2  0.0072
    ## 567      6.8     4.4  0.0044
    ## 568        7     7.3  0.0073
    ## 569      7.5     7.6  0.0076
    ## 570      7.3     8.0  0.0080
    ## 571      7.3     8.1  0.0081
    ## 572      6.8     7.5  0.0075
    ## 573      6.8    10.3  0.0103
    ## 574      7.7      NA      NA
    ## 575        7     8.8  0.0088
    ## 576      7.1      NA      NA
    ## 577      6.8     5.6  0.0056
    ## 578      7.2      NA      NA
    ## 579      7.3      NA      NA
    ## 580      7.2     8.0  0.0080
    ## 581        7     6.6  0.0066
    ## 582      6.9     4.7  0.0047
    ## 583      6.9     9.8  0.0098
    ## 584      7.2     8.0  0.0080
    ## 585      7.4     6.2  0.0062
    ## 586      7.2      NA      NA
    ## 587        7     7.9  0.0079
    ## 588        7     7.7  0.0077
    ## 589      7.1     8.1  0.0081
    ## 590      7.5     5.7  0.0057
    ## 591      7.4     8.8  0.0088
    ## 592        7     7.7  0.0077
    ## 593      6.9     6.0  0.0060
    ## 594      7.3     3.4  0.0034
    ## 595      7.3     8.3  0.0083
    ## 596        7     9.4  0.0094
    ## 597     <NA>     7.4  0.0074
    ## 598        7     7.4  0.0074
    ## 599      7.3    10.5  0.0105
    ## 600      7.3     8.6  0.0086
    ## 601      7.4     5.4  0.0054
    ## 602     <NA>     6.6  0.0066
    ## 603      6.9    10.1  0.0101
    ## 604      6.9     9.9  0.0099
    ## 605      7.1     9.4  0.0094
    ## 606        7     7.0  0.0070
    ## 607      6.9     7.9  0.0079
    ## 608      6.8     5.6  0.0056
    ## 609      7.2     8.7  0.0087
    ## 610      6.6     7.0  0.0070
    ## 611      6.6     7.9  0.0079
    ## 612        7     9.0  0.0090
    ## 613        7     6.8  0.0068
    ## 614      8.1    11.3  0.0113
    ## 615      6.8     9.6  0.0096
    ## 616        7     8.6  0.0086
    ## 617      6.9     6.4  0.0064
    ## 618      6.9     6.9  0.0069
    ## 619      7.2     6.6  0.0066
    ## 620      6.9     7.7  0.0077
    ## 621      7.1     6.6  0.0066
    ## 622      7.2     7.5  0.0075
    ## 623      7.2     8.6  0.0086
    ## 624      6.8     6.9  0.0069
    ## 625      7.1     8.8  0.0088
    ## 626      6.9     6.6  0.0066
    ## 627      7.3     8.7  0.0087
    ## 628      7.6    11.1  0.0111
    ## 629      6.9     9.1  0.0091
    ## 630      7.5     6.6  0.0066
    ## 631      7.5     8.5  0.0085
    ## 632      7.3     8.9  0.0089
    ## 633      7.8      NA      NA
    ## 634        7     8.4  0.0084
    ## 635      7.1     8.0  0.0080
    ## 636        7     6.6  0.0066
    ## 637      7.4     6.6  0.0066
    ## 638      7.5     7.1  0.0071
    ## 639     <NA>     4.6  0.0046
    ## 640      7.6     9.4  0.0094
    ## 641      7.1     7.6  0.0076
    ## 642        7     6.8  0.0068
    ## 643      7.1     7.5  0.0075
    ## 644        7     8.1  0.0081
    ## 645      7.5     5.3  0.0053
    ## 646      6.9     7.1  0.0071
    ## 647      6.9      NA      NA
    ## 648      6.4     6.8  0.0068
    ## 649      7.1     7.8  0.0078
    ## 650        7     6.7  0.0067
    ## 651     <NA>     7.9  0.0079
    ## 652      7.1     6.2  0.0062
    ## 653      7.1     8.8  0.0088
    ## 654      7.2     7.0  0.0070
    ## 655      7.3     8.6  0.0086
    ## 656      7.6     8.3  0.0083
    ## 657      6.7     6.4  0.0064
    ## 658      7.5     6.9  0.0069
    ## 659      7.1     8.7  0.0087
    ## 660      6.9     8.0  0.0080
    ## 661      7.2     7.9  0.0079
    ## 662      7.3     8.5  0.0085
    ## 663      7.5    10.4  0.0104
    ## 664        7     6.8  0.0068
    ## 665      6.8     6.9  0.0069
    ## 666      6.8     4.2  0.0042
    ## 667      8.3     8.4  0.0084
    ## 668      7.6     9.5  0.0095
    ## 669      7.4     6.5  0.0065
    ## 670      7.3     4.1  0.0041
    ## 671        7     7.2  0.0072
    ## 672      7.2     9.8  0.0098
    ## 673     <NA>     8.0  0.0080
    ## 674      7.5     6.1  0.0061
    ## 675      6.8     8.5  0.0085
    ## 676     <NA>     8.2  0.0082
    ## 677        7     8.1  0.0081
    ## 678      6.9     7.6  0.0076
    ## 679      7.1     7.4  0.0074
    ## 680      6.8      NA      NA
    ## 681      7.3     7.9  0.0079
    ## 682        7     7.6  0.0076
    ## 683        7    10.2  0.0102
    ## 684      7.3     6.5  0.0065
    ## 685      7.1     7.3  0.0073
    ## 686        7     7.6  0.0076
    ## 687        7     8.1  0.0081
    ## 688      6.9     6.8  0.0068
    ## 689      7.3     8.7  0.0087
    ## 690      7.2     7.8  0.0078
    ## 691      7.1     7.7  0.0077
    ## 692      7.1     7.6  0.0076
    ## 693      7.4     9.7  0.0097
    ## 694        7     6.9  0.0069
    ## 695      7.2     9.1  0.0091
    ## 696      6.8     5.4  0.0054
    ## 697      6.8     7.6  0.0076
    ## 698      7.1     7.5  0.0075
    ## 699      7.1     9.1  0.0091
    ## 700      8.3    11.1  0.0111
    ## 701      6.9     6.9  0.0069
    ## 702      7.4     5.8  0.0058
    ## 703      6.9     7.2  0.0072
    ## 704      7.2     7.0  0.0070
    ## 705      7.1     8.4  0.0084
    ## 706        7     6.7  0.0067
    ## 707        7     7.1  0.0071
    ## 708      7.2     7.3  0.0073
    ## 709      6.9     6.0  0.0060
    ## 710      7.2     8.6  0.0086
    ## 711      7.4     6.5  0.0065
    ## 712      6.9      NA      NA
    ## 713      7.5     6.1  0.0061
    ## 714        7     7.4  0.0074
    ## 715        7     6.6  0.0066
    ## 716        7     6.9  0.0069
    ## 717     <NA>     7.1  0.0071
    ## 718              7.6  0.0076
    ## 719      7.9     8.9  0.0089
    ## 720      7.3     6.4  0.0064
    ## 721      7.2     8.4  0.0084
    ## 722      7.4     8.9  0.0089
    ## 723      7.3     8.7  0.0087
    ## 724      7.2     7.2  0.0072
    ## 725      7.2    10.2  0.0102
    ## 726      7.3     6.0  0.0060
    ## 727      7.3    10.0  0.0100
    ## 728      7.4     5.6  0.0056
    ## 729      7.2     7.3  0.0073
    ## 730        7     7.5  0.0075
    ## 731      7.6     6.3  0.0063
    ## 732      7.1     8.7  0.0087
    ## 733      7.2     7.3  0.0073
    ## 734      6.4     7.0  0.0070
    ## 735      7.2     6.5  0.0065
    ## 736      7.3     6.2  0.0062
    ## 737        7     7.0  0.0070
    ## 738      7.5     5.3  0.0053
    ## 739      7.2     7.4  0.0074
    ## 740      7.3     7.7  0.0077
    ## 741        7    10.2  0.0102
    ## 742      7.3     5.9  0.0059
    ## 743      7.2     7.4  0.0074
    ## 744      7.4     5.8  0.0058
    ## 745      7.2      NA      NA
    ## 746      7.2     7.5  0.0075
    ## 747      7.3     6.7  0.0067
    ## 748      7.2     8.9  0.0089
    ## 749      7.2     7.6  0.0076
    ## 750      7.2     8.6  0.0086
    ## 751        7     7.2  0.0072
    ## 752      7.2     7.0  0.0070
    ## 753      7.3     5.6  0.0056
    ## 754     None    10.7  0.0107
    ## 755      7.2     7.5  0.0075
    ## 756      7.1     8.8  0.0088
    ## 757      7.1     6.4  0.0064
    ## 758        7     6.8  0.0068
    ## 759      7.1     6.3  0.0063
    ## 760      7.4     6.3  0.0063
    ## 761      7.3     8.6  0.0086
    ## 762      6.8     8.5  0.0085
    ## 763        7     6.8  0.0068
    ## 764        7     9.3  0.0093
    ## 765      6.9     6.7  0.0067
    ## 766        7     8.6  0.0086
    ## 767      7.1     8.7  0.0087
    ## 768      7.2     6.9  0.0069
    ## 769      6.3     6.0  0.0060
    ## 770      6.8     9.8  0.0098
    ## 771      7.9     9.9  0.0099
    ## 772      8.4     9.2  0.0092
    ## 773      7.3     9.2  0.0092
    ## 774        9    11.9  0.0119
    ## 775      7.2     7.6  0.0076
    ## 776      7.3     6.2  0.0062
    ## 777      7.1      NA      NA
    ## 778      7.1     8.0  0.0080
    ## 779      7.2     7.8  0.0078
    ## 780      7.1     6.3  0.0063
    ## 781        7     7.3  0.0073
    ## 782      6.8     7.3  0.0073
    ## 783      7.5    10.2  0.0102
    ## 784        7     6.2  0.0062
    ## 785      7.1    10.8  0.0108
    ## 786      7.5    10.0  0.0100
    ## 787        7     8.2  0.0082
    ## 788      6.5     6.4  0.0064
    ## 789      7.1     9.9  0.0099
    ## 790      7.3     7.0  0.0070
    ## 791      6.9     5.4  0.0054
    ## 792      7.3     9.0  0.0090
    ## 793      7.5     6.1  0.0061
    ## 794      6.4      NA      NA
    ## 795      7.1     6.7  0.0067
    ## 796        7     6.9  0.0069
    ## 797      7.3     5.9  0.0059
    ## 798      7.1     6.8  0.0068
    ## 799      7.2     6.8  0.0068
    ## 800      7.8     7.1  0.0071
    ## 801      6.9     9.4  0.0094
    ## 802      6.8     4.6  0.0046
    ## 803      7.1     7.4  0.0074
    ## 804      6.8     4.5  0.0045
    ## 805      7.2     9.8  0.0098
    ## 806      7.3     8.5  0.0085
    ## 807      6.8      NA      NA
    ## 808      7.3     6.5  0.0065
    ## 809     <NA>      NA      NA
    ## 810      7.2     8.6  0.0086
    ## 811      7.2     9.0  0.0090
    ## 812              7.4  0.0074
    ## 813        7     6.4  0.0064
    ## 814      6.8     7.4  0.0074
    ## 815      7.1     7.7  0.0077
    ## 816      7.3     5.5  0.0055
    ## 817      7.1     7.7  0.0077
    ## 818      7.3     7.8  0.0078
    ## 819      7.3     5.8  0.0058
    ## 820        7     7.2  0.0072
    ## 821      7.2     7.1  0.0071
    ## 822      7.2      NA      NA
    ## 823      7.2     8.2  0.0082
    ## 824      6.8     9.9  0.0099
    ## 825      6.8     8.5  0.0085
    ## 826      7.2     7.3  0.0073
    ## 827      6.9     6.9  0.0069
    ## 828      7.2     8.5  0.0085
    ## 829      6.9     6.1  0.0061
    ## 830      6.9     8.7  0.0087
    ## 831      7.3     5.8  0.0058
    ## 832      7.5     8.8  0.0088
    ## 833      6.9     8.2  0.0082
    ## 834      6.4     7.2  0.0072
    ## 835      7.1     7.4  0.0074
    ## 836      7.4     3.3  0.0033
    ## 837      6.7     9.4  0.0094
    ## 838      7.9    11.2  0.0112
    ## 839      7.3     9.0  0.0090
    ## 840      7.2     5.0  0.0050
    ## 841        7     8.8  0.0088
    ## 842      6.8     4.0  0.0040
    ## 843      7.4     9.9  0.0099
    ## 844      6.9     8.3  0.0083
    ## 845      6.9     4.9  0.0049
    ## 846      7.2     8.6  0.0086
    ## 847      7.2     7.1  0.0071
    ## 848      7.4     6.3  0.0063
    ## 849     <NA>     6.0  0.0060
    ## 850      7.2     8.5  0.0085
    ## 851        7     8.7  0.0087
    ## 852      6.8     4.2  0.0042
    ## 853      6.9     8.5  0.0085
    ## 854      7.9     9.7  0.0097
    ## 855      6.8     9.8  0.0098
    ## 856      7.1     9.0  0.0090
    ## 857      7.2     8.2  0.0082
    ## 858      7.2     8.4  0.0084
    ## 859      7.1     6.8  0.0068
    ## 860      7.2     8.0  0.0080
    ## 861      7.3     9.5  0.0095
    ## 862      7.1     6.1  0.0061
    ## 863      7.3     9.1  0.0091
    ## 864      6.9     5.9  0.0059
    ## 865      7.2     9.0  0.0090
    ## 866      7.2     8.8  0.0088
    ## 867      7.3     9.0  0.0090
    ## 868      7.2     7.7  0.0077
    ## 869        7     9.4  0.0094
    ## 870      7.1     7.5  0.0075
    ## 871      7.2     8.1  0.0081
    ## 872      7.2     8.0  0.0080
    ## 873      7.1     8.9  0.0089
    ## 874      6.9     9.6  0.0096
    ## 875      6.8     8.0  0.0080
    ## 876      7.4     6.2  0.0062
    ## 877      7.4     6.1  0.0061
    ## 878      7.4     3.3  0.0033
    ## 879      7.4     4.8  0.0048
    ## 880      7.2     7.8  0.0078
    ## 881      7.4      NA      NA
    ## 882      6.6     6.9  0.0069
    ## 883      7.5     6.2  0.0062
    ## 884        7     6.9  0.0069
    ## 885      7.4     9.0  0.0090
    ## 886      7.2     7.6  0.0076
    ## 887      7.1     7.2  0.0072
    ## 888      7.4     4.9  0.0049
    ## 889      6.9     6.3  0.0063
    ## 890      7.2     7.7  0.0077
    ## 891      7.3     6.0  0.0060
    ## 892      7.2     7.1  0.0071
    ## 893      6.9     7.5  0.0075
    ## 894      6.8     9.5  0.0095
    ## 895      7.3     5.5  0.0055
    ## 896      7.2     8.2  0.0082
    ## 897      7.1     7.6  0.0076
    ## 898      7.2     7.3  0.0073
    ## 899      6.9     7.3  0.0073
    ## 900      7.1     8.2  0.0082
    ## 901      7.5     6.1  0.0061
    ## 902      7.1     9.2  0.0092
    ## 903      7.4     6.1  0.0061
    ## 904      7.1     7.6  0.0076
    ## 905      6.9     7.7  0.0077
    ## 906      7.1     8.1  0.0081
    ## 907      7.4    10.8  0.0108
    ## 908      7.4     9.0  0.0090
    ## 909      7.1     8.2  0.0082
    ## 910        7    10.1  0.0101
    ## 911      7.3     8.1  0.0081
    ## 912      7.2     7.7  0.0077
    ## 913        7     9.7  0.0097
    ## 914      6.7     9.7  0.0097
    ## 915      7.3     7.8  0.0078
    ## 916      7.1     6.5  0.0065
    ## 917      7.3     5.9  0.0059
    ## 918      7.3     5.4  0.0054
    ## 919      7.2     8.9  0.0089
    ## 920      7.1     6.6  0.0066
    ## 921      7.4     6.2  0.0062
    ## 922      7.3     7.0  0.0070
    ## 923      6.9     9.9  0.0099
    ## 924        7     7.4  0.0074
    ## 925      7.2     6.8  0.0068
    ## 926      7.3     9.2  0.0092
    ## 927        7     7.0  0.0070
    ## 928      7.3     8.8  0.0088
    ## 929      7.5     6.0  0.0060
    ## 930        7     6.8  0.0068
    ## 931      7.2     6.2  0.0062
    ## 932      7.3     8.7  0.0087
    ## 933      7.2     5.3  0.0053
    ## 934      7.2     7.5  0.0075
    ## 935      7.3     6.1  0.0061
    ## 936      6.7     8.1  0.0081
    ## 937      7.1     7.3  0.0073
    ## 938      7.2     8.9  0.0089
    ## 939      7.3     8.4  0.0084
    ## 940      6.6     7.3  0.0073
    ## 941      7.1     7.5  0.0075
    ## 942      7.2     7.2  0.0072
    ## 943      7.2     7.7  0.0077
    ## 944      6.9     6.9  0.0069
    ## 945        7     6.8  0.0068
    ## 946      6.6     6.4  0.0064
    ## 947      7.1     6.3  0.0063
    ## 948        7     7.2  0.0072
    ## 949      7.5     9.7  0.0097
    ## 950      7.1      NA      NA
    ## 951      7.2     9.6  0.0096
    ## 952      7.1      NA      NA
    ## 953     <NA>    12.2  0.0122
    ## 954      7.4     9.8  0.0098
    ## 955      6.4     8.1  0.0081
    ## 956      7.3     8.2  0.0082
    ## 957      7.2     8.9  0.0089
    ## 958        9    11.9  0.0119
    ## 959      7.5     6.2  0.0062
    ## 960      7.1     6.2  0.0062
    ## 961      7.4     6.7  0.0067
    ## 962      7.2     8.2  0.0082
    ## 963      7.2     8.7  0.0087
    ## 964      7.4     7.7  0.0077
    ## 965      7.2     5.5  0.0055
    ## 966      7.3      NA      NA
    ## 967      6.8     4.7  0.0047
    ## 968      7.1     9.1  0.0091
    ## 969      7.1     7.4  0.0074
    ## 970        7     8.4  0.0084
    ## 971      7.1     8.0  0.0080
    ## 972      6.9     4.8  0.0048
    ## 973      6.8     7.5  0.0075
    ## 974      7.1      NA      NA
    ## 975      7.1     7.2  0.0072
    ## 976      6.6     7.6  0.0076
    ## 977      7.5     8.5  0.0085
    ## 978      7.4     6.3  0.0063
    ## 979        7     6.4  0.0064
    ## 980      8.1    10.4  0.0104
    ## 981      7.2     7.6  0.0076
    ## 982      7.2     7.4  0.0074
    ## 983     <NA>     7.1  0.0071
    ## 984     <NA>     7.2  0.0072
    ## 985      7.2     9.1  0.0091
    ## 986      7.3     6.0  0.0060
    ## 987      6.4     7.1  0.0071
    ## 988      7.2     6.7  0.0067
    ## 989      7.3     6.8  0.0068
    ## 990      7.4     6.6  0.0066
    ## 991      7.1     8.5  0.0085
    ## 992      7.3     6.8  0.0068
    ## 993     <NA>     6.3  0.0063
    ## 994      7.1     6.7  0.0067
    ## 995     <NA>     8.9  0.0089
    ## 996      7.2     7.6  0.0076
    ## 997      7.3     9.0  0.0090
    ## 998     <NA>     9.1  0.0091
    ## 999      7.6     5.8  0.0058
    ## 1000     7.3     8.6  0.0086
    ## 1001     7.3     6.4  0.0064
    ## 1002     7.1     8.1  0.0081
    ## 1003     6.7     7.8  0.0078
    ## 1004     7.3     8.2  0.0082
    ## 1005     7.3    10.2  0.0102
    ## 1006     7.3     7.5  0.0075
    ## 1007     6.9     8.2  0.0082
    ## 1008     7.1     6.9  0.0069
    ## 1009     6.5     7.2  0.0072
    ## 1010     7.2     8.2  0.0082
    ## 1011     7.3     8.6  0.0086
    ## 1012     6.8     6.5  0.0065
    ## 1013     7.2     7.7  0.0077
    ## 1014     7.1     6.9  0.0069
    ## 1015     7.2      NA      NA
    ## 1016     7.5     8.8  0.0088
    ## 1017     7.6     9.6  0.0096
    ## 1018     7.4     6.5  0.0065
    ## 1019       7     6.9  0.0069
    ## 1020     7.1     9.9  0.0099
    ## 1021       7     9.2  0.0092
    ## 1022     6.9     5.6  0.0056
    ## 1023     7.2     7.0  0.0070
    ## 1024       7     7.8  0.0078
    ## 1025     7.2     7.6  0.0076
    ## 1026     6.8     6.9  0.0069
    ## 1027     7.2     7.4  0.0074
    ## 1028    None     8.0  0.0080
    ## 1029     7.1     8.2  0.0082
    ## 1030     7.3     8.3  0.0083
    ## 1031     7.2     7.3  0.0073
    ## 1032     7.1     7.3  0.0073
    ## 1033     7.4     7.4  0.0074
    ## 1034     6.7     8.3  0.0083
    ## 1035     7.1     8.5  0.0085
    ## 1036     7.3     8.7  0.0087
    ## 1037     7.6     8.9  0.0089
    ## 1038     7.1     7.5  0.0075
    ## 1039     7.1     8.1  0.0081
    ## 1040     7.3     7.1  0.0071
    ## 1041     6.8     4.3  0.0043
    ## 1042     7.3     8.8  0.0088
    ## 1043     7.2     6.8  0.0068
    ## 1044     7.1     7.7  0.0077
    ## 1045     7.1     9.1  0.0091
    ## 1046     7.2     6.6  0.0066
    ## 1047     7.1     9.2  0.0092
    ## 1048     6.3     7.5  0.0075
    ## 1049     7.4     6.1  0.0061
    ## 1050       7     7.1  0.0071
    ## 1051     7.2     8.6  0.0086
    ## 1052     7.5     6.3  0.0063
    ## 1053     7.3     7.2  0.0072
    ## 1054     7.4     9.6  0.0096
    ## 1055     7.5     6.3  0.0063
    ## 1056     7.5     7.1  0.0071
    ## 1057     7.2     9.1  0.0091
    ## 1058       7     8.8  0.0088
    ## 1059     7.1     7.3  0.0073
    ## 1060     6.8     7.9  0.0079
    ## 1061       7      NA      NA
    ## 1062     7.6     9.3  0.0093
    ## 1063     7.3     5.3  0.0053
    ## 1064     7.4     6.3  0.0063
    ## 1065     7.5     6.2  0.0062
    ## 1066       7     6.2  0.0062
    ## 1067     6.7     7.3  0.0073
    ## 1068     6.9     6.6  0.0066
    ## 1069     7.1     8.4  0.0084
    ## 1070     7.4    11.0  0.0110
    ## 1071     7.2     6.6  0.0066
    ## 1072     7.3     9.3  0.0093
    ## 1073     7.4     5.3  0.0053
    ## 1074     7.2     8.7  0.0087
    ## 1075     7.3      NA      NA
    ## 1076     7.2     8.2  0.0082
    ## 1077     7.4     8.7  0.0087
    ## 1078     7.2     7.8  0.0078
    ## 1079     7.3     9.0  0.0090
    ## 1080     6.7     7.0  0.0070
    ## 1081     7.2     7.6  0.0076
    ## 1082     7.2     8.0  0.0080
    ## 1083     7.2     8.2  0.0082
    ## 1084       7     7.5  0.0075
    ## 1085     7.2     8.2  0.0082
    ## 1086       7     8.4  0.0084
    ## 1087     7.4     8.7  0.0087
    ## 1088     6.8    10.0  0.0100
    ## 1089     7.1     8.5  0.0085
    ## 1090     7.4     6.6  0.0066
    ## 1091     7.3     9.0  0.0090
    ## 1092     6.9     6.1  0.0061
    ## 1093     7.6     6.1  0.0061
    ## 1094     7.4     7.4  0.0074
    ## 1095     6.9     6.4  0.0064
    ## 1096     6.9     4.8  0.0048
    ## 1097     6.6     7.5  0.0075
    ## 1098     7.2     7.0  0.0070
    ## 1099     7.3     8.2  0.0082
    ## 1100       7    10.1  0.0101
    ## 1101       7     6.6  0.0066
    ## 1102     6.4     7.2  0.0072
    ## 1103     7.2     7.7  0.0077
    ## 1104     7.1     7.3  0.0073
    ## 1105     7.2     8.8  0.0088
    ## 1106     7.2     8.2  0.0082
    ## 1107       7     6.8  0.0068
    ## 1108    <NA>      NA      NA
    ## 1109     6.4     8.5  0.0085
    ## 1110     7.3     8.9  0.0089
    ## 1111     7.2     9.1  0.0091
    ## 1112     7.3     8.6  0.0086
    ## 1113     7.2     8.1  0.0081
    ## 1114       7     9.0  0.0090
    ## 1115    <NA>     8.0  0.0080
    ## 1116       7     7.7  0.0077
    ## 1117    <NA>     6.4  0.0064
    ## 1118     7.1     8.0  0.0080
    ## 1119     7.1     7.6  0.0076
    ## 1120     7.3     7.3  0.0073
    ## 1121     7.3     6.1  0.0061
    ## 1122     7.3     8.5  0.0085
    ## 1123     7.5     5.6  0.0056
    ## 1124     7.3     9.0  0.0090
    ## 1125       7     7.3  0.0073
    ## 1126     7.1     6.5  0.0065
    ## 1127    <NA>     8.6  0.0086
    ## 1128     6.8     6.3  0.0063
    ## 1129     7.4     5.9  0.0059
    ## 1130     7.2     7.1  0.0071
    ## 1131     7.2      NA      NA
    ## 1132       7     6.8  0.0068
    ## 1133     7.4     8.0  0.0080
    ## 1134     7.4     6.5  0.0065
    ## 1135     6.8     4.3  0.0043
    ## 1136       7      NA      NA
    ## 1137       7     8.2  0.0082
    ## 1138     7.2      NA      NA
    ## 1139     7.2     9.4  0.0094
    ## 1140     7.3     8.4  0.0084
    ## 1141     6.8     9.8  0.0098
    ## 1142     7.3     5.9  0.0059
    ## 1143     7.1     7.0  0.0070
    ## 1144     7.2     7.2  0.0072
    ## 1145     7.3     9.1  0.0091
    ## 1146     6.9     7.2  0.0072
    ## 1147     7.2     6.5  0.0065
    ## 1148     7.4     5.8  0.0058
    ## 1149     6.8     4.2  0.0042
    ## 1150     6.8     6.5  0.0065
    ## 1151     7.5     6.7  0.0067
    ## 1152     6.8      NA      NA
    ## 1153     7.1     6.7  0.0067
    ## 1154     7.2     6.6  0.0066
    ## 1155     7.1     7.0  0.0070
    ## 1156     7.3     9.3  0.0093
    ## 1157     7.6     9.5  0.0095
    ## 1158     7.2     8.5  0.0085
    ## 1159     6.8     4.2  0.0042
    ## 1160     7.2     6.4  0.0064
    ## 1161     7.1     8.3  0.0083
    ## 1162     7.4     6.7  0.0067
    ## 1163     6.8     7.0  0.0070
    ## 1164       7     7.3  0.0073
    ## 1165       7     8.3  0.0083
    ## 1166     6.8    10.0  0.0100
    ## 1167     6.5     7.0  0.0070
    ## 1168     6.9      NA      NA
    ## 1169     7.1     7.5  0.0075
    ## 1170     6.3     7.5  0.0075
    ## 1171     7.5     8.8  0.0088
    ## 1172     7.2     6.8  0.0068
    ## 1173     6.7     8.3  0.0083
    ## 1174     6.8     3.4  0.0034
    ## 1175     7.2     8.8  0.0088
    ## 1176     6.7     8.3  0.0083
    ## 1177     7.3     9.1  0.0091
    ## 1178     7.2     8.5  0.0085
    ## 1179     6.9     8.7  0.0087
    ## 1180     7.4      NA      NA
    ## 1181     7.4     5.5  0.0055
    ## 1182     7.2      NA      NA
    ## 1183     6.6     7.3  0.0073
    ## 1184     7.3     7.1  0.0071
    ## 1185     7.1     7.9  0.0079
    ## 1186     7.4    10.0  0.0100
    ## 1187     7.4     6.7  0.0067
    ## 1188     7.4     8.0  0.0080
    ## 1189     7.1     9.0  0.0090
    ## 1190     6.9     6.8  0.0068
    ## 1191     7.2     9.0  0.0090
    ## 1192       7     8.9  0.0089
    ## 1193     7.3     5.2  0.0052
    ## 1194     6.8     7.7  0.0077
    ## 1195     7.3     8.2  0.0082
    ## 1196     7.1     7.8  0.0078
    ## 1197     7.4     8.9  0.0089
    ## 1198       7     8.3  0.0083
    ## 1199     7.5     5.1  0.0051
    ## 1200     6.8    10.0  0.0100
    ## 1201       7     6.6  0.0066
    ## 1202    <NA>     9.1  0.0091
    ## 1203     7.5     5.9  0.0059
    ## 1204     7.6     9.8  0.0098
    ## 1205       7     7.4  0.0074
    ## 1206     7.1     8.3  0.0083
    ## 1207     7.2     7.2  0.0072
    ## 1208     7.1     9.3  0.0093
    ## 1209     7.2     7.2  0.0072
    ## 1210     6.9     7.9  0.0079
    ## 1211     7.3     8.6  0.0086
    ## 1212     7.2     8.6  0.0086
    ## 1213     7.2     7.9  0.0079
    ## 1214     7.5     5.5  0.0055
    ## 1215     7.4     8.2  0.0082
    ## 1216     7.9    11.0  0.0110
    ## 1217       7     7.2  0.0072
    ## 1218     7.3     8.4  0.0084
    ## 1219     7.2      NA      NA
    ## 1220     7.3     8.2  0.0082
    ## 1221     7.3     5.9  0.0059
    ## 1222     7.2     6.9  0.0069
    ## 1223     7.1     6.8  0.0068
    ## 1224    <NA>     7.1  0.0071
    ## 1225     7.3    10.2  0.0102
    ## 1226     7.2     6.9  0.0069
    ## 1227     8.6    12.0  0.0120
    ## 1228     6.9     8.3  0.0083
    ## 1229     7.2     9.0  0.0090
    ## 1230     6.8     4.3  0.0043
    ## 1231     7.3     7.2  0.0072
    ## 1232     6.9    10.2  0.0102
    ## 1233       7      NA      NA
    ## 1234     7.4     7.8  0.0078
    ## 1235     6.8     7.4  0.0074
    ## 1236     6.8     7.7  0.0077
    ## 1237     6.4     8.5  0.0085
    ## 1238     6.9      NA      NA
    ## 1239     7.1     7.4  0.0074
    ## 1240     7.1     8.3  0.0083
    ## 1241     7.2     8.6  0.0086
    ## 1242     6.2     7.0  0.0070
    ## 1243     6.9    10.1  0.0101
    ## 1244     7.4     8.0  0.0080
    ## 1245     7.2     7.7  0.0077
    ## 1246       7     7.3  0.0073
    ## 1247     7.1     7.5  0.0075
    ## 1248     7.4     8.8  0.0088
    ## 1249     7.5     6.2  0.0062
    ## 1250     6.4     7.3  0.0073
    ## 1251     7.2     8.5  0.0085
    ## 1252    <NA>     6.2  0.0062
    ## 1253     7.6     8.6  0.0086
    ## 1254     7.1     7.0  0.0070
    ## 1255     7.5     5.4  0.0054
    ## 1256       7     7.4  0.0074
    ## 1257     7.2     8.8  0.0088
    ## 1258     7.1     7.5  0.0075
    ## 1259     7.5     9.0  0.0090
    ## 1260     7.4     7.4  0.0074
    ## 1261     7.1     5.9  0.0059
    ## 1262     6.9     8.2  0.0082
    ## 1263     7.3     5.6  0.0056
    ## 1264     7.4    10.0  0.0100
    ## 1265     7.5     6.6  0.0066
    ## 1266     7.4     9.5  0.0095
    ## 1267     7.2     7.8  0.0078
    ## 1268     7.5     6.4  0.0064
    ## 1269     7.5    10.2  0.0102
    ## 1270     7.1     7.8  0.0078
    ## 1271     7.2     7.8  0.0078
    ## 1272     7.1     6.9  0.0069
    ## 1273     7.4     5.8  0.0058
    ## 1274     7.2     8.4  0.0084
    ## 1275    <NA>     6.5  0.0065
    ## 1276     7.2     9.0  0.0090
    ## 1277     7.4     5.6  0.0056
    ## 1278    <NA>      NA      NA
    ## 1279     6.9     4.6  0.0046
    ## 1280     7.5     5.6  0.0056
    ## 1281     7.3     7.5  0.0075
    ## 1282     7.5     8.7  0.0087
    ## 1283       7     7.3  0.0073
    ## 1284     7.3     8.6  0.0086
    ## 1285     7.1     7.0  0.0070
    ## 1286     7.2     7.9  0.0079
    ## 1287       7     9.1  0.0091
    ## 1288     7.4     5.2  0.0052
    ## 1289    <NA>     8.9  0.0089
    ## 1290     7.6     9.1  0.0091
    ## 1291     7.3     9.0  0.0090
    ## 1292     7.1     8.4  0.0084
    ## 1293     7.3     9.3  0.0093
    ## 1294     7.3     5.6  0.0056
    ## 1295       7     7.0  0.0070
    ## 1296     7.1     7.0  0.0070
    ## 1297     7.1      NA      NA
    ## 1298     7.3     7.3  0.0073
    ## 1299     7.3     8.6  0.0086
    ## 1300     6.9     9.2  0.0092
    ## 1301     7.1     8.0  0.0080
    ## 1302     6.8     5.4  0.0054
    ## 1303             7.6  0.0076
    ## 1304     7.3     8.7  0.0087
    ## 1305    <NA>     7.9  0.0079
    ## 1306     6.8     4.0  0.0040
    ## 1307     7.2     8.3  0.0083
    ## 1308     7.1     9.1  0.0091
    ## 1309     7.2     8.9  0.0089
    ## 1310     6.5     8.2  0.0082
    ## 1311     7.1     9.0  0.0090
    ## 1312       7     8.5  0.0085
    ## 1313     7.2     5.5  0.0055
    ## 1314     7.2     8.9  0.0089
    ## 1315    None     7.3  0.0073
    ## 1316     7.4     8.9  0.0089
    ## 1317     7.3      NA      NA
    ## 1318     7.2     7.5  0.0075
    ## 1319     7.3     5.4  0.0054
    ## 1320     7.6     8.6  0.0086
    ## 1321       7     7.4  0.0074
    ## 1322     6.8     4.3  0.0043
    ## 1323     6.9     5.9  0.0059
    ## 1324       7     7.6  0.0076
    ## 1325     7.2     8.3  0.0083
    ## 1326    None     4.7  0.0047
    ## 1327     7.2     7.7  0.0077
    ## 1328     6.7     5.7  0.0057
    ## 1329     7.3     9.3  0.0093
    ## 1330     7.2     7.0  0.0070
    ## 1331     7.4    10.5  0.0105
    ## 1332     7.5     9.5  0.0095
    ## 1333     7.2     8.2  0.0082
    ## 1334     6.9     8.8  0.0088
    ## 1335     6.8      NA      NA
    ## 1336     7.2     9.8  0.0098
    ## 1337       7     9.4  0.0094
    ## 1338     7.2     8.5  0.0085
    ## 1339     7.4     8.2  0.0082
    ## 1340    <NA>      NA      NA
    ## 1341     7.1     7.2  0.0072
    ## 1342     7.3     6.8  0.0068
    ## 1343    <NA>     9.3  0.0093
    ## 1344     7.4     7.9  0.0079
    ## 1345     7.2     6.7  0.0067
    ## 1346       7     6.3  0.0063
    ## 1347     6.7     6.0  0.0060
    ## 1348     7.3     7.8  0.0078
    ## 1349     7.2     7.2  0.0072
    ## 1350     7.2     8.7  0.0087
    ## 1351     7.1     9.0  0.0090
    ## 1352     7.2     6.9  0.0069
    ## 1353     7.3     5.9  0.0059
    ## 1354     7.4     5.9  0.0059
    ## 1355     7.2     7.7  0.0077
    ## 1356       7    10.2  0.0102
    ## 1357     7.1     8.4  0.0084
    ## 1358     7.5    11.8  0.0118
    ## 1359     7.3     9.3  0.0093
    ## 1360     7.3     7.6  0.0076
    ## 1361     7.4     6.3  0.0063
    ## 1362     7.4     9.8  0.0098
    ## 1363     7.4     7.8  0.0078
    ## 1364       7     8.1  0.0081
    ## 1365     7.2     8.7  0.0087
    ## 1366     6.9     6.4  0.0064
    ## 1367     7.6     8.4  0.0084
    ## 1368     6.9     7.6  0.0076
    ## 1369     7.3     9.0  0.0090
    ## 1370     7.3     8.3  0.0083
    ## 1371     7.3     9.1  0.0091
    ## 1372     7.2    10.2  0.0102
    ## 1373     7.2     7.9  0.0079
    ## 1374     6.9     8.3  0.0083
    ## 1375     7.6     6.8  0.0068
    ## 1376     7.4     9.6  0.0096
    ## 1377       7     8.5  0.0085
    ## 1378       7     8.2  0.0082
    ## 1379     6.9     5.2  0.0052
    ## 1380     7.4     8.3  0.0083
    ## 1381       7     7.5  0.0075
    ## 1382       7     7.8  0.0078
    ## 1383     7.2     7.1  0.0071
    ## 1384     7.3     8.5  0.0085
    ## 1385     6.9      NA      NA
    ## 1386     6.8     7.0  0.0070
    ## 1387     7.4     5.7  0.0057
    ## 1388     6.9     9.8  0.0098
    ## 1389     7.5     5.8  0.0058
    ## 1390     6.9     9.9  0.0099
    ## 1391     7.2     8.9  0.0089
    ## 1392     7.6     9.3  0.0093
    ## 1393     7.2     6.9  0.0069
    ## 1394     7.3     5.5  0.0055
    ## 1395     7.2     7.8  0.0078
    ## 1396       7     7.4  0.0074
    ## 1397     7.3     6.9  0.0069
    ## 1398     7.2     8.3  0.0083
    ## 1399     7.1     8.3  0.0083
    ## 1400     6.9     9.4  0.0094
    ## 1401     7.1     7.7  0.0077
    ## 1402     6.9     4.1  0.0041
    ## 1403       7     8.6  0.0086
    ## 1404     7.1     8.7  0.0087
    ## 1405     7.4     6.0  0.0060
    ## 1406     7.1     5.6  0.0056
    ## 1407     6.8     7.4  0.0074
    ## 1408     8.4    11.8  0.0118
    ## 1409     7.6     6.7  0.0067
    ## 1410     6.9     8.0  0.0080
    ## 1411     7.4     3.5  0.0035
    ## 1412    <NA>     6.9  0.0069
    ## 1413     7.2     8.4  0.0084
    ## 1414     6.8     6.8  0.0068
    ## 1415     7.1     7.9  0.0079
    ## 1416       7     9.0  0.0090
    ## 1417     6.7     7.8  0.0078
    ## 1418     7.2     9.0  0.0090
    ## 1419     7.3     9.1  0.0091
    ## 1420     7.1     8.9  0.0089
    ## 1421     7.2     7.0  0.0070
    ## 1422    <NA>     4.3  0.0043
    ## 1423     7.3     6.4  0.0064
    ## 1424       7     7.9  0.0079
    ## 1425     6.9     5.3  0.0053
    ## 1426     7.3     9.0  0.0090
    ## 1427     7.4     9.6  0.0096
    ## 1428     7.1     7.5  0.0075
    ## 1429     7.1     5.4  0.0054
    ## 1430     7.2     6.9  0.0069
    ## 1431     7.3     8.2  0.0082
    ## 1432     7.2     8.3  0.0083
    ## 1433     7.1     8.4  0.0084
    ## 1434     7.2     7.3  0.0073
    ## 1435     6.8     8.3  0.0083
    ## 1436     6.9     7.9  0.0079
    ## 1437     7.3     8.4  0.0084
    ## 1438     7.3     8.9  0.0089
    ## 1439     6.9    10.0  0.0100
    ## 1440     7.1     7.1  0.0071
    ## 1441     7.2     6.2  0.0062
    ## 1442     7.2     7.3  0.0073
    ## 1443     7.2     8.9  0.0089
    ## 1444     7.3     9.0  0.0090
    ## 1445     7.4     9.0  0.0090
    ## 1446     6.9     6.5  0.0065
    ## 1447    <NA>     7.6  0.0076
    ## 1448    <NA>     9.9  0.0099
    ## 1449     7.1     7.2  0.0072
    ## 1450     7.4     6.8  0.0068
    ## 1451     6.7     7.6  0.0076
    ## 1452       7      NA      NA
    ## 1453     6.9     8.0  0.0080
    ## 1454     7.3     8.7  0.0087
    ## 1455     7.3    11.8  0.0118
    ## 1456     6.9     7.3  0.0073
    ## 1457     7.4    10.7  0.0107
    ## 1458     7.6     9.4  0.0094
    ## 1459     7.5     7.1  0.0071
    ## 1460     7.1     6.0  0.0060
    ## 1461     7.3     5.2  0.0052
    ## 1462     6.9     7.5  0.0075
    ## 1463    <NA>     9.2  0.0092
    ## 1464     7.4     7.8  0.0078
    ## 1465     7.1     7.5  0.0075
    ## 1466       7     7.5  0.0075
    ## 1467     7.4     5.0  0.0050
    ## 1468    <NA>     8.5  0.0085
    ## 1469     6.8     6.8  0.0068
    ## 1470     6.8     6.7  0.0067
    ## 1471     7.5     8.2  0.0082
    ## 1472     7.1     7.6  0.0076
    ## 1473       7     7.0  0.0070
    ## 1474       7     7.0  0.0070
    ## 1475     6.8      NA      NA
    ## 1476     7.3     6.2  0.0062
    ## 1477     7.2     9.0  0.0090
    ## 1478     7.6     9.4  0.0094
    ## 1479     7.5     5.1  0.0051
    ## 1480     7.2     9.1  0.0091
    ## 1481     7.2     7.3  0.0073
    ## 1482     7.4     6.4  0.0064
    ## 1483     6.8     7.5  0.0075
    ## 1484       7     7.3  0.0073
    ## 1485     7.3     9.0  0.0090
    ## 1486     7.5     6.9  0.0069
    ## 1487     7.3     9.0  0.0090
    ## 1488     6.7     7.7  0.0077
    ## 1489     6.6     7.2  0.0072
    ## 1490     8.2    11.3  0.0113
    ## 1491     7.2     6.0  0.0060
    ## 1492     7.4     9.2  0.0092
    ## 1493       7     8.6  0.0086
    ## 1494     6.8    10.5  0.0105
    ## 1495     7.2     6.7  0.0067
    ## 1496     6.8     4.5  0.0045
    ## 1497     7.5     9.0  0.0090
    ## 1498     7.5     8.2  0.0082
    ## 1499     6.8     7.3  0.0073
    ## 1500     7.4     6.8  0.0068
    ## 1501       7     8.6  0.0086
    ## 1502     6.7     9.1  0.0091
    ## 1503     6.9     6.2  0.0062
    ## 1504     7.3     8.0  0.0080
    ## 1505     7.2     7.3  0.0073
    ## 1506     7.1     6.8  0.0068
    ## 1507     7.1     6.6  0.0066
    ## 1508     7.2     6.8  0.0068
    ## 1509     6.7     7.7  0.0077
    ## 1510     6.8     6.8  0.0068
    ## 1511     7.1     8.2  0.0082
    ## 1512     7.6     9.0  0.0090
    ## 1513       7     8.1  0.0081
    ## 1514     6.8     8.3  0.0083
    ## 1515     7.4     6.8  0.0068
    ## 1516     7.1     5.7  0.0057
    ## 1517       7     8.7  0.0087
    ## 1518       7     8.3  0.0083
    ## 1519       7     8.0  0.0080
    ## 1520     7.2     9.1  0.0091
    ## 1521     7.3     8.8  0.0088
    ## 1522     7.2     7.2  0.0072
    ## 1523     6.9     7.4  0.0074
    ## 1524     7.2     7.0  0.0070
    ## 1525     7.2     6.4  0.0064
    ## 1526     7.7    11.1  0.0111
    ## 1527     6.8     7.2  0.0072
    ## 1528     7.1      NA      NA
    ## 1529     7.3     6.2  0.0062
    ## 1530     7.2     4.3  0.0043
    ## 1531     7.2     8.6  0.0086
    ## 1532       7     6.9  0.0069
    ## 1533     7.1     7.4  0.0074
    ## 1534     7.5     6.1  0.0061
    ## 1535     7.1     7.8  0.0078
    ## 1536       7     8.0  0.0080
    ## 1537       7     7.0  0.0070
    ## 1538     7.5     8.9  0.0089
    ## 1539     7.7    12.0  0.0120
    ## 1540     7.1     8.7  0.0087
    ## 1541     7.2     8.0  0.0080
    ## 1542     7.2     8.0  0.0080
    ## 1543    <NA>     7.8  0.0078
    ## 1544     6.9     5.0  0.0050
    ## 1545     7.3     8.7  0.0087
    ## 1546     6.8     9.9  0.0099
    ## 1547     7.2     7.5  0.0075
    ## 1548     7.2      NA      NA
    ## 1549       7     6.6  0.0066
    ## 1550     6.7     9.8  0.0098
    ## 1551     7.5     9.1  0.0091
    ## 1552     7.1     6.7  0.0067
    ## 1553     7.5     7.5  0.0075
    ## 1554     7.2     8.9  0.0089
    ## 1555     7.3     5.9  0.0059
    ## 1556     7.4     5.5  0.0055
    ## 1557     7.3     8.4  0.0084
    ## 1558     7.1     7.0  0.0070
    ## 1559       7     6.9  0.0069
    ## 1560     7.3    11.2  0.0112
    ## 1561     6.9     7.1  0.0071
    ## 1562     6.6     8.4  0.0084
    ## 1563     7.1     8.0  0.0080
    ## 1564     7.3     5.6  0.0056
    ## 1565     6.9     9.5  0.0095
    ## 1566     6.9     5.8  0.0058
    ## 1567     6.9     8.3  0.0083
    ## 1568     7.2     7.9  0.0079
    ## 1569     7.2     7.9  0.0079
    ## 1570     7.2     7.7  0.0077
    ## 1571     7.2     7.2  0.0072
    ## 1572     7.7     6.4  0.0064
    ## 1573    <NA>     7.0  0.0070
    ## 1574     7.4     6.2  0.0062
    ## 1575     7.3     7.9  0.0079
    ## 1576    <NA>     6.7  0.0067
    ## 1577     7.2     7.8  0.0078
    ## 1578       7     7.2  0.0072
    ## 1579       7     7.2  0.0072
    ## 1580     6.9     7.5  0.0075
    ## 1581     7.1     8.6  0.0086
    ## 1582     7.2     6.7  0.0067
    ## 1583     7.9     9.0  0.0090
    ## 1584     7.2     8.6  0.0086
    ## 1585     6.9     8.3  0.0083
    ## 1586     7.3     8.9  0.0089
    ## 1587       7     7.6  0.0076
    ## 1588     7.6     6.8  0.0068
    ## 1589     6.7     6.0  0.0060
    ## 1590     7.3     8.4  0.0084
    ## 1591    <NA>     8.4  0.0084
    ## 1592       7     6.7  0.0067
    ## 1593       7     7.6  0.0076
    ## 1594     7.3     9.1  0.0091
    ## 1595     7.3     6.8  0.0068
    ## 1596     6.7     7.0  0.0070
    ## 1597             6.2  0.0062
    ## 1598     7.2     5.6  0.0056
    ## 1599     6.7     8.5  0.0085
    ## 1600     6.9     6.6  0.0066
    ## 1601     7.4     9.2  0.0092
    ## 1602     7.2     7.7  0.0077
    ## 1603     7.1     8.0  0.0080
    ## 1604     7.1     8.3  0.0083
    ## 1605     6.8      NA      NA
    ## 1606     7.2     7.2  0.0072
    ## 1607     7.1     6.2  0.0062
    ## 1608     7.3     7.9  0.0079
    ## 1609     7.2     8.7  0.0087
    ## 1610     7.3     9.6  0.0096
    ## 1611     6.8     7.8  0.0078
    ## 1612     6.9     6.6  0.0066
    ## 1613     7.1     7.9  0.0079
    ## 1614     7.2     7.9  0.0079
    ## 1615     7.2     8.2  0.0082
    ## 1616    <NA>     6.9  0.0069
    ## 1617     7.1     6.9  0.0069
    ## 1618     7.2     7.6  0.0076
    ## 1619       9    11.8  0.0118
    ## 1620     7.2     8.3  0.0083
    ## 1621       7     7.9  0.0079
    ## 1622       7     8.6  0.0086
    ## 1623     7.2     7.0  0.0070
    ## 1624       7     8.3  0.0083
    ## 1625       7     7.0  0.0070
    ## 1626     7.2     6.3  0.0063
    ## 1627     7.1     6.7  0.0067
    ## 1628     7.4     8.9  0.0089
    ## 1629     7.6     9.2  0.0092
    ## 1630     7.1     7.6  0.0076
    ## 1631     7.1     8.9  0.0089
    ## 1632     7.1     8.5  0.0085
    ## 1633     6.9     7.4  0.0074
    ## 1634     6.9     7.6  0.0076
    ## 1635     6.9     8.4  0.0084
    ## 1636     6.8     8.3  0.0083
    ## 1637     7.1     7.2  0.0072
    ## 1638     6.6     6.6  0.0066
    ## 1639     7.1     8.3  0.0083
    ## 1640       7     6.9  0.0069
    ## 1641     6.8     6.9  0.0069
    ## 1642       7     9.0  0.0090
    ## 1643     7.1     7.3  0.0073
    ## 1644     7.2     7.1  0.0071
    ## 1645       7     8.1  0.0081
    ## 1646     7.2     6.9  0.0069
    ## 1647     7.4    10.1  0.0101
    ## 1648       7     8.5  0.0085
    ## 1649       7     7.7  0.0077
    ## 1650     7.2     8.3  0.0083
    ## 1651     7.4     6.4  0.0064
    ## 1652    <NA>     7.8  0.0078
    ## 1653     6.9     8.1  0.0081
    ## 1654     7.2     8.3  0.0083
    ## 1655     7.3     5.6  0.0056
    ## 1656     7.4     7.8  0.0078
    ## 1657     6.9     9.7  0.0097
    ## 1658     7.4     5.7  0.0057
    ## 1659     7.2     8.1  0.0081
    ## 1660    <NA>     8.5  0.0085
    ## 1661     7.2     5.8  0.0058
    ## 1662     7.1     7.9  0.0079
    ## 1663     7.1     8.0  0.0080
    ## 1664     7.3      NA      NA
    ## 1665     7.1     7.0  0.0070
    ## 1666     7.4     8.5  0.0085
    ## 1667     7.2     7.0  0.0070
    ## 1668     6.8    10.5  0.0105
    ## 1669     7.2     8.3  0.0083
    ## 1670       7     8.1  0.0081
    ## 1671     6.9     9.3  0.0093
    ## 1672       7     8.1  0.0081
    ## 1673     7.3     6.5  0.0065
    ## 1674       7     8.5  0.0085
    ## 1675     7.4    10.5  0.0105
    ## 1676     7.4     5.3  0.0053
    ## 1677     7.4     5.9  0.0059
    ## 1678     6.9     9.7  0.0097
    ## 1679     6.8    10.0  0.0100
    ## 1680     7.2     7.8  0.0078
    ## 1681     6.9     6.1  0.0061
    ## 1682     7.1     7.2  0.0072
    ## 1683    <NA>     7.5  0.0075
    ## 1684     7.4     9.9  0.0099
    ## 1685     7.1     7.4  0.0074
    ## 1686     6.9     5.4  0.0054
    ## 1687     6.7     9.5  0.0095
    ## 1688     7.3     8.6  0.0086
    ## 1689     7.3     9.1  0.0091
    ## 1690     8.2     8.0  0.0080
    ## 1691     7.3     6.1  0.0061
    ## 1692     7.3     9.1  0.0091
    ## 1693     7.1     7.7  0.0077
    ## 1694     7.5     7.8  0.0078
    ## 1695     7.3     5.6  0.0056
    ## 1696       7     7.9  0.0079
    ## 1697     7.4     8.0  0.0080
    ## 1698       7     8.8  0.0088
    ## 1699     7.1     6.8  0.0068
    ## 1700     7.3     7.0  0.0070
    ## 1701     6.9     5.4  0.0054
    ## 1702     7.1     9.0  0.0090
    ## 1703     7.1     8.8  0.0088
    ## 1704    <NA>    10.0  0.0100
    ## 1705     7.2     6.3  0.0063
    ## 1706     7.2     7.8  0.0078
    ## 1707       7     7.1  0.0071
    ## 1708     6.6     6.5  0.0065
    ## 1709     7.4     6.9  0.0069
    ## 1710       7     6.3  0.0063
    ## 1711     8.8    12.4  0.0124
    ## 1712     7.2     7.7  0.0077
    ## 1713     6.8     4.2  0.0042
    ## 1714     7.5     6.0  0.0060
    ## 1715     7.1     8.8  0.0088
    ## 1716     7.1     7.0  0.0070
    ## 1717     6.8     7.4  0.0074
    ## 1718     7.5     8.6  0.0086
    ## 1719     7.1     6.8  0.0068
    ## 1720     6.9     9.3  0.0093
    ## 1721     6.9     9.7  0.0097
    ## 1722     7.3     8.2  0.0082
    ## 1723     7.3     7.4  0.0074
    ## 1724       7     6.8  0.0068
    ## 1725     6.8     7.9  0.0079
    ## 1726     7.1     8.0  0.0080
    ## 1727     6.7     7.3  0.0073
    ## 1728     6.8     6.9  0.0069
    ## 1729     7.3     7.8  0.0078
    ## 1730     7.3     7.3  0.0073
    ## 1731     7.1     6.9  0.0069
    ## 1732     7.3     5.0  0.0050
    ## 1733     7.1     5.2  0.0052
    ## 1734     7.4     5.4  0.0054
    ## 1735     7.4     5.6  0.0056
    ## 1736     6.8     6.7  0.0067
    ## 1737     7.6     9.4  0.0094
    ## 1738     7.1     6.0  0.0060
    ## 1739     7.3     8.3  0.0083
    ## 1740     6.8     4.4  0.0044
    ## 1741     7.2     7.2  0.0072
    ## 1742       7     6.9  0.0069
    ## 1743     7.1     7.9  0.0079
    ## 1744     7.4     6.0  0.0060
    ## 1745     6.4     7.2  0.0072
    ## 1746     7.2     7.6  0.0076
    ## 1747     7.4     6.0  0.0060
    ## 1748    <NA>     7.9  0.0079
    ## 1749     7.1     7.0  0.0070
    ## 1750     6.8     5.3  0.0053
    ## 1751     7.5     9.4  0.0094
    ## 1752     6.9     8.1  0.0081
    ## 1753     7.1     7.4  0.0074
    ## 1754     7.2     8.7  0.0087
    ## 1755     6.8     8.3  0.0083
    ## 1756       8     7.7  0.0077
    ## 1757       7     7.0  0.0070
    ## 1758     7.4     3.6  0.0036
    ## 1759     7.2     6.7  0.0067
    ## 1760     6.9     9.4  0.0094
    ## 1761     7.1     7.7  0.0077
    ## 1762     7.2     7.6  0.0076
    ## 1763     7.3     9.3  0.0093
    ## 1764     7.2      NA      NA
    ## 1765     7.1     6.9  0.0069
    ## 1766     7.2     7.3  0.0073
    ## 1767     7.5     5.9  0.0059
    ## 1768       8    10.1  0.0101
    ## 1769     7.4     6.5  0.0065
    ## 1770     7.1     7.2  0.0072
    ## 1771     7.4     5.1  0.0051
    ## 1772     7.3     9.0  0.0090
    ## 1773     7.2     8.2  0.0082
    ## 1774     7.2     8.0  0.0080
    ## 1775       7     7.1  0.0071
    ## 1776     7.2     8.8  0.0088
    ## 1777     7.3      NA      NA
    ## 1778     7.9     6.7  0.0067
    ## 1779     7.3     8.5  0.0085
    ## 1780     6.9     5.9  0.0059
    ## 1781       7     8.4  0.0084
    ## 1782       7     7.8  0.0078
    ## 1783     7.1     7.7  0.0077
    ## 1784     7.1     6.6  0.0066
    ## 1785     7.1     7.7  0.0077
    ## 1786     7.3     5.4  0.0054
    ## 1787     7.3     5.8  0.0058
    ## 1788    <NA>     7.7  0.0077
    ## 1789     7.6     6.2  0.0062
    ## 1790     6.9     6.9  0.0069
    ## 1791       7     8.1  0.0081
    ## 1792     7.1     7.5  0.0075
    ## 1793       7     6.2  0.0062
    ## 1794     7.3     8.5  0.0085
    ## 1795     7.3    10.8  0.0108
    ## 1796       7     8.0  0.0080
    ## 1797     7.2     8.9  0.0089
    ## 1798     7.2     7.8  0.0078
    ## 1799     7.1      NA      NA
    ## 1800     7.4     8.8  0.0088
    ## 1801     7.4     6.3  0.0063
    ## 1802    <NA>    11.0  0.0110
    ## 1803     6.9     9.8  0.0098
    ## 1804     7.3     6.1  0.0061
    ## 1805     7.5     6.5  0.0065
    ## 1806     7.2     7.0  0.0070
    ## 1807     8.5     8.1  0.0081
    ## 1808       7     8.4  0.0084
    ## 1809     7.1     9.1  0.0091
    ## 1810     7.1     4.0  0.0040
    ## 1811     7.2     8.9  0.0089
    ## 1812     7.2     8.8  0.0088
    ## 1813       7     7.0  0.0070
    ## 1814     7.2     6.4  0.0064
    ## 1815     7.1     8.7  0.0087
    ## 1816     7.4    10.1  0.0101
    ## 1817     7.5     6.8  0.0068
    ## 1818     7.2     7.6  0.0076
    ## 1819             6.5  0.0065
    ## 1820     7.1     7.9  0.0079
    ## 1821     7.2     8.1  0.0081
    ## 1822     7.1     7.9  0.0079
    ## 1823     6.6     7.9  0.0079
    ## 1824     7.1     8.2  0.0082
    ## 1825     7.1     6.9  0.0069
    ## 1826     6.8     7.1  0.0071
    ## 1827     7.3     8.2  0.0082
    ## 1828     7.3     8.5  0.0085
    ## 1829     7.3     9.0  0.0090
    ## 1830     7.1     7.5  0.0075
    ## 1831     7.1     7.3  0.0073
    ## 1832     6.3     7.2  0.0072
    ## 1833     7.3     8.3  0.0083
    ## 1834       7     8.2  0.0082
    ## 1835     7.3    10.3  0.0103
    ## 1836     7.1     6.5  0.0065
    ## 1837     7.2     7.8  0.0078
    ## 1838     7.1     8.4  0.0084
    ## 1839     6.4     6.5  0.0065
    ## 1840     7.3     7.2  0.0072
    ## 1841     7.3     6.1  0.0061
    ## 1842     7.2     8.0  0.0080
    ## 1843     7.3     9.1  0.0091
    ## 1844     7.4     6.2  0.0062
    ## 1845     7.5     7.4  0.0074
    ## 1846     6.8      NA      NA
    ## 1847     7.3     8.2  0.0082
    ## 1848       7     7.3  0.0073
    ## 1849     7.1     8.6  0.0086
    ## 1850     7.4    10.7  0.0107
    ## 1851     7.5     5.7  0.0057
    ## 1852       7     6.7  0.0067
    ## 1853       9    10.3  0.0103
    ## 1854     7.2     7.4  0.0074
    ## 1855     7.2     7.8  0.0078
    ## 1856       7     7.7  0.0077
    ## 1857     7.5     6.3  0.0063
    ## 1858     7.3     5.8  0.0058
    ## 1859       7     8.8  0.0088
    ## 1860     7.2     9.6  0.0096
    ## 1861     7.1     8.5  0.0085
    ## 1862     6.9     7.3  0.0073
    ## 1863       7     8.6  0.0086
    ## 1864     7.6     5.9  0.0059
    ## 1865     7.5     6.2  0.0062
    ## 1866       7     5.8  0.0058
    ## 1867     7.3     8.7  0.0087
    ## 1868       7     6.8  0.0068
    ## 1869     7.4     5.7  0.0057
    ## 1870     7.4     5.9  0.0059
    ## 1871     7.1     5.7  0.0057
    ## 1872     7.2     6.2  0.0062
    ## 1873     7.4     6.3  0.0063
    ## 1874     6.3     5.5  0.0055
    ## 1875    <NA>     7.9  0.0079
    ## 1876     6.5     6.9  0.0069
    ## 1877       7     7.8  0.0078
    ## 1878     7.2     7.7  0.0077
    ## 1879     6.8    10.6  0.0106
    ## 1880     7.1     9.3  0.0093
    ## 1881     7.4     6.0  0.0060
    ## 1882    <NA>     7.9  0.0079
    ## 1883    <NA>     8.4  0.0084
    ## 1884     6.9     6.0  0.0060
    ## 1885     7.3     5.5  0.0055
    ## 1886     7.1     7.2  0.0072
    ## 1887     7.3     7.3  0.0073
    ## 1888       7     6.3  0.0063
    ## 1889     7.3     7.9  0.0079
    ## 1890     7.2     7.7  0.0077
    ## 1891     7.1     8.1  0.0081
    ## 1892     7.3     9.0  0.0090
    ## 1893     7.2     8.8  0.0088
    ## 1894     7.4     6.4  0.0064
    ## 1895     7.2     8.5  0.0085
    ## 1896     6.8     4.7  0.0047
    ## 1897     6.8     9.1  0.0091
    ## 1898     7.3     8.6  0.0086
    ## 1899     7.6     6.9  0.0069
    ## 1900    <NA>    10.5  0.0105
    ## 1901     7.2     8.5  0.0085
    ## 1902     7.3     8.7  0.0087
    ## 1903     7.1     6.9  0.0069
    ## 1904     6.9     5.5  0.0055
    ## 1905       7     8.2  0.0082
    ## 1906     7.2     7.2  0.0072
    ## 1907       7     7.6  0.0076
    ## 1908     7.2     7.5  0.0075
    ## 1909    <NA>     8.1  0.0081
    ## 1910     6.8     6.2  0.0062
    ## 1911     7.1    10.9  0.0109
    ## 1912     7.2     8.2  0.0082
    ## 1913     7.1     7.3  0.0073
    ## 1914     6.9    10.1  0.0101
    ## 1915       7     6.6  0.0066
    ## 1916     7.2     8.4  0.0084
    ## 1917     7.2     6.8  0.0068
    ## 1918     7.3     8.7  0.0087
    ## 1919     7.3     6.1  0.0061
    ## 1920     7.8    11.1  0.0111
    ## 1921     6.9     8.7  0.0087
    ## 1922     7.1     9.2  0.0092
    ## 1923     6.7     7.4  0.0074
    ## 1924       7     8.6  0.0086
    ## 1925     7.5     6.4  0.0064
    ## 1926     7.1     9.1  0.0091
    ## 1927     7.2     7.3  0.0073
    ## 1928     7.5     6.2  0.0062
    ## 1929     7.4     6.0  0.0060
    ## 1930     7.2     8.6  0.0086
    ## 1931     6.9    10.0  0.0100
    ## 1932     7.2     6.5  0.0065
    ## 1933       7     7.8  0.0078
    ## 1934     6.4     7.7  0.0077
    ## 1935     6.9     8.2  0.0082
    ## 1936       7     8.7  0.0087
    ## 1937     7.3     8.8  0.0088
    ## 1938     6.9     9.2  0.0092
    ## 1939     7.5     7.7  0.0077
    ## 1940     7.1     6.9  0.0069
    ## 1941     7.2    10.1  0.0101
    ## 1942     7.1     7.2  0.0072
    ## 1943     6.8     5.3  0.0053
    ## 1944     6.6     7.6  0.0076
    ## 1945     7.5     8.7  0.0087
    ## 1946     7.3     7.5  0.0075
    ## 1947     7.2     9.7  0.0097
    ## 1948     6.8     7.5  0.0075
    ## 1949       7     7.1  0.0071
    ## 1950     6.9     7.7  0.0077
    ## 1951       7     9.0  0.0090
    ## 1952       7     7.5  0.0075
    ## 1953     7.4     8.6  0.0086
    ## 1954     7.4     6.6  0.0066
    ## 1955     7.2     8.6  0.0086
    ## 1956     8.3    11.6  0.0116
    ## 1957     6.9     6.5  0.0065
    ## 1958       7     6.9  0.0069
    ## 1959     7.4     8.7  0.0087
    ## 1960     7.2     7.1  0.0071
    ## 1961     7.2     6.4  0.0064
    ## 1962     6.6     8.6  0.0086
    ## 1963       7    10.1  0.0101
    ## 1964              NA      NA
    ## 1965     7.2     7.3  0.0073
    ## 1966     7.4     5.9  0.0059
    ## 1967     7.1     9.3  0.0093
    ## 1968     7.2     8.5  0.0085
    ## 1969     7.1     6.8  0.0068
    ## 1970     7.1     6.7  0.0067
    ## 1971     7.3     6.5  0.0065
    ## 1972     7.1     7.9  0.0079
    ## 1973     6.8     8.0  0.0080
    ## 1974     7.1     7.3  0.0073
    ## 1975     7.3     7.7  0.0077
    ## 1976     6.6     7.8  0.0078
    ## 1977     6.6     7.4  0.0074
    ## 1978     7.2     7.0  0.0070
    ## 1979     7.4     8.8  0.0088
    ## 1980     6.9     6.6  0.0066
    ## 1981     7.2     9.0  0.0090
    ## 1982     7.2     3.5  0.0035
    ## 1983     7.3     6.4  0.0064
    ## 1984     7.1     8.0  0.0080
    ## 1985     7.2     9.3  0.0093
    ## 1986     7.2     8.1  0.0081
    ## 1987     6.8     8.7  0.0087
    ## 1988     7.5     5.7  0.0057
    ## 1989     6.7     7.3  0.0073
    ## 1990     7.2     7.4  0.0074
    ## 1991     7.2     9.0  0.0090
    ## 1992       7     6.9  0.0069
    ## 1993     6.9      NA      NA
    ## 1994     7.4     5.5  0.0055
    ## 1995     7.1     7.9  0.0079
    ## 1996     7.6     9.8  0.0098
    ## 1997       8    10.0  0.0100
    ## 1998     7.2     8.4  0.0084
    ## 1999       7      NA      NA
    ## 2000     7.1     7.1  0.0071
    ## 2001     6.8     7.6  0.0076
    ## 2002     7.2     6.3  0.0063
    ## 2003     7.4      NA      NA
    ## 2004     7.2     8.5  0.0085
    ## 2005     7.2     7.3  0.0073
    ## 2006     7.3     6.3  0.0063
    ## 2007     7.3     6.9  0.0069
    ## 2008     7.2     7.9  0.0079
    ## 2009     7.1     7.6  0.0076
    ## 2010     7.3     9.9  0.0099
    ## 2011     7.7     8.9  0.0089
    ## 2012     7.2     8.1  0.0081
    ## 2013     7.4     8.5  0.0085
    ## 2014     7.5     5.2  0.0052
    ## 2015     7.2     7.1  0.0071
    ## 2016       7     8.1  0.0081
    ## 2017       7     9.0  0.0090
    ## 2018     7.3     9.6  0.0096
    ## 2019     7.1     8.7  0.0087
    ## 2020       7     6.2  0.0062
    ## 2021     7.2     8.2  0.0082
    ## 2022     6.8    10.3  0.0103
    ## 2023     7.3     5.6  0.0056
    ## 2024     6.8     5.0  0.0050
    ## 2025     7.2     7.3  0.0073
    ## 2026     6.6     9.2  0.0092
    ## 2027     7.3     5.3  0.0053
    ## 2028     7.4     8.2  0.0082
    ## 2029     7.2     7.4  0.0074
    ## 2030    None     8.8  0.0088
    ## 2031     7.3     8.6  0.0086
    ## 2032       7     8.7  0.0087
    ## 2033       7     8.2  0.0082
    ## 2034     7.1     8.6  0.0086
    ## 2035     7.3     9.4  0.0094
    ## 2036     6.8     9.7  0.0097
    ## 2037       7     7.7  0.0077
    ## 2038       7     7.4  0.0074
    ## 2039     7.2     7.0  0.0070
    ## 2040     7.6     6.5  0.0065
    ## 2041     6.5     6.3  0.0063
    ## 2042     7.2     7.3  0.0073
    ## 2043       8    11.0  0.0110
    ## 2044     7.2     7.8  0.0078
    ## 2045     7.5     6.4  0.0064
    ## 2046     7.4     8.0  0.0080
    ## 2047       7     7.0  0.0070
    ## 2048     7.1     8.6  0.0086
    ## 2049     7.3     5.3  0.0053
    ## 2050       7     6.6  0.0066
    ## 2051     7.4     6.0  0.0060
    ## 2052     7.3     5.6  0.0056
    ## 2053     7.1     7.7  0.0077
    ## 2054       7     6.4  0.0064
    ## 2055     7.2     7.9  0.0079
    ## 2056    <NA>     5.9  0.0059
    ## 2057     7.4     6.6  0.0066
    ## 2058     7.2     9.0  0.0090
    ## 2059     6.8     5.2  0.0052
    ## 2060     7.5     5.6  0.0056
    ## 2061     7.4     6.6  0.0066
    ## 2062     7.4     5.7  0.0057
    ## 2063     7.2     4.1  0.0041
    ## 2064     7.7     9.9  0.0099
    ## 2065     7.3      NA      NA
    ## 2066       7     7.7  0.0077
    ## 2067     7.4     5.8  0.0058
    ## 2068             6.0  0.0060
    ## 2069     7.1     7.2  0.0072
    ## 2070     7.2     9.0  0.0090
    ## 2071     7.1     6.4  0.0064
    ## 2072     7.5     8.2  0.0082
    ## 2073     7.7     7.5  0.0075
    ## 2074     7.2     8.3  0.0083
    ## 2075       7     7.6  0.0076
    ## 2076     6.8     9.8  0.0098
    ## 2077     8.9     9.9  0.0099
    ## 2078     7.3      NA      NA
    ## 2079     7.2     8.7  0.0087
    ## 2080     7.3     8.6  0.0086
    ## 2081     6.6     8.1  0.0081
    ## 2082     6.8    10.3  0.0103
    ## 2083    <NA>     7.3  0.0073
    ## 2084     7.5     6.1  0.0061
    ## 2085     7.1     8.5  0.0085
    ## 2086    <NA>     9.4  0.0094
    ## 2087     7.1     6.6  0.0066
    ## 2088     7.3     5.8  0.0058
    ## 2089     7.3     8.6  0.0086
    ## 2090     7.1     6.8  0.0068
    ## 2091     7.1     7.5  0.0075
    ## 2092       7     8.8  0.0088
    ## 2093     7.6     8.3  0.0083
    ## 2094     7.2     8.1  0.0081
    ## 2095       7     7.4  0.0074
    ## 2096     7.3     8.9  0.0089
    ## 2097     7.4     5.4  0.0054
    ## 2098     7.3     8.6  0.0086
    ## 2099     7.5     6.5  0.0065
    ## 2100     7.4     5.6  0.0056
    ## 2101     7.5     5.7  0.0057
    ## 2102             6.3  0.0063
    ## 2103     7.5     8.8  0.0088
    ## 2104     7.3     8.8  0.0088
    ## 2105     7.2     7.7  0.0077
    ## 2106     6.9     8.7  0.0087
    ## 2107     7.6     9.4  0.0094
    ## 2108       8     7.5  0.0075
    ## 2109     7.4     6.4  0.0064
    ## 2110     7.1     8.0  0.0080
    ## 2111     6.9     5.5  0.0055
    ## 2112       7     8.2  0.0082
    ## 2113       7     7.8  0.0078
    ## 2114     7.2     8.9  0.0089
    ## 2115     7.4     6.6  0.0066
    ## 2116     7.2     7.0  0.0070
    ## 2117     7.5     7.2  0.0072
    ## 2118     7.7     9.2  0.0092
    ## 2119     7.8     9.2  0.0092
    ## 2120     7.3     9.0  0.0090
    ## 2121     7.4     7.6  0.0076
    ## 2122     6.9     5.9  0.0059
    ## 2123    <NA>     6.5  0.0065
    ## 2124     6.9     8.3  0.0083
    ## 2125     7.2     7.3  0.0073
    ## 2126     7.2     8.0  0.0080
    ## 2127     7.4     8.6  0.0086
    ## 2128     7.6     8.8  0.0088
    ## 2129     7.2     6.3  0.0063
    ## 2130     6.9     9.8  0.0098
    ## 2131     7.2     8.6  0.0086
    ## 2132     7.6     9.8  0.0098
    ## 2133     6.5     6.3  0.0063
    ## 2134     6.8     8.5  0.0085
    ## 2135     7.3     9.0  0.0090
    ## 2136     7.2     7.0  0.0070
    ## 2137     6.8     4.2  0.0042
    ## 2138     7.4     5.9  0.0059
    ## 2139       7     7.2  0.0072
    ## 2140     7.4    10.0  0.0100
    ## 2141     7.3     8.7  0.0087
    ## 2142     7.1     8.3  0.0083
    ## 2143       7     6.5  0.0065
    ## 2144     7.2     7.3  0.0073
    ## 2145     7.2     7.5  0.0075
    ## 2146     7.2     7.0  0.0070
    ## 2147     7.1     7.7  0.0077
    ## 2148    <NA>     8.2  0.0082
    ## 2149     7.2     7.9  0.0079
    ## 2150     7.3     8.1  0.0081
    ## 2151     7.1     5.6  0.0056
    ## 2152       7     9.2  0.0092
    ## 2153     7.2      NA      NA
    ## 2154     7.2     7.3  0.0073
    ## 2155     7.1     7.7  0.0077
    ## 2156     6.8     7.4  0.0074
    ## 2157     7.2     8.2  0.0082
    ## 2158     7.2     8.1  0.0081
    ## 2159     7.1     8.5  0.0085
    ## 2160     7.6     8.8  0.0088
    ## 2161     6.8     7.5  0.0075
    ## 2162       7     6.7  0.0067
    ## 2163       7     9.9  0.0099
    ## 2164     7.2     8.2  0.0082
    ## 2165     7.2     6.7  0.0067
    ## 2166     7.2     7.5  0.0075
    ## 2167     6.9      NA      NA
    ## 2168     6.8     8.0  0.0080
    ## 2169     7.1     7.4  0.0074
    ## 2170       7     7.1  0.0071
    ## 2171     7.2     6.7  0.0067
    ## 2172     7.1     6.8  0.0068
    ## 2173     6.8     3.7  0.0037
    ## 2174     6.6     7.0  0.0070
    ## 2175       7     7.2  0.0072
    ## 2176     7.2     6.8  0.0068
    ## 2177     7.2     8.6  0.0086
    ## 2178     7.2     7.4  0.0074
    ## 2179     7.6     9.6  0.0096
    ## 2180     7.2     8.8  0.0088
    ## 2181     7.3     6.5  0.0065
    ## 2182       7     8.4  0.0084
    ## 2183     7.3     5.3  0.0053
    ## 2184     7.2     6.8  0.0068
    ## 2185     6.6     7.2  0.0072
    ## 2186     7.2     8.0  0.0080
    ## 2187     7.2     7.3  0.0073
    ## 2188     7.3     8.9  0.0089
    ## 2189     7.4     5.3  0.0053
    ## 2190     7.3     5.7  0.0057
    ## 2191     7.4     7.7  0.0077
    ## 2192     7.4     9.9  0.0099
    ## 2193     6.6     7.3  0.0073
    ## 2194     7.1     9.8  0.0098
    ## 2195     7.2     8.5  0.0085
    ## 2196     7.4     5.6  0.0056
    ## 2197       7     7.0  0.0070
    ## 2198       7     7.5  0.0075
    ## 2199     7.2     7.0  0.0070
    ## 2200     7.5     8.8  0.0088
    ## 2201     6.7     8.3  0.0083
    ## 2202       7     9.1  0.0091
    ## 2203     7.1     8.9  0.0089
    ## 2204       7     7.8  0.0078
    ## 2205     7.3     9.1  0.0091
    ## 2206     7.1     8.3  0.0083
    ## 2207    <NA>     9.1  0.0091
    ## 2208     7.2      NA      NA
    ## 2209     7.2     8.5  0.0085
    ## 2210     7.2     7.5  0.0075
    ## 2211     7.2     8.5  0.0085
    ## 2212       7     8.4  0.0084
    ## 2213     7.2     8.4  0.0084
    ## 2214     7.3     8.7  0.0087
    ## 2215     7.3     8.9  0.0089
    ## 2216     7.5     5.1  0.0051
    ## 2217     7.2     8.8  0.0088
    ## 2218     7.1     7.6  0.0076
    ## 2219     7.2     7.5  0.0075
    ## 2220     6.7     7.0  0.0070
    ## 2221     6.8     3.8  0.0038
    ## 2222     6.3     7.6  0.0076
    ## 2223     6.9     8.4  0.0084
    ## 2224     6.2     5.6  0.0056
    ## 2225     6.9     6.2  0.0062
    ## 2226       7     6.9  0.0069
    ## 2227     8.1    10.9  0.0109
    ## 2228     7.2     7.7  0.0077
    ## 2229     7.2     6.8  0.0068
    ## 2230     7.4     6.6  0.0066
    ## 2231     6.9     5.4  0.0054
    ## 2232       7     8.5  0.0085
    ## 2233     7.6     9.6  0.0096
    ## 2234     7.1     7.8  0.0078
    ## 2235    <NA>     8.8  0.0088
    ## 2236     7.2     8.7  0.0087
    ## 2237     6.8     8.2  0.0082
    ## 2238       7     7.4  0.0074
    ## 2239       7     7.4  0.0074
    ## 2240     6.8     7.5  0.0075
    ## 2241    <NA>     9.2  0.0092
    ## 2242     7.2     7.8  0.0078
    ## 2243     7.2     7.4  0.0074
    ## 2244     7.4     6.2  0.0062
    ## 2245     7.3     6.4  0.0064
    ## 2246     7.2     8.4  0.0084
    ## 2247       7     6.6  0.0066
    ## 2248     7.2     7.3  0.0073
    ## 2249       7     8.8  0.0088
    ## 2250     7.2     6.5  0.0065
    ## 2251     7.3     6.7  0.0067
    ## 2252     7.2     6.9  0.0069
    ## 2253       7     8.3  0.0083
    ## 2254     7.2     8.3  0.0083
    ## 2255       7     6.5  0.0065
    ## 2256       7     7.4  0.0074
    ## 2257     7.2     9.8  0.0098
    ## 2258     7.5     7.0  0.0070
    ## 2259     7.1     6.7  0.0067
    ## 2260     7.3     5.1  0.0051
    ## 2261     7.3     6.2  0.0062
    ## 2262     7.2      NA      NA
    ## 2263     7.2     8.6  0.0086
    ## 2264       7     7.4  0.0074
    ## 2265     6.8     8.4  0.0084
    ## 2266     6.9     8.2  0.0082
    ## 2267     7.5     7.4  0.0074
    ## 2268     7.2     8.1  0.0081
    ## 2269     6.9     6.4  0.0064
    ## 2270     7.2     8.2  0.0082
    ## 2271     7.6     9.5  0.0095
    ## 2272     7.2     7.6  0.0076
    ## 2273     7.4     6.7  0.0067
    ## 2274     8.9    12.6  0.0126
    ## 2275     7.2     7.9  0.0079
    ## 2276     7.1     7.8  0.0078
    ## 2277    <NA>     8.8  0.0088
    ## 2278     7.2     8.9  0.0089
    ## 2279     7.8    10.5  0.0105
    ## 2280     6.6     7.0  0.0070
    ## 2281     7.4     8.0  0.0080
    ## 2282    <NA>     6.6  0.0066
    ## 2283       7     6.6  0.0066
    ## 2284     7.3     5.2  0.0052
    ## 2285     7.3     7.6  0.0076
    ## 2286       7     7.2  0.0072
    ## 2287     7.2     8.7  0.0087
    ## 2288     7.1     9.0  0.0090
    ## 2289     7.1     6.2  0.0062
    ## 2290    <NA>     7.8  0.0078
    ## 2291     7.3     8.4  0.0084
    ## 2292     6.9     7.4  0.0074
    ## 2293     7.1     5.9  0.0059
    ## 2294     7.1     8.0  0.0080
    ## 2295     7.5     7.7  0.0077
    ## 2296     7.1     9.0  0.0090
    ## 2297     7.4     6.4  0.0064
    ## 2298     7.1     9.2  0.0092
    ## 2299     7.2     6.6  0.0066
    ## 2300     7.2     8.0  0.0080
    ## 2301     7.2      NA      NA
    ## 2302     7.2     8.7  0.0087
    ## 2303     7.3     8.6  0.0086
    ## 2304       7     8.6  0.0086
    ## 2305     7.2     6.2  0.0062
    ## 2306     7.3     9.1  0.0091
    ## 2307     7.1     6.6  0.0066
    ## 2308     7.3     8.6  0.0086
    ## 2309     7.2     8.1  0.0081
    ## 2310     8.9    11.7  0.0117
    ## 2311     7.2     9.0  0.0090
    ## 2312     7.2     7.6  0.0076
    ## 2313     7.3     8.1  0.0081
    ## 2314     7.3     8.8  0.0088
    ## 2315     7.2     7.6  0.0076
    ## 2316     7.5     8.1  0.0081
    ## 2317     7.1     8.7  0.0087
    ## 2318    <NA>     7.1  0.0071
    ## 2319     6.8     3.3  0.0033
    ## 2320     7.2     8.9  0.0089
    ## 2321     7.5     9.4  0.0094
    ## 2322     7.2     7.7  0.0077
    ## 2323     7.6     7.1  0.0071
    ## 2324     7.4     5.2  0.0052
    ## 2325       7     8.3  0.0083
    ## 2326     7.2     8.7  0.0087
    ## 2327       7     8.5  0.0085
    ## 2328     7.2     7.3  0.0073
    ## 2329     7.1     8.8  0.0088
    ## 2330     6.9     6.7  0.0067
    ## 2331     6.8     5.3  0.0053
    ## 2332     7.5     6.0  0.0060
    ## 2333       7     5.9  0.0059
    ## 2334     7.2     7.9  0.0079
    ## 2335       7     6.8  0.0068
    ## 2336     7.3     9.2  0.0092
    ## 2337     7.1     7.8  0.0078
    ## 2338     7.1     7.6  0.0076
    ## 2339       7     7.2  0.0072
    ## 2340     7.4     7.4  0.0074
    ## 2341     7.3     5.3  0.0053
    ## 2342     7.5     5.9  0.0059
    ## 2343     7.1     8.6  0.0086
    ## 2344       7     7.4  0.0074
    ## 2345     6.3     5.5  0.0055
    ## 2346       7     7.7  0.0077
    ## 2347     7.2     7.5  0.0075
    ## 2348     7.3     8.0  0.0080
    ## 2349     7.1     7.7  0.0077
    ## 2350     7.1     8.3  0.0083
    ## 2351     7.2     8.8  0.0088
    ## 2352     7.4     9.6  0.0096
    ## 2353     7.2     9.1  0.0091
    ## 2354     7.2     7.6  0.0076
    ## 2355     7.5     6.4  0.0064
    ## 2356       7    10.1  0.0101
    ## 2357     7.4     5.9  0.0059
    ## 2358     6.9      NA      NA
    ## 2359     7.1     8.6  0.0086
    ## 2360       7     9.0  0.0090
    ## 2361     7.3     9.1  0.0091
    ## 2362     7.6     6.3  0.0063
    ## 2363     6.9     7.4  0.0074
    ## 2364     7.2     6.5  0.0065
    ## 2365     6.7     7.5  0.0075
    ## 2366     7.5     9.8  0.0098
    ## 2367     7.2     6.4  0.0064
    ## 2368       7     8.6  0.0086
    ## 2369     7.2     8.8  0.0088
    ## 2370     7.3     5.6  0.0056
    ## 2371     6.9     7.1  0.0071
    ## 2372     7.2     8.1  0.0081
    ## 2373     7.4     7.0  0.0070
    ## 2374     7.2     7.6  0.0076
    ## 2375     6.4     7.1  0.0071
    ## 2376     6.8     9.6  0.0096
    ## 2377     7.5     5.4  0.0054
    ## 2378     6.7     7.3  0.0073
    ## 2379     7.6     9.8  0.0098
    ## 2380    <NA>     5.2  0.0052
    ## 2381     7.1     7.6  0.0076
    ## 2382     7.2     9.2  0.0092
    ## 2383     7.3    10.8  0.0108
    ## 2384     7.1     8.6  0.0086
    ## 2385     6.8     4.4  0.0044
    ## 2386       7     7.5  0.0075
    ## 2387     7.4     9.6  0.0096
    ## 2388     7.3     6.2  0.0062
    ## 2389       7     6.3  0.0063
    ## 2390     7.5     5.8  0.0058
    ## 2391     7.2      NA      NA
    ## 2392     6.6     7.3  0.0073
    ## 2393     7.2     9.2  0.0092
    ## 2394       7     6.1  0.0061
    ## 2395     6.6     8.6  0.0086
    ## 2396     7.3     8.6  0.0086
    ## 2397     7.3     8.8  0.0088
    ## 2398     6.8     5.6  0.0056
    ## 2399     7.1     7.6  0.0076
    ## 2400     7.3     6.7  0.0067
    ## 2401     7.3     5.0  0.0050
    ## 2402     7.2     8.3  0.0083
    ## 2403     6.5     8.3  0.0083
    ## 2404     7.2     7.3  0.0073
    ## 2405     7.4     7.0  0.0070
    ## 2406     7.3     7.9  0.0079
    ## 2407     7.2     8.5  0.0085
    ## 2408     6.9     9.5  0.0095
    ## 2409     7.4     7.7  0.0077
    ## 2410     6.7     8.5  0.0085
    ## 2411       7     8.5  0.0085
    ## 2412     7.2     8.1  0.0081
    ## 2413     7.4     5.0  0.0050
    ## 2414     7.2     6.8  0.0068
    ## 2415     7.1     8.1  0.0081
    ## 2416     6.9     9.9  0.0099
    ## 2417     7.2     8.2  0.0082
    ## 2418             8.9  0.0089
    ## 2419     6.8    10.0  0.0100
    ## 2420     7.3     9.0  0.0090
    ## 2421     8.7    12.2  0.0122
    ## 2422     7.1     7.1  0.0071
    ## 2423     7.3     6.8  0.0068
    ## 2424     7.5    10.4  0.0104
    ## 2425     7.4     8.7  0.0087
    ## 2426     6.8    10.0  0.0100
    ## 2427     7.1     8.1  0.0081
    ## 2428     6.9     7.8  0.0078
    ## 2429     7.6     8.9  0.0089
    ## 2430     6.5     7.1  0.0071
    ## 2431     6.8     8.2  0.0082
    ## 2432       7     8.5  0.0085
    ## 2433     6.8     9.5  0.0095
    ## 2434     7.1     6.3  0.0063
    ## 2435    <NA>     5.6  0.0056
    ## 2436       7     8.2  0.0082
    ## 2437     7.3     8.9  0.0089
    ## 2438       7     9.9  0.0099
    ## 2439     7.1     8.2  0.0082
    ## 2440     7.2     6.7  0.0067
    ## 2441     7.4     9.6  0.0096
    ## 2442       7     6.7  0.0067
    ## 2443     6.8     9.5  0.0095
    ## 2444     7.1     5.4  0.0054
    ## 2445     7.3     8.9  0.0089
    ## 2446     7.1     6.8  0.0068
    ## 2447     7.2     7.1  0.0071
    ## 2448     6.8     9.2  0.0092
    ## 2449     7.4     6.4  0.0064
    ## 2450     8.9      NA      NA
    ## 2451     7.4     7.7  0.0077
    ## 2452     6.7     9.5  0.0095
    ## 2453     7.4     5.7  0.0057
    ## 2454     6.7    10.0  0.0100
    ## 2455     6.9     6.3  0.0063
    ## 2456     7.1     7.4  0.0074
    ## 2457     7.5     7.6  0.0076
    ## 2458     7.2     8.6  0.0086
    ## 2459     6.8     8.4  0.0084
    ## 2460       7     6.8  0.0068
    ## 2461     7.1     8.8  0.0088
    ## 2462     7.4     6.6  0.0066
    ## 2463     6.6     8.4  0.0084
    ## 2464     7.2     7.5  0.0075
    ## 2465     7.2     7.2  0.0072
    ## 2466     7.2     8.9  0.0089
    ## 2467     7.1     9.1  0.0091
    ## 2468     6.5     8.3  0.0083
    ## 2469     7.1     9.2  0.0092
    ## 2470     6.9     8.3  0.0083
    ## 2471       7     9.4  0.0094
    ## 2472     7.3     8.3  0.0083
    ## 2473       7     7.8  0.0078
    ## 2474     7.4     5.7  0.0057
    ## 2475     7.2     6.8  0.0068
    ## 2476     6.8     9.6  0.0096
    ## 2477     7.2     8.6  0.0086
    ## 2478     7.3    10.0  0.0100
    ## 2479       7     6.3  0.0063
    ## 2480     7.7     7.8  0.0078
    ## 2481     6.9     7.2  0.0072
    ## 2482    <NA>     5.6  0.0056
    ## 2483     6.8     6.4  0.0064
    ## 2484     6.9     7.4  0.0074
    ## 2485     7.4     6.2  0.0062
    ## 2486       7     6.7  0.0067
    ## 2487     7.2     7.9  0.0079
    ## 2488     7.2    10.0  0.0100
    ## 2489     7.1     8.3  0.0083
    ## 2490     7.4     5.4  0.0054
    ## 2491     7.3     8.8  0.0088
    ## 2492    <NA>     7.0  0.0070
    ## 2493     7.3     7.4  0.0074
    ## 2494     7.1     7.2  0.0072
    ## 2495       7     7.1  0.0071
    ## 2496    <NA>     8.2  0.0082
    ## 2497     7.3     7.8  0.0078
    ## 2498       7     6.4  0.0064
    ## 2499     7.3     8.5  0.0085
    ## 2500    None     7.0  0.0070
    ## 2501     7.1     8.0  0.0080
    ## 2502     7.2     8.8  0.0088
    ## 2503     7.2     8.8  0.0088
    ## 2504     7.2     8.7  0.0087
    ## 2505    <NA>     8.7  0.0087
    ## 2506     7.1     7.5  0.0075
    ## 2507     7.3     8.4  0.0084
    ## 2508       7     9.0  0.0090
    ## 2509     6.9     6.0  0.0060
    ## 2510     6.4     7.6  0.0076
    ## 2511     7.2     6.7  0.0067
    ## 2512       8    10.9  0.0109
    ## 2513     7.1      NA      NA
    ## 2514     7.5     6.9  0.0069
    ## 2515     7.4     5.7  0.0057
    ## 2516     7.3     8.6  0.0086
    ## 2517     7.1     7.7  0.0077
    ## 2518     7.2     7.8  0.0078
    ## 2519     7.3     9.0  0.0090
    ## 2520     7.2     8.9  0.0089
    ## 2521     6.9     6.7  0.0067
    ## 2522     7.4     6.9  0.0069
    ## 2523     6.9     6.3  0.0063
    ## 2524     7.2     8.3  0.0083
    ## 2525     7.5     5.3  0.0053
    ## 2526       7     8.2  0.0082
    ## 2527     7.5     8.7  0.0087
    ## 2528     6.9     7.4  0.0074
    ## 2529     7.3     8.1  0.0081
    ## 2530     6.8     8.5  0.0085
    ## 2531       7     7.4  0.0074
    ## 2532       7      NA      NA
    ## 2533     6.8     8.3  0.0083
    ## 2534       7     7.4  0.0074
    ## 2535     7.5     8.2  0.0082
    ## 2536     7.1     7.4  0.0074
    ## 2537     6.9     8.6  0.0086
    ## 2538     7.2     8.7  0.0087
    ## 2539       7     6.8  0.0068
    ## 2540     7.2     7.7  0.0077
    ## 2541     6.7     9.6  0.0096
    ## 2542       7     7.4  0.0074
    ## 2543       7     7.4  0.0074
    ## 2544     7.2     8.1  0.0081
    ## 2545     7.4     6.2  0.0062
    ## 2546     6.8    10.6  0.0106
    ## 2547     6.9     7.3  0.0073
    ## 2548     7.1     8.2  0.0082
    ## 2549     7.1     7.3  0.0073
    ## 2550     7.2     8.1  0.0081
    ## 2551     6.9    10.0  0.0100
    ## 2552     7.3     8.2  0.0082
    ## 2553       7     7.3  0.0073
    ## 2554     7.4    10.3  0.0103
    ## 2555     7.2     8.4  0.0084
    ## 2556     7.2     7.5  0.0075
    ## 2557     7.3     5.3  0.0053
    ## 2558       7     6.9  0.0069
    ## 2559    <NA>     7.7  0.0077
    ## 2560     7.2     6.3  0.0063
    ## 2561     7.3     8.8  0.0088
    ## 2562     6.7     7.4  0.0074
    ## 2563     6.8      NA      NA
    ## 2564     7.3     8.6  0.0086
    ## 2565       7     8.4  0.0084
    ## 2566     7.3     8.7  0.0087
    ## 2567       7     6.9  0.0069
    ## 2568     7.1     5.8  0.0058
    ## 2569     7.3     5.9  0.0059
    ## 2570    <NA>     8.2  0.0082
    ## 2571     7.2     9.2  0.0092
    ## 2572     7.1     7.5  0.0075
    ## 2573     7.2     7.3  0.0073
    ## 2574       7     7.3  0.0073
    ## 2575     7.4     7.5  0.0075
    ## 2576     7.8     9.3  0.0093
    ## 2577     6.9     6.6  0.0066
    ## 2578     7.4     5.0  0.0050
    ## 2579       7     9.8  0.0098
    ## 2580       7     7.9  0.0079
    ## 2581       7    10.2  0.0102
    ## 2582     6.9     9.9  0.0099
    ## 2583     7.3     6.9  0.0069
    ## 2584     7.2     9.4  0.0094
    ## 2585     7.3     8.3  0.0083
    ## 2586     7.5     8.1  0.0081
    ## 2587     7.1     7.2  0.0072
    ## 2588     7.3     9.0  0.0090
    ## 2589     7.2     7.3  0.0073
    ## 2590     7.2     8.5  0.0085
    ## 2591     7.1      NA      NA
    ## 2592     7.1     7.4  0.0074
    ## 2593     6.3     7.5  0.0075
    ## 2594     7.6     6.6  0.0066
    ## 2595       7     8.7  0.0087
    ## 2596     7.1     8.1  0.0081
    ## 2597       7     6.9  0.0069
    ## 2598     7.2     6.6  0.0066
    ## 2599     6.8     7.6  0.0076
    ## 2600     7.2     9.4  0.0094
    ## 2601       7     6.9  0.0069
    ## 2602     7.1     7.8  0.0078
    ## 2603    <NA>     7.2  0.0072
    ## 2604     7.1     9.3  0.0093
    ## 2605     7.1     7.0  0.0070
    ## 2606     7.2     3.7  0.0037
    ## 2607     7.3     9.4  0.0094
    ## 2608     7.3     6.1  0.0061
    ## 2609     7.5     6.1  0.0061
    ## 2610     7.1     6.2  0.0062
    ## 2611     7.1     7.6  0.0076
    ## 2612     7.1     6.8  0.0068
    ## 2613     6.9     7.0  0.0070
    ## 2614     7.3     5.4  0.0054
    ## 2615     6.6     6.8  0.0068
    ## 2616     7.2     9.1  0.0091
    ## 2617     7.1     7.7  0.0077
    ## 2618     6.9     6.5  0.0065
    ## 2619     7.1     8.8  0.0088
    ## 2620     7.2     8.0  0.0080
    ## 2621     7.2     8.4  0.0084
    ## 2622     7.2     8.2  0.0082
    ## 2623     7.1     7.3  0.0073
    ## 2624     7.5     5.3  0.0053
    ## 2625     6.9     8.6  0.0086
    ## 2626     7.1     7.2  0.0072
    ## 2627     7.2     8.0  0.0080
    ## 2628     7.2     8.2  0.0082
    ## 2629     6.8    10.0  0.0100
    ## 2630     7.1     7.0  0.0070
    ## 2631       7     8.0  0.0080
    ## 2632       7     7.1  0.0071
    ## 2633     7.3     7.8  0.0078
    ## 2634     7.7     6.5  0.0065
    ## 2635     7.2     7.2  0.0072
    ## 2636     6.9     8.3  0.0083
    ## 2637     7.2     7.8  0.0078
    ## 2638       9    10.8  0.0108
    ## 2639       7     8.0  0.0080
    ## 2640     8.3    10.3  0.0103
    ## 2641     7.1     7.5  0.0075
    ## 2642     6.8     9.7  0.0097
    ## 2643       7     7.7  0.0077
    ## 2644     7.2     8.5  0.0085
    ## 2645       7     8.8  0.0088
    ## 2646     7.2     8.9  0.0089
    ## 2647     7.3     9.4  0.0094
    ## 2648     7.6     8.3  0.0083
    ## 2649     7.5     5.2  0.0052
    ## 2650     7.2     6.6  0.0066
    ## 2651       7     7.6  0.0076
    ## 2652     7.2     8.7  0.0087
    ## 2653     7.3     7.6  0.0076
    ## 2654       7     6.3  0.0063
    ## 2655     7.4     6.1  0.0061
    ## 2656     6.8    10.0  0.0100
    ## 2657     7.4     7.4  0.0074
    ## 2658     7.5     6.3  0.0063
    ## 2659     6.8     7.6  0.0076
    ## 2660     6.9     7.1  0.0071
    ## 2661     6.8     5.3  0.0053
    ## 2662     7.2     9.1  0.0091
    ## 2663     7.2     8.5  0.0085
    ## 2664       7      NA      NA
    ## 2665     7.1     6.8  0.0068
    ## 2666     8.3    10.1  0.0101
    ## 2667     7.1     5.3  0.0053
    ## 2668       7     7.4  0.0074
    ## 2669     7.2     6.7  0.0067
    ## 2670       7     7.4  0.0074
    ## 2671     7.1     7.9  0.0079
    ## 2672       7     7.3  0.0073
    ## 2673     7.2     8.4  0.0084
    ## 2674     7.1     8.4  0.0084
    ## 2675       7     9.4  0.0094
    ## 2676     7.3     7.8  0.0078
    ## 2677    <NA>     9.0  0.0090
    ## 2678     7.4     6.3  0.0063
    ## 2679     7.3     6.2  0.0062
    ## 2680       7     6.9  0.0069
    ## 2681     7.6     6.2  0.0062
    ## 2682       7     6.4  0.0064
    ## 2683     7.9     6.7  0.0067
    ## 2684     7.8    10.8  0.0108
    ## 2685     7.5     7.9  0.0079
    ## 2686     7.2     7.4  0.0074
    ## 2687     7.1     7.6  0.0076
    ## 2688     8.3     9.3  0.0093
    ## 2689     7.4     8.9  0.0089
    ## 2690     7.5     7.9  0.0079
    ## 2691     7.3     5.6  0.0056
    ## 2692     7.6     8.9  0.0089
    ## 2693     7.1     9.1  0.0091
    ## 2694     7.1     7.5  0.0075
    ## 2695     7.2     9.4  0.0094
    ## 2696     6.8     9.8  0.0098
    ## 2697     7.3     8.1  0.0081
    ## 2698     7.5     6.2  0.0062
    ## 2699            10.7  0.0107
    ## 2700     7.5     7.9  0.0079
    ## 2701     7.6     5.4  0.0054
    ## 2702     7.6     7.8  0.0078
    ## 2703     7.1     7.8  0.0078
    ## 2704       7     8.5  0.0085
    ## 2705     7.3     6.2  0.0062
    ## 2706     7.4     6.5  0.0065
    ## 2707     6.5     7.2  0.0072
    ## 2708     7.1     8.9  0.0089
    ## 2709     7.1     8.5  0.0085
    ## 2710     7.3     8.2  0.0082
    ## 2711     7.3     8.5  0.0085
    ## 2712     6.7     6.9  0.0069
    ## 2713     7.1     6.8  0.0068
    ## 2714     7.2     8.3  0.0083
    ## 2715     7.1     9.1  0.0091
    ## 2716     7.4     6.6  0.0066
    ## 2717     7.2     7.0  0.0070
    ## 2718     6.9     7.4  0.0074
    ## 2719     7.1     7.7  0.0077
    ## 2720    <NA>     8.2  0.0082
    ## 2721     6.9     6.3  0.0063
    ## 2722     6.9     6.7  0.0067
    ## 2723     6.6     7.2  0.0072
    ## 2724     7.2     8.7  0.0087
    ## 2725     7.1     8.2  0.0082
    ## 2726     6.7     7.5  0.0075
    ## 2727     7.1     7.4  0.0074
    ## 2728     7.1     6.5  0.0065
    ## 2729     7.3     9.1  0.0091
    ## 2730     7.5     5.6  0.0056
    ## 2731     6.8     4.4  0.0044
    ## 2732       7     7.5  0.0075
    ## 2733     6.5     6.5  0.0065
    ## 2734     7.2     8.3  0.0083
    ## 2735     7.1     7.2  0.0072
    ## 2736     7.5     8.6  0.0086
    ## 2737     7.4     5.7  0.0057
    ## 2738     7.2     8.2  0.0082
    ## 2739     7.3     8.7  0.0087
    ## 2740     7.2     8.0  0.0080
    ## 2741     7.1     9.4  0.0094
    ## 2742     6.8    10.5  0.0105
    ## 2743     7.2     7.2  0.0072
    ## 2744     7.3     8.0  0.0080
    ## 2745     7.2     9.1  0.0091
    ## 2746       7     9.6  0.0096
    ## 2747     6.2      NA      NA
    ## 2748     7.7     6.4  0.0064
    ## 2749     6.8    10.0  0.0100
    ## 2750     7.4     9.8  0.0098
    ## 2751     7.3     8.0  0.0080
    ## 2752     6.9     8.1  0.0081
    ## 2753       7     7.6  0.0076
    ## 2754     8.2    10.8  0.0108
    ## 2755     6.8     7.9  0.0079
    ## 2756     6.3     7.5  0.0075
    ## 2757     7.1     7.8  0.0078
    ## 2758     6.8     9.4  0.0094
    ## 2759    None     9.8  0.0098
    ## 2760     7.3     6.4  0.0064
    ## 2761     7.2     8.5  0.0085
    ## 2762     6.8    10.3  0.0103
    ## 2763       7     7.4  0.0074
    ## 2764       7     6.7  0.0067
    ## 2765     6.8    10.0  0.0100
    ## 2766     6.5     6.6  0.0066
    ## 2767     7.4     9.7  0.0097
    ## 2768     7.4     8.9  0.0089
    ## 2769     7.5     8.2  0.0082
    ## 2770     6.8     7.3  0.0073
    ## 2771     7.2     8.4  0.0084
    ## 2772     7.6     7.6  0.0076
    ## 2773     7.1     8.4  0.0084
    ## 2774     7.4     6.9  0.0069
    ## 2775     7.4     8.9  0.0089
    ## 2776     7.1     9.4  0.0094
    ## 2777     6.6     6.8  0.0068
    ## 2778     7.1     6.4  0.0064
    ## 2779     6.9     6.6  0.0066
    ## 2780       7     8.3  0.0083
    ## 2781    <NA>     5.4  0.0054
    ## 2782     7.3     5.7  0.0057
    ## 2783     7.2     9.0  0.0090
    ## 2784     6.9     8.0  0.0080
    ## 2785     7.3     8.6  0.0086
    ## 2786     7.4     7.8  0.0078
    ## 2787     6.8     9.4  0.0094
    ## 2788     7.2     6.9  0.0069
    ## 2789     7.1     7.2  0.0072
    ## 2790     7.4     5.8  0.0058
    ## 2791     7.3     7.6  0.0076
    ## 2792     7.2     7.3  0.0073
    ## 2793     7.2     7.9  0.0079
    ## 2794     6.8     7.0  0.0070
    ## 2795     7.1     6.3  0.0063
    ## 2796       7     6.4  0.0064
    ## 2797     7.4     6.5  0.0065
    ## 2798    None     5.5  0.0055
    ## 2799     7.2     7.9  0.0079
    ## 2800     7.2     6.8  0.0068
    ## 2801     7.4     6.7  0.0067
    ## 2802     7.2     6.8  0.0068
    ## 2803     7.3     6.3  0.0063
    ## 2804     6.8     7.6  0.0076
    ## 2805     7.3     5.5  0.0055
    ## 2806     6.6     7.9  0.0079
    ## 2807     7.4     7.4  0.0074
    ## 2808     7.2     8.2  0.0082
    ## 2809     7.1     7.7  0.0077
    ## 2810     7.1     8.5  0.0085
    ## 2811       7     7.7  0.0077
    ## 2812     6.9     6.5  0.0065
    ## 2813       7     8.9  0.0089
    ## 2814     7.3     9.1  0.0091
    ## 2815     7.2     8.5  0.0085
    ## 2816     7.1     7.6  0.0076
    ## 2817    <NA>     8.4  0.0084
    ## 2818    <NA>     7.3  0.0073
    ## 2819       7     6.2  0.0062
    ## 2820     7.3     8.2  0.0082
    ## 2821     7.1     6.3  0.0063
    ## 2822     7.1     6.4  0.0064
    ## 2823     6.5     7.2  0.0072
    ## 2824     6.9     6.4  0.0064
    ## 2825     6.9     5.4  0.0054
    ## 2826     7.2     8.2  0.0082
    ## 2827     7.4     7.8  0.0078
    ## 2828     7.3     8.3  0.0083
    ## 2829       7     7.9  0.0079
    ## 2830     6.8     4.4  0.0044
    ## 2831       7     8.6  0.0086
    ## 2832     6.9     5.3  0.0053
    ## 2833     7.2     8.2  0.0082
    ## 2834     7.7     6.6  0.0066
    ## 2835     7.1     8.8  0.0088
    ## 2836     7.2     5.3  0.0053
    ## 2837    <NA>     9.5  0.0095
    ## 2838     7.1     6.9  0.0069
    ## 2839     7.1     7.4  0.0074
    ## 2840     7.2     8.4  0.0084
    ## 2841       7     6.5  0.0065
    ## 2842     6.8     9.8  0.0098
    ## 2843     7.2     8.7  0.0087
    ## 2844     6.7     6.0  0.0060
    ## 2845     6.7     7.9  0.0079
    ## 2846     7.2     7.6  0.0076
    ## 2847     7.4      NA      NA
    ## 2848       7     8.2  0.0082
    ## 2849     6.8      NA      NA
    ## 2850     7.3     9.6  0.0096
    ## 2851     7.2     8.9  0.0089
    ## 2852       7     7.5  0.0075
    ## 2853     6.9     5.8  0.0058
    ## 2854     7.3    10.3  0.0103
    ## 2855     7.4     8.2  0.0082
    ## 2856     7.4     9.2  0.0092
    ## 2857     7.5     5.2  0.0052
    ## 2858     6.9     8.0  0.0080
    ## 2859     7.6     9.4  0.0094
    ## 2860     7.1     7.2  0.0072
    ## 2861     8.1    11.5  0.0115
    ## 2862       7     7.8  0.0078
    ## 2863     7.2     8.3  0.0083
    ## 2864     7.3     8.8  0.0088
    ## 2865       7     6.9  0.0069
    ## 2866     7.1     7.3  0.0073
    ## 2867     8.4     9.1  0.0091
    ## 2868    <NA>     7.3  0.0073
    ## 2869     7.4     6.0  0.0060
    ## 2870     6.9     8.5  0.0085
    ## 2871     7.4     8.0  0.0080
    ## 2872     7.5     8.4  0.0084
    ## 2873       7     7.0  0.0070
    ## 2874     6.8     7.1  0.0071
    ## 2875       7     8.7  0.0087
    ## 2876     7.2     7.6  0.0076
    ## 2877     7.1     6.0  0.0060
    ## 2878     7.1     6.2  0.0062
    ## 2879     7.3     8.4  0.0084
    ## 2880     7.1     7.7  0.0077
    ## 2881       7     9.5  0.0095
    ## 2882       7     8.5  0.0085
    ## 2883    <NA>     9.7  0.0097
    ## 2884     7.4     6.3  0.0063
    ## 2885     8.9    11.2  0.0112
    ## 2886     7.1     7.7  0.0077
    ## 2887     7.6     8.1  0.0081
    ## 2888     7.2     6.9  0.0069
    ## 2889     7.1     7.5  0.0075
    ## 2890       7     8.8  0.0088
    ## 2891     7.1     5.6  0.0056
    ## 2892     7.1     8.4  0.0084
    ## 2893     7.4     6.3  0.0063
    ## 2894     7.2     6.7  0.0067
    ## 2895     6.5     6.5  0.0065
    ## 2896     7.1     6.3  0.0063
    ## 2897     7.1     5.3  0.0053
    ## 2898     7.3     8.5  0.0085
    ## 2899     7.2     8.9  0.0089
    ## 2900     7.2     8.2  0.0082
    ## 2901     7.6     7.7  0.0077
    ## 2902     7.3     8.8  0.0088
    ## 2903     7.2     7.4  0.0074
    ## 2904     7.1     7.2  0.0072
    ## 2905     7.4     5.7  0.0057
    ## 2906     7.2     8.9  0.0089
    ## 2907     7.3     7.4  0.0074
    ## 2908     7.1     7.2  0.0072
    ## 2909     7.1     6.9  0.0069
    ## 2910     7.2     8.0  0.0080
    ## 2911     7.4     8.4  0.0084
    ## 2912     7.2     5.8  0.0058
    ## 2913     7.2     7.6  0.0076
    ## 2914     6.9     7.5  0.0075
    ## 2915     7.3     9.3  0.0093
    ## 2916     6.9     6.5  0.0065
    ## 2917     6.5     6.3  0.0063
    ## 2918     7.1     6.3  0.0063
    ## 2919       7     8.0  0.0080
    ## 2920     7.2     8.3  0.0083
    ## 2921     7.4     6.4  0.0064
    ## 2922     7.2     7.6  0.0076
    ## 2923     7.1     7.4  0.0074
    ## 2924       8    11.8  0.0118
    ## 2925     7.4     6.8  0.0068
    ## 2926     7.2     8.6  0.0086
    ## 2927     7.3     6.8  0.0068
    ## 2928     7.1     7.3  0.0073
    ## 2929     7.5     6.2  0.0062
    ## 2930    <NA>     6.0  0.0060
    ## 2931       7     9.4  0.0094
    ## 2932     7.2    10.0  0.0100
    ## 2933     7.3      NA      NA
    ## 2934     7.3     6.1  0.0061
    ## 2935     7.5     7.3  0.0073
    ## 2936     7.4     8.0  0.0080
    ## 2937    <NA>    10.0  0.0100
    ## 2938     6.8     7.8  0.0078
    ## 2939     7.3     7.9  0.0079
    ## 2940     7.4     5.3  0.0053
    ## 2941     8.8    12.4  0.0124
    ## 2942     7.3     8.7  0.0087
    ## 2943     7.2     8.1  0.0081
    ## 2944     7.2     7.6  0.0076
    ## 2945     7.5      NA      NA
    ## 2946     6.4     7.4  0.0074
    ## 2947     6.9     9.7  0.0097
    ## 2948     7.6     6.2  0.0062
    ## 2949     7.5     9.8  0.0098
    ## 2950     7.1     7.4  0.0074
    ## 2951     7.3     8.3  0.0083
    ## 2952     7.1     8.0  0.0080
    ## 2953       7     7.9  0.0079
    ## 2954       7     8.6  0.0086
    ## 2955     6.9     7.2  0.0072
    ## 2956       7     6.9  0.0069
    ## 2957     7.2     8.5  0.0085
    ## 2958     7.1     7.6  0.0076
    ## 2959     7.1     8.6  0.0086
    ## 2960     7.4     6.7  0.0067
    ## 2961     7.3     8.1  0.0081
    ## 2962     6.7     9.4  0.0094
    ## 2963       7     8.4  0.0084
    ## 2964     7.1     8.9  0.0089
    ## 2965     7.4     5.4  0.0054
    ## 2966     6.8     8.3  0.0083
    ## 2967     7.1     6.2  0.0062
    ## 2968     7.1     7.3  0.0073
    ## 2969     7.1     7.3  0.0073
    ## 2970     7.2     8.1  0.0081
    ## 2971     7.2     6.5  0.0065
    ## 2972     6.4     7.6  0.0076
    ## 2973     7.2     8.0  0.0080
    ## 2974     7.2     7.8  0.0078
    ## 2975     7.1      NA      NA
    ## 2976     7.2     8.7  0.0087
    ## 2977     7.5     7.9  0.0079
    ## 2978     7.4     6.8  0.0068
    ## 2979     6.8    10.6  0.0106
    ## 2980     7.2     8.0  0.0080
    ## 2981     6.9     9.6  0.0096
    ## 2982     7.1     7.0  0.0070
    ## 2983     7.4    10.5  0.0105
    ## 2984       7     6.9  0.0069
    ## 2985     7.2     8.4  0.0084
    ## 2986     7.2     7.9  0.0079
    ## 2987     7.3      NA      NA
    ## 2988     7.2     8.8  0.0088
    ## 2989     7.2     8.0  0.0080
    ## 2990       7     6.5  0.0065
    ## 2991       7     8.7  0.0087
    ## 2992     6.7     7.8  0.0078
    ## 2993     7.3     7.0  0.0070
    ## 2994     7.1     6.3  0.0063
    ## 2995     7.2     7.8  0.0078
    ## 2996     7.2     8.4  0.0084
    ## 2997     6.8     7.5  0.0075
    ## 2998     7.2     8.0  0.0080
    ## 2999     7.5     9.9  0.0099
    ## 3000     7.1     8.4  0.0084

``` r
# if there are more than 1000 observations, we want to filter out high temperature observations
if(nrow(intro_df) > 1000){
  filter(intro_df, Wtemp_Inst >= 15)
}
```

    ##        site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst
    ## 1     02336360 2011-05-03 21:45:00     14.00            X       21.4
    ## 2     02336300 2011-05-01 08:00:00     32.00            X       19.1
    ## 3     02337170 2011-05-29 22:45:00   1470.00            A       24.0
    ## 4     02203655 2011-05-25 01:30:00      7.50          A e       23.1
    ## 5     02336120 2011-05-02 07:30:00     16.00            A       19.7
    ## 6     02336120 2011-05-12 16:15:00     14.00          A e       22.3
    ## 7     02336120 2011-05-12 18:00:00     14.00            A       23.4
    ## 8     02336300 2011-05-03 00:15:00     32.00            X       22.3
    ## 9     02336360 2011-05-27 08:15:00    162.00          A e       21.0
    ## 10    02336120 2011-05-27 17:30:00    162.00            E       21.2
    ## 11    02336728 2011-05-15 00:15:00     12.00            A       22.1
    ## 12    02336360 2011-05-08 12:30:00     13.00            E       16.6
    ## 13    02203655 2011-05-05 05:00:00     18.00            E       16.9
    ## 14    02336120 2011-05-27 14:45:00    338.00            A       20.4
    ## 15    02336526 2011-05-03 14:00:00      4.00            A       19.7
    ## 16    02336728 2011-05-22 03:30:00      9.70            X       21.2
    ## 17    02336728 2011-05-16 19:15:00     12.00            A       17.9
    ## 18    02337170 2011-05-17 00:45:00   1840.00            A       16.5
    ## 19    02203700 2011-05-07 15:15:00      5.30          A e       16.8
    ## 20    02336360 2011-06-01 00:15:00      7.20            X       26.5
    ## 21    02336410 2011-05-01 10:45:00     22.00            E       18.4
    ## 22    02336240 2011-05-30 21:00:00     11.00            A       26.1
    ## 23   021989773 2011-05-29 04:30:00  23000.00            A       26.4
    ## 24    02336526 2011-05-23 14:15:00      3.60          A e       21.2
    ## 25    02336313 2011-05-24 19:45:00      0.93            A       25.1
    ## 26   021989773 2011-05-29 05:00:00  19200.00          A e       26.4
    ## 27    02336410 2011-05-14 02:30:00     16.00            X       22.6
    ## 28   021989773 2011-05-22 15:00:00 -68600.00            A       24.0
    ## 29    02336360 2011-05-08 16:15:00     13.00            A       18.0
    ## 30    02203655 2011-05-26 15:00:00      6.80          A e       22.1
    ## 31    02336526 2011-05-27 17:45:00     31.00            A       21.4
    ## 32    02336300 2011-05-16 08:45:00     25.00            A       17.1
    ## 33    02336313 2011-05-30 01:15:00      0.73          A e       25.5
    ## 34    02203655 2011-05-30 17:45:00     10.00            X       23.1
    ## 35    02337170 2011-05-10 08:15:00   1350.00            X       21.0
    ## 36    02203700 2011-05-23 08:15:00      3.70            X       21.1
    ## 37    02336728 2011-05-29 14:45:00     20.00            A       22.0
    ## 38    02336728 2011-05-19 18:00:00     11.00            A       18.4
    ## 39   021989773 2011-05-25 23:30:00  51200.00            A       26.3
    ## 40    02336360 2011-05-16 06:15:00     11.00            E       17.6
    ## 41    02336360 2011-05-22 06:15:00      9.80            X       21.4
    ## 42    02336728 2011-05-25 15:15:00      8.20          A e       21.9
    ## 43    02336240 2011-05-29 12:45:00     14.00            A       21.0
    ## 44    02203700 2011-05-07 06:30:00      5.30            X       16.4
    ## 45    02203655 2011-06-01 02:00:00      8.80            A       25.0
    ## 46    02203700 2011-05-04 01:15:00     48.00            A       19.9
    ## 47    02336360 2011-05-09 21:15:00     12.00            E       22.7
    ## 48    02336240 2011-05-12 22:15:00     11.00          A e       24.9
    ## 49    02336240 2011-05-09 22:15:00     12.00            A       22.5
    ## 50    02337170 2011-05-20 22:30:00   4510.00            A       16.9
    ## 51    02336410 2011-05-12 20:30:00     16.00            A       25.3
    ## 52    02336240 2011-05-04 04:15:00    449.00            A       17.8
    ## 53    02336120 2011-05-18 18:45:00     13.00          A e       16.5
    ## 54    02203700 2011-05-24 06:45:00      3.70            A       22.0
    ## 55    02203700 2011-05-04 21:15:00     24.00            A       20.0
    ## 56    02336300 2011-05-23 09:15:00     22.00            A       22.2
    ## 57    02336728 2011-05-04 11:00:00    117.00            A       16.8
    ## 58    02336240 2011-05-30 04:45:00     12.00            A       23.1
    ## 59    02336120 2011-05-09 07:45:00     16.00            E       18.8
    ## 60    02203655 2011-06-01 01:15:00      8.80          A e       24.9
    ## 61    02336240 2011-05-22 15:00:00      8.90          A e       20.7
    ## 62    02336120 2011-05-08 02:00:00     17.00            X       18.9
    ## 63    02336120 2011-05-21 11:00:00     12.00            A       18.8
    ## 64    02336120 2011-05-03 12:00:00     16.00          A e       19.7
    ## 65    02336240 2011-05-08 14:00:00     12.00            E       16.7
    ## 66    02336410 2011-05-08 11:30:00     22.00            X       17.1
    ## 67    02336313 2011-05-08 21:00:00      1.00            X       21.8
    ## 68    02336728 2011-05-30 03:30:00     17.00            A       22.9
    ## 69    02336526 2011-05-21 00:30:00      3.60            E       22.5
    ## 70    02336300 2011-05-03 23:45:00    108.00            A       19.1
    ## 71    02336410 2011-05-27 16:15:00    139.00            X       21.2
    ## 72    02336526 2011-05-31 15:45:00      4.60            X       23.4
    ## 73    02336300 2011-05-01 13:00:00     31.00            X       18.2
    ## 74    02336120 2011-05-27 06:30:00    374.00          A e       21.8
    ## 75   021989773 2011-05-24 12:30:00  46200.00            A       24.8
    ## 76    02336410 2011-05-23 15:30:00     13.00            A       22.0
    ## 77    02336120 2011-05-12 10:00:00     14.00            X       21.6
    ## 78    02337170 2011-05-27 21:00:00        NA            X       20.6
    ## 79    02336728 2011-05-31 10:30:00     13.00            A       22.7
    ## 80    02336240 2011-05-22 06:45:00      8.50            A       20.4
    ## 81    02336240 2011-05-20 21:45:00      9.50            A       21.7
    ## 82    02337170 2011-05-21 04:15:00   4220.00            A       15.5
    ## 83    02337170 2011-05-11 17:15:00   2460.00            A       18.1
    ## 84    02203655 2011-05-23 09:00:00      7.50          A e       21.7
    ## 85    02336360 2011-05-13 04:15:00     11.00            A       23.0
    ## 86   021989773 2011-05-24 05:45:00 -39900.00            A       24.9
    ## 87   021989773 2011-05-14 23:15:00 -48300.00            A       24.5
    ## 88    02336240 2011-05-30 17:00:00     12.00            A       24.6
    ## 89    02336360 2011-05-30 08:30:00      6.90            E       23.6
    ## 90    02336313 2011-05-08 23:00:00      0.98            E       21.8
    ## 91    02203655 2011-05-02 17:45:00     12.00            E       20.1
    ## 92    02203700 2011-05-26 17:15:00      3.70          A e       23.9
    ## 93    02336360 2011-05-28 09:00:00     14.00            A       21.6
    ## 94    02336526 2011-05-13 01:00:00      3.60            E       25.5
    ## 95    02336120 2011-05-18 21:15:00     15.00          A e       17.8
    ## 96    02336120 2011-05-29 05:00:00     20.00            X       22.9
    ## 97    02336526 2011-05-06 05:45:00      5.20            A       16.2
    ## 98   021989773 2011-05-22 17:30:00 -23200.00          A e       24.2
    ## 99    02203700 2011-05-11 15:00:00      4.90            A       21.7
    ## 100   02203700 2011-05-02 00:30:00        NA            E       22.3
    ## 101   02337170 2011-05-30 15:15:00   1330.00            A       22.7
    ## 102   02336313 2011-05-17 19:15:00      1.00          A e       16.6
    ## 103   02336526 2011-05-27 10:00:00    472.00            A       19.6
    ## 104   02203700 2011-05-03 06:30:00      6.10          A e       19.8
    ## 105   02336360 2011-05-24 21:15:00      9.10          A e       25.8
    ## 106   02337170 2011-05-25 07:45:00   2110.00            A       20.7
    ## 107   02203655 2011-05-18 01:15:00      9.20            A       15.9
    ## 108   02337170 2011-05-25 17:45:00   1560.00          A e       20.3
    ## 109   02337170 2011-05-27 12:15:00   5300.00            A       20.7
    ## 110   02336120 2011-05-09 05:15:00     16.00            A       19.2
    ## 111   02336410 2011-05-03 11:45:00     20.00            E       20.2
    ## 112   02336360 2011-05-15 06:30:00     11.00            A       20.4
    ## 113   02336360 2011-05-13 00:45:00     11.00            A       24.2
    ## 114   02336313 2011-05-10 12:30:00      1.10            A       19.3
    ## 115   02336526 2011-05-04 03:00:00    377.00            A       17.8
    ## 116  021989773 2011-05-14 22:00:00 -62300.00            A       24.4
    ## 117   02336313 2011-05-30 18:15:00      0.73            E       25.7
    ## 118   02336360 2011-05-20 05:45:00     10.00            A       17.9
    ## 119   02336728 2011-05-04 09:30:00    162.00            E       17.2
    ## 120  021989773 2011-05-08 18:30:00  64900.00            X       23.1
    ## 121   02336120 2011-05-22 22:45:00     11.00            A       25.1
    ## 122   02337170 2011-05-14 16:15:00   3900.00            A       15.2
    ## 123   02336313 2011-05-16 10:00:00      1.00            A       16.5
    ## 124   02336526 2011-05-04 00:45:00    192.00            A       19.2
    ## 125   02336120 2011-05-16 10:30:00     13.00            X       16.9
    ## 126   02336728 2011-05-03 00:45:00     15.00          A e       21.3
    ## 127   02336300 2011-05-19 18:00:00     25.00            X       18.9
    ## 128   02203655 2011-05-03 06:00:00     11.00            A       20.9
    ## 129   02337170 2011-05-08 17:15:00   1440.00            A       16.5
    ## 130   02336728 2011-05-30 15:15:00     15.00            E       23.8
    ## 131   02336526 2011-05-22 23:15:00      3.50            A       25.4
    ## 132   02336360 2011-05-28 00:30:00     19.00            A       23.6
    ## 133  021989773 2011-05-12 09:30:00  11400.00          A e       23.6
    ## 134   02336120 2011-05-01 07:15:00     17.00          A e       18.8
    ## 135   02203655 2011-05-07 09:45:00     12.00          A e       15.9
    ## 136   02336410 2011-05-11 18:45:00     17.00            A       24.6
    ## 137   02336240 2011-05-15 09:15:00     10.00            X       18.9
    ## 138   02336313 2011-05-10 03:15:00      1.20          A e       22.1
    ## 139   02203655 2011-05-25 15:45:00      7.50          A e       21.5
    ## 140   02336728 2011-05-20 13:30:00     10.00          A e       16.8
    ## 141   02336360 2011-05-17 19:00:00     10.00          A e       16.5
    ## 142   02336300 2011-05-02 19:45:00     31.00            E       22.8
    ## 143   02336300 2011-05-12 11:30:00     28.00          A e       21.7
    ## 144  021989773 2011-05-25 20:15:00 -30100.00            E       25.8
    ## 145   02336360 2011-05-10 15:45:00     12.00            E       20.8
    ## 146   02336410 2011-05-25 17:00:00     11.00          A e       23.4
    ## 147   02336120 2011-05-21 21:00:00     12.00            A       23.3
    ## 148   02203655 2011-05-07 12:00:00     12.00          A e       15.2
    ## 149  021989773 2011-05-06 15:45:00   2990.00          A e       23.2
    ## 150   02203655 2011-05-06 04:30:00     13.00            A       17.1
    ## 151   02203655 2011-05-21 04:15:00      8.20            A       20.5
    ## 152   02336410 2011-05-20 17:00:00     14.00            A       19.1
    ## 153  021989773 2011-05-25 12:00:00  61400.00            X       25.1
    ## 154   02336526 2011-05-10 01:45:00      4.00          A e       23.7
    ## 155  021989773 2011-05-05 06:15:00  85800.00            X       23.3
    ## 156   02336728 2011-05-24 21:15:00      8.90            E       25.7
    ## 157   02336300 2011-05-14 05:15:00     27.00            E       22.2
    ## 158   02336728 2011-05-20 22:30:00     10.00            E       22.7
    ## 159   02337170 2011-05-10 14:00:00   2550.00            X       20.3
    ## 160   02336526 2011-05-28 16:00:00      9.10          A e       21.1
    ## 161   02337170 2011-05-24 04:00:00   1920.00            E       20.5
    ## 162   02203655 2011-05-05 10:00:00     15.00            A       15.0
    ## 163   02337170 2011-05-29 00:45:00   2570.00            A       21.6
    ## 164   02336526 2011-05-26 14:45:00      2.80            A       22.5
    ## 165   02336728 2011-05-29 12:45:00     20.00            A       21.6
    ## 166   02203655 2011-05-03 22:45:00     59.00            E       20.2
    ## 167   02336313 2011-05-14 12:00:00      1.00            A       20.2
    ## 168  021989773 2011-05-09 02:30:00 -70200.00          A e       22.7
    ## 169   02337170 2011-06-01 02:45:00   1260.00            X       26.2
    ## 170   02203700 2011-05-13 02:30:00      4.60            A       23.8
    ## 171   02203655 2011-05-25 10:30:00      7.20            A       21.4
    ## 172   02336526 2011-05-26 19:30:00      2.80            A       24.6
    ## 173   02203655 2011-05-19 21:15:00      8.80            A       17.6
    ## 174   02336360 2011-05-08 20:00:00     13.00            A       19.9
    ## 175  021989773 2011-05-29 20:30:00 -87100.00            A       26.9
    ## 176   02336410 2011-05-26 14:15:00     11.00            A       22.6
    ## 177   02336300 2011-05-25 01:00:00     20.00            A       25.4
    ## 178  021989773 2011-05-31 21:15:00        NA            E       28.0
    ## 179   02203655 2011-05-31 15:15:00      9.60            A       22.6
    ## 180   02336360 2011-05-24 04:45:00      9.10          A e       22.9
    ## 181   02203655 2011-05-18 01:30:00      9.20            E       15.9
    ## 182   02336240 2011-05-31 02:15:00     11.00            A       24.6
    ## 183   02336313 2011-05-31 01:15:00      0.69            A       25.7
    ## 184   02336360 2011-05-10 21:00:00     12.00            X       24.6
    ## 185   02337170 2011-05-29 07:00:00   2070.00            A       21.5
    ## 186   02336360 2011-05-07 19:45:00     13.00          A e       19.7
    ## 187   02336410 2011-05-06 02:30:00     27.00          A e       17.2
    ## 188   02336300 2011-05-23 09:00:00     22.00            A       22.3
    ## 189   02203700 2011-05-04 17:45:00     26.00            A       20.2
    ## 190   02336313 2011-05-18 00:45:00      1.00          A e       16.4
    ## 191   02336728 2011-05-21 00:15:00     10.00            A       21.8
    ## 192   02336120 2011-05-26 12:30:00      8.90            X       22.4
    ## 193   02336120 2011-05-05 00:30:00     36.00          A e       17.9
    ## 194   02203655 2011-05-31 15:00:00      9.60          A e       22.6
    ## 195   02203700 2011-05-12 09:45:00      4.40            X       20.6
    ## 196   02336410 2011-05-22 01:15:00        NA            A       22.3
    ## 197   02336313 2011-05-31 04:15:00      0.69            A       24.6
    ## 198   02203700 2011-05-03 15:30:00      6.10            X       20.8
    ## 199  021989773 2011-05-28 16:45:00   3660.00            A       26.7
    ## 200  021989773 2011-05-29 10:30:00 -26300.00            X       26.4
    ## 201   02336313 2011-05-07 06:15:00      1.10            A       16.0
    ## 202   02336313 2011-05-11 08:45:00      1.00            A       20.9
    ## 203   02336526 2011-05-12 01:30:00      3.80          A e       25.3
    ## 204   02336410 2011-05-12 08:00:00     17.00            A       22.5
    ## 205   02336728 2011-05-02 10:00:00     16.00            A       19.4
    ## 206   02337170 2011-05-03 03:00:00   4290.00            E       15.4
    ## 207   02336240 2011-05-06 07:30:00     14.00            A       15.0
    ## 208   02336300 2011-05-20 01:45:00     25.00          A e       19.4
    ## 209   02336313 2011-05-19 00:45:00      1.00            A       17.6
    ## 210   02336728 2011-05-17 03:15:00     12.00            A       16.4
    ## 211  021989773 2011-05-14 22:30:00 -48400.00            E       24.4
    ## 212   02337170 2011-05-28 06:45:00   3310.00            A       20.4
    ## 213   02336526 2011-05-05 02:45:00      7.20            A       17.5
    ## 214   02336360 2011-05-19 08:45:00     10.00            A       15.1
    ## 215   02203700 2011-05-09 09:00:00      4.90            E       18.4
    ## 216   02336410 2011-05-14 20:00:00     16.00            X       22.7
    ## 217   02336360 2011-05-17 20:30:00     10.00            A       16.5
    ## 218   02336410 2011-05-05 20:00:00     29.00            A       17.3
    ## 219  021989773 2011-05-15 09:30:00 -84200.00            X       24.0
    ## 220   02336300 2011-05-13 23:45:00     26.00            X       23.9
    ## 221  021989773 2011-05-17 00:00:00 -69700.00            A       23.9
    ## 222  021989773 2011-05-28 00:15:00  76000.00            A       26.2
    ## 223   02336120 2011-05-14 04:15:00     13.00            A       22.1
    ## 224   02336526 2011-05-15 13:00:00      3.60            A       18.6
    ## 225   02336240 2011-05-31 06:00:00     11.00          A e       23.5
    ## 226   02336240 2011-05-18 16:15:00     11.00            X       15.7
    ## 227   02336360 2011-05-04 20:45:00     25.00            E       19.6
    ## 228   02336240 2011-05-04 00:45:00    182.00            A       19.0
    ## 229   02336360 2011-05-06 07:00:00     15.00            X       16.1
    ## 230   02203655 2011-05-21 18:15:00      8.80            A       20.6
    ## 231   02336410 2011-05-17 07:45:00     16.00            A       16.3
    ## 232   02336410 2011-05-18 22:00:00     15.00          A e       17.0
    ## 233  021989773 2011-05-20 21:00:00  53400.00            A       23.9
    ## 234   02336360 2011-05-15 16:00:00     10.00            A       19.2
    ## 235   02336120 2011-05-06 01:30:00     21.00            X       17.2
    ## 236   02336360 2011-05-13 14:15:00     11.00            X       21.3
    ## 237   02336120 2011-05-20 02:30:00     12.00            A       18.9
    ## 238   02336120 2011-05-14 18:00:00     13.00            A       21.5
    ## 239   02336410 2011-05-30 06:30:00     15.00            A       23.9
    ## 240   02336526 2011-05-24 17:15:00      3.10            A       23.0
    ## 241   02203655 2011-05-21 05:00:00      7.80            A       20.3
    ## 242   02336728 2011-05-05 01:30:00     31.00          A e       17.4
    ## 243  021989773 2011-05-24 08:45:00  70100.00            X       24.8
    ## 244   02336728 2011-05-13 20:45:00     12.00            E       24.2
    ## 245  021989773 2011-05-24 14:30:00 -19200.00            X       25.2
    ## 246   02203655 2011-05-29 21:45:00     11.00          A e       23.3
    ## 247   02203700 2011-05-04 07:00:00        NA            E       16.6
    ## 248   02336120 2011-05-10 14:30:00     15.00            E       20.2
    ## 249   02337170 2011-05-13 18:15:00   5050.00          A e       16.9
    ## 250   02336526 2011-05-04 00:15:00     57.00            A       19.7
    ## 251   02336240 2011-05-20 17:30:00      9.50            A       20.6
    ## 252   02336526 2011-05-04 20:15:00      9.10            A       19.9
    ## 253   02336313 2011-05-21 03:30:00      0.93          A e       20.7
    ## 254   02336313 2011-05-30 19:15:00      0.73            E       26.2
    ## 255   02336360 2011-05-04 16:15:00     31.00          A e       17.3
    ## 256   02336728 2011-05-31 12:45:00     13.00            A       22.7
    ## 257   02336360 2011-05-29 22:00:00      7.50            E       25.7
    ## 258   02336240 2011-05-20 20:30:00      9.50            X       22.0
    ## 259   02337170 2011-05-17 01:00:00   1830.00            A       16.5
    ## 260   02336120 2011-05-27 12:00:00    995.00            X       20.5
    ## 261   02336728 2011-05-25 15:00:00      8.20            A       21.7
    ## 262   02336360 2011-05-10 15:00:00        NA            A       20.3
    ## 263   02337170 2011-05-03 12:15:00   4710.00            E       15.4
    ## 264  021989773 2011-05-01 20:00:00 -81400.00            A       24.1
    ## 265  021989773 2011-05-11 11:00:00  65300.00            A       23.0
    ## 266   02336360 2011-05-27 11:30:00    274.00            A       20.9
    ## 267   02336728 2011-05-26 21:15:00      8.20            A       25.2
    ## 268   02336410 2011-05-09 21:15:00     20.00            A       22.2
    ## 269   02336313 2011-05-03 03:30:00      1.00          A e       21.7
    ## 270   02203655 2011-05-26 05:45:00        NA            A       23.3
    ## 271   02203700 2011-05-04 12:15:00      9.80            A       15.1
    ## 272   02336240 2011-05-31 03:45:00     11.00            A       24.1
    ## 273   02336410 2011-05-31 15:45:00     12.00            E       24.2
    ## 274   02337170 2011-05-27 19:15:00   7200.00          A e       20.6
    ## 275   02337170 2011-06-01 03:15:00   1260.00            A       26.1
    ## 276   02336410 2011-05-05 15:45:00     31.00            E       15.3
    ## 277  021989773 2011-05-30 12:30:00  18200.00            X       26.8
    ## 278  021989773 2011-05-16 18:15:00  46900.00            X       24.0
    ## 279  021989773 2011-05-18 13:30:00 -49500.00            X       23.1
    ## 280   02336120 2011-05-19 01:15:00     13.00            E       17.1
    ## 281   02336313 2011-05-01 23:15:00        NA            A       22.4
    ## 282   02336360 2011-05-22 10:45:00      9.80            E       20.4
    ## 283   02336240 2011-05-29 07:45:00     15.00            X       21.3
    ## 284   02336728 2011-05-17 03:45:00     12.00            A       16.3
    ## 285  021989773 2011-05-31 08:00:00 -49400.00          A e       27.0
    ## 286   02336240 2011-05-08 01:15:00     13.00            A       18.5
    ## 287   02336300 2011-05-16 19:00:00     27.00            A       18.3
    ## 288   02336300 2011-05-08 03:45:00     34.00            X       18.6
    ## 289   02203700 2011-05-11 07:15:00      4.60          A e       21.4
    ## 290   02336360 2011-05-23 18:45:00     11.00            A       24.2
    ## 291   02336120 2011-05-22 03:30:00     12.00            A       22.2
    ## 292   02336120 2011-05-22 10:15:00     11.00            X       20.4
    ## 293  021989773 2011-05-17 00:15:00 -67500.00            X       23.9
    ## 294  021989773 2011-05-17 21:30:00 -48500.00            A       23.8
    ## 295   02203655 2011-05-31 19:00:00      9.60            X       24.0
    ## 296   02203655 2011-05-25 03:30:00      7.20            E       23.0
    ## 297   02203700 2011-05-10 02:00:00      5.10            X       22.8
    ## 298   02336313 2011-05-07 15:15:00      1.20            A       17.3
    ## 299   02337170 2011-05-13 22:30:00   6370.00            A       15.4
    ## 300  021989773 2011-05-21 01:15:00 -75700.00            X       23.6
    ## 301   02203700 2011-05-26 21:15:00      3.50            A       25.0
    ## 302   02336120 2011-05-21 00:15:00     12.00          A e       21.6
    ## 303   02203700 2011-05-25 03:30:00      3.70          A e       23.4
    ## 304  021989773 2011-05-24 03:30:00 -64900.00            X       25.0
    ## 305   02336410 2011-05-31 10:00:00     13.00            X       23.8
    ## 306   02203655 2011-05-07 16:00:00        NA            A       16.2
    ## 307   02336526 2011-05-06 03:30:00      5.50          A e       17.2
    ## 308  021989773 2011-05-20 14:45:00 -52000.00            A       23.3
    ## 309   02203700 2011-05-11 14:45:00      4.90            A       21.4
    ## 310   02336360 2011-05-07 00:45:00     14.00            E       18.4
    ## 311   02336410 2011-05-01 20:45:00     22.00            A       21.6
    ## 312   02336313 2011-05-05 15:45:00      1.30            A       15.6
    ## 313  021989773 2011-05-08 17:15:00  17700.00            X       22.7
    ## 314   02336728 2011-05-27 12:30:00    749.00            A       19.7
    ## 315   02336360 2011-05-22 17:45:00      9.80          A e       23.3
    ## 316   02203655 2011-05-30 03:15:00     11.00            X       24.4
    ## 317   02336300 2011-05-07 01:15:00     38.00            A       17.8
    ## 318   02203655 2011-05-25 01:15:00      7.20          A e       23.2
    ## 319   02336360 2011-05-07 14:45:00     14.00            A       15.7
    ## 320   02336360 2011-05-28 15:45:00     11.00            X       22.0
    ## 321   02336120 2011-05-24 08:00:00     10.00            X       22.2
    ## 322   02336300 2011-05-15 08:15:00     26.00            A       19.9
    ## 323   02337170 2011-05-31 10:30:00   1270.00            A       24.2
    ## 324   02336240 2011-05-23 16:45:00      8.20            A       23.1
    ## 325   02203655 2011-05-28 01:45:00     41.00            X       22.1
    ## 326   02336728 2011-05-01 09:00:00     16.00          A e       18.2
    ## 327   02336410 2011-05-08 18:00:00     21.00            A       19.6
    ## 328   02336410 2011-05-19 09:00:00     16.00            A       15.1
    ## 329   02336526 2011-05-26 06:00:00      3.50            X       23.6
    ## 330   02336240 2011-05-24 15:15:00      8.20          A e       22.2
    ## 331   02336313 2011-05-08 12:30:00      1.10            A       15.9
    ## 332   02336240 2011-05-04 10:15:00     89.00            X       16.3
    ## 333   02336240 2011-05-28 14:30:00     22.00            E       20.6
    ## 334   02336410 2011-05-31 20:00:00     11.00            A       27.1
    ## 335   02336360 2011-05-01 14:30:00        NA          A e       17.9
    ## 336   02336313 2011-05-13 11:00:00      1.00            A       20.4
    ## 337   02336728 2011-05-14 19:45:00     12.00            X       23.3
    ## 338   02203700 2011-05-13 08:15:00      4.40            A       20.9
    ## 339   02336728 2011-05-30 18:45:00     15.00            A       25.9
    ## 340   02336300 2011-05-24 06:15:00     22.00            E       23.1
    ## 341   02203655 2011-05-06 07:30:00     12.00            E       15.9
    ## 342   02336360 2011-05-11 12:00:00     12.00            X       21.0
    ## 343   02336120 2011-05-26 03:00:00     11.00            A       24.6
    ## 344   02336410 2011-05-19 15:45:00     15.00            X       15.6
    ## 345   02203655 2011-05-18 20:45:00      8.80          A e       16.0
    ## 346   02336313 2011-05-02 21:45:00      1.00            A       23.3
    ## 347   02336313 2011-05-02 15:45:00      1.00            A       21.0
    ## 348   02336526 2011-05-25 00:00:00      3.10          A e       25.3
    ## 349   02337170 2011-05-11 06:15:00   3250.00            A       17.8
    ## 350   02336300 2011-05-14 11:30:00     27.00            E       21.1
    ## 351   02337170 2011-05-04 17:45:00   6280.00            E       16.3
    ## 352   02203700 2011-05-24 17:45:00      3.70            E       24.1
    ## 353   02336410 2011-05-06 12:45:00     26.00            A       15.0
    ## 354   02336360 2011-05-09 04:30:00     13.00            X       19.5
    ## 355   02336526 2011-05-16 22:15:00      5.00            X       18.2
    ## 356   02336120 2011-05-04 02:30:00    504.00            E       18.5
    ## 357   02336240 2011-05-30 08:15:00     12.00            E       22.6
    ## 358   02336410 2011-05-11 03:30:00     19.00            E       23.0
    ## 359   02336120 2011-05-15 07:15:00        NA            A       19.9
    ## 360   02337170 2011-05-12 12:30:00   4480.00          A e       16.1
    ## 361   02336240 2011-05-10 00:45:00     11.00            A       21.8
    ## 362   02336240 2011-05-23 06:30:00      8.50            X       21.6
    ## 363   02337170 2011-05-21 21:45:00   3390.00            X       17.8
    ## 364   02336240 2011-05-10 20:45:00     11.00            A       24.4
    ## 365   02336410 2011-05-21 11:00:00     14.00            E       19.1
    ## 366  021989773 2011-05-06 07:45:00  45800.00            X       23.1
    ## 367   02336728 2011-05-20 01:45:00     11.00            X       18.1
    ## 368   02336300 2011-05-24 21:30:00        NA            A       26.7
    ## 369   02336728 2011-05-31 06:45:00     13.00            X       23.2
    ## 370   02336728 2011-05-30 05:00:00     16.00            X       22.7
    ## 371   02336360 2011-05-05 18:00:00     16.00            A       17.0
    ## 372  021989773 2011-05-31 01:15:00  23600.00            A       27.4
    ## 373   02336120 2011-05-12 02:15:00     15.00            A       23.8
    ## 374   02336360 2011-05-10 03:00:00     12.00            X       21.7
    ## 375   02203700 2011-05-15 17:30:00      4.40            E       19.2
    ## 376   02336300 2011-05-24 02:45:00     21.00            E       24.1
    ## 377   02203700 2011-05-20 17:30:00      4.20            E       20.9
    ## 378   02336410 2011-05-02 07:15:00     21.00            X       20.2
    ## 379  021989773 2011-05-08 12:45:00 -44400.00            A       22.2
    ## 380   02336728 2011-05-03 09:45:00     15.00            A       20.1
    ## 381   02336240 2011-05-01 13:15:00     13.00            A       17.5
    ## 382   02336410 2011-05-31 17:15:00     12.00          A e       25.3
    ## 383   02336240 2011-05-18 01:45:00     11.00            A       15.3
    ## 384   02336360 2011-05-13 23:45:00     11.00            E       23.0
    ## 385  021989773 2011-05-08 22:45:00  41600.00            A       23.0
    ## 386   02336120 2011-05-11 10:15:00     15.00            A       21.2
    ## 387   02336240 2011-05-12 17:15:00     11.00            X       23.8
    ## 388   02336120 2011-05-10 19:30:00     16.00            A       23.1
    ## 389   02336360 2011-05-22 18:45:00      9.80            X       24.3
    ## 390   02336728 2011-05-29 10:45:00     21.00            X       21.8
    ## 391   02336410 2011-05-12 20:15:00     17.00            A       25.3
    ## 392   02336360 2011-05-29 15:00:00      8.10            A       22.3
    ## 393   02336300 2011-05-03 23:00:00     47.00            E       20.2
    ## 394   02336240 2011-05-16 05:15:00      9.90            X       17.3
    ## 395   02336360 2011-05-29 05:00:00      8.70            E       23.2
    ## 396   02336526 2011-05-22 01:30:00      3.60            A       23.6
    ## 397   02336360 2011-05-11 18:45:00     12.00            E       24.6
    ## 398   02203700 2011-05-02 02:15:00      6.10            A       21.3
    ## 399   02203700 2011-05-18 23:15:00      4.20            A       18.4
    ## 400   02203655 2011-05-02 07:45:00     11.00            A       20.0
    ## 401   02336728 2011-05-16 19:45:00     12.00            A       18.0
    ## 402   02337170 2011-05-30 10:00:00   1390.00            A       22.9
    ## 403   02203700 2011-05-18 21:45:00      4.00            E       18.7
    ## 404   02203655 2011-05-31 07:45:00      9.20            X       24.0
    ## 405   02337170 2011-05-14 20:30:00   5450.00            X       16.0
    ## 406   02336300 2011-05-12 02:30:00     30.00            A       24.0
    ## 407   02336240 2011-05-24 01:00:00      8.20          A e       23.6
    ## 408   02336120 2011-05-11 23:15:00     15.00            E       24.8
    ## 409   02336410 2011-05-08 11:45:00     21.00            E       17.0
    ## 410   02336410 2011-05-12 07:45:00     17.00            A       22.5
    ## 411   02336313 2011-05-06 19:00:00      1.20            E       19.4
    ## 412   02336360 2011-05-23 17:30:00     11.00            E       23.3
    ## 413   02336410 2011-05-06 11:00:00     26.00          A e       15.2
    ## 414   02336728 2011-05-04 14:00:00     72.00            A       16.5
    ## 415   02337170 2011-05-22 11:00:00   2240.00            X       16.6
    ## 416   02337170 2011-05-24 05:00:00   1840.00            X       20.3
    ## 417   02336526 2011-05-08 00:45:00      4.80          A e       20.8
    ## 418   02336410 2011-05-24 14:45:00     13.00            A       21.9
    ## 419   02336728 2011-05-28 05:30:00     47.00            A       21.8
    ## 420   02336313 2011-05-06 05:45:00      1.20            A       15.5
    ## 421   02337170 2011-05-27 10:45:00   4000.00            A       20.8
    ## 422   02203655 2011-05-07 18:15:00     12.00            E       17.6
    ## 423   02336526 2011-05-11 18:00:00      4.00            E       23.6
    ## 424   02336313 2011-05-29 08:30:00      0.77            X       21.3
    ## 425  021989773 2011-05-01 14:30:00  76200.00            E       23.5
    ## 426   02336410 2011-05-14 02:45:00     16.00            A       22.6
    ## 427  021989773 2011-05-21 04:30:00 -44300.00          A e       23.7
    ## 428   02336120 2011-05-05 02:30:00     33.00          A e       17.3
    ## 429   02203700 2011-05-24 02:00:00      3.70            A       24.1
    ## 430   02203700 2011-05-12 06:45:00      4.60            A       21.9
    ## 431   02336120 2011-05-15 07:30:00     13.00            X       19.8
    ## 432   02336313 2011-05-23 20:00:00      0.98            E       24.8
    ## 433   02337170 2011-05-26 00:30:00   1690.00            A       21.1
    ## 434   02336120 2011-05-15 04:30:00     13.00          A e       20.8
    ## 435  021989773 2011-05-27 08:30:00 -28800.00            E       25.9
    ## 436   02336410 2011-05-05 03:15:00     43.00            A       17.7
    ## 437   02336360 2011-05-19 20:30:00     10.00            X       20.0
    ## 438   02203700 2011-05-05 16:30:00     21.00            X       18.9
    ## 439   02336526 2011-05-20 00:15:00      3.80          A e       20.0
    ## 440   02336728 2011-05-04 03:15:00    284.00            E       19.3
    ## 441   02336300 2011-05-17 09:30:00     27.00            A       15.8
    ## 442   02336240 2011-05-27 20:30:00        NA            A       21.8
    ## 443   02203655 2011-05-02 03:00:00     11.00            A       20.9
    ## 444   02337170 2011-05-29 14:45:00   1620.00            E       21.3
    ## 445   02336313 2011-05-14 16:15:00      1.00            A       21.1
    ## 446  021989773 2011-05-12 01:30:00  52100.00            A       23.5
    ## 447   02336120 2011-05-21 08:30:00     12.00          A e       19.2
    ## 448   02336360 2011-05-02 06:15:00     13.00            A       20.0
    ## 449   02203700 2011-05-26 15:45:00      3.70            A       22.7
    ## 450   02203700 2011-05-12 15:45:00      5.10            A       22.4
    ## 451   02336300 2011-05-24 14:45:00     21.00            A       22.7
    ## 452   02336526 2011-05-01 15:00:00      4.40          A e       17.8
    ## 453   02336313 2011-05-20 11:45:00      1.00            X       16.1
    ## 454  021989773 2011-05-16 11:15:00 -55200.00            A       24.0
    ## 455   02203655 2011-05-25 23:00:00      7.50            A       23.4
    ## 456   02336313 2011-05-24 03:45:00      0.87            E       23.1
    ## 457   02336728 2011-05-21 10:00:00      9.70            A       18.1
    ## 458   02336728 2011-05-01 23:30:00     16.00            X       21.0
    ## 459   02336526 2011-05-31 15:15:00      4.60            E       23.1
    ## 460   02336300 2011-05-20 09:00:00     25.00            A       17.7
    ## 461   02336313 2011-05-28 15:45:00      0.93          A e       21.8
    ## 462   02203700 2011-05-16 01:15:00      4.40            A       18.1
    ## 463   02336410 2011-05-07 05:45:00     23.00            A       17.1
    ## 464   02336728 2011-05-27 14:30:00    268.00            A       19.8
    ## 465   02203655 2011-05-26 20:30:00      7.50          A e       23.5
    ## 466   02336410 2011-05-03 11:15:00        NA            A       20.2
    ## 467   02337170 2011-05-09 03:15:00   1390.00            A       18.8
    ## 468  021989773 2011-05-03 23:45:00 -73900.00            X       24.0
    ## 469   02336313 2011-05-12 03:30:00      0.98          A e       23.4
    ## 470   02336300 2011-05-09 01:00:00     32.00            A       20.5
    ## 471   02336240 2011-05-28 07:00:00     28.00            A       20.9
    ## 472   02337170 2011-05-20 20:00:00   3450.00            E       16.8
    ## 473   02336120 2011-05-28 05:00:00     44.00            X       22.0
    ## 474   02336526 2011-05-24 15:00:00      3.10            A       21.7
    ## 475   02336410 2011-05-22 14:00:00     14.00            A       20.7
    ## 476   02336313 2011-05-10 01:45:00      0.98            A       22.7
    ## 477   02336360 2011-05-23 21:30:00     10.00            A       24.8
    ## 478   02336360 2011-05-30 23:45:00      6.60            X       26.4
    ## 479   02336410 2011-05-21 10:00:00     14.00          A e       19.3
    ## 480   02336526 2011-05-20 04:45:00      3.80            E       19.1
    ## 481   02337170 2011-05-14 21:00:00   5540.00            A       15.9
    ## 482   02203655 2011-05-06 04:00:00     13.00            A       17.4
    ## 483   02203700 2011-05-24 18:30:00      3.70            E       24.6
    ## 484   02336526 2011-05-16 12:15:00      3.80            A       16.5
    ## 485   02336313 2011-05-09 17:30:00      1.10            A       22.8
    ## 486   02336526 2011-05-23 11:45:00      3.60          A e       21.1
    ## 487   02336526 2011-05-15 05:45:00      3.60          A e       21.1
    ## 488   02336240 2011-05-15 17:45:00     10.00            A       19.3
    ## 489   02336240 2011-05-31 08:00:00     11.00            E       23.0
    ## 490   02336728 2011-05-29 05:30:00     23.00            A       21.9
    ## 491   02336240 2011-05-22 12:00:00      8.90            A       19.5
    ## 492   02336240 2011-05-20 13:45:00      9.50            A       16.6
    ## 493   02336313 2011-05-15 06:00:00      0.93            E       20.0
    ## 494   02337170 2011-05-10 07:30:00   1350.00            X       21.0
    ## 495   02203655 2011-05-30 20:15:00     10.00            A       23.9
    ## 496   02336360 2011-05-13 12:15:00     11.00            A       21.0
    ## 497  021989773 2011-05-12 00:15:00  52200.00          A e       23.8
    ## 498   02203700 2011-05-04 15:15:00     25.00            A       15.9
    ## 499   02336728 2011-05-03 13:15:00     15.00            E       20.3
    ## 500   02336360 2011-05-31 19:00:00      6.30            A       27.0
    ## 501   02337170 2011-05-03 03:30:00   4190.00            A       15.4
    ## 502   02203700 2011-05-13 10:15:00      4.40            A       20.2
    ## 503   02203700 2011-05-22 14:30:00      3.90          A e       20.4
    ## 504   02336360 2011-05-27 05:45:00     89.00            E       22.1
    ## 505   02336300 2011-05-16 01:15:00        NA            A       18.3
    ## 506   02336120 2011-05-06 00:00:00     22.00          A e       17.7
    ## 507   02336410 2011-05-09 00:15:00     21.00            A       20.1
    ## 508   02336300 2011-05-25 12:30:00     19.00            X       21.9
    ## 509   02336526 2011-05-14 13:15:00      3.60            A       20.5
    ## 510   02203700 2011-05-16 19:15:00      6.70          A e       18.5
    ## 511   02336410 2011-05-10 04:45:00     19.00            X       21.4
    ## 512   02336410 2011-05-07 04:00:00     23.00            A       17.4
    ## 513   02337170 2011-05-31 02:15:00   1270.00            E       25.5
    ## 514   02336300 2011-05-06 15:15:00     39.00            X       15.4
    ## 515   02336360 2011-05-20 21:30:00     10.00            E       22.3
    ## 516   02336300 2011-05-21 00:45:00     25.00            A       22.2
    ## 517   02336526 2011-05-11 16:00:00      4.00          A e       21.7
    ## 518   02336300 2011-05-03 20:45:00        NA          A e       22.8
    ## 519   02203655 2011-05-02 04:15:00     11.00            A       20.8
    ## 520   02336728 2011-05-24 05:00:00      8.90            E       22.1
    ## 521   02336360 2011-05-12 06:45:00     11.00            E       22.5
    ## 522   02336313 2011-05-01 17:15:00      1.10          A e       21.3
    ## 523   02336728 2011-05-04 14:15:00     68.00            A       16.5
    ## 524   02336360 2011-05-09 05:00:00     12.00            A       19.4
    ## 525  021989773 2011-05-02 23:15:00 -70600.00          A e       24.0
    ## 526   02336526 2011-05-02 23:00:00      4.20            A       23.7
    ## 527   02336410 2011-05-15 09:30:00     17.00            X       19.7
    ## 528   02336526 2011-05-27 11:00:00    184.00          A e       19.7
    ## 529   02336360 2011-05-05 16:00:00     17.00          A e       15.4
    ## 530   02336120 2011-05-23 12:30:00     11.00            X       21.2
    ## 531   02336728 2011-05-25 07:15:00      8.20          A e       21.6
    ## 532   02203700 2011-05-22 02:30:00      3.90            A       22.9
    ## 533   02336526 2011-05-28 04:15:00     14.00            E       21.8
    ## 534   02336526 2011-05-26 15:15:00      2.80            A       22.6
    ## 535   02336360 2011-05-11 22:45:00     11.00            A       24.9
    ## 536   02336313 2011-05-13 22:15:00      0.98          A e       24.1
    ## 537   02337170 2011-05-29 02:15:00   2480.00            A       21.6
    ## 538   02336526 2011-05-30 23:30:00      4.60            A       27.2
    ## 539   02203700 2011-05-25 17:30:00      3.70            X       24.0
    ## 540   02336120 2011-05-07 13:15:00     17.00          A e       15.7
    ## 541   02336240 2011-05-24 00:15:00      8.20            A       23.8
    ## 542   02336300 2011-05-06 14:45:00     39.00            A       15.2
    ## 543   02336240 2011-05-10 22:00:00     11.00            A       24.0
    ## 544   02336120 2011-05-31 02:15:00     13.00            E       25.6
    ## 545   02203700 2011-05-15 01:00:00      4.20            A       21.7
    ## 546   02337170 2011-05-02 12:00:00   2850.00            A       15.5
    ## 547   02336360 2011-05-21 01:00:00     10.00            A       21.1
    ## 548  021989773 2011-05-30 06:15:00  26100.00            A       26.8
    ## 549   02336313 2011-05-10 12:45:00      1.10          A e       19.4
    ## 550   02203655 2011-05-20 02:15:00      8.80            A       18.5
    ## 551   02336728 2011-05-02 10:15:00     15.00          A e       19.5
    ## 552   02336360 2011-05-11 15:15:00     12.00          A e       21.6
    ## 553  021989773 2011-05-14 11:45:00  30400.00            A       24.1
    ## 554   02336410 2011-05-20 23:15:00     14.00            A       21.3
    ## 555   02203700 2011-05-21 15:30:00      4.00            A       19.9
    ## 556   02203655 2011-05-26 15:30:00      7.20            A       22.2
    ## 557   02203700 2011-05-10 06:00:00      4.90          A e       20.8
    ## 558   02336313 2011-05-18 22:15:00      1.00            X       18.2
    ## 559   02337170 2011-05-17 17:45:00   2670.00            E       15.7
    ## 560   02336360 2011-05-28 17:45:00     11.00            X       23.7
    ## 561   02336526 2011-05-06 18:15:00      5.20          A e       17.9
    ## 562   02336240 2011-05-16 14:30:00     10.00            A       16.5
    ## 563  021989773 2011-05-14 21:45:00 -67500.00            A       24.4
    ## 564   02203655 2011-05-02 10:30:00     11.00            A       19.1
    ## 565   02336526 2011-05-01 20:45:00      4.20            A       22.7
    ## 566   02203700 2011-05-15 21:15:00      4.60            A       19.0
    ## 567   02336728 2011-05-26 05:15:00      8.20            A       22.6
    ## 568   02336360 2011-05-05 02:15:00     21.00          A e       18.3
    ## 569   02203700 2011-05-21 12:00:00      4.20            X       17.8
    ## 570   02336410 2011-05-08 21:30:00     21.00            A       20.2
    ## 571   02336120 2011-05-28 04:15:00     46.00          A e       22.1
    ## 572   02336410 2011-05-04 09:45:00    159.00            A       17.5
    ## 573   02337170 2011-05-17 01:45:00   1790.00          A e       16.4
    ## 574   02336526 2011-05-12 20:00:00      3.60            A       25.5
    ## 575   02337170 2011-05-12 10:30:00   4010.00            A       16.3
    ## 576   02336313 2011-05-01 17:00:00      1.10            A       21.1
    ## 577   02336410 2011-05-28 10:30:00     33.00          A e       21.4
    ## 578   02336526 2011-05-15 10:45:00      3.60            X       19.2
    ## 579   02337170 2011-05-10 10:15:00   1430.00            A       20.7
    ## 580   02336240 2011-05-21 01:00:00      9.20            A       20.7
    ## 581   02336360 2011-05-05 22:00:00     16.00            A       18.0
    ## 582   02336410 2011-05-03 02:00:00     21.00            A       21.5
    ## 583   02203700 2011-05-24 21:15:00      3.90          A e       25.9
    ## 584   02336360 2011-05-30 07:15:00        NA            A       23.8
    ## 585   02336410 2011-05-15 23:30:00     16.00            A       18.7
    ## 586   02336526 2011-05-15 19:45:00      3.60          A e       18.9
    ## 587   02337170 2011-05-08 13:00:00   1540.00            E       15.4
    ## 588  021989773 2011-05-30 23:15:00 -46200.00            A       27.5
    ## 589   02336120 2011-05-09 20:00:00     16.00            A       21.9
    ## 590   02336526 2011-05-20 16:00:00      3.60            E       17.9
    ## 591   02336728 2011-05-03 21:45:00     32.00            X       21.6
    ## 592   02336526 2011-05-11 12:00:00      4.00            A       20.7
    ## 593  021989773 2011-05-07 21:45:00  45900.00            A       23.0
    ## 594  021989773 2011-05-31 02:15:00        NA            E       27.4
    ## 595   02203700 2011-05-14 11:00:00      4.60            X       20.2
    ## 596   02336526 2011-05-30 20:15:00      4.80            A       26.7
    ## 597   02336410 2011-05-28 19:00:00     25.00            A       24.1
    ## 598   02203700 2011-05-06 22:00:00      5.30          A e       21.0
    ## 599   02336240 2011-05-02 05:30:00     13.00            X       19.3
    ## 600   02336728 2011-05-01 04:15:00     17.00            E       18.1
    ## 601  021989773 2011-05-15 12:15:00   6240.00            A       24.1
    ## 602   02203700 2011-05-27 00:15:00    115.00            A       23.2
    ## 603   02336526 2011-05-01 08:30:00      4.20            A       18.5
    ## 604   02337170 2011-05-27 23:15:00   6190.00            X       20.6
    ## 605   02203700 2011-05-17 20:00:00      4.40            X       16.9
    ## 606   02336360 2011-06-01 01:45:00      7.20            A       26.0
    ## 607   02336728 2011-05-04 03:30:00    314.00            E       19.3
    ## 608   02203700 2011-05-03 05:30:00      6.10            A       20.2
    ## 609   02203700 2011-05-15 15:45:00      4.20            E       19.0
    ## 610   02336313 2011-05-09 08:30:00      1.00            A       18.5
    ## 611   02336240 2011-05-15 22:15:00     10.00          A e       18.6
    ## 612   02336300 2011-05-17 00:30:00     27.00            A       17.8
    ## 613   02336410 2011-05-27 07:30:00    207.00            X       21.7
    ## 614  021989773 2011-05-11 23:45:00  66500.00            A       23.9
    ## 615   02336410 2011-05-05 20:45:00     28.00            A       17.4
    ## 616   02203655 2011-05-04 09:30:00     81.00          A e       16.3
    ## 617   02336240 2011-05-02 13:45:00     13.00            E       18.8
    ## 618   02336120 2011-05-15 23:00:00     13.00          A e       18.8
    ## 619   02336410 2011-05-18 18:45:00     16.00            A       16.7
    ## 620   02203700 2011-05-01 09:45:00      6.10            A       17.3
    ## 621   02337170 2011-05-31 06:45:00   1270.00            E       24.7
    ## 622   02203700 2011-05-22 05:00:00      3.70            X       21.7
    ## 623   02336526 2011-05-20 04:30:00      3.80          A e       19.2
    ## 624   02336300 2011-05-17 19:00:00     29.00            A       16.8
    ## 625   02336300 2011-05-24 07:00:00     21.00          A e       22.9
    ## 626   02203700 2011-05-10 00:45:00      4.90          A e       23.4
    ## 627   02336360 2011-05-11 11:45:00     12.00            A       21.1
    ## 628   02336300 2011-05-03 16:45:00     31.00            E       22.0
    ## 629  021989773 2011-05-07 05:00:00  42500.00            X       23.0
    ## 630   02336120 2011-05-04 18:15:00     55.00          A e       18.0
    ## 631   02336526 2011-05-28 20:30:00      8.00          A e       25.3
    ## 632   02336313 2011-05-05 23:00:00      1.20            A       18.5
    ## 633   02336526 2011-05-27 21:00:00     22.00            A       23.6
    ## 634   02336526 2011-05-29 12:00:00      6.40            X       20.7
    ## 635   02337170 2011-05-30 11:30:00   1370.00            A       22.7
    ## 636   02336240 2011-05-16 02:00:00     10.00            A       17.8
    ## 637   02336728 2011-05-03 09:15:00     15.00            X       20.0
    ## 638  021989773 2011-05-07 23:00:00  -4550.00            A       22.8
    ## 639   02336240 2011-05-03 06:30:00     12.00            A       19.9
    ## 640   02203655 2011-05-20 05:45:00      8.20            X       18.3
    ## 641   02336526 2011-05-01 14:30:00      4.40          A e       17.6
    ## 642   02336120 2011-05-30 11:00:00     14.00            A       23.1
    ## 643   02336240 2011-05-24 16:00:00      8.20            A       22.8
    ## 644   02336728 2011-05-15 08:30:00     11.00            E       19.1
    ## 645   02336728 2011-05-24 13:00:00      8.90            X       20.8
    ## 646   02336120 2011-05-03 02:15:00     16.00            X       21.5
    ## 647   02336240 2011-05-23 18:45:00      8.50            E       24.9
    ## 648   02203655 2011-05-22 01:15:00      8.20            X       21.8
    ## 649   02336240 2011-05-05 17:45:00     15.00            A       17.4
    ## 650   02337170 2011-05-28 18:45:00   2400.00            A       21.2
    ## 651   02336728 2011-05-24 11:30:00      8.90          A e       20.6
    ## 652   02336120 2011-05-06 17:30:00     19.00            A       16.4
    ## 653   02336526 2011-05-22 18:00:00      3.50            X       23.0
    ## 654   02337170 2011-05-31 14:45:00   1270.00            X       23.9
    ## 655  021989773 2011-05-28 04:45:00 -11000.00          A e       26.0
    ## 656   02336360 2011-05-28 15:00:00     11.00            E       21.6
    ## 657   02203655 2011-05-03 19:45:00     11.00            A       20.8
    ## 658   02203655 2011-05-05 18:00:00     14.00          A e       16.0
    ## 659   02336120 2011-05-31 12:15:00     12.00          A e       23.2
    ## 660   02203655 2011-05-05 01:45:00     18.00            A       18.3
    ## 661   02336240 2011-05-10 02:15:00     11.00            A       21.2
    ## 662   02203655 2011-05-25 04:00:00      7.20            X       22.9
    ## 663   02336313 2011-05-13 15:00:00      1.00            A       22.1
    ## 664  021989773 2011-05-11 02:30:00 -35400.00          A e       23.1
    ## 665   02203700 2011-05-23 14:30:00      3.90          A e       20.9
    ## 666  021989773 2011-05-11 18:00:00 -61700.00          A e       23.4
    ## 667   02336728 2011-05-30 08:30:00     16.00          A e       22.6
    ## 668   02336526 2011-05-03 06:30:00      4.20            X       21.3
    ## 669   02336240 2011-05-30 02:30:00     12.00            E       23.7
    ## 670   02336526 2011-05-01 10:30:00      4.20            E       17.8
    ## 671   02336526 2011-05-16 02:00:00      3.80            A       18.2
    ## 672   02336313 2011-05-28 09:45:00      0.98            E       20.1
    ## 673   02336240 2011-05-18 23:45:00      9.90            E       16.9
    ## 674   02336240 2011-05-14 00:45:00     10.00            A       22.8
    ## 675   02336526 2011-05-05 18:45:00      5.70            A       17.2
    ## 676  021989773 2011-05-04 05:00:00  85700.00            A       23.8
    ## 677   02336526 2011-05-03 19:00:00      4.00            A       22.9
    ## 678  021989773 2011-05-23 08:45:00  79100.00            A       24.5
    ## 679   02336240 2011-05-15 00:45:00     11.00          A e       21.4
    ## 680   02336240 2011-05-29 14:45:00     14.00            A       21.9
    ## 681   02336526 2011-05-22 09:00:00      3.30            A       21.3
    ## 682   02337170 2011-05-25 14:30:00   1560.00            A       19.7
    ## 683   02336313 2011-05-20 01:00:00      0.98            X       19.6
    ## 684   02203655 2011-05-28 05:15:00     32.00          A e       21.3
    ## 685   02336313 2011-05-22 01:45:00      0.93            A       22.7
    ## 686   02336313 2011-05-28 09:00:00      1.00            E       20.3
    ## 687   02336728 2011-05-26 05:30:00      8.20            X       22.5
    ## 688  021989773 2011-05-17 14:15:00  18300.00            A       23.5
    ## 689   02336410 2011-05-15 03:45:00     16.00          A e       21.1
    ## 690   02336300 2011-05-08 08:00:00     33.00            A       17.6
    ## 691  021989773 2011-05-25 08:15:00   3590.00            A       25.3
    ## 692  021989773 2011-05-13 20:15:00 -67400.00            A       24.6
    ## 693   02203655 2011-05-01 16:15:00     11.00            A       18.5
    ## 694   02336360 2011-05-13 00:15:00     11.00            X       24.4
    ## 695  021989773 2011-05-05 19:00:00  73800.00            X       23.4
    ## 696   02336410 2011-05-08 17:15:00     21.00            X       19.0
    ## 697   02336240 2011-05-11 22:45:00     11.00            X       24.4
    ## 698   02336410 2011-05-17 10:00:00     16.00            A       15.9
    ## 699   02203655 2011-05-22 21:45:00      8.20            X       22.6
    ## 700   02336300 2011-05-02 05:30:00     32.00            A       20.5
    ## 701   02336313 2011-05-31 22:45:00      0.65            E       26.7
    ## 702   02203700 2011-05-13 16:30:00      4.40            A       22.8
    ## 703   02203700 2011-05-07 21:00:00      5.30            E       22.3
    ## 704   02203700 2011-05-25 21:15:00      3.70            E       26.1
    ## 705   02336410 2011-06-01 03:15:00     12.00            E       25.5
    ## 706   02203655 2011-05-21 03:30:00      8.20            A       20.6
    ## 707   02336313 2011-05-01 06:30:00      1.00          A e       18.4
    ## 708  021989773 2011-05-12 15:45:00 -19300.00            E       23.6
    ## 709   02336526 2011-05-29 17:30:00      5.90            A       23.5
    ## 710   02337170 2011-05-25 02:45:00   2120.00            A       21.0
    ## 711   02336526 2011-05-03 09:30:00      4.00          A e       20.3
    ## 712   02336120 2011-05-30 09:30:00     15.00          A e       23.4
    ## 713   02336313 2011-05-01 17:45:00      1.10            E       21.7
    ## 714   02336728 2011-05-17 08:15:00     13.00            A       15.6
    ## 715   02336410 2011-05-26 11:45:00     11.00            A       22.6
    ## 716   02337170 2011-05-27 14:45:00   6860.00            E       20.4
    ## 717   02336526 2011-05-22 16:45:00      3.60          A e       21.8
    ## 718   02336526 2011-05-14 00:30:00      3.60            A       23.7
    ## 719   02203700 2011-05-10 16:00:00      4.90            A       21.8
    ## 720   02336526 2011-05-24 22:45:00      3.30            A       25.4
    ## 721   02336240 2011-05-02 00:00:00     13.00            A       20.9
    ## 722  021989773 2011-05-25 03:15:00 -42700.00            A       25.4
    ## 723   02337170 2011-05-27 00:45:00   1720.00            A       21.4
    ## 724   02336728 2011-05-21 09:45:00        NA            A       18.1
    ## 725   02336120 2011-05-13 15:00:00     13.00            E       21.7
    ## 726   02203655 2011-05-02 07:15:00     11.00          A e       20.1
    ## 727   02336360 2011-05-10 09:30:00     12.00            A       20.4
    ## 728   02336120 2011-05-28 20:15:00     25.00            A       24.6
    ## 729   02336526 2011-05-12 17:15:00      3.80            A       23.1
    ## 730   02336313 2011-05-02 08:30:00      1.00            A       19.2
    ## 731   02203700 2011-05-01 17:30:00      6.10            E       21.8
    ## 732   02336410 2011-05-19 21:00:00     14.00            A       19.4
    ## 733   02336120 2011-05-27 02:45:00    580.00            E       22.6
    ## 734   02203700 2011-05-01 16:00:00      6.10            A       19.7
    ## 735   02336526 2011-05-30 02:30:00      6.40            E       25.8
    ## 736   02203700 2011-05-17 07:00:00      4.60            A       15.8
    ## 737   02336313 2011-05-22 16:00:00      1.10            A       22.8
    ## 738  021989773 2011-05-06 16:00:00  13400.00            E       23.2
    ## 739   02203655 2011-05-28 08:15:00     25.00            X       20.7
    ## 740   02203655 2011-05-02 12:00:00     11.00            X       18.7
    ## 741   02336120 2011-05-31 13:15:00     12.00            E       23.3
    ## 742  021989773 2011-05-04 10:15:00 -36700.00          A e       23.4
    ## 743   02336120 2011-05-25 04:30:00      9.90          A e       23.7
    ## 744   02336313 2011-05-20 08:30:00      0.98            A       16.9
    ## 745   02336526 2011-05-15 03:45:00      3.80            A       21.9
    ## 746   02337170 2011-05-14 15:30:00   3700.00            A       15.2
    ## 747   02203700 2011-05-26 02:30:00      3.70            A       24.3
    ## 748   02336240 2011-05-03 11:15:00     13.00          A e       19.3
    ## 749   02203700 2011-05-26 03:30:00      3.50            A       23.9
    ## 750   02336728 2011-05-19 16:30:00        NA          A e       17.0
    ## 751   02336313 2011-05-15 16:00:00      1.00            E       18.8
    ## 752  021989773 2011-05-04 19:45:00  53600.00          A e       23.6
    ## 753   02336410 2011-05-24 14:00:00     13.00            A       21.7
    ## 754   02336360 2011-05-20 01:30:00     10.00            X       18.7
    ## 755   02336313 2011-05-06 19:15:00        NA            E       19.6
    ## 756   02336120 2011-05-24 14:30:00     11.00            A       21.8
    ## 757   02336410 2011-05-31 05:15:00     13.00            A       24.6
    ## 758   02336728 2011-05-28 04:15:00     51.00            A       22.0
    ## 759   02336526 2011-05-08 07:30:00      4.60          A e       17.7
    ## 760  021989773 2011-05-15 21:45:00 -70400.00            X       24.5
    ## 761   02336360 2011-05-22 14:15:00      9.80            X       20.4
    ## 762   02336410 2011-05-14 00:00:00     16.00            E       23.0
    ## 763   02336313 2011-05-28 21:30:00        NA            X       24.9
    ## 764   02336360 2011-05-30 22:45:00      6.60            A       26.8
    ## 765   02336313 2011-05-20 04:30:00      0.98            A       18.3
    ## 766   02336410 2011-05-25 07:00:00     13.00            A       22.7
    ## 767   02336410 2011-05-16 02:30:00     16.00            A       18.2
    ## 768   02203700 2011-05-04 15:00:00     24.00            A       15.8
    ## 769   02336313 2011-05-22 22:15:00      0.93            A       24.9
    ## 770   02336120 2011-05-02 21:15:00     17.00            A       22.2
    ## 771   02203700 2011-05-19 01:15:00      4.20            A       17.6
    ## 772   02337170 2011-05-24 22:30:00   2270.00            A       20.5
    ## 773  021989773 2011-05-14 07:00:00 -63600.00            A       23.9
    ## 774   02336300 2011-05-24 19:00:00     21.00          A e       25.7
    ## 775   02336360 2011-05-05 09:00:00     18.00          A e       15.9
    ## 776   02203655 2011-05-27 11:15:00   1170.00            E       19.7
    ## 777   02203700 2011-05-03 13:00:00      6.10            A       18.9
    ## 778   02203700 2011-05-11 09:15:00      4.60            A       20.6
    ## 779   02337170 2011-05-04 22:45:00   7340.00            A       15.1
    ## 780   02336526 2011-05-14 20:30:00      3.60            A       23.5
    ## 781   02336240 2011-05-20 15:00:00      9.50            A       17.5
    ## 782   02203700 2011-05-09 11:45:00      4.90            E       17.8
    ## 783   02336120 2011-05-05 22:00:00     22.00            A       17.9
    ## 784   02203700 2011-05-23 06:00:00      3.70            A       22.1
    ## 785   02336410 2011-05-18 23:00:00     15.00            E       16.8
    ## 786   02337170 2011-05-24 11:15:00   1940.00            X       20.2
    ## 787   02203700 2011-05-24 12:15:00      3.90            A       20.3
    ## 788   02336240 2011-05-06 21:30:00     14.00            A       18.6
    ## 789   02336240 2011-05-22 06:15:00      8.90            E       20.6
    ## 790  021989773 2011-05-30 20:45:00 -80800.00            A       27.4
    ## 791  021989773 2011-05-13 18:00:00 -59600.00            A       24.6
    ## 792   02336410 2011-05-20 03:15:00     15.00            E       18.2
    ## 793   02336240 2011-05-04 17:15:00     33.00            A       17.5
    ## 794   02203700 2011-05-24 05:45:00      3.90            X       22.4
    ## 795   02337170 2011-05-25 02:15:00   2070.00            A       21.0
    ## 796   02336526 2011-05-24 16:45:00      3.10            A       22.6
    ## 797   02336410 2011-05-05 18:45:00     30.00            A       17.1
    ## 798   02336240 2011-05-07 05:15:00     13.00            X       16.1
    ## 799   02336120 2011-05-03 17:30:00     17.00            A       21.2
    ## 800   02336526 2011-05-03 03:45:00      4.20            E       22.3
    ## 801   02336728 2011-05-31 19:30:00     13.00            A       26.4
    ## 802   02336360 2011-05-19 00:15:00     10.00            A       16.8
    ## 803   02336410 2011-05-18 02:30:00     16.00            A       15.6
    ## 804   02203655 2011-05-23 04:30:00      7.50          A e       22.8
    ## 805   02336728 2011-05-24 17:15:00      8.90            A       23.9
    ## 806   02336313 2011-05-21 19:15:00        NA          A e       23.6
    ## 807   02336410 2011-05-21 16:45:00     14.00            E       20.7
    ## 808   02336313 2011-05-20 13:30:00      1.00          A e       16.8
    ## 809   02203700 2011-05-19 17:45:00      4.20            A       18.9
    ## 810   02336120 2011-05-21 10:15:00     12.00            A       18.9
    ## 811   02336120 2011-05-25 18:45:00     10.00            A       23.9
    ## 812   02336240 2011-05-09 23:00:00     12.00            X       22.3
    ## 813   02337170 2011-05-22 09:00:00   2520.00            E       16.8
    ## 814   02336410 2011-05-02 16:15:00     21.00            A       20.2
    ## 815  021989773 2011-05-14 02:15:00  90600.00            X       24.3
    ## 816  021989773 2011-05-27 03:15:00  20800.00            X       25.9
    ## 817   02203700 2011-05-11 07:00:00      4.60          A e       21.5
    ## 818  021989773 2011-05-22 17:15:00 -36300.00            E       24.1
    ## 819   02203655 2011-05-06 22:15:00     12.00            A       17.8
    ## 820   02336300 2011-05-15 11:30:00     26.00          A e       19.1
    ## 821   02203655 2011-05-27 03:30:00    148.00            A       21.4
    ## 822   02336526 2011-05-25 08:15:00      3.10            E       22.2
    ## 823   02336360 2011-05-11 07:15:00     12.00            A       22.1
    ## 824   02336360 2011-05-14 20:30:00     11.00          A e       23.3
    ## 825   02203655 2011-05-07 20:30:00     11.00            A       18.2
    ## 826   02203655 2011-05-02 18:30:00     11.00            A       20.3
    ## 827  021989773 2011-05-22 03:30:00 -60600.00            A       24.0
    ## 828   02203700 2011-05-20 00:45:00      4.00          A e       20.4
    ## 829   02336313 2011-05-07 02:30:00      1.10            A       17.8
    ## 830  021989773 2011-05-07 11:15:00 -18500.00            X       22.3
    ## 831   02337170 2011-05-31 22:00:00   1260.00            A       26.1
    ## 832   02337170 2011-05-12 05:45:00   4320.00            A       16.4
    ## 833   02336313 2011-05-31 00:45:00      0.73          A e       25.9
    ## 834   02336410 2011-05-12 14:30:00     17.00            A       21.9
    ## 835   02336313 2011-05-17 04:00:00      1.10          A e       16.4
    ## 836   02336526 2011-05-28 00:15:00     17.00            E       23.3
    ## 837   02336728 2011-05-01 13:45:00     16.00            E       18.4
    ## 838  021989773 2011-05-05 03:30:00        NA            A       23.6
    ## 839   02203700 2011-05-01 15:00:00      6.10          A e       18.5
    ## 840   02336313 2011-05-28 22:30:00      0.82            A       24.8
    ## 841   02336120 2011-05-21 02:45:00     12.00            A       20.8
    ## 842   02336120 2011-05-01 04:15:00     17.00            A       19.4
    ## 843   02336360 2011-05-03 15:30:00     13.00            A       20.3
    ## 844   02336360 2011-05-18 19:30:00     10.00            A       17.6
    ## 845   02336360 2011-05-09 20:15:00     12.00            A       22.7
    ## 846   02336360 2011-05-07 08:15:00     14.00            A       16.3
    ## 847   02336240 2011-05-16 12:00:00        NA          A e       16.5
    ## 848   02336240 2011-05-10 13:15:00     11.00            A       19.6
    ## 849   02203700 2011-05-18 20:45:00      4.00          A e       18.8
    ## 850   02203655 2011-05-03 21:45:00     14.00            A       20.8
    ## 851  021989773 2011-05-04 14:45:00  30800.00            E       23.6
    ## 852  021989773 2011-05-20 20:15:00  61700.00            A       23.8
    ## 853   02336313 2011-05-12 17:00:00      1.00          A e       24.5
    ## 854   02336360 2011-05-23 07:30:00      9.40            E       22.1
    ## 855  021989773 2011-05-05 15:45:00  34300.00            A       23.4
    ## 856   02336300 2011-05-22 04:15:00     24.00            E       22.3
    ## 857   02336360 2011-05-01 05:30:00     14.00            A       19.2
    ## 858   02336313 2011-05-09 06:45:00      1.00            A       19.0
    ## 859   02336240 2011-05-29 23:30:00     13.00            A       24.7
    ## 860  021989773 2011-05-05 02:45:00  -7900.00            A       23.8
    ## 861   02336360 2011-05-30 01:00:00      7.20            A       25.0
    ## 862  021989773 2011-05-30 07:00:00  -7050.00          A e       26.8
    ## 863   02336120 2011-05-16 23:45:00     13.00            A       17.8
    ## 864  021989773 2011-05-16 09:00:00 -68600.00            E       23.8
    ## 865   02336313 2011-05-14 13:30:00      1.00            A       20.4
    ## 866  021989773 2011-05-05 11:00:00 -49500.00            A       22.9
    ## 867   02203700 2011-05-04 03:00:00    132.00            E       18.8
    ## 868   02336728 2011-05-24 06:30:00      8.90          A e       21.6
    ## 869   02336120 2011-05-08 19:15:00     17.00          A e       19.5
    ## 870   02336300 2011-05-07 22:45:00     34.00            A       20.1
    ## 871   02336360 2011-05-27 15:45:00     50.00          A e       21.2
    ## 872   02336360 2011-05-10 02:15:00     12.00            E       21.9
    ## 873   02336240 2011-05-13 00:00:00     11.00          A e       24.2
    ## 874   02336526 2011-05-17 09:45:00      4.00            E       15.6
    ## 875   02336360 2011-05-29 12:45:00      8.10            X       21.8
    ## 876   02336410 2011-05-27 00:30:00     65.00            A       22.9
    ## 877   02203655 2011-05-29 05:15:00     14.00            A       22.9
    ## 878   02203655 2011-05-02 01:30:00     11.00            X       21.1
    ## 879   02203700 2011-05-17 21:45:00      4.40            X       16.8
    ## 880   02336410 2011-05-20 19:30:00     14.00          A e       21.5
    ## 881   02336120 2011-05-09 09:30:00     16.00            X       18.6
    ## 882   02336410 2011-05-19 15:00:00     15.00            A       15.2
    ## 883   02336360 2011-05-21 12:45:00      9.80            E       18.8
    ## 884   02336526 2011-05-24 20:00:00      3.00            A       25.0
    ## 885   02336240 2011-05-21 20:00:00      9.20          A e       24.0
    ## 886   02336120 2011-05-04 10:15:00    168.00            A       16.9
    ## 887   02336120 2011-05-25 20:15:00        NA            X       24.9
    ## 888   02336410 2011-05-19 05:30:00     15.00          A e       15.7
    ## 889   02336526 2011-05-19 00:30:00      3.80            X       17.5
    ## 890  021989773 2011-05-05 04:00:00  53300.00            X       23.6
    ## 891   02203700 2011-05-03 08:00:00      6.10            A       19.5
    ## 892  021989773 2011-05-10 00:45:00   2060.00            A       23.0
    ## 893   02336410 2011-05-16 07:15:00     16.00          A e       17.5
    ## 894   02336360 2011-05-22 16:45:00      9.80            X       22.2
    ## 895   02336300 2011-05-20 08:30:00     27.00            X       17.8
    ## 896  021989773 2011-05-15 17:15:00  50300.00            A       24.4
    ## 897   02336120 2011-05-13 17:45:00     13.00          A e       22.8
    ## 898   02203700 2011-05-12 01:15:00      4.60            A       24.7
    ## 899   02203700 2011-05-02 14:45:00      6.10            A       19.4
    ## 900   02336240 2011-05-30 21:15:00     11.00            E       26.1
    ## 901   02336410 2011-05-06 05:45:00     26.00          A e       16.6
    ## 902   02336526 2011-05-08 11:45:00      4.60            X       16.2
    ## 903   02203700 2011-05-16 05:45:00      4.20            E       17.2
    ## 904   02337170 2011-05-28 20:45:00   2560.00            A       21.7
    ## 905   02336410 2011-05-24 11:45:00     13.00            E       21.6
    ## 906   02336728 2011-05-25 05:15:00      8.60          A e       22.3
    ## 907   02336728 2011-05-27 19:15:00    111.00            X       21.4
    ## 908   02336410 2011-05-26 19:30:00     10.00            A       24.9
    ## 909  021989773 2011-05-11 15:30:00 -45100.00            A       23.4
    ## 910   02203700 2011-05-02 11:00:00      6.10            X       18.3
    ## 911   02336526 2011-05-22 17:15:00      3.60            A       22.4
    ## 912   02336526 2011-05-08 05:00:00      4.60            A       18.8
    ## 913   02336120 2011-05-13 01:15:00     14.00          A e       24.3
    ## 914   02336240 2011-05-14 07:30:00     10.00            A       21.0
    ## 915   02336360 2011-05-28 14:00:00     12.00            E       21.4
    ## 916   02336728 2011-05-20 15:30:00     10.00            X       18.6
    ## 917   02203655 2011-05-31 10:30:00      9.20            E       23.2
    ## 918   02203655 2011-05-28 02:00:00     40.00            A       22.0
    ## 919   02336240 2011-05-24 06:45:00      8.20            X       22.0
    ## 920   02336526 2011-05-10 04:30:00      4.00            X       22.6
    ## 921   02203700 2011-05-11 13:45:00      4.60            X       20.6
    ## 922   02336728 2011-05-01 15:30:00     16.00            E       19.4
    ## 923   02336300 2011-05-23 12:15:00     21.00            A       21.6
    ## 924  021989773 2011-05-04 17:00:00  74300.00            X       23.5
    ## 925   02336120 2011-05-25 05:15:00      9.90          A e       23.5
    ## 926   02336313 2011-05-14 18:45:00      1.00          A e       22.8
    ## 927   02336360 2011-05-31 22:00:00      6.60            X       27.2
    ## 928   02336728 2011-05-20 20:45:00     11.00            X       22.7
    ## 929   02336300 2011-05-21 18:30:00     23.00          A e       23.3
    ## 930  021989773 2011-05-13 10:30:00  -2120.00          A e       23.9
    ## 931   02336360 2011-05-13 22:15:00     11.00            A       23.5
    ## 932   02336300 2011-05-25 07:15:00     20.00            E       23.1
    ## 933   02336728 2011-05-23 14:30:00      8.90            A       21.2
    ## 934   02336526 2011-05-27 07:15:00     68.00          A e       20.4
    ## 935   02336410 2011-05-24 16:30:00     13.00            A       22.9
    ## 936   02336360 2011-05-17 16:30:00     10.00            E       15.9
    ## 937   02336410 2011-05-24 00:30:00     15.00            X       24.0
    ## 938   02336410 2011-05-05 07:00:00        NA            A       16.6
    ## 939   02336360 2011-05-14 05:45:00     11.00          A e       21.9
    ## 940   02336120 2011-05-27 21:45:00     79.00            X       22.7
    ## 941   02336120 2011-05-01 23:30:00     17.00          A e       21.6
    ## 942   02336300 2011-05-07 19:00:00     34.00            E       19.9
    ## 943   02336410 2011-05-27 02:15:00    150.00            X       22.4
    ## 944   02336728 2011-05-15 01:15:00     12.00            E       21.5
    ## 945   02336410 2011-05-13 04:45:00     17.00            E       23.0
    ## 946   02336120 2011-05-07 21:00:00     18.00            X       19.6
    ## 947   02336300 2011-05-23 18:45:00     21.00            A       25.1
    ## 948   02336300 2011-05-19 21:00:00     26.00            A       21.1
    ## 949  021989773 2011-05-09 09:30:00  52000.00            E       22.5
    ## 950   02336360 2011-05-12 09:30:00     11.00            E       21.8
    ## 951   02336526 2011-05-05 16:45:00      5.70            X       15.4
    ## 952   02203655 2011-05-26 01:45:00      6.80            A       23.5
    ## 953   02336313 2011-05-22 23:15:00      0.93          A e       24.7
    ## 954   02203700 2011-05-17 14:45:00      4.90            A       15.3
    ## 955   02336728 2011-05-15 01:45:00     12.00            A       21.2
    ## 956   02336120 2011-05-29 10:00:00     18.00          A e       22.0
    ## 957   02336410 2011-05-15 05:30:00     16.00            A       20.7
    ## 958   02336120 2011-05-09 01:30:00     16.00            A       20.0
    ## 959   02336360 2011-05-07 07:45:00     14.00            E       16.4
    ## 960   02203700 2011-05-08 15:30:00      4.90            A       18.5
    ## 961   02336240 2011-05-11 12:30:00     11.00            A       20.5
    ## 962   02336360 2011-05-21 10:45:00      9.80            A       19.0
    ## 963   02336300 2011-05-21 03:45:00     25.00            E       20.9
    ## 964   02336120 2011-05-04 22:45:00     40.00          A e       18.6
    ## 965   02337170 2011-05-27 00:30:00   1720.00            X       21.4
    ## 966   02336313 2011-05-11 18:45:00      0.98            A       25.4
    ## 967   02336300 2011-05-20 16:00:00     25.00            E       19.0
    ## 968   02336360 2011-05-13 13:45:00     11.00            A       21.1
    ## 969   02336728 2011-05-02 14:15:00     16.00            A       19.9
    ## 970   02336300 2011-05-10 11:45:00     31.00          A e       20.2
    ## 971   02203700 2011-05-25 06:00:00      3.70          A e       22.3
    ## 972   02336240 2011-05-08 20:15:00     12.00            E       20.2
    ## 973   02336526 2011-05-31 10:45:00        NA            A       22.8
    ## 974   02336728 2011-05-22 09:00:00      9.30            A       19.6
    ## 975   02336313 2011-05-14 09:15:00      0.98          A e       20.6
    ## 976   02336728 2011-05-17 14:30:00     12.00            X       15.7
    ## 977   02203655 2011-05-27 15:15:00    201.00            X       19.8
    ## 978  021989773 2011-05-04 15:30:00  56700.00            E       23.6
    ## 979   02336360 2011-05-14 11:15:00        NA          A e       20.9
    ## 980  021989773 2011-05-10 15:30:00 -51900.00            E       23.0
    ## 981   02336300 2011-05-21 10:00:00     25.00            E       19.6
    ## 982   02336120 2011-05-18 19:00:00     13.00            A       16.7
    ## 983  021989773 2011-05-27 21:00:00 -42600.00          A e       26.3
    ## 984   02336240 2011-05-06 17:15:00     14.00            X       17.5
    ## 985   02336120 2011-05-20 20:45:00     13.00          A e       21.4
    ## 986   02336410 2011-05-13 12:15:00     17.00            E       21.4
    ## 987   02336240 2011-05-27 06:45:00    292.00            E       20.9
    ## 988   02336360 2011-05-14 12:45:00     11.00            E       20.8
    ## 989   02336300 2011-05-17 20:30:00     29.00            E       16.7
    ## 990  021989773 2011-05-16 09:45:00 -65800.00            A       23.8
    ## 991  021989773 2011-05-04 16:30:00  79500.00            X       23.6
    ## 992   02336526 2011-05-24 09:00:00      3.10          A e       22.0
    ## 993   02336313 2011-05-02 08:15:00      1.00            A       19.3
    ## 994   02203655 2011-05-27 00:45:00    330.00            A       22.8
    ## 995   02203655 2011-05-30 17:30:00     10.00            A       23.0
    ## 996   02203655 2011-05-18 03:15:00      9.20            E       15.7
    ## 997   02203700 2011-05-12 19:30:00      4.60            A       26.1
    ## 998   02336360 2011-05-26 02:30:00      8.40            A       24.3
    ## 999   02336360 2011-05-19 01:00:00     10.00            X       16.6
    ## 1000 021989773 2011-05-02 12:30:00 -27200.00            A       23.8
    ## 1001  02203700 2011-05-03 00:00:00      6.10            A       22.7
    ## 1002 021989773 2011-05-31 15:00:00  70800.00            X       27.2
    ## 1003  02336410 2011-05-13 18:00:00     16.00            A       23.6
    ## 1004  02336240 2011-05-22 13:15:00      8.90            A       19.7
    ## 1005  02336313 2011-05-22 18:30:00      1.00            A       24.9
    ## 1006  02336120 2011-05-28 06:15:00     41.00            E       21.8
    ## 1007  02336313 2011-05-19 02:15:00      1.00            X       17.0
    ## 1008  02336360 2011-05-26 16:00:00      8.10            A       23.2
    ## 1009  02336120 2011-05-20 05:30:00     12.00            A       18.0
    ## 1010  02336360 2011-05-28 18:00:00     11.00            A       23.9
    ## 1011  02336360 2011-05-23 15:45:00     10.00            A       22.0
    ## 1012  02336410 2011-05-07 07:30:00     23.00            X       16.7
    ## 1013  02336360 2011-05-26 19:00:00      8.40            E       25.2
    ## 1014  02337170 2011-05-27 01:15:00   1710.00            A       21.3
    ## 1015  02336300 2011-05-13 09:15:00     27.00            A       22.0
    ## 1016  02336360 2011-05-08 19:15:00     13.00            X       19.8
    ## 1017  02203655 2011-05-24 10:45:00      7.80            E       21.3
    ## 1018 021989773 2011-05-06 03:45:00 -10200.00            E       23.6
    ## 1019  02336360 2011-05-29 02:15:00      9.10            E       23.9
    ## 1020  02203700 2011-05-14 12:15:00      4.60            X       20.1
    ## 1021  02336360 2011-05-27 12:30:00    170.00            X       20.8
    ## 1022  02203655 2011-05-03 17:00:00     11.00            X       20.6
    ## 1023  02336300 2011-05-07 23:30:00     32.00            A       19.8
    ## 1024  02336410 2011-05-31 12:15:00     12.00            A       23.4
    ## 1025  02336120 2011-05-27 17:45:00    156.00            A       21.2
    ## 1026  02336120 2011-05-21 13:30:00     12.00            X       18.9
    ## 1027  02336728 2011-05-13 09:45:00     12.00            A       20.9
    ## 1028  02336313 2011-05-20 18:15:00      1.00            A       21.6
    ## 1029  02336120 2011-05-14 17:45:00     13.00            E       21.4
    ## 1030  02336240 2011-05-31 05:15:00     11.00          A e       23.7
    ## 1031  02203655 2011-05-29 19:15:00     12.00          A e       22.6
    ## 1032  02336526 2011-05-04 04:15:00    152.00            A       17.1
    ## 1033  02336360 2011-05-20 00:45:00     10.00            A       19.0
    ## 1034  02336728 2011-05-21 23:15:00      9.70            A       23.8
    ## 1035  02336526 2011-05-01 16:45:00      4.40            A       19.1
    ## 1036  02336360 2011-05-05 05:15:00     20.00          A e       17.2
    ## 1037  02336728 2011-05-03 07:00:00        NA            A       19.9
    ## 1038  02203655 2011-05-30 10:00:00     10.00            A       22.8
    ## 1039  02336728 2011-05-03 14:15:00     15.00            A       20.7
    ## 1040  02336120 2011-05-02 07:15:00     16.00            A       19.7
    ## 1041  02336300 2011-05-10 02:30:00     31.00          A e       21.9
    ## 1042 021989773 2011-05-02 18:00:00  50500.00            A       23.8
    ## 1043  02336120 2011-05-15 23:15:00     13.00            A       18.7
    ## 1044 021989773 2011-05-26 08:15:00 -17500.00            E       25.6
    ## 1045  02336313 2011-05-09 16:15:00      1.10            A       21.7
    ## 1046  02336728 2011-05-31 06:30:00     13.00            A       23.2
    ## 1047  02336360 2011-05-25 06:45:00      9.10            X       22.7
    ## 1048  02336410 2011-05-06 10:00:00     26.00            A       15.5
    ## 1049  02203655 2011-05-30 09:15:00     10.00            A       23.1
    ## 1050 021989773 2011-05-26 11:00:00  71700.00          A e       25.3
    ## 1051  02336300 2011-05-01 07:00:00     34.00            A       19.4
    ## 1052  02336313 2011-05-11 02:00:00      0.98            E       23.7
    ## 1053  02336526 2011-05-03 10:15:00      4.00            E       20.1
    ## 1054  02336300 2011-05-25 16:30:00     20.00            E       24.0
    ## 1055 021989773 2011-05-24 20:45:00  39800.00          A e       26.1
    ## 1056  02203700 2011-05-25 05:00:00      3.50            A       22.8
    ## 1057  02336728 2011-05-29 03:15:00     24.00            A       22.0
    ## 1058  02336410 2011-05-06 00:15:00     28.00            A       17.5
    ## 1059  02336240 2011-05-01 21:30:00     13.00            X       21.7
    ## 1060  02203700 2011-05-09 19:30:00      5.10            X       24.3
    ## 1061  02336410 2011-05-23 16:30:00     13.00            X       22.5
    ## 1062  02337170 2011-05-13 04:45:00   4120.00            E       15.4
    ## 1063 021989773 2011-05-25 18:15:00 -62700.00          A e       26.2
    ## 1064  02336240 2011-05-12 09:15:00     11.00            A       21.1
    ## 1065  02336240 2011-05-22 07:15:00      8.50            A       20.3
    ## 1066  02336313 2011-05-09 18:45:00      1.00            E       23.5
    ## 1067  02337170 2011-05-30 14:30:00   1350.00            A       22.6
    ## 1068  02336313 2011-05-23 00:45:00      0.93          A e       24.3
    ## 1069  02336526 2011-05-26 10:30:00      3.00            A       22.7
    ## 1070  02203700 2011-05-13 03:15:00      4.60            X       23.4
    ## 1071  02203655 2011-05-30 11:30:00     10.00            A       22.5
    ## 1072 021989773 2011-05-26 20:00:00 -48100.00            A       26.6
    ## 1073  02336410 2011-05-02 13:30:00     21.00            X       19.4
    ## 1074  02203655 2011-05-01 05:15:00     12.00            E       19.6
    ## 1075  02336313 2011-05-11 11:00:00      1.00          A e       20.3
    ## 1076  02336360 2011-05-25 13:15:00      8.70            X       21.4
    ## 1077  02203700 2011-05-09 16:45:00      5.10            A       21.7
    ## 1078  02336300 2011-05-19 22:00:00     24.00            A       21.1
    ## 1079  02203700 2011-05-22 05:30:00      3.90            X       21.5
    ## 1080  02336526 2011-05-13 11:00:00      3.60          A e       21.1
    ## 1081  02336360 2011-05-05 23:45:00     15.00            A       17.8
    ## 1082  02336300 2011-05-14 08:00:00     27.00            A       21.6
    ## 1083  02337170 2011-05-31 05:30:00   1270.00            X       24.9
    ## 1084  02203655 2011-05-04 23:30:00     20.00          A e       19.0
    ## 1085  02203655 2011-05-20 19:30:00      8.80            E       19.6
    ## 1086  02203655 2011-05-27 06:45:00     86.00            A       20.9
    ## 1087  02337170 2011-05-25 05:15:00   2230.00            A       21.0
    ## 1088  02336120 2011-05-03 10:15:00     16.00            A       19.8
    ## 1089  02336728 2011-05-27 13:00:00    523.00          A e       19.7
    ## 1090  02336300 2011-05-22 18:30:00     23.00            X       25.0
    ## 1091  02336526 2011-05-31 05:00:00      6.90            A       25.0
    ## 1092  02336120 2011-05-04 23:00:00     39.00            A       18.5
    ## 1093  02203700 2011-05-12 09:00:00      4.40            E       20.9
    ## 1094  02336240 2011-05-02 18:00:00     13.00            A       21.8
    ## 1095  02336410 2011-05-04 13:45:00     95.00            A       16.7
    ## 1096  02336728 2011-05-25 18:45:00      9.70            A       25.1
    ## 1097  02336410 2011-05-17 08:30:00     16.00            X       16.2
    ## 1098  02336410 2011-05-01 19:15:00     22.00            E       21.4
    ## 1099  02336300 2011-05-25 13:45:00     20.00          A e       22.2
    ## 1100 021989773 2011-05-14 21:00:00 -81900.00            A       24.3
    ## 1101  02336120 2011-05-14 17:15:00     13.00          A e       21.3
    ## 1102  02203700 2011-05-27 02:30:00     64.00            A       21.9
    ## 1103  02336300 2011-05-10 03:45:00     31.00            A       21.6
    ## 1104  02336728 2011-05-22 13:30:00      9.30            E       19.8
    ## 1105  02336526 2011-05-02 20:45:00      4.20            E       23.1
    ## 1106  02203655 2011-05-31 15:30:00      9.60            A       22.6
    ## 1107  02336410 2011-05-26 20:45:00     10.00            X       25.2
    ## 1108  02336120 2011-05-06 15:30:00     19.00            A       15.3
    ## 1109  02336120 2011-05-30 01:15:00     16.00            E       25.4
    ## 1110  02336728 2011-05-19 23:15:00     11.00            X       19.6
    ## 1111  02337170 2011-05-08 18:30:00   1430.00            A       17.0
    ## 1112 021989773 2011-05-19 09:30:00  35000.00            A       23.0
    ## 1113  02336410 2011-05-01 09:15:00     22.00            X       18.7
    ## 1114  02336300 2011-05-09 15:00:00     32.00            A       19.7
    ## 1115  02336120 2011-05-09 02:30:00     16.00            A       19.8
    ## 1116  02336240 2011-05-23 21:15:00      8.50            A       24.9
    ## 1117  02337170 2011-05-09 18:15:00   1350.00            A       19.4
    ## 1118  02336120 2011-06-01 02:45:00     12.00            A       25.9
    ## 1119  02336120 2011-05-16 19:45:00     13.00          A e       17.8
    ## 1120  02336313 2011-05-29 06:00:00      0.82            A       22.1
    ## 1121  02336300 2011-05-18 19:15:00     27.00            A       17.9
    ## 1122  02336410 2011-05-10 10:30:00     19.00            A       20.6
    ## 1123  02336120 2011-05-12 03:30:00     14.00            A       23.4
    ## 1124  02203655 2011-05-18 21:00:00      8.80            E       16.1
    ## 1125  02336526 2011-05-14 14:15:00      3.60            A       20.5
    ## 1126  02336360 2011-05-05 04:15:00     20.00            A       17.6
    ## 1127  02336313 2011-05-13 20:30:00      1.00            A       24.5
    ## 1128  02336410 2011-05-09 17:30:00     20.00            A       21.0
    ## 1129  02336410 2011-05-21 12:30:00     14.00            E       19.0
    ## 1130 021989773 2011-05-19 05:30:00  84500.00            A       23.1
    ## 1131  02336300 2011-05-19 09:15:00     26.00          A e       15.5
    ## 1132  02336526 2011-05-08 20:45:00      4.60            A       21.7
    ## 1133  02336410 2011-05-11 10:30:00     19.00            A       21.7
    ## 1134  02336313 2011-05-16 15:15:00      1.10            A       16.5
    ## 1135  02203655 2011-05-05 21:45:00     13.00            A       17.2
    ## 1136  02336410 2011-05-11 21:15:00     17.00            X       25.0
    ## 1137 021989773 2011-05-30 09:45:00 -46600.00            E       26.7
    ## 1138  02336300 2011-05-03 05:15:00     31.00            A       21.2
    ## 1139  02336526 2011-05-15 12:15:00      3.60          A e       18.8
    ## 1140  02336526 2011-05-10 03:00:00      4.00            X       23.2
    ## 1141  02336526 2011-05-07 16:45:00      4.80            E       16.9
    ## 1142  02336240 2011-05-13 00:45:00     11.00            A       23.9
    ## 1143  02336526 2011-05-23 19:15:00      3.50            A       24.1
    ## 1144  02337170 2011-05-24 08:45:00   1720.00            A       20.1
    ## 1145  02336240 2011-05-05 19:00:00     15.00            E       17.6
    ## 1146  02203700 2011-05-22 04:45:00      3.90            A       21.8
    ## 1147  02336300 2011-05-03 13:30:00     30.00            E       20.0
    ## 1148  02336410 2011-05-29 14:15:00     18.00            A       22.1
    ## 1149  02336410 2011-05-25 23:15:00     11.00            A       25.3
    ## 1150  02337170 2011-05-29 12:15:00   1710.00            A       21.2
    ## 1151  02336410 2011-05-02 00:00:00     22.00            A       21.0
    ## 1152  02336526 2011-05-27 09:00:00   2250.00          A e       19.4
    ## 1153  02337170 2011-06-01 03:45:00   1260.00          A e       26.1
    ## 1154  02336728 2011-05-24 09:30:00      8.90            E       20.8
    ## 1155  02336120 2011-05-08 12:30:00     17.00            A       16.9
    ## 1156  02336410 2011-05-16 13:30:00     15.00            A       16.8
    ## 1157  02336120 2011-05-27 12:30:00    900.00            A       20.4
    ## 1158  02336300 2011-05-12 15:00:00     27.00            X       22.5
    ## 1159  02336240 2011-05-09 07:45:00     12.00            A       18.5
    ## 1160  02336728 2011-05-23 09:30:00      8.90            X       20.5
    ## 1161  02336410 2011-05-13 18:15:00     16.00            A       23.7
    ## 1162 021989773 2011-05-10 04:00:00 -70600.00          A e       22.8
    ## 1163  02203655 2011-05-27 22:15:00     60.00            A       22.4
    ## 1164  02336360 2011-05-01 22:15:00     14.00            A       21.7
    ## 1165 021989773 2011-05-11 20:00:00 -45000.00            X       23.7
    ## 1166  02336300 2011-05-14 19:45:00     27.00          A e       23.5
    ## 1167  02336410 2011-05-31 16:15:00     12.00          A e       24.5
    ## 1168 021989773 2011-05-20 05:45:00  72400.00            E       23.2
    ## 1169  02336728 2011-05-30 02:30:00     17.00            A       23.1
    ## 1170  02336313 2011-05-06 20:00:00      1.20            E       19.6
    ## 1171  02336728 2011-05-23 11:30:00      8.90            E       20.3
    ## 1172  02336410 2011-05-20 22:45:00     14.00            E       21.6
    ## 1173  02336313 2011-05-23 11:30:00      0.93            A       20.2
    ## 1174  02336728 2011-05-05 02:45:00     29.00            A       17.4
    ## 1175  02336313 2011-05-30 23:30:00      0.69            E       26.2
    ## 1176  02336240 2011-05-21 18:45:00      9.20          A e       23.4
    ## 1177 021989773 2011-05-27 01:30:00  39100.00            E       26.2
    ## 1178  02336240 2011-05-24 20:00:00      8.20            A       26.0
    ## 1179  02336360 2011-05-10 01:00:00     12.00            A       22.1
    ## 1180 021989773 2011-05-13 00:45:00  74600.00            X       24.0
    ## 1181  02336526 2011-05-06 21:45:00      5.00            E       19.9
    ## 1182  02336728 2011-05-22 13:00:00      9.30            A       19.6
    ## 1183  02336240 2011-05-11 14:00:00     11.00            A       20.9
    ## 1184  02336120 2011-05-26 02:15:00     11.00            X       24.8
    ## 1185 021989773 2011-05-01 14:15:00  72300.00            X       23.5
    ## 1186  02336240 2011-05-20 13:15:00      9.50            A       16.4
    ## 1187  02336313 2011-05-14 03:30:00      0.93            A       22.4
    ## 1188  02336313 2011-05-20 18:45:00      1.00            E       21.9
    ## 1189 021989773 2011-05-04 00:30:00 -60300.00            E       24.1
    ## 1190  02336728 2011-05-26 04:00:00      8.20          A e       23.1
    ## 1191  02203700 2011-05-14 04:15:00      4.40            A       21.8
    ## 1192 021989773 2011-05-26 09:30:00  13200.00            A       25.5
    ## 1193  02203700 2011-05-09 22:00:00      4.90            A       24.7
    ## 1194  02336526 2011-05-28 05:00:00        NA            A       21.6
    ## 1195  02336120 2011-05-13 20:15:00     13.00            X       23.8
    ## 1196  02336410 2011-05-23 10:45:00     14.00            A       21.6
    ## 1197  02336120 2011-05-03 00:15:00     16.00          A e       21.9
    ## 1198 021989773 2011-05-16 11:45:00 -53600.00            X       24.1
    ## 1199  02336526 2011-05-20 15:00:00      3.60            E       17.3
    ## 1200  02336313 2011-05-22 17:15:00      1.10            A       23.9
    ## 1201  02336313 2011-05-17 15:00:00      1.00            X       15.5
    ## 1202  02336360 2011-05-15 17:30:00     10.00            A       19.4
    ## 1203  02336313 2011-05-31 23:30:00      0.65            A       26.6
    ## 1204  02203655 2011-05-21 11:15:00      8.20            X       18.7
    ## 1205  02336410 2011-05-12 02:45:00     17.00            X       23.6
    ## 1206  02336526 2011-05-12 11:15:00      3.80            A       21.2
    ## 1207  02336313 2011-05-30 17:00:00      0.73            A       25.4
    ## 1208  02336240 2011-05-18 01:15:00        NA            E       15.4
    ## 1209  02337170 2011-05-08 12:00:00   1580.00            A       15.4
    ## 1210  02336410 2011-05-08 01:45:00     22.00            E       18.8
    ## 1211  02336120 2011-05-01 12:00:00     18.00            X       18.1
    ## 1212  02203700 2011-05-12 05:00:00      4.90            X       22.8
    ## 1213  02336240 2011-05-01 20:45:00     13.00          A e       21.9
    ## 1214  02336120 2011-05-06 18:30:00     19.00            A       17.3
    ## 1215  02203700 2011-05-14 21:30:00      4.40            E       23.5
    ## 1216  02336526 2011-05-04 02:45:00    411.00            X       17.8
    ## 1217  02336120 2011-05-06 15:15:00     19.00            X       15.2
    ## 1218  02336120 2011-05-06 09:15:00     19.00            A       15.5
    ## 1219 021989773 2011-05-15 08:00:00 -57800.00          A e       24.0
    ## 1220  02336313 2011-05-13 15:45:00      1.00            A       22.7
    ## 1221  02336410 2011-05-31 21:30:00     11.00            X       27.1
    ## 1222  02336300 2011-05-11 19:30:00     29.00            A       25.6
    ## 1223  02336240 2011-05-22 14:45:00      8.90            A       20.5
    ## 1224  02336120 2011-05-15 09:00:00     13.00            A       19.4
    ## 1225 021989773 2011-05-18 11:30:00 -81000.00            A       23.1
    ## 1226  02336300 2011-05-16 16:00:00     27.00            X       17.0
    ## 1227  02336728 2011-05-29 06:00:00     22.00          A e       21.9
    ## 1228  02203700 2011-05-23 10:00:00      3.90            A       20.5
    ## 1229  02203700 2011-05-15 13:00:00      4.20            X       17.9
    ## 1230  02336240 2011-05-29 17:00:00     14.00            X       23.8
    ## 1231  02336728 2011-05-16 06:30:00     11.00            X       17.1
    ## 1232  02203700 2011-05-25 11:45:00      3.70            X       20.1
    ## 1233  02336728 2011-05-14 00:00:00     12.00            A       22.8
    ## 1234  02203655 2011-05-30 06:15:00     10.00            A       24.0
    ## 1235  02336240 2011-05-15 18:00:00     10.00          A e       19.3
    ## 1236  02336240 2011-05-14 06:30:00     11.00            A       21.2
    ## 1237  02336360 2011-05-18 17:15:00     10.00            X       15.9
    ## 1238  02336410 2011-05-20 20:45:00     14.00            A       21.9
    ## 1239  02336240 2011-05-04 07:15:00    222.00            A       17.1
    ## 1240  02336410 2011-05-04 00:15:00    134.00          A e       19.7
    ## 1241  02336526 2011-05-07 15:30:00      4.80            X       15.8
    ## 1242  02337170 2011-05-17 19:30:00   2910.00          A e       15.3
    ## 1243  02336313 2011-05-20 15:45:00      1.20            A       19.9
    ## 1244  02336526 2011-05-08 01:45:00      4.80            A       20.3
    ## 1245  02203655 2011-05-02 01:15:00     11.00          A e       21.0
    ## 1246  02336300 2011-05-08 22:15:00     31.00            A       21.3
    ## 1247  02203655 2011-05-19 16:15:00      9.20            E       15.7
    ## 1248  02336300 2011-05-20 12:30:00     26.00          A e       17.2
    ## 1249  02336313 2011-05-31 14:15:00      0.77            A       22.9
    ## 1250  02203700 2011-05-02 05:45:00      6.10            X       19.9
    ## 1251  02203700 2011-05-06 01:30:00      5.60            A       18.6
    ## 1252  02336313 2011-05-17 02:00:00      1.20            E       16.9
    ## 1253  02203655 2011-05-01 18:30:00     11.00          A e       19.7
    ## 1254  02336728 2011-05-02 18:00:00     16.00            E       22.0
    ## 1255  02336120 2011-05-06 20:30:00     19.00            A       18.6
    ## 1256  02203655 2011-05-02 14:00:00     11.00            E       18.6
    ## 1257 021989773 2011-05-02 22:15:00 -82200.00            A       24.1
    ## 1258 021989773 2011-05-26 11:45:00  72800.00            E       25.3
    ## 1259  02336526 2011-05-02 01:30:00      4.20          A e       22.5
    ## 1260  02336360 2011-05-17 08:00:00     11.00            A       16.1
    ## 1261  02203700 2011-05-13 20:30:00      4.40            A       25.0
    ## 1262  02336526 2011-05-31 17:15:00      4.60            A       24.7
    ## 1263  02336300 2011-05-09 02:00:00     32.00            A       20.3
    ## 1264 021989773 2011-05-10 14:00:00 -19700.00            A       22.9
    ## 1265  02336526 2011-05-16 16:45:00      3.80            E       16.7
    ## 1266  02336300 2011-05-20 10:45:00     26.00            E       17.4
    ## 1267  02336360 2011-05-01 13:45:00     14.00            E       17.8
    ## 1268  02336360 2011-05-19 03:30:00     10.00            A       16.1
    ## 1269  02336360 2011-05-29 02:45:00      9.10          A e       23.8
    ## 1270  02336300 2011-05-15 16:15:00     26.00            X       19.4
    ## 1271  02336526 2011-05-27 21:30:00     21.00            X       23.6
    ## 1272  02336120 2011-05-16 21:00:00     13.00            A       17.8
    ## 1273  02336300 2011-05-01 19:15:00     32.00            A       22.3
    ## 1274  02336728 2011-05-24 19:00:00        NA            X       24.8
    ## 1275  02336526 2011-05-05 20:30:00      5.50            E       18.5
    ## 1276  02336410 2011-05-01 21:45:00        NA            A       21.4
    ## 1277  02336526 2011-05-21 10:00:00      3.50          A e       19.5
    ## 1278  02336526 2011-05-02 22:30:00      4.20            A       23.6
    ## 1279  02336360 2011-05-09 13:45:00     12.00            A       18.4
    ## 1280  02203655 2011-05-26 06:30:00      6.80          A e       23.2
    ## 1281  02336410 2011-05-13 21:00:00     16.00          A e       24.0
    ## 1282  02336240 2011-05-29 18:45:00     14.00            A       25.3
    ## 1283  02336728 2011-05-03 03:30:00     15.00            A       20.3
    ## 1284  02336313 2011-05-21 23:30:00      0.93            A       23.4
    ## 1285  02336313 2011-05-18 21:30:00      1.00            A       18.3
    ## 1286  02203700 2011-05-23 15:00:00      3.70            A       21.3
    ## 1287  02336120 2011-05-29 00:15:00     23.00            A       24.4
    ## 1288 021989773 2011-05-25 19:00:00 -49000.00            A       25.7
    ## 1289 021989773 2011-05-15 01:45:00  92100.00            X       24.2
    ## 1290  02336410 2011-05-19 07:30:00     16.00            A       15.4
    ## 1291  02336313 2011-05-11 23:15:00      0.93            A       25.0
    ## 1292 021989773 2011-05-23 12:45:00  10700.00          A e       24.4
    ## 1293  02336240 2011-05-01 23:15:00     13.00            A       21.1
    ## 1294  02336360 2011-05-15 10:00:00     11.00          A e       19.5
    ## 1295  02336300 2011-05-08 12:30:00     33.00            A       16.8
    ## 1296  02336120 2011-05-08 01:15:00     17.00            X       19.1
    ## 1297  02337170 2011-05-15 16:30:00   2200.00            A       15.6
    ## 1298  02336360 2011-05-10 01:15:00     12.00            A       22.0
    ## 1299  02203700 2011-05-15 02:45:00      4.40            A       21.2
    ## 1300  02203700 2011-05-19 16:15:00      4.00            X       17.1
    ## 1301 021989773 2011-05-13 19:30:00 -81000.00          A e       24.7
    ## 1302  02337170 2011-05-30 23:45:00   1270.00          A e       25.6
    ## 1303  02336526 2011-05-20 18:45:00      3.60            A       20.6
    ## 1304  02336526 2011-05-21 10:30:00      3.50            A       19.4
    ## 1305  02337170 2011-05-10 01:00:00   1350.00            A       21.6
    ## 1306  02203700 2011-05-11 05:30:00      4.90            E       22.2
    ## 1307  02336300 2011-05-03 11:45:00     31.00            A       20.0
    ## 1308  02336526 2011-05-29 16:30:00      5.90          A e       22.4
    ## 1309  02336410 2011-05-27 13:30:00    288.00            A       21.4
    ## 1310  02336410 2011-05-11 15:15:00     17.00            A       21.9
    ## 1311  02337170 2011-05-08 17:00:00   1440.00            X       16.4
    ## 1312  02336526 2011-05-04 02:15:00    427.00          A e       18.4
    ## 1313  02336360 2011-05-06 18:30:00     14.00            E       18.1
    ## 1314  02336120 2011-05-19 23:00:00     12.00            A       19.8
    ## 1315  02336240 2011-05-22 02:45:00        NA            X       21.6
    ## 1316  02203700 2011-05-22 07:45:00      3.90            A       20.6
    ## 1317 021989773 2011-05-08 00:30:00 -65600.00            A       22.7
    ## 1318  02336728 2011-05-01 11:15:00     16.00            E       18.3
    ## 1319  02203655 2011-05-26 07:15:00      6.80            A       23.1
    ## 1320  02336313 2011-05-07 19:15:00      1.00            E       20.6
    ## 1321  02336240 2011-05-22 17:45:00      9.20            E       24.0
    ## 1322  02336728 2011-05-13 06:30:00     12.00          A e       21.4
    ## 1323  02336313 2011-05-23 07:45:00      0.87            A       21.4
    ## 1324  02336313 2011-05-28 14:30:00      0.93            A       20.2
    ## 1325  02336240 2011-05-16 00:00:00     10.00            E       18.2
    ## 1326  02336728 2011-05-20 23:30:00     11.00          A e       22.3
    ## 1327  02336240 2011-05-03 01:15:00     13.00            A       21.0
    ## 1328  02336120 2011-05-05 03:30:00     32.00            A       17.0
    ## 1329  02337170 2011-05-10 02:45:00   1340.00          A e       21.6
    ## 1330  02336728 2011-05-25 21:45:00      9.30            A       26.0
    ## 1331  02336360 2011-05-07 21:45:00     13.00            E       19.7
    ## 1332  02336120 2011-05-26 14:15:00      8.90            X       22.5
    ## 1333  02336313 2011-05-23 01:15:00      0.87          A e       24.1
    ## 1334  02336240 2011-05-22 10:45:00      8.90            X       19.6
    ## 1335  02336526 2011-05-17 14:15:00      3.80            A       15.1
    ## 1336  02336728 2011-05-24 20:00:00      8.90            A       25.3
    ## 1337  02336526 2011-05-07 00:15:00      4.80          A e       19.9
    ## 1338  02336360 2011-05-30 07:30:00      6.90            X       23.8
    ## 1339  02336360 2011-05-02 01:45:00     14.00            A       20.9
    ## 1340  02203700 2011-05-03 21:15:00      6.70            X       22.2
    ## 1341  02336120 2011-05-11 06:00:00     15.00            X       22.0
    ## 1342  02336300 2011-05-14 04:00:00     27.00            A       22.4
    ## 1343  02336410 2011-05-04 01:45:00    176.00            A       19.2
    ## 1344  02336240 2011-05-30 03:00:00     12.00            A       23.6
    ## 1345  02336410 2011-05-04 20:00:00     59.00            A       18.7
    ## 1346  02336120 2011-05-18 04:15:00     14.00            X       15.3
    ## 1347  02203700 2011-05-02 19:00:00      6.10            A       23.2
    ## 1348  02336360 2011-05-29 15:30:00        NA          A e       22.6
    ## 1349  02336360 2011-05-18 20:30:00     10.00            A       17.7
    ## 1350  02336300 2011-05-20 20:00:00     24.00            X       22.8
    ## 1351 021989773 2011-05-10 22:30:00  48300.00            A       23.6
    ## 1352  02203700 2011-05-08 12:00:00      4.90            X       16.0
    ## 1353 021989773 2011-05-19 12:30:00 -72500.00            E       23.0
    ## 1354  02336120 2011-05-29 17:00:00        NA            A       23.1
    ## 1355  02336300 2011-05-16 20:15:00     29.00          A e       18.8
    ## 1356  02336300 2011-05-20 06:15:00     26.00            A       18.2
    ## 1357  02336120 2011-05-03 09:45:00     16.00            A       19.9
    ## 1358  02203655 2011-05-22 20:15:00      8.20          A e       22.5
    ## 1359 021989773 2011-05-17 12:00:00 -56100.00            A       23.5
    ## 1360  02336360 2011-05-17 04:45:00     11.00          A e       16.5
    ## 1361  02336120 2011-05-29 04:00:00     21.00          A e       23.1
    ## 1362  02336360 2011-05-28 06:15:00     15.00            A       22.2
    ## 1363  02336120 2011-05-31 22:15:00     12.00            A       27.2
    ## 1364  02336240 2011-05-30 11:30:00     12.00            A       22.2
    ## 1365  02336526 2011-05-02 10:30:00      4.20            X       19.3
    ## 1366 021989773 2011-05-05 09:30:00  -4820.00            A       22.9
    ## 1367  02336300 2011-05-17 17:45:00     29.00          A e       16.6
    ## 1368 021989773 2011-05-22 06:00:00   7220.00            X       24.1
    ## 1369  02336526 2011-05-10 15:45:00      4.20            X       20.7
    ## 1370  02203655 2011-05-07 04:00:00     12.00            A       17.9
    ## 1371 021989773 2011-05-23 21:00:00  77100.00            A       25.8
    ## 1372  02337170 2011-05-29 00:30:00   2580.00          A e       21.7
    ## 1373  02203655 2011-05-22 21:15:00      8.20          A e       22.6
    ## 1374  02336120 2011-05-19 14:45:00     12.00            A       15.4
    ## 1375  02336360 2011-05-08 17:30:00     13.00          A e       18.8
    ## 1376  02336240 2011-05-27 06:00:00    247.00            E       21.1
    ## 1377  02203700 2011-05-05 14:30:00     21.00            A       16.9
    ## 1378  02336526 2011-05-20 18:00:00      3.60            E       19.8
    ## 1379  02336313 2011-05-13 07:45:00      0.98            X       21.4
    ## 1380  02336360 2011-05-22 20:00:00      9.80            E       25.3
    ## 1381  02203700 2011-05-17 15:45:00      4.90            A       15.7
    ## 1382  02336526 2011-05-30 06:45:00      5.90            E       24.1
    ## 1383  02203700 2011-05-22 09:15:00        NA          A e       20.0
    ## 1384  02336300 2011-05-20 22:00:00     25.00          A e       23.4
    ## 1385  02336300 2011-05-14 17:00:00     26.00            A       21.8
    ## 1386  02336410 2011-05-02 07:45:00        NA            A       20.2
    ## 1387 021989773 2011-05-10 23:30:00  58700.00            A       23.3
    ## 1388  02337170 2011-05-13 20:15:00   6100.00            X       16.8
    ## 1389  02336120 2011-05-23 22:15:00     11.00            A       24.8
    ## 1390  02336240 2011-05-10 04:45:00     11.00            A       20.5
    ## 1391  02336240 2011-05-23 05:15:00      8.20            E       22.1
    ## 1392  02336526 2011-05-12 12:15:00      3.80            A       21.0
    ## 1393  02336360 2011-05-24 03:15:00      9.40            A       23.1
    ## 1394  02336240 2011-05-27 05:00:00        NA            X       21.5
    ## 1395  02337170 2011-05-31 09:15:00   1270.00            A       24.4
    ## 1396  02336360 2011-05-06 01:30:00     15.00            A       17.4
    ## 1397  02336300 2011-05-16 18:15:00     25.00            A       17.6
    ## 1398  02336360 2011-05-04 22:15:00     24.00            E       19.3
    ## 1399  02337170 2011-05-24 08:00:00   1710.00            E       20.1
    ## 1400  02336300 2011-05-24 12:45:00     21.00            A       21.9
    ## 1401  02336313 2011-05-24 09:30:00      0.93            A       21.1
    ## 1402  02337170 2011-05-16 12:30:00   1400.00            A       16.1
    ## 1403  02336728 2011-05-03 23:30:00     62.00            A       20.0
    ## 1404  02337170 2011-05-27 05:30:00   2070.00            A       20.6
    ## 1405  02336120 2011-05-15 20:15:00     13.00            X       19.1
    ## 1406  02336120 2011-05-14 07:30:00     13.00            A       21.4
    ## 1407  02336526 2011-05-27 22:15:00     19.00            A       23.6
    ## 1408  02336410 2011-05-24 08:45:00        NA            A       22.2
    ## 1409  02336313 2011-05-12 09:45:00      1.00            E       20.9
    ## 1410  02336526 2011-05-08 19:45:00      4.60            E       21.3
    ## 1411  02336410 2011-05-03 03:30:00     21.00          A e       21.4
    ## 1412  02336313 2011-05-24 04:15:00      0.87            X       22.9
    ## 1413  02336313 2011-05-28 10:45:00      0.98            E       19.9
    ## 1414  02203700 2011-05-09 00:00:00      5.10          A e       21.8
    ## 1415  02336120 2011-05-07 23:45:00     17.00            E       19.5
    ## 1416  02336120 2011-05-31 13:30:00     12.00            A       23.3
    ## 1417  02336120 2011-05-30 17:15:00     14.00            A       24.4
    ## 1418 021989773 2011-05-31 13:30:00  29000.00            A       27.1
    ## 1419  02203700 2011-05-17 20:15:00      4.60          A e       17.0
    ## 1420  02336313 2011-05-01 19:45:00      1.00            A       22.6
    ## 1421  02336313 2011-05-01 23:45:00      1.00            A       22.3
    ## 1422  02336300 2011-05-22 20:45:00     22.00          A e       26.5
    ## 1423  02336526 2011-05-17 19:00:00      3.80            A       16.5
    ## 1424  02336360 2011-05-17 12:45:00        NA            A       15.2
    ## 1425  02336240 2011-05-08 07:15:00     12.00            A       16.9
    ## 1426  02336360 2011-05-02 23:45:00     14.00            X       22.0
    ## 1427  02336300 2011-05-01 14:45:00     33.00            X       18.7
    ## 1428  02203700 2011-05-16 02:00:00      4.40            E       17.9
    ## 1429  02336120 2011-05-19 02:15:00     13.00            A       16.9
    ## 1430  02336313 2011-05-08 06:15:00      1.10            X       17.3
    ## 1431  02336313 2011-05-20 23:30:00      0.98            A       22.2
    ## 1432  02203655 2011-05-23 23:45:00      8.50            A       23.0
    ## 1433  02336410 2011-05-21 20:30:00     14.00          A e       23.5
    ## 1434  02336300 2011-05-15 13:30:00     26.00            A       19.0
    ## 1435  02336313 2011-05-19 15:00:00      1.00            A       16.6
    ## 1436 021989773 2011-05-04 08:15:00  28600.00            A       23.5
    ## 1437 021989773 2011-05-28 20:30:00 -69500.00          A e       26.6
    ## 1438  02336120 2011-05-10 22:30:00     16.00          A e       24.1
    ## 1439  02336410 2011-05-14 05:30:00     16.00            A       22.0
    ## 1440  02203655 2011-05-21 04:00:00      8.20            A       20.5
    ## 1441  02203700 2011-05-03 16:45:00      6.10            A       22.1
    ## 1442  02336360 2011-05-11 09:00:00     12.00            E       21.7
    ## 1443  02336526 2011-05-04 10:30:00     23.00            A       15.4
    ## 1444  02336728 2011-05-23 14:15:00      8.90            E       21.0
    ## 1445 021989773 2011-05-23 08:00:00  72900.00            A       24.5
    ## 1446  02337170 2011-05-20 18:30:00   2770.00            A       16.3
    ## 1447  02203655 2011-05-25 13:00:00      7.20            A       20.9
    ## 1448  02336120 2011-05-20 23:30:00     12.00            X       21.8
    ## 1449  02336120 2011-05-25 17:30:00     10.00            A       23.1
    ## 1450  02336728 2011-05-22 23:00:00      9.70            A       25.3
    ## 1451  02336526 2011-05-08 03:30:00      4.80            A       19.5
    ## 1452  02336300 2011-05-01 11:30:00     32.00            A       18.1
    ## 1453  02336526 2011-05-23 06:45:00      3.80            A       22.8
    ## 1454  02336526 2011-05-29 02:30:00      6.90            A       24.2
    ## 1455 021989773 2011-05-30 13:45:00        NA            A       26.8
    ## 1456  02336120 2011-05-15 00:00:00     13.00          A e       22.3
    ## 1457 021989773 2011-05-09 19:45:00  56500.00            E       23.5
    ## 1458  02336120 2011-05-25 17:00:00     11.00            A       22.8
    ## 1459  02336410 2011-05-10 06:00:00     19.00            X       21.2
    ## 1460  02336240 2011-05-29 10:15:00     14.00            X       21.0
    ## 1461  02337170 2011-05-30 00:00:00   1450.00            A       24.0
    ## 1462  02336728 2011-05-20 12:45:00     10.00            E       16.5
    ## 1463  02336240 2011-05-24 05:45:00      8.20            A       22.2
    ## 1464  02336526 2011-05-16 01:45:00      3.80            A       18.3
    ## 1465  02336728 2011-05-03 17:45:00     16.00          A e       22.8
    ## 1466  02336360 2011-05-05 10:30:00     18.00            E       15.4
    ## 1467  02336300 2011-05-10 19:15:00     31.00            X       24.5
    ## 1468  02336728 2011-05-30 14:45:00     15.00            E       23.6
    ## 1469 021989773 2011-06-01 00:30:00 -28200.00            A       27.7
    ## 1470  02203655 2011-05-30 04:00:00     10.00            E       24.4
    ## 1471  02336120 2011-05-14 19:00:00        NA            A       21.9
    ## 1472  02336526 2011-05-02 05:45:00      4.00            A       20.9
    ## 1473  02336360 2011-05-29 18:45:00      8.10            A       25.2
    ## 1474  02336313 2011-05-09 18:30:00      1.00          A e       23.3
    ## 1475  02336300 2011-05-08 10:45:00     32.00            X       17.0
    ## 1476  02336120 2011-05-28 09:45:00        NA            A       21.3
    ## 1477  02336313 2011-05-28 06:15:00      1.10            A       20.9
    ## 1478 021989773 2011-05-25 14:30:00  -4490.00            A       25.5
    ## 1479  02336120 2011-05-04 15:30:00     69.00            A       16.7
    ## 1480  02336120 2011-05-31 07:45:00     12.00          A e       23.9
    ## 1481  02336240 2011-05-16 21:15:00     10.00            A       17.7
    ## 1482  02336120 2011-05-25 16:15:00     11.00            X       22.5
    ## 1483  02336360 2011-05-08 06:15:00     13.00            E       17.8
    ## 1484  02203655 2011-05-17 12:15:00      9.60            X       15.5
    ## 1485  02336360 2011-05-22 02:45:00      9.80            A       22.1
    ## 1486  02336240 2011-05-14 23:00:00     10.00            E       22.1
    ## 1487  02336313 2011-05-09 14:45:00      1.00            A       19.9
    ## 1488  02336410 2011-05-16 21:30:00     16.00            A       18.2
    ## 1489  02336526 2011-05-27 18:00:00     30.00            A       21.6
    ## 1490  02336360 2011-05-30 06:45:00      7.50            A       23.9
    ## 1491  02336728 2011-05-13 14:15:00     12.00            A       21.6
    ## 1492  02336120 2011-05-23 19:45:00     11.00            A       24.0
    ## 1493  02336313 2011-05-17 08:00:00        NA            E       15.4
    ## 1494  02203700 2011-05-06 21:15:00      5.30            E       21.3
    ## 1495  02336240 2011-05-03 13:00:00     12.00            X       19.3
    ## 1496  02336526 2011-05-24 23:15:00      3.30            A       25.4
    ## 1497  02336360 2011-05-13 15:30:00     11.00            E       21.7
    ## 1498  02336313 2011-05-06 06:00:00      1.20          A e       15.4
    ## 1499  02203700 2011-05-26 17:00:00      3.70            A       23.7
    ## 1500  02336360 2011-05-23 02:00:00      9.80            E       23.6
    ## 1501  02336410 2011-05-07 06:15:00     23.00            A       17.0
    ## 1502  02336526 2011-05-14 08:45:00        NA            E       21.4
    ## 1503  02336526 2011-05-03 04:30:00      4.20            E       22.0
    ## 1504  02336360 2011-05-25 20:15:00      8.40            A       26.1
    ## 1505  02336300 2011-05-16 19:15:00     29.00            X       18.5
    ## 1506  02336240 2011-05-02 10:15:00     13.00            E       18.8
    ## 1507  02337170 2011-05-27 01:00:00   1710.00          A e       21.3
    ## 1508  02337170 2011-05-31 22:15:00   1260.00            E       26.1
    ## 1509  02336120 2011-05-26 21:45:00     98.00            A       24.8
    ## 1510  02336410 2011-05-05 09:30:00     36.00            E       15.8
    ## 1511  02337170 2011-05-10 21:45:00   4300.00            A       20.9
    ## 1512  02336240 2011-05-31 23:30:00     10.00            A       25.8
    ## 1513  02336360 2011-05-27 03:15:00    265.00            A       22.4
    ## 1514  02336313 2011-05-01 15:30:00      1.00          A e       19.7
    ## 1515  02336360 2011-05-11 05:00:00     12.00          A e       22.6
    ## 1516  02336410 2011-05-03 08:00:00     21.00            X       20.7
    ## 1517  02336526 2011-05-04 21:30:00      8.60            A       20.2
    ## 1518  02336360 2011-05-21 09:15:00      9.80            A       19.3
    ## 1519  02336410 2011-05-15 02:00:00     16.00            X       21.5
    ## 1520  02203655 2011-05-04 14:00:00     39.00            E       15.9
    ## 1521  02336410 2011-05-25 03:45:00     12.00            X       23.4
    ## 1522  02336240 2011-05-18 16:45:00     11.00            X       16.3
    ## 1523  02336728 2011-05-03 07:30:00     15.00            A       19.9
    ## 1524  02336120 2011-05-17 04:45:00     13.00            E       16.7
    ## 1525 021989773 2011-05-11 15:45:00 -53700.00            E       23.4
    ## 1526  02336300 2011-05-10 00:15:00     33.00            X       22.8
    ## 1527  02336526 2011-05-05 06:00:00      6.40            A       15.8
    ## 1528  02336410 2011-05-20 10:30:00     15.00          A e       17.2
    ## 1529 021989773 2011-05-28 17:15:00  -9530.00            X       26.8
    ## 1530  02336300 2011-05-22 00:30:00     24.00            X       23.9
    ## 1531  02337170 2011-05-15 10:30:00   2490.00            A       15.0
    ## 1532 021989773 2011-05-05 13:15:00 -47600.00            X       23.4
    ## 1533  02336120 2011-05-16 06:45:00     13.00            A       17.4
    ## 1534  02336360 2011-05-17 11:00:00     11.00            E       15.5
    ## 1535 021989773 2011-05-16 20:00:00 -21600.00            E       23.9
    ## 1536  02336526 2011-05-08 09:45:00      4.60            A       16.8
    ## 1537  02336120 2011-05-26 19:15:00      8.90            E       24.2
    ## 1538 021989773 2011-05-14 20:15:00 -90800.00            A       24.2
    ## 1539  02336410 2011-05-12 10:15:00     17.00            E       22.0
    ## 1540  02336300 2011-05-19 13:00:00     26.00            A       15.2
    ## 1541  02336313 2011-05-15 08:15:00        NA          A e       19.0
    ## 1542  02336120 2011-05-17 04:15:00     13.00            A       16.8
    ## 1543  02203655 2011-05-20 01:30:00      8.80            A       18.4
    ## 1544  02337170 2011-05-22 17:45:00   1550.00          A e       17.7
    ## 1545  02203655 2011-05-21 17:30:00      8.50            A       20.2
    ## 1546  02203700 2011-05-10 23:30:00      4.60            A       25.2
    ## 1547  02203700 2011-05-12 15:00:00      5.10          A e       21.7
    ## 1548  02336360 2011-05-17 19:15:00     10.00            A       16.5
    ## 1549 021989773 2011-05-20 01:30:00 -65200.00            E       23.4
    ## 1550 021989773 2011-05-26 06:15:00 -61100.00            E       25.4
    ## 1551  02337170 2011-05-02 12:45:00   2790.00          A e       15.6
    ## 1552  02336313 2011-05-08 11:45:00      1.10            X       15.9
    ## 1553  02203655 2011-05-23 11:00:00      7.20            A       21.0
    ## 1554  02336728 2011-05-26 01:30:00      8.60            E       24.5
    ## 1555  02336313 2011-05-21 13:00:00      1.00            E       18.1
    ## 1556  02336240 2011-05-20 17:00:00      9.20          A e       19.8
    ## 1557  02336410 2011-05-11 13:00:00     18.00            X       21.4
    ## 1558  02203655 2011-05-26 11:15:00      6.80          A e       22.2
    ## 1559  02337170 2011-05-13 22:00:00   6390.00            X       15.7
    ## 1560  02336410 2011-05-11 18:15:00     17.00            A       24.2
    ## 1561  02336313 2011-05-22 16:45:00      1.10            A       23.5
    ## 1562  02336526 2011-05-14 02:00:00      3.60            X       23.3
    ## 1563 021989773 2011-05-04 09:30:00  -2060.00            A       23.3
    ## 1564  02336240 2011-05-15 16:30:00      9.90            A       19.2
    ## 1565  02203700 2011-05-04 02:00:00     67.00            A       19.9
    ## 1566  02336300 2011-05-11 23:45:00     29.00            E       25.2
    ## 1567 021989773 2011-05-18 20:00:00  42300.00            E       23.6
    ## 1568  02203700 2011-05-01 13:15:00      6.10            E       17.1
    ## 1569  02336410 2011-05-14 20:30:00     16.00            A       22.8
    ## 1570  02336410 2011-05-06 14:00:00     25.00            X       15.1
    ## 1571  02336120 2011-05-24 07:00:00     10.00            E       22.5
    ## 1572  02336300 2011-05-11 03:15:00     31.00            A       23.2
    ## 1573  02203655 2011-05-26 05:15:00      6.80            A       23.3
    ## 1574  02203655 2011-05-17 20:45:00      9.20            E       15.9
    ## 1575  02336410 2011-05-05 22:00:00     28.00            A       17.4
    ## 1576  02336526 2011-05-24 01:15:00      3.30            X       24.6
    ## 1577  02336313 2011-05-31 15:00:00      0.73            X       23.7
    ## 1578  02336313 2011-05-07 05:45:00      1.10            A       16.2
    ## 1579  02336120 2011-05-29 23:30:00     16.00          A e       25.8
    ## 1580  02203700 2011-05-05 23:15:00      5.60            A       19.8
    ## 1581  02336300 2011-05-13 02:00:00     28.00            X       24.3
    ## 1582  02203655 2011-05-31 00:45:00      9.20            E       24.7
    ## 1583  02336526 2011-05-24 20:15:00      3.00          A e       25.1
    ## 1584  02336410 2011-05-21 09:00:00     14.00            A       19.5
    ## 1585  02203700 2011-05-15 04:30:00      4.20            A       20.6
    ## 1586 021989773 2011-05-11 19:00:00 -59300.00            X       23.4
    ## 1587  02336410 2011-05-08 16:30:00     21.00            A       18.4
    ## 1588  02336410 2011-05-14 09:00:00     16.00            E       21.4
    ## 1589  02337170 2011-05-29 08:30:00   1940.00            X       21.4
    ## 1590  02336360 2011-05-22 22:00:00      9.80            X       25.2
    ## 1591  02336360 2011-05-23 03:15:00      9.80            A       23.2
    ## 1592  02337170 2011-05-13 15:15:00   2840.00            A       16.5
    ## 1593  02337170 2011-05-15 10:45:00   2460.00            A       15.0
    ## 1594  02336300 2011-05-01 21:00:00     32.00            A       22.8
    ## 1595  02336300 2011-05-09 10:15:00     31.00            A       18.9
    ## 1596  02336410 2011-05-31 14:30:00     12.00            E       23.7
    ## 1597  02336410 2011-05-03 18:00:00     20.00          A e       22.3
    ## 1598  02203700 2011-05-20 22:15:00      5.80            A       23.5
    ## 1599  02336360 2011-05-27 16:30:00     43.00          A e       21.4
    ## 1600  02336360 2011-05-28 12:00:00     12.00            A       21.2
    ## 1601  02336300 2011-05-10 14:15:00     30.00            A       20.6
    ## 1602  02336300 2011-05-21 05:00:00     25.00          A e       20.6
    ## 1603  02336240 2011-05-11 05:00:00     11.00            X       21.7
    ## 1604  02203700 2011-05-10 12:30:00      4.60            X       19.0
    ## 1605  02336313 2011-05-31 02:45:00        NA            A       25.2
    ## 1606 021989773 2011-05-21 20:00:00  74500.00            X       24.4
    ## 1607  02336360 2011-05-28 07:30:00     14.00            A       21.9
    ## 1608  02336300 2011-05-17 17:15:00     28.00            A       16.6
    ## 1609  02336313 2011-05-24 04:00:00      0.87            X       23.0
    ## 1610  02336300 2011-05-09 16:15:00     32.00            A       20.6
    ## 1611  02203700 2011-05-26 09:45:00      3.70          A e       22.2
    ## 1612  02336313 2011-05-09 01:45:00      0.98          A e       20.8
    ## 1613  02203700 2011-05-14 00:15:00      4.20            E       23.6
    ## 1614  02336526 2011-05-07 03:45:00      4.80            A       18.2
    ## 1615 021989773 2011-05-03 17:15:00  53200.00            A       24.0
    ## 1616  02336120 2011-05-27 10:30:00   1030.00            E       21.0
    ## 1617  02336240 2011-05-21 10:15:00      9.20            A       18.3
    ## 1618 021989773 2011-05-29 21:15:00 -71700.00            E       27.0
    ## 1619  02336300 2011-05-24 23:30:00     20.00            A       26.1
    ## 1620  02336526 2011-05-31 11:30:00      4.80            X       22.6
    ## 1621  02336410 2011-05-20 20:15:00        NA            A       21.8
    ## 1622  02336410 2011-05-05 01:30:00     45.00            E       18.1
    ## 1623  02336728 2011-05-13 11:45:00     12.00          A e       20.9
    ## 1624  02337170 2011-05-26 21:30:00   1710.00            A       21.9
    ## 1625  02336120 2011-05-05 04:00:00     32.00            A       16.8
    ## 1626  02336526 2011-05-15 02:45:00      3.80            E       22.3
    ## 1627  02336360 2011-05-30 00:15:00      7.20            X       25.1
    ## 1628  02203700 2011-05-11 03:00:00      4.90            E       23.5
    ## 1629  02336526 2011-05-30 05:00:00      5.70            A       24.8
    ## 1630  02337170 2011-05-08 06:00:00   2020.00            X       15.4
    ## 1631  02336728 2011-05-22 10:00:00      9.30            X       19.5
    ## 1632  02336410 2011-05-22 12:45:00     14.00            A       20.5
    ## 1633  02336728 2011-05-20 19:15:00     10.00            A       22.1
    ## 1634  02336240 2011-05-02 12:30:00     13.00            E       18.6
    ## 1635  02203655 2011-05-01 08:45:00     12.00            A       18.3
    ## 1636  02336300 2011-05-02 13:15:00     31.00            E       19.3
    ## 1637 021989773 2011-05-26 09:15:00   7340.00            A       25.4
    ## 1638  02336526 2011-05-08 23:00:00      4.60          A e       22.2
    ## 1639 021989773 2011-05-08 09:15:00  61500.00          A e       22.2
    ## 1640 021989773 2011-05-19 13:00:00        NA            A       23.0
    ## 1641  02336240 2011-05-10 18:30:00     11.00            A       24.1
    ## 1642  02336120 2011-05-24 19:15:00     10.00            A       24.0
    ## 1643  02336240 2011-05-02 14:00:00     13.00            A       18.9
    ## 1644  02336728 2011-05-26 06:15:00      8.20            A       22.3
    ## 1645  02336360 2011-05-13 17:00:00     11.00            E       22.7
    ## 1646  02336728 2011-05-19 22:15:00     11.00            E       19.9
    ## 1647  02336526 2011-05-13 03:15:00      3.60            A       24.5
    ## 1648  02336240 2011-05-21 14:30:00      9.20            A       18.9
    ## 1649  02203655 2011-05-23 08:45:00      7.50            A       21.7
    ## 1650  02336120 2011-05-07 09:15:00     17.00            E       16.1
    ## 1651  02336240 2011-05-04 00:00:00        NA            A       19.8
    ## 1652  02336410 2011-05-09 05:30:00     21.00            A       19.7
    ## 1653  02336360 2011-05-23 06:00:00      9.40            X       22.5
    ## 1654  02336360 2011-05-02 12:45:00     14.00            X       19.0
    ## 1655 021989773 2011-05-15 15:15:00  91300.00            X       24.2
    ## 1656 021989773 2011-05-23 00:30:00  -2380.00            A       24.8
    ## 1657  02336410 2011-05-02 23:15:00     21.00            X       21.8
    ## 1658 021989773 2011-05-10 06:30:00 -26400.00            A       23.0
    ## 1659  02336120 2011-05-30 00:30:00     16.00            A       25.5
    ## 1660  02203700 2011-05-25 16:30:00      3.70            A       23.0
    ## 1661  02336120 2011-05-21 11:15:00     12.00            X       18.8
    ## 1662  02203700 2011-05-02 07:45:00      5.80            A       19.4
    ## 1663  02203700 2011-05-03 16:15:00      6.10            E       21.6
    ## 1664  02203700 2011-05-23 22:00:00      3.90          A e       25.5
    ## 1665  02336240 2011-05-10 17:30:00     11.00            A       23.2
    ## 1666  02336240 2011-05-02 23:30:00     13.00          A e       21.6
    ## 1667  02203700 2011-05-08 05:45:00      4.90            X       17.9
    ## 1668  02336240 2011-05-21 21:30:00      9.20            X       23.4
    ## 1669 021989773 2011-05-12 17:30:00 -80000.00            A       23.8
    ## 1670  02336526 2011-05-22 23:45:00      3.50          A e       25.3
    ## 1671  02336526 2011-05-13 07:00:00      3.60            A       22.8
    ## 1672 021989773 2011-05-11 01:15:00  11800.00            X       23.2
    ## 1673  02336240 2011-05-23 11:30:00      8.50            A       20.5
    ## 1674  02336526 2011-05-21 03:45:00      3.60          A e       21.7
    ## 1675  02336410 2011-05-06 01:00:00     28.00            A       17.5
    ## 1676  02203655 2011-05-19 19:45:00      8.80            E       17.5
    ## 1677  02203700 2011-05-08 01:30:00      5.10            A       20.1
    ## 1678  02336410 2011-05-19 06:00:00     15.00            A       15.6
    ## 1679  02336313 2011-05-23 18:45:00      0.98            A       24.8
    ## 1680  02336240 2011-05-30 10:15:00     12.00            A       22.3
    ## 1681  02336313 2011-05-25 00:15:00      0.87          A e       24.6
    ## 1682  02203655 2011-05-17 23:45:00        NA            A       16.0
    ## 1683  02336410 2011-05-17 18:15:00     16.00          A e       16.4
    ## 1684 021989773 2011-06-01 01:15:00        NA            E       27.7
    ## 1685  02336240 2011-05-12 13:30:00     11.00            A       21.0
    ## 1686  02336120 2011-05-09 07:15:00     16.00            A       18.9
    ## 1687  02336526 2011-05-29 15:00:00      5.90            A       21.4
    ## 1688  02336728 2011-05-27 07:45:00    256.00          A e       20.8
    ## 1689  02336360 2011-05-08 10:15:00     13.00            E       16.9
    ## 1690  02336120 2011-05-23 09:00:00     11.00            A       21.7
    ## 1691  02336410 2011-05-27 21:00:00     72.00            X       22.7
    ## 1692  02336120 2011-05-25 20:00:00     10.00            X       24.8
    ## 1693  02336728 2011-05-24 21:45:00      8.90          A e       25.7
    ## 1694  02336120 2011-05-10 08:30:00     15.00          A e       20.3
    ## 1695  02336360 2011-05-03 10:15:00     13.00          A e       20.1
    ## 1696  02336120 2011-05-27 16:45:00    191.00            E       20.9
    ## 1697  02336526 2011-05-06 03:45:00      5.50            A       17.1
    ## 1698  02336526 2011-05-08 16:45:00      4.60          A e       18.4
    ## 1699  02336360 2011-05-25 07:15:00      8.70            X       22.6
    ## 1700  02336240 2011-05-02 13:15:00     13.00            X       18.7
    ## 1701  02336120 2011-05-07 09:45:00     17.00          A e       16.0
    ## 1702  02337170 2011-05-27 21:30:00   6790.00            A       20.6
    ## 1703  02336300 2011-05-10 03:15:00     31.00          A e       21.8
    ## 1704 021989773 2011-05-03 18:00:00  50000.00            X       24.0
    ## 1705  02203655 2011-05-07 17:15:00     12.00          A e       17.0
    ## 1706  02336313 2011-05-09 17:00:00      1.00            A       22.3
    ## 1707 021989773 2011-05-05 07:15:00  62200.00            X       23.2
    ## 1708  02336300 2011-05-16 04:00:00     25.00            A       17.8
    ## 1709  02203655 2011-05-30 12:15:00     10.00            A       22.2
    ## 1710  02336410 2011-05-21 23:30:00     14.00            A       22.9
    ## 1711  02203655 2011-05-23 18:00:00      7.80            A       22.4
    ## 1712  02336728 2011-05-16 13:15:00     11.00            A       16.7
    ## 1713  02336360 2011-05-18 20:15:00     10.00            E       17.7
    ## 1714 021989773 2011-05-07 16:00:00  -7160.00            X       22.8
    ## 1715  02336240 2011-05-31 01:15:00     11.00            A       24.9
    ## 1716  02336526 2011-05-24 01:00:00      3.30            A       24.6
    ## 1717  02336410 2011-05-14 13:00:00     17.00            A       21.0
    ## 1718  02336120 2011-05-13 00:00:00     14.00            A       24.7
    ## 1719  02336120 2011-05-02 11:30:00     16.00            A       19.1
    ## 1720  02336526 2011-05-23 11:30:00      3.60            E       21.2
    ## 1721 021989773 2011-05-19 20:15:00  57000.00            X       23.6
    ## 1722  02337170 2011-05-16 09:00:00   1350.00            X       16.1
    ## 1723  02336728 2011-05-20 12:15:00     10.00          A e       16.4
    ## 1724  02337170 2011-05-30 18:15:00   1290.00            A       23.7
    ## 1725  02336526 2011-05-04 23:00:00      8.30            A       19.8
    ## 1726 021989773 2011-05-28 23:00:00 -16200.00            A       26.7
    ## 1727  02336526 2011-05-24 11:15:00      3.10            X       21.4
    ## 1728  02203655 2011-05-26 22:00:00      8.50            A       23.1
    ## 1729  02336240 2011-05-15 22:00:00     10.00            A       18.6
    ## 1730  02336120 2011-05-31 13:00:00     12.00            E       23.3
    ## 1731 021989773 2011-05-07 13:45:00 -51200.00            A       22.7
    ## 1732 021989773 2011-05-01 17:15:00  44600.00            A       23.8
    ## 1733  02336313 2011-05-23 11:00:00      0.93            A       20.3
    ## 1734  02336313 2011-05-11 04:00:00      0.93            A       22.8
    ## 1735 021989773 2011-05-12 06:00:00 -68800.00            A       23.4
    ## 1736  02336120 2011-05-27 04:30:00    478.00            A       22.7
    ## 1737  02336360 2011-05-20 08:45:00     10.00            E       17.4
    ## 1738  02203655 2011-05-27 06:15:00     81.00            A       21.0
    ## 1739  02203700 2011-05-23 16:30:00      3.90            A       22.8
    ## 1740  02336410 2011-05-10 23:30:00     19.00          A e       23.5
    ## 1741  02203700 2011-05-17 17:45:00      4.60          A e       17.0
    ## 1742 021989773 2011-05-28 03:30:00  37900.00          A e       26.0
    ## 1743  02337170 2011-05-27 07:15:00   2620.00            A       20.6
    ## 1744  02336410 2011-05-08 15:30:00     21.00            X       17.6
    ## 1745  02203655 2011-05-23 07:15:00      7.20          A e       22.1
    ## 1746 021989773 2011-05-15 05:00:00  64400.00            A       24.1
    ## 1747  02336526 2011-05-09 07:30:00      4.20          A e       19.8
    ## 1748  02336300 2011-05-21 05:15:00     25.00            E       20.6
    ## 1749  02336360 2011-05-31 05:00:00      6.30            E       24.7
    ## 1750  02336300 2011-05-07 04:30:00     38.00            A       17.1
    ## 1751  02336240 2011-05-09 08:00:00     12.00            A       18.5
    ## 1752  02336360 2011-05-20 03:45:00     10.00            A       18.3
    ## 1753  02336728 2011-05-24 19:45:00        NA            E       25.2
    ## 1754  02203700 2011-05-11 22:30:00      4.60          A e       26.2
    ## 1755 021989773 2011-05-07 18:00:00  78900.00            X       23.3
    ## 1756  02336313 2011-05-17 23:15:00      1.00          A e       16.8
    ## 1757  02203700 2011-05-25 02:00:00      3.50            A       24.0
    ## 1758  02337170 2011-05-04 11:15:00   6620.00            A       15.4
    ## 1759  02336300 2011-05-06 17:45:00     38.00            A       17.7
    ## 1760 021989773 2011-05-11 23:00:00  91200.00            A       23.9
    ## 1761  02336120 2011-05-01 22:00:00     17.00            A       21.8
    ## 1762  02336120 2011-05-17 13:30:00     14.00            A       15.3
    ## 1763  02336526 2011-05-29 04:15:00      6.90            X       23.4
    ## 1764  02203700 2011-05-17 02:15:00      5.60          A e       17.2
    ## 1765  02336410 2011-05-06 00:30:00     28.00            A       17.5
    ## 1766  02336313 2011-05-10 00:00:00        NA            A       23.4
    ## 1767  02336728 2011-05-26 13:45:00      7.80            A       21.5
    ## 1768  02336120 2011-05-10 09:15:00     15.00            A       20.2
    ## 1769  02203655 2011-05-30 08:45:00     10.00            A       23.3
    ## 1770  02203700 2011-05-01 17:45:00      6.10            E       22.1
    ## 1771  02336728 2011-05-20 23:45:00     10.00            A       22.1
    ## 1772  02336240 2011-05-03 01:30:00     13.00            A       21.0
    ## 1773  02336120 2011-05-31 03:15:00     13.00            A       25.2
    ## 1774  02336120 2011-05-16 14:15:00     13.00            A       16.7
    ## 1775  02336526 2011-05-30 07:45:00      5.50            A       23.8
    ## 1776  02336120 2011-05-10 21:00:00     16.00            A       24.0
    ## 1777  02336313 2011-05-28 21:15:00      0.87            A       24.8
    ## 1778  02336526 2011-05-12 18:45:00      3.80            X       24.5
    ## 1779  02336240 2011-05-04 05:30:00    339.00            A       17.5
    ## 1780  02203700 2011-05-13 15:15:00      4.40            E       21.6
    ## 1781  02336728 2011-05-28 02:30:00     55.00          A e       22.1
    ## 1782  02336526 2011-05-01 16:00:00      4.40            X       18.4
    ## 1783 021989773 2011-05-10 08:15:00  66400.00            A       22.8
    ## 1784  02203700 2011-05-26 19:45:00      3.70            A       25.3
    ## 1785  02336120 2011-05-11 02:45:00     15.00          A e       23.0
    ## 1786 021989773 2011-05-06 02:15:00 -48100.00            A       23.5
    ## 1787  02203655 2011-05-31 12:00:00      9.60            A       22.8
    ## 1788  02336313 2011-05-14 11:00:00      0.98            X       20.3
    ## 1789  02336240 2011-05-03 22:45:00    109.00            A       19.9
    ## 1790  02336728 2011-05-27 16:15:00    186.00            A       20.3
    ## 1791  02336728 2011-05-05 03:45:00     28.00            A       17.3
    ## 1792  02337170 2011-05-11 13:45:00   2430.00            A       17.3
    ## 1793  02336300 2011-05-16 03:30:00     26.00            A       17.9
    ## 1794  02336120 2011-05-24 06:00:00     10.00            E       22.8
    ## 1795  02203700 2011-05-13 16:00:00      4.40            X       22.4
    ## 1796  02336410 2011-05-30 20:30:00     13.00            E       26.5
    ## 1797  02203700 2011-05-21 10:00:00      4.60            A       18.2
    ## 1798  02336410 2011-05-04 05:00:00    340.00            A       18.4
    ## 1799  02336300 2011-05-22 21:15:00     22.00            A       26.5
    ## 1800  02336300 2011-05-09 03:30:00     32.00            A       20.1
    ## 1801  02336410 2011-05-02 00:30:00     22.00            A       20.9
    ## 1802  02336120 2011-05-05 16:45:00     23.00            A       15.7
    ## 1803  02336240 2011-05-29 19:30:00     14.00            A       25.6
    ## 1804  02336526 2011-05-29 20:45:00      5.70            A       26.2
    ## 1805  02336300 2011-05-12 04:30:00     29.00            A       23.4
    ## 1806  02336313 2011-05-09 14:30:00      1.10            A       19.6
    ## 1807  02336526 2011-05-13 21:00:00      3.60            A       24.2
    ## 1808  02336360 2011-05-31 09:30:00        NA          A e       23.7
    ## 1809  02336240 2011-05-30 06:15:00     12.00            A       22.8
    ## 1810  02336240 2011-05-19 00:30:00      9.90            A       16.7
    ## 1811  02336240 2011-05-13 10:45:00        NA            A       20.8
    ## 1812  02203655 2011-05-04 00:15:00    174.00            A       20.8
    ## 1813  02336240 2011-05-27 11:15:00   1360.00            A       19.5
    ## 1814  02336410 2011-05-06 06:45:00        NA            A       16.3
    ## 1815  02336120 2011-05-14 11:45:00     13.00          A e       20.7
    ## 1816 021989773 2011-05-24 15:45:00 -58800.00            A       25.3
    ## 1817  02203655 2011-05-19 17:30:00      9.20            A       16.6
    ## 1818  02336410 2011-05-17 03:30:00     16.00            A       17.0
    ## 1819  02336410 2011-05-31 00:15:00     13.00            E       25.7
    ## 1820  02336360 2011-05-24 04:30:00      9.10            X       22.9
    ## 1821 021989773 2011-05-04 19:00:00  64100.00            X       23.6
    ## 1822  02336410 2011-05-09 01:15:00     21.00          A e       20.1
    ## 1823  02336410 2011-05-03 19:15:00     20.00            A       22.6
    ## 1824  02336240 2011-05-31 23:00:00     10.00            E       25.9
    ## 1825  02336300 2011-05-08 08:30:00     34.00            A       17.5
    ## 1826  02336410 2011-05-04 08:45:00    194.00            E       17.8
    ## 1827  02336410 2011-05-04 03:15:00    224.00          A e       18.4
    ## 1828  02336410 2011-05-24 07:45:00     13.00            E       22.5
    ## 1829  02336360 2011-05-10 20:45:00     12.00            A       24.6
    ## 1830  02336120 2011-05-31 07:00:00     13.00            A       24.1
    ## 1831  02336728 2011-05-21 16:00:00      9.70            A       20.6
    ## 1832  02336300 2011-05-25 09:00:00     19.00            A       22.6
    ## 1833  02336728 2011-05-21 05:30:00      9.70            X       19.0
    ## 1834  02336313 2011-05-07 16:30:00      1.10            A       18.5
    ## 1835  02336120 2011-05-16 03:30:00     13.00            A       17.9
    ## 1836 021989773 2011-05-25 08:30:00   3590.00            A       25.3
    ## 1837  02336120 2011-05-26 23:30:00        NA            A       22.9
    ## 1838  02336240 2011-05-15 11:00:00     10.00          A e       18.5
    ## 1839  02336240 2011-05-06 16:00:00     14.00            X       16.0
    ## 1840  02336360 2011-05-12 07:00:00     11.00            X       22.5
    ## 1841  02336526 2011-05-01 06:00:00      4.20            A       19.6
    ## 1842 021989773 2011-05-02 07:00:00  25400.00            A       23.5
    ## 1843  02336526 2011-05-09 13:00:00        NA            X       18.3
    ## 1844  02336300 2011-05-18 19:00:00     27.00            E       17.8
    ## 1845  02336526 2011-05-26 18:00:00      2.80            E       23.8
    ## 1846  02336360 2011-05-20 02:30:00     10.00            A       18.5
    ## 1847  02336526 2011-05-28 09:30:00     11.00            E       20.2
    ## 1848  02336120 2011-05-12 07:30:00     14.00          A e       22.1
    ## 1849  02336410 2011-05-01 07:15:00     22.00            A       19.1
    ## 1850  02336526 2011-05-14 09:00:00      3.50            X       21.3
    ## 1851  02336360 2011-05-18 21:45:00     10.00            A       17.5
    ## 1852  02336300 2011-05-02 13:00:00     31.00          A e       19.3
    ## 1853  02336313 2011-05-28 21:45:00      0.87            A       24.9
    ## 1854  02336300 2011-05-22 09:00:00     23.00            A       21.2
    ## 1855  02336240 2011-05-01 12:15:00     13.00            E       17.4
    ## 1856  02336728 2011-05-30 21:30:00     15.00            A       26.5
    ## 1857  02336240 2011-05-19 16:15:00      9.50            A       16.7
    ## 1858  02336526 2011-05-26 16:45:00      2.80            A       23.2
    ## 1859  02336410 2011-05-21 13:45:00     14.00            A       19.1
    ## 1860  02336526 2011-05-08 01:15:00      4.80          A e       20.6
    ## 1861 021989773 2011-05-20 02:45:00 -59100.00          A e       23.4
    ## 1862  02336313 2011-05-20 10:15:00      0.98            A       16.4
    ## 1863  02203655 2011-05-04 13:15:00     43.00            X       15.9
    ## 1864  02337170 2011-05-17 07:15:00   1880.00            A       16.0
    ## 1865  02336526 2011-05-05 23:00:00      5.50            A       18.9
    ## 1866  02336410 2011-05-06 22:45:00     25.00          A e       18.1
    ## 1867  02336313 2011-05-02 05:30:00      1.00            A       20.1
    ## 1868  02336410 2011-05-16 03:45:00     16.00            X       18.0
    ## 1869 021989773 2011-05-23 12:00:00  35000.00            A       24.4
    ## 1870  02203700 2011-05-21 05:00:00      4.90            A       20.2
    ## 1871  02336313 2011-05-09 23:45:00      0.98          A e       23.5
    ## 1872  02337170 2011-05-13 21:00:00   6290.00            X       16.3
    ## 1873 021989773 2011-05-17 10:30:00 -73500.00          A e       23.4
    ## 1874  02336360 2011-05-22 22:45:00      9.80            A       24.9
    ## 1875  02336410 2011-05-31 21:15:00     11.00            A       27.1
    ## 1876  02336360 2011-05-07 15:30:00     14.00            A       16.1
    ## 1877  02336728 2011-05-14 17:30:00     12.00          A e       22.1
    ## 1878  02337170 2011-05-16 11:45:00   1370.00          A e       16.1
    ## 1879  02203655 2011-05-19 04:00:00      8.80            A       16.4
    ## 1880  02336728 2011-05-20 06:15:00     10.00            A       16.5
    ## 1881  02336728 2011-05-19 21:15:00     11.00            E       20.0
    ## 1882  02337170 2011-05-04 08:00:00   6450.00            E       15.2
    ## 1883  02336360 2011-05-11 14:15:00     12.00            A       21.2
    ## 1884  02336410 2011-05-10 10:45:00     19.00          A e       20.5
    ## 1885  02336313 2011-05-10 00:30:00      0.98          A e       23.2
    ## 1886 021989773 2011-05-10 19:00:00  -9740.00            X       23.5
    ## 1887  02203655 2011-05-29 02:45:00     14.00            A       23.6
    ## 1888  02336240 2011-05-10 02:45:00     11.00            E       21.1
    ## 1889  02336526 2011-05-10 20:15:00      6.40            X       24.9
    ## 1890  02336120 2011-05-11 14:45:00     15.00            X       21.4
    ## 1891 021989773 2011-05-31 14:30:00  71100.00            A       27.2
    ## 1892  02336300 2011-05-25 16:15:00     19.00            A       23.8
    ## 1893  02336360 2011-05-30 23:30:00      6.60            A       26.5
    ## 1894 021989773 2011-05-18 10:00:00 -46000.00            A       23.1
    ## 1895  02203700 2011-05-24 14:45:00      3.90            A       21.5
    ## 1896 021989773 2011-05-07 10:00:00  31400.00            A       22.5
    ## 1897 021989773 2011-05-26 17:30:00 -59800.00            A       26.1
    ## 1898  02336728 2011-05-22 07:45:00      9.30            A       19.9
    ## 1899  02336313 2011-05-01 04:00:00      1.00            A       19.6
    ## 1900  02336240 2011-05-20 08:00:00      9.50            A       16.8
    ## 1901 021989773 2011-05-25 16:30:00 -44800.00            X       26.0
    ## 1902  02336313 2011-05-29 16:00:00      0.82            A       23.1
    ## 1903  02203700 2011-05-07 16:45:00      5.60            A       18.7
    ## 1904  02203700 2011-05-21 08:45:00      4.60            E       18.6
    ## 1905 021989773 2011-05-03 01:45:00        NA            A       24.0
    ## 1906  02336300 2011-05-13 09:30:00     27.00            A       22.0
    ## 1907 021989773 2011-05-23 08:30:00  82400.00            A       24.5
    ## 1908  02203700 2011-05-09 09:30:00      4.90            E       18.3
    ## 1909  02336526 2011-05-07 23:15:00      4.80            A       21.2
    ## 1910  02203700 2011-05-09 16:00:00      5.10            E       20.8
    ## 1911  02336728 2011-05-03 12:15:00     15.00            X       20.2
    ## 1912  02336313 2011-05-29 02:00:00      0.77            A       23.8
    ## 1913 021989773 2011-05-27 12:15:00  70500.00          A e       25.7
    ## 1914  02336120 2011-05-11 09:00:00     14.00            A       21.5
    ## 1915  02337170 2011-05-25 21:45:00   1670.00            A       21.3
    ## 1916  02203655 2011-05-03 01:30:00     11.00            X       21.5
    ## 1917  02336526 2011-05-31 01:00:00      6.70            A       26.6
    ## 1918  02336120 2011-05-02 22:00:00     17.00            A       22.3
    ## 1919  02336240 2011-05-29 18:15:00     14.00            A       25.0
    ## 1920  02336526 2011-05-21 01:45:00      3.60            A       22.3
    ## 1921  02336313 2011-05-10 17:15:00      1.00            E       23.8
    ## 1922  02336526 2011-05-15 15:15:00      3.60          A e       18.7
    ## 1923  02336240 2011-05-20 22:30:00      9.20            A       21.4
    ## 1924  02336410 2011-05-04 11:30:00    125.00            E       17.1
    ## 1925  02336120 2011-05-22 02:15:00     12.00            A       22.5
    ## 1926 021989773 2011-05-06 16:15:00  21600.00            A       23.1
    ## 1927  02336526 2011-05-03 15:45:00      4.20            X       20.5
    ## 1928  02336120 2011-05-17 19:00:00     14.00            A       16.3
    ## 1929  02336360 2011-05-26 12:30:00      8.10            A       22.4
    ## 1930 021989773 2011-05-14 20:00:00 -83400.00            X       24.2
    ## 1931  02336120 2011-05-25 03:45:00      9.90            E       24.0
    ## 1932  02336728 2011-05-13 12:30:00     12.00            E       21.0
    ## 1933  02336526 2011-05-26 16:00:00      2.80          A e       22.9
    ## 1934  02336120 2011-05-16 08:30:00     13.00            A       17.1
    ## 1935  02336360 2011-05-10 03:30:00     12.00            A       21.6
    ## 1936  02336240 2011-05-09 17:00:00     12.00            A       21.3
    ## 1937 021989773 2011-05-03 12:45:00 -45000.00            A       23.7
    ## 1938  02336240 2011-05-13 21:00:00     10.00            X       24.1
    ## 1939 021989773 2011-05-06 05:15:00  78500.00            A       23.0
    ## 1940 021989773 2011-05-25 04:45:00 -52700.00            A       25.3
    ## 1941 021989773 2011-05-13 20:45:00 -61100.00            E       24.4
    ## 1942 021989773 2011-05-04 16:45:00  78100.00            A       23.6
    ## 1943  02336410 2011-05-22 19:45:00     14.00            X       24.8
    ## 1944  02336240 2011-05-20 22:00:00      9.20            X       21.6
    ## 1945  02336120 2011-05-24 16:00:00     11.00            E       22.3
    ## 1946  02336410 2011-05-01 18:00:00     22.00            A       20.6
    ## 1947  02336526 2011-05-15 03:00:00      3.80            X       22.2
    ## 1948 021989773 2011-05-31 14:15:00  59400.00            A       27.1
    ## 1949  02336728 2011-05-22 13:45:00      9.30            A       19.9
    ## 1950  02203700 2011-05-22 13:30:00      3.90          A e       19.7
    ## 1951  02336410 2011-05-07 04:45:00     23.00            A       17.3
    ## 1952  02336360 2011-05-09 10:00:00     12.00            E       18.6
    ## 1953  02336313 2011-05-21 16:15:00      1.00            X       21.7
    ## 1954 021989773 2011-05-12 04:15:00 -61700.00            E       23.4
    ## 1955  02336410 2011-05-23 04:45:00     13.00            A       22.9
    ## 1956  02336526 2011-05-10 02:45:00      4.00            A       23.3
    ## 1957  02336300 2011-05-17 21:45:00     29.00            A       16.6
    ## 1958  02336526 2011-05-25 16:30:00      3.10            X       22.4
    ## 1959  02336360 2011-05-08 19:45:00     13.00            E       19.8
    ## 1960  02336300 2011-05-21 13:15:00     25.00            A       19.4
    ## 1961  02203700 2011-05-16 00:30:00      4.40            A       18.3
    ## 1962  02336360 2011-05-26 02:45:00      8.40            A       24.2
    ## 1963  02337170 2011-05-09 15:15:00   1370.00            A       18.3
    ## 1964  02336240 2011-05-11 12:00:00     11.00            A       20.5
    ## 1965  02336360 2011-05-02 00:00:00     14.00            A       21.3
    ## 1966  02336120 2011-05-12 21:00:00        NA            X       25.0
    ## 1967  02336300 2011-05-15 19:30:00     26.00            X       19.5
    ## 1968  02336526 2011-05-13 09:45:00      3.60            X       21.6
    ## 1969  02337170 2011-05-14 08:30:00   3980.00          A e       15.0
    ## 1970  02336526 2011-05-17 13:45:00      3.80          A e       15.1
    ## 1971  02336300 2011-05-19 20:00:00     26.00            A       20.7
    ## 1972  02336728 2011-05-27 04:45:00    244.00          A e       22.4
    ## 1973  02336410 2011-05-04 17:30:00     67.00            A       17.7
    ## 1974  02336120 2011-05-08 18:15:00     17.00          A e       19.1
    ## 1975  02336300 2011-05-01 09:30:00        NA          A e       18.7
    ## 1976  02203700 2011-05-24 04:15:00      3.70          A e       23.0
    ## 1977 021989773 2011-05-29 16:15:00  53000.00            E       26.8
    ## 1978  02336240 2011-05-29 10:30:00     14.00            E       21.0
    ## 1979  02336728 2011-05-20 22:15:00     10.00            X       22.8
    ## 1980  02336526 2011-05-11 10:30:00      4.00            A       21.1
    ## 1981  02336410 2011-05-22 05:00:00     14.00            A       21.7
    ## 1982  02336313 2011-05-17 03:15:00      1.20            E       16.6
    ## 1983  02336410 2011-05-24 04:45:00     14.00          A e       23.1
    ## 1984  02336526 2011-05-08 09:15:00      4.60            E       17.0
    ## 1985  02336526 2011-05-19 08:15:00      3.60            X       15.4
    ## 1986  02336526 2011-05-31 14:00:00      4.60            X       22.7
    ## 1987  02336120 2011-05-22 17:30:00     11.00            A       22.1
    ## 1988  02336313 2011-05-24 01:45:00      0.87            A       23.9
    ## 1989  02203700 2011-05-21 19:15:00      4.00          A e       23.8
    ## 1990  02336313 2011-05-21 22:30:00      0.98            A       23.5
    ## 1991  02336120 2011-05-11 02:30:00     15.00          A e       23.1
    ## 1992  02336313 2011-05-18 02:45:00      0.98            A       15.8
    ## 1993  02336120 2011-05-26 23:15:00    352.00            E       23.1
    ## 1994  02336360 2011-05-24 16:15:00      9.10            A       22.6
    ## 1995  02336120 2011-05-16 04:30:00     13.00            A       17.8
    ## 1996  02337170 2011-05-23 21:00:00   1980.00            A       22.4
    ## 1997  02336300 2011-05-13 20:45:00     27.00            A       25.0
    ## 1998  02336410 2011-05-02 12:45:00     21.00            A       19.4
    ## 1999  02203700 2011-05-06 22:30:00      5.30          A e       20.8
    ## 2000  02336526 2011-05-01 21:00:00      4.20            X       22.7
    ## 2001  02336120 2011-05-16 12:30:00     13.00            E       16.7
    ## 2002  02336313 2011-05-14 11:45:00      0.98            A       20.3
    ## 2003  02336313 2011-05-08 07:00:00      1.00            E       17.0
    ## 2004  02203700 2011-05-16 07:00:00      4.40            A       17.0
    ## 2005  02336410 2011-05-02 22:15:00     21.00            X       22.0
    ## 2006  02336728 2011-05-13 08:15:00     12.00            A       21.0
    ## 2007  02336240 2011-05-29 09:30:00     15.00          A e       21.1
    ## 2008  02336313 2011-05-12 12:00:00      1.00            A       20.5
    ## 2009  02336120 2011-05-25 04:00:00      9.90            E       23.9
    ## 2010  02203700 2011-05-13 08:30:00      4.40            A       20.8
    ## 2011  02336360 2011-05-27 07:15:00     76.00            A       21.9
    ## 2012  02336728 2011-05-26 11:00:00      7.80            X       21.3
    ## 2013  02336410 2011-05-25 08:45:00     13.00            A       22.3
    ## 2014  02336240 2011-05-15 09:30:00     10.00            E       18.8
    ## 2015 021989773 2011-05-04 19:30:00  55100.00            A       23.6
    ## 2016  02203655 2011-05-20 18:15:00      8.80            A       19.2
    ## 2017 021989773 2011-05-15 09:45:00        NA            A       24.1
    ## 2018  02336313 2011-05-31 15:45:00      0.73            A       24.6
    ## 2019  02203700 2011-05-05 09:30:00     22.00            X       16.1
    ## 2020  02336410 2011-05-21 13:00:00     14.00            A       19.0
    ## 2021  02336313 2011-05-15 00:00:00      1.00            X       22.0
    ## 2022 021989773 2011-05-01 10:00:00 -54600.00            X       23.5
    ## 2023 021989773 2011-05-14 16:00:00  55600.00            A       24.2
    ## 2024  02336300 2011-05-20 06:45:00     26.00            A       18.1
    ## 2025  02336240 2011-05-17 16:30:00     11.00          A e       16.0
    ## 2026  02336360 2011-05-27 10:45:00    319.00            A       21.1
    ## 2027  02203700 2011-05-13 15:45:00      4.40            E       22.2
    ## 2028  02336313 2011-05-31 03:15:00      0.69            E       25.0
    ## 2029  02336526 2011-05-03 12:00:00      4.00            E       19.7
    ## 2030  02336360 2011-05-02 10:00:00     13.00            A       19.4
    ## 2031  02336240 2011-05-22 04:45:00      8.90            A       21.0
    ## 2032  02336300 2011-05-12 18:30:00     28.00            X       25.4
    ## 2033  02203700 2011-05-04 07:15:00     21.00            A       16.6
    ## 2034  02336728 2011-05-18 03:00:00     11.00            E       15.3
    ## 2035  02336360 2011-05-01 12:00:00     14.00            A       17.8
    ## 2036  02336120 2011-05-19 15:45:00     12.00            A       15.8
    ## 2037  02336360 2011-05-20 13:15:00        NA            X       16.8
    ## 2038  02336313 2011-05-07 19:00:00      1.10            A       20.5
    ## 2039  02336360 2011-05-26 16:30:00      8.10            A       23.5
    ## 2040  02336120 2011-05-01 21:45:00     17.00            A       21.8
    ## 2041  02336240 2011-05-24 13:45:00      8.20            A       21.3
    ## 2042  02336240 2011-05-05 23:30:00     14.00            A       17.1
    ## 2043  02337170 2011-05-26 12:00:00   1760.00            A       20.3
    ## 2044  02336410 2011-05-20 04:30:00     15.00          A e       18.0
    ## 2045  02336313 2011-05-07 21:00:00      1.00            A       20.8
    ## 2046  02336360 2011-05-10 18:30:00     12.00            X       23.4
    ## 2047 021989773 2011-05-21 05:15:00        NA          A e       23.7
    ## 2048  02336728 2011-05-14 09:00:00     12.00            E       20.4
    ## 2049  02336526 2011-05-16 09:00:00      3.60          A e       17.0
    ## 2050  02336410 2011-05-27 14:30:00    230.00            A       21.1
    ## 2051  02203700 2011-05-13 07:30:00      4.40            E       21.2
    ## 2052  02336410 2011-05-04 20:45:00     55.00            A       18.8
    ## 2053  02336120 2011-05-27 05:00:00    415.00          A e       22.6
    ## 2054  02203655 2011-05-23 02:45:00      7.80            A       23.0
    ## 2055  02203655 2011-05-21 11:00:00      8.20            X       18.8
    ## 2056  02336526 2011-05-11 20:45:00      3.80          A e       25.8
    ## 2057  02336313 2011-05-15 13:30:00      1.00            A       18.1
    ## 2058  02336313 2011-05-15 06:45:00      0.98          A e       19.7
    ## 2059  02336300 2011-05-12 09:30:00     29.00            A       22.2
    ## 2060  02203655 2011-05-25 07:45:00      7.20          A e       22.1
    ## 2061  02336410 2011-05-06 07:30:00     26.00            E       16.1
    ## 2062  02336240 2011-05-31 20:30:00     10.00            A       26.5
    ## 2063  02336300 2011-05-21 17:00:00     23.00            X       21.8
    ## 2064  02336360 2011-05-10 17:00:00     12.00            E       21.9
    ## 2065  02336410 2011-05-03 18:45:00     20.00            E       22.5
    ## 2066  02336728 2011-05-25 10:30:00      8.20            A       20.7
    ## 2067  02337170 2011-05-31 21:15:00   1260.00            A       25.8
    ## 2068  02337170 2011-05-29 02:45:00   2430.00            X       21.5
    ## 2069  02336410 2011-05-05 16:00:00     31.00            A       15.4
    ## 2070  02336240 2011-05-01 22:45:00     13.00            E       21.3
    ## 2071  02336410 2011-05-22 03:45:00     14.00            A       21.9
    ## 2072 021989773 2011-05-13 02:30:00  50600.00            X       23.8
    ## 2073  02336313 2011-05-28 11:00:00      0.98          A e       19.8
    ## 2074  02336360 2011-05-03 20:30:00     14.00            A       22.1
    ## 2075  02203700 2011-05-01 04:15:00      6.10            A       19.5
    ## 2076  02336240 2011-05-10 02:00:00     11.00            E       21.3
    ## 2077  02336313 2011-05-14 05:30:00      0.93            A       21.7
    ## 2078 021989773 2011-05-05 20:45:00  19500.00            A       23.4
    ## 2079  02336410 2011-05-23 04:00:00     13.00            A       23.1
    ## 2080  02337170 2011-05-24 11:00:00   1900.00          A e       20.2
    ## 2081  02336120 2011-05-17 03:15:00     13.00            A       17.1
    ## 2082  02336410 2011-05-30 06:45:00     15.00            A       23.9
    ## 2083  02336360 2011-05-28 19:15:00     10.00          A e       24.9
    ## 2084  02336728 2011-05-19 17:00:00     10.00            A       17.5
    ## 2085 021989773 2011-05-31 23:30:00        NA            A       27.8
    ## 2086  02336526 2011-05-03 04:45:00      4.20            E       22.0
    ## 2087 021989773 2011-05-20 13:00:00        NA          A e       23.2
    ## 2088 021989773 2011-05-03 19:00:00  44600.00          A e       24.1
    ## 2089  02336313 2011-05-20 09:15:00      0.98            X       16.6
    ## 2090  02336240 2011-05-02 16:45:00     13.00            A       20.7
    ## 2091  02203700 2011-05-12 14:15:00      4.60          A e       21.0
    ## 2092  02337170 2011-05-11 01:00:00   4120.00            A       20.5
    ## 2093  02337170 2011-05-23 08:45:00   1410.00            A       19.9
    ## 2094  02336526 2011-05-20 11:00:00      3.60            X       17.1
    ## 2095  02336360 2011-05-29 05:15:00      8.70            X       23.2
    ## 2096  02336410 2011-05-16 08:30:00        NA            A       17.3
    ## 2097  02336300 2011-05-20 20:15:00     25.00            E       23.1
    ## 2098  02336120 2011-05-10 11:00:00     15.00          A e       19.9
    ## 2099 021989773 2011-06-01 02:45:00  67000.00            X       27.6
    ## 2100  02336526 2011-05-19 22:00:00      3.60            A       19.8
    ## 2101  02336120 2011-05-24 17:00:00     11.00            A       22.8
    ## 2102  02336120 2011-05-31 20:15:00     12.00          A e       26.5
    ## 2103  02336240 2011-05-07 14:00:00     13.00            A       15.3
    ## 2104  02336410 2011-05-20 15:15:00     14.00          A e       17.7
    ## 2105  02336526 2011-05-19 16:15:00      3.80            A       15.6
    ## 2106  02336120 2011-05-28 01:45:00     56.00          A e       22.5
    ## 2107  02336410 2011-05-25 22:15:00     11.00            A       25.7
    ## 2108  02336360 2011-05-30 05:30:00      7.20            E       24.1
    ## 2109  02203655 2011-05-22 23:45:00      8.20            A       22.8
    ## 2110 021989773 2011-05-22 10:45:00  43800.00            X       23.9
    ## 2111  02336313 2011-05-16 01:00:00      1.00            A       18.2
    ## 2112  02336120 2011-05-29 22:30:00     16.00            X       25.9
    ## 2113  02336120 2011-05-19 13:00:00     12.00            A       15.0
    ## 2114  02336526 2011-05-12 09:15:00      3.80            A       22.0
    ## 2115  02203655 2011-05-07 19:15:00     11.00            A       17.9
    ## 2116  02336240 2011-05-09 22:00:00     12.00            A       22.5
    ## 2117  02336728 2011-05-27 00:15:00     25.00            E       23.6
    ## 2118  02336313 2011-05-23 11:15:00      0.93            A       20.3
    ## 2119  02336728 2011-05-21 07:30:00      9.70          A e       18.5
    ## 2120  02336300 2011-05-12 23:45:00     27.00          A e       25.6
    ## 2121 021989773 2011-05-05 18:00:00  80600.00            X       23.3
    ## 2122  02336410 2011-05-23 07:30:00     13.00            A       22.3
    ## 2123  02336120 2011-05-24 22:15:00     10.00            E       25.4
    ## 2124  02336240 2011-05-24 07:00:00      8.20            E       21.9
    ## 2125  02336360 2011-05-24 17:15:00      9.10            A       23.5
    ## 2126  02336300 2011-05-06 19:00:00     38.00            A       18.9
    ## 2127  02336526 2011-05-13 09:00:00      3.60          A e       21.9
    ## 2128  02336313 2011-05-13 17:15:00      1.00            A       23.8
    ## 2129  02336410 2011-05-31 01:15:00     13.00            A       25.4
    ## 2130  02336313 2011-05-08 21:15:00      1.00            A       21.9
    ## 2131  02336240 2011-05-02 14:30:00     13.00            A       19.2
    ## 2132  02336526 2011-05-19 00:45:00      3.80            E       17.5
    ## 2133  02337170 2011-05-25 22:45:00   1670.00            E       21.3
    ## 2134  02336120 2011-05-12 00:30:00     15.00            X       24.4
    ## 2135  02336410 2011-05-15 15:45:00     16.00            X       19.1
    ## 2136  02336313 2011-05-16 11:30:00      1.00          A e       16.3
    ## 2137  02336300 2011-05-17 12:30:00     27.00            A       15.3
    ## 2138  02203700 2011-05-15 14:00:00      4.40            E       18.2
    ## 2139  02203700 2011-05-12 08:00:00      4.60            A       21.3
    ## 2140  02336360 2011-05-19 02:30:00     10.00            A       16.2
    ## 2141  02336313 2011-05-16 20:45:00      2.60            A       17.9
    ## 2142 021989773 2011-05-30 23:30:00 -47500.00          A e       27.5
    ## 2143 021989773 2011-05-19 08:15:00  65000.00            E       23.1
    ## 2144  02336360 2011-05-09 14:15:00     12.00          A e       18.5
    ## 2145  02336526 2011-05-16 15:00:00      3.80            A       16.5
    ## 2146  02336410 2011-05-06 23:45:00     24.00            E       18.1
    ## 2147  02336313 2011-05-20 13:00:00      1.00          A e       16.3
    ## 2148  02336728 2011-05-17 00:15:00     12.00            A       17.2
    ## 2149  02336120 2011-05-30 04:00:00     15.00            A       24.5
    ## 2150  02203700 2011-05-20 02:15:00      4.00          A e       19.7
    ## 2151 021989773 2011-05-08 05:45:00  29900.00          A e       22.9
    ## 2152  02203655 2011-05-26 21:45:00      8.50            X       23.2
    ## 2153  02203655 2011-05-07 13:15:00     12.00            A       15.1
    ## 2154  02336526 2011-05-02 08:45:00      4.00            A       19.8
    ## 2155  02336313 2011-05-18 02:00:00      1.00            A       16.1
    ## 2156  02336728 2011-05-31 22:45:00     13.00            A       26.5
    ## 2157  02203655 2011-05-05 02:45:00     18.00            X       17.9
    ## 2158  02336300 2011-05-13 14:00:00     27.00            A       21.9
    ## 2159 021989773 2011-05-29 09:30:00 -36400.00            A       26.3
    ## 2160 021989773 2011-05-06 13:45:00 -48400.00          A e       23.2
    ## 2161  02337170 2011-05-24 16:00:00   2870.00            A       20.6
    ## 2162  02336728 2011-05-30 04:00:00     17.00            E       22.8
    ## 2163  02336120 2011-05-27 04:15:00    499.00            A       22.7
    ## 2164  02336360 2011-05-01 11:15:00     14.00          A e       17.9
    ## 2165  02203655 2011-05-06 03:15:00     13.00          A e       17.5
    ## 2166  02336240 2011-05-21 13:15:00      9.20          A e       18.3
    ## 2167  02336728 2011-05-22 08:00:00      9.30            A       19.8
    ## 2168  02336360 2011-05-10 15:30:00     12.00            X       20.6
    ## 2169  02336360 2011-05-22 17:00:00      9.80            E       22.5
    ## 2170  02336526 2011-05-03 20:00:00        NA            A       22.8
    ## 2171  02336728 2011-05-16 22:00:00     12.00            A       17.8
    ## 2172  02203655 2011-05-07 20:45:00     11.00            A       18.1
    ## 2173 021989773 2011-05-27 23:45:00  55500.00            X       26.3
    ## 2174  02336526 2011-05-26 09:15:00      3.10            A       23.0
    ## 2175  02203700 2011-05-06 04:30:00      5.60            A       17.0
    ## 2176  02336410 2011-05-07 22:45:00     22.00            A       19.0
    ## 2177  02336313 2011-05-09 16:45:00      1.10            E       22.1
    ## 2178 021989773 2011-05-12 23:30:00  55800.00            X       24.2
    ## 2179  02336120 2011-05-28 17:15:00     27.00            X       22.6
    ## 2180  02336313 2011-05-22 01:00:00      0.93            A       23.0
    ## 2181  02336728 2011-05-28 00:15:00     67.00          A e       22.1
    ## 2182  02336410 2011-05-19 22:00:00     15.00          A e       19.3
    ## 2183  02336313 2011-05-14 05:45:00      0.98            A       21.7
    ## 2184  02203655 2011-05-20 16:45:00      8.50            A       18.3
    ## 2185  02336313 2011-05-13 16:00:00      1.00            E       23.0
    ## 2186 021989773 2011-05-18 21:15:00  -4640.00            X       23.6
    ## 2187  02336360 2011-05-30 14:45:00      6.60          A e       23.2
    ## 2188  02203655 2011-05-06 16:00:00     12.00            X       15.5
    ## 2189 021989773 2011-05-24 21:45:00  88100.00          A e       26.3
    ## 2190  02336120 2011-05-10 06:15:00     15.00            X       20.7
    ## 2191  02203655 2011-05-28 12:45:00     21.00            A       20.0
    ## 2192  02337170 2011-05-12 09:15:00   3960.00            A       16.2
    ## 2193 021989773 2011-05-20 05:30:00  62800.00            A       23.3
    ## 2194  02336360 2011-05-27 18:15:00     34.00            A       22.5
    ## 2195  02336300 2011-05-18 18:45:00     27.00            A       17.7
    ## 2196  02203700 2011-05-20 10:15:00      4.00            A       16.8
    ## 2197  02336410 2011-05-29 20:45:00     17.00            E       25.6
    ## 2198  02336728 2011-05-17 23:45:00     11.00            E       16.1
    ## 2199  02203700 2011-05-14 19:00:00      4.60          A e       23.2
    ## 2200  02336360 2011-05-17 12:15:00     11.00            E       15.3
    ## 2201  02203700 2011-05-14 09:30:00      4.40            X       20.4
    ## 2202  02336360 2011-05-13 13:30:00     11.00            A       21.1
    ## 2203  02336360 2011-05-20 21:15:00     10.00            A       22.4
    ## 2204 021989773 2011-05-29 18:30:00 -23800.00          A e       27.2
    ## 2205  02203655 2011-05-26 18:30:00      7.50            X       23.2
    ## 2206 021989773 2011-05-27 14:45:00  45400.00            A       25.9
    ## 2207  02336360 2011-05-01 20:30:00     14.00          A e       22.0
    ## 2208  02336410 2011-05-04 02:45:00    220.00            A       18.6
    ## 2209  02336360 2011-05-20 15:45:00      9.80            A       17.9
    ## 2210  02336313 2011-05-02 02:15:00      0.98            A       21.4
    ## 2211  02336240 2011-05-27 12:15:00   1170.00            A       19.5
    ## 2212  02336120 2011-05-12 18:45:00     14.00            X       23.8
    ## 2213  02336120 2011-05-09 17:45:00     16.00            X       20.4
    ## 2214  02336728 2011-05-30 21:00:00     15.00            A       26.4
    ## 2215  02336300 2011-05-11 07:30:00     31.00            E       22.3
    ## 2216  02336313 2011-06-01 02:45:00      0.65            E       25.6
    ## 2217  02336728 2011-05-16 07:30:00     11.00            A       17.0
    ## 2218  02336120 2011-05-04 12:45:00     99.00            X       16.5
    ## 2219  02336240 2011-05-21 05:30:00      9.20            A       19.3
    ## 2220  02336300 2011-05-15 09:15:00     27.00          A e       19.6
    ## 2221  02336313 2011-05-13 22:45:00      0.98          A e       24.1
    ## 2222  02337170 2011-05-22 12:30:00   2040.00            A       16.6
    ## 2223  02336300 2011-05-24 15:00:00     21.00            X       22.8
    ## 2224  02337170 2011-05-04 17:15:00   6130.00            X       16.2
    ## 2225  02336120 2011-05-06 06:30:00     20.00          A e       16.0
    ## 2226  02336360 2011-05-24 15:45:00      8.70            E       22.2
    ## 2227 021989773 2011-05-22 16:30:00 -47300.00            A       24.4
    ## 2228  02336240 2011-05-23 01:30:00      8.50          A e       23.3
    ## 2229  02336360 2011-05-07 03:30:00     14.00            E       17.6
    ## 2230  02337170 2011-05-21 11:00:00   2640.00          A e       15.2
    ## 2231  02336728 2011-05-14 16:00:00     12.00            X       21.3
    ## 2232  02337170 2011-05-12 00:30:00   4870.00            A       18.5
    ## 2233  02337170 2011-05-03 04:45:00   3980.00            X       15.2
    ## 2234  02336240 2011-05-11 17:45:00     11.00            A       24.4
    ## 2235  02336526 2011-05-21 19:15:00      3.50            E       22.7
    ## 2236  02336410 2011-05-24 11:15:00     13.00          A e       21.7
    ## 2237  02336300 2011-05-11 11:00:00     29.00            A       21.5
    ## 2238  02336526 2011-05-06 21:00:00      5.20            A       19.7
    ## 2239  02336410 2011-05-23 18:00:00     13.00            A       23.8
    ## 2240  02203700 2011-05-06 14:45:00      6.10            A       15.6
    ## 2241  02336120 2011-05-02 12:30:00     16.00            E       19.0
    ## 2242  02203655 2011-05-27 07:00:00    111.00            A       21.0
    ## 2243  02336360 2011-05-04 09:15:00     65.00            X       17.5
    ## 2244  02337170 2011-05-24 15:30:00   2790.00            E       20.6
    ## 2245  02337170 2011-05-21 00:30:00   4710.00            X       16.4
    ## 2246  02336313 2011-05-02 23:00:00      0.98            A       23.2
    ## 2247  02336120 2011-05-27 03:45:00    557.00            A       22.9
    ## 2248  02336313 2011-05-05 22:45:00      1.20            E       18.6
    ## 2249  02336360 2011-05-08 20:45:00     13.00            A       19.8
    ## 2250  02336120 2011-05-08 02:45:00     17.00            E       18.6
    ## 2251  02336313 2011-05-11 00:15:00      0.98            E       24.4
    ## 2252  02336410 2011-05-17 23:30:00     16.00            A       16.0
    ## 2253  02203700 2011-05-24 15:00:00      3.70            A       21.7
    ## 2254  02337170 2011-05-21 01:00:00   4690.00            A       16.3
    ## 2255  02336313 2011-05-23 10:30:00      0.93            X       20.4
    ## 2256  02336410 2011-05-13 07:45:00     17.00            E       22.3
    ## 2257  02336240 2011-05-14 09:00:00     10.00            A       20.7
    ## 2258  02337170 2011-05-21 22:00:00   3410.00            E       17.8
    ## 2259 021989773 2011-05-23 23:15:00  49400.00            A       25.3
    ## 2260  02336526 2011-05-18 22:30:00      3.60            A       17.4
    ## 2261  02336300 2011-05-20 10:00:00     25.00            A       17.6
    ## 2262  02337170 2011-05-14 22:45:00   5590.00          A e       15.4
    ## 2263 021989773 2011-05-14 12:15:00  50700.00            A       24.1
    ## 2264  02203655 2011-05-23 12:00:00      7.50            A       20.8
    ## 2265  02336360 2011-05-15 02:45:00     12.00            A       21.3
    ## 2266  02336300 2011-05-16 08:15:00     25.00          A e       17.2
    ## 2267  02336728 2011-05-21 14:45:00      9.70            E       19.5
    ## 2268  02336120 2011-05-05 07:45:00     28.00            E       15.9
    ## 2269  02336526 2011-05-02 04:45:00      4.00            A       21.2
    ## 2270  02203700 2011-05-23 18:15:00      3.90            A       24.4
    ## 2271  02336300 2011-05-25 03:15:00     21.00            A       24.4
    ## 2272  02336120 2011-05-04 14:15:00     80.00            A       16.5
    ## 2273  02336240 2011-05-10 23:30:00     11.00            X       23.5
    ## 2274  02336313 2011-05-19 06:45:00      1.00            X       15.2
    ## 2275  02203700 2011-05-17 18:00:00      4.40          A e       17.0
    ## 2276  02336526 2011-05-27 09:45:00        NA            A       19.6
    ## 2277  02336410 2011-05-06 18:15:00     25.00          A e       17.7
    ## 2278  02337170 2011-05-24 12:30:00   2180.00            A       20.4
    ## 2279  02337170 2011-05-17 22:45:00   3300.00            A       15.0
    ## 2280  02336526 2011-05-03 22:45:00     12.00            A       21.3
    ## 2281  02336410 2011-05-08 11:15:00     21.00            A       17.1
    ## 2282 021989773 2011-05-30 09:00:00 -51500.00            A       26.7
    ## 2283  02336300 2011-05-03 08:45:00     31.00          A e       20.5
    ## 2284  02337170 2011-05-03 14:15:00   5800.00            E       15.4
    ## 2285  02337170 2011-05-26 22:45:00   1710.00            A       21.8
    ## 2286  02336526 2011-05-17 15:30:00      3.80            X       15.4
    ## 2287  02203655 2011-05-25 22:00:00      7.50          A e       23.4
    ## 2288  02336526 2011-05-31 00:45:00      6.40            A       26.7
    ## 2289  02336526 2011-05-28 00:45:00     16.00            E       23.1
    ## 2290  02336313 2011-05-03 01:45:00      1.00            X       22.3
    ## 2291  02336526 2011-05-27 22:30:00     19.00            A       23.6
    ## 2292 021989773 2011-05-08 02:15:00 -71200.00          A e       22.8
    ## 2293  02336526 2011-05-02 05:30:00      4.00          A e       20.9
    ## 2294  02203655 2011-05-06 08:00:00     12.00            X       15.7
    ## 2295  02336526 2011-05-06 16:15:00      5.20            X       15.7
    ## 2296  02336728 2011-05-02 21:30:00     16.00          A e       22.8
    ## 2297  02336240 2011-05-09 20:15:00     12.00            A       22.8
    ## 2298  02203700 2011-05-01 11:45:00      6.40          A e       16.7
    ## 2299  02336300 2011-05-09 09:00:00     32.00            A       19.2
    ## 2300  02336526 2011-05-29 09:00:00      6.70            A       21.4
    ## 2301  02336240 2011-05-29 06:15:00     15.00            E       21.5
    ## 2302  02336526 2011-05-06 05:15:00      5.20            X       16.4
    ## 2303  02336240 2011-05-16 03:30:00     10.00            A       17.5
    ## 2304  02203700 2011-05-17 00:00:00      7.00            E       18.2
    ## 2305  02336526 2011-05-31 11:45:00      4.60          A e       22.5
    ## 2306  02336360 2011-05-08 05:00:00     13.00          A e       18.0
    ## 2307  02336120 2011-05-08 21:45:00     17.00            A       20.4
    ## 2308  02336240 2011-05-05 21:00:00     15.00            E       17.7
    ## 2309  02336360 2011-05-05 21:30:00     16.00            A       18.0
    ## 2310  02336240 2011-05-13 16:15:00     10.00          A e       22.6
    ## 2311  02336410 2011-05-13 13:45:00     17.00            A       21.5
    ## 2312  02336240 2011-05-22 21:45:00      8.50            X       24.8
    ## 2313  02337170 2011-05-17 00:00:00   1880.00            A       16.7
    ## 2314  02203655 2011-05-23 10:00:00      7.20            A       21.3
    ## 2315  02336728 2011-05-27 15:15:00    231.00            X       19.9
    ## 2316  02336313 2011-05-15 08:45:00      0.98            A       18.8
    ## 2317  02336526 2011-05-15 22:00:00      3.80          A e       18.8
    ## 2318  02336526 2011-05-09 10:00:00      4.40            A       18.8
    ## 2319 021989773 2011-05-31 22:45:00 -64300.00            A       27.9
    ## 2320 021989773 2011-05-25 07:30:00 -23600.00            X       25.4
    ## 2321  02336240 2011-05-14 17:15:00     10.00            X       21.5
    ## 2322  02336120 2011-05-02 02:30:00     17.00            A       20.8
    ## 2323  02336728 2011-05-26 22:15:00      8.20            A       24.7
    ## 2324  02336313 2011-05-08 19:00:00      1.10            E       21.1
    ## 2325  02203700 2011-05-07 16:30:00      5.60            X       18.4
    ## 2326  02336526 2011-05-01 06:30:00      4.20            E       19.4
    ## 2327 021989773 2011-05-08 21:45:00  71400.00            E       23.0
    ## 2328  02203700 2011-05-06 03:30:00      5.80            A       17.5
    ## 2329  02336120 2011-05-12 17:00:00     14.00          A e       22.7
    ## 2330 021989773 2011-05-19 16:00:00  28000.00            A       23.3
    ## 2331  02203655 2011-05-18 06:00:00      9.20          A e       15.4
    ## 2332  02336300 2011-05-20 23:15:00     24.00            A       23.1
    ## 2333  02337170 2011-05-30 21:00:00   1280.00          A e       25.1
    ## 2334  02336120 2011-05-22 22:00:00     11.00          A e       25.1
    ## 2335  02336120 2011-05-05 09:00:00     27.00            E       15.5
    ## 2336  02203700 2011-05-04 19:30:00     25.00            A       20.8
    ## 2337  02203655 2011-05-23 17:00:00      7.80            X       22.0
    ## 2338  02337170 2011-05-10 23:30:00   4300.00            X       21.0
    ## 2339  02336120 2011-05-31 23:15:00     12.00          A e       26.9
    ## 2340  02336360 2011-05-03 02:30:00     13.00          A e       21.4
    ## 2341  02337170 2011-05-24 23:15:00   2170.00            A       20.6
    ## 2342  02336526 2011-05-02 06:30:00      4.00            A       20.6
    ## 2343  02336728 2011-05-15 00:30:00     12.00            A       21.9
    ## 2344  02337170 2011-05-12 17:30:00   6440.00            X       15.0
    ## 2345  02336360 2011-05-02 09:30:00     13.00            A       19.5
    ## 2346  02203700 2011-05-25 15:30:00      3.70            A       22.0
    ## 2347  02336240 2011-05-01 13:45:00     13.00            X       17.6
    ## 2348  02337170 2011-05-31 19:00:00   1260.00            A       25.0
    ## 2349  02336120 2011-05-08 09:00:00     17.00            A       17.3
    ## 2350  02336410 2011-05-28 21:15:00     24.00            A       24.4
    ## 2351  02336728 2011-05-26 21:45:00      7.80            A       25.0
    ## 2352  02337170 2011-05-21 08:30:00   3180.00            A       15.0
    ## 2353  02336410 2011-05-26 16:30:00     11.00            A       23.3
    ## 2354  02336728 2011-05-31 04:30:00     13.00            A       23.7
    ## 2355  02336360 2011-05-18 22:15:00     10.00          A e       17.4
    ## 2356  02336728 2011-05-16 00:30:00     12.00            A       18.3
    ## 2357 021989773 2011-05-23 13:30:00 -21000.00            A       24.6
    ## 2358  02336240 2011-05-30 01:30:00     13.00            E       24.0
    ## 2359  02336120 2011-05-25 23:15:00      9.90            X       25.7
    ## 2360  02336313 2011-05-13 04:00:00      0.98          A e       23.0
    ## 2361  02336240 2011-05-09 20:30:00     12.00            A       22.8
    ## 2362  02337170 2011-05-27 09:45:00   3550.00          A e       20.7
    ## 2363  02337170 2011-05-02 21:15:00   5010.00          A e       17.2
    ## 2364  02336728 2011-05-13 17:00:00     12.00          A e       23.4
    ## 2365  02203700 2011-05-22 21:00:00      3.90            E       26.2
    ## 2366  02336728 2011-05-15 22:30:00     11.00          A e       18.9
    ## 2367  02336240 2011-05-31 07:15:00     11.00          A e       23.2
    ## 2368  02336313 2011-05-24 02:00:00        NA          A e       23.8
    ## 2369 021989773 2011-05-27 13:00:00  56300.00            X       25.8
    ## 2370  02336313 2011-05-07 15:45:00      1.10            A       17.9
    ## 2371  02336120 2011-05-03 03:15:00     16.00          A e       21.2
    ## 2372  02336526 2011-05-31 12:30:00      4.80            A       22.5
    ## 2373  02336728 2011-05-26 12:00:00      7.80            X       21.2
    ## 2374  02203700 2011-05-11 14:15:00      4.60            X       21.0
    ## 2375  02336526 2011-05-26 17:15:00      2.80          A e       23.4
    ## 2376  02336120 2011-05-31 07:15:00     12.00            X       24.0
    ## 2377 021989773 2011-05-21 17:15:00   6810.00          A e       23.7
    ## 2378  02203700 2011-05-18 19:30:00      4.20            X       18.4
    ## 2379  02336360 2011-05-20 09:15:00     10.00            A       17.3
    ## 2380  02336300 2011-05-22 09:15:00     23.00            A       21.2
    ## 2381  02336360 2011-05-20 16:15:00      9.80            A       18.4
    ## 2382  02336360 2011-05-12 22:00:00     11.00            X       25.3
    ## 2383  02336300 2011-05-13 15:30:00     26.00            E       22.5
    ## 2384  02336728 2011-05-25 05:30:00      8.60          A e       22.2
    ## 2385  02336240 2011-05-13 19:30:00     11.00            X       24.7
    ## 2386  02336313 2011-05-22 11:45:00      1.30            E       19.3
    ## 2387  02336120 2011-05-03 18:15:00     17.00            A       21.6
    ## 2388  02336313 2011-05-23 04:00:00      0.87            A       23.0
    ## 2389  02336360 2011-05-03 11:15:00     13.00            A       19.9
    ## 2390 021989773 2011-05-26 20:15:00 -42000.00            E       26.6
    ## 2391  02336120 2011-05-20 21:15:00     13.00            A       21.8
    ## 2392  02336360 2011-05-16 07:45:00     11.00            A       17.4
    ## 2393  02336240 2011-05-31 07:45:00     11.00          A e       23.1
    ## 2394  02203700 2011-05-09 13:45:00      4.90            A       18.5
    ## 2395  02336120 2011-05-21 03:00:00     12.00            A       20.8
    ## 2396  02336360 2011-05-19 14:45:00     10.00            A       15.1
    ## 2397  02336360 2011-05-14 07:00:00     11.00            A       21.6
    ## 2398  02336728 2011-05-26 14:30:00      7.80            E       21.6
    ## 2399  02336120 2011-05-14 04:30:00     13.00            A       22.0
    ## 2400  02203700 2011-05-17 17:30:00        NA            E       16.9
    ## 2401  02336410 2011-05-14 12:30:00     17.00            E       21.0
    ## 2402  02203700 2011-05-09 06:45:00      4.90            E       19.1
    ## 2403  02336360 2011-05-15 18:45:00     10.00            A       19.4
    ## 2404 021989773 2011-05-22 22:45:00  44500.00            A       24.9
    ## 2405 021989773 2011-05-29 01:45:00  61300.00            A       26.6
    ## 2406  02203700 2011-05-02 01:00:00      6.10            A       21.9
    ## 2407  02336526 2011-05-29 03:15:00      6.90            A       23.9
    ## 2408  02203700 2011-05-19 00:15:00      4.00            A       18.1
    ## 2409 021989773 2011-05-23 13:15:00 -11700.00            E       24.5
    ## 2410  02203700 2011-05-05 22:00:00      6.10            A       20.4
    ## 2411  02336410 2011-05-07 19:00:00     22.00            A       19.1
    ## 2412  02336240 2011-05-30 19:15:00     12.00            X       26.0
    ## 2413  02336360 2011-05-31 09:45:00      6.00            E       23.7
    ## 2414  02336728 2011-05-17 12:15:00     12.00            A       15.3
    ## 2415  02336728 2011-05-21 00:45:00     10.00            A       21.5
    ## 2416  02203700 2011-05-03 00:15:00      6.10            A       22.6
    ## 2417  02336728 2011-05-21 23:00:00     10.00            A       23.9
    ## 2418  02203700 2011-05-06 19:00:00      5.60          A e       20.6
    ## 2419 021989773 2011-05-20 07:15:00  77600.00          A e       23.2
    ## 2420  02336728 2011-05-04 18:15:00     47.00          A e       18.1
    ## 2421  02336120 2011-05-11 05:15:00     15.00            X       22.2
    ## 2422  02336240 2011-05-02 22:15:00     13.00            E       21.9
    ## 2423  02336120 2011-05-08 10:15:00     17.00            X       17.1
    ## 2424  02337170 2011-05-21 07:00:00   3580.00            X       15.0
    ## 2425  02336728 2011-05-26 02:45:00      8.20            X       23.8
    ## 2426  02203655 2011-05-04 18:00:00     26.00            X       17.5
    ## 2427  02203700 2011-05-02 12:45:00      6.10            A       18.2
    ## 2428  02336120 2011-05-22 23:30:00     11.00            A       24.9
    ## 2429  02336526 2011-05-26 05:30:00      3.50            A       23.7
    ## 2430  02336240 2011-05-15 05:15:00      9.90          A e       20.0
    ## 2431  02337170 2011-05-09 14:00:00   1370.00            A       18.2
    ## 2432  02336410 2011-05-21 09:45:00     14.00          A e       19.4
    ## 2433  02336526 2011-05-21 00:45:00      3.60          A e       22.5
    ## 2434  02336313 2011-05-05 23:15:00      1.20            X       18.5
    ## 2435  02336526 2011-05-10 22:00:00      6.40            A       25.9
    ## 2436  02203655 2011-05-05 05:15:00     18.00            A       16.8
    ## 2437  02337170 2011-05-04 07:30:00   6340.00            A       15.2
    ## 2438  02336728 2011-05-03 06:45:00     15.00          A e       19.9
    ## 2439  02336526 2011-05-29 16:45:00      5.90          A e       22.7
    ## 2440  02336360 2011-05-02 18:30:00        NA            E       21.5
    ## 2441  02336728 2011-05-19 21:30:00     11.00          A e       20.0
    ## 2442  02336300 2011-05-14 21:45:00     26.00            X       24.0
    ## 2443 021989773 2011-05-18 14:30:00 -16500.00            A       23.1
    ## 2444  02336410 2011-05-26 09:30:00     11.00            A       23.0
    ## 2445  02336410 2011-05-17 12:00:00     16.00          A e       15.5
    ## 2446  02336313 2011-05-14 23:00:00      0.98            A       22.2
    ## 2447  02203655 2011-05-25 22:15:00      7.50            A       23.4
    ## 2448  02336526 2011-05-13 06:15:00      3.60            X       23.1
    ## 2449  02337170 2011-05-21 08:15:00   3240.00            A       15.0
    ## 2450  02336300 2011-05-25 00:30:00        NA            A       25.6
    ## 2451 021989773 2011-05-28 01:30:00  49900.00            A       26.2
    ## 2452  02336410 2011-05-01 12:15:00     22.00            A       18.2
    ## 2453  02337170 2011-05-31 16:45:00   1270.00            A       24.2
    ## 2454  02336410 2011-05-09 21:00:00     20.00            A       22.2
    ## 2455  02203700 2011-05-17 00:15:00      7.00            A       18.1
    ## 2456  02336526 2011-05-29 03:00:00      6.90            A       24.0
    ## 2457  02336526 2011-05-14 23:45:00      3.80            A       23.3
    ## 2458  02336313 2011-05-23 10:15:00      0.93            A       20.5
    ## 2459  02336728 2011-05-29 04:00:00     24.00            A       21.9
    ## 2460  02336313 2011-05-21 04:00:00      0.93          A e       20.5
    ## 2461  02203655 2011-05-22 15:30:00      8.50            E       20.4
    ## 2462  02336240 2011-05-31 19:30:00     11.00            A       26.6
    ## 2463  02336728 2011-05-30 13:00:00     15.00          A e       22.9
    ## 2464  02336240 2011-05-06 00:30:00     14.00            E       16.8
    ## 2465  02336313 2011-05-17 16:00:00      1.10            X       16.3
    ## 2466  02337170 2011-05-17 19:45:00   2950.00            A       15.3
    ## 2467  02336120 2011-05-14 00:15:00     13.00            X       23.2
    ## 2468  02336300 2011-05-20 16:15:00     24.00            A       19.3
    ## 2469 021989773 2011-05-24 00:00:00  34400.00            A       25.2
    ## 2470 021989773 2011-05-02 17:00:00  58300.00          A e       23.8
    ## 2471  02203655 2011-05-21 06:15:00      7.80            X       20.0
    ## 2472 021989773 2011-05-09 18:00:00 -18700.00            X       22.9
    ## 2473  02336410 2011-05-31 04:15:00     13.00            X       24.8
    ## 2474  02336526 2011-05-23 05:00:00      4.20            A       23.5
    ## 2475  02336526 2011-05-11 19:15:00      4.00          A e       24.9
    ## 2476  02336300 2011-05-17 05:15:00     27.00            A       16.7
    ## 2477  02336240 2011-05-10 01:30:00     11.00            A       21.5
    ## 2478  02336728 2011-05-24 12:30:00      8.90            A       20.6
    ## 2479  02336526 2011-05-15 00:45:00      3.80            X       23.0
    ## 2480  02336240 2011-05-21 21:15:00      9.20            A       23.5
    ## 2481  02336300 2011-05-16 02:00:00     27.00            A       18.2
    ## 2482  02336313 2011-05-31 23:15:00      0.65            E       26.6
    ## 2483  02336300 2011-05-24 19:30:00     20.00            A       26.0
    ## 2484  02203700 2011-05-23 20:15:00      3.70            A       25.6
    ## 2485  02336728 2011-05-23 09:45:00      8.90            E       20.5
    ## 2486  02336410 2011-05-17 14:45:00     16.00          A e       15.5
    ## 2487  02337170 2011-05-04 06:45:00   6130.00            E       15.2
    ## 2488  02336410 2011-05-24 16:00:00     13.00            A       22.5
    ## 2489 021989773 2011-05-11 19:45:00 -45900.00            E       23.7
    ## 2490  02336526 2011-05-24 17:45:00      3.10            A       23.3
    ## 2491  02336300 2011-05-25 23:30:00     19.00            A       26.6
    ## 2492  02336526 2011-05-24 14:45:00      3.10            X       21.6
    ## 2493  02336120 2011-05-23 17:15:00     11.00            A       22.5
    ## 2494  02336120 2011-05-06 02:15:00     21.00          A e       17.0
    ## 2495 021989773 2011-05-30 14:00:00  75500.00            E       26.9
    ## 2496 021989773 2011-05-07 19:45:00  82300.00            E       23.0
    ## 2497  02203655 2011-05-28 19:45:00     17.00            A       22.1
    ## 2498  02336728 2011-05-18 03:15:00     11.00            A       15.2
    ## 2499  02336360 2011-05-05 22:45:00     16.00            E       18.0
    ## 2500  02336240 2011-05-17 06:45:00     11.00          A e       15.7
    ## 2501  02336120 2011-05-14 21:00:00     13.00            E       22.7
    ## 2502  02336240 2011-05-12 02:45:00     11.00            A       22.9
    ## 2503  02336728 2011-05-14 16:15:00     12.00            X       21.4
    ## 2504  02336313 2011-05-05 19:15:00        NA            A       18.2
    ## 2505 021989773 2011-05-11 03:15:00 -54800.00            A       23.1
    ## 2506  02336526 2011-05-31 07:00:00      5.20            A       24.2
    ## 2507  02203700 2011-05-04 19:45:00     26.00            A       20.8
    ## 2508  02336240 2011-05-01 06:45:00     13.00            X       18.1
    ## 2509  02336300 2011-05-06 09:45:00     41.00            A       15.1
    ## 2510  02203700 2011-05-06 03:15:00      5.80            A       17.6
    ## 2511  02336526 2011-05-01 07:00:00        NA            E       19.1
    ## 2512  02203700 2011-05-05 14:00:00     22.00            E       16.6
    ## 2513  02336410 2011-05-08 00:00:00     22.00            A       19.0
    ## 2514  02336728 2011-05-27 22:45:00     74.00            E       22.1
    ## 2515  02336360 2011-05-24 14:30:00      8.70            X       21.5
    ## 2516  02336360 2011-05-25 07:00:00      8.70            A       22.7
    ## 2517  02336728 2011-05-24 18:45:00      8.90            A       24.7
    ## 2518 021989773 2011-05-15 01:15:00  62000.00            A       24.3
    ## 2519  02203700 2011-05-14 09:00:00      4.20          A e       20.6
    ## 2520  02336360 2011-05-01 06:00:00     14.00            E       19.1
    ## 2521  02336120 2011-05-27 01:45:00    437.00            E       22.6
    ## 2522  02336240 2011-05-08 22:30:00     12.00            A       20.3
    ## 2523  02336526 2011-05-09 07:15:00      4.20          A e       19.8
    ## 2524  02336300 2011-05-12 17:45:00     27.00            E       24.6
    ## 2525 021989773 2011-05-25 04:15:00 -49400.00            X       25.3
    ## 2526  02336526 2011-05-16 14:00:00      3.80            E       16.4
    ## 2527  02336120 2011-05-15 19:45:00     13.00            A       19.1
    ## 2528  02336120 2011-05-10 15:00:00     15.00          A e       20.3
    ## 2529  02203700 2011-05-14 16:15:00      4.40            X       21.4
    ## 2530  02336360 2011-05-23 01:00:00      9.80            X       24.0
    ## 2531  02336300 2011-05-02 16:30:00     31.00            X       20.7
    ## 2532  02336120 2011-05-07 18:45:00     18.00            A       18.3
    ## 2533  02337170 2011-05-20 17:30:00   2520.00            A       15.8
    ## 2534  02336120 2011-05-27 11:45:00   1030.00            A       20.6
    ## 2535  02336526 2011-05-22 07:45:00      3.50            A       21.7
    ## 2536  02336240 2011-05-17 16:00:00     11.00            A       15.5
    ## 2537  02336300 2011-05-07 03:15:00     39.00            X       17.3
    ## 2538  02336410 2011-05-05 04:00:00     42.00          A e       17.5
    ## 2539  02203655 2011-05-20 23:45:00      8.50            A       20.3
    ## 2540  02336526 2011-05-10 21:00:00      6.40            E       25.4
    ## 2541  02336526 2011-05-27 14:30:00     55.00            A       20.1
    ## 2542  02336728 2011-05-27 12:15:00    894.00          A e       19.6
    ## 2543  02336728 2011-05-03 01:15:00     15.00          A e       21.0
    ## 2544  02337170 2011-05-20 23:45:00   4710.00            X       16.6
    ## 2545  02337170 2011-05-20 15:30:00   2290.00            E       15.0
    ## 2546  02336313 2011-05-30 21:45:00      0.73            A       26.4
    ## 2547  02336728 2011-05-15 15:30:00     11.00            X       19.3
    ## 2548  02336728 2011-05-25 12:15:00      8.20            A       20.5
    ## 2549  02203700 2011-05-01 08:45:00      6.10            X       17.6
    ## 2550  02336728 2011-05-27 05:45:00    195.00            A       22.3
    ## 2551  02203700 2011-05-08 18:30:00      5.60            A       21.7
    ## 2552  02336300 2011-05-11 19:15:00     30.00            A       25.5
    ## 2553  02336120 2011-05-28 19:30:00        NA          A e       24.2
    ## 2554  02336526 2011-05-28 17:30:00      8.90            A       22.5
    ## 2555  02336300 2011-05-15 00:00:00     26.00            A       23.0
    ## 2556  02336360 2011-05-08 13:30:00     13.00            A       16.7
    ## 2557  02336300 2011-05-15 06:00:00     27.00            E       20.6
    ## 2558  02336240 2011-05-18 00:00:00     11.00            E       15.7
    ## 2559  02337170 2011-05-17 16:00:00   2510.00            E       15.9
    ## 2560  02336360 2011-05-27 04:15:00        NA            A       22.3
    ## 2561  02336240 2011-05-25 04:30:00      7.90            E       22.8
    ## 2562  02336360 2011-05-30 08:00:00      6.90            E       23.7
    ## 2563  02336360 2011-05-06 11:00:00     15.00            E       15.1
    ## 2564 021989773 2011-05-15 16:15:00  66000.00            A       24.3
    ## 2565 021989773 2011-05-18 20:15:00  38200.00            A       23.6
    ## 2566  02336120 2011-05-06 19:30:00     19.00            X       18.1
    ## 2567  02336526 2011-05-05 03:45:00      6.90            A       16.9
    ## 2568  02336728 2011-05-21 21:45:00     10.00          A e       24.2
    ## 2569  02336300 2011-05-20 05:45:00     25.00            E       18.3
    ## 2570  02337170 2011-05-14 21:45:00   5610.00            A       15.7
    ## 2571  02336410 2011-05-25 07:45:00     13.00            A       22.5
    ## 2572  02336120 2011-05-12 12:00:00     14.00            A       21.3
    ## 2573  02336313 2011-05-29 01:45:00      0.77            A       23.9
    ## 2574  02336300 2011-05-01 14:00:00     32.00            E       18.4
    ## 2575  02336240 2011-05-22 11:15:00      8.90          A e       19.6
    ## 2576  02336313 2011-05-07 23:15:00      0.98            A       20.4
    ## 2577  02337170 2011-05-30 08:45:00   1400.00            A       23.1
    ## 2578  02336360 2011-05-26 10:00:00      8.40            A       22.8
    ## 2579  02203700 2011-05-02 10:30:00      5.80            A       18.5
    ## 2580 021989773 2011-05-12 04:00:00        NA          A e       23.4
    ## 2581 021989773 2011-05-17 19:30:00  39100.00            A       23.8
    ## 2582  02203655 2011-05-06 08:15:00     12.00            X       15.6
    ## 2583  02336313 2011-05-10 23:45:00      0.98            A       24.6
    ## 2584  02336300 2011-05-25 02:45:00     20.00            A       24.6
    ## 2585  02336313 2011-05-15 04:15:00      0.93            E       20.8
    ## 2586 021989773 2011-05-25 01:15:00  28600.00            A       25.5
    ## 2587  02336410 2011-05-03 21:00:00        NA            A       22.0
    ## 2588  02336313 2011-06-01 00:30:00      0.65            X       26.4
    ## 2589  02336300 2011-05-24 00:45:00     21.00          A e       25.0
    ## 2590  02336240 2011-05-01 07:30:00     13.00            A       18.0
    ## 2591  02337170 2011-05-23 19:15:00   1730.00            A       21.9
    ## 2592  02336313 2011-05-01 21:00:00      1.00          A e       22.7
    ## 2593  02336360 2011-05-31 07:00:00      6.30          A e       24.2
    ## 2594  02336240 2011-05-05 23:00:00     15.00          A e       17.2
    ## 2595  02336410 2011-05-30 18:30:00     14.00            A       25.8
    ## 2596  02336300 2011-05-06 22:15:00     37.00          A e       18.9
    ## 2597  02336360 2011-05-12 13:00:00     11.00            E       21.2
    ## 2598  02203700 2011-05-06 08:45:00      5.60            X       15.0
    ## 2599  02336120 2011-05-25 19:45:00      9.90            X       24.6
    ## 2600  02336360 2011-05-26 08:00:00      8.40            A       23.2
    ## 2601  02336526 2011-05-12 11:00:00      3.80            E       21.3
    ## 2602  02336120 2011-05-27 21:00:00     88.00            A       22.6
    ## 2603  02203655 2011-05-25 20:45:00      7.50            E       23.4
    ## 2604  02203700 2011-05-17 03:15:00      5.30            A       16.9
    ## 2605  02336120 2011-05-20 11:30:00     12.00            A       16.9
    ## 2606  02336300 2011-05-20 04:45:00     24.00            E       18.5
    ## 2607  02336240 2011-05-14 21:45:00     10.00            X       22.6
    ## 2608  02336120 2011-05-01 11:30:00     17.00          A e       18.1
    ## 2609  02203700 2011-05-23 11:15:00      3.70            E       20.1
    ## 2610  02337170 2011-05-26 05:15:00   1750.00            X       20.3
    ## 2611  02203700 2011-05-25 01:00:00      3.70            A       24.5
    ## 2612  02336728 2011-05-16 03:30:00     11.00            A       17.6
    ## 2613  02336526 2011-05-12 03:15:00      3.60            X       24.6
    ## 2614  02203700 2011-05-20 17:15:00      4.00            A       20.6
    ## 2615 021989773 2011-05-16 07:15:00  20500.00            X       23.9
    ## 2616  02336120 2011-05-26 02:30:00     11.00            A       24.7
    ## 2617  02336240 2011-05-02 01:30:00        NA            A       20.4
    ## 2618  02336410 2011-05-20 03:45:00     15.00            A       18.2
    ## 2619  02336410 2011-05-29 09:00:00     19.00            E       22.5
    ## 2620  02336728 2011-05-25 16:00:00      8.20            A       22.6
    ## 2621  02203700 2011-05-06 01:00:00      5.60            X       18.8
    ## 2622  02203655 2011-05-06 03:00:00     13.00            E       17.6
    ## 2623  02336360 2011-05-26 21:15:00      8.40          A e       25.6
    ## 2624  02203700 2011-05-24 16:45:00      3.90            E       23.3
    ## 2625  02203700 2011-05-20 04:15:00      4.00            X       18.8
    ## 2626  02336526 2011-05-09 16:00:00        NA            E       19.7
    ## 2627  02336728 2011-05-26 18:15:00      7.80            X       24.4
    ## 2628  02336360 2011-05-29 20:00:00      7.80            E       25.6
    ## 2629  02203655 2011-05-24 07:00:00      7.50            X       22.4
    ## 2630  02203700 2011-05-10 17:15:00      4.90          A e       23.4
    ## 2631  02336300 2011-05-19 09:30:00     26.00            A       15.4
    ## 2632  02336240 2011-05-16 22:00:00     11.00            E       17.7
    ## 2633 021989773 2011-05-21 04:45:00 -39400.00          A e       23.7
    ## 2634  02336526 2011-05-05 01:15:00      7.40            A       18.3
    ## 2635  02336300 2011-05-20 18:45:00     25.00            A       21.8
    ## 2636  02336410 2011-05-14 11:00:00     17.00            A       21.1
    ## 2637  02336526 2011-05-13 19:15:00      3.60            A       24.0
    ## 2638  02336313 2011-05-06 01:00:00      1.20            E       17.7
    ## 2639  02336120 2011-05-02 22:15:00     17.00            E       22.2
    ## 2640  02336410 2011-05-21 16:30:00     14.00            A       20.5
    ## 2641  02336410 2011-05-31 14:45:00     12.00            A       23.7
    ## 2642  02336360 2011-05-30 22:15:00      6.60            A       27.1
    ## 2643  02336526 2011-05-13 00:15:00      3.80            E       25.8
    ## 2644  02336526 2011-05-09 09:45:00      4.40            A       18.9
    ## 2645 021989773 2011-05-05 01:00:00 -61800.00            E       23.8
    ## 2646  02337170 2011-05-09 00:00:00   1400.00            A       18.7
    ## 2647  02336410 2011-05-23 23:00:00     14.00          A e       24.5
    ## 2648  02336300 2011-05-16 15:00:00     26.00            X       16.8
    ## 2649  02336360 2011-05-14 08:15:00     11.00            A       21.4
    ## 2650  02337170 2011-05-30 12:45:00   1360.00            A       22.6
    ## 2651  02203700 2011-05-22 20:15:00      3.90          A e       26.0
    ## 2652  02336313 2011-05-10 21:45:00      0.98            A       25.0
    ## 2653  02336313 2011-05-24 11:15:00      0.93          A e       20.6
    ## 2654  02203655 2011-05-03 07:45:00     10.00            A       20.4
    ## 2655  02336120 2011-05-17 02:30:00     13.00            A       17.2
    ## 2656  02336360 2011-05-11 00:15:00     12.00            A       23.8
    ## 2657 021989773 2011-05-09 12:00:00   1200.00          A e       22.4
    ## 2658  02336526 2011-05-19 01:15:00      3.80            A       17.4
    ## 2659  02336360 2011-05-03 13:30:00     13.00            A       19.8
    ## 2660  02336300 2011-05-17 02:15:00     28.00            X       17.3
    ## 2661  02336410 2011-05-25 04:45:00     12.00            A       23.2
    ## 2662  02336120 2011-05-30 21:15:00     14.00            A       26.6
    ## 2663  02336526 2011-05-04 22:30:00      8.30            E       19.9
    ## 2664  02203655 2011-05-31 04:30:00      9.20            E       24.8
    ## 2665  02336360 2011-05-17 06:00:00     11.00            X       16.4
    ## 2666 021989773 2011-05-11 17:00:00 -82500.00            X       23.5
    ## 2667  02336410 2011-05-26 05:00:00     11.00            A       23.7
    ## 2668  02337170 2011-05-27 12:30:00   5540.00            A       20.7
    ## 2669  02203655 2011-05-02 02:45:00     11.00            E       21.0
    ## 2670  02336313 2011-05-24 08:00:00      0.93          A e       21.6
    ## 2671  02336360 2011-05-26 17:30:00      8.10            A       24.3
    ## 2672  02336360 2011-05-20 15:00:00     10.00          A e       17.4
    ## 2673  02336120 2011-05-02 22:45:00     17.00          A e       22.2
    ## 2674  02336300 2011-05-14 00:00:00     27.00            X       23.8
    ## 2675  02336360 2011-05-07 22:00:00     13.00            A       19.6
    ## 2676  02336313 2011-05-08 02:45:00      1.00          A e       18.9
    ## 2677  02336240 2011-05-11 11:30:00     11.00            A       20.5
    ## 2678 021989773 2011-05-27 17:00:00 -31500.00            A       26.5
    ## 2679  02336360 2011-05-18 04:30:00     11.00            A       15.1
    ## 2680  02336300 2011-05-08 10:00:00     34.00          A e       17.1
    ## 2681  02336410 2011-05-23 09:30:00     14.00          A e       21.8
    ## 2682  02336120 2011-05-16 04:45:00     13.00            A       17.7
    ## 2683  02336120 2011-05-21 18:00:00     12.00            A       20.9
    ## 2684 021989773 2011-05-14 19:00:00 -60600.00            A       24.3
    ## 2685  02336240 2011-05-23 13:30:00      8.50            A       20.6
    ## 2686  02337170 2011-05-29 16:15:00   1590.00          A e       21.7
    ## 2687  02336120 2011-05-17 18:45:00     14.00            E       16.3
    ## 2688  02336360 2011-05-31 07:15:00      6.30            X       24.2
    ## 2689  02336728 2011-05-27 03:30:00    333.00            E       22.5
    ## 2690  02336360 2011-05-26 07:30:00      8.40            A       23.2
    ## 2691  02336410 2011-05-08 05:15:00     22.00          A e       18.2
    ## 2692  02336120 2011-05-09 14:45:00     16.00            X       18.9
    ## 2693  02336300 2011-05-25 05:00:00     20.00            A       23.8
    ## 2694  02336120 2011-05-26 16:15:00      8.90            A       23.1
    ## 2695  02336410 2011-05-30 20:45:00     13.00            A       26.5
    ## 2696  02336526 2011-05-16 21:45:00      4.80            A       18.3
    ## 2697  02336300 2011-05-24 12:30:00     21.00            A       21.9
    ## 2698  02336300 2011-05-11 09:30:00     30.00            A       21.8
    ## 2699  02336240 2011-05-03 05:45:00     12.00            A       20.0
    ## 2700 021989773 2011-05-29 22:45:00 -41900.00            X       27.1
    ## 2701 021989773 2011-05-28 03:45:00  35100.00            A       26.0
    ## 2702  02337170 2011-05-17 22:00:00   3240.00            E       15.1
    ## 2703  02203700 2011-05-14 16:45:00      4.60            E       21.7
    ## 2704  02336120 2011-05-22 20:00:00     11.00            A       23.9
    ## 2705 021989773 2011-05-04 08:45:00  24100.00            A       23.4
    ## 2706  02336300 2011-05-13 00:30:00     27.00            A       25.0
    ## 2707  02336120 2011-05-21 23:15:00     12.00            A       23.5
    ## 2708  02203700 2011-05-15 19:00:00      4.60            X       19.2
    ## 2709  02336526 2011-05-27 18:15:00     29.00          A e       21.8
    ## 2710  02336300 2011-05-09 00:30:00     32.00            A       20.7
    ## 2711 021989773 2011-05-22 07:30:00  88300.00            X       23.9
    ## 2712  02336526 2011-05-23 20:15:00      3.30            A       24.7
    ## 2713  02336360 2011-05-15 23:45:00     11.00            E       18.6
    ## 2714  02336360 2011-05-12 23:45:00        NA            A       24.6
    ## 2715  02336300 2011-05-19 02:45:00     28.00          A e       16.7
    ## 2716  02336120 2011-05-04 05:45:00    684.00            E       18.1
    ## 2717  02337170 2011-05-15 09:45:00   2630.00            X       15.0
    ## 2718 021989773 2011-05-11 21:00:00 -24100.00            E       23.7
    ## 2719  02336526 2011-05-02 21:30:00      4.20            A       23.5
    ## 2720  02336313 2011-05-18 04:30:00      1.00            E       15.2
    ## 2721  02336360 2011-05-16 04:30:00     11.00            A       17.8
    ## 2722  02336360 2011-05-05 00:45:00     23.00            A       18.6
    ## 2723  02336410 2011-05-07 11:45:00     22.00            A       15.7
    ## 2724  02336120 2011-05-29 23:15:00     16.00            A       25.8
    ## 2725  02203655 2011-05-22 01:45:00      8.20          A e       21.8
    ## 2726  02336120 2011-05-17 12:30:00     14.00            X       15.3
    ## 2727  02336120 2011-05-10 04:45:00     16.00            A       21.0
    ## 2728  02336728 2011-05-02 18:15:00     16.00            E       22.1
    ## 2729 021989773 2011-05-30 04:30:00  57600.00            E       27.0
    ## 2730  02336300 2011-05-07 13:00:00     36.00            A       15.4
    ## 2731  02337170 2011-05-12 16:15:00   6010.00            X       15.3
    ## 2732  02203700 2011-05-25 18:00:00      3.70            A       24.5
    ## 2733 021989773 2011-05-01 13:15:00  24900.00            A       23.6
    ## 2734  02337170 2011-05-10 21:00:00   4180.00            A       20.9
    ## 2735  02203700 2011-05-03 07:45:00      6.10            E       19.6
    ## 2736  02336410 2011-05-28 21:30:00     24.00            E       24.4
    ## 2737  02336240 2011-05-30 13:45:00     12.00            E       22.4
    ## 2738  02336526 2011-05-31 14:30:00      4.60            A       22.9
    ## 2739  02336313 2011-05-25 00:30:00      0.87            A       24.5
    ## 2740  02336728 2011-05-27 15:30:00    212.00            X       20.0
    ## 2741  02203655 2011-05-07 16:30:00     11.00            A       16.6
    ## 2742  02336360 2011-05-09 04:00:00     12.00            A       19.6
    ## 2743  02336360 2011-05-07 04:30:00     14.00            A       17.3
    ## 2744  02336410 2011-05-17 01:30:00     16.00            A       17.3
    ## 2745  02336300 2011-05-17 04:00:00     27.00            A       16.9
    ## 2746 021989773 2011-05-10 01:15:00 -21000.00            X       22.9
    ## 2747  02336410 2011-05-16 07:45:00     16.00            A       17.4
    ## 2748  02337170 2011-05-12 10:45:00   4050.00          A e       16.3
    ## 2749  02336313 2011-05-20 05:00:00      0.98            E       18.1
    ## 2750  02336240 2011-05-19 18:30:00      9.90            A       19.7
    ## 2751  02203655 2011-05-31 21:45:00      9.20            X       24.4
    ## 2752  02336240 2011-05-09 14:45:00     12.00            A       19.0
    ## 2753  02336120 2011-05-15 13:45:00     13.00            A       18.7
    ## 2754  02336300 2011-05-11 06:00:00     30.00            X       22.7
    ## 2755  02336360 2011-05-19 02:45:00     10.00            A       16.2
    ## 2756  02203655 2011-05-06 20:45:00     12.00            A       17.3
    ## 2757  02203700 2011-05-20 23:45:00      5.60            A       22.9
    ## 2758  02336240 2011-05-04 12:45:00     53.00            A       15.8
    ## 2759  02336728 2011-05-04 04:15:00    363.00            X       18.5
    ## 2760  02336300 2011-05-03 02:30:00     31.00            A       21.7
    ## 2761  02336313 2011-05-22 06:30:00      0.93            A       20.9
    ## 2762  02203655 2011-05-07 14:45:00     11.00            X       15.5
    ## 2763  02337170 2011-05-27 02:30:00   1710.00            E       21.0
    ## 2764  02337170 2011-05-29 01:30:00   2520.00            A       21.6
    ## 2765  02336526 2011-05-07 02:45:00      4.80            A       18.7
    ## 2766  02336526 2011-05-14 17:45:00      3.80            E       21.9
    ## 2767  02336360 2011-05-17 05:00:00     11.00            A       16.5
    ##      pH_Inst DO_Inst
    ## 1        7.2     8.1
    ## 2        7.2     7.1
    ## 3        6.9     7.6
    ## 4          7     6.2
    ## 5        7.1     7.6
    ## 6        7.2     8.1
    ## 7        7.3     8.5
    ## 8        7.3     7.5
    ## 9        6.6     7.6
    ## 10       6.4     7.2
    ## 11       7.2     7.8
    ## 12       7.1     8.3
    ## 13       7.1     7.5
    ## 14       6.2     7.1
    ## 15         7     7.5
    ## 16       7.1     7.6
    ## 17       7.2     9.4
    ## 18         7     9.0
    ## 19       7.2     8.4
    ## 20       7.1     7.0
    ## 21       6.8     7.7
    ## 22       7.1     7.5
    ## 23       7.4     5.8
    ## 24       7.6     7.7
    ## 25       7.2     8.4
    ## 26       7.4     5.7
    ## 27       7.2     7.2
    ## 28       7.3      NA
    ## 29       7.2     8.9
    ## 30       6.9     5.9
    ## 31       6.8     7.8
    ## 32       7.5     7.6
    ## 33       7.3     5.6
    ## 34       6.9     6.7
    ## 35      <NA>     7.8
    ## 36       6.8     4.2
    ## 37         7     7.7
    ## 38       7.3      NA
    ## 39       7.5     6.9
    ## 40       7.1     8.0
    ## 41       7.1     6.9
    ## 42       7.1     8.4
    ## 43         7     7.3
    ## 44         7     5.6
    ## 45         7     6.2
    ## 46       7.1     7.6
    ## 47       7.4     8.8
    ## 48       7.3     7.9
    ## 49       7.3     8.3
    ## 50       6.8     9.3
    ## 51       7.4     8.6
    ## 52       6.9     8.6
    ## 53       7.4     9.5
    ## 54       6.8     4.2
    ## 55       6.8     7.2
    ## 56       7.3     6.6
    ## 57      <NA>     8.3
    ## 58         7     6.9
    ## 59         7     7.8
    ## 60         7     6.4
    ## 61       7.3     8.5
    ## 62       7.2     8.2
    ## 63       7.1     7.5
    ## 64       7.1     7.6
    ## 65       7.2     8.4
    ## 66         7     8.0
    ## 67       7.3     8.6
    ## 68         7     7.4
    ## 69         9    11.0
    ## 70       7.3     7.5
    ## 71       6.7      NA
    ## 72       7.2     8.6
    ## 73       7.2     7.4
    ## 74      <NA>     6.3
    ## 75       7.4     6.0
    ## 76       7.3     7.7
    ## 77       7.2     7.1
    ## 78       6.4     6.5
    ## 79         7     7.3
    ## 80       7.2     7.1
    ## 81       7.3     9.0
    ## 82       6.8     9.8
    ## 83       6.9     9.0
    ## 84       6.9     5.8
    ## 85         7     6.8
    ## 86       7.4     5.5
    ## 87       7.5     5.4
    ## 88       7.1     7.6
    ## 89       6.9     6.5
    ## 90       7.2     8.0
    ## 91       7.1     7.3
    ## 92       7.1     8.8
    ## 93       6.8     6.8
    ## 94       8.3     8.3
    ## 95       7.3     9.5
    ## 96       6.8      NA
    ## 97         7     8.2
    ## 98       7.4     5.2
    ## 99       7.4     8.6
    ## 100      7.1     8.0
    ## 101      6.8     7.2
    ## 102      7.2     8.9
    ## 103     <NA>     8.2
    ## 104      7.1     6.2
    ## 105      7.5     8.7
    ## 106        7     8.4
    ## 107      7.1     8.5
    ## 108      7.1     8.8
    ## 109      6.5     6.6
    ## 110      7.1     7.8
    ## 111      6.8     7.3
    ## 112      7.1     7.2
    ## 113      7.2     7.3
    ## 114      7.2     7.1
    ## 115      6.5     8.3
    ## 116      7.5     5.5
    ## 117      7.3     7.1
    ## 118      7.1     7.9
    ## 119      6.7     8.2
    ## 120      7.4     6.7
    ## 121      7.3     8.0
    ## 122      6.8     9.4
    ## 123      7.3     7.6
    ## 124      6.9     8.2
    ## 125      7.2     8.1
    ## 126      7.1     7.8
    ## 127      7.6     9.6
    ## 128      7.1     6.1
    ## 129        7     9.0
    ## 130        7      NA
    ## 131      9.1    11.4
    ## 132      6.8     6.8
    ## 133      7.6     6.1
    ## 134      7.1     7.8
    ## 135      7.2     7.7
    ## 136      7.3     8.6
    ## 137      7.2     7.4
    ## 138      7.2     6.7
    ## 139      6.9     6.7
    ## 140      7.1     8.6
    ## 141      7.4    10.5
    ## 142      7.3     8.3
    ## 143      7.4     6.7
    ## 144      7.5     5.9
    ## 145      7.1     8.3
    ## 146      7.4     8.4
    ## 147      7.4     8.4
    ## 148      7.2     8.0
    ## 149      7.4     6.0
    ## 150      7.2     7.7
    ## 151        7     6.8
    ## 152      7.3     9.5
    ## 153      7.4     5.8
    ## 154      7.7     7.7
    ## 155      7.4     6.2
    ## 156      7.3     8.7
    ## 157      7.4     6.7
    ## 158      7.3     8.6
    ## 159      6.9     8.0
    ## 160      7.1     8.2
    ## 161      6.9     8.3
    ## 162      7.1     7.9
    ## 163      6.8     7.4
    ## 164      7.5     7.0
    ## 165        7     7.5
    ## 166      7.1     6.2
    ## 167      7.2     6.8
    ## 168      7.4     6.3
    ## 169      6.9     7.1
    ## 170      6.8     4.3
    ## 171      6.9     5.7
    ## 172      8.4    11.1
    ## 173      7.1     8.9
    ## 174      7.3     9.0
    ## 175      7.4     5.6
    ## 176      7.2     7.0
    ## 177      7.4     7.2
    ## 178      7.4     6.2
    ## 179      7.4     6.6
    ## 180      7.1     6.6
    ## 181      7.1     8.4
    ## 182        7     6.7
    ## 183      7.3     5.4
    ## 184     <NA>     8.8
    ## 185      6.8     7.4
    ## 186      7.3     9.0
    ## 187        7     8.4
    ## 188      7.3     6.6
    ## 189      7.1     7.4
    ## 190      7.2     7.8
    ## 191      7.2     8.1
    ## 192      7.1     6.8
    ## 193      6.8     8.2
    ## 194      7.4     6.7
    ## 195      6.8     3.5
    ## 196      7.2     7.7
    ## 197      7.4     5.4
    ## 198      7.2    10.2
    ## 199     <NA>     5.7
    ## 200      7.3     5.4
    ## 201      7.2     7.8
    ## 202      7.2     6.3
    ## 203      8.1     7.6
    ## 204      7.1     7.0
    ## 205        7     7.7
    ## 206      6.8    10.0
    ## 207      7.2     8.4
    ## 208      7.5     8.3
    ## 209      7.2     7.7
    ## 210      7.1     8.6
    ## 211      7.5     5.4
    ## 212      6.6     7.3
    ## 213      6.9     8.0
    ## 214      7.1     8.6
    ## 215      7.2     4.0
    ## 216      7.4     8.6
    ## 217      7.4    10.4
    ## 218      7.1     9.1
    ## 219      7.2     5.4
    ## 220      7.6     7.8
    ## 221      7.4     5.4
    ## 222      7.4      NA
    ## 223      7.2     7.3
    ## 224      7.2     7.2
    ## 225     <NA>     6.8
    ## 226      7.4     9.9
    ## 227        7     8.3
    ## 228        7     8.0
    ## 229        7     8.2
    ## 230        7     8.2
    ## 231      7.2     8.5
    ## 232      7.5    10.1
    ## 233      7.3     5.7
    ## 234      7.3     9.0
    ## 235      6.9     8.5
    ## 236      7.1     7.7
    ## 237      7.2     8.3
    ## 238      7.3     8.3
    ## 239        7     6.4
    ## 240        8    10.2
    ## 241        7     6.8
    ## 242      6.9     8.3
    ## 243      7.4     6.0
    ## 244      7.3     8.3
    ## 245      7.3     5.9
    ## 246      6.7     6.8
    ## 247      6.7     8.3
    ## 248      7.2     8.0
    ## 249      6.8     9.1
    ## 250        7     8.1
    ## 251      7.4    10.0
    ## 252      6.9     9.2
    ## 253      7.2     6.6
    ## 254      7.3     6.9
    ## 255      6.9     8.5
    ## 256        7     7.4
    ## 257     <NA>     7.3
    ## 258      7.4     9.6
    ## 259        7     9.0
    ## 260      6.2     7.0
    ## 261      7.1     8.3
    ## 262        7     8.0
    ## 263      6.9     9.8
    ## 264      7.3     6.0
    ## 265      7.4     6.4
    ## 266      6.6     7.4
    ## 267      7.2     8.3
    ## 268      7.2     8.4
    ## 269        7     5.7
    ## 270      6.9     5.2
    ## 271      6.7     8.0
    ## 272        7     6.7
    ## 273      7.1     6.9
    ## 274      6.3     6.2
    ## 275      6.9     7.1
    ## 276        7     9.1
    ## 277      7.5     5.8
    ## 278      7.3     5.5
    ## 279      7.4     5.1
    ## 280      7.3     8.8
    ## 281        7     6.8
    ## 282      7.1     7.0
    ## 283        7     7.1
    ## 284      7.1      NA
    ## 285      7.4     6.4
    ## 286     <NA>     8.0
    ## 287      7.6     9.2
    ## 288      7.3     7.8
    ## 289      7.4     3.2
    ## 290      7.4     9.2
    ## 291      7.3     7.2
    ## 292      7.1     7.2
    ## 293      7.5     5.3
    ## 294      7.3     5.7
    ## 295      7.2     7.0
    ## 296      6.9     6.0
    ## 297      7.3     3.7
    ## 298      7.2     9.2
    ## 299      6.7     9.6
    ## 300      7.3     5.3
    ## 301        7     7.8
    ## 302      6.9     8.1
    ## 303      6.8     4.4
    ## 304      7.4     6.2
    ## 305        7     6.5
    ## 306      7.2     7.9
    ## 307        7     8.2
    ## 308      7.4     5.2
    ## 309      7.4     8.3
    ## 310      7.2     8.2
    ## 311      6.9     8.5
    ## 312        7     9.3
    ## 313      7.5     6.0
    ## 314      6.3     7.5
    ## 315      7.3     9.1
    ## 316      6.7     5.8
    ## 317      7.3     8.0
    ## 318      6.9     6.2
    ## 319      7.1     8.8
    ## 320      6.9     7.3
    ## 321      7.1     6.8
    ## 322      7.4     6.9
    ## 323      6.9     6.8
    ## 324      7.3     9.2
    ## 325     <NA>     7.1
    ## 326        7     7.9
    ## 327      7.2     9.0
    ## 328      7.2      NA
    ## 329      7.6     6.4
    ## 330      7.2     8.3
    ## 331      7.2     8.0
    ## 332        7     8.7
    ## 333        7     7.6
    ## 334      7.2     7.7
    ## 335      7.1     8.2
    ## 336      7.2     6.6
    ## 337      7.3     8.7
    ## 338      6.8     3.7
    ## 339      7.1     7.8
    ## 340      7.4     6.5
    ## 341      7.2     7.8
    ## 342        7     7.3
    ## 343     <NA>     6.8
    ## 344      7.3     9.8
    ## 345      7.1     9.3
    ## 346      7.1     6.6
    ## 347        7     8.2
    ## 348      9.1    11.2
    ## 349      6.8     9.0
    ## 350      7.4     6.8
    ## 351      6.6     8.5
    ## 352      7.1     8.8
    ## 353        7     8.8
    ## 354      7.1     7.8
    ## 355      8.1    11.7
    ## 356      6.7     7.9
    ## 357        7     7.0
    ## 358      7.1     7.1
    ## 359      7.2     7.4
    ## 360      6.8     9.5
    ## 361      7.2     7.5
    ## 362      7.1     6.8
    ## 363      6.9     9.2
    ## 364      7.2     8.4
    ## 365      7.2     7.8
    ## 366      7.5     6.2
    ## 367      7.2     8.6
    ## 368      7.6     8.7
    ## 369        7     7.3
    ## 370        7     7.4
    ## 371      7.1     9.0
    ## 372      7.6     6.9
    ## 373      7.2     7.3
    ## 374      7.1     7.4
    ## 375      7.1     9.8
    ## 376      7.4     6.8
    ## 377      7.1     9.0
    ## 378      6.8     7.3
    ## 379      7.4     6.3
    ## 380        7     7.6
    ## 381      7.2     8.0
    ## 382      7.1     7.4
    ## 383      7.3     8.5
    ## 384      7.3      NA
    ## 385      7.4     6.8
    ## 386      7.2     7.2
    ## 387      7.3     8.9
    ## 388      7.3     8.7
    ## 389      7.4     9.2
    ## 390        7     7.4
    ## 391      7.4     8.7
    ## 392      6.9     7.3
    ## 393      7.3     7.3
    ## 394      7.3     7.8
    ## 395     <NA>     6.4
    ## 396        9     9.7
    ## 397      7.3     9.0
    ## 398        7     6.9
    ## 399        7     8.0
    ## 400     None     6.3
    ## 401      7.2     9.4
    ## 402      6.8     7.1
    ## 403        7     9.3
    ## 404      7.2     6.0
    ## 405      6.8     9.3
    ## 406      7.4     6.9
    ## 407      7.2     7.0
    ## 408      7.3     8.1
    ## 409        7     8.1
    ## 410      7.1     6.7
    ## 411      7.2     9.0
    ## 412      7.3     8.9
    ## 413        7     8.6
    ## 414      6.8      NA
    ## 415      6.9     9.6
    ## 416      6.9     8.3
    ## 417      7.5     8.8
    ## 418      7.2     7.6
    ## 419      6.8     7.4
    ## 420        7     8.1
    ## 421      6.7     7.2
    ## 422      7.2     7.9
    ## 423      7.6    10.4
    ## 424      7.5      NA
    ## 425      7.4     5.8
    ## 426      7.2     7.2
    ## 427      7.5     5.2
    ## 428      6.8     8.3
    ## 429      6.8     4.6
    ## 430      6.8     3.4
    ## 431      7.2     7.4
    ## 432      7.2     8.4
    ## 433      7.1     8.9
    ## 434      7.2     7.4
    ## 435     <NA>     5.5
    ## 436      6.9     8.2
    ## 437      7.4    10.4
    ## 438      6.7     7.4
    ## 439        9    11.8
    ## 440      6.8     8.0
    ## 441      7.5     7.9
    ## 442      6.9     7.8
    ## 443      7.1     6.1
    ## 444      6.9     7.5
    ## 445      7.2     8.2
    ## 446      7.4     6.7
    ## 447      7.1     7.5
    ## 448        7     7.4
    ## 449        7     7.6
    ## 450      7.1     9.4
    ## 451      7.4     7.6
    ## 452        7     8.4
    ## 453      7.2     7.0
    ## 454      7.4     5.1
    ## 455     <NA>     6.1
    ## 456      7.1     5.9
    ## 457      7.1     8.0
    ## 458      7.1     8.1
    ## 459      7.2     8.4
    ## 460      7.4     7.7
    ## 461      7.1     7.2
    ## 462      6.9     5.3
    ## 463        7     8.2
    ## 464      6.3     7.6
    ## 465        7     6.0
    ## 466      6.8     7.2
    ## 467      6.9     8.3
    ## 468      7.4     5.7
    ## 469      7.2     6.0
    ## 470      7.3     7.8
    ## 471      6.9     7.4
    ## 472      6.9     9.4
    ## 473      6.6     7.0
    ## 474      7.6     8.2
    ## 475      7.2     7.8
    ## 476      7.2     6.6
    ## 477      7.4     8.6
    ## 478        7     7.0
    ## 479      7.2     7.6
    ## 480      8.2     8.2
    ## 481      6.8     9.4
    ## 482      7.2     7.6
    ## 483      7.1     9.1
    ## 484      7.2     7.6
    ## 485      7.3      NA
    ## 486      7.5     6.4
    ## 487      7.5     6.7
    ## 488      7.3     9.3
    ## 489        7     6.8
    ## 490      6.9     7.4
    ## 491      7.2     7.5
    ## 492      7.2     8.5
    ## 493      7.2     6.8
    ## 494      6.9     7.8
    ## 495      6.8     6.7
    ## 496        7     7.2
    ## 497      7.5     6.8
    ## 498      6.8     8.5
    ## 499        7     7.8
    ## 500      7.1     8.2
    ## 501      6.8    10.0
    ## 502      6.8     4.0
    ## 503      6.9     6.1
    ## 504      6.6     6.7
    ## 505      7.5     7.9
    ## 506        7     8.6
    ## 507      7.1     8.1
    ## 508      7.4      NA
    ## 509      7.1     6.8
    ## 510      7.1    10.3
    ## 511     <NA>     7.2
    ## 512        7     8.3
    ## 513      6.8     7.2
    ## 514      7.3     8.7
    ## 515      7.4     9.5
    ## 516      7.4     8.1
    ## 517      7.2     9.1
    ## 518      7.3     7.9
    ## 519      7.1     6.3
    ## 520      7.1     7.3
    ## 521        7     6.9
    ## 522        7     8.6
    ## 523     <NA>     8.6
    ## 524      7.1     7.8
    ## 525      7.4     5.8
    ## 526      7.4     9.3
    ## 527      7.2     7.5
    ## 528      6.6     8.1
    ## 529      7.1     8.8
    ## 530      7.1     7.1
    ## 531        7     7.2
    ## 532      6.8     4.4
    ## 533        7     7.3
    ## 534      7.5     7.6
    ## 535      7.3     8.0
    ## 536      7.3     8.1
    ## 537      6.8     7.5
    ## 538      7.7      NA
    ## 539        7     8.8
    ## 540      7.1      NA
    ## 541      7.2      NA
    ## 542      7.3      NA
    ## 543      7.2     8.0
    ## 544        7     6.6
    ## 545      6.9     4.7
    ## 546      6.9     9.8
    ## 547      7.2     8.0
    ## 548      7.4     6.2
    ## 549      7.2      NA
    ## 550        7     7.9
    ## 551        7     7.7
    ## 552      7.1     8.1
    ## 553      7.5     5.7
    ## 554      7.4     8.8
    ## 555        7     7.7
    ## 556      6.9     6.0
    ## 557      7.3     3.4
    ## 558      7.3     8.3
    ## 559        7     9.4
    ## 560        7     7.4
    ## 561      7.3    10.5
    ## 562      7.3     8.6
    ## 563      7.4     5.4
    ## 564     <NA>     6.6
    ## 565      6.9     9.9
    ## 566      7.1     9.4
    ## 567        7     7.0
    ## 568      6.9     7.9
    ## 569      6.8     5.6
    ## 570      7.2     8.7
    ## 571      6.6     7.0
    ## 572      6.6     7.9
    ## 573        7     9.0
    ## 574      8.1    11.3
    ## 575      6.8     9.6
    ## 576        7     8.6
    ## 577      6.9     6.9
    ## 578      7.2     6.6
    ## 579      6.9     7.7
    ## 580      7.2     7.5
    ## 581      7.2     8.6
    ## 582      6.8     6.9
    ## 583      7.1     8.8
    ## 584      6.9     6.6
    ## 585      7.3     8.7
    ## 586      7.6    11.1
    ## 587      6.9     9.1
    ## 588      7.5     6.6
    ## 589      7.3     8.9
    ## 590      7.8      NA
    ## 591      7.1     8.0
    ## 592        7     6.6
    ## 593      7.4     6.6
    ## 594      7.5     7.1
    ## 595     <NA>     4.6
    ## 596      7.6     9.4
    ## 597      7.1     7.6
    ## 598        7     6.8
    ## 599      7.1     7.5
    ## 600        7     8.1
    ## 601      7.5     5.3
    ## 602      6.9     7.1
    ## 603      6.9      NA
    ## 604      6.4     6.8
    ## 605      7.1     7.8
    ## 606        7     6.7
    ## 607     <NA>     7.9
    ## 608      7.1     6.2
    ## 609      7.1     8.8
    ## 610      7.2     7.0
    ## 611      7.3     8.6
    ## 612      7.6     8.3
    ## 613      6.7     6.4
    ## 614      7.5     6.9
    ## 615      7.1     8.7
    ## 616      6.9     8.0
    ## 617      7.2     7.9
    ## 618      7.3     8.5
    ## 619      7.5    10.4
    ## 620        7     6.8
    ## 621      6.8     6.9
    ## 622      6.8     4.2
    ## 623      8.3     8.4
    ## 624      7.6     9.5
    ## 625      7.4     6.5
    ## 626      7.3     4.1
    ## 627        7     7.2
    ## 628     <NA>     8.0
    ## 629      7.5     6.1
    ## 630      6.8     8.5
    ## 631     <NA>     8.2
    ## 632        7     8.1
    ## 633      6.9     7.6
    ## 634      7.1     7.4
    ## 635      6.8      NA
    ## 636      7.3     7.9
    ## 637        7     7.6
    ## 638      7.3     6.5
    ## 639      7.1     7.3
    ## 640        7     7.6
    ## 641        7     8.1
    ## 642      6.9     6.8
    ## 643      7.3     8.7
    ## 644      7.2     7.8
    ## 645      7.1     7.7
    ## 646      7.1     7.6
    ## 647      7.4     9.7
    ## 648        7     6.9
    ## 649      7.2     9.1
    ## 650      6.8     7.6
    ## 651      7.1     7.5
    ## 652      7.1     9.1
    ## 653      8.3    11.1
    ## 654      6.9     6.9
    ## 655      7.4     5.8
    ## 656      6.9     7.2
    ## 657      7.2     7.0
    ## 658      7.1     8.4
    ## 659        7     6.7
    ## 660        7     7.1
    ## 661      7.2     7.3
    ## 662      6.9     6.0
    ## 663      7.2     8.6
    ## 664      7.4     6.5
    ## 665      6.9      NA
    ## 666      7.5     6.1
    ## 667        7     7.4
    ## 668        7     6.6
    ## 669        7     6.9
    ## 670     <NA>     7.1
    ## 671      7.9     8.9
    ## 672      7.3     6.4
    ## 673      7.4     8.9
    ## 674      7.2     7.2
    ## 675      7.2    10.2
    ## 676      7.3     6.0
    ## 677      7.3    10.0
    ## 678      7.4     5.6
    ## 679      7.2     7.3
    ## 680        7     7.5
    ## 681      7.6     6.3
    ## 682      7.1     8.7
    ## 683      7.2     7.3
    ## 684      6.4     7.0
    ## 685      7.2     6.5
    ## 686      7.3     6.2
    ## 687        7     7.0
    ## 688      7.5     5.3
    ## 689      7.2     7.4
    ## 690      7.3     7.7
    ## 691      7.3     5.9
    ## 692      7.4     5.8
    ## 693      7.2      NA
    ## 694      7.2     7.5
    ## 695      7.3     6.7
    ## 696      7.2     8.9
    ## 697      7.2     7.6
    ## 698      7.2     8.6
    ## 699        7     7.2
    ## 700      7.2     7.0
    ## 701      7.3     5.6
    ## 702     None    10.7
    ## 703      7.2     7.5
    ## 704      7.1     8.8
    ## 705      7.1     6.4
    ## 706        7     6.8
    ## 707      7.1     6.3
    ## 708      7.4     6.3
    ## 709      7.3     8.6
    ## 710      6.8     8.5
    ## 711        7     6.8
    ## 712      6.9     6.7
    ## 713        7     8.6
    ## 714      7.1     8.7
    ## 715      7.2     6.9
    ## 716      6.3     6.0
    ## 717      7.9     9.9
    ## 718      8.4     9.2
    ## 719      7.3     9.2
    ## 720        9    11.9
    ## 721      7.2     7.6
    ## 722      7.3     6.2
    ## 723      7.1      NA
    ## 724      7.1     8.0
    ## 725      7.2     7.8
    ## 726      7.1     6.3
    ## 727        7     7.3
    ## 728      6.8     7.3
    ## 729      7.5    10.2
    ## 730        7     6.2
    ## 731      7.1    10.8
    ## 732      7.5    10.0
    ## 733      6.5     6.4
    ## 734      7.1     9.9
    ## 735      7.3     7.0
    ## 736      6.9     5.4
    ## 737      7.3     9.0
    ## 738      7.5     6.1
    ## 739      6.4      NA
    ## 740      7.1     6.7
    ## 741        7     6.9
    ## 742      7.3     5.9
    ## 743      7.1     6.8
    ## 744      7.2     6.8
    ## 745      7.8     7.1
    ## 746      6.9     9.4
    ## 747      6.8     4.6
    ## 748      7.1     7.4
    ## 749      6.8     4.5
    ## 750      7.2     9.8
    ## 751      7.3     8.5
    ## 752      7.3     6.5
    ## 753     <NA>      NA
    ## 754      7.2     8.6
    ## 755      7.2     9.0
    ## 756              7.4
    ## 757        7     6.4
    ## 758      6.8     7.4
    ## 759      7.1     7.7
    ## 760      7.3     5.5
    ## 761      7.1     7.7
    ## 762      7.3     7.8
    ## 763      7.3     5.8
    ## 764        7     7.2
    ## 765      7.2     7.1
    ## 766      7.2      NA
    ## 767      7.2     8.2
    ## 768      6.8     8.5
    ## 769      7.2     7.3
    ## 770      7.2     8.5
    ## 771      6.9     6.1
    ## 772      6.9     8.7
    ## 773      7.3     5.8
    ## 774      7.5     8.8
    ## 775      6.9     8.2
    ## 776      6.4     7.2
    ## 777      7.1     7.4
    ## 778      7.4     3.3
    ## 779      6.7     9.4
    ## 780      7.9    11.2
    ## 781      7.3     9.0
    ## 782      7.2     5.0
    ## 783        7     8.8
    ## 784      6.8     4.0
    ## 785      7.4     9.9
    ## 786      6.9     8.3
    ## 787      6.9     4.9
    ## 788      7.2     8.6
    ## 789      7.2     7.1
    ## 790      7.4     6.3
    ## 791     <NA>     6.0
    ## 792      7.2     8.5
    ## 793        7     8.7
    ## 794      6.8     4.2
    ## 795      6.9     8.5
    ## 796      7.9     9.7
    ## 797      7.1     9.0
    ## 798      7.2     8.2
    ## 799      7.2     8.4
    ## 800      7.1     6.8
    ## 801      7.2     8.0
    ## 802      7.3     9.5
    ## 803      7.3     9.1
    ## 804      6.9     5.9
    ## 805      7.2     9.0
    ## 806      7.2     8.8
    ## 807      7.3     9.0
    ## 808      7.2     7.7
    ## 809        7     9.4
    ## 810      7.1     7.5
    ## 811      7.2     8.1
    ## 812      7.2     8.0
    ## 813      6.9     9.6
    ## 814      6.8     8.0
    ## 815      7.4     6.2
    ## 816      7.4     6.1
    ## 817      7.4     3.3
    ## 818      7.4     4.8
    ## 819      7.2     7.8
    ## 820      7.4      NA
    ## 821      6.6     6.9
    ## 822      7.5     6.2
    ## 823        7     6.9
    ## 824      7.4     9.0
    ## 825      7.2     7.6
    ## 826      7.1     7.2
    ## 827      7.4     4.9
    ## 828      6.9     6.3
    ## 829      7.2     7.7
    ## 830      7.3     6.0
    ## 831      6.9     7.5
    ## 832      6.8     9.5
    ## 833      7.3     5.5
    ## 834      7.1     7.6
    ## 835      7.2     7.3
    ## 836      6.9     7.3
    ## 837      7.1     8.2
    ## 838      7.5     6.1
    ## 839      7.1     9.2
    ## 840      7.4     6.1
    ## 841      7.1     7.6
    ## 842      6.9     7.7
    ## 843      7.1     8.1
    ## 844      7.4    10.8
    ## 845      7.4     9.0
    ## 846      7.1     8.2
    ## 847      7.3     8.1
    ## 848      7.2     7.7
    ## 849        7     9.7
    ## 850      7.1     6.5
    ## 851      7.3     5.9
    ## 852      7.3     5.4
    ## 853      7.2     8.9
    ## 854      7.1     6.6
    ## 855      7.4     6.2
    ## 856      7.3     7.0
    ## 857        7     7.4
    ## 858      7.2     6.8
    ## 859        7     7.0
    ## 860      7.5     6.0
    ## 861        7     6.8
    ## 862      7.2     6.2
    ## 863      7.3     8.7
    ## 864      7.2     5.3
    ## 865      7.2     7.5
    ## 866      7.3     6.1
    ## 867      6.7     8.1
    ## 868      7.1     7.3
    ## 869      7.2     8.9
    ## 870      7.3     8.4
    ## 871      6.6     7.3
    ## 872      7.1     7.5
    ## 873      7.2     7.2
    ## 874      7.2     7.7
    ## 875      6.9     6.9
    ## 876        7     6.8
    ## 877      6.6     6.4
    ## 878      7.1     6.3
    ## 879        7     7.2
    ## 880      7.5     9.7
    ## 881      7.1      NA
    ## 882      7.2     9.6
    ## 883      7.1      NA
    ## 884     <NA>    12.2
    ## 885      7.4     9.8
    ## 886      6.4     8.1
    ## 887      7.3     8.2
    ## 888      7.2     8.9
    ## 889        9    11.9
    ## 890      7.5     6.2
    ## 891      7.1     6.2
    ## 892      7.4     6.7
    ## 893      7.2     8.2
    ## 894      7.2     8.7
    ## 895      7.4     7.7
    ## 896      7.2     5.5
    ## 897      7.3      NA
    ## 898      6.8     4.7
    ## 899      7.1     9.1
    ## 900      7.1     7.4
    ## 901        7     8.4
    ## 902      7.1     8.0
    ## 903      6.9     4.8
    ## 904      6.8     7.5
    ## 905      7.1      NA
    ## 906      7.1     7.2
    ## 907      6.6     7.6
    ## 908      7.5     8.5
    ## 909      7.4     6.3
    ## 910        7     6.4
    ## 911      8.1    10.4
    ## 912      7.2     7.6
    ## 913      7.2     7.4
    ## 914     <NA>     7.1
    ## 915     <NA>     7.2
    ## 916      7.2     9.1
    ## 917      7.3     6.0
    ## 918      6.4     7.1
    ## 919      7.2     6.7
    ## 920      7.3     6.8
    ## 921      7.4     6.6
    ## 922      7.1     8.5
    ## 923      7.3     6.8
    ## 924     <NA>     6.3
    ## 925      7.1     6.7
    ## 926     <NA>     8.9
    ## 927      7.2     7.6
    ## 928      7.3     9.0
    ## 929     <NA>     9.1
    ## 930      7.6     5.8
    ## 931      7.3     8.6
    ## 932      7.3     6.4
    ## 933      7.1     8.1
    ## 934      6.7     7.8
    ## 935      7.3     8.2
    ## 936      7.3    10.2
    ## 937      7.3     7.5
    ## 938      6.9     8.2
    ## 939      7.1     6.9
    ## 940      6.5     7.2
    ## 941      7.2     8.2
    ## 942      7.3     8.6
    ## 943      6.8     6.5
    ## 944      7.2     7.7
    ## 945      7.1     6.9
    ## 946      7.2      NA
    ## 947      7.5     8.8
    ## 948      7.6     9.6
    ## 949      7.4     6.5
    ## 950        7     6.9
    ## 951      7.1     9.9
    ## 952      6.9     5.6
    ## 953      7.2     7.0
    ## 954        7     7.8
    ## 955      7.2     7.6
    ## 956      6.8     6.9
    ## 957      7.2     7.4
    ## 958     None     8.0
    ## 959      7.1     8.2
    ## 960      7.3     8.3
    ## 961      7.2     7.3
    ## 962      7.1     7.3
    ## 963      7.4     7.4
    ## 964      6.7     8.3
    ## 965      7.1     8.5
    ## 966      7.3     8.7
    ## 967      7.6     8.9
    ## 968      7.1     7.5
    ## 969      7.1     8.1
    ## 970      7.3     7.1
    ## 971      6.8     4.3
    ## 972      7.3     8.8
    ## 973      7.2     6.8
    ## 974      7.1     7.7
    ## 975      7.2     6.6
    ## 976      7.1     9.2
    ## 977      6.3     7.5
    ## 978      7.4     6.1
    ## 979        7     7.1
    ## 980      7.5     6.3
    ## 981      7.3     7.2
    ## 982      7.4     9.6
    ## 983      7.5     6.3
    ## 984      7.2     9.1
    ## 985        7     8.8
    ## 986      7.1     7.3
    ## 987      6.8     7.9
    ## 988        7      NA
    ## 989      7.6     9.3
    ## 990      7.3     5.3
    ## 991      7.4     6.3
    ## 992      7.5     6.2
    ## 993        7     6.2
    ## 994      6.7     7.3
    ## 995      6.9     6.6
    ## 996      7.1     8.4
    ## 997      7.4    11.0
    ## 998      7.2     6.6
    ## 999      7.3     9.3
    ## 1000     7.4     5.3
    ## 1001     7.2     8.7
    ## 1002     7.3      NA
    ## 1003     7.4     8.7
    ## 1004     7.2     7.8
    ## 1005     7.3     9.0
    ## 1006     6.7     7.0
    ## 1007     7.2     7.6
    ## 1008     7.2     8.0
    ## 1009     7.2     8.2
    ## 1010       7     7.5
    ## 1011     7.2     8.2
    ## 1012       7     8.4
    ## 1013     7.4     8.7
    ## 1014     7.1     8.5
    ## 1015     7.4     6.6
    ## 1016     7.3     9.0
    ## 1017     6.9     6.1
    ## 1018     7.6     6.1
    ## 1019     6.9     6.4
    ## 1020     6.9     4.8
    ## 1021     6.6     7.5
    ## 1022     7.2     7.0
    ## 1023     7.3     8.2
    ## 1024       7     6.6
    ## 1025     6.4     7.2
    ## 1026     7.2     7.7
    ## 1027     7.1     7.3
    ## 1028     7.2     8.8
    ## 1029     7.2     8.2
    ## 1030       7     6.8
    ## 1031    <NA>      NA
    ## 1032     6.4     8.5
    ## 1033     7.3     8.9
    ## 1034     7.2     8.1
    ## 1035       7     9.0
    ## 1036    <NA>     8.0
    ## 1037       7     7.7
    ## 1038    <NA>     6.4
    ## 1039     7.1     8.0
    ## 1040     7.1     7.6
    ## 1041     7.3     7.3
    ## 1042     7.3     6.1
    ## 1043     7.3     8.5
    ## 1044     7.5     5.6
    ## 1045     7.3     9.0
    ## 1046       7     7.3
    ## 1047     7.1     6.5
    ## 1048    <NA>     8.6
    ## 1049     6.8     6.3
    ## 1050     7.4     5.9
    ## 1051     7.2     7.1
    ## 1052     7.2      NA
    ## 1053       7     6.8
    ## 1054     7.4     8.0
    ## 1055     7.4     6.5
    ## 1056     6.8     4.3
    ## 1057       7      NA
    ## 1058       7     8.2
    ## 1059     7.2      NA
    ## 1060     7.2     9.4
    ## 1061     7.3     8.4
    ## 1062     6.8     9.8
    ## 1063     7.3     5.9
    ## 1064     7.1     7.0
    ## 1065     7.2     7.2
    ## 1066     7.3     9.1
    ## 1067     6.9     7.2
    ## 1068     7.2     6.5
    ## 1069     7.4     5.8
    ## 1070     6.8     4.2
    ## 1071     6.8     6.5
    ## 1072     7.5     6.7
    ## 1073     6.8      NA
    ## 1074     7.1     6.7
    ## 1075     7.2     6.6
    ## 1076     7.1     7.0
    ## 1077     7.3     9.3
    ## 1078     7.6     9.5
    ## 1079     6.8     4.2
    ## 1080     7.2     6.4
    ## 1081     7.1     8.3
    ## 1082     7.4     6.7
    ## 1083     6.8     7.0
    ## 1084       7     7.3
    ## 1085       7     8.3
    ## 1086     6.5     7.0
    ## 1087     6.9      NA
    ## 1088     7.1     7.5
    ## 1089     6.3     7.5
    ## 1090     7.5     8.8
    ## 1091     7.2     6.8
    ## 1092     6.7     8.3
    ## 1093     6.8     3.4
    ## 1094     7.2     8.8
    ## 1095     6.7     8.3
    ## 1096     7.3     9.1
    ## 1097     7.2     8.5
    ## 1098     6.9     8.7
    ## 1099     7.4      NA
    ## 1100     7.4     5.5
    ## 1101     7.2      NA
    ## 1102     6.6     7.3
    ## 1103     7.3     7.1
    ## 1104     7.1     7.9
    ## 1105     7.4    10.0
    ## 1106     7.4     6.7
    ## 1107     7.4     8.0
    ## 1108     7.1     9.0
    ## 1109     6.9     6.8
    ## 1110     7.2     9.0
    ## 1111       7     8.9
    ## 1112     7.3     5.2
    ## 1113     6.8     7.7
    ## 1114     7.3     8.2
    ## 1115     7.1     7.8
    ## 1116     7.4     8.9
    ## 1117       7     8.3
    ## 1118       7     6.6
    ## 1119    <NA>     9.1
    ## 1120     7.5     5.9
    ## 1121     7.6     9.8
    ## 1122       7     7.4
    ## 1123     7.2     7.2
    ## 1124     7.1     9.3
    ## 1125     7.2     7.2
    ## 1126     6.9     7.9
    ## 1127     7.3     8.6
    ## 1128     7.2     8.6
    ## 1129     7.2     7.9
    ## 1130     7.5     5.5
    ## 1131     7.4     8.2
    ## 1132     7.9    11.0
    ## 1133       7     7.2
    ## 1134     7.3     8.4
    ## 1135     7.2      NA
    ## 1136     7.3     8.2
    ## 1137     7.3     5.9
    ## 1138     7.2     6.9
    ## 1139     7.1     6.8
    ## 1140    <NA>     7.1
    ## 1141     7.3    10.2
    ## 1142     7.2     6.9
    ## 1143     8.6    12.0
    ## 1144     6.9     8.3
    ## 1145     7.2     9.0
    ## 1146     6.8     4.3
    ## 1147     7.3     7.2
    ## 1148       7      NA
    ## 1149     7.4     7.8
    ## 1150     6.8     7.4
    ## 1151     6.8     7.7
    ## 1152     6.4     8.5
    ## 1153     6.9      NA
    ## 1154     7.1     7.4
    ## 1155     7.1     8.3
    ## 1156     7.2     8.6
    ## 1157     6.2     7.0
    ## 1158     7.4     8.0
    ## 1159     7.2     7.7
    ## 1160     7.1     7.5
    ## 1161     7.4     8.8
    ## 1162     7.5     6.2
    ## 1163     6.4     7.3
    ## 1164     7.2     8.5
    ## 1165    <NA>     6.2
    ## 1166     7.6     8.6
    ## 1167     7.1     7.0
    ## 1168     7.5     5.4
    ## 1169       7     7.4
    ## 1170     7.2     8.8
    ## 1171     7.1     7.5
    ## 1172     7.5     9.0
    ## 1173     7.1     5.9
    ## 1174     6.9     8.2
    ## 1175     7.3     5.6
    ## 1176     7.4    10.0
    ## 1177     7.5     6.6
    ## 1178     7.4     9.5
    ## 1179     7.2     7.8
    ## 1180     7.5     6.4
    ## 1181     7.5    10.2
    ## 1182     7.1     7.8
    ## 1183     7.2     7.8
    ## 1184     7.1     6.9
    ## 1185     7.4     5.8
    ## 1186     7.2     8.4
    ## 1187    <NA>     6.5
    ## 1188     7.2     9.0
    ## 1189     7.4     5.6
    ## 1190    <NA>      NA
    ## 1191     6.9     4.6
    ## 1192     7.5     5.6
    ## 1193     7.3     7.5
    ## 1194       7     7.3
    ## 1195     7.3     8.6
    ## 1196     7.1     7.0
    ## 1197     7.2     7.9
    ## 1198     7.4     5.2
    ## 1199     7.6     9.1
    ## 1200     7.3     9.0
    ## 1201     7.1     8.4
    ## 1202     7.3     9.3
    ## 1203     7.3     5.6
    ## 1204       7     7.0
    ## 1205     7.1     7.0
    ## 1206     7.1      NA
    ## 1207     7.3     7.3
    ## 1208     7.3     8.6
    ## 1209     6.9     9.2
    ## 1210     7.1     8.0
    ## 1211    <NA>     7.9
    ## 1212     6.8     4.0
    ## 1213     7.2     8.3
    ## 1214     7.1     9.1
    ## 1215     7.2     8.9
    ## 1216     6.5     8.2
    ## 1217     7.1     9.0
    ## 1218       7     8.5
    ## 1219     7.2     5.5
    ## 1220     7.2     8.9
    ## 1221    None     7.3
    ## 1222     7.4     8.9
    ## 1223     7.3      NA
    ## 1224     7.2     7.5
    ## 1225     7.3     5.4
    ## 1226     7.6     8.6
    ## 1227       7     7.4
    ## 1228     6.8     4.3
    ## 1229     6.9     5.9
    ## 1230       7     7.6
    ## 1231     7.2     8.3
    ## 1232    None     4.7
    ## 1233     7.2     7.7
    ## 1234     6.7     5.7
    ## 1235     7.3     9.3
    ## 1236     7.2     7.0
    ## 1237     7.4    10.5
    ## 1238     7.5     9.5
    ## 1239     6.9     8.8
    ## 1240     6.8      NA
    ## 1241     7.2     9.8
    ## 1242       7     9.4
    ## 1243     7.2     8.5
    ## 1244     7.4     8.2
    ## 1245    <NA>      NA
    ## 1246     7.3     6.8
    ## 1247    <NA>     9.3
    ## 1248     7.4     7.9
    ## 1249     7.2     6.7
    ## 1250       7     6.3
    ## 1251     6.7     6.0
    ## 1252     7.3     7.8
    ## 1253     7.2     7.2
    ## 1254     7.2     8.7
    ## 1255     7.1     9.0
    ## 1256     7.2     6.9
    ## 1257     7.3     5.9
    ## 1258     7.4     5.9
    ## 1259     7.2     7.7
    ## 1260     7.1     8.4
    ## 1261     7.5    11.8
    ## 1262     7.3     9.3
    ## 1263     7.3     7.6
    ## 1264     7.4     6.3
    ## 1265     7.4     9.8
    ## 1266     7.4     7.8
    ## 1267       7     8.1
    ## 1268     7.2     8.7
    ## 1269     6.9     6.4
    ## 1270     7.6     8.4
    ## 1271     6.9     7.6
    ## 1272     7.3     9.0
    ## 1273     7.3     8.3
    ## 1274     7.3     9.1
    ## 1275     7.2    10.2
    ## 1276     6.9     8.3
    ## 1277     7.6     6.8
    ## 1278     7.4     9.6
    ## 1279       7     8.2
    ## 1280     6.9     5.2
    ## 1281     7.4     8.3
    ## 1282       7     7.5
    ## 1283       7     7.8
    ## 1284     7.2     7.1
    ## 1285     7.3     8.5
    ## 1286     6.9      NA
    ## 1287     6.8     7.0
    ## 1288     7.4     5.7
    ## 1289     7.5     5.8
    ## 1290     7.2     8.9
    ## 1291     7.2     6.9
    ## 1292     7.3     5.5
    ## 1293     7.2     7.8
    ## 1294       7     7.4
    ## 1295     7.3     6.9
    ## 1296     7.2     8.3
    ## 1297     6.9     9.4
    ## 1298     7.1     7.7
    ## 1299     6.9     4.1
    ## 1300       7     8.6
    ## 1301     7.4     6.0
    ## 1302     6.8     7.4
    ## 1303     8.4    11.8
    ## 1304     7.6     6.7
    ## 1305     6.9     8.0
    ## 1306     7.4     3.5
    ## 1307    <NA>     6.9
    ## 1308     7.2     8.4
    ## 1309     6.8     6.8
    ## 1310     7.1     7.9
    ## 1311       7     9.0
    ## 1312     6.7     7.8
    ## 1313     7.2     9.0
    ## 1314     7.3     9.1
    ## 1315     7.2     7.0
    ## 1316    <NA>     4.3
    ## 1317     7.3     6.4
    ## 1318       7     7.9
    ## 1319     6.9     5.3
    ## 1320     7.3     9.0
    ## 1321     7.4     9.6
    ## 1322     7.1     7.5
    ## 1323     7.1     5.4
    ## 1324     7.2     6.9
    ## 1325     7.3     8.2
    ## 1326     7.2     8.3
    ## 1327     7.2     7.3
    ## 1328     6.8     8.3
    ## 1329     6.9     7.9
    ## 1330     7.3     8.4
    ## 1331     7.3     8.9
    ## 1332     7.1     7.1
    ## 1333     7.2     6.2
    ## 1334     7.2     7.3
    ## 1335     7.2     8.9
    ## 1336     7.3     9.0
    ## 1337     7.4     9.0
    ## 1338     6.9     6.5
    ## 1339    <NA>     7.6
    ## 1340    <NA>     9.9
    ## 1341     7.1     7.2
    ## 1342     7.4     6.8
    ## 1343     6.7     7.6
    ## 1344       7      NA
    ## 1345     6.9     8.0
    ## 1346     7.3     8.7
    ## 1347     7.3    11.8
    ## 1348     6.9     7.3
    ## 1349     7.4    10.7
    ## 1350     7.6     9.4
    ## 1351     7.5     7.1
    ## 1352     7.1     6.0
    ## 1353     7.3     5.2
    ## 1354     6.9     7.5
    ## 1355    <NA>     9.2
    ## 1356     7.4     7.8
    ## 1357     7.1     7.5
    ## 1358       7     7.5
    ## 1359     7.4     5.0
    ## 1360    <NA>     8.5
    ## 1361     6.8     6.8
    ## 1362     6.8     6.7
    ## 1363     7.1     7.6
    ## 1364       7     7.0
    ## 1365       7     7.0
    ## 1366     7.3     6.2
    ## 1367     7.6     9.4
    ## 1368     7.5     5.1
    ## 1369     7.2     9.1
    ## 1370     7.2     7.3
    ## 1371     7.4     6.4
    ## 1372     6.8     7.5
    ## 1373       7     7.3
    ## 1374     7.3     9.0
    ## 1375     7.3     9.0
    ## 1376     6.7     7.7
    ## 1377     6.6     7.2
    ## 1378     8.2    11.3
    ## 1379     7.2     6.0
    ## 1380     7.4     9.2
    ## 1381       7     8.6
    ## 1382     7.2     6.7
    ## 1383     6.8     4.5
    ## 1384     7.5     9.0
    ## 1385     7.5     8.2
    ## 1386     6.8     7.3
    ## 1387     7.4     6.8
    ## 1388     6.7     9.1
    ## 1389     7.3     8.0
    ## 1390     7.2     7.3
    ## 1391     7.1     6.8
    ## 1392     7.1     6.6
    ## 1393     7.2     6.8
    ## 1394     6.7     7.7
    ## 1395     6.8     6.8
    ## 1396     7.1     8.2
    ## 1397     7.6     9.0
    ## 1398       7     8.1
    ## 1399     6.8     8.3
    ## 1400     7.4     6.8
    ## 1401     7.1     5.7
    ## 1402       7     8.7
    ## 1403       7     8.3
    ## 1404       7     8.0
    ## 1405     7.3     8.8
    ## 1406     7.2     7.2
    ## 1407     6.9     7.4
    ## 1408     7.2     7.0
    ## 1409     7.2     6.4
    ## 1410     7.7    11.1
    ## 1411     6.8     7.2
    ## 1412     7.1      NA
    ## 1413     7.3     6.2
    ## 1414     7.2     4.3
    ## 1415     7.2     8.6
    ## 1416       7     6.9
    ## 1417     7.1     7.4
    ## 1418     7.5     6.1
    ## 1419     7.1     7.8
    ## 1420       7     8.0
    ## 1421       7     7.0
    ## 1422     7.5     8.9
    ## 1423     7.7    12.0
    ## 1424     7.1     8.7
    ## 1425     7.2     8.0
    ## 1426     7.2     8.0
    ## 1427    <NA>     7.8
    ## 1428     6.9     5.0
    ## 1429     7.3     8.7
    ## 1430     7.2     7.5
    ## 1431     7.2      NA
    ## 1432       7     6.6
    ## 1433     7.5     9.1
    ## 1434     7.5     7.5
    ## 1435     7.2     8.9
    ## 1436     7.3     5.9
    ## 1437     7.4     5.5
    ## 1438     7.3     8.4
    ## 1439     7.1     7.0
    ## 1440       7     6.9
    ## 1441     7.3    11.2
    ## 1442     6.9     7.1
    ## 1443     6.6     8.4
    ## 1444     7.1     8.0
    ## 1445     7.3     5.6
    ## 1446     6.9     9.5
    ## 1447     6.9     5.8
    ## 1448     6.9     8.3
    ## 1449     7.2     7.9
    ## 1450     7.2     7.9
    ## 1451     7.2     7.7
    ## 1452     7.2     7.2
    ## 1453     7.7     6.4
    ## 1454    <NA>     7.0
    ## 1455     7.4     6.2
    ## 1456     7.3     7.9
    ## 1457    <NA>     6.7
    ## 1458     7.2     7.8
    ## 1459       7     7.2
    ## 1460       7     7.2
    ## 1461     6.9     7.5
    ## 1462     7.1     8.6
    ## 1463     7.2     6.7
    ## 1464     7.9     9.0
    ## 1465     7.2     8.6
    ## 1466     6.9     8.3
    ## 1467     7.3     8.9
    ## 1468       7     7.6
    ## 1469     7.6     6.8
    ## 1470     6.7     6.0
    ## 1471    <NA>     8.4
    ## 1472       7     6.7
    ## 1473       7     7.6
    ## 1474     7.3     9.1
    ## 1475     7.3     6.8
    ## 1476     6.7     7.0
    ## 1477             6.2
    ## 1478     7.2     5.6
    ## 1479     6.7     8.5
    ## 1480     6.9     6.6
    ## 1481     7.4     9.2
    ## 1482     7.2     7.7
    ## 1483     7.1     8.0
    ## 1484     7.1     8.3
    ## 1485     7.2     7.2
    ## 1486     7.3     7.9
    ## 1487     7.2     8.7
    ## 1488     7.3     9.6
    ## 1489     6.8     7.8
    ## 1490     6.9     6.6
    ## 1491     7.2     7.9
    ## 1492     7.2     8.2
    ## 1493    <NA>     6.9
    ## 1494     7.1     6.9
    ## 1495     7.2     7.6
    ## 1496       9    11.8
    ## 1497     7.2     8.3
    ## 1498       7     7.9
    ## 1499       7     8.6
    ## 1500     7.2     7.0
    ## 1501       7     8.3
    ## 1502     7.2     6.3
    ## 1503     7.1     6.7
    ## 1504     7.4     8.9
    ## 1505     7.6     9.2
    ## 1506     7.1     7.6
    ## 1507     7.1     8.5
    ## 1508     6.9     7.4
    ## 1509     6.9     7.6
    ## 1510     6.9     8.4
    ## 1511     6.8     8.3
    ## 1512     7.1     7.2
    ## 1513     6.6     6.6
    ## 1514     7.1     8.3
    ## 1515       7     6.9
    ## 1516     6.8     6.9
    ## 1517       7     9.0
    ## 1518     7.1     7.3
    ## 1519     7.2     7.1
    ## 1520       7     8.1
    ## 1521     7.2     6.9
    ## 1522     7.4    10.1
    ## 1523       7     7.7
    ## 1524     7.2     8.3
    ## 1525     7.4     6.4
    ## 1526    <NA>     7.8
    ## 1527     6.9     8.1
    ## 1528     7.2     8.3
    ## 1529     7.3     5.6
    ## 1530     7.4     7.8
    ## 1531     6.9     9.7
    ## 1532     7.4     5.7
    ## 1533     7.2     8.1
    ## 1534    <NA>     8.5
    ## 1535     7.2     5.8
    ## 1536     7.1     7.9
    ## 1537     7.1     8.0
    ## 1538     7.3      NA
    ## 1539     7.1     7.0
    ## 1540     7.4     8.5
    ## 1541     7.2     7.0
    ## 1542     7.2     8.3
    ## 1543       7     8.1
    ## 1544     6.9     9.3
    ## 1545       7     8.1
    ## 1546     7.3     6.5
    ## 1547       7     8.5
    ## 1548     7.4    10.5
    ## 1549     7.4     5.3
    ## 1550     7.4     5.9
    ## 1551     6.9     9.7
    ## 1552     7.2     7.8
    ## 1553     6.9     6.1
    ## 1554     7.1     7.2
    ## 1555    <NA>     7.5
    ## 1556     7.4     9.9
    ## 1557     7.1     7.4
    ## 1558     6.9     5.4
    ## 1559     6.7     9.5
    ## 1560     7.3     8.6
    ## 1561     7.3     9.1
    ## 1562     8.2     8.0
    ## 1563     7.3     6.1
    ## 1564     7.3     9.1
    ## 1565     7.1     7.7
    ## 1566     7.5     7.8
    ## 1567     7.3     5.6
    ## 1568       7     7.9
    ## 1569     7.4     8.0
    ## 1570       7     8.8
    ## 1571     7.1     6.8
    ## 1572     7.3     7.0
    ## 1573     6.9     5.4
    ## 1574     7.1     9.0
    ## 1575     7.1     8.8
    ## 1576    <NA>    10.0
    ## 1577     7.2     6.3
    ## 1578     7.2     7.8
    ## 1579       7     7.1
    ## 1580     6.6     6.5
    ## 1581     7.4     6.9
    ## 1582       7     6.3
    ## 1583     8.8    12.4
    ## 1584     7.2     7.7
    ## 1585     6.8     4.2
    ## 1586     7.5     6.0
    ## 1587     7.1     8.8
    ## 1588     7.1     7.0
    ## 1589     6.8     7.4
    ## 1590     7.5     8.6
    ## 1591     7.1     6.8
    ## 1592     6.9     9.3
    ## 1593     6.9     9.7
    ## 1594     7.3     8.2
    ## 1595     7.3     7.4
    ## 1596       7     6.8
    ## 1597     6.8     7.9
    ## 1598     7.1     8.0
    ## 1599     6.7     7.3
    ## 1600     6.8     6.9
    ## 1601     7.3     7.8
    ## 1602     7.3     7.3
    ## 1603     7.1     6.9
    ## 1604     7.3     5.0
    ## 1605     7.4     5.4
    ## 1606     7.4     5.6
    ## 1607     6.8     6.7
    ## 1608     7.6     9.4
    ## 1609     7.1     6.0
    ## 1610     7.3     8.3
    ## 1611     6.8     4.4
    ## 1612     7.2     7.2
    ## 1613       7     6.9
    ## 1614     7.1     7.9
    ## 1615     7.4     6.0
    ## 1616     6.4     7.2
    ## 1617     7.2     7.6
    ## 1618     7.4     6.0
    ## 1619    <NA>     7.9
    ## 1620     7.1     7.0
    ## 1621     7.5     9.4
    ## 1622     6.9     8.1
    ## 1623     7.1     7.4
    ## 1624     7.2     8.7
    ## 1625     6.8     8.3
    ## 1626       8     7.7
    ## 1627       7     7.0
    ## 1628     7.4     3.6
    ## 1629     7.2     6.7
    ## 1630     6.9     9.4
    ## 1631     7.1     7.7
    ## 1632     7.2     7.6
    ## 1633     7.3     9.3
    ## 1634     7.2      NA
    ## 1635     7.1     6.9
    ## 1636     7.2     7.3
    ## 1637     7.5     5.9
    ## 1638       8    10.1
    ## 1639     7.4     6.5
    ## 1640     7.4     5.1
    ## 1641     7.3     9.0
    ## 1642     7.2     8.2
    ## 1643     7.2     8.0
    ## 1644       7     7.1
    ## 1645     7.2     8.8
    ## 1646     7.3      NA
    ## 1647     7.9     6.7
    ## 1648     7.3     8.5
    ## 1649     6.9     5.9
    ## 1650       7     8.4
    ## 1651       7     7.8
    ## 1652     7.1     7.7
    ## 1653     7.1     6.6
    ## 1654     7.1     7.7
    ## 1655     7.3     5.4
    ## 1656     7.3     5.8
    ## 1657    <NA>     7.7
    ## 1658     7.6     6.2
    ## 1659     6.9     6.9
    ## 1660       7     8.1
    ## 1661     7.1     7.5
    ## 1662       7     6.2
    ## 1663     7.3    10.8
    ## 1664       7     8.0
    ## 1665     7.2     8.9
    ## 1666     7.2     7.8
    ## 1667     7.1      NA
    ## 1668     7.4     8.8
    ## 1669     7.4     6.3
    ## 1670    <NA>    11.0
    ## 1671     7.3     6.1
    ## 1672     7.5     6.5
    ## 1673     7.2     7.0
    ## 1674     8.5     8.1
    ## 1675       7     8.4
    ## 1676     7.1     9.1
    ## 1677     7.1     4.0
    ## 1678     7.2     8.9
    ## 1679     7.2     8.8
    ## 1680       7     7.0
    ## 1681     7.2     6.4
    ## 1682     7.1     8.7
    ## 1683     7.4    10.1
    ## 1684     7.5     6.8
    ## 1685     7.2     7.6
    ## 1686     7.1     7.9
    ## 1687     7.2     8.1
    ## 1688     6.6     7.9
    ## 1689     7.1     8.2
    ## 1690     7.1     6.9
    ## 1691     6.8     7.1
    ## 1692     7.3     8.2
    ## 1693     7.3     8.5
    ## 1694     7.1     7.5
    ## 1695     7.1     7.3
    ## 1696     6.3     7.2
    ## 1697       7     8.2
    ## 1698     7.3    10.3
    ## 1699     7.1     6.5
    ## 1700     7.2     7.8
    ## 1701     7.1     8.4
    ## 1702     6.4     6.5
    ## 1703     7.3     7.2
    ## 1704     7.3     6.1
    ## 1705     7.2     8.0
    ## 1706     7.3     9.1
    ## 1707     7.4     6.2
    ## 1708     7.5     7.4
    ## 1709     6.8      NA
    ## 1710     7.3     8.2
    ## 1711       7     7.3
    ## 1712     7.1     8.6
    ## 1713     7.4    10.7
    ## 1714     7.5     5.7
    ## 1715       7     6.7
    ## 1716       9    10.3
    ## 1717     7.2     7.4
    ## 1718     7.2     7.8
    ## 1719       7     7.7
    ## 1720     7.5     6.3
    ## 1721     7.3     5.8
    ## 1722       7     8.8
    ## 1723     7.1     8.5
    ## 1724     6.9     7.3
    ## 1725       7     8.6
    ## 1726     7.6     5.9
    ## 1727     7.5     6.2
    ## 1728       7     5.8
    ## 1729     7.3     8.7
    ## 1730       7     6.8
    ## 1731     7.4     5.7
    ## 1732     7.4     5.9
    ## 1733     7.1     5.7
    ## 1734     7.2     6.2
    ## 1735     7.4     6.3
    ## 1736     6.3     5.5
    ## 1737    <NA>     7.9
    ## 1738     6.5     6.9
    ## 1739       7     7.8
    ## 1740     7.2     7.7
    ## 1741     7.1     9.3
    ## 1742     7.4     6.0
    ## 1743    <NA>     7.9
    ## 1744    <NA>     8.4
    ## 1745     6.9     6.0
    ## 1746     7.3     5.5
    ## 1747     7.1     7.2
    ## 1748     7.3     7.3
    ## 1749       7     6.3
    ## 1750     7.3     7.9
    ## 1751     7.2     7.7
    ## 1752     7.1     8.1
    ## 1753     7.3     9.0
    ## 1754     7.2     8.8
    ## 1755     7.4     6.4
    ## 1756     7.2     8.5
    ## 1757     6.8     4.7
    ## 1758     6.8     9.1
    ## 1759     7.3     8.6
    ## 1760     7.6     6.9
    ## 1761     7.2     8.5
    ## 1762     7.3     8.7
    ## 1763     7.1     6.9
    ## 1764     6.9     5.5
    ## 1765       7     8.2
    ## 1766     7.2     7.2
    ## 1767       7     7.6
    ## 1768     7.2     7.5
    ## 1769     6.8     6.2
    ## 1770     7.1    10.9
    ## 1771     7.2     8.2
    ## 1772     7.1     7.3
    ## 1773       7     6.6
    ## 1774     7.2     8.4
    ## 1775     7.2     6.8
    ## 1776     7.3     8.7
    ## 1777     7.3     6.1
    ## 1778     7.8    11.1
    ## 1779     6.9     8.7
    ## 1780     7.1     9.2
    ## 1781     6.7     7.4
    ## 1782       7     8.6
    ## 1783     7.5     6.4
    ## 1784     7.1     9.1
    ## 1785     7.2     7.3
    ## 1786     7.5     6.2
    ## 1787     7.4     6.0
    ## 1788     7.2     6.5
    ## 1789       7     7.8
    ## 1790     6.4     7.7
    ## 1791     6.9     8.2
    ## 1792     6.9     9.2
    ## 1793     7.5     7.7
    ## 1794     7.1     6.9
    ## 1795     7.2    10.1
    ## 1796     7.1     7.2
    ## 1797     6.8     5.3
    ## 1798     6.6     7.6
    ## 1799     7.5     8.7
    ## 1800     7.3     7.5
    ## 1801     6.9     7.7
    ## 1802       7     9.0
    ## 1803       7     7.5
    ## 1804     7.4     8.6
    ## 1805     7.4     6.6
    ## 1806     7.2     8.6
    ## 1807     8.3    11.6
    ## 1808     6.9     6.5
    ## 1809       7     6.9
    ## 1810     7.4     8.7
    ## 1811     7.2     7.1
    ## 1812     7.2     6.4
    ## 1813     6.6     8.6
    ## 1814              NA
    ## 1815     7.2     7.3
    ## 1816     7.4     5.9
    ## 1817     7.1     9.3
    ## 1818     7.2     8.5
    ## 1819     7.1     6.8
    ## 1820     7.1     6.7
    ## 1821     7.3     6.5
    ## 1822     7.1     7.9
    ## 1823     6.8     8.0
    ## 1824     7.1     7.3
    ## 1825     7.3     7.7
    ## 1826     6.6     7.8
    ## 1827     6.6     7.4
    ## 1828     7.2     7.0
    ## 1829     7.4     8.8
    ## 1830     6.9     6.6
    ## 1831     7.2     9.0
    ## 1832     7.3     6.4
    ## 1833     7.1     8.0
    ## 1834     7.2     9.3
    ## 1835     7.2     8.1
    ## 1836     7.5     5.7
    ## 1837     6.7     7.3
    ## 1838     7.2     7.4
    ## 1839     7.2     9.0
    ## 1840       7     6.9
    ## 1841     6.9      NA
    ## 1842     7.4     5.5
    ## 1843     7.1     7.9
    ## 1844     7.6     9.8
    ## 1845       8    10.0
    ## 1846     7.2     8.4
    ## 1847       7      NA
    ## 1848     7.1     7.1
    ## 1849     6.8     7.6
    ## 1850     7.2     6.3
    ## 1851     7.4      NA
    ## 1852     7.2     7.3
    ## 1853     7.3     6.3
    ## 1854     7.3     6.9
    ## 1855     7.2     7.9
    ## 1856     7.1     7.6
    ## 1857     7.3     9.9
    ## 1858     7.7     8.9
    ## 1859     7.2     8.1
    ## 1860     7.4     8.5
    ## 1861     7.5     5.2
    ## 1862     7.2     7.1
    ## 1863       7     8.1
    ## 1864       7     9.0
    ## 1865     7.3     9.6
    ## 1866     7.1     8.7
    ## 1867       7     6.2
    ## 1868     7.2     8.2
    ## 1869     7.3     5.6
    ## 1870     6.8     5.0
    ## 1871     7.2     7.3
    ## 1872     6.6     9.2
    ## 1873     7.3     5.3
    ## 1874     7.4     8.2
    ## 1875     7.2     7.4
    ## 1876    None     8.8
    ## 1877     7.3     8.6
    ## 1878       7     8.7
    ## 1879       7     8.2
    ## 1880     7.1     8.6
    ## 1881     7.3     9.4
    ## 1882     6.8     9.7
    ## 1883       7     7.7
    ## 1884       7     7.4
    ## 1885     7.2     7.0
    ## 1886     7.6     6.5
    ## 1887     6.5     6.3
    ## 1888     7.2     7.3
    ## 1889       8    11.0
    ## 1890     7.2     7.8
    ## 1891     7.5     6.4
    ## 1892     7.4     8.0
    ## 1893       7     7.0
    ## 1894     7.3     5.3
    ## 1895       7     6.6
    ## 1896     7.4     6.0
    ## 1897     7.3     5.6
    ## 1898     7.1     7.7
    ## 1899       7     6.4
    ## 1900     7.2     7.9
    ## 1901    <NA>     5.9
    ## 1902     7.4     6.6
    ## 1903     7.2     9.0
    ## 1904     6.8     5.2
    ## 1905     7.5     5.6
    ## 1906     7.4     6.6
    ## 1907     7.4     5.7
    ## 1908     7.2     4.1
    ## 1909     7.7     9.9
    ## 1910     7.3      NA
    ## 1911       7     7.7
    ## 1912     7.4     5.8
    ## 1913             6.0
    ## 1914     7.1     7.2
    ## 1915     7.2     9.0
    ## 1916     7.1     6.4
    ## 1917     7.7     7.5
    ## 1918     7.2     8.3
    ## 1919       7     7.6
    ## 1920     8.9     9.9
    ## 1921     7.3      NA
    ## 1922     7.2     8.7
    ## 1923     7.3     8.6
    ## 1924     6.6     8.1
    ## 1925    <NA>     7.3
    ## 1926     7.5     6.1
    ## 1927     7.1     8.5
    ## 1928    <NA>     9.4
    ## 1929     7.1     6.6
    ## 1930     7.3     5.8
    ## 1931     7.1     6.8
    ## 1932     7.1     7.5
    ## 1933     7.6     8.3
    ## 1934     7.2     8.1
    ## 1935       7     7.4
    ## 1936     7.3     8.9
    ## 1937     7.4     5.4
    ## 1938     7.3     8.6
    ## 1939     7.5     6.5
    ## 1940     7.4     5.6
    ## 1941     7.5     5.7
    ## 1942             6.3
    ## 1943     7.5     8.8
    ## 1944     7.3     8.8
    ## 1945     7.2     7.7
    ## 1946     6.9     8.7
    ## 1947       8     7.5
    ## 1948     7.4     6.4
    ## 1949     7.1     8.0
    ## 1950     6.9     5.5
    ## 1951       7     8.2
    ## 1952       7     7.8
    ## 1953     7.2     8.9
    ## 1954     7.4     6.6
    ## 1955     7.2     7.0
    ## 1956     7.5     7.2
    ## 1957     7.7     9.2
    ## 1958     7.8     9.2
    ## 1959     7.3     9.0
    ## 1960     7.4     7.6
    ## 1961     6.9     5.9
    ## 1962    <NA>     6.5
    ## 1963     6.9     8.3
    ## 1964     7.2     7.3
    ## 1965     7.2     8.0
    ## 1966     7.4     8.6
    ## 1967     7.6     8.8
    ## 1968     7.2     6.3
    ## 1969     6.9     9.8
    ## 1970     7.2     8.6
    ## 1971     7.6     9.8
    ## 1972     6.5     6.3
    ## 1973     6.8     8.5
    ## 1974     7.3     9.0
    ## 1975     7.2     7.0
    ## 1976     6.8     4.2
    ## 1977     7.4     5.9
    ## 1978       7     7.2
    ## 1979     7.3     8.7
    ## 1980       7     6.5
    ## 1981     7.2     7.3
    ## 1982     7.2     7.5
    ## 1983     7.2     7.0
    ## 1984     7.1     7.7
    ## 1985    <NA>     8.2
    ## 1986     7.2     7.9
    ## 1987     7.3     8.1
    ## 1988     7.1     5.6
    ## 1989       7     9.2
    ## 1990     7.2      NA
    ## 1991     7.2     7.3
    ## 1992     7.1     7.7
    ## 1993     6.8     7.4
    ## 1994     7.2     8.2
    ## 1995     7.2     8.1
    ## 1996     7.1     8.5
    ## 1997     7.6     8.8
    ## 1998     6.8     7.5
    ## 1999       7     6.7
    ## 2000       7     9.9
    ## 2001     7.2     8.2
    ## 2002     7.2     6.7
    ## 2003     7.2     7.5
    ## 2004     6.9      NA
    ## 2005     6.8     8.0
    ## 2006     7.1     7.4
    ## 2007       7     7.1
    ## 2008     7.2     6.7
    ## 2009     7.1     6.8
    ## 2010     6.8     3.7
    ## 2011     6.6     7.0
    ## 2012       7     7.2
    ## 2013     7.2     6.8
    ## 2014     7.2     7.4
    ## 2015     7.3     6.5
    ## 2016       7     8.4
    ## 2017     7.3     5.3
    ## 2018     7.2     6.8
    ## 2019     6.6     7.2
    ## 2020     7.2     8.0
    ## 2021     7.2     7.3
    ## 2022     7.4     5.3
    ## 2023     7.3     5.7
    ## 2024     7.4     7.7
    ## 2025     7.4     9.9
    ## 2026     6.6     7.3
    ## 2027     7.1     9.8
    ## 2028     7.4     5.6
    ## 2029       7     7.0
    ## 2030       7     7.5
    ## 2031     7.2     7.0
    ## 2032     7.5     8.8
    ## 2033     6.7     8.3
    ## 2034     7.1     8.9
    ## 2035       7     7.8
    ## 2036     7.3     9.1
    ## 2037     7.1     8.3
    ## 2038    <NA>     9.1
    ## 2039     7.2      NA
    ## 2040     7.2     8.5
    ## 2041     7.2     7.5
    ## 2042     7.2     8.5
    ## 2043       7     8.4
    ## 2044     7.2     8.4
    ## 2045     7.3     8.7
    ## 2046     7.3     8.9
    ## 2047     7.5     5.1
    ## 2048     7.1     7.6
    ## 2049     7.2     7.5
    ## 2050     6.7     7.0
    ## 2051     6.8     3.8
    ## 2052     6.9     8.4
    ## 2053     6.2     5.6
    ## 2054     6.9     6.2
    ## 2055       7     6.9
    ## 2056     8.1    10.9
    ## 2057     7.2     7.7
    ## 2058     7.2     6.8
    ## 2059     7.4     6.6
    ## 2060     6.9     5.4
    ## 2061       7     8.5
    ## 2062     7.1     7.8
    ## 2063    <NA>     8.8
    ## 2064     7.2     8.7
    ## 2065     6.8     8.2
    ## 2066       7     7.4
    ## 2067       7     7.4
    ## 2068     6.8     7.5
    ## 2069    <NA>     9.2
    ## 2070     7.2     7.8
    ## 2071     7.2     7.4
    ## 2072     7.4     6.2
    ## 2073     7.3     6.4
    ## 2074     7.2     8.4
    ## 2075       7     6.6
    ## 2076     7.2     7.3
    ## 2077     7.2     6.5
    ## 2078     7.3     6.7
    ## 2079     7.2     6.9
    ## 2080       7     8.3
    ## 2081     7.2     8.3
    ## 2082       7     6.5
    ## 2083       7     7.4
    ## 2084     7.2     9.8
    ## 2085     7.5     7.0
    ## 2086     7.1     6.7
    ## 2087     7.3     5.1
    ## 2088     7.3     6.2
    ## 2089     7.2      NA
    ## 2090     7.2     8.6
    ## 2091       7     7.4
    ## 2092     6.8     8.4
    ## 2093     6.9     8.2
    ## 2094     7.5     7.4
    ## 2095     6.9     6.4
    ## 2096     7.2     8.2
    ## 2097     7.6     9.5
    ## 2098     7.2     7.6
    ## 2099     7.4     6.7
    ## 2100     8.9    12.6
    ## 2101     7.2     7.9
    ## 2102     7.1     7.8
    ## 2103    <NA>     8.8
    ## 2104     7.2     8.9
    ## 2105     7.8    10.5
    ## 2106     6.6     7.0
    ## 2107     7.4     8.0
    ## 2108    <NA>     6.6
    ## 2109       7     6.6
    ## 2110     7.3     5.2
    ## 2111     7.3     7.6
    ## 2112       7     7.2
    ## 2113     7.2     8.7
    ## 2114     7.1     6.2
    ## 2115    <NA>     7.8
    ## 2116     7.3     8.4
    ## 2117     6.9     7.4
    ## 2118     7.1     5.9
    ## 2119     7.1     8.0
    ## 2120     7.5     7.7
    ## 2121     7.4     6.4
    ## 2122     7.2     6.6
    ## 2123     7.2     8.0
    ## 2124     7.2      NA
    ## 2125     7.2     8.7
    ## 2126     7.3     8.6
    ## 2127     7.2     6.2
    ## 2128     7.3     9.1
    ## 2129     7.1     6.6
    ## 2130     7.3     8.6
    ## 2131     7.2     8.1
    ## 2132     8.9    11.7
    ## 2133     7.2     9.0
    ## 2134     7.2     7.6
    ## 2135     7.3     8.8
    ## 2136     7.2     7.6
    ## 2137     7.5     8.1
    ## 2138    <NA>     7.1
    ## 2139     6.8     3.3
    ## 2140     7.2     8.9
    ## 2141     7.5     9.4
    ## 2142     7.6     7.1
    ## 2143     7.4     5.2
    ## 2144       7     8.3
    ## 2145     7.2     8.7
    ## 2146       7     8.5
    ## 2147     7.2     7.3
    ## 2148     7.1     8.8
    ## 2149     6.9     6.7
    ## 2150     6.8     5.3
    ## 2151     7.5     6.0
    ## 2152       7     5.9
    ## 2153     7.2     7.9
    ## 2154       7     6.8
    ## 2155     7.1     7.8
    ## 2156     7.1     7.6
    ## 2157       7     7.2
    ## 2158     7.4     7.4
    ## 2159     7.3     5.3
    ## 2160     7.5     5.9
    ## 2161     7.1     8.6
    ## 2162       7     7.4
    ## 2163     6.3     5.5
    ## 2164       7     7.7
    ## 2165     7.2     7.5
    ## 2166     7.3     8.0
    ## 2167     7.1     7.7
    ## 2168     7.1     8.3
    ## 2169     7.2     8.8
    ## 2170     7.4     9.6
    ## 2171     7.2     9.1
    ## 2172     7.2     7.6
    ## 2173     7.5     6.4
    ## 2174     7.4     5.9
    ## 2175     6.9      NA
    ## 2176     7.1     8.6
    ## 2177     7.3     9.1
    ## 2178     7.6     6.3
    ## 2179     6.9     7.4
    ## 2180     7.2     6.5
    ## 2181     6.7     7.5
    ## 2182     7.5     9.8
    ## 2183     7.2     6.4
    ## 2184       7     8.6
    ## 2185     7.2     8.8
    ## 2186     7.3     5.6
    ## 2187     6.9     7.1
    ## 2188     7.2     8.1
    ## 2189     7.4     7.0
    ## 2190     7.2     7.6
    ## 2191     6.4     7.1
    ## 2192     6.8     9.6
    ## 2193     7.5     5.4
    ## 2194     6.7     7.3
    ## 2195     7.6     9.8
    ## 2196    <NA>     5.2
    ## 2197     7.1     7.6
    ## 2198     7.2     9.2
    ## 2199     7.3    10.8
    ## 2200     7.1     8.6
    ## 2201     6.8     4.4
    ## 2202       7     7.5
    ## 2203     7.4     9.6
    ## 2204     7.3     6.2
    ## 2205       7     6.3
    ## 2206     7.5     5.8
    ## 2207     7.2      NA
    ## 2208     6.6     7.3
    ## 2209     7.2     9.2
    ## 2210       7     6.1
    ## 2211     6.6     8.6
    ## 2212     7.3     8.6
    ## 2213     7.3     8.8
    ## 2214     7.1     7.6
    ## 2215     7.3     6.7
    ## 2216     7.3     5.0
    ## 2217     7.2     8.3
    ## 2218     6.5     8.3
    ## 2219     7.2     7.3
    ## 2220     7.4     7.0
    ## 2221     7.3     7.9
    ## 2222     6.9     9.5
    ## 2223     7.4     7.7
    ## 2224     6.7     8.5
    ## 2225       7     8.5
    ## 2226     7.2     8.1
    ## 2227     7.4     5.0
    ## 2228     7.2     6.8
    ## 2229     7.1     8.1
    ## 2230     6.9     9.9
    ## 2231     7.2     8.2
    ## 2232             8.9
    ## 2233     6.8    10.0
    ## 2234     7.3     9.0
    ## 2235     8.7    12.2
    ## 2236     7.1     7.1
    ## 2237     7.3     6.8
    ## 2238     7.5    10.4
    ## 2239     7.4     8.7
    ## 2240     7.1     8.1
    ## 2241     6.9     7.8
    ## 2242     6.5     7.1
    ## 2243     6.8     8.2
    ## 2244       7     8.5
    ## 2245     6.8     9.5
    ## 2246     7.1     6.3
    ## 2247    <NA>     5.6
    ## 2248       7     8.2
    ## 2249     7.3     8.9
    ## 2250     7.1     8.2
    ## 2251     7.2     6.7
    ## 2252     7.4     9.6
    ## 2253       7     6.7
    ## 2254     6.8     9.5
    ## 2255     7.1     5.4
    ## 2256     7.1     6.8
    ## 2257     7.2     7.1
    ## 2258     6.8     9.2
    ## 2259     7.4     6.4
    ## 2260     8.9      NA
    ## 2261     7.4     7.7
    ## 2262     6.7     9.5
    ## 2263     7.4     5.7
    ## 2264     6.9     6.3
    ## 2265     7.1     7.4
    ## 2266     7.5     7.6
    ## 2267     7.2     8.6
    ## 2268     6.8     8.4
    ## 2269       7     6.8
    ## 2270     7.1     8.8
    ## 2271     7.4     6.6
    ## 2272     6.6     8.4
    ## 2273     7.2     7.5
    ## 2274     7.2     7.2
    ## 2275     7.1     9.1
    ## 2276     6.5     8.3
    ## 2277     7.1     9.2
    ## 2278     6.9     8.3
    ## 2279       7     9.4
    ## 2280     7.3     8.3
    ## 2281       7     7.8
    ## 2282     7.4     5.7
    ## 2283     7.2     6.8
    ## 2284     6.8     9.6
    ## 2285     7.2     8.6
    ## 2286     7.3    10.0
    ## 2287       7     6.3
    ## 2288     7.7     7.8
    ## 2289     6.9     7.2
    ## 2290    <NA>     5.6
    ## 2291     6.9     7.4
    ## 2292     7.4     6.2
    ## 2293       7     6.7
    ## 2294     7.2     7.9
    ## 2295     7.2    10.0
    ## 2296     7.1     8.3
    ## 2297     7.3     8.8
    ## 2298    <NA>     7.0
    ## 2299     7.3     7.4
    ## 2300     7.1     7.2
    ## 2301       7     7.1
    ## 2302    <NA>     8.2
    ## 2303     7.3     7.8
    ## 2304       7     6.4
    ## 2305    None     7.0
    ## 2306     7.1     8.0
    ## 2307     7.2     8.8
    ## 2308     7.2     8.8
    ## 2309     7.2     8.7
    ## 2310    <NA>     8.7
    ## 2311     7.1     7.5
    ## 2312     7.3     8.4
    ## 2313       7     9.0
    ## 2314     6.9     6.0
    ## 2315     6.4     7.6
    ## 2316     7.2     6.7
    ## 2317       8    10.9
    ## 2318     7.1      NA
    ## 2319     7.5     6.9
    ## 2320     7.4     5.7
    ## 2321     7.3     8.6
    ## 2322     7.1     7.7
    ## 2323     7.2     7.8
    ## 2324     7.3     9.0
    ## 2325     7.2     8.9
    ## 2326     6.9     6.7
    ## 2327     7.4     6.9
    ## 2328     6.9     6.3
    ## 2329     7.2     8.3
    ## 2330     7.5     5.3
    ## 2331       7     8.2
    ## 2332     7.5     8.7
    ## 2333     6.9     7.4
    ## 2334     7.3     8.1
    ## 2335     6.8     8.5
    ## 2336       7     7.4
    ## 2337       7      NA
    ## 2338     6.8     8.3
    ## 2339       7     7.4
    ## 2340     7.1     7.4
    ## 2341     6.9     8.6
    ## 2342       7     6.8
    ## 2343     7.2     7.7
    ## 2344     6.7     9.6
    ## 2345       7     7.4
    ## 2346       7     7.4
    ## 2347     7.2     8.1
    ## 2348     6.9     7.3
    ## 2349     7.1     8.2
    ## 2350     7.1     7.3
    ## 2351     7.2     8.1
    ## 2352     6.9    10.0
    ## 2353     7.3     8.2
    ## 2354       7     7.3
    ## 2355     7.4    10.3
    ## 2356     7.2     8.4
    ## 2357     7.3     5.3
    ## 2358       7     6.9
    ## 2359    <NA>     7.7
    ## 2360     7.2     6.3
    ## 2361     7.3     8.8
    ## 2362     6.7     7.4
    ## 2363     6.8      NA
    ## 2364     7.3     8.6
    ## 2365       7     8.4
    ## 2366     7.3     8.7
    ## 2367       7     6.9
    ## 2368     7.1     5.8
    ## 2369     7.3     5.9
    ## 2370     7.2     9.2
    ## 2371     7.1     7.5
    ## 2372     7.2     7.3
    ## 2373       7     7.3
    ## 2374     7.4     7.5
    ## 2375     7.8     9.3
    ## 2376     6.9     6.6
    ## 2377     7.4     5.0
    ## 2378       7     9.8
    ## 2379       7     7.9
    ## 2380     7.3     6.9
    ## 2381     7.2     9.4
    ## 2382     7.3     8.3
    ## 2383     7.5     8.1
    ## 2384     7.1     7.2
    ## 2385     7.3     9.0
    ## 2386     7.2     7.3
    ## 2387     7.2     8.5
    ## 2388     7.1      NA
    ## 2389     7.1     7.4
    ## 2390     7.6     6.6
    ## 2391       7     8.7
    ## 2392     7.1     8.1
    ## 2393       7     6.9
    ## 2394     7.2     6.6
    ## 2395     6.8     7.6
    ## 2396     7.2     9.4
    ## 2397       7     6.9
    ## 2398     7.1     7.8
    ## 2399    <NA>     7.2
    ## 2400     7.1     9.3
    ## 2401     7.1     7.0
    ## 2402     7.2     3.7
    ## 2403     7.3     9.4
    ## 2404     7.3     6.1
    ## 2405     7.5     6.1
    ## 2406     7.1     7.6
    ## 2407     7.1     6.8
    ## 2408     6.9     7.0
    ## 2409     7.3     5.4
    ## 2410     6.6     6.8
    ## 2411     7.2     9.1
    ## 2412     7.1     7.7
    ## 2413     6.9     6.5
    ## 2414     7.1     8.8
    ## 2415     7.2     8.0
    ## 2416     7.2     8.4
    ## 2417     7.2     8.2
    ## 2418     7.1     7.3
    ## 2419     7.5     5.3
    ## 2420     6.9     8.6
    ## 2421     7.1     7.2
    ## 2422     7.2     8.0
    ## 2423     7.2     8.2
    ## 2424     6.8    10.0
    ## 2425     7.1     7.0
    ## 2426       7     8.0
    ## 2427       7     7.1
    ## 2428     7.3     7.8
    ## 2429     7.7     6.5
    ## 2430     7.2     7.2
    ## 2431     6.9     8.3
    ## 2432     7.2     7.8
    ## 2433       9    10.8
    ## 2434       7     8.0
    ## 2435     8.3    10.3
    ## 2436     7.1     7.5
    ## 2437     6.8     9.7
    ## 2438       7     7.7
    ## 2439     7.2     8.5
    ## 2440     7.2     8.9
    ## 2441     7.3     9.4
    ## 2442     7.6     8.3
    ## 2443     7.5     5.2
    ## 2444     7.2     6.6
    ## 2445     7.2     8.7
    ## 2446     7.3     7.6
    ## 2447       7     6.3
    ## 2448     7.4     6.1
    ## 2449     6.8    10.0
    ## 2450     7.4     7.4
    ## 2451     7.5     6.3
    ## 2452     6.8     7.6
    ## 2453     6.9     7.1
    ## 2454     7.2     8.5
    ## 2455       7      NA
    ## 2456     7.1     6.8
    ## 2457     8.3    10.1
    ## 2458     7.1     5.3
    ## 2459       7     7.4
    ## 2460     7.2     6.7
    ## 2461       7     7.4
    ## 2462     7.1     7.9
    ## 2463       7     7.3
    ## 2464     7.2     8.4
    ## 2465     7.1     8.4
    ## 2466       7     9.4
    ## 2467     7.3     7.8
    ## 2468    <NA>     9.0
    ## 2469     7.4     6.3
    ## 2470     7.3     6.2
    ## 2471       7     6.9
    ## 2472     7.6     6.2
    ## 2473       7     6.4
    ## 2474     7.9     6.7
    ## 2475     7.8    10.8
    ## 2476     7.5     7.9
    ## 2477     7.2     7.4
    ## 2478     7.1     7.6
    ## 2479     8.3     9.3
    ## 2480     7.4     8.9
    ## 2481     7.5     7.9
    ## 2482     7.3     5.6
    ## 2483     7.6     8.9
    ## 2484     7.1     9.1
    ## 2485     7.1     7.5
    ## 2486     7.2     9.4
    ## 2487     6.8     9.8
    ## 2488     7.3     8.1
    ## 2489     7.5     6.2
    ## 2490            10.7
    ## 2491     7.5     7.9
    ## 2492     7.6     7.8
    ## 2493     7.1     7.8
    ## 2494       7     8.5
    ## 2495     7.3     6.2
    ## 2496     7.4     6.5
    ## 2497     6.5     7.2
    ## 2498     7.1     8.9
    ## 2499     7.1     8.5
    ## 2500     7.3     8.2
    ## 2501     7.3     8.5
    ## 2502     7.1     6.8
    ## 2503     7.2     8.3
    ## 2504     7.1     9.1
    ## 2505     7.4     6.6
    ## 2506     7.2     7.0
    ## 2507     6.9     7.4
    ## 2508     7.1     7.7
    ## 2509    <NA>     8.2
    ## 2510     6.9     6.3
    ## 2511     6.9     6.7
    ## 2512     6.6     7.2
    ## 2513     7.1     8.2
    ## 2514     6.7     7.5
    ## 2515     7.1     7.4
    ## 2516     7.1     6.5
    ## 2517     7.3     9.1
    ## 2518     7.5     5.6
    ## 2519     6.8     4.4
    ## 2520       7     7.5
    ## 2521     6.5     6.5
    ## 2522     7.2     8.3
    ## 2523     7.1     7.2
    ## 2524     7.5     8.6
    ## 2525     7.4     5.7
    ## 2526     7.2     8.2
    ## 2527     7.3     8.7
    ## 2528     7.2     8.0
    ## 2529     7.1     9.4
    ## 2530     7.2     7.2
    ## 2531     7.3     8.0
    ## 2532     7.2     9.1
    ## 2533       7     9.6
    ## 2534     6.2      NA
    ## 2535     7.7     6.4
    ## 2536     7.4     9.8
    ## 2537     7.3     8.0
    ## 2538     6.9     8.1
    ## 2539       7     7.6
    ## 2540     8.2    10.8
    ## 2541     6.8     7.9
    ## 2542     6.3     7.5
    ## 2543     7.1     7.8
    ## 2544     6.8     9.4
    ## 2545    None     9.8
    ## 2546     7.3     6.4
    ## 2547     7.2     8.5
    ## 2548       7     7.4
    ## 2549       7     6.7
    ## 2550     6.5     6.6
    ## 2551     7.4     9.7
    ## 2552     7.4     8.9
    ## 2553     6.8     7.3
    ## 2554     7.2     8.4
    ## 2555     7.6     7.6
    ## 2556     7.1     8.4
    ## 2557     7.4     6.9
    ## 2558     7.4     8.9
    ## 2559     7.1     9.4
    ## 2560     6.6     6.8
    ## 2561     7.1     6.4
    ## 2562     6.9     6.6
    ## 2563       7     8.3
    ## 2564    <NA>     5.4
    ## 2565     7.3     5.7
    ## 2566     7.2     9.0
    ## 2567     6.9     8.0
    ## 2568     7.3     8.6
    ## 2569     7.4     7.8
    ## 2570     6.8     9.4
    ## 2571     7.2     6.9
    ## 2572     7.1     7.2
    ## 2573     7.4     5.8
    ## 2574     7.3     7.6
    ## 2575     7.2     7.3
    ## 2576     7.2     7.9
    ## 2577     6.8     7.0
    ## 2578     7.1     6.3
    ## 2579       7     6.4
    ## 2580     7.4     6.5
    ## 2581    None     5.5
    ## 2582     7.2     7.9
    ## 2583     7.2     6.8
    ## 2584     7.4     6.7
    ## 2585     7.2     6.8
    ## 2586     7.3     6.3
    ## 2587     6.8     7.6
    ## 2588     7.3     5.5
    ## 2589     7.4     7.4
    ## 2590     7.1     7.7
    ## 2591     7.1     8.5
    ## 2592       7     7.7
    ## 2593     6.9     6.5
    ## 2594     7.2     8.5
    ## 2595     7.1     7.6
    ## 2596    <NA>     8.4
    ## 2597    <NA>     7.3
    ## 2598       7     6.2
    ## 2599     7.3     8.2
    ## 2600     7.1     6.3
    ## 2601     7.1     6.4
    ## 2602     6.5     7.2
    ## 2603     6.9     6.4
    ## 2604     6.9     5.4
    ## 2605     7.2     8.2
    ## 2606     7.4     7.8
    ## 2607     7.3     8.3
    ## 2608       7     7.9
    ## 2609     6.8     4.4
    ## 2610       7     8.6
    ## 2611     6.9     5.3
    ## 2612     7.2     8.2
    ## 2613     7.7     6.6
    ## 2614     7.1     8.8
    ## 2615     7.2     5.3
    ## 2616     7.1     6.9
    ## 2617     7.1     7.4
    ## 2618     7.2     8.4
    ## 2619       7     6.5
    ## 2620     7.2     8.7
    ## 2621     6.7     6.0
    ## 2622     7.2     7.6
    ## 2623     7.4      NA
    ## 2624       7     8.2
    ## 2625     6.8      NA
    ## 2626     7.3     9.6
    ## 2627     7.2     8.9
    ## 2628       7     7.5
    ## 2629     6.9     5.8
    ## 2630     7.3    10.3
    ## 2631     7.4     8.2
    ## 2632     7.4     9.2
    ## 2633     7.5     5.2
    ## 2634     6.9     8.0
    ## 2635     7.6     9.4
    ## 2636     7.1     7.2
    ## 2637     8.1    11.5
    ## 2638       7     7.8
    ## 2639     7.2     8.3
    ## 2640     7.3     8.8
    ## 2641       7     6.9
    ## 2642     7.1     7.3
    ## 2643     8.4     9.1
    ## 2644    <NA>     7.3
    ## 2645     7.4     6.0
    ## 2646     6.9     8.5
    ## 2647     7.4     8.0
    ## 2648     7.5     8.4
    ## 2649       7     7.0
    ## 2650     6.8     7.1
    ## 2651       7     8.7
    ## 2652     7.2     7.6
    ## 2653     7.1     6.0
    ## 2654     7.1     6.2
    ## 2655     7.3     8.4
    ## 2656     7.1     7.7
    ## 2657     7.4     6.3
    ## 2658     8.9    11.2
    ## 2659     7.1     7.7
    ## 2660     7.6     8.1
    ## 2661     7.2     6.9
    ## 2662     7.1     7.5
    ## 2663       7     8.8
    ## 2664     7.1     5.6
    ## 2665     7.1     8.4
    ## 2666     7.4     6.3
    ## 2667     7.2     6.7
    ## 2668     6.5     6.5
    ## 2669     7.1     6.3
    ## 2670     7.1     5.3
    ## 2671     7.3     8.5
    ## 2672     7.2     8.9
    ## 2673     7.2     8.2
    ## 2674     7.6     7.7
    ## 2675     7.3     8.8
    ## 2676     7.2     7.4
    ## 2677     7.1     7.2
    ## 2678     7.4     5.7
    ## 2679     7.2     8.9
    ## 2680     7.3     7.4
    ## 2681     7.1     6.9
    ## 2682     7.2     8.0
    ## 2683     7.4     8.4
    ## 2684     7.2     5.8
    ## 2685     7.2     7.6
    ## 2686     6.9     7.5
    ## 2687     7.3     9.3
    ## 2688     6.9     6.5
    ## 2689     6.5     6.3
    ## 2690     7.1     6.3
    ## 2691       7     8.0
    ## 2692     7.2     8.3
    ## 2693     7.4     6.4
    ## 2694     7.2     7.6
    ## 2695     7.1     7.4
    ## 2696       8    11.8
    ## 2697     7.4     6.8
    ## 2698     7.3     6.8
    ## 2699     7.1     7.3
    ## 2700     7.5     6.2
    ## 2701    <NA>     6.0
    ## 2702       7     9.4
    ## 2703     7.2    10.0
    ## 2704     7.3      NA
    ## 2705     7.3     6.1
    ## 2706     7.5     7.3
    ## 2707     7.4     8.0
    ## 2708    <NA>    10.0
    ## 2709     6.8     7.8
    ## 2710     7.3     7.9
    ## 2711     7.4     5.3
    ## 2712     8.8    12.4
    ## 2713     7.3     8.7
    ## 2714     7.2     7.6
    ## 2715     7.5      NA
    ## 2716     6.4     7.4
    ## 2717     6.9     9.7
    ## 2718     7.6     6.2
    ## 2719     7.5     9.8
    ## 2720     7.1     7.4
    ## 2721     7.1     8.0
    ## 2722       7     7.9
    ## 2723       7     8.6
    ## 2724     6.9     7.2
    ## 2725       7     6.9
    ## 2726     7.2     8.5
    ## 2727     7.1     7.6
    ## 2728     7.1     8.6
    ## 2729     7.4     6.7
    ## 2730     7.3     8.1
    ## 2731     6.7     9.4
    ## 2732     7.1     8.9
    ## 2733     7.4     5.4
    ## 2734     6.8     8.3
    ## 2735     7.1     6.2
    ## 2736     7.1     7.3
    ## 2737     7.1     7.3
    ## 2738     7.2     8.1
    ## 2739     7.2     6.5
    ## 2740     6.4     7.6
    ## 2741     7.2     8.0
    ## 2742     7.2     7.8
    ## 2743     7.1      NA
    ## 2744     7.2     8.7
    ## 2745     7.5     7.9
    ## 2746     7.4     6.8
    ## 2747     7.2     8.0
    ## 2748     6.9     9.6
    ## 2749     7.1     7.0
    ## 2750     7.4    10.5
    ## 2751       7     6.9
    ## 2752     7.2     8.4
    ## 2753     7.2     7.9
    ## 2754     7.3      NA
    ## 2755     7.2     8.8
    ## 2756     7.2     8.0
    ## 2757       7     6.5
    ## 2758       7     8.7
    ## 2759     6.7     7.8
    ## 2760     7.3     7.0
    ## 2761     7.1     6.3
    ## 2762     7.2     7.8
    ## 2763     7.2     8.4
    ## 2764     6.8     7.5
    ## 2765     7.2     8.0
    ## 2766     7.5     9.9
    ## 2767     7.1     8.4

### Optional: the `ifelse` function

Let's learn a new way to apply if-else logic - the function `ifelse`. This function is similar to the previous if-else structure syntax, but the function can only return one value (rather than doing a series of commands within `{}`). See `?ifelse` for more information. Basic syntax for `ifelse()`:

`ifelse(condition, yesValue, noValue)`

Add a new column to `intro_df` that removes the flow value if it is erroneous (code is "X"), otherewise, retain the flow value.

``` r
#use mutate along with ifelse to add a new column
intro_df_revised <- mutate(intro_df, Flow_revised = ifelse(Flow_Inst_cd == "X", NA, Flow_Inst))
```

Three ways to string `dplyr` commands together
----------------------------------------------

But what if I wanted to select and filter the same data frame? There are three ways to do this: use intermediate steps, nested functions, or pipes. With the intermediate steps, you essentially create a temporary data frame and use that as input to the next function. You can also nest functions (i.e. one function inside of another). This is handy, but can be difficult to read if too many functions are nested from inside out. The last option, pipes, are a fairly recent addition to R. Pipes in the Unix/Linux world are not new and allow you to chain commands together where the output of one command is the input to the next. This provides a more natural way to read the commands in that they are executed in the way you conceptualize it and make the interpretation of the code a bit easier. Pipes in R look like `%>%` and are made available via the `magrittr` package, which is installed as part of `dplyr`. Let's try all three with the same analysis: selecting out a subset of columns but only for the discharge qualifier (`Flow_Inst_cd`) indicating an erroneous value, "X".

``` r
#Intermediate data frames
dplyr_error_tmp1 <- select(intro_df, site_no, dateTime, Flow_Inst, Flow_Inst_cd)
dplyr_error_tmp <- filter(dplyr_error_tmp1, Flow_Inst_cd == "X")
head(dplyr_error_tmp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-03 21:45:00      14.0            X
    ## 2 02336300 2011-05-01 08:00:00      32.0            X
    ## 3 02336300 2011-05-03 00:15:00      32.0            X
    ## 4 02336728 2011-05-22 03:30:00       9.7            X
    ## 5 02336360 2011-06-01 00:15:00       7.2            X
    ## 6 02336410 2011-05-14 02:30:00      16.0            X

``` r
#Nested function
dplyr_error_nest <- filter(
  select(intro_df, site_no, dateTime, Flow_Inst, Flow_Inst_cd),
  Flow_Inst_cd == "X")
head(dplyr_error_nest)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-03 21:45:00      14.0            X
    ## 2 02336300 2011-05-01 08:00:00      32.0            X
    ## 3 02336300 2011-05-03 00:15:00      32.0            X
    ## 4 02336728 2011-05-22 03:30:00       9.7            X
    ## 5 02336360 2011-06-01 00:15:00       7.2            X
    ## 6 02336410 2011-05-14 02:30:00      16.0            X

``` r
#Pipes
dplyr_error_pipe <- intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X")
head(dplyr_error_pipe)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-03 21:45:00      14.0            X
    ## 2 02336300 2011-05-01 08:00:00      32.0            X
    ## 3 02336300 2011-05-03 00:15:00      32.0            X
    ## 4 02336728 2011-05-22 03:30:00       9.7            X
    ## 5 02336360 2011-06-01 00:15:00       7.2            X
    ## 6 02336410 2011-05-14 02:30:00      16.0            X

``` r
# Every function, including head(), can be chained
intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X") %>% 
  head()
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-03 21:45:00      14.0            X
    ## 2 02336300 2011-05-01 08:00:00      32.0            X
    ## 3 02336300 2011-05-03 00:15:00      32.0            X
    ## 4 02336728 2011-05-22 03:30:00       9.7            X
    ## 5 02336360 2011-06-01 00:15:00       7.2            X
    ## 6 02336410 2011-05-14 02:30:00      16.0            X

Although we show you the nested and piping methods, we will only use the intermediate data frames method for the remainder of this material.

Cleaning up dataset
-------------------

Before moving on to merging, let's try cleaning up our `intro_df` data.frame. First, take a quick look at the structure: `summary(intro_df)`. Notice anything strange? Hint: why are the pH values character? That shouldn't be the case; there should be numeric values in that column. If there are any entries that are not numeric values or `NA`, R will treat the entire column as character. You can coerce them to numeric (so anything that is not NA or a number will be coerced into NA), but you should investigate what values are causing the issue first. To do this, we coerce to numeric and look at what values were considered NA in the numeric column, but not in the character column.

``` r
pH_df <- select(intro_df, pH_Inst)
pH_numeric_df <- mutate(pH_df, pH_Inst_numeric = as.numeric(pH_Inst))
```

    ## Warning in eval(substitute(expr), envir, enclos): NAs introduced by
    ## coercion

``` r
filter(pH_numeric_df, is.na(pH_Inst_numeric), pH_Inst != "NA")
```

    ##    pH_Inst pH_Inst_numeric
    ## 1     None              NA
    ## 2     None              NA
    ## 3                       NA
    ## 4     None              NA
    ## 5                       NA
    ## 6     None              NA
    ## 7                       NA
    ## 8     None              NA
    ## 9     None              NA
    ## 10                      NA
    ## 11                      NA
    ## 12                      NA
    ## 13    None              NA
    ## 14                      NA
    ## 15                      NA
    ## 16                      NA
    ## 17    None              NA
    ## 18                      NA
    ## 19    None              NA
    ## 20    None              NA

Looks like the culprits are entries of `None` and blank spaces. These are both scenarios that I would feel comfortable setting to NA, so using `as.numeric` will suffice. However, there could have been a symbol that indicated the value should be something other than missing. That's why it is important to check. Let's actually clean up that column and create a new data.frame. Then use `summary()` to verify that the columns are correct.

``` r
intro_df <- mutate(intro_df, pH_Inst = as.numeric(pH_Inst))
```

    ## Warning in eval(substitute(expr), envir, enclos): NAs introduced by
    ## coercion

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

You might have noticed that the date column is treated as character and not Date or POSIX. Handling dates are beyond this course, but they are available in this dataset if you would like to work with them.

Exercise 1
----------

For the remainder of the exercises in this course, we will be using prefabricated datasets from the `smwrData` package. This package is a collection of real hydrologic data that can be loaded into your R workspace and used. It is similar to the stock R datasets (type `data()` into your console to see stock datasets), but with USGS-relevant data. So don't forget to load the package before the exercise.

This exercise is going to focus on using what we just covered on `dplyr` to start to clean up a dataset. Remember to use the stickies: green when you're done, red if you have a problem.

1.  If it isn't already open, make sure you have the script we created, "usgs\_analysis.R" opened up.
2.  Start a new section of code in this script by simply putting in a line or two of comments indicating what it is this set of code does. Our goal for this is to create a new data frame that represents a subset of the observations as well as a subset of the data.
3.  First, we want a new data frame based on the PugetNitrate dataset from the `smwrData` package (don't forget to load your package!). Load the data by executing `data(PugetNitrate)`.
4.  Using dplyr, remove the landuse columns (l10, l20, and l40). Think `select()`. Give the new data frame a new name, so you can distinguish it from your raw data.
5.  Next, we are going to get a subset of the observations. We only want wells where the surficial geology is Alluvium or Fine. Also give this data frame a different name than before.
6.  Lastly, add a new column using an `ifelse` function that tells us if the well depth is "shallow" or "deep" based on the well depth column values `wellmet`. Hint: use `summary(PugetNitrate)` to determine what threshold would determine "shallow" vs "deep" based on the data.

Merging Data
------------

Joining data in `dplyr` is accomplished via the various `x_join()` commands (e.g., `inner_join`, `left_join`, `anti_join`, etc). These are very SQL-esque so if you speak SQL then these will be pretty easy for you. If not then they aren't immediately intuitive. There are also the base functions `rbind()` and `merge()`, but we won't be covering these because they are redundant with the faster, more readable `dplyr` functions.

We are going to talk about several different ways to do this. First, let's add some new rows to a data frame. This is very handy as you might have data collected and entered at one time, and then additional observations made later that need to be added. So with `rbind()` we can stack two data frames with the same columns to store more observations.

In this example, let's imagine we collected 3 new observations for water temperature and pH at the site "00000001". Notice that we did not collect anything for discharge or dissolved oxygen. What happens in the columns that don't match when the we bind the rows of these two data frames?

``` r
#Let's first create a new small example data.frame
new_data <- data.frame(site_no=rep("00000001", 3), 
                       dateTime=c("2016-09-01 07:45:00", "2016-09-02 07:45:00", "2016-09-03 07:45:00"), 
                       Wtemp_Inst=c(14.0, 16.4, 16.0),
                       pH_Inst = c(7.8, 8.5, 8.3),
                       stringsAsFactors = FALSE)
head(new_data)
```

    ##    site_no            dateTime Wtemp_Inst pH_Inst
    ## 1 00000001 2016-09-01 07:45:00       14.0     7.8
    ## 2 00000001 2016-09-02 07:45:00       16.4     8.5
    ## 3 00000001 2016-09-03 07:45:00       16.0     8.3

``` r
#Now add this to our existing df (intro_df)
bind_rows_df <- bind_rows(intro_df, new_data)
tail(bind_rows_df)
```

    ##       site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst
    ## 2998 02336526 2011-05-07 02:45:00       4.8            A       18.7
    ## 2999 02336526 2011-05-14 17:45:00       3.8            E       21.9
    ## 3000 02336360 2011-05-17 05:00:00      11.0            A       16.5
    ## 3001 00000001 2016-09-01 07:45:00        NA         <NA>       14.0
    ## 3002 00000001 2016-09-02 07:45:00        NA         <NA>       16.4
    ## 3003 00000001 2016-09-03 07:45:00        NA         <NA>       16.0
    ##      pH_Inst DO_Inst
    ## 2998     7.2     8.0
    ## 2999     7.5     9.9
    ## 3000     7.1     8.4
    ## 3001     7.8      NA
    ## 3002     8.5      NA
    ## 3003     8.3      NA

Now something to think about. Could you add a vector as a new row? Why/Why not? When/When not?

Let's go back to the columns now. There are simple ways to add columns of the same length with observations in the same order to a data frame, but it is very common to have to datasets that are in different orders and have differing numbers of rows. What we want to do in that case is going to be more of a database type function and join two tables based on a common column. We can achieve this by using `x_join` functions. So let's imagine that we did actually collect dissolved oxygen, discharge, and chloride concentration on our observation dates. Also, we collected on some additional dates. We don't care about the additional dates, so use the `left_join` function from `dplyr`, which keeps all rows from the first (left) data frame. See `?left_join` for more information.

``` r
# DO and discharge data
forgotten_data <- data.frame(site_no=rep("00000001", 5),
                             dateTime=c("2016-09-01 07:45:00", "2016-09-02 07:45:00", "2016-09-03 07:45:00",
                                        "2016-09-04 07:45:00", "2016-09-05 07:45:00"),
                             DO_Inst=c(10.2,8.7,9.3,9.2,8.9),
                             Cl_conc=c(15.6,11.0,14.2,13.6,13.7),
                             Flow_Inst=c(25,54,67,60,59),
                             stringsAsFactors = FALSE)

left_join(new_data, forgotten_data, by=c("site_no", "dateTime"))
```

    ##    site_no            dateTime Wtemp_Inst pH_Inst DO_Inst Cl_conc
    ## 1 00000001 2016-09-01 07:45:00       14.0     7.8    10.2    15.6
    ## 2 00000001 2016-09-02 07:45:00       16.4     8.5     8.7    11.0
    ## 3 00000001 2016-09-03 07:45:00       16.0     8.3     9.3    14.2
    ##   Flow_Inst
    ## 1        25
    ## 2        54
    ## 3        67

Notice that the `left_join` kept only the matching rows (September 1-3), but kept all columns. If we wanted to remove the chloride concentration column, we can use `select` which we learned earlier in this lesson.

Exercise 2
----------

In this exercise we are going to practice merging data. We will be using two datasets from the `smwrData` package.

1.  Load `ChoptankFlow` and `ChoptankNH3` into your environment from the `smwrData` package by using `data()`.
2.  Add to your script a line (or more if you need it) to create a new data frame, `Choptank_Flow_NH3`, that is a merge of `ChoptankFlow` and `ChoptankNH3`, but with only lines in `ChoptankNH3` preserved in the output. The column to merge on is the date column (although named differently in each data frame, but they will need to have the same name to merge).
3.  This data frame may have some `NA` values. Add another line to your code and create a data frame that removes all NA values from `Choptank_Flow_NH3`.
4.  If that goes quickly, feel free to explore other joins (`inner_join`, `full_join`, etc).

Modify and Summarize
--------------------

One area where `dplyr` really shines is in modifying and summarizing. First, we'll look at an example of grouping a data frame and summarizing the data within those groups. We do this with `group_by()` and `summarize()`. You won't notice much of change between this new data frame and the original because `group_by` is changing the class of the data frame so that `dplyr` handles it appropriately in the next function. Let's look at the average discharge and water temperature by site.

``` r
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
intro_df_summary <- summarize(intro_df_grouped, mean(Flow_Inst), mean(Wtemp_Inst))
intro_df_summary
```

    ## Source: local data frame [12 x 3]
    ## 
    ##      site_no mean(Flow_Inst) mean(Wtemp_Inst)
    ##        <chr>           <dbl>            <dbl>
    ## 1  021989773              NA               NA
    ## 2   02203655              NA               NA
    ## 3   02203700              NA               NA
    ## 4   02336120              NA               NA
    ## 5   02336240              NA               NA
    ## 6   02336300              NA               NA
    ## 7   02336313              NA               NA
    ## 8   02336360              NA               NA
    ## 9   02336410              NA               NA
    ## 10  02336526              NA               NA
    ## 11  02336728              NA               NA
    ## 12  02337170              NA               NA

Notice that this summary just returns NAs. We need the mean calculations to ignore the NA values. We could remove the NAs using `filter()` and then pass that data.frame into `summarize`, or we can tell the mean function to ignore the NAs using the argument `na.rm=TRUE` in the `mean` function. See `?mean` to learn more about this argument.

``` r
intro_df_summary <- summarize(intro_df_grouped, mean(Flow_Inst, na.rm=TRUE), mean(Wtemp_Inst, na.rm=TRUE))
intro_df_summary
```

    ## Source: local data frame [12 x 3]
    ## 
    ##      site_no mean(Flow_Inst, na.rm = TRUE) mean(Wtemp_Inst, na.rm = TRUE)
    ##        <chr>                         <dbl>                          <dbl>
    ## 1  021989773                  1913.8848921                       24.41783
    ## 2   02203655                    24.4458101                       20.15225
    ## 3   02203700                     7.2583333                       20.28375
    ## 4   02336120                    51.3655914                       20.76570
    ## 5   02336240                    30.3128099                       20.27397
    ## 6   02336300                    28.1372549                       20.42985
    ## 7   02336313                     0.9892576                       20.75435
    ## 8   02336360                    16.6371324                       20.68986
    ## 9   02336410                    28.4246032                       20.36858
    ## 10  02336526                    21.6340426                       20.78191
    ## 11  02336728                    43.8768868                       20.76798
    ## 12  02337170                  3435.1867220                       17.80897

There are many other functions in `dplyr` that are useful. Let's run through some examples with `arrange()` and `slice()`.

First `arrange()` will re-order a data frame based on the values in a specified column. It will take multiple columns and can be in descending or ascending order.

``` r
#ascending order is default
head(arrange(intro_df, DO_Inst))
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02203700 2011-05-11 07:15:00       4.6          A e       21.4     7.4
    ## 2 02203700 2011-05-11 09:15:00       4.6            A       20.6     7.4
    ## 3 02203700 2011-05-11 07:00:00       4.6          A e       21.5     7.4
    ## 4 02203700 2011-05-12 08:00:00       4.6            A       21.3     6.8
    ## 5 02203700 2011-05-12 06:45:00       4.6            A       21.9     6.8
    ## 6 02203700 2011-05-10 06:00:00       4.9          A e       20.8     7.3
    ##   DO_Inst
    ## 1     3.2
    ## 2     3.3
    ## 3     3.3
    ## 4     3.3
    ## 5     3.4
    ## 6     3.4

``` r
#descending
head(arrange(intro_df, desc(DO_Inst)))
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336526 2011-05-19 22:00:00       3.6            A       19.8     8.9
    ## 2 02336526 2011-05-24 20:15:00       3.0          A e       25.1     8.8
    ## 3 02336526 2011-05-23 20:15:00       3.3            A       24.7     8.8
    ## 4 02336526 2011-05-24 20:00:00       3.0            A       25.0      NA
    ## 5 02336526 2011-05-21 19:15:00       3.5            E       22.7     8.7
    ## 6 02336526 2011-05-23 19:15:00       3.5            A       24.1     8.6
    ##   DO_Inst
    ## 1    12.6
    ## 2    12.4
    ## 3    12.4
    ## 4    12.2
    ## 5    12.2
    ## 6    12.0

``` r
#multiple columns: lowest flow with highest temperature at top
head(arrange(intro_df, Flow_Inst, desc(Wtemp_Inst)))
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 021989773 2011-05-14 20:15:00    -90800            A       24.2     7.3
    ## 2 021989773 2011-05-29 20:30:00    -87100            A       26.9     7.4
    ## 3 021989773 2011-05-15 09:30:00    -84200            X       24.0     7.2
    ## 4 021989773 2011-05-14 20:00:00    -83400            X       24.2     7.3
    ## 5 021989773 2011-05-11 17:00:00    -82500            X       23.5     7.4
    ## 6 021989773 2011-05-02 22:15:00    -82200            A       24.1     7.3
    ##   DO_Inst
    ## 1      NA
    ## 2     5.6
    ## 3     5.4
    ## 4     5.8
    ## 5     6.3
    ## 6     5.9

Now `slice()`, which accomplishes what we did with the numeric indices before. Remembering back to that, we could grab rows of the data frame with something like `intro_df[3:10,]` or we can use `slice`:

``` r
#grab rows 3 through 10
slice(intro_df, 3:10)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 2 02203655 2011-05-25 01:30:00       7.5          A e       23.1     7.0
    ## 3 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 4 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ## 5 02336120 2011-05-12 18:00:00      14.0            A       23.4     7.3
    ## 6 02336300 2011-05-03 00:15:00      32.0            X       22.3     7.3
    ## 7 02336360 2011-05-27 08:15:00     162.0          A e       21.0     6.6
    ## 8 02336120 2011-05-27 17:30:00     162.0            E       21.2     6.4
    ##   DO_Inst
    ## 1     7.6
    ## 2     6.2
    ## 3     7.6
    ## 4     8.1
    ## 5     8.5
    ## 6     7.5
    ## 7     7.6
    ## 8     7.2

Lastly, one more function, `rowwise()`, allows us to run rowwise, operations. Let's say we had two dissolved oxygen columns, and we only wanted to keep the maximum value out of the two for each observation. This can easily be accomplished using`rowwise`. First, add a new dissolved oxygen column with random values (see `?runif`).

``` r
intro_df_2DO <- mutate(intro_df, DO_2 = runif(n=nrow(intro_df), min = 5.0, max = 18.0))
head(intro_df_2DO)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1     7.0
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst      DO_2
    ## 1     8.1  7.184540
    ## 2     7.1 15.497713
    ## 3     7.6 10.004251
    ## 4     6.2  9.260546
    ## 5     7.6 12.827309
    ## 6     8.1 12.857123

Now, let's use `rowwise` to find the maximum dissolved oxygen for each observation.

``` r
head(mutate(intro_df_2DO, max_DO = max(DO_Inst, DO_2)))
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1     7.0
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst      DO_2 max_DO
    ## 1     8.1  7.184540     NA
    ## 2     7.1 15.497713     NA
    ## 3     7.6 10.004251     NA
    ## 4     6.2  9.260546     NA
    ## 5     7.6 12.827309     NA
    ## 6     8.1 12.857123     NA

The max is always NA because it is treating the arguments as vectors. It would be similar to running `max(intro_df_2DO$Flow_Inst, intro_df_2DO$DO_2)`. So we need to group by row. `rowwise()`, like `group_by` will only change the class of the data frame in preparation for the next `dplyr` function.

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
#Add a column that totals landuse for each observation
intro_df_DO_max <- mutate(intro_df_2DO_byrow, max_DO = max(DO_Inst, DO_2))
head(intro_df_DO_max)
```

    ## Source: local data frame [6 x 9]
    ## 
    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ##      <chr>               <chr>     <dbl>        <chr>      <dbl>   <dbl>
    ## 1 02336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 02336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 02337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 02203655 2011-05-25 01:30:00       7.5          A e       23.1     7.0
    ## 5 02336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 02336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ## Variables not shown: DO_Inst <dbl>, DO_2 <dbl>, max_DO <dbl>.

We now have quite a few tools that we can use to clean and manipulate data in R. We have barely touched what both base R and `dplyr` are capable of accomplishing, but hopefully you now have some basics to build on.

Let's practice some of these last functions with other `smwrData` datasets.

Exercise 3
----------

Next, we're going to practice summarizing large datasets. We will use the `MC11_1993` soil temperature dataset from the `smwrdata` package (271 rows, 10 columns). If you complete a step and notice that your neighbor has not, see if you can answer any questions to help them get it done.

1.  Create a new data.frame that gives the maximum reference temperature (`TEMP.REF`) for each month and name it `MC11_1993_max_monthly_ref_temp`. Hint: don't forget about `group_by()`!

2.  Now add a new column that is the average soil temperature at each depth (do not include `TEMP.REF`). Then, sort the resulting data.frame in descending order. Name this new data.frame `MC11_1993_daily_avg_temp`. Hint: use `rowwise` to compute at each depth.

3.  Challenge: Find the average and minimum temperatures (for each month) at depths of 0.5, 1.5, and 2.5 using `summarize_each`.
