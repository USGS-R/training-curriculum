---
author: Jeffrey W. Hollister, Luke Winslow, Lindsay Carr
date: 9999-01-08
slug: Clean
title: C. Clean
image: img/main/intro-icons-300px/clean.png
menu:
  main:
    parent: Introduction to R Course
    weight: 1
---
In this third lesson we are going to start working on manipulating and cleaning up our data frames. We are spending some time on this because, in my experience, most data analysis and statistics classes seem to assume that 95% of the time spent working with data is on the analysis and interpretation of that analysis and little time is spent getting data ready to analyze. However, in reality, the time spent is flipped with most time spent on cleaning up data and significantly less time on the analysis. We will just be scratching the surface of the many ways you can work with data in R. We will show the basics of subsetting, merging, modifying, and sumarizing data and our examples will all use Hadley Wickham and Romain Francois' `dplyr` package. There are many ways to do this type of work in R, many of which are available from base R, but I heard from many focusing on one way to do this is best, so `dplyr` it is!

Remember that we are using the NWIS dataset for all of these lessons. If you successfully completed the [Get](/intro-curriculum/Get) lesson, then you should have the NWIS data frame. If you did not complete the Get lesson (or are starting in a new R session), just load in the `course_NWISdata.csv` by downloading it from [here](/intro-curriculum/data), saving it in a folder called "data", and using `read.csv` (see below).

``` r
intro_df <- read.csv("data/course_NWISdata.csv", stringsAsFactors = FALSE, 
                     colClasses = c("character", rep(NA, 6)))
```

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Subsetting data with `dplyr`.
-   [Exercise 2](#exercise-2): Merging two data frames together.

Lesson Goals
------------

-   Show and tell on using base R for data manipulation
-   Better understand data cleaning through use of `dplyr`
-   Use joins in `dplyr` to combine data frames by a common key
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
    ## 1 02336120 2011-05-27 12:15:00       954            E       20.5     6.2
    ## 2 02336240 2011-05-17 08:45:00        11            A       15.3     7.3
    ## 3 02336360 2011-05-20 13:30:00        10            X       16.8      NA
    ## 4 02336360 2011-05-20 02:45:00        10            X       18.4     7.2
    ## 5 02336120 2011-05-01 07:30:00        17          A e       18.7     7.1
    ## 6 02336240 2011-05-31 02:30:00        11            A       24.5     7.0
    ##   DO_Inst
    ## 1     7.0
    ## 2     8.3
    ## 3     8.4
    ## 4     8.3
    ## 5     7.8
    ## 6     6.7

``` r
#And grab the first site_no
intro_df[1,1]
```

    ## [1] "02336120"

``` r
#Get a whole column
head(intro_df[,7])
```

    ## [1] 7.0 8.3 8.4 8.3 7.8 6.7

``` r
#Get a single row
intro_df[15,]
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 15 02336120 2011-05-01 06:30:00        17            A       18.9       7
    ##    DO_Inst
    ## 15     7.7

``` r
#Grab multiple rows
intro_df[3:7,]
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 3 02336360 2011-05-20 13:30:00      10.0            X       16.8      NA
    ## 4 02336360 2011-05-20 02:45:00      10.0            X       18.4     7.2
    ## 5 02336120 2011-05-01 07:30:00      17.0          A e       18.7     7.1
    ## 6 02336240 2011-05-31 02:30:00      11.0            A       24.5     7.0
    ## 7 02203655 2011-05-23 13:45:00       7.8            X       20.8     6.9
    ##   DO_Inst
    ## 3     8.4
    ## 4     8.3
    ## 5     7.8
    ## 6     6.7
    ## 7     6.7

Did you notice the difference between subsetting by a row and subsetting by a column? Subsetting a column returns a vector, but subsetting a row returns a data.frame. This is because columns (like vectors) contain a single data type, but rows can contain multiple data types, so it could not become a vector.

Also remember that data frames have column names. We can use those too. Let's try it.

``` r
#First, there are a couple of ways to use the column names
head(intro_df$site_no)
```

    ## [1] "02336120" "02336240" "02336360" "02336360" "02336120" "02336240"

``` r
head(intro_df["site_no"])
```

    ##    site_no
    ## 1 02336120
    ## 2 02336240
    ## 3 02336360
    ## 4 02336360
    ## 5 02336120
    ## 6 02336240

``` r
head(intro_df[["site_no"]])
```

    ## [1] "02336120" "02336240" "02336360" "02336360" "02336120" "02336240"

``` r
#Multiple colums
head(intro_df[c("dateTime","Flow_Inst")])
```

    ##              dateTime Flow_Inst
    ## 1 2011-05-27 12:15:00       954
    ## 2 2011-05-17 08:45:00        11
    ## 3 2011-05-20 13:30:00        10
    ## 4 2011-05-20 02:45:00        10
    ## 5 2011-05-01 07:30:00        17
    ## 6 2011-05-31 02:30:00        11

``` r
#Now we can combine what we have seen to do some more complex queries
#Get all the data where water temperature is greater than 15
high_temp <- intro_df[intro_df$Wtemp_Inst > 15,]
head(high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-27 12:15:00       954            E       20.5     6.2
    ## 2 02336240 2011-05-17 08:45:00        11            A       15.3     7.3
    ## 3 02336360 2011-05-20 13:30:00        10            X       16.8      NA
    ## 4 02336360 2011-05-20 02:45:00        10            X       18.4     7.2
    ## 5 02336120 2011-05-01 07:30:00        17          A e       18.7     7.1
    ## 6 02336240 2011-05-31 02:30:00        11            A       24.5     7.0
    ##   DO_Inst
    ## 1     7.0
    ## 2     8.3
    ## 3     8.4
    ## 4     8.3
    ## 5     7.8
    ## 6     6.7

``` r
#Or maybe we want just the discharge that was estimated (code is "E")
estimated_q <- intro_df$Flow_Inst[intro_df$Flow_Inst_cd == "E"]
head(estimated_q)
```

    ## [1] 954.0  24.0  14.0  87.0   4.4  10.0

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
    ## 1 02336120 2011-05-27 12:15:00     7.0
    ## 2 02336240 2011-05-17 08:45:00     8.3
    ## 3 02336360 2011-05-20 13:30:00     8.4
    ## 4 02336360 2011-05-20 02:45:00     8.3
    ## 5 02336120 2011-05-01 07:30:00     7.8
    ## 6 02336240 2011-05-31 02:30:00     6.7

``` r
#Now select some observations, like before
dplyr_high_temp <- filter(intro_df, Wtemp_Inst > 15)
head(dplyr_high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-27 12:15:00       954            E       20.5     6.2
    ## 2 02336240 2011-05-17 08:45:00        11            A       15.3     7.3
    ## 3 02336360 2011-05-20 13:30:00        10            X       16.8      NA
    ## 4 02336360 2011-05-20 02:45:00        10            X       18.4     7.2
    ## 5 02336120 2011-05-01 07:30:00        17          A e       18.7     7.1
    ## 6 02336240 2011-05-31 02:30:00        11            A       24.5     7.0
    ##   DO_Inst
    ## 1     7.0
    ## 2     8.3
    ## 3     8.4
    ## 4     8.3
    ## 5     7.8
    ## 6     6.7

``` r
#Find just observations with estimated flows (as above)
dplyr_estimated_q <- filter(intro_df, Flow_Inst_cd == "E")
head(dplyr_estimated_q)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-27 12:15:00     954.0            E       20.5     6.2
    ## 2 02336410 2011-05-06 23:45:00      24.0            E         NA     7.0
    ## 3 02336120 2011-05-18 02:30:00      14.0            E       15.7     7.3
    ## 4 02336360 2011-05-04 08:00:00      87.0            E       17.7     6.7
    ## 5 02203700 2011-05-14 09:30:00       4.4            E       20.4     6.8
    ## 6 02336240 2011-05-31 20:15:00      10.0            E       26.6     7.1
    ##   DO_Inst
    ## 1     7.0
    ## 2     8.5
    ## 3     8.8
    ## 4     8.2
    ## 5     4.4
    ## 6     7.9

Now we have seen how to filter observations and select columns within a data frame. Now I want to add a new column. In dplyr, `mutate()` allows us to add new columns. These can be vectors you are adding or based on expressions applied to existing columns. For instance, we have a column of dissolved oxygen in milligrams per liter (mg/L), but we would like to add a column with dissolved oxygen in milligrams per milliliter (mg/mL).

``` r
#Add a column with dissolved oxygen in mg/mL instead of mg/L
intro_df_newcolumn <- mutate(intro_df, DO_mgmL = DO_Inst/1000)
head(intro_df_newcolumn)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-27 12:15:00       954            E       20.5     6.2
    ## 2 02336240 2011-05-17 08:45:00        11            A       15.3     7.3
    ## 3 02336360 2011-05-20 13:30:00        10            X       16.8      NA
    ## 4 02336360 2011-05-20 02:45:00        10            X       18.4     7.2
    ## 5 02336120 2011-05-01 07:30:00        17          A e       18.7     7.1
    ## 6 02336240 2011-05-31 02:30:00        11            A       24.5     7.0
    ##   DO_Inst DO_mgmL
    ## 1     7.0  0.0070
    ## 2     8.3  0.0083
    ## 3     8.4  0.0084
    ## 4     8.3  0.0083
    ## 5     7.8  0.0078
    ## 6     6.7  0.0067

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
    ## 1 02336360 2011-05-20 13:30:00      10.0            X
    ## 2 02336360 2011-05-20 02:45:00      10.0            X
    ## 3 02203655 2011-05-23 13:45:00       7.8            X
    ## 4 02336240 2011-05-10 21:00:00      11.0            X
    ## 5 02203700 2011-05-01 20:45:00       6.1            X
    ## 6 02336313 2011-05-18 21:15:00       1.0            X

``` r
#Nested function
dplyr_error_nest <- filter(
  select(intro_df, site_no, dateTime, Flow_Inst, Flow_Inst_cd),
  Flow_Inst_cd == "X")
head(dplyr_error_nest)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-20 13:30:00      10.0            X
    ## 2 02336360 2011-05-20 02:45:00      10.0            X
    ## 3 02203655 2011-05-23 13:45:00       7.8            X
    ## 4 02336240 2011-05-10 21:00:00      11.0            X
    ## 5 02203700 2011-05-01 20:45:00       6.1            X
    ## 6 02336313 2011-05-18 21:15:00       1.0            X

``` r
#Pipes
dplyr_error_pipe <- intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X")
head(dplyr_error_pipe)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-20 13:30:00      10.0            X
    ## 2 02336360 2011-05-20 02:45:00      10.0            X
    ## 3 02203655 2011-05-23 13:45:00       7.8            X
    ## 4 02336240 2011-05-10 21:00:00      11.0            X
    ## 5 02203700 2011-05-01 20:45:00       6.1            X
    ## 6 02336313 2011-05-18 21:15:00       1.0            X

``` r
# Every function, including head(), can be chained
intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X") %>% 
  head()
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336360 2011-05-20 13:30:00      10.0            X
    ## 2 02336360 2011-05-20 02:45:00      10.0            X
    ## 3 02203655 2011-05-23 13:45:00       7.8            X
    ## 4 02336240 2011-05-10 21:00:00      11.0            X
    ## 5 02203700 2011-05-01 20:45:00       6.1            X
    ## 6 02336313 2011-05-18 21:15:00       1.0            X

Although we show you the nested and piping methods, we will only use the intermediate data frames method for the remainder of this material.

Cleaning up dataset
-------------------

Before moving on to merging, let's try cleaning up our `intro_df` data.frame. First, take a quick look at the structure: `summary(intro_df)`. Are the columns all of the classes that you would expect? Take note of how many missing values there are. We could remove them, but if there's a missing value in any of one of the columns for a single observation, the entire row is removed. So, let's leave NAs in our dataset for now.

The only cleaning to this dataset that we will do right now is to rename some of the columns. We are going to have to reference columns a lot, and might not want to type `_Inst` for every single one, especially since they are all `_Inst`, so it's not giving us additional information. Let's rename all columns with `_Inst` using the `rename` function from `dplyr`.

``` r
# the pattern is new_col_name = old_col_name
intro_df <- rename(intro_df, 
                   Flow = Flow_Inst,
                   Flow_cd = Flow_Inst_cd,
                   Wtemp = Wtemp_Inst,
                   pH = pH_Inst,
                   DO = DO_Inst)

# only want to keep data that has a real flow value
nrow(intro_df)
```

    ## [1] 3000

``` r
intro_df <- filter(intro_df, !is.na(Flow))
nrow(intro_df) # there were 90 missing flow values
```

    ## [1] 2910

``` r
# remove erroneous and estimated
intro_df <- filter(intro_df, Flow_cd != "X")
intro_df <- filter(intro_df, Flow_cd != "E")
# or use `%in%`: intro_df <- filter(intro_df, !Flow_cd %in% c("E", "X"))

# add a column with water temperature in F, not C
# equation degF = (degC * 9/5) + 32
intro_df <- mutate(intro_df, Wtemp_F = (Wtemp * 9/5) + 32)
```

You might have noticed that the date column is treated as character and not Date or POSIX. Handling dates are beyond this course, but they are available in this dataset if you would like to work with them.

Exercise 1
----------

This exercise is going to focus on using what we just covered on `dplyr` to start to clean up a dataset. Our goal for this is to create a new data frame that represents a subset of the observations as well as a subset of the data.

1.  Using dplyr, remove the `Flow_cd` column. Think `select()`. Give the new data frame a new name, so you can distinguish it from your raw data.
2.  Next, we are going to get a subset of the observations. We only want data where flow was greater than 10 cubic feet per second. Also give this data frame a different name than before.
3.  Lastly, add a new column with flow in units of cubic meters per second. Hint: there are 3.28 feet in a meter.

Joining Data
------------

Joining data in `dplyr` is accomplished via the various `x_join()` commands (e.g., `inner_join`, `left_join`, `anti_join`, etc). These are very SQL-esque so if you speak SQL then these will be pretty easy for you. If not then they aren't immediately intuitive. There are also the base functions `rbind()` and `merge()`, but we won't be covering these because they are redundant with the faster, more readable `dplyr` functions.

We are going to talk about several different ways to do this. First, let's add some new rows to a data frame. This is very handy as you might have data collected and entered at one time, and then additional observations made later that need to be added. So with `rbind()` we can stack two data frames with the same columns to store more observations.

In this example, let's imagine we collected 3 new observations for water temperature and pH at the site "00000001". Notice that we did not collect anything for discharge or dissolved oxygen. What happens in the columns that don't match when the we bind the rows of these two data frames?

``` r
#Let's first read in a new small example data.frame
new_data <- read.csv(file = 'data/newData.csv', 
                     stringsAsFactors = FALSE, 
                     colClasses = c("character", rep(NA, 3)))
head(new_data)
```

    ##    site_no            dateTime Wtemp  pH
    ## 1 00000001 2016-09-01 07:45:00  14.0 7.8
    ## 2 00000001 2016-09-02 07:45:00  16.4 8.5
    ## 3 00000001 2016-09-03 07:45:00  16.0 8.3

``` r
#Now add this to our existing df (intro_df)
bind_rows_df <- bind_rows(intro_df, new_data)
tail(bind_rows_df)
```

    ##       site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1937 02336526 2011-05-03 06:30:00  4.2       A  21.3 7.0 6.6   70.34
    ## 1938 02336120 2011-05-22 16:15:00 11.0     A e  21.3 7.2 7.9   70.34
    ## 1939 02336120 2011-06-01 02:00:00 12.0       A  26.1 7.0 6.7   78.98
    ## 1940 00000001 2016-09-01 07:45:00   NA    <NA>  14.0 7.8  NA      NA
    ## 1941 00000001 2016-09-02 07:45:00   NA    <NA>  16.4 8.5  NA      NA
    ## 1942 00000001 2016-09-03 07:45:00   NA    <NA>  16.0 8.3  NA      NA

Now something to think about. Could you add a vector as a new row? Why/Why not? When/When not?

Let's go back to the columns now. There are simple ways to add columns of the same length with observations in the same order to a data frame, but it is very common to have to datasets that are in different orders and have differing numbers of rows. What we want to do in that case is going to be more of a database type function and join two tables based on a common column. We can achieve this by using `x_join` functions. Let's say we have a separate data frame of site metadata, including latitude and longitude, and we want to attach that information to our discharge measurements. See `?left_join` for more information.

``` r
# read site metadata
siteInfo <- read.csv('data/siteInfo.csv',
                     stringsAsFactors = FALSE, 
                     colClasses = c(rep("character", 2), rep(NA, 9)))

str(siteInfo)
```

    ## 'data.frame':    11 obs. of  13 variables:
    ##  $ station_nm          : chr  "SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA" "INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA" "N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA" "S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA" ...
    ##  $ site_no             : chr  "02203655" "02203700" "02336120" "02336240" ...
    ##  $ agency_cd           : chr  "USGS" "USGS" "USGS" "USGS" ...
    ##  $ timeZoneOffset      : chr  "-05:00" "-05:00" "-05:00" "-05:00" ...
    ##  $ timeZoneAbbreviation: chr  "EST" "EST" "EST" "EST" ...
    ##  $ dec_lat_va          : num  33.7 33.7 33.8 33.8 33.8 ...
    ##  $ dec_lon_va          : num  -84.4 -84.3 -84.3 -84.3 -84.4 ...
    ##  $ srs                 : chr  "EPSG:4326" "EPSG:4326" "EPSG:4326" "EPSG:4326" ...
    ##  $ siteTypeCd          : chr  "ST" "ST" "ST" "ST" ...
    ##  $ hucCd               : int  3070103 3070103 3130001 3130001 3130001 3130001 3130001 3130001 3130002 3130002 ...
    ##  $ stateCd             : int  13 13 13 13 13 13 13 13 13 13 ...
    ##  $ countyCd            : chr  "13121" "13089" "13089" "13089" ...
    ##  $ network             : chr  "NWIS" "NWIS" "NWIS" "NWIS" ...

``` r
intro_df_siteInfo <- left_join(intro_df, siteInfo, by="site_no")
head(intro_df_siteInfo)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02336240 2011-05-17 08:45:00   11.0       A  15.3 7.3 8.3   59.54
    ## 2 02336120 2011-05-01 07:30:00   17.0     A e  18.7 7.1 7.8   65.66
    ## 3 02336240 2011-05-31 02:30:00   11.0       A  24.5 7.0 6.7   76.10
    ## 4 02337170 2011-05-16 11:15:00 1350.0     A e  16.1 7.0 8.7   60.98
    ## 5 02336526 2011-05-05 04:15:00    6.7       A  16.6 6.9 8.0   61.88
    ## 6 02336360 2011-05-24 04:15:00    9.1       A  22.9 7.1 6.7   73.22
    ##                                           station_nm agency_cd
    ## 1  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 2 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 3  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 4              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 5   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 6  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ##   timeZoneOffset timeZoneAbbreviation dec_lat_va dec_lon_va       srs
    ## 1         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 2         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 3         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 4         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 5         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 6         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ##   siteTypeCd   hucCd stateCd countyCd network
    ## 1         ST 3130001      13    13089    NWIS
    ## 2         ST 3130001      13    13089    NWIS
    ## 3         ST 3130001      13    13089    NWIS
    ## 4         ST 3130002      13    13121    NWIS
    ## 5         ST 3130002      13    13121    NWIS
    ## 6         ST 3130001      13    13121    NWIS

If we wanted to remove some of the columns from `siteInfo.csv`, we can use `select` which we learned earlier in this lesson.

Exercise 2
----------

In this exercise we are going to practice merging data. We will be using two subsets of`intro_df` (see) the code snippet below). First, we need to create the two subsets and will do this by selecting random rows using the `dplyr` function `sample_n`. In order to select the same random rows (so that the class is on the same page), use `set.seed`.

``` r
# specify what the seed will be
set.seed(92)

#subset intro_df and 
intro_df_subset <- sample_n(intro_df, size=20)

#keep only the flow values
Q <- select(intro_df_subset, site_no, dateTime, Flow)

# select 8 random rows and only keep DO for second dataframe
DO <- sample_n(intro_df_subset, size=8)
DO <- select(DO, site_no, dateTime, DO)

head(Q)
```

    ##       site_no            dateTime   Flow
    ## 135  02336360 2011-05-23 05:30:00    9.4
    ## 1248 02203700 2011-05-14 06:15:00    4.4
    ## 600  02337170 2011-05-23 11:45:00 1430.0
    ## 1249 02336410 2011-05-13 06:45:00   17.0
    ## 1595 02336360 2011-05-27 19:30:00   28.0
    ## 1613 02336300 2011-05-23 02:00:00   23.0

``` r
head(DO)
```

    ##       site_no            dateTime  DO
    ## 1613 02336300 2011-05-23 02:00:00 7.0
    ## 227  02336120 2011-05-22 15:30:00 7.8
    ## 926  02336300 2011-05-16 05:15:00 7.6
    ## 600  02337170 2011-05-23 11:45:00 8.1
    ## 737  02336360 2011-05-25 08:00:00 6.5
    ## 761  02336360 2011-05-06 13:45:00 8.5

1.  Run the lines above to create the two data frames we will be working with.
2.  Create a new data frame, `DO_Q`, that is a merge of `Q` and `DO`, but with only lines in `DO` preserved in the output. The columns to merge on are the site and date columns.
3.  Now try merging, but keeping all `Q` observations, and call it `Q_DO`. You should notice a lot of `NA` values where the `DO` dataframe did not have a matching observation.
4.  Add another line to your code and create a data frame that removes all NA values from `Q_DO`. Woah - that's the same dataframe as our `DO_Q`!
5.  If that goes quickly, feel free to explore other joins (`inner_join`, `full_join`, etc).

Additional functions
--------------------

There are many other functions in `dplyr` that are useful. Let's run through some examples with `arrange()` and `slice()`.

First `arrange()` will re-order a data frame based on the values in a specified column. It will take multiple columns and can be in descending or ascending order.

``` r
#ascending order is default
head(arrange(intro_df, DO))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02203700 2011-05-10 08:30:00  4.6       A  19.8 7.3 3.2   67.64
    ## 2 02203700 2011-05-10 06:00:00  4.9       A  20.8 7.3 3.4   69.44
    ## 3 02203700 2011-05-12 07:00:00  4.4       A  21.8  NA 3.4   71.24
    ## 4 02203700 2011-05-10 07:00:00  4.6       A  20.4 7.3 3.4   68.72
    ## 5 02203700 2011-05-09 00:45:00  5.1       A  21.5 7.2 3.5   70.70
    ## 6 02203700 2011-05-10 10:00:00  4.9     A e  19.4 7.3 3.5   66.92

``` r
#descending
head(arrange(intro_df, desc(DO)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH   DO Wtemp_F
    ## 1 02336526 2011-05-23 21:00:00  3.3       A  24.7 8.9 12.4   76.46
    ## 2 02336526 2011-05-18 23:30:00  3.8       A  17.5 8.9 12.4   63.50
    ## 3 02336526 2011-05-17 20:00:00  3.6       A  16.5 7.9 12.3   61.70
    ## 4 02336526 2011-05-20 21:30:00  3.5     A e  22.2 8.9 12.3   71.96
    ## 5 02336526 2011-05-24 19:45:00  3.0       A  24.9 8.7 12.2   76.82
    ## 6 02336526 2011-05-19 00:15:00  3.8     A e  17.6 9.0 12.1   63.68

``` r
#multiple columns: lowest flow with highest temperature at top
head(arrange(intro_df, Flow, desc(Wtemp)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02336313 2011-06-01 00:15:00 0.65       A  26.4  NA 5.3   79.52
    ## 2 02336313 2011-05-30 02:00:00 0.73       A  25.2 7.4 5.5   77.36
    ## 3 02336313 2011-05-30 03:15:00 0.73       A  24.8 7.4 5.7   76.64
    ## 4 02336313 2011-05-30 15:45:00 0.73       A  24.4 7.4 7.0   75.92
    ## 5 02336313 2011-05-30 11:15:00 0.73       A  22.2 7.5 5.9   71.96
    ## 6 02336313 2011-05-31 18:15:00 0.77     A e  26.2 7.2 7.1   79.16

Now `slice()`, which accomplishes what we did with the numeric indices before. Remembering back to that, we could grab rows of the data frame with something like `intro_df[3:10,]` or we can use `slice`:

``` r
#grab rows 3 through 10
slice(intro_df, 3:10)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02336240 2011-05-31 02:30:00   11.0       A  24.5 7.0 6.7   76.10
    ## 2 02337170 2011-05-16 11:15:00 1350.0     A e  16.1 7.0 8.7   60.98
    ## 3 02336526 2011-05-05 04:15:00    6.7       A  16.6 6.9 8.0   61.88
    ## 4 02336360 2011-05-24 04:15:00    9.1       A  22.9 7.1 6.7   73.22
    ## 5 02336120 2011-05-01 06:30:00   17.0       A  18.9 7.0 7.7   66.02
    ## 6 02336526 2011-05-25 16:45:00    3.1       A  22.5 7.8 9.5   72.50
    ## 7 02336410 2011-05-13 21:30:00   16.0       A  23.7  NA 8.2   74.66
    ## 8 02336410 2011-05-21 17:00:00   14.0       A  21.0 7.4 9.1   69.80

We now have quite a few tools that we can use to clean and manipulate data in R. We have barely touched what both base R and `dplyr` are capable of accomplishing, but hopefully you now have some basics to build on.
