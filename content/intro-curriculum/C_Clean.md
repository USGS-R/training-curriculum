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
    ## 1 02203700 2011-05-20 16:45:00       4.0          A e         NA     7.0
    ## 2 02336410 2011-05-28 08:15:00      35.0            A       21.8     6.9
    ## 3 02203655 2011-05-22 09:30:00       7.8            A       20.6     7.0
    ## 4 02336240 2011-05-14 23:15:00      10.0            X       22.0     7.3
    ## 5 02336313 2011-05-22 12:00:00       1.3            A       19.3     7.2
    ## 6 02336728 2011-05-25 01:30:00       8.6            X       24.2     7.1
    ##   DO_Inst
    ## 1     8.6
    ## 2     6.9
    ## 3     6.6
    ## 4     7.8
    ## 5     7.3
    ## 6     7.3

``` r
#And grab the first site_no
intro_df[1,1]
```

    ## [1] "02203700"

``` r
#Get a whole column
head(intro_df[,7])
```

    ## [1] 8.6 6.9 6.6 7.8 7.3 7.3

``` r
#Get a single row
intro_df[15,]
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 15 02336410 2011-05-10 04:15:00        19            A       21.5       7
    ##    DO_Inst
    ## 15     7.2

``` r
#Grab multiple rows
intro_df[3:7,]
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 3 02203655 2011-05-22 09:30:00       7.8            A       20.6     7.0
    ## 4 02336240 2011-05-14 23:15:00      10.0            X       22.0     7.3
    ## 5 02336313 2011-05-22 12:00:00       1.3            A       19.3     7.2
    ## 6 02336728 2011-05-25 01:30:00       8.6            X       24.2     7.1
    ## 7 02203700 2011-05-09 10:30:00       4.9            A       18.0     7.2
    ##   DO_Inst
    ## 3     6.6
    ## 4     7.8
    ## 5     7.3
    ## 6     7.3
    ## 7     4.4

Did you notice the difference between subsetting by a row and subsetting by a column? Subsetting a column returns a vector, but subsetting a row returns a data.frame. This is because columns (like vectors) contain a single data type, but rows can contain multiple data types, so it could not become a vector.

Also remember that data frames have column names. We can use those too. Let's try it.

``` r
#First, there are a couple of ways to use the column names
head(intro_df$site_no)
```

    ## [1] "02203700" "02336410" "02203655" "02336240" "02336313" "02336728"

``` r
head(intro_df["site_no"])
```

    ##    site_no
    ## 1 02203700
    ## 2 02336410
    ## 3 02203655
    ## 4 02336240
    ## 5 02336313
    ## 6 02336728

``` r
head(intro_df[["site_no"]])
```

    ## [1] "02203700" "02336410" "02203655" "02336240" "02336313" "02336728"

``` r
#Multiple colums
head(intro_df[c("dateTime","Flow_Inst")])
```

    ##              dateTime Flow_Inst
    ## 1 2011-05-20 16:45:00       4.0
    ## 2 2011-05-28 08:15:00      35.0
    ## 3 2011-05-22 09:30:00       7.8
    ## 4 2011-05-14 23:15:00      10.0
    ## 5 2011-05-22 12:00:00       1.3
    ## 6 2011-05-25 01:30:00       8.6

``` r
#Now we can combine what we have seen to do some more complex queries
#Get all the data where water temperature is greater than 15
high_temp <- intro_df[intro_df$Wtemp_Inst > 15,]
head(high_temp)
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## NA     <NA>                <NA>        NA         <NA>         NA      NA
    ## 2  02336410 2011-05-28 08:15:00      35.0            A       21.8     6.9
    ## 3  02203655 2011-05-22 09:30:00       7.8            A       20.6     7.0
    ## 4  02336240 2011-05-14 23:15:00      10.0            X       22.0     7.3
    ## 5  02336313 2011-05-22 12:00:00       1.3            A       19.3     7.2
    ## 6  02336728 2011-05-25 01:30:00       8.6            X       24.2     7.1
    ##    DO_Inst
    ## NA      NA
    ## 2      6.9
    ## 3      6.6
    ## 4      7.8
    ## 5      7.3
    ## 6      7.3

``` r
#Or maybe we want just the discharge that was estimated (code is "E")
estimated_q <- intro_df$Flow_Inst[intro_df$Flow_Inst_cd == "E"]
head(estimated_q)
```

    ## [1] 5990.0    5.5 3380.0    9.1    4.0    3.6

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
    ## 1 02203700 2011-05-20 16:45:00     8.6
    ## 2 02336410 2011-05-28 08:15:00     6.9
    ## 3 02203655 2011-05-22 09:30:00     6.6
    ## 4 02336240 2011-05-14 23:15:00     7.8
    ## 5 02336313 2011-05-22 12:00:00     7.3
    ## 6 02336728 2011-05-25 01:30:00     7.3

``` r
#Now select some observations, like before
dplyr_high_temp <- filter(intro_df, Wtemp_Inst > 15)
head(dplyr_high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336410 2011-05-28 08:15:00      35.0            A       21.8     6.9
    ## 2 02203655 2011-05-22 09:30:00       7.8            A       20.6     7.0
    ## 3 02336240 2011-05-14 23:15:00      10.0            X       22.0     7.3
    ## 4 02336313 2011-05-22 12:00:00       1.3            A       19.3     7.2
    ## 5 02336728 2011-05-25 01:30:00       8.6            X       24.2     7.1
    ## 6 02203700 2011-05-09 10:30:00       4.9            A       18.0     7.2
    ##   DO_Inst
    ## 1     6.9
    ## 2     6.6
    ## 3     7.8
    ## 4     7.3
    ## 5     7.3
    ## 6     4.4

``` r
#Find just observations with estimated flows (as above)
dplyr_estimated_q <- filter(intro_df, Flow_Inst_cd == "E")
head(dplyr_estimated_q)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02337170 2011-05-07 08:00:00    5990.0            E       14.1     6.8
    ## 2 02336526 2011-05-05 23:15:00       5.5            E       18.9     7.2
    ## 3 02337170 2011-05-13 08:15:00    3380.0            E       15.9     6.9
    ## 4 02336360 2011-05-24 07:45:00       9.1            E       22.2     7.1
    ## 5 02203700 2011-05-20 16:15:00       4.0            E       19.4     7.0
    ## 6 02336526 2011-05-13 07:45:00       3.6            E       22.4     7.2
    ##   DO_Inst
    ## 1    10.1
    ## 2     9.5
    ## 3     9.7
    ## 4     6.6
    ## 5     8.2
    ## 6     6.1

Now we have seen how to filter observations and select columns within a data frame. Now I want to add a new column. In dplyr, `mutate()` allows us to add new columns. These can be vectors you are adding or based on expressions applied to existing columns. For instance, we have a column of dissolved oxygen in milligrams per liter (mg/L), but we would like to add a column with dissolved oxygen in milligrams per milliliter (mg/mL).

``` r
#Add a column with dissolved oxygen in mg/mL instead of mg/L
intro_df_newcolumn <- mutate(intro_df, DO_mgmL = DO_Inst/1000)
head(intro_df_newcolumn)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02203700 2011-05-20 16:45:00       4.0          A e         NA     7.0
    ## 2 02336410 2011-05-28 08:15:00      35.0            A       21.8     6.9
    ## 3 02203655 2011-05-22 09:30:00       7.8            A       20.6     7.0
    ## 4 02336240 2011-05-14 23:15:00      10.0            X       22.0     7.3
    ## 5 02336313 2011-05-22 12:00:00       1.3            A       19.3     7.2
    ## 6 02336728 2011-05-25 01:30:00       8.6            X       24.2     7.1
    ##   DO_Inst DO_mgmL
    ## 1     8.6  0.0086
    ## 2     6.9  0.0069
    ## 3     6.6  0.0066
    ## 4     7.8  0.0078
    ## 5     7.3  0.0073
    ## 6     7.3  0.0073

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
    ## 1 02336240 2011-05-14 23:15:00      10.0            X
    ## 2 02336728 2011-05-25 01:30:00       8.6            X
    ## 3 02337170 2011-05-30 13:30:00    1350.0            X
    ## 4 02336728 2011-05-26 06:00:00       8.2            X
    ## 5 02336120 2011-05-26 12:45:00       8.9            X
    ## 6 02336360 2011-05-19 21:30:00      10.0            X

``` r
#Nested function
dplyr_error_nest <- filter(
  select(intro_df, site_no, dateTime, Flow_Inst, Flow_Inst_cd),
  Flow_Inst_cd == "X")
head(dplyr_error_nest)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336240 2011-05-14 23:15:00      10.0            X
    ## 2 02336728 2011-05-25 01:30:00       8.6            X
    ## 3 02337170 2011-05-30 13:30:00    1350.0            X
    ## 4 02336728 2011-05-26 06:00:00       8.2            X
    ## 5 02336120 2011-05-26 12:45:00       8.9            X
    ## 6 02336360 2011-05-19 21:30:00      10.0            X

``` r
#Pipes
dplyr_error_pipe <- intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X")
head(dplyr_error_pipe)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336240 2011-05-14 23:15:00      10.0            X
    ## 2 02336728 2011-05-25 01:30:00       8.6            X
    ## 3 02337170 2011-05-30 13:30:00    1350.0            X
    ## 4 02336728 2011-05-26 06:00:00       8.2            X
    ## 5 02336120 2011-05-26 12:45:00       8.9            X
    ## 6 02336360 2011-05-19 21:30:00      10.0            X

``` r
# Every function, including head(), can be chained
intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X") %>% 
  head()
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336240 2011-05-14 23:15:00      10.0            X
    ## 2 02336728 2011-05-25 01:30:00       8.6            X
    ## 3 02337170 2011-05-30 13:30:00    1350.0            X
    ## 4 02336728 2011-05-26 06:00:00       8.2            X
    ## 5 02336120 2011-05-26 12:45:00       8.9            X
    ## 6 02336360 2011-05-19 21:30:00      10.0            X

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
    ## 1948 02336240 2011-05-09 21:00:00   12       A  22.8 7.3 8.7   73.04
    ## 1949 02337170 2011-05-15 12:15:00 2280     A e  15.1 6.9 9.6   59.18
    ## 1950 02336728 2011-05-31 11:00:00   13       A  22.7 7.0 7.3   72.86
    ## 1951 00000001 2016-09-01 07:45:00   NA    <NA>  14.0 7.8  NA      NA
    ## 1952 00000001 2016-09-02 07:45:00   NA    <NA>  16.4 8.5  NA      NA
    ## 1953 00000001 2016-09-03 07:45:00   NA    <NA>  16.0 8.3  NA      NA

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
left_join(intro_df, siteInfo, by="site_no")
```

    ##       site_no            dateTime    Flow Flow_cd Wtemp  pH   DO Wtemp_F
    ## 1    02203700 2011-05-20 16:45:00    4.00     A e    NA 7.0  8.6      NA
    ## 2    02336410 2011-05-28 08:15:00   35.00       A  21.8 6.9  6.9   71.24
    ## 3    02203655 2011-05-22 09:30:00    7.80       A  20.6 7.0  6.6   69.08
    ## 4    02336313 2011-05-22 12:00:00    1.30       A  19.3 7.2  7.3   66.74
    ## 5    02203700 2011-05-09 10:30:00    4.90       A  18.0 7.2  4.4   64.40
    ## 6    02336313 2011-05-13 12:15:00    1.00       A  20.4 7.2  7.1   68.72
    ## 7    02337170 2011-05-18 23:15:00 4510.00       A  13.5 6.9 10.0   56.30
    ## 8    02336120 2011-05-08 15:45:00   17.00     A e  17.6 7.2  8.7   63.68
    ## 9    02336526 2011-05-11 11:30:00    4.00       A  20.8 7.0  6.6   69.44
    ## 10   02336410 2011-05-10 04:15:00   19.00       A  21.5 7.0  7.2   70.70
    ## 11   02336360 2011-05-03 06:45:00   13.00       A  20.6 7.1  7.3   69.08
    ## 12   02336526 2011-05-07 18:15:00    4.80       A    NA 7.4 10.6      NA
    ## 13   02336526 2011-05-28 13:15:00    9.80       A  19.8 7.1  7.9   67.64
    ## 14   02336300 2011-05-15 21:00:00   26.00       A  19.2 7.6  8.6   66.56
    ## 15   02336360 2011-05-15 00:00:00   11.00       A  22.2 7.3  7.9   71.96
    ## 16   02336120 2011-05-13 19:15:00   13.00     A e  23.6 7.3  8.6   74.48
    ## 17   02203655 2011-05-06 11:45:00   13.00       A  14.6 7.2  8.2   58.28
    ## 18   02336728 2011-05-14 06:45:00   12.00       A  20.6 7.2  7.5   69.08
    ## 19   02336728 2011-05-27 00:45:00   32.00       A  23.1 6.9  7.4   73.58
    ## 20   02336300 2011-05-11 05:15:00   30.00       A  22.8 7.3  6.8   73.04
    ## 21   02336526 2011-05-23 03:00:00    5.20       A  24.4 8.6  7.6   75.92
    ## 22   02203700 2011-05-19 08:30:00    4.20       A    NA 6.8  5.4      NA
    ## 23   02336120 2011-05-12 10:15:00   14.00     A e  21.6 7.2  7.1   70.88
    ## 24   02336240 2011-05-05 04:30:00   19.00       A  16.1 7.0  8.2   60.98
    ## 25   02203655 2011-05-21 04:45:00    8.20     A e  20.4 7.0  6.8   68.72
    ## 26   02336120 2011-05-28 15:30:00   28.00       A  21.8 6.8  7.3   71.24
    ## 27   02336300 2011-05-15 23:15:00   27.00       A  18.8 7.6  8.3   65.84
    ## 28   02203700 2011-05-25 03:15:00    3.70       A  23.5 6.8  4.4   74.30
    ## 29   02203655 2011-05-03 11:00:00   11.00     A e  19.5 7.1  6.7   67.10
    ## 30   02336313 2011-05-17 04:30:00    1.20       A  16.2 7.2  7.2   61.16
    ## 31   02203700 2011-05-09 08:15:00    4.90     A e  18.7 7.2  3.9   65.66
    ## 32   02203655 2011-05-05 14:15:00   15.00       A  14.3 7.1  8.3   57.74
    ## 33   02336313 2011-05-10 22:15:00    0.98       A  24.9 7.2  7.5   76.82
    ## 34   02336240 2011-06-01 02:00:00   11.00     A e  25.2 7.0  6.7   77.36
    ## 35   02337170 2011-05-07 12:45:00 5430.00       A  13.8 6.8  9.8   56.84
    ## 36   02336313 2011-05-20 20:45:00    0.98       A  22.2 7.2  8.0   71.96
    ## 37   02336410 2011-05-05 21:00:00   28.00       A    NA 7.1  8.9      NA
    ## 38   02336313 2011-05-31 01:30:00    0.69       A  25.7 7.3  5.6   78.26
    ## 39   02336526 2011-05-27 03:00:00  102.00       A  21.3 6.7  7.5   70.34
    ## 40   02336526 2011-05-14 22:15:00    3.80       A  23.6 8.1 10.9   74.48
    ## 41   02336300 2011-05-25 08:00:00   20.00       A  22.9 7.3  6.4   73.22
    ## 42   02203655 2011-05-31 08:45:00    9.20       A  23.7 7.3  6.1   74.66
    ## 43   02336240 2011-05-01 09:30:00   13.00       A  17.7 7.2  7.7   63.86
    ## 44   02336120 2011-05-23 23:00:00   11.00     A e  24.7 7.3  7.8   76.46
    ## 45   02336728 2011-05-04 00:15:00  129.00       A  18.6 7.0  8.8   65.48
    ## 46   02336360 2011-05-11 07:00:00   12.00     A e  22.2 7.0  6.9   71.96
    ## 47   02336410 2011-05-08 07:45:00   22.00       A  17.8 7.0  8.1   64.04
    ## 48   02336120 2011-06-01 00:45:00   12.00       A  26.4 7.0  7.0   79.52
    ## 49   02336360 2011-05-03 19:15:00   14.00     A e  22.4 7.2  8.7   72.32
    ## 50   02336360 2011-05-24 06:00:00    9.10     A e  22.6 7.1  6.6   72.68
    ## 51   02203700 2011-05-11 03:15:00    4.90     A e  23.4 7.4  3.6   74.12
    ## 52   02203700 2011-05-05 07:30:00   22.00     A e  16.4 6.6  7.2   61.52
    ## 53   02203655 2011-05-31 17:45:00   10.00       A  23.6 7.3  7.0   74.48
    ## 54   02336313 2011-05-14 09:15:00    0.98       A  20.6 7.2  6.6   69.08
    ## 55   02203655 2011-05-24 21:00:00    7.80     A e  23.1 7.0  7.1   73.58
    ## 56   02336313 2011-05-31 03:45:00    0.69       A  24.8 7.4  5.4   76.64
    ## 57   02336313 2011-05-15 12:00:00    1.00       A  18.0 7.2  7.0   64.40
    ## 58   02336360 2011-05-05 10:00:00   18.00       A  15.6 6.9  8.3   60.08
    ## 59   02336360 2011-05-13 17:30:00   11.00       A  23.1 7.3  9.0   73.58
    ## 60   02336300 2011-05-23 23:15:00   21.00       A  25.6 7.5  8.1   78.08
    ## 61   02337170 2011-05-05 01:45:00 6930.00       A  14.6 6.7  9.8   58.28
    ## 62   02203655 2011-05-22 14:00:00    8.20       A  19.9 7.0  7.1   67.82
    ## 63   02336240 2011-05-30 12:45:00   12.00       A  22.2 7.0  7.2   71.96
    ## 64   02203700 2011-05-21 19:00:00    3.90       A  23.6 7.0  9.2   74.48
    ## 65   02336410 2011-05-29 08:00:00   19.00       A  22.7 7.0  6.5   72.86
    ## 66   02336526 2011-05-25 20:00:00    2.80       A  25.0 8.6 11.8   77.00
    ## 67   02336240 2011-05-08 18:45:00   12.00       A  20.3 7.3  9.0   68.54
    ## 68   02203655 2011-05-23 23:15:00    8.20       A  22.9 7.0  6.8   73.22
    ## 69   02336526 2011-05-03 18:15:00    4.00     A e  22.7 7.2   NA   72.86
    ## 70   02336240 2011-05-10 18:45:00   12.00       A  24.2 7.3  8.9   75.56
    ## 71   02336300 2011-05-16 04:45:00   26.00     A e  17.7 7.5  7.6   63.86
    ## 72   02336360 2011-05-06 07:00:00   15.00       A  16.1 7.0  8.2   60.98
    ## 73   02336526 2011-05-02 03:45:00    4.20       A  21.6 7.1  6.9   70.88
    ## 74   02336240 2011-05-19 12:15:00    9.90     A e  14.2 7.3  8.8   57.56
    ## 75   02336240 2011-05-24 13:30:00    8.50       A  21.2  NA  7.4   70.16
    ## 76   02203700 2011-05-15 06:45:00    4.40       A  19.6 6.9  4.5   67.28
    ## 77   02336360 2011-05-28 18:00:00   11.00       A  23.9 7.0  7.5   75.02
    ## 78   02203655 2011-05-29 20:15:00   12.00       A  22.8 6.7  7.2   73.04
    ## 79   02336313 2011-05-12 22:30:00    1.00       A  25.4 7.2  7.0   77.72
    ## 80   02336728 2011-05-24 19:45:00    8.90       A  25.2 7.3  9.0   77.36
    ## 81   02336360 2011-05-10 03:30:00   12.00     A e  21.6 7.0  7.4   70.88
    ## 82   02336526 2011-05-05 13:30:00    5.70       A  13.3 7.0  9.0   55.94
    ## 83   02336120 2011-05-26 02:45:00   11.00       A  24.6 7.1   NA   76.28
    ## 84   02336240 2011-05-07 10:15:00   13.00       A  15.2 7.2  8.4   59.36
    ## 85   02336728 2011-05-29 23:45:00   18.00     A e  24.2 7.0  7.4   75.56
    ## 86   02336728 2011-05-13 19:45:00   12.00       A  24.4 7.3  8.4   75.92
    ## 87   02203700 2011-05-19 20:45:00    4.00       A  21.4 7.0  9.8   70.52
    ## 88   02336410 2011-05-21 08:15:00   14.00       A  19.6 7.2  7.6   67.28
    ## 89   02336410 2011-05-11 14:00:00   18.00       A  21.5 7.1  7.6   70.70
    ## 90   02336410 2011-05-12 04:00:00   17.00       A  23.4 7.1  6.9   74.12
    ## 91   02337170 2011-05-24 18:15:00 2900.00       A  20.2 6.9  8.7   68.36
    ## 92   02203700 2011-05-01 12:30:00    6.10       A  16.8 7.0  7.3   62.24
    ## 93   02336120 2011-05-27 16:45:00  191.00       A  20.9 6.3  7.2   69.62
    ## 94   02336360 2011-05-29 23:45:00    7.50     A e  25.2 7.0  7.1   77.36
    ## 95   02203700 2011-05-02 10:15:00    5.80       A  18.5 7.0  6.4   65.30
    ## 96   02336526 2011-05-19 08:15:00    3.60       A  15.4 7.7  8.2   59.72
    ## 97   02337170 2011-05-28 16:30:00 2360.00       A  20.6 6.8  7.6   69.08
    ## 98   02336120 2011-05-02 07:45:00   16.00       A  19.6 7.1  7.6   67.28
    ## 99   02336313 2011-05-02 06:30:00    1.00       A  19.8 7.0  6.2   67.64
    ## 100  02336120 2011-05-23 02:15:00   11.00       A  23.9 7.2  7.0   75.02
    ## 101  02336240 2011-05-30 14:45:00   11.00       A  22.9 7.0  7.4   73.22
    ## 102  02336360 2011-05-28 17:30:00   11.00       A  23.5 7.0  7.4   74.30
    ## 103  02337170 2011-05-26 03:45:00 1730.00     A e  20.5 7.0   NA   68.90
    ## 104  02203700 2011-05-03 11:00:00    6.10       A  18.8 7.1  6.3   65.84
    ## 105  02336360 2011-05-26 01:30:00    8.40       A  24.7  NA  6.8   76.46
    ## 106  02336120 2011-05-03 03:15:00   16.00     A e  21.2 7.1  7.5   70.16
    ## 107  02336313 2011-05-02 21:00:00    1.00       A  23.2 7.1  7.5   73.76
    ## 108  02336120 2011-05-01 13:45:00   18.00       A  18.1  NA   NA   64.58
    ## 109  02336120 2011-05-10 03:00:00   16.00       A  21.5 7.2  7.7   70.70
    ## 110  02336526 2011-05-17 04:00:00    5.90       A  17.3 7.7  8.3   63.14
    ## 111  02336410 2011-05-05 15:15:00   32.00     A e  15.0 7.0  8.9   59.00
    ## 112  02336240 2011-05-03 00:30:00   13.00       A  21.3 7.2  7.5   70.34
    ## 113  02337170 2011-05-13 15:45:00 3080.00       A  16.6 6.9  9.3   61.88
    ## 114  02336313 2011-05-19 13:45:00    1.00       A  14.9 7.2  8.4   58.82
    ## 115  02336728 2011-05-16 20:00:00   12.00       A  18.1 7.2  9.4   64.58
    ## 116  02336410 2011-05-28 05:45:00   40.00       A  22.4 6.9  6.9   72.32
    ## 117  02336360 2011-05-03 11:30:00   13.00       A  19.9 7.1  7.4   67.82
    ## 118  02203655 2011-05-31 02:15:00    9.20       A  24.9 7.0  6.1   76.82
    ## 119  02336313 2011-05-05 17:30:00    1.30       A  17.2 7.1  9.4   62.96
    ## 120  02336728 2011-05-26 00:45:00    8.60     A e  24.9 7.2  7.3   76.82
    ## 121  02336360 2011-05-27 03:30:00  244.00     A e  22.4 6.6  6.7   72.32
    ## 122  02336313 2011-05-31 07:45:00    0.73       A  23.3 7.4  5.4   73.94
    ## 123  02337170 2011-05-14 05:00:00 4700.00       A  14.5 6.8 10.0   58.10
    ## 124  02336526 2011-05-15 08:45:00    3.60     A e  20.0 7.2  6.6   68.00
    ## 125  02337170 2011-05-10 19:45:00 3850.00       A    NA 6.8  8.2      NA
    ## 126  02336410 2011-05-04 05:15:00  333.00       A  18.6 6.6  7.5   65.48
    ## 127  02336300 2011-05-24 07:45:00   21.00       A  22.7 7.3  6.4   72.86
    ## 128  02336410 2011-05-08 06:15:00   22.00       A  18.0 7.0  7.9   64.40
    ## 129  02336120 2011-05-19 18:45:00   12.00       A  17.9 7.3  9.3   64.22
    ## 130  02337170 2011-05-24 02:00:00 2090.00     A e  21.2 6.9  8.3   70.16
    ## 131  02336728 2011-05-21 06:30:00    9.70       A    NA 7.1  8.0      NA
    ## 132  02336313 2011-05-08 05:00:00    1.00       A  17.8  NA  7.5   64.04
    ## 133  02203655 2011-05-04 18:45:00   26.00       A  17.9  NA  7.9   64.22
    ## 134  02336526 2011-05-01 04:45:00    4.20       A  20.2 6.9  6.6   68.36
    ## 135  02336120 2011-05-31 11:30:00   12.00       A  23.3 6.9  6.6   73.94
    ## 136  02336240 2011-05-12 09:15:00   11.00       A  21.1 7.1  7.0   69.98
    ## 137  02336240 2011-05-14 07:00:00   10.00     A e  21.1 7.2  7.1   69.98
    ## 138  02336240 2011-05-31 06:15:00   11.00       A  23.4 7.0  6.8   74.12
    ## 139  02336313 2011-05-02 08:45:00    1.00       A  19.1 7.0  6.1   66.38
    ## 140  02336728 2011-05-25 14:15:00    8.20     A e  21.2  NA  8.0   70.16
    ## 141  02336728 2011-05-21 06:00:00    9.70       A  18.9 7.1  8.0   66.02
    ## 142  02336240 2011-05-29 05:45:00   15.00       A  21.6  NA  7.1   70.88
    ## 143  02336526 2011-05-09 20:45:00    4.40       A  24.0 8.0 11.0   75.20
    ## 144  02336360 2011-05-08 17:45:00   13.00       A  19.0 7.3  9.0   66.20
    ## 145  02336240 2011-05-05 01:00:00   22.00       A  16.9 7.0  8.2   62.42
    ## 146  02336410 2011-05-26 10:45:00   11.00       A  22.7 7.2  6.8   72.86
    ## 147  02336300 2011-05-10 21:00:00   30.00       A  25.4 7.3  8.8   77.72
    ## 148  02336300 2011-05-08 03:00:00   33.00       A  18.7 7.3  7.8   65.66
    ## 149  02336728 2011-05-24 06:15:00    8.90     A e  21.7 7.1  7.3   71.06
    ## 150  02336313 2011-05-24 13:00:00    0.93       A  20.8 7.1  6.8   69.44
    ## 151  02336120 2011-05-24 13:45:00   11.00       A  21.7 7.1  7.2   71.06
    ## 152  02203700 2011-05-07 04:30:00    5.30     A e  17.3 7.0  5.8   63.14
    ## 153  02336313 2011-05-07 00:45:00    1.10     A e  18.6 7.2  7.8   65.48
    ## 154  02336526 2011-05-09 01:15:00    4.40       A  21.9 7.6  8.4   71.42
    ## 155  02336313 2011-05-24 16:00:00    0.98       A  23.4 7.2  8.6   74.12
    ## 156  02336728 2011-05-31 11:15:00   13.00     A e  22.7 7.0  7.4   72.86
    ## 157  02336300 2011-05-09 12:45:00   33.00       A  18.7 7.3  7.6   65.66
    ## 158  02336120 2011-05-17 08:15:00   13.00       A  15.9 7.2  8.3   60.62
    ## 159  02203700 2011-05-22 09:15:00    3.90     A e  20.0 6.8  4.5   68.00
    ## 160  02203655 2011-05-05 20:30:00   14.00       A  16.8 7.1  8.3   62.24
    ## 161  02203655 2011-05-07 06:30:00   12.00     A e  17.1 7.2  7.5   62.78
    ## 162  02336120 2011-05-05 05:30:00   30.00       A  16.5 6.8  8.3   61.70
    ## 163  02203700 2011-05-17 06:15:00    4.60     A e  16.0 6.9  5.5   60.80
    ## 164  02336360 2011-05-13 22:45:00   11.00       A  23.4 7.3  8.5   74.12
    ## 165  02336360 2011-05-08 18:45:00   13.00     A e  19.6 7.3   NA   67.28
    ## 166  02336120 2011-05-20 06:30:00   12.00     A e  17.8 7.2  8.2   64.04
    ## 167  02337170 2011-05-08 13:15:00 1540.00       A  15.4 6.9  9.1   59.72
    ## 168  02336240 2011-05-21 02:00:00    9.20       A  20.4 7.2  7.4   68.72
    ## 169  02336120 2011-05-03 23:30:00   39.00       A  20.9 7.0  7.8   69.62
    ## 170  02203655 2011-05-05 12:00:00   15.00     A e  14.4 7.1  8.2   57.92
    ## 171  02336300 2011-05-15 21:30:00   27.00       A  19.1 7.6  8.7   66.38
    ## 172  02337170 2011-05-26 05:45:00 1760.00       A  20.2 7.0  8.6   68.36
    ## 173  02336410 2011-05-03 17:45:00   20.00       A  22.0 6.8  8.2   71.60
    ## 174  02203700 2011-05-19 16:00:00    4.00       A  16.8 7.0  8.4   62.24
    ## 175  02336120 2011-05-19 05:00:00   13.00       A  16.2 7.3  8.5   61.16
    ## 176  02336240 2011-05-28 00:30:00   44.00       A  21.9 6.9  7.5   71.42
    ## 177  02337170 2011-05-18 08:00:00 3360.00       A  13.5 7.0 10.1   56.30
    ## 178  02203700 2011-05-13 01:30:00    4.40       A  24.4 6.9  4.6   75.92
    ## 179  02336313 2011-05-06 14:30:00    1.20     A e  15.2 7.1  9.4   59.36
    ## 180  02336728 2011-05-31 10:00:00   13.00       A  22.8 7.0  7.3   73.04
    ## 181  02336120 2011-05-02 11:30:00   16.00       A  19.1 7.0  7.7   66.38
    ## 182  02336120 2011-05-22 15:45:00   11.00       A  21.1 7.2  7.8   69.98
    ## 183  02336120 2011-05-21 02:30:00   12.00       A  20.9 7.0  7.6   69.62
    ## 184  02336240 2011-05-23 06:00:00    8.50       A  21.8 7.1  6.7   71.24
    ## 185  02203655 2011-05-19 06:30:00    8.80       A  16.0 7.0  8.1   60.80
    ## 186  02336313 2011-05-24 09:45:00    0.93       A  21.0 7.1  5.7   69.80
    ## 187  02336410 2011-05-27 01:45:00  147.00       A  22.8 6.9  6.4   73.04
    ## 188  02336410 2011-05-26 19:00:00   10.00       A  24.8 7.5  8.2   76.64
    ## 189  02336300 2011-05-12 19:30:00   27.00       A  26.0 7.5  8.9   78.80
    ## 190  02336120 2011-05-31 13:30:00   12.00       A  23.3 7.0  6.9   73.94
    ## 191  02336120 2011-05-22 17:45:00   11.00     A e  22.2 7.3  8.1   71.96
    ## 192  02336120 2011-05-21 18:30:00   12.00       A  21.3 7.4  8.5   70.34
    ## 193  02336526 2011-05-16 05:00:00    3.80       A  17.7 7.5   NA   63.86
    ## 194  02336120 2011-05-23 15:00:00   11.00       A  21.7 7.2  7.5   71.06
    ## 195  02336410 2011-05-06 15:45:00   25.00     A e  15.6 7.0  9.1   60.08
    ## 196  02336120 2011-05-17 21:45:00   14.00       A  16.6 7.3  9.3   61.88
    ## 197  02336313 2011-05-14 04:00:00    0.93       A  22.2 7.2  6.6   71.96
    ## 198  02336300 2011-05-18 14:00:00   27.00       A  14.3 7.5  8.9   57.74
    ## 199  02336360 2011-05-02 17:15:00   14.00       A  20.6 7.2  8.8   69.08
    ## 200  02336526 2011-05-11 21:45:00    3.80       A  26.0 8.2 10.6   78.80
    ## 201  02336360 2011-05-14 05:45:00   11.00       A  21.9 7.1  6.9   71.42
    ## 202  02337170 2011-05-23 08:15:00 1410.00     A e  19.9 6.8  8.3   67.82
    ## 203  02203655 2011-05-19 18:00:00    9.20     A e  16.9 7.1  9.3   62.42
    ## 204  02203655 2011-05-17 05:15:00   10.00       A  16.8 7.1  8.1   62.24
    ## 205  02203700 2011-05-13 22:30:00    4.40       A  24.2 7.2  9.5   75.56
    ## 206  02336526 2011-05-17 07:30:00    4.20       A  16.3 7.3  7.7   61.34
    ## 207  02336313 2011-05-05 08:15:00    1.30     A e  14.2 6.9  7.7   57.56
    ## 208  02203700 2011-05-21 09:45:00    4.60       A  18.3 6.8  5.3   64.94
    ## 209  02336410 2011-05-26 18:15:00   11.00       A  24.3 7.4  8.5   75.74
    ## 210  02336313 2011-05-23 17:00:00    0.98       A  23.7 7.2  8.8   74.66
    ## 211  02336300 2011-05-09 21:30:00   31.00       A  23.9 7.3  8.6   75.02
    ## 212  02336728 2011-05-25 03:30:00    8.60       A  23.0 7.1  7.1   73.40
    ## 213  02336728 2011-05-15 03:15:00   12.00       A  20.5 7.2  7.6   68.90
    ## 214  02336526 2011-05-28 02:30:00   17.00     A e  22.4 6.9  7.2   72.32
    ## 215  02203655 2011-05-28 18:00:00   18.00       A  21.2  NA  7.3   70.16
    ## 216  02336240 2011-05-14 04:00:00   10.00       A  21.8 7.2  6.9   71.24
    ## 217  02336410 2011-05-06 00:45:00   28.00       A  17.5 7.0  8.4   63.50
    ## 218  02336728 2011-05-31 02:00:00   14.00       A  24.7 7.0  7.2   76.46
    ## 219  02336313 2011-05-05 13:30:00    1.40       A  13.4 7.0  8.9   56.12
    ## 220  02336313 2011-05-06 00:30:00    1.20       A  17.9 7.0  7.9   64.22
    ## 221  02336240 2011-05-07 05:45:00   13.00     A e  16.0 7.2  8.3   60.80
    ## 222  02336120 2011-05-27 19:45:00  105.00       A    NA 6.5  7.2      NA
    ## 223  02336360 2011-05-01 08:30:00   14.00       A  18.5 7.0  7.5   65.30
    ## 224  02336526 2011-05-05 16:15:00    5.70       A  14.9 7.0  9.8   58.82
    ## 225  02336526 2011-05-24 22:45:00    3.30     A e  25.4  NA 11.9   77.72
    ## 226  02336360 2011-05-31 06:45:00    6.30       A  24.3  NA  6.5   75.74
    ## 227  02203655 2011-05-23 09:30:00    7.20       A  21.5 6.9  5.9   70.70
    ## 228  02336240 2011-05-27 15:00:00  312.00     A e  19.9 6.7  8.3   67.82
    ## 229  02336300 2011-05-16 18:30:00   27.00       A  17.6 7.6  9.0   63.68
    ## 230  02336120 2011-05-04 09:45:00  191.00       A  17.0 6.4  8.1   62.60
    ## 231  02203700 2011-05-12 12:45:00    4.60       A  20.3 6.9  5.2   68.54
    ## 232  02336728 2011-05-15 19:30:00   11.00     A e  19.5  NA  8.9   67.10
    ## 233  02336526 2011-05-21 14:15:00    3.60       A  19.0 7.6  8.2   66.20
    ## 234  02336410 2011-05-23 16:00:00   13.00       A  22.3 7.3  8.1   72.14
    ## 235  02336300 2011-05-09 10:15:00   31.00       A  18.9 7.3  7.4   66.02
    ## 236  02336360 2011-05-16 18:00:00   10.00     A e  17.8 7.3  9.8   64.04
    ## 237  02337170 2011-05-06 19:30:00 7840.00       A  12.2 6.8 10.6   53.96
    ## 238  02336526 2011-05-20 10:15:00    3.50     A e  17.4 7.6  7.4   63.32
    ## 239  02336300 2011-05-24 17:30:00   21.00       A  24.6 7.5  8.5   76.28
    ## 240  02336728 2011-05-29 17:00:00   20.00       A  23.3 7.0  7.8   73.94
    ## 241  02336240 2011-05-29 23:45:00   13.00       A  24.6 7.0  6.9   76.28
    ## 242  02337170 2011-05-12 16:00:00 5910.00       A  15.4 6.8   NA   59.72
    ## 243  02336526 2011-05-15 23:45:00    3.80       A  18.6 8.0 10.3   65.48
    ## 244  02336240 2011-05-13 01:45:00   10.00       A  23.4 7.1  6.8   74.12
    ## 245  02336313 2011-05-12 00:30:00    0.93     A e  24.6 7.2  6.5   76.28
    ## 246  02337170 2011-05-27 04:15:00 1780.00       A  20.7 7.0  8.4   69.26
    ## 247  02336300 2011-05-12 23:15:00   27.00       A  25.8 7.5  7.9   78.44
    ## 248  02336728 2011-05-03 18:15:00   16.00     A e  22.9 7.2  8.5   73.22
    ## 249  02336120 2011-05-12 16:15:00   14.00       A  22.3 7.2  8.1   72.14
    ## 250  02336728 2011-05-31 00:45:00   14.00       A  25.3 7.0  7.2   77.54
    ## 251  02336300 2011-05-24 10:00:00   21.00       A  22.2 7.3  6.5   71.96
    ## 252  02336240 2011-05-13 08:45:00    9.90     A e  21.2 7.1  7.0   70.16
    ## 253  02336300 2011-05-01 23:30:00   32.00     A e  21.9 7.3  7.8   71.42
    ## 254  02336410 2011-05-21 01:15:00   14.00       A  20.7 7.3  8.2   69.26
    ## 255  02336313 2011-05-01 14:30:00    1.10       A  18.3 7.1  7.9   64.94
    ## 256  02336120 2011-05-03 21:30:00   17.00       A  21.9 7.1  8.1   71.42
    ## 257  02336120 2011-05-16 08:00:00   13.00     A e  17.2 7.2  8.1   62.96
    ## 258  02336120 2011-05-24 10:00:00   10.00       A  21.8 7.1  6.9   71.24
    ## 259  02336360 2011-05-27 20:00:00   27.00     A e  23.4 6.8  7.3   74.12
    ## 260  02336313 2011-05-09 07:30:00    1.00       A  18.8 7.2  6.9   65.84
    ## 261  02336240 2011-05-15 03:45:00    9.90       A  20.4 7.2  7.1   68.72
    ## 262  02336120 2011-05-25 15:00:00   11.00     A e  22.0 7.1  7.4   71.60
    ## 263  02203700 2011-05-02 01:00:00    6.10       A  21.9 7.1  7.6   71.42
    ## 264  02336410 2011-05-16 17:45:00   16.00     A e  17.2 7.3  9.1   62.96
    ## 265  02336120 2011-05-15 07:45:00   13.00       A  19.7 7.2  7.4   67.46
    ## 266  02336120 2011-05-12 06:00:00   14.00       A  22.5 7.1  7.1   72.50
    ## 267  02203700 2011-05-27 00:45:00  113.00       A    NA 6.6  7.0      NA
    ## 268  02203655 2011-05-26 19:00:00    7.50       A  23.4 7.0  6.3   74.12
    ## 269  02336526 2011-05-15 03:15:00    3.60     A e  22.1 7.9  7.3   71.78
    ## 270  02203655 2011-05-31 19:00:00    9.60       A  24.0 7.2  7.0   75.20
    ## 271  02336120 2011-05-05 18:45:00   23.00       A  17.0 7.0  9.0   62.60
    ## 272  02336300 2011-05-07 16:30:00   36.00     A e    NA 7.3   NA      NA
    ## 273  02337170 2011-05-14 09:00:00 3920.00       A  15.0 6.9  9.8   59.00
    ## 274  02336120 2011-05-05 14:45:00   24.00       A  14.8 7.0  8.9   58.64
    ## 275  02336240 2011-05-08 17:00:00   12.00       A  19.2 7.3  9.0   66.56
    ## 276  02203700 2011-05-15 14:00:00    4.40       A  18.2 7.0  7.1   64.76
    ## 277  02336360 2011-05-31 08:30:00    6.00       A  23.9 6.9  6.4   75.02
    ## 278  02337170 2011-05-04 17:15:00 6130.00       A  16.2 6.7  8.5   61.16
    ## 279  02336240 2011-05-19 04:00:00    9.90       A  15.7 7.3  8.3   60.26
    ## 280  02337170 2011-05-02 19:15:00 4390.00       A  16.8 6.8  9.4   62.24
    ## 281  02336313 2011-05-19 05:45:00    1.00     A e  15.6 7.2  7.4   60.08
    ## 282  02336313 2011-05-09 20:00:00    1.00       A  23.7 7.3  8.5   74.66
    ## 283  02336300 2011-05-14 21:15:00   27.00       A  24.0 7.6  8.5   75.20
    ## 284  02336360 2011-05-21 14:15:00    9.80       A  19.0 7.1  8.1   66.20
    ## 285  02336410 2011-05-22 00:30:00   14.00       A  22.5 7.3  7.9   72.50
    ## 286  02336240 2011-05-21 21:45:00    9.20       A  23.3 7.3   NA   73.94
    ## 287  02336526 2011-05-21 06:45:00    3.60       A  20.7 7.8  6.9   69.26
    ## 288  02336313 2011-05-14 06:15:00    0.98     A e  21.5 7.2  6.4   70.70
    ## 289  02336313 2011-05-19 18:45:00    1.00     A e  19.8 7.3  9.3   67.64
    ## 290  02336728 2011-05-03 05:15:00   15.00       A  20.0 7.0  7.7   68.00
    ## 291  02336300 2011-05-01 15:45:00   33.00       A  19.4 7.3  7.9   66.92
    ## 292  02336526 2011-05-11 17:45:00    4.00     A e  23.4 7.5 10.2   74.12
    ## 293  02336240 2011-05-17 10:45:00   11.00       A  15.0 7.3  8.4   59.00
    ## 294  02336410 2011-05-16 14:45:00   16.00       A  16.9 7.2  8.9   62.42
    ## 295  02203655 2011-05-06 20:15:00   12.00       A  17.1 7.2  8.1   62.78
    ## 296  02336360 2011-05-03 04:15:00   13.00       A  21.1 7.1  7.3   69.98
    ## 297  02336360 2011-05-24 21:15:00    9.10       A  25.8 7.5  8.7   78.44
    ## 298  02336300 2011-05-24 22:15:00   21.00       A  26.6 7.5  8.4   79.88
    ## 299  02336313 2011-05-14 17:15:00    1.10       A  21.8 7.3  8.7   71.24
    ## 300  02336240 2011-05-23 17:15:00    8.50       A  23.5 7.3  9.4   74.30
    ## 301  02336120 2011-05-27 11:15:00 1060.00       A  20.9 6.3  7.0   69.62
    ## 302  02336313 2011-05-10 10:00:00    1.00       A  19.6 7.2  6.7   67.28
    ## 303  02336313 2011-05-14 12:00:00    1.00     A e  20.2 7.2  6.8   68.36
    ## 304  02336410 2011-05-13 08:15:00   17.00       A  22.2 7.1  7.1   71.96
    ## 305  02336313 2011-05-02 04:45:00    0.98       A  20.4 7.0  5.5   68.72
    ## 306  02336313 2011-05-08 21:00:00    1.00       A  21.8  NA  8.6   71.24
    ## 307  02336313 2011-06-01 03:45:00    0.65       A  25.3 7.2  4.6   77.54
    ## 308  02336410 2011-05-17 07:00:00   16.00       A  16.4 7.2  8.5   61.52
    ## 309  02336526 2011-05-22 19:15:00    3.50       A  24.3 8.7 11.9   75.74
    ## 310  02336300 2011-05-18 02:30:00   27.00       A  15.7 7.6  8.4   60.26
    ## 311  02336120 2011-05-28 01:15:00   58.00       A  22.5 6.6  7.0   72.50
    ## 312  02336360 2011-05-13 03:15:00   11.00     A e    NA 7.0  6.9      NA
    ## 313  02336240 2011-05-13 03:15:00   10.00       A  22.8 7.1  6.8   73.04
    ## 314  02337170 2011-05-29 07:45:00 2000.00     A e  21.5 6.8  7.4   70.70
    ## 315  02337170 2011-05-08 12:00:00 1580.00       A  15.4 6.9  9.2   59.72
    ## 316  02203655 2011-05-24 08:00:00    7.50       A  22.1 6.9  5.8   71.78
    ## 317  02336526 2011-05-27 08:45:00 2650.00       A  19.4 6.4  8.5   66.92
    ## 318  02336410 2011-05-11 19:15:00   17.00     A e  24.8 7.3  8.4   76.64
    ## 319  02203655 2011-05-20 04:45:00    8.50       A  18.4 7.0  7.7   65.12
    ## 320  02336300 2011-05-16 23:30:00   29.00     A e  18.2 7.6  8.6   64.76
    ## 321  02336526 2011-05-30 16:45:00    5.00     A e  24.2 7.4  8.6   75.56
    ## 322  02336240 2011-05-05 08:15:00   18.00       A  15.1 7.1  8.4   59.18
    ## 323  02336526 2011-05-03 16:00:00    4.20     A e  20.7 7.1  8.6   69.26
    ## 324  02203700 2011-05-01 19:15:00    6.10       A  23.5 7.2 11.2   74.30
    ## 325  02336313 2011-05-12 08:00:00    1.00     A e  21.5 7.2  6.2   70.70
    ## 326  02203655 2011-05-30 09:15:00   10.00       A  23.1 6.8  6.3   73.58
    ## 327  02336728 2011-05-23 21:30:00    9.30     A e  25.3 7.3  8.5   77.54
    ## 328  02203655 2011-05-17 07:00:00   10.00     A e  16.5 7.1  8.2   61.70
    ## 329  02336526 2011-05-14 03:15:00    3.50     A e  23.0 8.0  7.2   73.40
    ## 330  02337170 2011-05-18 19:00:00 3830.00       A  13.6 6.9  9.9   56.48
    ## 331  02203700 2011-05-08 05:00:00    5.10       A  18.2 7.1  4.3   64.76
    ## 332  02336728 2011-05-05 01:30:00   31.00     A e  17.4 6.9  8.3   63.32
    ## 333  02336313 2011-05-13 21:45:00    1.00     A e  24.3 7.3  8.2   75.74
    ## 334  02336240 2011-05-22 01:00:00    8.90     A e  22.1 7.2  7.3   71.78
    ## 335  02337170 2011-05-10 06:00:00 1350.00       A  21.2 6.9  7.8   70.16
    ## 336  02336120 2011-05-19 11:15:00   12.00       A  14.9 7.2  8.6   58.82
    ## 337  02336526 2011-05-14 19:45:00    3.60     A e  23.3 7.8 11.1   73.94
    ## 338  02337170 2011-05-07 15:45:00 4520.00       A  13.8 6.8  9.8   56.84
    ## 339  02337170 2011-05-28 00:45:00 5540.00       A  20.5 6.5  7.0   68.90
    ## 340  02336360 2011-05-03 23:00:00   25.00       A  20.6 7.0  7.8   69.08
    ## 341  02336120 2011-05-15 08:15:00   13.00       A  19.6 7.2  7.4   67.28
    ## 342  02336300 2011-05-07 01:30:00   36.00       A  17.8 7.3  8.0   64.04
    ## 343  02203655 2011-05-22 08:15:00    7.50       A  20.9 7.0  6.5   69.62
    ## 344  02203655 2011-05-02 11:15:00   11.00     A e  18.9 7.1  6.7   66.02
    ## 345  02336526 2011-05-05 13:00:00    5.70     A e  13.2 6.9  8.8   55.76
    ## 346  02336240 2011-05-02 12:00:00   13.00     A e  18.6 7.2  7.7   65.48
    ## 347  02203700 2011-05-26 14:00:00    3.50       A  21.8 6.9  6.0   71.24
    ## 348  02336410 2011-05-19 10:30:00   16.00       A  14.9 7.2  8.9   58.82
    ## 349  02203700 2011-05-07 14:30:00    5.30       A  16.0 7.2  8.0   60.80
    ## 350  02203655 2011-05-25 22:15:00    7.50       A  23.4 7.0  6.3   74.12
    ## 351  02203700 2011-05-08 02:00:00    5.10     A e  19.8 7.1  4.0   67.64
    ## 352  02336728 2011-05-18 03:00:00   11.00     A e  15.3  NA  8.9   59.54
    ## 353  02336410 2011-05-02 19:00:00   21.00       A  22.0 6.8  8.5   71.60
    ## 354  02336120 2011-05-28 16:00:00   27.00     A e  22.0 6.8  7.3   71.60
    ## 355  02336526 2011-05-30 23:30:00    4.60       A    NA 7.7  8.6      NA
    ## 356  02203700 2011-05-13 07:15:00    4.40       A  21.3 6.8  3.9   70.34
    ## 357  02336240 2011-05-05 07:15:00   18.00       A  15.4 7.0  8.3   59.72
    ## 358  02203700 2011-05-16 00:00:00    4.20       A  18.4 7.0   NA   65.12
    ## 359  02203655 2011-05-18 20:45:00    8.80     A e  16.0 7.1  9.3   60.80
    ## 360  02337170 2011-05-22 01:45:00 3430.00       A  17.5 6.8  9.2   63.50
    ## 361  02203655 2011-05-01 19:15:00   11.00       A  19.9 7.2  7.1   67.82
    ## 362  02203655 2011-05-21 01:00:00    8.20       A  20.5 7.0  7.3   68.90
    ## 363  02336300 2011-05-25 13:30:00   19.00     A e  22.1 7.4  7.0   71.78
    ## 364  02336313 2011-05-12 23:45:00    0.98       A  25.0 7.2  6.7   77.00
    ## 365  02337170 2011-05-26 02:00:00 1710.00     A e  20.9  NA  8.8   69.62
    ## 366  02336728 2011-05-02 17:45:00   16.00       A  21.8 7.1  8.7   71.24
    ## 367  02336410 2011-05-14 18:15:00   16.00       A  22.1 7.4  8.6   71.78
    ## 368  02336313 2011-05-30 09:30:00    0.73       A  22.6 7.5  5.5   72.68
    ## 369  02336410 2011-05-07 20:00:00   22.00       A  19.3 7.2  8.9   66.74
    ## 370  02203655 2011-05-24 09:45:00    7.50       A  21.6 6.9  5.8   70.88
    ## 371  02203700 2011-05-12 18:30:00    4.60       A  25.6 7.4 11.4   78.08
    ## 372  02336410 2011-05-09 19:15:00   20.00     A e  22.2 7.3  8.7   71.96
    ## 373  02336360 2011-05-19 11:00:00   10.00       A  14.8 7.0  8.7   58.64
    ## 374  02336240 2011-05-20 12:15:00    9.50     A e  16.3 7.2  8.2   61.34
    ## 375  02336360 2011-05-25 18:30:00    8.40     A e  24.9 7.3  8.9   76.82
    ## 376  02336120 2011-05-27 14:45:00  338.00       A  20.4 6.2  7.1   68.72
    ## 377  02203655 2011-05-28 13:15:00   21.00     A e  20.0 6.4  7.1   68.00
    ## 378  02203655 2011-05-07 12:00:00   12.00       A  15.2 7.2  8.0   59.36
    ## 379  02336240 2011-05-08 10:30:00   12.00       A  16.5 7.2  8.1   61.70
    ## 380  02336120 2011-05-13 17:00:00   14.00       A  22.5 7.3  8.2   72.50
    ## 381  02336526 2011-05-01 13:15:00    4.40       A  17.3 6.9  7.7   63.14
    ## 382  02336360 2011-05-16 01:15:00   11.00     A e  18.3 7.2  8.4   64.94
    ## 383  02337170 2011-05-29 00:45:00 2570.00       A  21.6 6.8  7.4   70.88
    ## 384  02336300 2011-05-13 21:30:00   27.00       A  24.7 7.6  8.5   76.46
    ## 385  02336728 2011-05-25 04:45:00    8.60       A  22.4 7.1  7.2   72.32
    ## 386  02336410 2011-05-28 11:00:00   32.00       A  21.3 6.9  7.0   70.34
    ## 387  02336240 2011-05-28 21:30:00   19.00       A  23.8 7.0  7.2   74.84
    ## 388  02336240 2011-05-07 13:15:00   13.00       A  15.0 7.2  8.6   59.00
    ## 389  02336300 2011-05-08 14:00:00   33.00       A  17.2 7.3  7.0   62.96
    ## 390  02203655 2011-05-25 07:00:00    7.20       A  22.3 6.9  5.6   72.14
    ## 391  02336313 2011-05-09 11:15:00    1.10       A  17.9 7.2  7.2   64.22
    ## 392  02203700 2011-05-17 09:30:00    4.40       A  15.2 6.9  5.4   59.36
    ## 393  02336240 2011-05-08 04:45:00   13.00     A e  17.4 7.2  8.0   63.32
    ## 394  02336410 2011-05-10 08:45:00   19.00     A e  20.8  NA  7.3   69.44
    ## 395  02337170 2011-05-16 23:30:00 1910.00       A  16.8 7.0  9.0   62.24
    ## 396  02336313 2011-05-16 15:15:00    1.10       A  16.5 7.3  8.4   61.70
    ## 397  02336360 2011-05-03 22:15:00   17.00       A  21.3 7.1   NA   70.34
    ## 398  02336240 2011-05-23 05:00:00    8.20       A  22.2 7.1  6.7   71.96
    ## 399  02203655 2011-05-04 10:45:00   63.00     A e  16.1 6.9  8.0   60.98
    ## 400  02336360 2011-05-20 14:30:00   10.00       A  17.1 7.1  8.6   62.78
    ## 401  02203655 2011-05-20 16:30:00    8.50       A  18.2 7.0  8.6   64.76
    ## 402  02336360 2011-05-18 19:30:00   10.00       A  17.6 7.4 10.8   63.68
    ## 403  02336410 2011-05-31 20:30:00   11.00       A  27.2 7.2  7.7   80.96
    ## 404  02336526 2011-05-30 15:45:00    5.00       A  23.4 7.3  8.2   74.12
    ## 405  02336300 2011-05-19 03:45:00   27.00       A  16.5 7.5  8.3   61.70
    ## 406  02336300 2011-05-22 05:00:00   24.00       A    NA 7.3  6.9      NA
    ## 407  02336728 2011-05-24 08:15:00    8.90       A  21.1 7.1  7.4   69.98
    ## 408  02203700 2011-05-22 10:00:00    3.90       A  19.8 6.8  4.5   67.64
    ## 409  02203655 2011-05-30 08:15:00   10.00     A e    NA 6.7  6.3      NA
    ## 410  02336360 2011-05-11 08:45:00   12.00       A  21.8 7.0  7.0   71.24
    ## 411  02336360 2011-05-12 12:00:00   11.00     A e  21.2 7.0  7.1   70.16
    ## 412  02336120 2011-05-15 21:30:00   13.00       A  18.9 7.3  8.6   66.02
    ## 413  02336120 2011-05-10 16:15:00   15.00       A  20.8 7.2  8.3   69.44
    ## 414  02336526 2011-05-30 21:15:00    4.80       A  27.0 7.7  9.3   80.60
    ## 415  02336526 2011-05-10 12:00:00    4.00       A  19.7 7.0   NA   67.46
    ## 416  02336360 2011-05-20 04:45:00   10.00       A  18.1 7.1  8.0   64.58
    ## 417  02336120 2011-05-22 16:00:00   11.00       A  21.2 7.2  7.9   70.16
    ## 418  02336728 2011-05-13 13:15:00   12.00       A  21.1 7.1  7.6   69.98
    ## 419  02336728 2011-05-31 04:00:00   14.00       A  23.8 7.0  7.3   74.84
    ## 420  02336300 2011-05-15 02:15:00   27.00       A  21.8 7.5  7.1   71.24
    ## 421  02336120 2011-05-24 03:45:00   11.00     A e  23.4 7.2  6.9   74.12
    ## 422  02336313 2011-05-23 07:15:00    0.93       A  21.6 7.1  5.8   70.88
    ## 423  02203700 2011-05-06 16:45:00    5.80     A e  17.9 7.2   NA   64.22
    ## 424  02336300 2011-05-12 13:30:00   27.00     A e  21.8 7.4  7.2   71.24
    ## 425  02336526 2011-05-30 18:30:00    5.00     A e  25.7 7.5  9.3   78.26
    ## 426  02336526 2011-05-28 20:00:00    8.30     A e  24.9 7.2  8.2   76.82
    ## 427  02336120 2011-05-25 18:45:00   10.00     A e  23.9 7.2  8.1   75.02
    ## 428  02203700 2011-05-21 10:30:00    4.60       A  18.1 6.8  5.3   64.58
    ## 429  02336728 2011-05-19 16:00:00   11.00       A  16.5 7.2  9.7   61.70
    ## 430  02336120 2011-05-15 11:45:00   13.00       A  18.9 7.2  7.6   66.02
    ## 431  02336300 2011-05-01 17:45:00   32.00     A e  21.0 7.3  8.1   69.80
    ## 432  02203700 2011-05-06 14:00:00    5.80     A e  14.9 7.1  7.8   58.82
    ## 433  02336410 2011-05-02 22:15:00   21.00       A  22.0 6.8  8.0   71.60
    ## 434  02336526 2011-05-02 09:45:00    4.00     A e  19.5 7.0  7.0   67.10
    ## 435  02337170 2011-05-03 18:15:00 7180.00       A    NA 6.8 10.3      NA
    ## 436  02336526 2011-05-11 19:00:00    4.00       A  24.7 7.8 10.8   76.46
    ## 437  02336360 2011-05-02 15:30:00   14.00       A  19.6 7.1  8.3   67.28
    ## 438  02336526 2011-05-10 18:30:00    4.60       A  23.5 7.6 10.6   74.30
    ## 439  02336313 2011-05-31 12:30:00    0.77     A e  22.1 7.4  6.0   71.78
    ## 440  02336728 2011-05-03 19:30:00   16.00       A  22.8 7.1  8.2   73.04
    ## 441  02336300 2011-05-22 14:30:00   23.00       A  21.4 7.4  7.8   70.52
    ## 442  02337170 2011-05-13 04:15:00 4220.00     A e  15.3 6.8   NA   59.54
    ## 443  02203700 2011-05-23 02:00:00    3.70     A e  24.2 6.8  4.2   75.56
    ## 444  02203700 2011-05-21 11:00:00    4.60       A  17.9 6.8  5.3   64.22
    ## 445  02336240 2011-05-30 02:45:00   12.00       A  23.6 7.0  6.8   74.48
    ## 446  02336313 2011-05-02 02:15:00    0.98       A  21.4 7.0  6.1   70.52
    ## 447  02203700 2011-05-10 23:45:00    4.60       A  25.1 7.3  6.1   77.18
    ## 448  02336410 2011-05-30 15:30:00   14.00       A  23.7 7.0  7.1   74.66
    ## 449  02336300 2011-05-21 04:15:00   24.00     A e  20.8 7.4  7.3   69.44
    ## 450  02336526 2011-05-23 10:30:00    3.60     A e  21.5 7.5  6.2   70.70
    ## 451  02336240 2011-05-31 05:15:00   11.00       A  23.7 7.0  6.8   74.66
    ## 452  02336410 2011-05-27 19:15:00   90.00       A  22.1 6.8  7.2   71.78
    ## 453  02203700 2011-05-05 19:30:00   18.00       A  21.1 6.6  7.4   69.98
    ## 454  02336300 2011-05-01 05:30:00   33.00     A e  19.8 7.2  7.1   67.64
    ## 455  02203700 2011-05-15 05:45:00    4.20     A e  20.0  NA  4.4   68.00
    ## 456  02336728 2011-05-04 15:15:00   62.00       A  16.8 6.8  8.6   62.24
    ## 457  02336120 2011-05-28 15:00:00   28.00     A e  21.6 6.8  7.3   70.88
    ## 458  02336526 2011-05-01 12:00:00    4.40       A  17.3 6.9  7.4   63.14
    ## 459  02336360 2011-05-27 18:00:00   34.00     A e  22.4 6.7  7.3   72.32
    ## 460  02203655 2011-05-06 11:00:00   13.00       A  14.8 7.2  8.2   58.64
    ## 461  02336410 2011-05-10 06:15:00   19.00     A e    NA 7.0  7.3      NA
    ## 462  02336360 2011-05-31 06:15:00    6.30       A  24.4 6.9  6.5   75.92
    ## 463  02203655 2011-05-29 12:15:00   13.00       A  20.8 6.7  6.6   69.44
    ## 464  02336313 2011-05-11 06:30:00    0.98     A e  21.7 7.2  6.1   71.06
    ## 465  02336360 2011-05-14 22:00:00   11.00     A e  23.0 7.4  8.6   73.40
    ## 466  02336240 2011-05-01 09:45:00   13.00       A  17.7 7.2  7.7   63.86
    ## 467  02336526 2011-05-25 19:15:00    3.00       A  24.7 8.5 11.6   76.46
    ## 468  02336120 2011-05-01 09:45:00   17.00     A e  18.3 7.0  7.8   64.94
    ## 469  02336240 2011-05-04 18:15:00   30.00       A  18.1 7.0  8.6   64.58
    ## 470  02336410 2011-05-20 05:00:00   15.00       A  18.0 7.2  8.3   64.40
    ## 471  02337170 2011-05-26 03:30:00 1730.00       A  20.6 7.0  8.7   69.08
    ## 472  02336410 2011-05-13 04:30:00   17.00       A  23.1 7.1  7.0   73.58
    ## 473  02336120 2011-05-10 19:00:00   16.00       A  22.8 7.3  8.7   73.04
    ## 474  02336120 2011-05-05 13:30:00   25.00       A  14.6 6.9  8.8   58.28
    ## 475  02336360 2011-05-11 04:15:00   12.00       A  22.8 7.0  6.9   73.04
    ## 476  02336410 2011-05-17 20:30:00   16.00       A  16.3 7.4 10.0   61.34
    ## 477  02336313 2011-05-13 06:30:00    0.98     A e  21.9 7.2  6.0   71.42
    ## 478  02336410 2011-05-19 15:45:00   15.00       A  15.6 7.3  9.8   60.08
    ## 479  02336313 2011-05-05 12:00:00    1.40       A  13.1 7.0   NA   55.58
    ## 480  02336313 2011-05-07 16:45:00    1.20     A e    NA 7.2  9.2      NA
    ## 481  02203700 2011-05-07 16:00:00    5.60       A    NA 7.2  8.7      NA
    ## 482  02203700 2011-05-10 21:45:00    4.90     A e  26.3 7.3  9.4   79.34
    ## 483  02336360 2011-05-22 21:30:00    9.80       A  25.3 7.5  8.8   77.54
    ## 484  02336240 2011-05-22 21:45:00    8.50       A  24.8 7.3  8.4   76.64
    ## 485  02336728 2011-05-24 08:00:00    8.90       A  21.2 7.1  7.4   70.16
    ## 486  02203655 2011-05-29 02:45:00   14.00     A e  23.6 6.5  6.3   74.48
    ## 487  02336300 2011-05-11 22:45:00   31.00       A  25.9 7.5  7.9   78.62
    ## 488  02336240 2011-05-21 04:15:00    9.20     A e    NA 7.2  7.3      NA
    ## 489  02336300 2011-05-03 21:30:00   30.00       A  22.3 7.3  7.7   72.14
    ## 490  02336360 2011-05-14 15:00:00   11.00     A e  21.0  NA  8.1   69.80
    ## 491  02337170 2011-05-28 22:30:00 2630.00       A  21.8 6.8  7.5   71.24
    ## 492  02336360 2011-05-02 22:15:00   14.00       A  22.2 7.2  8.4   71.96
    ## 493  02336526 2011-05-06 12:45:00    5.20       A  13.9 7.0  8.8   57.02
    ## 494  02336240 2011-05-07 03:15:00   13.00       A  16.7 7.2  8.1   62.06
    ## 495  02336240 2011-05-29 13:45:00   14.00     A e  21.3 7.0  7.3   70.34
    ## 496  02336240 2011-05-28 20:00:00   19.00       A  24.0 7.0  7.4   75.20
    ## 497  02336526 2011-05-20 08:45:00    3.60       A  17.9 7.6  7.4   64.22
    ## 498  02203700 2011-05-14 04:00:00    4.20       A  21.9 6.9   NA   71.42
    ## 499  02203700 2011-05-02 07:45:00    5.80       A  19.4 7.0  6.2   66.92
    ## 500  02336120 2011-05-10 14:45:00   15.00       A  20.2 7.2  8.0   68.36
    ## 501  02336300 2011-05-21 03:45:00   25.00       A    NA 7.4  7.4      NA
    ## 502  02336728 2011-05-24 09:45:00    8.90     A e  20.8 7.1  7.4   69.44
    ## 503  02336526 2011-05-06 21:00:00    5.20       A  19.7 7.5 10.4   67.46
    ## 504  02336728 2011-05-20 22:15:00   10.00     A e  22.8 7.3  8.7   73.04
    ## 505  02336360 2011-05-31 00:15:00    6.30     A e  26.2 7.0  6.9   79.16
    ## 506  02336360 2011-05-15 22:30:00   11.00       A  18.9 7.3  9.0   66.02
    ## 507  02336410 2011-05-20 04:30:00   15.00       A  18.0 7.2  8.4   64.40
    ## 508  02336360 2011-05-28 20:45:00   10.00       A  25.3 7.0  7.1   77.54
    ## 509  02336300 2011-05-18 04:00:00   28.00       A  15.4 7.5  7.9   59.72
    ## 510  02337170 2011-05-31 00:45:00 1270.00       A  25.6 6.8  7.3   78.08
    ## 511  02336728 2011-05-15 23:30:00   11.00       A  18.6 7.2  8.5   65.48
    ## 512  02337170 2011-05-06 07:45:00 7140.00     A e  13.1 6.8 10.4   55.58
    ## 513  02336360 2011-05-31 01:00:00    6.30       A  25.9 7.0  6.8   78.62
    ## 514  02336240 2011-05-31 21:00:00   10.00     A e  26.4 7.1  7.7   79.52
    ## 515  02336526 2011-05-07 20:45:00    4.80       A  20.6 7.7 10.8   69.08
    ## 516  02336313 2011-05-28 09:00:00    1.00     A e  20.3 7.3  6.2   68.54
    ## 517  02336360 2011-05-30 18:15:00    6.60       A  25.9 7.0  7.8   78.62
    ## 518  02336410 2011-05-20 20:15:00   14.00       A  21.8 7.5   NA   71.24
    ## 519  02336526 2011-05-14 03:00:00    3.50     A e  23.0  NA  7.4   73.40
    ## 520  02336300 2011-05-19 04:45:00   27.00       A  16.3 7.4  8.3   61.34
    ## 521  02203700 2011-05-25 02:15:00    3.50       A  23.9 6.8  4.6   75.02
    ## 522  02336410 2011-05-17 07:15:00   16.00       A  16.4 7.2  8.5   61.52
    ## 523  02336313 2011-05-11 19:00:00    0.98     A e  25.4 7.3  8.6   77.72
    ## 524  02336728 2011-05-22 04:00:00    9.30     A e  21.0 7.1  7.6   69.80
    ## 525  02337170 2011-05-03 14:00:00 5670.00       A  15.4 6.8   NA   59.72
    ## 526  02336120 2011-05-07 00:30:00   19.00       A  18.4 7.1  8.5   65.12
    ## 527  02203700 2011-05-24 11:45:00    3.70       A  20.3 6.9  4.6   68.54
    ## 528  02336360 2011-05-02 19:15:00   14.00       A  22.1 7.2  9.0   71.78
    ## 529  02336360 2011-05-21 22:45:00    9.80       A  23.4 7.4  8.4   74.12
    ## 530  02336728 2011-05-31 17:00:00   13.00     A e  25.2 7.1  8.0   77.36
    ## 531  02336120 2011-05-05 19:45:00   23.00     A e  17.6 7.0  9.0   63.68
    ## 532  02336526 2011-05-10 23:30:00    5.70       A  26.0 8.3  9.0   78.80
    ## 533  02203700 2011-05-22 23:00:00    3.90       A  25.7 6.9  6.7   78.26
    ## 534  02336300 2011-05-12 10:15:00   28.00     A e  22.0 7.4  6.6   71.60
    ## 535  02336526 2011-05-15 14:15:00    3.60     A e  18.6 7.2   NA   65.48
    ## 536  02336300 2011-05-16 20:15:00   29.00     A e  18.8 7.6  9.2   65.84
    ## 537  02336300 2011-05-13 20:45:00   27.00       A  25.0 7.6  8.8   77.00
    ## 538  02336313 2011-05-02 13:30:00    1.00       A  18.8 7.0  7.3   65.84
    ## 539  02337170 2011-05-29 13:15:00 1680.00     A e  21.2 6.9  7.4   70.16
    ## 540  02336120 2011-05-14 02:15:00   13.00       A  22.6 7.2  7.4   72.68
    ## 541  02336240 2011-05-06 08:45:00   14.00       A  14.8 7.2  8.5   58.64
    ## 542  02336526 2011-05-30 07:00:00    5.70       A  24.0 7.2  6.8   75.20
    ## 543  02336410 2011-05-25 17:00:00   11.00       A  23.4 7.4  8.4   74.12
    ## 544  02336360 2011-05-10 05:45:00   12.00     A e  21.1 7.0  7.3   69.98
    ## 545  02336526 2011-05-06 00:00:00    5.50       A  18.7 7.2  9.2   65.66
    ## 546  02336300 2011-05-14 07:30:00   27.00       A  21.8 7.4  6.7   71.24
    ## 547  02203700 2011-05-10 00:45:00    4.90     A e  23.4 7.3  4.1   74.12
    ## 548  02336240 2011-05-15 05:15:00    9.90     A e  20.0 7.2  7.2   68.00
    ## 549  02203655 2011-05-25 01:45:00    7.20       A  23.1 6.9  6.1   73.58
    ## 550  02336526 2011-05-26 12:30:00    2.80       A  22.4 7.4  6.1   72.32
    ## 551  02336120 2011-05-02 17:00:00   17.00       A  20.0 7.2  8.4   68.00
    ## 552  02336410 2011-05-24 05:00:00   14.00       A  23.0 7.2  6.7   73.40
    ## 553  02336526 2011-05-21 10:00:00    3.50     A e  19.5  NA  6.8   67.10
    ## 554  02337170 2011-05-25 22:00:00 1670.00       A  21.3 7.2  9.0   70.34
    ## 555  02336728 2011-05-22 22:45:00    9.70       A  25.4 7.2  8.0   77.72
    ## 556  02336313 2011-05-07 03:00:00    1.10       A  17.5 7.2  7.7   63.50
    ## 557  02337170 2011-05-22 13:45:00 1880.00       A  16.6 6.9  9.5   61.88
    ## 558  02336526 2011-05-15 09:00:00    3.60     A e  19.9 7.2  6.6   67.82
    ## 559  02336300 2011-05-17 23:15:00   28.00       A  16.3 7.6  9.0   61.34
    ## 560  02203655 2011-05-19 17:30:00    9.20     A e  16.6 7.1  9.3   61.88
    ## 561  02336313 2011-05-02 03:45:00    1.00       A  20.8 7.0  6.0   69.44
    ## 562  02336526 2011-05-25 01:45:00    5.00       A  24.8 8.9  9.0   76.64
    ## 563  02336313 2011-05-17 04:15:00    1.10     A e  16.3 7.2  7.3   61.34
    ## 564  02336360 2011-05-29 19:45:00    7.80       A  25.6 7.0  7.6   78.08
    ## 565  02203655 2011-05-06 22:00:00   12.00       A  17.7 7.2  7.8   63.86
    ## 566  02336410 2011-05-10 12:30:00   19.00       A  20.3 7.0  7.5   68.54
    ## 567  02336313 2011-05-08 14:15:00    1.10     A e  17.4 7.2  8.8   63.32
    ## 568  02336728 2011-05-26 13:45:00    7.80     A e  21.5 7.0  7.6   70.70
    ## 569  02336300 2011-05-02 13:30:00   31.00     A e  19.4 7.3  7.4   66.92
    ## 570  02336120 2011-05-29 14:45:00   17.00     A e  22.1 6.9  7.3   71.78
    ## 571  02336728 2011-05-02 04:45:00   16.00     A e  19.1 7.0  7.9   66.38
    ## 572  02203655 2011-05-20 20:45:00    8.80       A  19.8 7.0  8.1   67.64
    ## 573  02336120 2011-05-05 09:00:00   27.00       A  15.5 6.8  8.5   59.90
    ## 574  02336728 2011-05-29 16:45:00   20.00       A  23.2 7.0  7.8   73.76
    ## 575  02336120 2011-05-17 00:00:00   13.00       A  17.7 7.3  8.7   63.86
    ## 576  02336240 2011-05-04 04:30:00  428.00       A  17.7 6.9  8.7   63.86
    ## 577  02336240 2011-05-09 01:30:00   12.00       A  19.6 7.2  7.7   67.28
    ## 578  02336526 2011-05-08 01:45:00    4.80       A  20.3 7.4  8.2   68.54
    ## 579  02336410 2011-05-09 06:15:00   21.00       A  19.6 7.0  7.5   67.28
    ## 580  02336300 2011-05-18 03:00:00   28.00     A e  15.6 7.6  8.3   60.08
    ## 581  02337170 2011-05-11 01:45:00 4000.00       A  20.0 6.8  8.5   68.00
    ## 582  02203655 2011-05-03 05:30:00   11.00       A  21.0 7.1  6.2   69.80
    ## 583  02337170 2011-05-18 20:15:00 4320.00       A  13.6 6.9 10.0   56.48
    ## 584  02336313 2011-05-18 07:45:00    0.98       A  14.2 7.2  7.2   57.56
    ## 585  02203700 2011-05-04 18:45:00   24.00       A  20.8 7.0  7.4   69.44
    ## 586  02203700 2011-05-03 21:00:00    6.70       A  22.3 7.2  9.8   72.14
    ## 587  02336300 2011-05-20 22:45:00   24.00       A  23.3 7.5  8.9   73.94
    ## 588  02336240 2011-05-10 13:30:00   11.00       A  19.7 7.2  7.8   67.46
    ## 589  02336526 2011-05-26 06:15:00    3.50       A  23.5 7.6  6.3   74.30
    ## 590  02336728 2011-05-13 10:00:00   12.00       A  20.9 7.1  7.3   69.62
    ## 591  02336120 2011-05-09 07:00:00   16.00     A e  18.9 7.1  7.8   66.02
    ## 592  02336526 2011-05-18 22:15:00    3.60     A e  17.4 8.9 12.8   63.32
    ## 593  02336410 2011-05-15 21:15:00   16.00       A  19.0 7.4  9.0   66.20
    ## 594  02336120 2011-05-25 00:00:00    9.90       A  25.1 7.2  7.5   77.18
    ## 595  02336526 2011-05-28 03:00:00   16.00       A  22.2 6.9  7.3   71.96
    ## 596  02336240 2011-05-23 18:30:00    8.50       A  24.8 7.4  9.8   76.64
    ## 597  02336728 2011-05-20 09:45:00   10.00       A  16.2 7.1  8.6   61.16
    ## 598  02203655 2011-05-26 02:00:00    6.80       A  23.4 6.9  5.5   74.12
    ## 599  02336313 2011-05-29 15:45:00    0.82       A  22.7 7.4  6.6   72.86
    ## 600  02336120 2011-05-29 17:45:00   17.00       A  23.7 6.8  7.5   74.66
    ## 601  02336300 2011-05-15 16:45:00   25.00       A  19.4 7.6  8.5   66.92
    ## 602  02336526 2011-05-12 07:30:00    3.60       A  22.8 7.2  6.1   73.04
    ## 603  02336240 2011-05-22 19:45:00    8.90       A  25.4 7.4  9.6   77.72
    ## 604  02336728 2011-05-30 12:15:00   16.00       A  22.7 7.0  7.3   72.86
    ## 605  02336313 2011-05-29 07:30:00    0.77       A  21.6 7.5  5.9   70.88
    ## 606  02336300 2011-05-21 18:15:00   24.00       A  23.0 7.5  9.1   73.40
    ## 607  02203700 2011-05-23 20:30:00    3.90       A  25.7 7.1  8.9   78.26
    ## 608  02336410 2011-05-01 19:00:00   22.00       A  21.3 6.9  8.6   70.34
    ## 609  02336120 2011-05-23 08:15:00   11.00       A  21.9 7.1  6.9   71.42
    ## 610  02336240 2011-05-13 03:00:00   10.00     A e  22.9 7.1  6.8   73.22
    ## 611  02336526 2011-05-25 13:15:00    3.60       A  21.3 7.4  6.6   70.34
    ## 612  02203700 2011-05-03 02:00:00    5.80       A  21.7 7.2  6.9   71.06
    ## 613  02336410 2011-05-28 04:15:00   44.00       A  22.6 6.9  6.8   72.68
    ## 614  02336360 2011-05-29 04:45:00    8.70       A  23.3 6.9   NA   73.94
    ## 615  02203655 2011-05-29 10:30:00   13.00       A  21.1 6.7  6.6   69.98
    ## 616  02336526 2011-05-01 15:15:00    4.40       A  17.9 7.0  8.5   64.22
    ## 617  02336313 2011-05-23 04:15:00    0.87     A e  22.9 7.1  5.7   73.22
    ## 618  02336360 2011-05-22 21:15:00    9.80       A  25.4  NA  8.9   77.72
    ## 619  02336120 2011-05-08 05:45:00   17.00     A e  17.8 7.2  8.2   64.04
    ## 620  02203700 2011-05-18 18:15:00    4.20       A  17.7 7.0  9.2   63.86
    ## 621  02336300 2011-05-16 16:30:00   27.00       A  17.0 7.6  8.7   62.60
    ## 622  02336313 2011-05-13 20:45:00    1.00       A  24.4 7.3  8.6   75.92
    ## 623  02336360 2011-05-07 10:15:00   14.00     A e  15.7 7.1  8.3   60.26
    ## 624  02336360 2011-05-24 18:45:00    9.10       A  24.8 7.4  9.1   76.64
    ## 625  02336410 2011-05-20 08:45:00   15.00     A e  17.5 7.2  8.3   63.50
    ## 626  02337170 2011-05-10 13:15:00 2330.00     A e  20.3 6.9  7.9   68.54
    ## 627  02336410 2011-05-09 03:30:00   21.00       A  19.9 7.1  7.7   67.82
    ## 628  02336360 2011-05-07 17:45:00   14.00       A  18.2 7.3  9.0   64.76
    ## 629  02203655 2011-05-05 23:15:00   13.00       A  17.7 7.2  8.0   63.86
    ## 630  02336526 2011-05-20 01:15:00    3.60     A e  20.0 8.9 10.9   68.00
    ## 631  02336526 2011-05-22 03:30:00    3.50       A  23.1 8.6  7.8   73.58
    ## 632  02336313 2011-05-30 10:00:00    0.73       A  22.5 7.5  5.8   72.50
    ## 633  02336526 2011-05-13 13:00:00    3.60       A  20.7 7.2  7.0   69.26
    ## 634  02336360 2011-05-16 05:15:00   11.00     A e  17.7 7.1  8.0   63.86
    ## 635  02203700 2011-05-23 23:30:00    3.70     A e  25.1 6.9  6.8   77.18
    ## 636  02336300 2011-05-15 09:00:00   26.00       A  19.7 7.4  6.9   67.46
    ## 637  02336240 2011-05-15 21:00:00   10.00       A  18.8  NA  8.8   65.84
    ## 638  02336360 2011-05-29 01:30:00    9.40       A  24.2 6.9  6.4   75.56
    ## 639  02336360 2011-05-28 05:45:00   15.00     A e  22.4 6.8  6.7   72.32
    ## 640  02336120 2011-05-04 20:45:00   45.00     A e  18.9 6.8  8.4   66.02
    ## 641  02336526 2011-05-12 02:30:00    3.60       A  24.9 7.9  7.0   76.82
    ## 642  02336300 2011-05-08 23:45:00   33.00       A  20.8 7.3  8.1   69.44
    ## 643  02336313 2011-05-18 00:30:00    1.00       A  16.5 7.2  7.9   61.70
    ## 644  02336240 2011-05-03 20:00:00   13.00       A  22.0 7.2  8.1   71.60
    ## 645  02336410 2011-05-10 11:45:00   19.00       A  20.4 7.0  7.5   68.72
    ## 646  02336300 2011-05-19 10:15:00   26.00       A  15.3 7.4  8.2   59.54
    ## 647  02336728 2011-05-26 07:45:00    7.80       A  21.9 7.0  7.1   71.42
    ## 648  02336313 2011-05-23 09:15:00    0.93       A  20.8 7.1  5.7   69.44
    ## 649  02336313 2011-05-21 07:45:00    0.98       A  19.0 7.2  6.7   66.20
    ## 650  02336120 2011-05-11 13:00:00   15.00       A  21.1 7.2  7.5   69.98
    ## 651  02203655 2011-05-17 17:45:00    9.20       A  16.0 7.1  8.9   60.80
    ## 652  02336240 2011-05-20 16:30:00    9.50       A  19.2 7.3  9.6   66.56
    ## 653  02336728 2011-05-26 05:30:00    8.20     A e  22.5 7.0  7.0   72.50
    ## 654  02336313 2011-05-16 05:45:00    1.00     A e  17.2 7.2  7.6   62.96
    ## 655  02336300 2011-05-02 04:30:00   32.00       A  20.7 7.2  7.0   69.26
    ## 656  02336120 2011-05-17 19:15:00   14.00     A e  16.4  NA  9.4   61.52
    ## 657  02203655 2011-05-27 02:00:00  206.00     A e    NA 6.7  7.2      NA
    ## 658  02336728 2011-05-22 18:45:00    9.30       A  24.6 7.3  9.0   76.28
    ## 659  02203700 2011-05-17 00:00:00    7.00     A e  18.2 7.0  6.4   64.76
    ## 660  02336360 2011-05-11 06:15:00   12.00       A  22.4 7.0  6.9   72.32
    ## 661  02336410 2011-05-28 00:15:00   56.00       A  23.0 6.9  6.9   73.40
    ## 662  02337170 2011-05-10 04:15:00 1340.00       A  21.4 6.9  7.8   70.52
    ## 663  02337170 2011-05-14 08:15:00 4020.00       A  14.9 6.9  9.8   58.82
    ## 664  02336120 2011-05-22 08:15:00   11.00       A  20.8 7.1  7.1   69.44
    ## 665  02336120 2011-05-02 15:45:00   16.00       A  19.7  NA  8.2   67.46
    ## 666  02203655 2011-05-25 20:45:00    7.50       A  23.4 6.9  6.4   74.12
    ## 667  02336526 2011-05-15 09:15:00    3.60       A  19.8 7.2  6.6   67.64
    ## 668  02336728 2011-05-16 11:00:00   11.00       A  16.7 7.1  8.3   62.06
    ## 669  02336120 2011-05-08 00:00:00   17.00       A  19.4 7.2  8.5   66.92
    ## 670  02336240 2011-05-06 20:00:00   14.00     A e  19.1 7.2  8.9   66.38
    ## 671  02203655 2011-05-25 23:45:00    7.20       A  23.4 7.0  6.0   74.12
    ## 672  02336120 2011-05-04 23:45:00   38.00       A  18.2 6.7  8.2   64.76
    ## 673  02336240 2011-05-04 20:15:00   27.00       A  18.5 7.0  8.5   65.30
    ## 674  02337170 2011-05-03 14:15:00 5800.00       A  15.4  NA   NA   59.72
    ## 675  02337170 2011-05-24 01:00:00 2150.00       A  21.6 6.9  8.3   70.88
    ## 676  02203655 2011-05-18 11:45:00    9.20       A  14.2 7.0  8.6   57.56
    ## 677  02336410 2011-05-01 15:45:00   22.00       A  18.7 6.8  8.4   65.66
    ## 678  02336526 2011-05-19 13:45:00    3.80     A e  14.4 7.5  8.9   57.92
    ## 679  02203655 2011-05-31 14:00:00    9.60       A  22.5 7.4  6.6   72.50
    ## 680  02336360 2011-05-30 17:15:00    6.60     A e  25.0 7.0  7.6   77.00
    ## 681  02336313 2011-05-17 22:30:00    1.00     A e  16.8 7.2  8.6   62.24
    ## 682  02336240 2011-05-30 02:30:00   12.00       A  23.7 7.0  6.9   74.66
    ## 683  02337170 2011-05-15 04:45:00 4140.00       A  14.4 6.8  9.9   57.92
    ## 684  02336526 2011-05-26 00:15:00    3.00       A  25.5 9.0 10.9   77.90
    ## 685  02336120 2011-05-11 03:00:00   15.00       A  23.0 7.2  7.3   73.40
    ## 686  02203700 2011-05-21 00:15:00    5.30       A  22.7 6.9  6.2   72.86
    ## 687  02336360 2011-05-08 19:30:00   13.00       A  19.8 7.3  9.0   67.64
    ## 688  02337170 2011-05-31 17:00:00 1270.00       A  24.2 6.9  7.1   75.56
    ## 689  02336120 2011-05-28 14:30:00   29.00       A  21.5 6.8  7.3   70.70
    ## 690  02336410 2011-05-20 02:45:00   15.00     A e  18.3 7.3  8.5   64.94
    ## 691  02337170 2011-05-02 13:15:00 2760.00     A e  15.6 6.9  9.7   60.08
    ## 692  02336313 2011-05-16 20:00:00    2.30     A e  17.8 7.4  9.3   64.04
    ## 693  02336240 2011-05-17 17:15:00   11.00     A e  16.4 7.4 10.0   61.52
    ## 694  02336313 2011-05-06 06:30:00    1.20       A  15.2 7.0  8.1   59.36
    ## 695  02336526 2011-05-01 11:45:00    4.40       A  17.4 6.9  7.3   63.32
    ## 696  02203700 2011-05-25 05:15:00    3.70       A  22.6 6.8  4.3   72.68
    ## 697  02336120 2011-05-02 05:45:00   16.00       A  19.9 7.1  7.6   67.82
    ## 698  02336360 2011-05-06 17:45:00   14.00       A  17.4 7.2  9.0   63.32
    ## 699  02336526 2011-05-27 14:15:00   58.00       A  20.0 6.8  7.9   68.00
    ## 700  02203700 2011-05-07 00:30:00    5.30       A  19.6 7.0  6.2   67.28
    ## 701  02337170 2011-05-07 09:15:00 5990.00       A  14.1 6.9 10.0   57.38
    ## 702  02203700 2011-05-10 05:00:00    5.10       A  21.3 7.3  3.6   70.34
    ## 703  02336240 2011-05-06 00:30:00   14.00       A  16.8 7.2  8.4   62.24
    ## 704  02336120 2011-05-11 09:30:00   15.00       A  21.4 7.1  7.2   70.52
    ## 705  02203655 2011-05-30 00:45:00   11.00       A  24.1 6.6  6.3   75.38
    ## 706  02336300 2011-05-23 22:45:00   21.00       A  25.8 7.5  8.3   78.44
    ## 707  02203655 2011-05-21 02:30:00    8.20       A  20.6 7.0  7.0   69.08
    ## 708  02336360 2011-05-12 12:15:00   11.00       A  21.2 7.0  7.2   70.16
    ## 709  02336360 2011-05-06 14:30:00   14.00       A  15.0 7.1  8.6   59.00
    ## 710  02336120 2011-05-24 23:00:00    9.90       A  25.3 7.2  7.8   77.54
    ## 711  02203700 2011-05-07 01:30:00    5.30     A e  19.0 7.0  6.0   66.20
    ## 712  02336120 2011-05-02 12:45:00   16.00       A  19.0 7.0  7.8   66.20
    ## 713  02337170 2011-05-30 14:45:00 1340.00       A  22.6 6.9  7.2   72.68
    ## 714  02336526 2011-05-08 17:30:00    4.60     A e  19.1 7.4 10.6   66.38
    ## 715  02337170 2011-05-26 14:15:00 1740.00     A e  20.6 7.1  8.4   69.08
    ## 716  02336728 2011-05-22 01:30:00    9.70     A e  22.4 7.2  7.6   72.32
    ## 717  02336120 2011-05-28 08:30:00   37.00     A e  21.5 6.7  7.0   70.70
    ## 718  02336360 2011-05-03 20:30:00   14.00       A  22.1 7.2  8.4   71.78
    ## 719  02336410 2011-05-17 13:15:00   16.00       A  15.4 7.2  8.9   59.72
    ## 720  02336526 2011-05-05 04:45:00    6.70       A  16.4 6.9  8.0   61.52
    ## 721  02336240 2011-05-11 09:00:00   11.00       A  20.9 7.1  7.2   69.62
    ## 722  02203700 2011-05-11 05:45:00    4.60     A e  22.1 7.4  3.5   71.78
    ## 723  02337170 2011-05-21 00:45:00 4700.00       A  16.3 6.8  9.5   61.34
    ## 724  02336526 2011-05-13 04:15:00    3.60       A  24.0 7.7  6.4   75.20
    ## 725  02336410 2011-05-27 03:15:00  160.00       A    NA 6.8  6.3      NA
    ## 726  02203655 2011-05-27 04:00:00  133.00       A  21.3 6.6  7.0   70.34
    ## 727  02203700 2011-05-06 14:15:00    6.10       A  15.2 7.1  7.9   59.36
    ## 728  02203655 2011-05-21 09:45:00    7.80       A  19.1 7.0  6.8   66.38
    ## 729  02203655 2011-05-21 20:45:00    8.50       A  21.1 7.0  7.8   69.98
    ## 730  02337170 2011-05-27 12:45:00 5760.00     A e  20.7 6.5  6.4   69.26
    ## 731  02336120 2011-05-22 13:45:00   11.00       A  20.4 7.2  7.5   68.72
    ## 732  02337170 2011-05-26 23:15:00 1720.00     A e  21.7 7.2  8.6   71.06
    ## 733  02336360 2011-05-27 00:15:00   49.00       A  22.2 6.9  7.5   71.96
    ## 734  02336300 2011-05-19 03:00:00   27.00       A  16.7 7.5  8.4   62.06
    ## 735  02336240 2011-05-02 11:00:00   13.00       A  18.7 7.2  7.6   65.66
    ## 736  02336526 2011-05-05 19:45:00    5.50       A    NA 7.2 10.3      NA
    ## 737  02336300 2011-05-24 23:30:00   20.00     A e  26.1 7.5  7.9   78.98
    ## 738  02337170 2011-05-28 22:45:00 2630.00     A e  21.8 6.8  7.5   71.24
    ## 739  02203655 2011-05-30 06:45:00   10.00       A  23.8 6.7  5.8   74.84
    ## 740  02336240 2011-05-11 05:30:00   11.00       A  21.6 7.1  7.0   70.88
    ## 741  02336360 2011-05-27 01:30:00  209.00       A  22.6 6.7  6.8   72.68
    ## 742  02336410 2011-05-08 00:45:00   22.00       A  18.9 7.1  8.2   66.02
    ## 743  02336360 2011-05-05 09:30:00   18.00     A e  15.7 6.9  8.3   60.26
    ## 744  02203655 2011-05-30 16:45:00   10.00     A e  22.7 6.9  6.8   72.86
    ## 745  02336300 2011-05-16 12:00:00   25.00       A  16.8 7.5  7.8   62.24
    ## 746  02203700 2011-05-12 22:15:00    4.40     A e  26.4 7.2  9.1   79.52
    ## 747  02203700 2011-05-10 07:30:00    4.60       A  20.2 7.3  3.3   68.36
    ## 748  02336313 2011-05-28 09:30:00    0.98       A  20.1 7.3  6.3   68.18
    ## 749  02336313 2011-05-23 05:00:00    0.93       A  22.5 7.1  5.8   72.50
    ## 750  02337170 2011-05-18 00:15:00 3410.00       A  14.9 7.0  9.5   58.82
    ## 751  02336360 2011-05-30 23:30:00    6.60       A  26.5 7.0  7.0   79.70
    ## 752  02336313 2011-05-06 17:15:00    1.20       A  17.9 7.1  9.6   64.22
    ## 753  02203700 2011-05-26 23:00:00    6.40       A  22.2 6.9  6.8   71.96
    ## 754  02336300 2011-05-16 20:00:00   31.00     A e  18.9 7.6  9.3   66.02
    ## 755  02336360 2011-05-13 23:15:00   11.00       A  23.2 7.3  8.3   73.76
    ## 756  02336360 2011-05-11 07:30:00   12.00       A    NA 7.0  6.9      NA
    ## 757  02336410 2011-05-26 23:15:00   17.00     A e  23.9 7.2  7.3   75.02
    ## 758  02336300 2011-05-12 21:15:00   27.00       A  26.4 7.5  8.6   79.52
    ## 759  02336240 2011-06-01 00:15:00   10.00       A  25.7 7.1  7.0   78.26
    ## 760  02203655 2011-05-18 01:15:00    9.20       A  15.9 7.1  8.5   60.62
    ## 761  02336526 2011-05-28 14:15:00    9.50     A e  20.1 7.1  8.0   68.18
    ## 762  02336360 2011-05-16 09:15:00   11.00       A  17.2 7.1  8.1   62.96
    ## 763  02336313 2011-05-05 23:15:00    1.20       A  18.5 7.0  8.0   65.30
    ## 764  02336360 2011-05-17 00:15:00   11.00     A e  17.5 7.3  9.1   63.50
    ## 765  02336300 2011-05-01 20:45:00   32.00       A  22.8 7.3  8.2   73.04
    ## 766  02336410 2011-05-05 22:45:00   28.00       A  17.4 7.1  8.8   63.32
    ## 767  02336240 2011-05-25 02:45:00    7.90       A  23.4 7.1  6.5   74.12
    ## 768  02336410 2011-05-20 21:45:00   14.00       A  21.9  NA  9.3   71.42
    ## 769  02336300 2011-05-03 03:00:00   31.00     A e  21.6  NA  7.0   70.88
    ## 770  02337170 2011-05-11 01:00:00 4120.00       A  20.5 6.8  8.4   68.90
    ## 771  02336728 2011-05-28 18:30:00   33.00     A e  22.8 7.0   NA   73.04
    ## 772  02336240 2011-05-03 04:15:00   12.00     A e  20.3 7.1  7.3   68.54
    ## 773  02336526 2011-05-31 12:45:00    4.80       A  22.5 7.2   NA   72.50
    ## 774  02336313 2011-05-24 17:45:00    0.93     A e  24.9  NA  8.9   76.82
    ## 775  02203700 2011-05-15 21:45:00    4.60       A  18.9 7.1  9.0   66.02
    ## 776  02203700 2011-05-26 04:15:00    3.70       A  23.7 6.8  4.4   74.66
    ## 777  02336120 2011-05-26 00:30:00   11.00       A  25.4 7.2  7.3   77.72
    ## 778  02336120 2011-05-07 13:45:00   17.00       A  15.7 6.9  8.7   60.26
    ## 779  02336240 2011-05-17 14:00:00   12.00       A  15.0 7.3  9.1   59.00
    ## 780  02203655 2011-05-03 01:45:00   11.00       A  21.5 7.1  6.4   70.70
    ## 781  02336240 2011-05-18 19:00:00   10.00       A  17.9  NA 10.4   64.22
    ## 782  02336313 2011-05-01 16:00:00    1.10       A  20.2 7.1  8.4   68.36
    ## 783  02336410 2011-05-20 17:30:00   14.00     A e  19.7 7.4  9.6   67.46
    ## 784  02336240 2011-05-23 12:15:00    8.50       A  20.5 7.2  7.1   68.90
    ## 785  02336526 2011-05-06 02:45:00    5.50       A  17.6 7.1  8.3   63.68
    ## 786  02336360 2011-05-14 05:15:00   11.00       A  21.9 7.0  6.9   71.42
    ## 787  02203700 2011-05-24 03:45:00    3.70       A  23.3 6.8  4.2   73.94
    ## 788  02336313 2011-05-29 16:30:00    0.82       A  23.6 7.4  6.8   74.48
    ## 789  02336120 2011-05-16 21:30:00   13.00     A e  18.0 7.4  9.0   64.40
    ## 790  02336410 2011-05-05 03:45:00   42.00       A  17.6 6.9  8.2   63.68
    ## 791  02203700 2011-05-10 21:00:00    4.90       A  26.4 7.3 10.2   79.52
    ## 792  02203655 2011-05-28 20:30:00   17.00       A  22.4 6.5  7.2   72.32
    ## 793  02336120 2011-05-06 22:00:00   19.00       A  18.8 7.1  8.8   65.84
    ## 794  02203655 2011-05-05 06:30:00   17.00       A    NA 7.1  7.5      NA
    ## 795  02203700 2011-05-01 08:15:00    6.10       A  17.8  NA  6.7   64.04
    ## 796  02336410 2011-05-15 16:45:00   16.00     A e    NA 7.3  8.9      NA
    ## 797  02337170 2011-05-10 21:30:00 4270.00       A  20.9 6.8  8.3   69.62
    ## 798  02336240 2011-05-27 12:15:00 1170.00       A  19.5 6.6  8.6   67.10
    ## 799  02336410 2011-05-30 09:30:00   15.00       A  23.5 7.0  6.6   74.30
    ## 800  02336313 2011-05-31 20:15:00    0.69       A  26.9 7.2  7.0   80.42
    ## 801  02336240 2011-05-12 13:00:00   11.00       A  20.8  NA  7.4   69.44
    ## 802  02336728 2011-05-03 06:45:00   15.00       A  19.9 7.0  7.7   67.82
    ## 803  02336526 2011-05-25 11:30:00    3.10     A e  21.4 7.4  6.1   70.52
    ## 804  02337170 2011-05-08 00:00:00 2640.00       A  15.3 6.9  9.6   59.54
    ## 805  02336240 2011-05-16 00:15:00   10.00       A  18.2 7.3  8.2   64.76
    ## 806  02336120 2011-05-29 16:30:00   17.00       A  22.8 6.9  7.4   73.04
    ## 807  02337170 2011-05-17 17:00:00 2590.00       A  15.8 7.1  9.4   60.44
    ## 808  02336300 2011-05-25 19:15:00   21.00       A  26.4 7.5  8.7   79.52
    ## 809  02336240 2011-05-30 13:45:00   12.00       A  22.4 7.1  7.3   72.32
    ## 810  02336300 2011-05-07 12:00:00   36.00       A  15.2 7.3  8.0   59.36
    ## 811  02337170 2011-05-03 18:30:00 7200.00       A  13.9 6.8 10.3   57.02
    ## 812  02337170 2011-05-22 10:45:00 2280.00       A    NA 6.9  9.6      NA
    ## 813  02337170 2011-05-26 09:15:00 1760.00       A  20.1 7.1  8.5   68.18
    ## 814  02336410 2011-05-20 00:45:00   15.00       A  18.5 7.3  8.9   65.30
    ## 815  02336360 2011-05-30 00:15:00    7.20       A  25.1 7.0  7.0   77.18
    ## 816  02336300 2011-05-24 12:30:00   21.00       A  21.9 7.4  6.8   71.42
    ## 817  02203655 2011-05-04 14:30:00   37.00       A  16.0 7.0  8.1   60.80
    ## 818  02336526 2011-05-19 07:45:00    3.60     A e  15.6 7.7  8.3   60.08
    ## 819  02336240 2011-05-16 02:30:00   10.00       A  17.7 7.3  7.8   63.86
    ## 820  02336526 2011-05-14 00:00:00    3.60     A e  23.8 8.4  9.7   74.84
    ## 821  02336360 2011-05-30 20:45:00    6.60       A  27.4 7.1  7.7   81.32
    ## 822  02336300 2011-05-23 00:30:00   22.00     A e  25.3 7.4  7.5   77.54
    ## 823  02336526 2011-05-03 02:00:00    4.20     A e  23.0 7.2  7.4   73.40
    ## 824  02336728 2011-05-21 08:45:00    9.70       A  18.2 7.1  8.0   64.76
    ## 825  02336728 2011-05-26 17:30:00    7.80       A  23.8 7.2  8.8   74.84
    ## 826  02336526 2011-05-30 21:00:00    4.80     A e    NA 7.7  9.3      NA
    ## 827  02336313 2011-05-21 03:00:00    0.93       A    NA 7.1  6.9      NA
    ## 828  02336240 2011-05-27 21:15:00   62.00       A  21.8 6.9  7.7   71.24
    ## 829  02336120 2011-05-23 01:45:00   11.00       A  24.0 7.2  7.1   75.20
    ## 830  02336526 2011-05-07 11:30:00    4.80       A  14.8 7.1  8.4   58.64
    ## 831  02336300 2011-05-06 20:00:00   38.00       A    NA 7.3  8.6      NA
    ## 832  02336120 2011-05-06 11:00:00   19.00       A  15.1 7.0  8.6   59.18
    ## 833  02336120 2011-05-16 11:00:00   13.00     A e  16.8 7.2  8.1   62.24
    ## 834  02336120 2011-05-24 23:45:00    9.90     A e  25.1 7.1  7.6   77.18
    ## 835  02336410 2011-05-19 15:15:00   15.00       A  15.3 7.3  9.6   59.54
    ## 836  02336526 2011-05-31 16:00:00    4.60       A  23.6 7.3  8.8   74.48
    ## 837  02336410 2011-05-05 11:45:00   34.00       A  15.0 6.9  8.8   59.00
    ## 838  02336360 2011-05-01 09:15:00   14.00     A e  18.3 7.0  7.6   64.94
    ## 839  02336526 2011-05-15 05:15:00    3.60       A  21.3 7.6  6.7   70.34
    ## 840  02336300 2011-05-14 18:15:00   26.00       A  22.6 7.6  8.6   72.68
    ## 841  02336410 2011-05-18 02:00:00   16.00       A  15.6 7.3  9.1   60.08
    ## 842  02336313 2011-05-12 02:30:00    0.93       A  23.8 7.2  6.0   74.84
    ## 843  02203655 2011-05-23 18:15:00    8.20       A    NA 7.0  7.3      NA
    ## 844  02336526 2011-05-12 23:45:00    3.60       A  26.0 8.4  9.5   78.80
    ## 845  02336410 2011-05-21 22:30:00   14.00     A e  23.3 7.4  8.4   73.94
    ## 846  02336300 2011-05-01 21:00:00   32.00     A e  22.8 7.3  8.2   73.04
    ## 847  02336300 2011-05-18 23:30:00   27.00       A  18.0 7.6  9.3   64.40
    ## 848  02336410 2011-05-22 10:00:00   14.00       A  20.8 7.2  7.2   69.44
    ## 849  02336313 2011-05-17 04:45:00    1.10       A    NA 7.2  7.2      NA
    ## 850  02203700 2011-05-22 18:15:00    3.90       A  24.4 7.0  8.5   75.92
    ## 851  02336300 2011-05-19 07:15:00   26.00       A  15.8 7.4  8.2   60.44
    ## 852  02336300 2011-05-21 02:00:00   25.00       A    NA 7.4  7.7      NA
    ## 853  02336240 2011-05-21 03:30:00    9.20       A  19.9 7.2  7.3   67.82
    ## 854  02336526 2011-05-15 20:00:00    3.60     A e  18.9 7.7 11.1   66.02
    ## 855  02336410 2011-05-28 15:00:00   28.00       A  21.5 7.0  7.4   70.70
    ## 856  02337170 2011-05-28 03:30:00 4330.00       A  20.5 6.6  7.3   68.90
    ## 857  02336728 2011-05-03 13:15:00   15.00       A  20.3 7.0  7.8   68.54
    ## 858  02336410 2011-05-31 10:45:00   13.00       A  23.6 7.0  6.4   74.48
    ## 859  02336526 2011-05-26 08:15:00    3.10       A  23.2 7.5  6.0   73.76
    ## 860  02336120 2011-05-01 08:00:00   17.00     A e  18.6 7.1  7.8   65.48
    ## 861  02336300 2011-05-01 13:00:00   31.00       A  18.2 7.2  7.4   64.76
    ## 862  02336360 2011-05-16 16:30:00   11.00       A  17.3 7.3  9.6   63.14
    ## 863  02336410 2011-05-09 04:00:00   21.00       A  19.9 7.1  7.6   67.82
    ## 864  02336300 2011-05-01 12:30:00   31.00       A  18.2 7.2  7.3   64.76
    ## 865  02336120 2011-05-04 17:45:00   57.00       A  17.7 6.8  8.5   63.86
    ## 866  02336313 2011-05-05 09:15:00    1.40       A  13.8 6.9  8.0   56.84
    ## 867  02203700 2011-05-25 03:30:00    3.70       A  23.4 6.8  4.4   74.12
    ## 868  02336120 2011-05-19 14:00:00   12.00     A e  15.1 7.3  8.9   59.18
    ## 869  02336120 2011-05-10 08:30:00   15.00       A  20.3 7.1  7.5   68.54
    ## 870  02336360 2011-05-08 03:45:00   13.00     A e  18.4 7.1  8.0   65.12
    ## 871  02336728 2011-05-16 13:30:00   11.00       A  16.7 7.1  8.6   62.06
    ## 872  02336240 2011-05-15 23:00:00   10.00       A  18.5 7.3  8.5   65.30
    ## 873  02336526 2011-05-16 00:45:00    3.80       A  18.4 8.0  9.7   65.12
    ## 874  02336120 2011-05-08 00:45:00   17.00       A  19.2 7.1  8.4   66.56
    ## 875  02336728 2011-05-04 04:45:00  369.00       A  18.3 6.7   NA   64.94
    ## 876  02336728 2011-05-25 13:45:00    8.20       A  20.8 7.1  7.8   69.44
    ## 877  02336728 2011-05-23 15:30:00    8.90       A  22.1 7.2  8.5   71.78
    ## 878  02336313 2011-05-08 01:00:00    1.00       A  19.7 7.2  7.5   67.46
    ## 879  02336313 2011-05-13 05:15:00    0.98       A  22.5 7.2  6.1   72.50
    ## 880  02203655 2011-05-07 00:30:00   12.00     A e  18.3 7.2  7.4   64.94
    ## 881  02336313 2011-05-30 01:15:00    0.73       A  25.5 7.3  5.6   77.90
    ## 882  02203700 2011-05-20 08:30:00    4.00       A  17.3 6.8  5.1   63.14
    ## 883  02336410 2011-05-19 02:00:00   15.00     A e  16.3 7.3  9.1   61.34
    ## 884  02336120 2011-05-08 03:30:00   17.00     A e  18.4 7.1  8.2   65.12
    ## 885  02203700 2011-05-17 12:00:00    4.40     A e  14.7  NA  5.7   58.46
    ## 886  02336120 2011-05-22 11:00:00   11.00       A  20.2 7.2  7.2   68.36
    ## 887  02336313 2011-05-24 23:15:00    0.87     A e  24.8 7.2  7.0   76.64
    ## 888  02336526 2011-05-04 01:00:00  255.00       A  19.0 6.8  8.0   66.20
    ## 889  02203655 2011-06-01 02:30:00    8.80       A  25.0 7.0  6.0   77.00
    ## 890  02336300 2011-05-12 05:30:00   30.00       A  23.2 7.4  6.6   73.76
    ## 891  02336313 2011-05-29 00:45:00    0.77       A    NA 7.4  5.9      NA
    ## 892  02336313 2011-05-31 18:30:00    0.77       A  26.4 7.2  6.8   79.52
    ## 893  02336120 2011-05-09 20:00:00   16.00     A e  21.9 7.3  8.9   71.42
    ## 894  02336360 2011-05-22 23:00:00    9.80       A  24.8 7.4  8.0   76.64
    ## 895  02337170 2011-05-02 10:00:00 3060.00       A  15.4 6.9  9.9   59.72
    ## 896  02336360 2011-05-04 01:45:00  177.00       A  18.7 6.7  8.0   65.66
    ## 897  02336526 2011-05-19 00:45:00    3.80       A    NA 8.9 11.7      NA
    ## 898  02336313 2011-05-14 13:15:00    1.00     A e  20.4 7.2  7.2   68.72
    ## 899  02336410 2011-05-27 00:00:00   36.00     A e  23.2 7.2   NA   73.76
    ## 900  02336410 2011-05-18 20:45:00   15.00       A  17.2 7.5 10.3   62.96
    ## 901  02336526 2011-05-23 09:30:00    3.60     A e  21.9 7.5  6.1   71.42
    ## 902  02336526 2011-05-26 17:45:00    2.80       A  23.7 7.9  9.8   74.66
    ## 903  02336410 2011-05-07 21:15:00   22.00       A  19.2 7.2  8.8   66.56
    ## 904  02336240 2011-05-18 17:30:00   10.00       A  17.0 7.4 10.2   62.60
    ## 905  02336526 2011-05-24 04:00:00    5.70       A  23.8 8.3  7.2   74.84
    ## 906  02336313 2011-05-18 06:00:00    1.00       A  14.7 7.1  7.4   58.46
    ## 907  02336240 2011-05-24 07:45:00    8.20     A e  21.7 7.2  6.8   71.06
    ## 908  02336313 2011-05-09 19:15:00    1.00       A  23.5  NA  8.9   74.30
    ## 909  02337170 2011-05-31 17:30:00 1270.00       A  24.4 6.9  7.2   75.92
    ## 910  02337170 2011-05-04 07:30:00 6340.00       A  15.2 6.8  9.7   59.36
    ## 911  02203655 2011-05-31 18:30:00    9.60       A  23.9 7.2  7.0   75.02
    ## 912  02203700 2011-05-14 18:30:00    4.60       A  22.8 7.3 10.7   73.04
    ## 913  02336360 2011-05-19 13:45:00   10.00       A  14.8 7.1  9.2   58.64
    ## 914  02336728 2011-05-04 21:30:00   38.00       A  18.6 6.9  8.5   65.48
    ## 915  02336120 2011-05-17 05:45:00   13.00       A  16.4 7.2  8.3   61.52
    ## 916  02336240 2011-05-27 11:00:00 1380.00       A  19.5 6.6  8.6   67.10
    ## 917  02336313 2011-05-29 17:15:00    0.82       A  24.3 7.4  7.2   75.74
    ## 918  02336410 2011-05-03 01:15:00   21.00       A  21.6 6.8  7.4   70.88
    ## 919  02336410 2011-05-20 16:00:00   14.00       A  18.2  NA  9.1   64.76
    ## 920  02336360 2011-05-13 16:30:00   11.00       A  22.4 7.2  8.7   72.32
    ## 921  02336526 2011-05-21 22:00:00    3.50       A  23.9 9.0 12.1   75.02
    ## 922  02336300 2011-05-24 01:00:00   21.00       A  24.9 7.4  7.3   76.82
    ## 923  02336240 2011-05-27 13:00:00  917.00       A  19.6 6.6  8.6   67.28
    ## 924  02336526 2011-05-11 13:00:00    4.00     A e  20.6 7.0  7.0   69.08
    ## 925  02336120 2011-05-12 06:45:00   14.00       A  22.3 7.2  7.1   72.14
    ## 926  02336313 2011-05-10 02:15:00    0.98     A e  22.5 7.2  6.7   72.50
    ## 927  02203700 2011-05-22 12:15:00    3.90       A  19.3 6.8  4.8   66.74
    ## 928  02203655 2011-05-03 23:45:00  102.00       A  20.6 7.1  6.7   69.08
    ## 929  02203655 2011-05-06 08:30:00   12.00       A  15.5 7.2  7.9   59.90
    ## 930  02336360 2011-05-29 05:45:00    8.70       A  23.1 6.9  6.4   73.58
    ## 931  02203700 2011-05-12 21:30:00    4.40       A  26.7 7.3 10.0   80.06
    ## 932  02337170 2011-05-04 18:00:00 6370.00       A  16.3 6.6  8.5   61.34
    ## 933  02336526 2011-05-07 15:45:00    4.80       A  15.9 7.2  9.9   60.62
    ## 934  02337170 2011-06-01 02:45:00 1260.00     A e  26.2 6.9  7.1   79.16
    ## 935  02336240 2011-05-31 18:00:00   11.00       A  26.1 7.1  8.1   78.98
    ## 936  02203700 2011-05-13 11:30:00    4.40       A  19.9  NA  4.5   67.82
    ## 937  02203700 2011-05-15 09:00:00    4.20       A  18.8 6.9  4.8   65.84
    ## 938  02336240 2011-05-10 07:00:00   11.00       A  20.1 7.2  7.4   68.18
    ## 939  02336120 2011-05-13 12:45:00   13.00       A  21.3 7.1  7.3   70.34
    ## 940  02337170 2011-05-27 06:00:00 2210.00       A  20.7 6.8  7.8   69.26
    ## 941  02336300 2011-05-18 22:15:00   27.00       A  18.3 7.6  9.6   64.94
    ## 942  02336120 2011-05-31 23:45:00   12.00       A  26.8 7.0  7.2   80.24
    ## 943  02336360 2011-05-07 03:00:00   14.00     A e  17.7 7.1  8.1   63.86
    ## 944  02336410 2011-05-14 22:30:00   16.00       A  22.5 7.4  8.1   72.50
    ## 945  02336410 2011-05-03 08:15:00   21.00       A  20.7 6.8  6.9   69.26
    ## 946  02336728 2011-05-28 18:45:00   33.00       A  22.9 7.0   NA   73.22
    ## 947  02336360 2011-05-07 04:15:00   14.00       A  17.3 7.1  8.1   63.14
    ## 948  02203700 2011-05-10 20:00:00    4.90       A  26.1 7.3 10.7   78.98
    ## 949  02336360 2011-05-29 17:45:00    7.80       A  24.4 7.0  7.6   75.92
    ## 950  02336526 2011-05-22 17:00:00    3.60       A  22.0 8.0 10.2   71.60
    ## 951  02336120 2011-05-14 08:30:00   13.00       A  21.1 7.2  7.2   69.98
    ## 952  02203655 2011-05-18 07:15:00    8.80       A  15.1 7.0  8.1   59.18
    ## 953  02337170 2011-05-18 21:45:00 4580.00     A e  13.6 6.8   NA   56.48
    ## 954  02336360 2011-05-15 08:15:00   11.00       A  20.0 7.1  7.3   68.00
    ## 955  02336240 2011-05-28 19:00:00   20.00       A  23.7 7.0  7.5   74.66
    ## 956  02336300 2011-05-16 23:00:00   29.00     A e  18.4 7.6  8.6   65.12
    ## 957  02336240 2011-05-11 09:30:00   11.00       A  20.8 7.1  7.1   69.44
    ## 958  02336410 2011-05-07 15:45:00   22.00       A  16.4 7.0  9.0   61.52
    ## 959  02336526 2011-05-11 15:45:00    4.00     A e  21.5 7.2  9.0   70.70
    ## 960  02336120 2011-05-21 10:45:00   12.00       A  18.9 7.1  7.5   66.02
    ## 961  02337170 2011-05-12 03:00:00 4710.00       A  17.4 6.8  9.2   63.32
    ## 962  02336526 2011-05-26 18:00:00    2.80       A  23.8 8.0 10.0   74.84
    ## 963  02203655 2011-05-31 06:15:00    8.80       A  24.4 7.2  6.1   75.92
    ## 964  02336526 2011-05-17 12:00:00    4.00       A  15.1 7.2  7.9   59.18
    ## 965  02336240 2011-05-27 06:00:00  247.00     A e  21.1 6.7  7.7   69.98
    ## 966  02336120 2011-05-14 09:00:00   13.00       A  21.1 7.2  7.2   69.98
    ## 967  02336300 2011-05-16 20:30:00   30.00       A  18.7 7.6  9.1   65.66
    ## 968  02336313 2011-05-21 22:00:00    0.98     A e    NA 7.2  7.6      NA
    ## 969  02203700 2011-05-11 12:15:00    4.60       A  20.0  NA  4.6   68.00
    ## 970  02336410 2011-05-26 06:45:00   11.00     A e  23.5 7.2  6.7   74.30
    ## 971  02336526 2011-05-21 11:45:00    3.60       A  19.0 7.5  6.9   66.20
    ## 972  02336120 2011-05-31 02:15:00   13.00       A  25.6 7.0  6.6   78.08
    ## 973  02336526 2011-05-19 03:45:00    3.60     A e  16.8 8.5  9.4   62.24
    ## 974  02336313 2011-05-09 23:45:00    0.98     A e  23.5 7.2  7.3   74.30
    ## 975  02336313 2011-05-24 02:30:00    0.87       A  23.6 7.1  6.0   74.48
    ## 976  02337170 2011-05-23 17:30:00 1600.00       A  21.1 7.1  8.4   69.98
    ## 977  02336360 2011-05-15 05:15:00   11.00       A  20.7 7.1  7.3   69.26
    ## 978  02336360 2011-05-20 02:30:00   10.00       A  18.5  NA  8.4   65.30
    ## 979  02336526 2011-05-04 02:30:00  437.00       A  18.0 6.6  8.2   64.40
    ## 980  02336728 2011-05-20 21:00:00   10.00     A e  22.8 7.3   NA   73.04
    ## 981  02336728 2011-05-23 11:00:00    8.90       A  20.3 7.1  7.5   68.54
    ## 982  02336240 2011-05-08 14:00:00   12.00       A  16.7 7.2  8.4   62.06
    ## 983  02336410 2011-05-18 04:00:00   16.00       A  15.4 7.2  9.0   59.72
    ## 984  02337170 2011-05-31 14:15:00 1280.00       A  23.9 6.9  6.8   75.02
    ## 985  02336313 2011-05-07 00:30:00    1.10     A e  18.7 7.2  7.8   65.66
    ## 986  02336240 2011-05-14 01:15:00   10.00       A  22.6 7.2  7.0   72.68
    ## 987  02203655 2011-05-18 06:30:00    9.20       A  15.3 7.0  8.2   59.54
    ## 988  02336313 2011-05-25 00:15:00    0.87       A  24.6 7.2  6.4   76.28
    ## 989  02203655 2011-05-02 07:30:00   11.00       A  20.0 7.1  6.4   68.00
    ## 990  02336120 2011-05-12 01:15:00   15.00       A  24.2 7.2  7.4   75.56
    ## 991  02336526 2011-05-26 10:00:00    3.00     A e  22.8 7.4  5.8   73.04
    ## 992  02336728 2011-05-20 15:45:00   10.00       A  18.8 7.2  9.2   65.84
    ## 993  02203655 2011-05-24 01:30:00    8.20       A  23.1 7.0  6.4   73.58
    ## 994  02336120 2011-05-03 07:00:00   16.00       A  20.4 7.1  7.5   68.72
    ## 995  02203700 2011-05-16 23:15:00    7.90       A  18.8 7.1   NA   65.84
    ## 996  02336120 2011-05-18 02:00:00   14.00     A e  15.8 7.3  8.8   60.44
    ## 997  02336240 2011-06-01 00:45:00   10.00       A  25.5 7.0  6.8   77.90
    ## 998  02336300 2011-05-10 09:30:00   31.00       A  20.6 7.3  7.0   69.08
    ## 999  02336313 2011-05-22 06:30:00    0.93       A  20.9 7.1  6.3   69.62
    ## 1000 02203700 2011-05-24 23:00:00    3.70     A e  25.4 7.0  7.2   77.72
    ## 1001 02336526 2011-05-26 02:45:00    5.20     A e  24.8 8.5  7.7   76.64
    ## 1002 02336526 2011-05-05 03:45:00    6.90       A  16.9 6.9  8.0   62.42
    ## 1003 02336300 2011-05-25 02:30:00   21.00     A e  24.7 7.4  6.8   76.46
    ## 1004 02336526 2011-05-08 15:00:00    4.60     A e  16.9 7.2  9.4   62.42
    ## 1005 02203655 2011-05-02 02:45:00   11.00     A e  21.0 7.1  6.3   69.80
    ## 1006 02336410 2011-05-06 07:30:00   26.00       A  16.1 7.0  8.5   60.98
    ## 1007 02336240 2011-05-21 07:45:00    8.90       A  18.7 7.2  7.5   65.66
    ## 1008 02203700 2011-05-16 11:00:00    4.40       A  16.3 6.9  5.2   61.34
    ## 1009 02336313 2011-05-09 22:45:00    0.98     A e  23.7 7.2   NA   74.66
    ## 1010 02336360 2011-05-25 04:45:00    9.10       A  23.1 7.1  6.6   73.58
    ## 1011 02336410 2011-05-13 00:30:00   17.00       A  24.1 7.2  7.4   75.38
    ## 1012 02336240 2011-05-01 10:15:00   13.00       A  17.6 7.1  7.6   63.68
    ## 1013 02336360 2011-05-12 01:15:00   11.00       A  24.1 7.1  7.2   75.38
    ## 1014 02336526 2011-05-19 04:45:00    3.60       A  16.5 8.2  8.9   61.70
    ## 1015 02336526 2011-05-20 19:30:00    3.50       A  21.5 8.6 12.2   70.70
    ## 1016 02336300 2011-05-13 04:45:00   27.00     A e  23.3 7.4  6.6   73.94
    ## 1017 02336313 2011-05-14 09:30:00    1.00       A  20.6 7.2  6.6   69.08
    ## 1018 02336410 2011-06-01 02:45:00   12.00     A e  25.6 7.1  6.4   78.08
    ## 1019 02203655 2011-05-17 06:15:00   10.00       A  16.6 7.1  8.1   61.88
    ## 1020 02336240 2011-05-09 18:45:00   12.00       A  22.8 7.3  9.1   73.04
    ## 1021 02336410 2011-05-29 17:00:00   17.00     A e  23.6 7.1  7.5   74.48
    ## 1022 02336728 2011-05-28 14:30:00   36.00       A  20.5 6.9  7.8   68.90
    ## 1023 02336526 2011-05-03 15:30:00    4.20       A  20.4 7.1  8.3   68.72
    ## 1024 02336360 2011-05-04 03:45:00  485.00       A  18.9 6.8  7.8   66.02
    ## 1025 02336410 2011-05-10 21:45:00   19.00       A  24.0 7.3  8.1   75.20
    ## 1026 02336526 2011-05-11 20:00:00    4.00     A e  25.5 8.0 10.9   77.90
    ## 1027 02336120 2011-05-10 22:45:00   16.00     A e  24.0 7.3   NA   75.20
    ## 1028 02336300 2011-05-23 04:45:00   23.00       A  23.5 7.3  6.6   74.30
    ## 1029 02336120 2011-05-11 15:15:00   15.00     A e  21.6 7.3  7.9   70.88
    ## 1030 02337170 2011-05-15 03:15:00 4590.00       A  14.4 6.8  9.9   57.92
    ## 1031 02336410 2011-05-02 04:15:00   22.00     A e  20.5 6.8  7.2   68.90
    ## 1032 02336313 2011-05-12 18:30:00    1.00       A  25.5 7.3  8.9   77.90
    ## 1033 02336410 2011-05-09 22:45:00   19.00     A e  22.0 7.2  8.1   71.60
    ## 1034 02336120 2011-05-24 17:15:00   10.00       A  22.9 7.2  7.9   73.22
    ## 1035 02336240 2011-05-22 06:15:00    8.90       A  20.6 7.2  7.1   69.08
    ## 1036 02336410 2011-05-23 03:30:00   13.00     A e  23.2 7.2  6.9   73.76
    ## 1037 02336120 2011-05-05 03:00:00   33.00     A e  17.1 6.8  8.3   62.78
    ## 1038 02336410 2011-05-25 21:45:00   11.00       A  25.8 7.4  8.0   78.44
    ## 1039 02336360 2011-05-17 22:45:00   10.00     A e  16.2 7.4 10.1   61.16
    ## 1040 02336120 2011-05-24 12:45:00   11.00       A  21.6 7.1  7.1   70.88
    ## 1041 02336728 2011-05-22 01:15:00    9.70       A  22.6 7.2  7.6   72.68
    ## 1042 02336526 2011-05-15 09:45:00    3.60       A  19.6 7.2  6.6   67.28
    ## 1043 02336360 2011-05-15 20:30:00   10.00     A e  19.2 7.4  9.4   66.56
    ## 1044 02337170 2011-05-28 07:15:00 3220.00       A  20.4 6.6  7.3   68.72
    ## 1045 02336526 2011-05-17 02:00:00    7.70     A e  17.8 8.1  9.2   64.04
    ## 1046 02336526 2011-05-07 09:00:00    4.80     A e  15.7 7.1   NA   60.26
    ## 1047 02336360 2011-05-13 21:15:00   11.00       A  23.8 7.4  8.9   74.84
    ## 1048 02203655 2011-05-01 09:15:00   12.00     A e  18.2 7.1  6.9   64.76
    ## 1049 02336120 2011-05-13 20:30:00   13.00     A e  23.8 7.3  8.6   74.84
    ## 1050 02336313 2011-05-22 16:00:00    1.10     A e  22.8 7.3  9.0   73.04
    ## 1051 02336410 2011-05-10 08:30:00   19.00       A  20.9 7.0  7.3   69.62
    ## 1052 02336526 2011-05-17 18:15:00    3.80       A  16.4 7.6 11.6   61.52
    ## 1053 02203700 2011-05-05 14:45:00   21.00       A  17.1 6.6  7.2   62.78
    ## 1054 02337170 2011-05-23 05:30:00 1410.00       A  20.0 6.9  8.4   68.00
    ## 1055 02336526 2011-05-02 18:45:00    4.20       A  22.0 7.2  9.8   71.60
    ## 1056 02336313 2011-05-08 14:45:00    1.10     A e  18.1 7.2  9.1   64.58
    ## 1057 02336360 2011-05-28 12:30:00   12.00     A e  21.2 6.8   NA   70.16
    ## 1058 02336728 2011-05-28 21:30:00   29.00       A  23.5 7.0  7.6   74.30
    ## 1059 02203655 2011-05-20 13:30:00    8.50       A  16.8 7.0  8.1   62.24
    ## 1060 02336240 2011-05-06 11:45:00   14.00     A e  14.2 7.2  8.6   57.56
    ## 1061 02336410 2011-05-12 08:45:00   17.00       A  22.3 7.0  7.0   72.14
    ## 1062 02203700 2011-05-15 04:00:00    4.20       A  20.8 6.8   NA   69.44
    ## 1063 02336240 2011-05-29 15:30:00   14.00       A  22.4 7.0  7.5   72.32
    ## 1064 02203655 2011-05-26 17:30:00    7.50       A  23.0 7.0  6.7   73.40
    ## 1065 02336240 2011-05-29 20:30:00   13.00       A  25.4 7.0  7.3   77.72
    ## 1066 02203655 2011-05-20 16:15:00    8.50       A  18.0 7.0  8.6   64.40
    ## 1067 02336300 2011-05-16 21:45:00   29.00       A  18.8 7.6  9.0   65.84
    ## 1068 02336120 2011-05-18 13:00:00   13.00       A  14.0 7.3  8.9   57.20
    ## 1069 02336360 2011-05-28 12:45:00   12.00     A e  21.2 6.8  7.0   70.16
    ## 1070 02337170 2011-05-23 23:00:00 2180.00     A e  22.2 7.1  8.4   71.96
    ## 1071 02336526 2011-05-13 23:00:00    3.60     A e  24.0 8.5 10.6   75.20
    ## 1072 02336120 2011-05-24 02:00:00   11.00       A  23.9 7.1  7.1   75.02
    ## 1073 02203700 2011-05-18 07:15:00    4.40       A  14.4 6.8  5.3   57.92
    ## 1074 02337170 2011-05-03 01:30:00 4600.00       A  15.8 6.8  9.9   60.44
    ## 1075 02336526 2011-05-27 19:15:00   26.00     A e  22.6 6.9  7.8   72.68
    ## 1076 02203700 2011-05-01 08:00:00    6.40       A  17.9 7.0  6.7   64.22
    ## 1077 02336410 2011-05-05 13:30:00   33.00       A  14.8 7.0  8.9   58.64
    ## 1078 02337170 2011-05-14 02:45:00 5380.00       A  14.2 6.8 10.0   57.56
    ## 1079 02336360 2011-05-09 07:30:00   12.00       A    NA 7.1  7.8      NA
    ## 1080 02337170 2011-05-12 05:00:00 4420.00       A  16.6 6.8  9.4   61.88
    ## 1081 02336526 2011-05-22 16:15:00    3.60       A  21.4 7.8  9.4   70.52
    ## 1082 02336410 2011-05-12 15:45:00   17.00       A  22.3 7.2  8.0   72.14
    ## 1083 02336120 2011-05-04 17:30:00   58.00       A  17.6 6.8  8.5   63.68
    ## 1084 02336240 2011-05-24 07:30:00    8.20       A  21.8  NA  6.8   71.24
    ## 1085 02336410 2011-05-12 10:30:00   17.00       A  22.0 7.1  7.1   71.60
    ## 1086 02336120 2011-05-21 04:15:00   12.00       A  20.4 6.8  7.5   68.72
    ## 1087 02336526 2011-05-06 20:15:00    5.20       A  19.3 7.4 10.5   66.74
    ## 1088 02336120 2011-05-17 18:30:00   14.00       A  16.2 7.3  9.3   61.16
    ## 1089 02203700 2011-05-09 14:45:00    5.10       A  19.4 7.2  7.6   66.92
    ## 1090 02336240 2011-05-03 01:30:00   13.00     A e  21.0 7.1  7.3   69.80
    ## 1091 02336526 2011-05-03 00:15:00    4.20     A e  23.7 7.4  8.6   74.66
    ## 1092 02336120 2011-05-05 11:15:00   26.00     A e  14.9 6.9  8.7   58.82
    ## 1093 02336240 2011-05-14 04:45:00   10.00     A e  21.6 7.2  7.0   70.88
    ## 1094 02336120 2011-05-11 23:00:00   15.00       A  24.9 7.3  8.2   76.82
    ## 1095 02336240 2011-05-07 11:30:00   13.00       A  15.0 7.2  8.5   59.00
    ## 1096 02336240 2011-05-20 09:15:00    9.50       A  16.6 7.2  8.0   61.88
    ## 1097 02203700 2011-05-09 13:45:00    4.90       A  18.5 7.2  6.6   65.30
    ## 1098 02336526 2011-05-30 21:30:00    4.60     A e  27.1 7.7  9.2   80.78
    ## 1099 02336120 2011-05-09 04:15:00   16.00       A  19.4 7.1  7.7   66.92
    ## 1100 02336410 2011-05-27 12:15:00  370.00       A  20.9 6.7  7.0   69.62
    ## 1101 02336360 2011-05-03 18:45:00   13.00       A  22.4 7.2  8.7   72.32
    ## 1102 02336526 2011-05-16 15:15:00    3.80       A  16.5 7.2  8.9   61.70
    ## 1103 02336313 2011-05-10 04:45:00    1.10       A  21.4 7.2  6.6   70.52
    ## 1104 02336313 2011-05-08 05:30:00    1.00       A  17.6 7.2  7.5   63.68
    ## 1105 02336313 2011-05-30 05:00:00    0.73       A  24.1 7.5  5.6   75.38
    ## 1106 02203655 2011-05-25 03:15:00    7.20       A  23.0 6.9  6.0   73.40
    ## 1107 02336526 2011-05-28 10:15:00   11.00     A e  20.1 7.0  7.6   68.18
    ## 1108 02336728 2011-05-13 16:30:00   12.00       A  23.1 7.2  8.6   73.58
    ## 1109 02336300 2011-05-21 20:00:00   24.00       A  24.6 7.5  9.2   76.28
    ## 1110 02336410 2011-05-22 13:30:00   14.00     A e  20.6 7.2  7.7   69.08
    ## 1111 02336313 2011-05-10 22:30:00    0.98       A  24.9 7.2  7.3   76.82
    ## 1112 02336300 2011-05-13 22:15:00   27.00       A  24.4 7.6  8.3   75.92
    ## 1113 02336410 2011-05-03 15:00:00   20.00       A  20.4 6.8  7.6   68.72
    ## 1114 02336313 2011-05-29 21:30:00    0.77       A  26.0 7.3  6.3   78.80
    ## 1115 02203700 2011-05-18 12:30:00    4.20       A  13.5 6.8  5.9   56.30
    ## 1116 02203655 2011-05-01 23:00:00   11.00       A  20.8 7.2  6.8   69.44
    ## 1117 02203655 2011-05-31 20:45:00    9.20       A  24.4 7.1  6.8   75.92
    ## 1118 02336526 2011-05-17 21:45:00    3.80       A  16.4 8.1 12.0   61.52
    ## 1119 02336120 2011-05-10 07:30:00   15.00       A  20.4 7.1  7.5   68.72
    ## 1120 02336728 2011-05-27 09:00:00  645.00     A e  20.9 6.6  7.3   69.62
    ## 1121 02336300 2011-05-07 22:00:00   35.00       A  20.3 7.2  8.4   68.54
    ## 1122 02203655 2011-05-23 07:45:00    7.50       A  22.0 6.9  5.9   71.60
    ## 1123 02337170 2011-05-20 13:00:00 2520.00     A e  14.5 7.0 10.0   58.10
    ## 1124 02336120 2011-05-30 03:45:00   15.00       A  24.6 6.9  6.7   76.28
    ## 1125 02336360 2011-05-01 14:30:00   14.00       A    NA 7.1  8.2      NA
    ## 1126 02336120 2011-05-27 10:00:00 1010.00       A  20.4 6.3  7.5   68.72
    ## 1127 02337170 2011-05-26 18:00:00 1730.00       A  21.5 7.2  8.6   70.70
    ## 1128 02336120 2011-05-07 06:30:00   17.00       A  16.7 7.1  8.3   62.06
    ## 1129 02203700 2011-05-04 23:30:00   24.00       A  18.6 6.7  7.0   65.48
    ## 1130 02336313 2011-05-23 02:00:00    0.87     A e  23.8 7.2  6.0   74.84
    ## 1131 02336526 2011-05-12 04:00:00    3.60       A  24.3 7.6  6.4   75.74
    ## 1132 02336360 2011-05-06 08:00:00   15.00       A  15.8 7.0  8.1   60.44
    ## 1133 02336526 2011-05-24 00:15:00    3.50       A  24.8 9.1 10.9   76.64
    ## 1134 02336120 2011-05-04 13:15:00   93.00     A e  16.4 6.6  8.3   61.52
    ## 1135 02336120 2011-06-01 02:30:00   12.00       A  26.0 7.0  6.7   78.80
    ## 1136 02336300 2011-05-07 03:00:00   38.00     A e  17.4 7.3  8.0   63.32
    ## 1137 02336300 2011-05-16 00:00:00   26.00       A  18.6 7.6  8.2   65.48
    ## 1138 02336410 2011-05-22 12:30:00   14.00       A  20.5 7.2  7.3   68.90
    ## 1139 02337170 2011-05-14 06:45:00 4290.00       A  14.7 6.8   NA   58.46
    ## 1140 02203700 2011-05-24 07:45:00    3.70     A e  21.6 6.8  4.3   70.88
    ## 1141 02336240 2011-05-28 01:30:00   40.00       A  21.8 6.9  7.4   71.24
    ## 1142 02336240 2011-05-12 07:45:00   10.00       A  21.4 7.1  7.0   70.52
    ## 1143 02203700 2011-05-16 08:15:00    4.20       A  16.8 6.9  4.8   62.24
    ## 1144 02336360 2011-05-25 11:30:00    8.70       A  21.5 7.1  6.7   70.70
    ## 1145 02336120 2011-05-19 23:45:00   12.00     A e  19.7 7.3  8.9   67.46
    ## 1146 02203700 2011-05-19 05:30:00    4.20       A  15.8 6.8  5.3   60.44
    ## 1147 02336120 2011-05-14 18:00:00   13.00       A  21.5 7.3  8.3   70.70
    ## 1148 02336360 2011-05-11 05:00:00   12.00     A e  22.6 7.0  6.9   72.68
    ## 1149 02336300 2011-05-15 11:15:00   26.00       A  19.2 7.4  7.1   66.56
    ## 1150 02336240 2011-05-06 07:00:00   14.00     A e  15.1 7.2  8.4   59.18
    ## 1151 02337170 2011-05-16 03:30:00 1500.00       A  16.0 6.9  8.9   60.80
    ## 1152 02336313 2011-05-07 21:30:00    1.00       A  20.8 7.3  8.3   69.44
    ## 1153 02337170 2011-05-16 07:00:00 1380.00       A  16.1 6.9  8.8   60.98
    ## 1154 02336240 2011-05-21 15:30:00    9.20       A  19.7 7.3  9.0   67.46
    ## 1155 02336313 2011-05-08 04:00:00    1.00     A e  18.3 7.2   NA   64.94
    ## 1156 02336410 2011-05-21 19:00:00   14.00       A  22.8 7.5  9.3   73.04
    ## 1157 02336120 2011-05-21 05:00:00   12.00       A  20.2 6.7  7.5   68.36
    ## 1158 02336313 2011-05-19 05:30:00    0.98       A  15.7 7.2  7.2   60.26
    ## 1159 02203655 2011-05-26 14:30:00    6.80       A  22.0 6.9  5.8   71.60
    ## 1160 02336526 2011-05-13 20:30:00    3.60       A  24.2 8.2 11.5   75.56
    ## 1161 02336526 2011-05-19 11:00:00    3.60     A e  14.6 7.5  8.1   58.28
    ## 1162 02336728 2011-05-28 07:45:00   45.00       A  21.4 6.8  7.5   70.52
    ## 1163 02336728 2011-05-01 20:15:00   16.00       A  22.0 7.1  8.5   71.60
    ## 1164 02336313 2011-05-31 04:00:00    0.69       A  24.7 7.4  5.5   76.46
    ## 1165 02336728 2011-05-13 13:30:00   12.00       A  21.2 7.1  7.7   70.16
    ## 1166 02336526 2011-05-10 23:15:00    5.90       A  26.0 8.3  9.2   78.80
    ## 1167 02336120 2011-05-12 08:15:00   14.00       A  22.0 7.1  7.1   71.60
    ## 1168 02336240 2011-05-10 03:00:00   11.00       A  21.0 7.2  7.3   69.80
    ## 1169 02336240 2011-05-23 23:15:00    8.20       A  24.1 7.3  7.9   75.38
    ## 1170 02336120 2011-05-10 21:30:00   16.00       A  24.2 7.3  8.6   75.56
    ## 1171 02336360 2011-05-12 19:30:00   11.00     A e  25.2 7.3  9.2   77.36
    ## 1172 02203655 2011-05-02 23:15:00   11.00       A  21.4 7.1  6.7   70.52
    ## 1173 02203700 2011-05-21 03:00:00    5.10       A    NA 6.8  5.0      NA
    ## 1174 02203655 2011-05-21 07:45:00    7.80     A e  19.7 7.0  6.8   67.46
    ## 1175 02337170 2011-05-09 01:00:00 1390.00       A  18.7 6.9  8.4   65.66
    ## 1176 02203700 2011-05-07 12:15:00    5.10       A  14.6 7.2  7.0   58.28
    ## 1177 02336410 2011-05-22 06:45:00   14.00       A  21.4 7.2  7.3   70.52
    ## 1178 02336240 2011-05-10 15:30:00   11.00       A  21.0 7.2  8.4   69.80
    ## 1179 02336240 2011-05-06 10:15:00   14.00     A e  14.5 7.2  8.6   58.10
    ## 1180 02336360 2011-05-25 06:30:00    9.10       A  22.8 7.1  6.5   73.04
    ## 1181 02336120 2011-05-08 20:15:00   17.00       A  20.0 7.3  8.9   68.00
    ## 1182 02336728 2011-05-02 00:45:00   16.00       A  20.3 7.1  8.0   68.54
    ## 1183 02336360 2011-05-26 11:45:00    8.40     A e  22.5 7.1  6.4   72.50
    ## 1184 02336240 2011-05-04 13:45:00   46.00       A  15.9 7.0  8.7   60.62
    ## 1185 02336300 2011-05-01 19:30:00   33.00       A  22.5 7.3  8.3   72.50
    ## 1186 02336313 2011-05-22 17:45:00    1.00       A  24.3 7.3  9.0   75.74
    ## 1187 02336728 2011-05-25 00:00:00    8.90     A e  25.0 7.2  7.7   77.00
    ## 1188 02336240 2011-05-28 17:15:00   21.00       A  22.5 7.0   NA   72.50
    ## 1189 02336300 2011-05-15 15:30:00   26.00     A e  19.3 7.5  8.3   66.74
    ## 1190 02336120 2011-05-10 04:30:00   16.00       A  21.1 7.1  7.6   69.98
    ## 1191 02336526 2011-05-30 04:15:00    5.90       A  25.1 7.2  6.7   77.18
    ## 1192 02203655 2011-05-28 06:15:00   28.00       A  21.1 6.4  7.0   69.98
    ## 1193 02337170 2011-05-12 20:45:00 6530.00       A  14.4 6.7  9.9   57.92
    ## 1194 02336300 2011-05-08 01:15:00   34.00       A  19.1 7.3  7.9   66.38
    ## 1195 02336313 2011-05-13 01:00:00    0.98       A  24.4 7.2  6.6   75.92
    ## 1196 02336240 2011-05-24 14:15:00    8.20       A  21.5 7.2  7.8   70.70
    ## 1197 02336410 2011-05-28 20:15:00   25.00     A e  24.4 7.1  7.5   75.92
    ## 1198 02336410 2011-05-07 09:30:00   23.00       A  16.2 7.0  8.5   61.16
    ## 1199 02336313 2011-05-20 06:30:00    0.93       A  17.5 7.1  6.9   63.50
    ## 1200 02336410 2011-05-27 06:30:00  211.00       A  22.0 6.7  5.8   71.60
    ## 1201 02336526 2011-05-31 14:30:00    4.60     A e  22.9 7.2  8.1   73.22
    ## 1202 02336240 2011-05-03 11:15:00   13.00       A  19.3 7.1  7.4   66.74
    ## 1203 02337170 2011-05-31 08:45:00 1270.00       A  24.5 6.8  6.9   76.10
    ## 1204 02337170 2011-05-14 12:00:00 3660.00       A  15.1  NA  9.7   59.18
    ## 1205 02203655 2011-05-22 17:00:00    8.50       A  21.3  NA  7.7   70.34
    ## 1206 02336360 2011-05-07 21:45:00   13.00       A  19.7 7.3  8.9   67.46
    ## 1207 02336120 2011-05-23 22:15:00   11.00     A e  24.8 7.3  8.0   76.64
    ## 1208 02203655 2011-05-30 17:30:00   10.00       A  23.0 6.9  6.6   73.40
    ## 1209 02336526 2011-05-31 15:30:00    4.60       A  23.3 7.2  8.5   73.94
    ## 1210 02336526 2011-05-24 15:30:00    3.10       A  21.8 7.7  8.5   71.24
    ## 1211 02203700 2011-05-03 02:30:00    6.10       A  21.5 7.2  6.7   70.70
    ## 1212 02336728 2011-05-04 08:45:00  188.00       A  17.4 6.7  8.1   63.32
    ## 1213 02336240 2011-05-05 20:45:00   15.00       A  17.8 7.2  8.8   64.04
    ## 1214 02336300 2011-05-24 03:45:00   21.00       A  23.8  NA   NA   74.84
    ## 1215 02336240 2011-05-27 06:15:00  247.00       A  20.9 6.8  7.8   69.62
    ## 1216 02336300 2011-05-04 02:15:00  695.00     A e  19.1 7.1  7.6   66.38
    ## 1217 02336360 2011-05-26 12:30:00    8.10     A e  22.4 7.1  6.6   72.32
    ## 1218 02336313 2011-05-28 15:15:00    0.93       A  21.2 7.2  7.2   70.16
    ## 1219 02203700 2011-05-05 15:15:00   21.00     A e  17.6 6.7  7.3   63.68
    ## 1220 02336120 2011-05-05 23:30:00   22.00       A  17.8 7.0  8.7   64.04
    ## 1221 02336410 2011-05-20 20:30:00   14.00     A e  21.8 7.5  9.6   71.24
    ## 1222 02337170 2011-05-13 17:30:00 4450.00       A  16.8 6.9  9.1   62.24
    ## 1223 02336313 2011-05-14 05:15:00    0.98       A  21.8 7.2  6.5   71.24
    ## 1224 02336300 2011-05-22 12:30:00   23.00     A e  20.7 7.3  7.1   69.26
    ## 1225 02336240 2011-05-27 08:45:00 2560.00       A  19.5 6.6  8.5   67.10
    ## 1226 02203655 2011-05-31 05:15:00    8.80       A    NA 7.1  6.2      NA
    ## 1227 02336313 2011-05-01 06:00:00    1.00       A  18.7 7.1  6.3   65.66
    ## 1228 02337170 2011-05-31 04:15:00 1270.00       A  25.1 6.8  7.0   77.18
    ## 1229 02336120 2011-05-24 16:15:00   11.00       A  22.4 7.2  7.7   72.32
    ## 1230 02336300 2011-05-17 20:00:00   28.00       A  16.7 7.7  9.3   62.06
    ## 1231 02336526 2011-05-06 06:00:00    5.20       A  16.1 7.0  8.2   60.98
    ## 1232 02336313 2011-05-24 18:00:00    0.93     A e  25.0 7.2  8.9   77.00
    ## 1233 02336313 2011-05-31 06:30:00    0.73       A  23.8 7.4  5.3   74.84
    ## 1234 02203700 2011-05-24 06:00:00    3.90       A  22.3 6.8  4.2   72.14
    ## 1235 02203700 2011-05-22 23:15:00    3.90       A  25.6 6.9  6.4   78.08
    ## 1236 02336360 2011-05-16 19:15:00   10.00       A  18.1 7.4 10.1   64.58
    ## 1237 02336728 2011-05-18 01:30:00   11.00       A  15.6 7.1  9.0   60.08
    ## 1238 02336300 2011-05-20 01:00:00   27.00     A e    NA 7.5  8.5      NA
    ## 1239 02203655 2011-05-28 15:15:00   19.00       A  20.1 6.4  7.2   68.18
    ## 1240 02336410 2011-05-29 22:30:00   16.00     A e  25.2 7.1  7.2   77.36
    ## 1241 02336526 2011-05-12 17:15:00    3.80       A  23.1 7.5 10.2   73.58
    ## 1242 02336728 2011-05-26 11:45:00    7.80     A e  21.2 7.0  7.3   70.16
    ## 1243 02336300 2011-05-01 10:00:00   32.00       A  18.6 7.2  7.0   65.48
    ## 1244 02336313 2011-05-11 03:30:00    0.98       A  23.0 7.2  6.2   73.40
    ## 1245 02336410 2011-05-16 01:45:00   16.00       A  18.3 7.3  8.2   64.94
    ## 1246 02336313 2011-05-08 21:30:00    1.00       A  21.9 7.3  8.5   71.42
    ## 1247 02203700 2011-05-19 04:30:00    4.20       A  16.3 6.8  5.3   61.34
    ## 1248 02336120 2011-05-12 01:00:00   15.00       A  24.2 7.2  7.5   75.56
    ## 1249 02336360 2011-05-31 02:45:00    6.30       A  25.3 7.0  6.5   77.54
    ## 1250 02203655 2011-05-28 13:45:00   21.00       A    NA 6.4  7.2      NA
    ## 1251 02336360 2011-05-22 19:15:00    9.80       A    NA 7.4  9.3      NA
    ## 1252 02336240 2011-05-03 19:30:00   13.00     A e  22.3 7.2  8.4   72.14
    ## 1253 02336360 2011-05-25 07:00:00    8.70       A  22.7 7.1  6.5   72.86
    ## 1254 02336240 2011-05-09 08:30:00   12.00       A  18.4 7.2  7.7   65.12
    ## 1255 02336410 2011-05-09 06:45:00   21.00     A e  19.5 7.1  7.7   67.10
    ## 1256 02203655 2011-05-29 22:00:00   11.00       A  23.4 6.7   NA   74.12
    ## 1257 02336410 2011-05-24 01:45:00   15.00       A  23.7 7.2  7.2   74.66
    ## 1258 02336360 2011-05-21 11:45:00    9.80       A  18.8 7.1  7.5   65.84
    ## 1259 02337170 2011-05-02 05:30:00 3680.00       A  15.0 6.9 10.1   59.00
    ## 1260 02203655 2011-05-07 01:15:00   12.00       A  18.3 7.2  7.6   64.94
    ## 1261 02336120 2011-05-23 21:15:00   11.00     A e  24.7 7.3  8.2   76.46
    ## 1262 02336120 2011-05-05 15:15:00   24.00       A  14.9 7.0  8.9   58.82
    ## 1263 02336120 2011-05-23 06:45:00   11.00       A  22.4 7.1  6.9   72.32
    ## 1264 02336120 2011-05-21 11:00:00   12.00       A  18.8 7.1  7.5   65.84
    ## 1265 02336120 2011-05-16 09:00:00   13.00     A e  17.1 7.2  8.1   62.78
    ## 1266 02337170 2011-05-31 18:15:00 1260.00       A  24.7 6.9  7.1   76.46
    ## 1267 02336526 2011-05-21 14:30:00    3.60     A e  19.0 7.6  8.3   66.20
    ## 1268 02336360 2011-05-04 13:15:00   39.00       A  16.7 6.8  8.4   62.06
    ## 1269 02336300 2011-05-10 11:45:00   31.00       A  20.2 7.3  7.1   68.36
    ## 1270 02203655 2011-05-01 07:15:00   11.00       A  18.9 7.1  6.6   66.02
    ## 1271 02203655 2011-05-20 21:30:00    8.80       A  19.9 7.0  8.1   67.82
    ## 1272 02336728 2011-05-19 22:30:00   11.00       A  19.9 7.3  9.2   67.82
    ## 1273 02203700 2011-05-12 16:15:00    4.90       A  23.0 7.2 10.0   73.40
    ## 1274 02336300 2011-05-19 02:30:00   27.00     A e  16.8 7.5  8.5   62.24
    ## 1275 02336300 2011-05-03 17:15:00   31.00       A  22.4 7.3  8.1   72.32
    ## 1276 02336728 2011-05-24 01:15:00    9.30       A  23.9 7.2  7.4   75.02
    ## 1277 02336526 2011-05-13 05:00:00    3.60     A e  23.7 7.6  6.2   74.66
    ## 1278 02337170 2011-05-05 04:30:00 6190.00     A e  14.3  NA 10.0   57.74
    ## 1279 02336410 2011-05-05 01:15:00   45.00     A e    NA 6.9  7.7      NA
    ## 1280 02336410 2011-05-21 05:00:00   14.00       A  20.1 7.2  7.7   68.18
    ## 1281 02336300 2011-05-22 19:00:00   22.00       A  25.5 7.5  8.8   77.90
    ## 1282 02336410 2011-05-16 04:45:00   16.00       A  17.8 7.2  8.2   64.04
    ## 1283 02336120 2011-05-14 17:15:00   13.00       A  21.3 7.2  8.2   70.34
    ## 1284 02336728 2011-05-25 21:00:00   10.00     A e  26.0 7.3  8.7   78.80
    ## 1285 02336120 2011-05-20 07:00:00   12.00       A  17.6 7.2  8.2   63.68
    ## 1286 02336410 2011-05-27 05:15:00  232.00       A  22.2 6.7  5.9   71.96
    ## 1287 02336360 2011-05-06 03:00:00   15.00     A e  17.0 7.1  8.1   62.60
    ## 1288 02336240 2011-05-13 12:30:00   10.00       A  20.7 7.2  7.3   69.26
    ## 1289 02336410 2011-05-04 06:45:00  284.00       A  18.5 6.7  7.5   65.30
    ## 1290 02336240 2011-05-29 12:45:00   14.00       A  21.0 7.0  7.3   69.80
    ## 1291 02203700 2011-05-15 13:00:00    4.20     A e  17.9 6.9  5.9   64.22
    ## 1292 02336410 2011-05-06 05:15:00   26.00       A  16.7 7.0  8.4   62.06
    ## 1293 02336410 2011-05-26 22:00:00   10.00     A e  24.9 7.3  7.6   76.82
    ## 1294 02336360 2011-05-07 18:30:00   13.00     A e  18.9 7.3  9.0   66.02
    ## 1295 02203700 2011-05-02 01:45:00    6.10     A e  21.5 7.0  7.1   70.70
    ## 1296 02336526 2011-05-12 07:15:00    3.60       A  22.9 7.2  6.1   73.22
    ## 1297 02336728 2011-05-29 09:30:00   21.00       A  21.9 7.0  7.4   71.42
    ## 1298 02336410 2011-05-09 23:30:00   20.00     A e  21.9  NA  7.9   71.42
    ## 1299 02337170 2011-05-13 23:45:00 6210.00       A  14.7 6.7  9.9   58.46
    ## 1300 02336120 2011-05-15 16:00:00   13.00       A  18.9 7.3  8.3   66.02
    ## 1301 02337170 2011-05-11 19:00:00 2860.00       A  18.7 6.9   NA   65.66
    ## 1302 02337170 2011-05-04 13:45:00 6190.00       A  15.6 6.7  8.8   60.08
    ## 1303 02336728 2011-05-21 03:45:00   10.00       A  19.6 7.1  7.9   67.28
    ## 1304 02203655 2011-05-26 15:00:00    6.80       A  22.1 6.9  5.9   71.78
    ## 1305 02337170 2011-05-15 07:30:00 3250.00     A e  14.7 6.9  9.8   58.46
    ## 1306 02336526 2011-05-24 15:15:00    3.10       A  21.8 7.6  8.3   71.24
    ## 1307 02203655 2011-05-04 14:00:00   39.00       A  15.9  NA  8.1   60.62
    ## 1308 02336300 2011-05-08 12:30:00   33.00       A  16.8 7.3  6.9   62.24
    ## 1309 02203700 2011-05-08 10:15:00    5.10       A  16.3 7.1  5.3   61.34
    ## 1310 02336300 2011-05-09 11:00:00   31.00       A  18.8 7.3  7.4   65.84
    ## 1311 02203655 2011-05-26 21:00:00    7.50       A  23.4 7.0  6.1   74.12
    ## 1312 02336313 2011-05-18 00:45:00    1.00       A  16.4 7.2  7.8   61.52
    ## 1313 02203700 2011-05-16 05:30:00    4.20     A e  17.2 6.9  4.7   62.96
    ## 1314 02337170 2011-05-31 21:45:00 1260.00       A  26.0 7.0  7.5   78.80
    ## 1315 02336240 2011-05-07 01:00:00   13.00     A e  17.5 7.2  8.2   63.50
    ## 1316 02337170 2011-05-27 00:45:00 1720.00       A  21.4 7.1  8.5   70.52
    ## 1317 02336313 2011-05-09 15:00:00    1.10       A  20.3 7.2  8.8   68.54
    ## 1318 02203700 2011-05-26 18:30:00    3.70       A  24.6 7.1  9.0   76.28
    ## 1319 02336728 2011-05-22 19:15:00    9.30       A  24.9 7.3  8.9   76.82
    ## 1320 02336410 2011-05-13 10:30:00   17.00       A  21.7 7.1  7.2   71.06
    ## 1321 02203700 2011-05-19 03:30:00    4.00     A e  16.7 6.8  5.4   62.06
    ## 1322 02336410 2011-05-15 14:15:00   16.00     A e  19.0 7.2  8.1   66.20
    ## 1323 02336360 2011-05-21 23:45:00    9.80       A  23.1 7.3  8.0   73.58
    ## 1324 02337170 2011-05-28 01:15:00 5320.00       A  20.6 6.5  7.1   69.08
    ## 1325 02203700 2011-05-05 14:00:00   22.00       A  16.6 6.6  7.2   61.88
    ## 1326 02336410 2011-05-26 23:45:00   34.00       A  23.5  NA  7.1   74.30
    ## 1327 02336360 2011-05-15 23:00:00   11.00       A  18.8 7.3  8.9   65.84
    ## 1328 02336120 2011-05-30 08:00:00   15.00       A  23.6 6.9  6.7   74.48
    ## 1329 02336360 2011-05-13 11:00:00   11.00       A  21.2 7.0  7.0   70.16
    ## 1330 02336360 2011-05-26 17:45:00    8.40       A  24.3 7.3  8.5   75.74
    ## 1331 02336313 2011-05-10 03:30:00    1.20     A e  22.0 7.2  6.6   71.60
    ## 1332 02336300 2011-05-24 11:30:00   21.00       A    NA 7.4  6.6      NA
    ## 1333 02203655 2011-05-22 03:45:00    7.80     A e  21.8 7.0  6.6   71.24
    ## 1334 02336360 2011-05-27 07:00:00   73.00       A  21.8 6.6  7.0   71.24
    ## 1335 02336526 2011-05-30 10:45:00    5.20       A  22.8 7.2  7.0   73.04
    ## 1336 02336120 2011-05-16 13:45:00   13.00     A e  16.7 7.2  8.3   62.06
    ## 1337 02203700 2011-05-05 04:15:00   24.00       A  17.1 6.7  7.1   62.78
    ## 1338 02336360 2011-05-04 08:30:00   76.00       A    NA 6.7  8.2      NA
    ## 1339 02336313 2011-05-05 14:30:00    1.40       A  14.3 7.0  9.2   57.74
    ## 1340 02203700 2011-05-07 23:30:00    5.10       A  21.1 7.1  4.6   69.98
    ## 1341 02336300 2011-05-22 03:30:00   23.00     A e  22.5 7.3  7.0   72.50
    ## 1342 02203700 2011-05-11 13:45:00    4.60       A  20.6 7.4  6.6   69.08
    ## 1343 02336526 2011-05-15 13:00:00    3.60       A  18.6 7.2  7.2   65.48
    ## 1344 02336526 2011-05-17 14:00:00    3.80       A  15.1 7.2  8.8   59.18
    ## 1345 02336240 2011-05-27 14:15:00  455.00     A e  19.7 6.7  8.4   67.46
    ## 1346 02336410 2011-05-19 13:45:00   15.00       A  14.8 7.2  9.3   58.64
    ## 1347 02336120 2011-05-02 16:30:00   16.00       A  19.9  NA  8.4   67.82
    ## 1348 02203700 2011-05-18 11:45:00    4.20       A  13.5 6.8  5.6   56.30
    ## 1349 02336300 2011-05-15 19:30:00   26.00     A e  19.5 7.6  8.8   67.10
    ## 1350 02336120 2011-05-29 15:30:00   17.00       A  22.4 6.9  7.3   72.32
    ## 1351 02203700 2011-05-08 23:00:00    4.90       A  22.2 7.2  5.6   71.96
    ## 1352 02336300 2011-05-25 05:45:00   20.00       A  23.5 7.4  6.3   74.30
    ## 1353 02336360 2011-05-14 05:00:00   11.00     A e  22.0 7.0  6.9   71.60
    ## 1354 02336240 2011-05-02 17:30:00   13.00       A  21.1 7.2  8.7   69.98
    ## 1355 02203700 2011-05-25 16:30:00    3.70       A  23.0 7.0  8.1   73.40
    ## 1356 02203700 2011-05-23 00:30:00    3.70       A  24.9 6.8  5.1   76.82
    ## 1357 02336120 2011-05-15 16:45:00   13.00       A  18.9 7.3  8.4   66.02
    ## 1358 02336120 2011-05-23 16:30:00   11.00       A  22.2 7.1  7.6   71.96
    ## 1359 02203700 2011-05-16 02:45:00    4.20     A e  17.8 6.9  4.9   64.04
    ## 1360 02337170 2011-05-23 19:30:00 1760.00       A  22.0 7.1  8.5   71.60
    ## 1361 02203655 2011-05-23 08:00:00    7.50       A  21.9 6.9  5.9   71.42
    ## 1362 02336360 2011-05-21 03:15:00   10.00       A    NA 7.1  7.5      NA
    ## 1363 02336120 2011-05-29 05:30:00   20.00     A e  22.8 6.8  6.8   73.04
    ## 1364 02336728 2011-05-22 03:30:00    9.70     A e  21.2 7.1  7.6   70.16
    ## 1365 02336240 2011-05-30 14:30:00   12.00       A  22.7 7.1  7.4   72.86
    ## 1366 02336728 2011-05-24 13:30:00    8.90       A  20.9 7.1  7.8   69.62
    ## 1367 02336313 2011-05-11 16:15:00    1.00       A  23.6 7.2  8.8   74.48
    ## 1368 02336526 2011-05-17 12:30:00    4.00       A  15.1  NA  8.0   59.18
    ## 1369 02203700 2011-05-24 10:30:00    3.70       A  20.6 6.8  4.4   69.08
    ## 1370 02336120 2011-05-07 20:45:00   18.00       A  19.5 7.2  9.0   67.10
    ## 1371 02336526 2011-05-15 10:15:00    3.60       A  19.4 7.2  6.6   66.92
    ## 1372 02336240 2011-05-15 11:15:00    9.90     A e  18.5 7.2  7.4   65.30
    ## 1373 02337170 2011-05-22 03:00:00 3330.00       A  17.3 6.8  9.3   63.14
    ## 1374 02336410 2011-05-31 03:30:00   13.00       A  24.9 7.0  6.5   76.82
    ## 1375 02336313 2011-05-17 01:00:00    1.30       A    NA 7.3  8.2      NA
    ## 1376 02337170 2011-05-22 09:30:00 2450.00       A  16.7 6.9  9.6   62.06
    ## 1377 02337170 2011-05-20 19:00:00 2970.00       A    NA 6.9  9.5      NA
    ## 1378 02337170 2011-05-16 14:15:00 1540.00     A e  16.3 7.0  8.7   61.34
    ## 1379 02337170 2011-05-30 08:45:00 1400.00       A  23.1 6.8  7.0   73.58
    ## 1380 02336313 2011-05-01 19:00:00    1.00       A  22.5 7.1  8.3   72.50
    ## 1381 02336728 2011-05-21 02:30:00   10.00     A e  20.3 7.1  7.9   68.54
    ## 1382 02336728 2011-05-20 09:00:00   10.00     A e  16.2 7.1  8.6   61.16
    ## 1383 02336240 2011-05-22 14:45:00    8.90       A  20.5 7.3  8.4   68.90
    ## 1384 02203655 2011-05-24 04:15:00    7.50       A  22.9 7.0   NA   73.22
    ## 1385 02203700 2011-05-15 07:45:00    4.40     A e  19.2 6.9  4.6   66.56
    ## 1386 02336120 2011-05-11 21:45:00   15.00       A  25.1 7.4   NA   77.18
    ## 1387 02336120 2011-05-13 09:00:00   13.00       A  21.8 7.1  7.0   71.24
    ## 1388 02203700 2011-05-16 19:45:00    7.90       A  18.9 7.2 10.2   66.02
    ## 1389 02336240 2011-05-11 04:45:00   11.00       A  21.8 7.1  6.9   71.24
    ## 1390 02336410 2011-05-15 15:15:00   16.00       A  19.1 7.3  8.4   66.38
    ## 1391 02203700 2011-05-08 09:15:00    4.90       A    NA 7.1  5.0      NA
    ## 1392 02203700 2011-05-13 07:30:00    4.40       A  21.2 6.8   NA   70.16
    ## 1393 02336526 2011-05-12 12:30:00    3.80       A  21.0 7.1  6.8   69.80
    ## 1394 02336120 2011-05-06 03:45:00   21.00     A e  16.6 7.0  8.5   61.88
    ## 1395 02337170 2011-05-05 00:15:00 7180.00       A  14.8 6.7  9.7   58.64
    ## 1396 02336120 2011-05-05 06:00:00   30.00       A  16.4 6.8  8.3   61.52
    ## 1397 02336526 2011-05-23 13:30:00    3.60     A e  21.1 7.5  7.1   69.98
    ## 1398 02336526 2011-05-15 14:00:00    3.60     A e  18.6 7.2  7.7   65.48
    ## 1399 02336360 2011-05-20 22:30:00   10.00       A  21.9 7.4  9.1   71.42
    ## 1400 02336410 2011-05-08 18:45:00   21.00     A e  20.0 7.2  8.8   68.00
    ## 1401 02203700 2011-05-08 09:45:00    5.10     A e  16.5  NA  5.1   61.70
    ## 1402 02336240 2011-05-08 03:00:00   13.00       A  17.9 7.2  7.9   64.22
    ## 1403 02203700 2011-05-17 07:30:00    4.60       A  15.7 6.9  5.4   60.26
    ## 1404 02336240 2011-05-23 00:30:00    8.50       A  23.7 7.2  7.2   74.66
    ## 1405 02336410 2011-05-03 23:15:00   79.00       A  20.6 6.8  7.2   69.08
    ## 1406 02336410 2011-05-25 10:45:00   13.00       A  21.9 7.2  7.0   71.42
    ## 1407 02203700 2011-05-18 00:00:00    4.40       A  16.4 6.9  6.7   61.52
    ## 1408 02336360 2011-05-31 03:30:00    6.30     A e  25.1 6.9  6.6   77.18
    ## 1409 02336120 2011-05-15 01:30:00   13.00       A  21.8 7.2  7.6   71.24
    ## 1410 02203700 2011-05-14 09:30:00    4.40       A  20.4 6.8  4.4   68.72
    ## 1411 02336300 2011-05-17 12:30:00   27.00       A  15.3 7.5  8.1   59.54
    ## 1412 02203700 2011-05-16 21:45:00   11.00       A  19.4 7.1  3.3   66.92
    ## 1413 02336240 2011-05-05 21:45:00   15.00     A e  17.5 7.2  8.8   63.50
    ## 1414 02336360 2011-05-22 10:30:00    9.80       A  20.5 7.1  7.0   68.90
    ## 1415 02336410 2011-05-20 06:00:00   15.00       A  17.8 7.2  8.3   64.04
    ## 1416 02336240 2011-05-01 14:30:00   13.00       A  17.9 7.2  8.2   64.22
    ## 1417 02336300 2011-05-01 05:45:00   34.00     A e  19.7 7.2  7.0   67.46
    ## 1418 02336313 2011-05-05 06:00:00    1.30       A  15.0 6.9  7.6   59.00
    ## 1419 02336728 2011-05-28 11:00:00   40.00       A  20.7 6.8  7.7   69.26
    ## 1420 02336313 2011-05-17 00:15:00    1.40       A  17.3 7.4  8.4   63.14
    ## 1421 02336240 2011-05-22 18:00:00    9.20       A  24.3 7.4  9.7   75.74
    ## 1422 02336120 2011-05-28 19:45:00   25.00       A  24.3 6.8  7.3   75.74
    ## 1423 02336526 2011-05-17 16:00:00    3.80     A e  15.6 7.4 10.3   60.08
    ## 1424 02336240 2011-05-15 19:30:00   10.00     A e  19.1 7.4  9.1   66.38
    ## 1425 02336526 2011-05-19 06:00:00    3.60       A  16.1 7.9  8.5   60.98
    ## 1426 02203700 2011-05-21 07:30:00    4.90       A  19.1 6.8  5.1   66.38
    ## 1427 02336300 2011-05-09 22:15:00   31.00       A  23.6 7.3  8.4   74.48
    ## 1428 02336120 2011-05-06 00:30:00   22.00       A  17.6 7.0  8.6   63.68
    ## 1429 02336240 2011-05-12 13:30:00   11.00       A  21.0 7.2  7.6   69.80
    ## 1430 02203700 2011-05-18 01:00:00    4.60       A  16.1 6.9  6.2   60.98
    ## 1431 02203655 2011-05-23 22:45:00    8.20     A e  22.9 7.0  6.9   73.22
    ## 1432 02336240 2011-05-14 15:30:00   10.00       A  21.0 7.2  8.2   69.80
    ## 1433 02336360 2011-05-24 16:00:00    8.70     A e  22.4 7.2  8.1   72.32
    ## 1434 02203700 2011-05-14 09:15:00    4.40       A  20.5 6.8  4.4   68.90
    ## 1435 02336240 2011-05-22 20:45:00    8.90       A  25.2 7.4  9.0   77.36
    ## 1436 02336313 2011-05-10 14:15:00    1.00     A e  20.7 7.2   NA   69.26
    ## 1437 02336300 2011-05-20 18:45:00   25.00       A  21.8 7.6  9.4   71.24
    ## 1438 02336240 2011-05-18 10:45:00   11.00       A  13.6 7.3  8.7   56.48
    ## 1439 02337170 2011-05-15 12:45:00 2250.00       A  15.2 6.9  9.6   59.36
    ## 1440 02336120 2011-05-21 01:15:00   12.00       A  21.3 7.0  7.8   70.34
    ## 1441 02337170 2011-05-23 02:30:00 1410.00       A  20.1 6.8  8.6   68.18
    ## 1442 02336410 2011-05-31 23:15:00   12.00       A  26.6 7.2  7.1   79.88
    ## 1443 02336410 2011-05-13 07:15:00   17.00     A e  22.4 7.1  6.7   72.32
    ## 1444 02336300 2011-05-10 03:15:00   31.00       A  21.8 7.3  7.2   71.24
    ## 1445 02336526 2011-05-31 10:30:00    4.80       A  22.8 7.1   NA   73.04
    ## 1446 02336313 2011-05-28 10:15:00    0.98       A  20.0 7.3  6.3   68.00
    ## 1447 02337170 2011-05-31 06:30:00 1270.00     A e  24.8 6.8  6.9   76.64
    ## 1448 02336240 2011-05-13 13:30:00   10.00       A  20.9 7.2  7.6   69.62
    ## 1449 02203655 2011-05-17 07:30:00    9.60     A e  16.4 7.1  8.1   61.52
    ## 1450 02337170 2011-05-28 09:30:00 2960.00       A  20.3 6.6  7.3   68.54
    ## 1451 02336728 2011-05-23 20:00:00    9.30       A  25.2 7.3  8.9   77.36
    ## 1452 02336240 2011-05-30 21:00:00   11.00     A e  26.1 7.1   NA   78.98
    ## 1453 02203700 2011-05-22 23:30:00    3.90       A  25.4 6.9  6.1   77.72
    ## 1454 02336526 2011-05-19 11:45:00    3.60       A  14.4 7.5  8.2   57.92
    ## 1455 02336240 2011-05-21 01:45:00    9.20     A e  20.4 7.2  7.4   68.72
    ## 1456 02336410 2011-05-01 17:15:00   22.00       A  19.9 6.9  8.5   67.82
    ## 1457 02336360 2011-05-02 16:00:00   14.00       A  19.7 7.1  8.5   67.46
    ## 1458 02203655 2011-05-23 18:45:00    7.80       A  22.7 7.0  7.4   72.86
    ## 1459 02336526 2011-05-07 20:00:00    4.80       A  20.2 7.6 10.9   68.36
    ## 1460 02336240 2011-05-09 00:15:00   12.00       A  20.0 7.2  7.9   68.00
    ## 1461 02203700 2011-05-08 16:00:00    5.10       A  19.1 7.3   NA   66.38
    ## 1462 02336313 2011-05-08 01:45:00    1.00       A  19.4 7.2  7.5   66.92
    ## 1463 02336120 2011-05-21 00:00:00   12.00       A  21.7 7.0  8.2   71.06
    ## 1464 02337170 2011-05-24 16:00:00 2870.00       A  20.6  NA  8.6   69.08
    ## 1465 02336120 2011-05-25 05:30:00    9.60     A e  23.4  NA  6.7   74.12
    ## 1466 02336410 2011-05-20 02:30:00   15.00       A  18.3 7.3  8.6   64.94
    ## 1467 02336410 2011-05-14 09:45:00   16.00       A  21.3 7.1  7.2   70.34
    ## 1468 02336300 2011-05-23 08:30:00   22.00       A  22.4  NA  6.6   72.32
    ## 1469 02336300 2011-05-07 02:45:00   38.00       A  17.4 7.3  8.0   63.32
    ## 1470 02336360 2011-05-18 06:45:00   10.00       A    NA 7.1  8.9      NA
    ## 1471 02336360 2011-05-01 22:00:00   14.00     A e  21.8 7.2  8.6   71.24
    ## 1472 02336300 2011-05-22 02:00:00   24.00       A  23.1 7.4  7.3   73.58
    ## 1473 02336313 2011-05-14 13:30:00    1.00       A    NA 7.2  7.5      NA
    ## 1474 02337170 2011-05-03 12:30:00 4830.00       A  15.3 6.9  9.8   59.54
    ## 1475 02336313 2011-05-11 18:00:00    1.00       A  25.0 7.3  8.9   77.00
    ## 1476 02336300 2011-05-21 16:00:00   23.00       A  21.0 7.4  8.5   69.80
    ## 1477 02203655 2011-05-06 22:30:00   12.00       A  17.9 7.2  7.6   64.22
    ## 1478 02337170 2011-05-05 02:00:00 6880.00       A  14.5 6.7   NA   58.10
    ## 1479 02337170 2011-05-22 22:15:00 1420.00       A  19.8 6.9  9.0   67.64
    ## 1480 02203655 2011-05-18 21:15:00    9.20       A  16.1 7.1  9.2   60.98
    ## 1481 02203700 2011-05-11 12:00:00    4.60     A e  19.9 7.4  4.5   67.82
    ## 1482 02336360 2011-05-05 07:15:00   19.00       A  16.6 6.9  8.1   61.88
    ## 1483 02336300 2011-05-10 06:00:00   31.00       A  21.2 7.3  7.1   70.16
    ## 1484 02337170 2011-05-28 12:30:00 2670.00       A  20.2 6.8  7.5   68.36
    ## 1485 02336728 2011-05-30 10:15:00   16.00       A    NA 7.0  7.3      NA
    ## 1486 02336526 2011-05-04 17:15:00   11.00     A e  17.2 6.8  9.3   62.96
    ## 1487 02336526 2011-05-11 11:15:00    4.00       A  20.8 7.0  6.5   69.44
    ## 1488 02336240 2011-05-08 07:45:00   12.00       A  16.8 7.2  8.1   62.24
    ## 1489 02203655 2011-05-21 12:30:00    8.20     A e  18.5 7.0  7.1   65.30
    ## 1490 02336410 2011-05-12 17:15:00   17.00       A  23.4 7.2  8.3   74.12
    ## 1491 02336728 2011-05-27 02:30:00  377.00       A  23.0 6.5  6.2   73.40
    ## 1492 02336300 2011-05-21 17:15:00   23.00       A  22.0 7.4  8.8   71.60
    ## 1493 02203655 2011-05-28 05:15:00   32.00       A  21.3 6.4  7.0   70.34
    ## 1494 02336120 2011-05-26 04:30:00   11.00       A  24.1 7.1  6.7   75.38
    ## 1495 02336728 2011-05-23 19:15:00    8.90     A e  24.8 7.3  9.0   76.64
    ## 1496 02336300 2011-05-19 05:15:00   27.00     A e  16.2 7.4  8.2   61.16
    ## 1497 02203655 2011-05-21 02:15:00    8.20     A e  20.6 7.0  7.1   69.08
    ## 1498 02203700 2011-05-26 12:45:00    3.70       A  21.5 6.8  5.2   70.70
    ## 1499 02336410 2011-05-15 23:45:00   16.00     A e  18.6  NA  8.4   65.48
    ## 1500 02336728 2011-05-16 19:00:00   12.00       A  17.8 7.2  9.3   64.04
    ## 1501 02336526 2011-05-14 15:15:00    3.60       A  20.6 7.2  8.0   69.08
    ## 1502 02336360 2011-05-25 09:30:00    8.70       A  22.0 7.1   NA   71.60
    ## 1503 02336526 2011-05-06 02:00:00    5.50       A  17.9 7.1  8.5   64.22
    ## 1504 02336313 2011-05-29 13:15:00    0.82       A  20.7 7.6  6.3   69.26
    ## 1505 02203700 2011-05-15 05:15:00    4.20       A  20.2 6.8  4.3   68.36
    ## 1506 02336526 2011-05-07 00:15:00    4.80     A e  19.9 7.4  9.0   67.82
    ## 1507 02336526 2011-05-05 06:00:00    6.40       A  15.8 6.9  8.1   60.44
    ## 1508 02336526 2011-05-18 01:45:00    3.80       A  16.0 8.1 10.3   60.80
    ## 1509 02203700 2011-05-13 10:00:00    4.40       A  20.3 6.9  3.9   68.54
    ## 1510 02336526 2011-05-28 04:15:00   14.00       A  21.8 7.0  7.3   71.24
    ## 1511 02336120 2011-05-07 18:00:00   18.00       A  17.7 7.2  9.1   63.86
    ## 1512 02336313 2011-05-11 12:00:00    1.00       A  20.2 7.2  6.8   68.36
    ## 1513 02203655 2011-05-20 02:45:00    8.80       A  18.5 7.0  7.8   65.30
    ## 1514 02336526 2011-05-21 07:00:00    3.60       A  20.6 7.8  6.9   69.08
    ## 1515 02336240 2011-05-19 03:30:00    9.90       A  15.8 7.3  8.3   60.44
    ## 1516 02336728 2011-05-23 07:30:00    8.90       A  21.0 7.1  7.4   69.80
    ## 1517 02336240 2011-05-18 00:45:00   11.00       A  15.5 7.4  8.7   59.90
    ## 1518 02336360 2011-05-06 18:00:00   14.00       A  17.6 7.2  9.0   63.68
    ## 1519 02336728 2011-05-02 15:45:00   15.00     A e  20.6 7.1  8.4   69.08
    ## 1520 02337170 2011-05-16 18:00:00 1910.00     A e  16.8 7.0  8.9   62.24
    ## 1521 02203655 2011-05-19 14:30:00    8.80     A e  14.9 7.0  9.0   58.82
    ## 1522 02203655 2011-05-22 12:00:00    7.80     A e  19.9 7.0  6.8   67.82
    ## 1523 02337170 2011-05-25 12:00:00 1730.00       A  19.9  NA  8.7   67.82
    ## 1524 02336728 2011-05-05 03:00:00   28.00     A e  17.4 6.9  8.2   63.32
    ## 1525 02336360 2011-05-22 14:45:00    9.80       A  20.6  NA  7.9   69.08
    ## 1526 02336410 2011-05-22 15:30:00   14.00       A  21.2 7.2  8.2   70.16
    ## 1527 02336120 2011-05-07 11:00:00   17.00       A  15.8 7.1  8.5   60.44
    ## 1528 02336526 2011-05-29 19:00:00    5.70       A  24.8 7.3  8.7   76.64
    ## 1529 02336360 2011-05-14 22:45:00   11.00       A  22.8 7.3  8.3   73.04
    ## 1530 02203700 2011-05-18 12:00:00    4.40       A  13.5 6.8  5.6   56.30
    ## 1531 02336120 2011-05-09 12:15:00   16.00       A  18.5 7.1  8.0   65.30
    ## 1532 02336360 2011-05-07 13:30:00   14.00     A e  15.4 7.1  8.6   59.72
    ## 1533 02336313 2011-05-30 20:30:00    0.73       A  26.5 7.3  6.8   79.70
    ## 1534 02337170 2011-05-20 13:45:00 2410.00     A e  14.6 7.0  9.9   58.28
    ## 1535 02336526 2011-05-24 01:30:00    3.10       A    NA 9.0  9.8      NA
    ## 1536 02336526 2011-05-11 09:15:00    3.80       A  21.5 7.1  6.4   70.70
    ## 1537 02203700 2011-05-21 23:45:00    3.90       A  24.1 6.9  6.0   75.38
    ## 1538 02336360 2011-05-11 13:30:00   12.00       A  21.0 7.0  7.5   69.80
    ## 1539 02336410 2011-05-22 06:00:00   14.00     A e  21.5 7.2  7.3   70.70
    ## 1540 02336240 2011-05-30 15:30:00   11.00       A  23.4 7.0  7.5   74.12
    ## 1541 02336240 2011-05-06 07:30:00   14.00     A e  15.0 7.2  8.4   59.00
    ## 1542 02336410 2011-05-19 07:30:00   16.00       A  15.4 7.2  8.9   59.72
    ## 1543 02336120 2011-05-13 06:15:00   13.00     A e  22.5 7.1  7.0   72.50
    ## 1544 02336526 2011-05-23 17:30:00    3.50     A e  22.8 8.2 10.7   73.04
    ## 1545 02336120 2011-05-01 08:45:00   17.00     A e  18.5 7.0  7.8   65.30
    ## 1546 02203655 2011-05-04 09:00:00   91.00       A  16.5 6.8  8.0   61.70
    ## 1547 02336526 2011-05-02 10:15:00    4.20       A  19.4 7.0  6.9   66.92
    ## 1548 02203655 2011-05-06 09:30:00   12.00     A e    NA  NA  7.9      NA
    ## 1549 02336313 2011-05-05 09:00:00    1.30       A  13.9 6.9  8.0   57.02
    ## 1550 02336313 2011-05-15 02:45:00    0.98       A  21.3 7.2  6.9   70.34
    ## 1551 02336240 2011-05-05 21:00:00   15.00       A  17.7 7.2  8.8   63.86
    ## 1552 02337170 2011-05-04 02:15:00 5830.00     A e  13.7 6.8 10.5   56.66
    ## 1553 02336728 2011-05-24 11:45:00    8.90       A  20.6 7.1  7.5   69.08
    ## 1554 02336526 2011-05-04 05:45:00   80.00       A  16.7 6.5  8.5   62.06
    ## 1555 02336300 2011-05-07 21:15:00   35.00       A  20.6 7.2  8.5   69.08
    ## 1556 02337170 2011-05-16 06:15:00 1400.00       A  16.0 6.9  8.9   60.80
    ## 1557 02336240 2011-05-21 09:45:00    9.20     A e  18.3 7.2  7.6   64.94
    ## 1558 02337170 2011-05-06 21:30:00 7540.00       A  12.8 6.8 10.5   55.04
    ## 1559 02203700 2011-05-12 23:00:00    4.60     A e  26.0 7.1  7.9   78.80
    ## 1560 02203700 2011-05-10 05:45:00    4.90       A  20.9  NA  3.5   69.62
    ## 1561 02336300 2011-05-16 18:15:00   25.00       A  17.6 7.6  9.0   63.68
    ## 1562 02336526 2011-05-23 17:15:00    3.60       A  22.6 8.1 10.4   72.68
    ## 1563 02336360 2011-05-24 22:15:00    9.10       A  25.5 7.4  8.2   77.90
    ## 1564 02337170 2011-05-31 06:15:00 1270.00       A  24.8 6.8  6.9   76.64
    ## 1565 02336120 2011-05-12 13:30:00   14.00       A  21.4 7.2  7.5   70.52
    ## 1566 02336526 2011-05-25 20:45:00    2.80       A  25.4 8.7 12.1   77.72
    ## 1567 02336728 2011-05-20 00:30:00   11.00       A  18.9 7.2  8.7   66.02
    ## 1568 02336313 2011-05-21 22:30:00    0.98       A  23.5 7.2  7.4   74.30
    ## 1569 02336410 2011-05-06 16:00:00   25.00     A e    NA 7.0  8.8      NA
    ## 1570 02336240 2011-05-27 13:45:00  625.00     A e  19.6 6.7  8.5   67.28
    ## 1571 02203700 2011-05-02 00:00:00    6.10       A  22.5 7.1  8.6   72.50
    ## 1572 02203655 2011-05-29 22:15:00   11.00     A e  23.4 6.7  6.9   74.12
    ## 1573 02336120 2011-05-23 10:30:00   11.00     A e  21.4 7.1  7.0   70.52
    ## 1574 02337170 2011-05-27 16:30:00 7190.00       A  20.5 6.3  5.8   68.90
    ## 1575 02336410 2011-05-26 01:00:00   11.00     A e  24.5 7.3  7.2   76.10
    ## 1576 02336410 2011-05-30 00:45:00   16.00       A  24.8 7.0  6.8   76.64
    ## 1577 02336313 2011-05-29 09:15:00    0.77       A  21.1 7.5  6.0   69.98
    ## 1578 02337170 2011-05-12 14:15:00 5140.00       A  15.8 6.8  9.4   60.44
    ## 1579 02336728 2011-05-25 13:30:00    8.20       A  20.7 7.0  7.7   69.26
    ## 1580 02336120 2011-05-24 02:45:00   11.00     A e  23.7 7.2  7.0   74.66
    ## 1581 02336120 2011-05-03 06:30:00   16.00       A  20.4 7.1  7.5   68.72
    ## 1582 02336526 2011-05-05 21:15:00    5.70       A  18.7 7.3 10.2   65.66
    ## 1583 02336728 2011-05-19 10:15:00   11.00       A  14.0 7.1  9.0   57.20
    ## 1584 02336410 2011-05-15 21:45:00   16.00       A  18.9 7.4  8.4   66.02
    ## 1585 02203700 2011-05-21 01:30:00    5.10       A  22.1 6.9  5.4   71.78
    ## 1586 02336526 2011-05-05 07:00:00    6.40     A e  15.3 6.9  8.2   59.54
    ## 1587 02203700 2011-05-18 10:30:00    4.40       A  13.6 6.8  5.4   56.48
    ## 1588 02336313 2011-05-01 05:15:00    1.00     A e  19.0 7.0  6.4   66.20
    ## 1589 02336360 2011-05-06 12:00:00   14.00       A  14.9 7.0  8.4   58.82
    ## 1590 02336120 2011-05-25 12:00:00   11.00       A  21.6 7.0  6.9   70.88
    ## 1591 02336526 2011-05-11 01:15:00    4.60       A  25.3 8.0  7.5   77.54
    ## 1592 02336313 2011-05-29 15:15:00    0.82       A  22.0 7.4  6.6   71.60
    ## 1593 02336526 2011-05-17 21:15:00    3.60       A  16.4 8.1 12.2   61.52
    ## 1594 02336313 2011-05-11 11:00:00    1.00       A  20.3 7.2  6.6   68.54
    ## 1595 02337170 2011-05-24 21:45:00 2390.00     A e  20.3 6.9  8.7   68.54
    ## 1596 02203655 2011-05-25 19:00:00    7.50       A  23.3 7.0  6.6   73.94
    ## 1597 02336300 2011-05-01 22:30:00   33.00       A  22.3 7.3  8.0   72.14
    ## 1598 02336526 2011-05-17 17:00:00    3.80     A e  16.0 7.5 11.0   60.80
    ## 1599 02336526 2011-05-03 19:00:00    4.00       A  22.9 7.3 10.0   73.22
    ## 1600 02336410 2011-05-25 21:15:00   11.00       A  25.8 7.5  8.1   78.44
    ## 1601 02336300 2011-05-17 14:00:00   27.00       A  15.4 7.5  8.6   59.72
    ## 1602 02337170 2011-05-22 03:45:00 3250.00     A e  17.2 6.9  9.4   62.96
    ## 1603 02336313 2011-05-10 11:00:00    1.00       A  19.4 7.2  6.8   66.92
    ## 1604 02203700 2011-05-08 06:45:00    5.10     A e  17.4 7.1  4.3   63.32
    ## 1605 02336313 2011-05-08 11:30:00    1.10     A e  15.9 7.2  7.7   60.62
    ## 1606 02336240 2011-05-04 08:30:00  164.00     A e  16.8 7.0  8.8   62.24
    ## 1607 02337170 2011-05-26 01:15:00 1700.00       A  21.0 7.1  8.8   69.80
    ## 1608 02336240 2011-05-18 13:15:00   11.00       A  13.6 7.3  9.0   56.48
    ## 1609 02336360 2011-05-11 11:30:00   12.00       A  21.1 6.9  7.2   69.98
    ## 1610 02337170 2011-05-28 11:30:00 2760.00       A  20.3 6.6  7.4   68.54
    ## 1611 02336410 2011-05-18 04:45:00   15.00       A  15.3 7.2  9.0   59.54
    ## 1612 02203700 2011-05-13 11:45:00    4.40       A  19.9 6.9  4.7   67.82
    ## 1613 02336360 2011-05-07 13:45:00   13.00       A  15.4 7.1  8.6   59.72
    ## 1614 02336240 2011-05-11 10:45:00   11.00       A  20.6 7.1  7.2   69.08
    ## 1615 02336360 2011-05-17 00:00:00   11.00     A e    NA 7.3  9.2      NA
    ## 1616 02336120 2011-05-08 03:00:00   17.00       A  18.6 7.1  8.2   65.48
    ## 1617 02336313 2011-05-09 20:15:00    1.00       A  23.7 7.3  8.5   74.66
    ## 1618 02336360 2011-05-24 20:15:00    9.10       A  25.7 7.5  9.0   78.26
    ## 1619 02336526 2011-05-30 11:30:00    5.50       A  22.5 7.2  7.1   72.50
    ## 1620 02336313 2011-05-08 10:15:00    1.10       A  16.1 7.2  7.7   60.98
    ## 1621 02203700 2011-05-23 08:30:00    3.90       A  21.0 6.8  4.2   69.80
    ## 1622 02336526 2011-05-04 00:30:00   67.00       A  19.5 7.0  8.1   67.10
    ## 1623 02337170 2011-05-23 02:45:00 1410.00       A  20.1 6.8  8.6   68.18
    ## 1624 02336410 2011-05-04 18:30:00   64.00       A  18.2 6.9  8.5   64.76
    ## 1625 02336240 2011-05-09 03:45:00   12.00       A  19.1 7.2  7.6   66.38
    ## 1626 02203700 2011-05-15 18:45:00    4.60       A  19.3 7.2 10.2   66.74
    ## 1627 02336410 2011-05-05 19:45:00   29.00       A  17.3 7.1  9.2   63.14
    ## 1628 02336300 2011-05-25 01:15:00   21.00       A  25.3 7.4  7.1   77.54
    ## 1629 02336120 2011-05-04 12:45:00   99.00       A  16.5 6.5  8.3   61.70
    ## 1630 02336313 2011-05-08 10:45:00    1.10     A e  16.0 7.2  7.6   60.80
    ## 1631 02336410 2011-05-08 19:15:00   21.00       A  20.2 7.2  8.9   68.36
    ## 1632 02336120 2011-05-26 23:45:00  352.00       A  22.8 6.6  7.2   73.04
    ## 1633 02336360 2011-05-17 07:30:00   11.00       A  16.1 7.1  8.4   60.98
    ## 1634 02337170 2011-05-08 08:30:00 1780.00       A  15.4 6.9   NA   59.72
    ## 1635 02336526 2011-05-13 21:00:00    3.60       A  24.2 8.3 11.6   75.56
    ## 1636 02336410 2011-05-21 01:45:00   14.00       A  20.6 7.3  7.9   69.08
    ## 1637 02336526 2011-05-13 07:00:00    3.60       A  22.8 7.3  6.1   73.04
    ## 1638 02203700 2011-05-22 21:00:00    3.90       A  26.2 7.0  8.4   79.16
    ## 1639 02336313 2011-05-23 23:45:00    0.93     A e  24.6 7.2  6.7   76.28
    ## 1640 02336410 2011-05-12 00:00:00   17.00     A e    NA 7.2  7.4      NA
    ## 1641 02336300 2011-05-08 21:00:00   33.00     A e  21.2 7.3  8.1   70.16
    ## 1642 02203655 2011-05-20 08:30:00    8.20     A e  17.7 7.0  7.5   63.86
    ## 1643 02203655 2011-05-28 06:00:00   29.00       A  21.2 6.4  7.0   70.16
    ## 1644 02336360 2011-05-16 09:00:00   11.00     A e  17.2 7.1  8.1   62.96
    ## 1645 02336120 2011-05-19 17:15:00   12.00     A e  16.7  NA  9.2   62.06
    ## 1646 02336526 2011-05-29 21:45:00    5.50     A e  26.6 7.4  8.5   79.88
    ## 1647 02336240 2011-05-11 20:30:00   11.00       A  25.3 7.3  8.6   77.54
    ## 1648 02336240 2011-05-19 14:30:00    9.90       A  15.0 7.3   NA   59.00
    ## 1649 02336120 2011-05-09 20:15:00   16.00       A  22.1 7.3  8.9   71.78
    ## 1650 02336410 2011-05-23 22:15:00   13.00       A  24.7 7.4  8.3   76.46
    ## 1651 02336360 2011-05-28 06:00:00   15.00       A  22.3 6.8  6.7   72.14
    ## 1652 02203655 2011-06-01 02:00:00    8.80     A e  25.0 7.0  6.2   77.00
    ## 1653 02203700 2011-05-18 00:45:00    4.60       A  16.2 6.9  6.3   61.16
    ## 1654 02336526 2011-05-11 10:15:00    4.00     A e  21.1 7.0  6.5   69.98
    ## 1655 02336360 2011-05-12 18:15:00   11.00     A e  24.3 7.3  9.1   75.74
    ## 1656 02336300 2011-05-17 04:30:00   27.00       A  16.8 7.5  7.9   62.24
    ## 1657 02203700 2011-05-20 10:45:00    4.00       A  16.6 6.9  5.2   61.88
    ## 1658 02336300 2011-05-25 17:15:00   19.00       A  24.6 7.4  8.3   76.28
    ## 1659 02203700 2011-05-25 00:45:00    3.50       A  24.6 6.9  5.4   76.28
    ## 1660 02336120 2011-05-27 20:15:00   98.00       A  22.4 6.5  7.2   72.32
    ## 1661 02336120 2011-05-31 00:30:00   13.00       A  26.0 7.0  6.9   78.80
    ## 1662 02336313 2011-05-28 22:15:00    0.82       A  24.9 7.3  6.0   76.82
    ## 1663 02336526 2011-05-22 16:45:00    3.60     A e  21.8 7.9  9.9   71.24
    ## 1664 02336120 2011-05-27 12:45:00  833.00     A e  20.4 6.2  7.0   68.72
    ## 1665 02336360 2011-05-30 04:15:00    7.20       A  24.3 6.9  6.5   75.74
    ## 1666 02336728 2011-05-04 06:30:00  309.00       A  17.8 6.6  8.0   64.04
    ## 1667 02203655 2011-05-02 22:00:00   11.00     A e  21.1 7.2  7.0   69.98
    ## 1668 02336313 2011-05-10 16:30:00    1.00       A  23.2 7.2  8.9   73.76
    ## 1669 02336410 2011-05-25 12:30:00   12.00       A  21.6 7.2  7.0   70.88
    ## 1670 02336728 2011-05-13 18:15:00   12.00       A  24.2 7.3  8.6   75.56
    ## 1671 02336313 2011-05-06 08:15:00    1.20       A  14.6 7.0  8.2   58.28
    ## 1672 02336120 2011-05-31 22:30:00   12.00       A    NA 7.1  7.6      NA
    ## 1673 02336526 2011-05-26 20:15:00    2.70       A  25.0 8.5 11.6   77.00
    ## 1674 02336313 2011-05-10 06:15:00    1.00       A  20.7 7.2  6.8   69.26
    ## 1675 02336300 2011-05-02 17:30:00   32.00       A  21.4 7.3  8.1   70.52
    ## 1676 02336300 2011-05-23 02:30:00   23.00     A e  24.4 7.3  6.9   75.92
    ## 1677 02336526 2011-05-06 07:15:00    5.20       A  15.5 7.0  8.3   59.90
    ## 1678 02336526 2011-05-20 14:45:00    3.60       A  17.2 7.6  8.9   62.96
    ## 1679 02336313 2011-05-15 17:45:00    1.00       A  18.7 7.3  8.9   65.66
    ## 1680 02336300 2011-05-24 19:15:00   20.00       A  25.8 7.6  8.9   78.44
    ## 1681 02336410 2011-05-07 21:45:00   22.00       A  19.1 7.1  8.8   66.38
    ## 1682 02203655 2011-05-06 04:15:00   13.00       A  17.2 7.2  7.7   62.96
    ## 1683 02336120 2011-05-28 04:15:00   46.00       A  22.1 6.6  7.0   71.78
    ## 1684 02336410 2011-05-24 06:00:00   14.00       A  22.8 7.2  6.9   73.04
    ## 1685 02203655 2011-05-29 15:30:00   12.00     A e  21.0 6.7  6.9   69.80
    ## 1686 02336300 2011-05-19 05:30:00   27.00       A    NA 7.4  8.2      NA
    ## 1687 02203655 2011-05-25 20:30:00    7.50       A  23.4 6.9  6.3   74.12
    ## 1688 02336526 2011-05-20 09:15:00    3.60       A  17.7 7.6  7.4   63.86
    ## 1689 02336120 2011-05-08 17:00:00   17.00       A  18.3 7.2  8.9   64.94
    ## 1690 02336300 2011-05-03 06:45:00   31.00       A  20.9 7.2  6.8   69.62
    ## 1691 02336728 2011-05-21 22:45:00   10.00       A  24.0 7.3  8.3   75.20
    ## 1692 02336410 2011-05-13 21:15:00   16.00       A  23.9 7.4  8.7   75.02
    ## 1693 02203700 2011-05-01 07:45:00    6.40     A e  18.0 7.0  6.7   64.40
    ## 1694 02336313 2011-05-11 22:45:00    0.98       A  25.1 7.2  7.0   77.18
    ## 1695 02336240 2011-05-28 21:15:00   19.00       A  23.8 7.0  7.2   74.84
    ## 1696 02336313 2011-05-02 21:30:00    1.00       A  23.3 7.1  6.8   73.94
    ## 1697 02336300 2011-05-15 11:45:00   27.00       A  19.1 7.4  7.1   66.38
    ## 1698 02336526 2011-05-14 18:30:00    3.80     A e  22.5 7.6 10.6   72.50
    ## 1699 02336120 2011-05-14 10:30:00   13.00       A  20.8 7.2  7.2   69.44
    ## 1700 02337170 2011-05-29 06:00:00 2150.00       A  21.5 6.8  7.4   70.70
    ## 1701 02336313 2011-05-07 14:45:00    1.10     A e  16.6 7.2  9.1   61.88
    ## 1702 02337170 2011-05-31 18:00:00 1260.00       A  24.6 6.9  7.2   76.28
    ## 1703 02203700 2011-05-20 07:00:00    4.00       A  17.6 6.8  5.0   63.68
    ## 1704 02336526 2011-05-30 12:15:00    5.20       A  22.4 7.2  7.2   72.32
    ## 1705 02337170 2011-05-28 23:45:00 2610.00       A  21.8 6.8  7.5   71.24
    ## 1706 02336313 2011-05-12 07:15:00    0.98       A  21.8 7.2  6.2   71.24
    ## 1707 02336313 2011-05-17 06:30:00    1.00       A  15.7 7.2  6.8   60.26
    ## 1708 02336360 2011-05-30 19:00:00    6.60       A  26.5 7.1  7.8   79.70
    ## 1709 02336120 2011-05-30 01:30:00   16.00       A  25.3 6.9  6.8   77.54
    ## 1710 02336360 2011-05-05 06:15:00   19.00       A  16.9 6.9  8.0   62.42
    ## 1711 02336240 2011-05-30 09:15:00   12.00       A  22.4 7.0  7.0   72.32
    ## 1712 02336300 2011-05-09 13:30:00   32.00       A  18.9 7.3  7.8   66.02
    ## 1713 02336360 2011-05-22 03:45:00    9.80       A  21.8 7.1  7.0   71.24
    ## 1714 02336240 2011-05-05 20:00:00   15.00       A  17.8 7.2  8.9   64.04
    ## 1715 02336120 2011-05-18 23:45:00   14.00       A  17.5 7.3  9.1   63.50
    ## 1716 02336313 2011-05-29 02:45:00    0.82     A e  23.5 7.4  5.8   74.30
    ## 1717 02336120 2011-05-22 09:45:00   11.00       A  20.4 7.1  7.2   68.72
    ## 1718 02336240 2011-05-16 09:15:00   10.00       A  16.7 7.3  8.0   62.06
    ## 1719 02336313 2011-05-14 03:45:00    0.93       A  22.3 7.2  6.6   72.14
    ## 1720 02336410 2011-05-28 19:00:00   25.00       A  24.1 7.1  7.6   75.38
    ## 1721 02337170 2011-05-15 21:00:00 2070.00       A  15.9 6.9  9.3   60.62
    ## 1722 02203700 2011-05-12 10:45:00    4.60       A  20.3 6.8  3.7   68.54
    ## 1723 02336728 2011-05-31 08:00:00   13.00       A  23.0 7.0  7.3   73.40
    ## 1724 02203700 2011-05-07 05:30:00    5.30       A  16.8 7.0  5.7   62.24
    ## 1725 02203700 2011-05-14 21:00:00    4.40       A  23.5 7.2  9.4   74.30
    ## 1726 02336313 2011-05-24 01:30:00    0.87     A e  24.0 7.1  6.0   75.20
    ## 1727 02336728 2011-05-02 19:15:00   16.00       A  22.6 7.2  8.6   72.68
    ## 1728 02336526 2011-05-08 07:00:00    4.60       A  17.9 7.1  7.7   64.22
    ## 1729 02203655 2011-05-03 13:30:00   11.00     A e  19.2 7.1  7.0   66.56
    ## 1730 02337170 2011-05-04 22:00:00 7360.00       A  15.3  NA  9.3   59.54
    ## 1731 02336410 2011-05-01 05:30:00   22.00       A  19.4 6.8  7.6   66.92
    ## 1732 02336728 2011-05-22 07:15:00    9.30       A  20.0 7.1  7.7   68.00
    ## 1733 02203700 2011-05-02 03:45:00    6.10     A e  20.6 7.0  6.5   69.08
    ## 1734 02336120 2011-05-13 08:00:00   13.00       A  22.0 7.1  7.0   71.60
    ## 1735 02336526 2011-05-19 13:00:00    3.80       A  14.3 7.5  8.6   57.74
    ## 1736 02337170 2011-05-14 23:45:00 5450.00       A  15.2 6.8  9.6   59.36
    ## 1737 02336240 2011-05-14 09:30:00   10.00       A  20.6 7.2  7.1   69.08
    ## 1738 02336360 2011-05-30 10:15:00    6.90       A  23.3 6.9  6.6   73.94
    ## 1739 02336300 2011-05-01 06:15:00   34.00       A  19.6 7.2  7.1   67.28
    ## 1740 02336728 2011-05-22 20:45:00    9.30       A  25.6 7.3  8.7   78.08
    ## 1741 02336360 2011-05-19 02:00:00   10.00     A e  16.3 7.2  9.0   61.34
    ## 1742 02337170 2011-05-08 04:30:00 2180.00       A  15.3 6.9  9.4   59.54
    ## 1743 02336728 2011-05-24 14:15:00    8.90     A e  21.4 7.1  8.1   70.52
    ## 1744 02336728 2011-05-24 03:30:00    8.90     A e    NA 7.1  7.2      NA
    ## 1745 02336120 2011-05-27 21:15:00   85.00       A  22.6 6.5  7.2   72.68
    ## 1746 02336410 2011-05-11 16:30:00   17.00       A  22.6 7.2  8.3   72.68
    ## 1747 02337170 2011-05-14 17:45:00 4470.00       A  15.5 6.8  9.4   59.90
    ## 1748 02336300 2011-05-19 07:45:00   26.00       A  15.7 7.4  8.2   60.26
    ## 1749 02337170 2011-05-17 03:30:00 1740.00       A  16.1 7.0  9.0   60.98
    ## 1750 02203700 2011-05-04 21:30:00   24.00       A  19.9 6.8  7.2   67.82
    ## 1751 02336120 2011-05-09 05:15:00   16.00       A  19.2 7.1  7.8   66.56
    ## 1752 02337170 2011-05-02 07:45:00 3330.00     A e  15.2 6.9   NA   59.36
    ## 1753 02336300 2011-05-23 16:15:00   22.00       A  23.2 7.5  8.2   73.76
    ## 1754 02203655 2011-05-04 10:00:00   74.00     A e  16.2 6.9  8.0   61.16
    ## 1755 02336120 2011-05-13 17:30:00   13.00       A  22.7 7.3  8.3   72.86
    ## 1756 02336526 2011-05-11 16:30:00    4.00       A  22.1 7.3  9.4   71.78
    ## 1757 02336728 2011-05-22 12:15:00    9.30       A  19.4 7.1  7.7   66.92
    ## 1758 02336120 2011-05-10 05:00:00   16.00       A    NA 7.1  7.6      NA
    ## 1759 02336526 2011-05-26 06:30:00    3.50       A  23.5 7.6  6.3   74.30
    ## 1760 02336240 2011-05-12 01:15:00   11.00       A  23.5 7.2  6.9   74.30
    ## 1761 02336120 2011-05-06 00:00:00   22.00     A e  17.7 7.0  8.6   63.86
    ## 1762 02337170 2011-05-03 04:30:00 4020.00       A  15.2 6.8 10.0   59.36
    ## 1763 02203700 2011-05-26 00:45:00    3.70       A  25.0 6.9  5.4   77.00
    ## 1764 02336410 2011-05-30 10:45:00   14.00       A  23.3 7.0  6.6   73.94
    ## 1765 02336410 2011-05-26 12:45:00   11.00       A  22.5 7.2  7.0   72.50
    ## 1766 02336728 2011-05-14 05:30:00   12.00       A  20.9 7.2  7.5   69.62
    ## 1767 02336526 2011-05-03 17:45:00    4.20       A  22.2 7.2   NA   71.96
    ## 1768 02336313 2011-05-18 02:45:00    0.98     A e  15.8 7.1  7.7   60.44
    ## 1769 02336120 2011-05-21 05:15:00   12.00       A  20.1 6.7  7.5   68.18
    ## 1770 02337170 2011-05-10 22:30:00 4340.00       A  21.0 6.8  8.3   69.80
    ## 1771 02203655 2011-05-19 15:15:00    9.20       A  15.2 7.1  9.1   59.36
    ## 1772 02336410 2011-05-31 19:00:00   11.00       A  26.9 7.2  7.7   80.42
    ## 1773 02336120 2011-05-02 12:15:00   16.00       A  19.0 7.0  7.7   66.20
    ## 1774 02336300 2011-05-24 13:45:00   21.00       A  22.2 7.4  7.1   71.96
    ## 1775 02337170 2011-05-20 17:30:00 2520.00       A  15.8 7.0  9.6   60.44
    ## 1776 02336360 2011-05-30 23:15:00    6.60       A  26.6 7.0  7.2   79.88
    ## 1777 02336728 2011-05-01 22:15:00   16.00       A  21.7 7.1  8.3   71.06
    ## 1778 02336120 2011-05-18 06:45:00   13.00     A e  14.8 7.2  8.7   58.64
    ## 1779 02336300 2011-05-06 13:45:00   39.00       A  14.7 7.3  8.5   58.46
    ## 1780 02336313 2011-05-12 18:45:00    1.00       A  25.6 7.3   NA   78.08
    ## 1781 02336120 2011-05-29 02:00:00   21.00       A  23.7 6.8  6.9   74.66
    ## 1782 02336313 2011-05-30 23:15:00    0.69       A  26.3 7.3  5.8   79.34
    ## 1783 02203700 2011-05-11 05:00:00    4.90       A  22.5 7.4  3.6   72.50
    ## 1784 02336120 2011-05-28 08:45:00   36.00     A e  21.5 6.7  7.0   70.70
    ## 1785 02336240 2011-05-22 17:00:00    8.90       A  23.0 7.3  9.3   73.40
    ## 1786 02336526 2011-05-15 06:00:00    3.60     A e  21.0 7.4  6.6   69.80
    ## 1787 02337170 2011-05-12 05:15:00 4380.00       A  16.5 6.8  9.5   61.70
    ## 1788 02336360 2011-05-21 19:15:00    9.80     A e  23.2 7.4  9.7   73.76
    ## 1789 02336120 2011-05-03 11:15:00   16.00       A  19.7 7.1  7.6   67.46
    ## 1790 02336410 2011-05-01 09:45:00   22.00       A  18.6 6.8  7.7   65.48
    ## 1791 02336313 2011-05-19 21:00:00    1.00       A  20.3 7.3  8.6   68.54
    ## 1792 02203655 2011-05-07 05:45:00   12.00       A  17.4 7.2  7.5   63.32
    ## 1793 02203700 2011-05-25 22:30:00    3.70       A  25.9 7.0  7.9   78.62
    ## 1794 02336240 2011-05-04 06:45:00  257.00     A e  17.2 6.9  8.8   62.96
    ## 1795 02336240 2011-05-31 00:45:00   11.00       A  25.1 7.0  6.9   77.18
    ## 1796 02203655 2011-05-23 01:15:00    7.80       A  23.0 7.0  6.3   73.40
    ## 1797 02336728 2011-05-27 23:30:00   70.00       A  22.1 6.7  7.5   71.78
    ## 1798 02336313 2011-05-24 21:15:00    0.93       A  24.9 7.2   NA   76.82
    ## 1799 02336526 2011-05-26 22:45:00   10.00     A e  23.8 8.4  9.7   74.84
    ## 1800 02203655 2011-05-02 08:30:00   11.00       A  19.7 7.1  6.6   67.46
    ## 1801 02336240 2011-05-05 21:30:00   15.00     A e  17.5 7.2   NA   63.50
    ## 1802 02336300 2011-05-18 22:00:00   27.00       A  18.4 7.6  9.7   65.12
    ## 1803 02336360 2011-05-21 19:30:00    9.80     A e  23.4 7.4  9.6   74.12
    ## 1804 02336410 2011-05-24 08:00:00   13.00       A  22.4 7.2  6.9   72.32
    ## 1805 02336728 2011-05-27 01:00:00  206.00       A  22.5 6.9  7.2   72.50
    ## 1806 02336120 2011-05-18 22:30:00   14.00     A e  17.8 7.3  9.3   64.04
    ## 1807 02203700 2011-05-25 23:30:00    3.70     A e  25.5  NA  6.8   77.90
    ## 1808 02336728 2011-05-04 20:45:00   40.00       A  18.7 6.9  8.6   65.66
    ## 1809 02336526 2011-05-21 23:00:00    3.50     A e  24.0 9.1 11.7   75.20
    ## 1810 02336120 2011-05-24 18:00:00   11.00       A  23.3 7.2  8.0   73.94
    ## 1811 02336313 2011-05-31 09:00:00    0.77       A  22.9 7.4  5.3   73.22
    ## 1812 02336728 2011-05-20 03:45:00   11.00       A  17.2 7.1   NA   62.96
    ## 1813 02336240 2011-05-20 22:45:00    9.20       A  21.3 7.3  8.5   70.34
    ## 1814 02336240 2011-05-11 01:30:00   11.00       A  22.9 7.1  7.0   73.22
    ## 1815 02203655 2011-05-27 01:00:00  303.00       A  22.7 6.7   NA   72.86
    ## 1816 02203655 2011-05-03 21:00:00   13.00       A  20.8 7.2  6.7   69.44
    ## 1817 02337170 2011-05-18 16:45:00 2990.00       A  13.3 7.0  9.9   55.94
    ## 1818 02336360 2011-06-01 00:45:00    7.20       A  26.3 7.1  6.9   79.34
    ## 1819 02336313 2011-05-02 13:00:00    1.00       A  18.6 7.0  6.8   65.48
    ## 1820 02336240 2011-05-30 18:15:00   12.00       A  25.8 7.1  7.8   78.44
    ## 1821 02337170 2011-05-20 20:30:00 3700.00       A  17.0 6.9  9.4   62.60
    ## 1822 02336526 2011-05-19 02:15:00    3.80     A e  17.1 8.8 10.4   62.78
    ## 1823 02336300 2011-05-10 14:00:00   30.00       A  20.5 7.3  7.7   68.90
    ## 1824 02336410 2011-05-04 13:30:00   98.00       A  16.8 6.7  8.3   62.24
    ## 1825 02336300 2011-05-24 13:30:00   21.00     A e  22.1 7.4  7.0   71.78
    ## 1826 02336120 2011-05-28 13:15:00   30.00     A e    NA 6.8  7.2      NA
    ## 1827 02203700 2011-05-11 10:15:00    4.60     A e  20.3 7.4  3.5   68.54
    ## 1828 02336360 2011-05-04 04:15:00  446.00       A  18.7 6.7  7.9   65.66
    ## 1829 02336300 2011-05-09 14:15:00   31.00       A  19.2 7.3  8.0   66.56
    ## 1830 02336120 2011-05-09 09:45:00   16.00       A  18.6 7.1  7.9   65.48
    ## 1831 02336313 2011-05-15 06:45:00    0.98       A  19.7 7.2  6.8   67.46
    ## 1832 02336360 2011-05-11 10:45:00   12.00       A  21.3 7.0  7.1   70.34
    ## 1833 02336360 2011-05-12 10:30:00   11.00       A  21.6 6.9  7.0   70.88
    ## 1834 02336360 2011-05-21 02:15:00   10.00       A  20.7 7.2  7.7   69.26
    ## 1835 02336120 2011-05-31 04:45:00   13.00       A  24.8 7.0  6.6   76.64
    ## 1836 02336728 2011-05-02 08:30:00   15.00       A  19.3 7.0  7.8   66.74
    ## 1837 02336410 2011-05-16 06:15:00   16.00       A  17.6 7.2  8.1   63.68
    ## 1838 02336360 2011-05-25 05:30:00    9.10       A  23.0 7.1  6.5   73.40
    ## 1839 02336240 2011-05-30 23:45:00   11.00       A  25.4 7.0  7.0   77.72
    ## 1840 02336360 2011-05-16 10:30:00   11.00       A  17.0 7.1  8.1   62.60
    ## 1841 02336120 2011-05-29 04:30:00   20.00       A  23.0  NA  6.8   73.40
    ## 1842 02336728 2011-05-14 18:30:00   12.00       A  22.9 7.3  8.7   73.22
    ## 1843 02337170 2011-05-21 21:30:00 3370.00       A  17.8 6.9  9.2   64.04
    ## 1844 02336526 2011-05-19 22:00:00    3.60       A  19.8 8.9 12.6   67.64
    ## 1845 02336526 2011-05-08 15:15:00    4.60       A  17.1 7.2  9.5   62.78
    ## 1846 02336240 2011-05-25 00:30:00    7.90       A  24.1 7.2  7.0   75.38
    ## 1847 02336300 2011-05-07 00:15:00   39.00       A  18.1 7.3  8.1   64.58
    ## 1848 02336526 2011-05-26 13:15:00    2.80       A  22.4 7.4  6.3   72.32
    ## 1849 02336728 2011-05-03 22:30:00   85.00     A e  20.7 7.0  8.3   69.26
    ## 1850 02336526 2011-05-10 23:00:00    5.90       A  26.0 8.4  9.5   78.80
    ## 1851 02336360 2011-05-23 18:45:00   11.00       A  24.2 7.4  9.2   75.56
    ## 1852 02336120 2011-05-17 07:00:00   13.00       A  16.1 7.2  8.3   60.98
    ## 1853 02337170 2011-05-07 01:00:00 6600.00       A  12.9 6.8 10.5   55.22
    ## 1854 02336313 2011-05-06 05:30:00    1.20       A  15.6 7.0  7.8   60.08
    ## 1855 02337170 2011-05-11 02:45:00 3840.00     A e  19.4 6.8  8.7   66.92
    ## 1856 02336120 2011-05-26 01:30:00   11.00       A  25.0 7.1  7.0   77.00
    ## 1857 02336410 2011-05-14 15:00:00   17.00       A  21.0 7.2  7.6   69.80
    ## 1858 02336526 2011-05-19 17:30:00    3.80     A e  16.8 8.0 11.4   62.24
    ## 1859 02336360 2011-05-28 17:15:00   11.00       A  23.2 7.0  7.4   73.76
    ## 1860 02336360 2011-05-14 15:30:00   11.00       A  21.0 7.2  8.2   69.80
    ## 1861 02336360 2011-05-04 14:15:00   36.00       A  16.8 6.9  8.4   62.24
    ## 1862 02336313 2011-05-31 01:15:00    0.69       A  25.7 7.3  5.4   78.26
    ## 1863 02203700 2011-05-22 22:30:00    3.90       A  26.0 7.0  7.2   78.80
    ## 1864 02336410 2011-05-23 23:30:00   14.00       A  24.3 7.3  7.9   75.74
    ## 1865 02337170 2011-05-18 17:15:00 3140.00       A  13.4 7.0  9.9   56.12
    ## 1866 02336240 2011-05-06 15:00:00   14.00     A e  15.1 7.2  8.9   59.18
    ## 1867 02336526 2011-05-10 20:00:00    6.40       A  24.8 8.0 11.0   76.64
    ## 1868 02336526 2011-05-17 16:15:00    3.80       A  15.8  NA 10.5   60.44
    ## 1869 02203700 2011-05-03 15:45:00    6.10       A  21.1 7.2 10.4   69.98
    ## 1870 02336300 2011-05-03 04:15:00   31.00       A  21.3 7.3  6.9   70.34
    ## 1871 02336728 2011-05-21 15:30:00    9.70     A e  20.1 7.2  8.8   68.18
    ## 1872 02337170 2011-05-07 07:00:00 5930.00       A  14.0 6.9 10.1   57.20
    ## 1873 02337170 2011-05-10 11:00:00 1580.00       A  20.6 6.9  7.8   69.08
    ## 1874 02336360 2011-05-23 03:00:00    9.80     A e  23.2 7.2  6.8   73.76
    ## 1875 02336410 2011-05-18 14:30:00   16.00       A  14.1 7.2  9.6   57.38
    ## 1876 02203655 2011-05-27 02:30:00  183.00     A e  22.1 6.7  7.0   71.78
    ## 1877 02336300 2011-05-01 18:15:00   34.00     A e  21.5 7.3  8.1   70.70
    ## 1878 02336728 2011-05-25 11:15:00    8.20       A  20.5 7.0  7.4   68.90
    ## 1879 02336360 2011-05-18 01:15:00   11.00       A  15.6 7.3  9.3   60.08
    ## 1880 02337170 2011-05-09 19:30:00 1340.00     A e  20.0 7.0   NA   68.00
    ## 1881 02336360 2011-05-04 16:45:00   31.00       A  17.6 7.0  8.5   63.68
    ## 1882 02336410 2011-05-24 18:00:00   12.00       A  24.1 7.4  8.7   75.38
    ## 1883 02203700 2011-05-09 20:15:00    5.10       A  24.5 7.2  8.9   76.10
    ## 1884 02336526 2011-05-12 15:15:00    3.80     A e  21.6 7.2  8.6   70.88
    ## 1885 02203700 2011-05-06 07:45:00    5.60       A  15.4 7.0  5.9   59.72
    ## 1886 02336526 2011-05-01 14:30:00    4.40       A  17.6 7.0  8.1   63.68
    ## 1887 02336728 2011-05-20 19:45:00   10.00     A e  22.4 7.3  9.2   72.32
    ## 1888 02203700 2011-05-04 08:15:00   17.00     A e  16.2 6.7  8.1   61.16
    ## 1889 02336360 2011-05-05 07:30:00   19.00     A e  16.5 6.9  8.1   61.70
    ## 1890 02336728 2011-05-14 22:30:00   12.00     A e  23.1 7.3  8.2   73.58
    ## 1891 02336728 2011-05-14 23:00:00   12.00       A  22.9 7.3  8.0   73.22
    ## 1892 02336240 2011-05-17 18:45:00   11.00       A    NA 7.4   NA      NA
    ## 1893 02336360 2011-05-21 00:00:00   10.00       A  21.5 7.3  8.4   70.70
    ## 1894 02336410 2011-05-31 07:30:00   13.00       A  24.2  NA  6.3   75.56
    ## 1895 02336240 2011-05-21 14:15:00    9.20     A e  18.7  NA  8.4   65.66
    ## 1896 02203700 2011-05-11 15:30:00    4.90     A e  22.2 7.4  9.3   71.96
    ## 1897 02336410 2011-05-25 18:15:00   11.00       A  24.6 7.4  8.6   76.28
    ## 1898 02336410 2011-05-15 23:00:00   16.00       A  18.7 7.3  8.6   65.66
    ## 1899 02336728 2011-05-17 10:00:00   13.00     A e  15.4 7.1  8.6   59.72
    ## 1900 02337170 2011-05-10 05:45:00 1350.00       A  21.2 6.9  7.8   70.16
    ## 1901 02336313 2011-05-16 07:15:00    1.00       A  16.9 7.2  7.5   62.42
    ## 1902 02203700 2011-05-01 08:45:00    6.10       A  17.6 7.0  6.7   63.68
    ## 1903 02203700 2011-05-16 04:45:00    4.40       A    NA 6.9  4.7      NA
    ## 1904 02336120 2011-05-25 20:45:00   10.00       A  25.2 7.3  8.2   77.36
    ## 1905 02336360 2011-05-27 14:45:00   65.00       A  21.0 6.6  7.4   69.80
    ## 1906 02336313 2011-05-15 17:00:00    1.00       A  18.8 7.3  8.9   65.84
    ## 1907 02337170 2011-05-04 09:15:00 6660.00     A e    NA 6.8  9.5      NA
    ## 1908 02336526 2011-05-12 07:00:00    3.60       A  23.0 7.2  6.1   73.40
    ## 1909 02336240 2011-05-07 21:00:00   13.00       A  19.7 7.3  8.8   67.46
    ## 1910 02336120 2011-05-23 19:30:00   11.00       A  23.9 7.2  8.1   75.02
    ## 1911 02336313 2011-05-12 16:00:00    1.00       A  23.8 7.2  8.8   74.84
    ## 1912 02336240 2011-05-21 17:30:00    9.20     A e  22.1 7.4  9.8   71.78
    ## 1913 02336526 2011-05-24 12:15:00    3.10     A e  21.2 7.5  6.4   70.16
    ## 1914 02336300 2011-05-18 08:00:00   28.00       A  14.6 7.5  8.2   58.28
    ## 1915 02336526 2011-05-31 10:00:00    4.80       A  23.0 7.1  6.9   73.40
    ## 1916 02336410 2011-05-03 02:15:00   21.00       A  21.5 6.8  7.0   70.70
    ## 1917 02336300 2011-05-08 08:30:00   34.00       A  17.5 7.3  7.7   63.50
    ## 1918 02337170 2011-05-08 20:00:00 1420.00       A  17.8 7.0   NA   64.04
    ## 1919 02336120 2011-05-25 12:45:00   12.00       A  21.6 7.1  7.0   70.88
    ## 1920 02336728 2011-05-27 06:45:00  340.00     A e  20.9 6.5  7.9   69.62
    ## 1921 02336360 2011-05-12 06:00:00   11.00       A  22.7 6.9  6.9   72.86
    ## 1922 02336313 2011-05-11 20:15:00    0.98       A  25.3 7.3  7.9   77.54
    ## 1923 02336410 2011-05-19 00:00:00   15.00     A e  16.6 7.4  9.6   61.88
    ## 1924 02336300 2011-05-03 14:30:00   31.00       A  20.5 7.3  7.5   68.90
    ## 1925 02336313 2011-05-13 00:30:00    0.98     A e  24.7 7.2  6.6   76.46
    ## 1926 02203655 2011-05-31 07:45:00    9.20       A  24.0 7.2  6.0   75.20
    ## 1927 02336728 2011-05-29 12:15:00   20.00       A  21.7 7.0  7.5   71.06
    ## 1928 02336313 2011-05-22 03:30:00    0.93     A e  22.1 7.2  6.2   71.78
    ## 1929 02336410 2011-05-05 05:15:00   40.00     A e  17.2 6.9  8.2   62.96
    ## 1930 02336300 2011-05-08 08:15:00   33.00       A  17.5 7.3  7.7   63.50
    ## 1931 02336410 2011-05-18 12:45:00   16.00       A  14.0 7.2  9.3   57.20
    ## 1932 02336120 2011-05-08 17:15:00   17.00       A  18.4 7.2  8.9   65.12
    ## 1933 02336313 2011-05-23 23:00:00    0.93       A  24.8 7.2  7.5   76.64
    ## 1934 02336526 2011-05-24 17:45:00    3.10       A  23.3 8.2 10.7   73.94
    ## 1935 02336240 2011-05-22 00:15:00    8.90       A  22.4 7.2  7.5   72.32
    ## 1936 02337170 2011-05-09 13:00:00 1390.00       A  18.2 6.9  8.3   64.76
    ## 1937 02336313 2011-05-10 12:30:00    1.10     A e  19.3 7.2  7.1   66.74
    ## 1938 02336240 2011-05-22 07:45:00    8.90       A  20.2 7.2  7.2   68.36
    ## 1939 02337170 2011-05-25 23:15:00 1680.00     A e    NA  NA  9.0      NA
    ## 1940 02336360 2011-05-08 17:00:00   13.00     A e  18.5 7.2  9.0   65.30
    ## 1941 02336240 2011-05-19 07:30:00    9.90       A  14.8 7.3  8.4   58.64
    ## 1942 02336526 2011-05-19 23:30:00    3.60       A  20.0 9.0 12.1   68.00
    ## 1943 02203655 2011-05-02 17:45:00   12.00       A  20.1 7.1  7.3   68.18
    ## 1944 02336410 2011-05-18 11:45:00   16.00       A  14.0 7.2  9.2   57.20
    ## 1945 02336728 2011-05-21 10:45:00    9.70       A  18.0 7.1  8.0   64.40
    ## 1946 02336300 2011-05-26 04:15:00   18.00       A  24.6 7.3  6.3   76.28
    ## 1947 02336410 2011-05-21 23:15:00   14.00       A  23.0 7.4  8.2   73.40
    ## 1948 02336240 2011-05-09 21:00:00   12.00       A  22.8 7.3  8.7   73.04
    ## 1949 02337170 2011-05-15 12:15:00 2280.00     A e  15.1 6.9  9.6   59.18
    ## 1950 02336728 2011-05-31 11:00:00   13.00       A  22.7 7.0  7.3   72.86
    ##                                              station_nm agency_cd
    ## 1    INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 2       NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 3      SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 4     WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 5    INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 6     WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 7                 CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 8    N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 9      PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 10      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 11    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 12     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 13     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 14                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 15    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 16   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 17     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 18    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 19    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 20                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 21     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 22   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 23   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 24    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 25     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 26   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 27                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 28   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 29     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 30    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 31   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 32     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 33    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 34    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 35                CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 36    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 37      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 38    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 39     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 40     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 41                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 42     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 43    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 44   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 45    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 46    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 47      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 48   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 49    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 50    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 51   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 52   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 53     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 54    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 55     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 56    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 57    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 58    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 59    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 60                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 61                CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 62     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 63    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 64   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 65      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 66     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 67    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 68     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 69     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 70    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 71                       PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 72    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 73     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 74    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 75    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 76   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 77    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 78     SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 79    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 80    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 81    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 82     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 83   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 84    S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 85    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 86    UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 87   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 88      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 89      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 90      NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 91                CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 92   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 93   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 94    NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 95   INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 96     PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 97                CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 98   N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 99    WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 100  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 101   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 102   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 103               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 104  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 105   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 106  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 107   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 108  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 109  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 110    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 111     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 112   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 113               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 114   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 115   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 116     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 117   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 118    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 119   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 120   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 121   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 122   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 123               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 124    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 125               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 126     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 127                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 128     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 129  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 130               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 131   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 132   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 133    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 134    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 135  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 136   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 137   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 138   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 139   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 140   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 141   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 142   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 143    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 144   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 145   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 146     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 147                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 148                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 149   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 150   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 151  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 152  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 153   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 154    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 155   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 156   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 157                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 158  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 159  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 160    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 161    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 162  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 163  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 164   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 165   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 166  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 167               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 168   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 169  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 170    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 171                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 172               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 173     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 174  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 175  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 176   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 177               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 178  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 179   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 180   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 181  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 182  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 183  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 184   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 185    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 186   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 187     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 188     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 189                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 190  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 191  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 192  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 193    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 194  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 195     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 196  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 197   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 198                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 199   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 200    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 201   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 202               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 203    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 204    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 205  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 206    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 207   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 208  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 209     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 210   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 211                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 212   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 213   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 214    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 215    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 216   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 217     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 218   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 219   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 220   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 221   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 222  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 223   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 224    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 225    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 226   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 227    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 228   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 229                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 230  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 231  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 232   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 233    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 234     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 235                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 236   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 237               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 238    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 239                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 240   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 241   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 242               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 243    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 244   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 245   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 246               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 247                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 248   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 249  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 250   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 251                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 252   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 253                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 254     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 255   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 256  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 257  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 258  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 259   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 260   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 261   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 262  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 263  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 264     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 265  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 266  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 267  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 268    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 269    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 270    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 271  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 272                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 273               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 274  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 275   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 276  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 277   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 278               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 279   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 280               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 281   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 282   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 283                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 284   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 285     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 286   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 287    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 288   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 289   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 290   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 291                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 292    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 293   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 294     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 295    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 296   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 297   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 298                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 299   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 300   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 301  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 302   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 303   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 304     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 305   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 306   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 307   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 308     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 309    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 310                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 311  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 312   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 313   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 314               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 315               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 316    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 317    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 318     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 319    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 320                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 321    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 322   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 323    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 324  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 325   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 326    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 327   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 328    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 329    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 330               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 331  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 332   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 333   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 334   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 335               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 336  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 337    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 338               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 339               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 340   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 341  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 342                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 343    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 344    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 345    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 346   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 347  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 348     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 349  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 350    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 351  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 352   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 353     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 354  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 355    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 356  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 357   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 358  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 359    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 360               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 361    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 362    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 363                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 364   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 365               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 366   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 367     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 368   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 369     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 370    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 371  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 372     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 373   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 374   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 375   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 376  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 377    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 378    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 379   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 380  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 381    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 382   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 383               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 384                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 385   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 386     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 387   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 388   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 389                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 390    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 391   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 392  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 393   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 394     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 395               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 396   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 397   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 398   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 399    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 400   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 401    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 402   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 403     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 404    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 405                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 406                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 407   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 408  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 409    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 410   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 411   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 412  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 413  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 414    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 415    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 416   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 417  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 418   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 419   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 420                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 421  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 422   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 423  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 424                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 425    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 426    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 427  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 428  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 429   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 430  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 431                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 432  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 433     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 434    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 435               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 436    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 437   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 438    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 439   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 440   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 441                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 442               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 443  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 444  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 445   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 446   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 447  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 448     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 449                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 450    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 451   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 452     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 453  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 454                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 455  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 456   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 457  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 458    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 459   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 460    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 461     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 462   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 463    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 464   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 465   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 466   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 467    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 468  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 469   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 470     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 471               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 472     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 473  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 474  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 475   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 476     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 477   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 478     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 479   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 480   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 481  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 482  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 483   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 484   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 485   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 486    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 487                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 488   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 489                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 490   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 491               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 492   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 493    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 494   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 495   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 496   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 497    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 498  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 499  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 500  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 501                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 502   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 503    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 504   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 505   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 506   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 507     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 508   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 509                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 510               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 511   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 512               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 513   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 514   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 515    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 516   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 517   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 518     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 519    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 520                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 521  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 522     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 523   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 524   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 525               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 526  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 527  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 528   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 529   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 530   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 531  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 532    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 533  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 534                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 535    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 536                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 537                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 538   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 539               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 540  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 541   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 542    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 543     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 544   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 545    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 546                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 547  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 548   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 549    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 550    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 551  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 552     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 553    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 554               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 555   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 556   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 557               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 558    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 559                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 560    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 561   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 562    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 563   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 564   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 565    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 566     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 567   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 568   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 569                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 570  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 571   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 572    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 573  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 574   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 575  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 576   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 577   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 578    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 579     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 580                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 581               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 582    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 583               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 584   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 585  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 586  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 587                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 588   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 589    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 590   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 591  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 592    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 593     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 594  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 595    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 596   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 597   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 598    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 599   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 600  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 601                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 602    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 603   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 604   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 605   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 606                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 607  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 608     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 609  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 610   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 611    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 612  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 613     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 614   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 615    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 616    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 617   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 618   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 619  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 620  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 621                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 622   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 623   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 624   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 625     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 626               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 627     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 628   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 629    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 630    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 631    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 632   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 633    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 634   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 635  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 636                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 637   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 638   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 639   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 640  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 641    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 642                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 643   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 644   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 645     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 646                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 647   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 648   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 649   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 650  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 651    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 652   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 653   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 654   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 655                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 656  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 657    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 658   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 659  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 660   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 661     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 662               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 663               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 664  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 665  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 666    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 667    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 668   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 669  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 670   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 671    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 672  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 673   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 674               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 675               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 676    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 677     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 678    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 679    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 680   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 681   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 682   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 683               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 684    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 685  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 686  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 687   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 688               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 689  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 690     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 691               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 692   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 693   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 694   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 695    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 696  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 697  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 698   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 699    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 700  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 701               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 702  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 703   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 704  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 705    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 706                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 707    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 708   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 709   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 710  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 711  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 712  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 713               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 714    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 715               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 716   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 717  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 718   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 719     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 720    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 721   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 722  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 723               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 724    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 725     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 726    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 727  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 728    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 729    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 730               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 731  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 732               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 733   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 734                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 735   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 736    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 737                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 738               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 739    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 740   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 741   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 742     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 743   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 744    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 745                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 746  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 747  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 748   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 749   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 750               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 751   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 752   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 753  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 754                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 755   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 756   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 757     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 758                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 759   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 760    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 761    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 762   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 763   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 764   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 765                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 766     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 767   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 768     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 769                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 770               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 771   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 772   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 773    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 774   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 775  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 776  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 777  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 778  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 779   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 780    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 781   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 782   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 783     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 784   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 785    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 786   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 787  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 788   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 789  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 790     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 791  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 792    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 793  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 794    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 795  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 796     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 797               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 798   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 799     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 800   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 801   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 802   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 803    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 804               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 805   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 806  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 807               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 808                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 809   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 810                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 811               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 812               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 813               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 814     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 815   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 816                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 817    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 818    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 819   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 820    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 821   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 822                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 823    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 824   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 825   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 826    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 827   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 828   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 829  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 830    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 831                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 832  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 833  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 834  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 835     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 836    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 837     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 838   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 839    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 840                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 841     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 842   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 843    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 844    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 845     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 846                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 847                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 848     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 849   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 850  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 851                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 852                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 853   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 854    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 855     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 856               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 857   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 858     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 859    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 860  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 861                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 862   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 863     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 864                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 865  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 866   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 867  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 868  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 869  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 870   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 871   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 872   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 873    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 874  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 875   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 876   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 877   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 878   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 879   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 880    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 881   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 882  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 883     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 884  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 885  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 886  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 887   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 888    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 889    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 890                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 891   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 892   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 893  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 894   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 895               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 896   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 897    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 898   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 899     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 900     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 901    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 902    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 903     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 904   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 905    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 906   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 907   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 908   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 909               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 910               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 911    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 912  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 913   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 914   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 915  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 916   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 917   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 918     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 919     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 920   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 921    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 922                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 923   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 924    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 925  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 926   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 927  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 928    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 929    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 930   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 931  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 932               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 933    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 934               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 935   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 936  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 937  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 938   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 939  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 940               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 941                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 942  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 943   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 944     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 945     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 946   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 947   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 948  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 949   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 950    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 951  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 952    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 953               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 954   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 955   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 956                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 957   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 958     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 959    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 960  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 961               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 962    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 963    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 964    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 965   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 966  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 967                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 968   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 969  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 970     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 971    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 972  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 973    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 974   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 975   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 976               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 977   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 978   NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 979    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 980   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 981   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 982   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 983     NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 984               CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 985   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 986   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 987    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 988   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 989    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 990  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 991    PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 992   UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 993    SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 994  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 995  INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 996  N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 997   S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 998                      PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 999   WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1000 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1001   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1002   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1003                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1004   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1005   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1006    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1007  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1008 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1009  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1010  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1011    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1012  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1013  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1014   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1015   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1016                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1017  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1018    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1019   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1020  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1021    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1022  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1023   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1024  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1025    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1026   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1027 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1028                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1029 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1030              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1031    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1032  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1033    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1034 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1035  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1036    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1037 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1038    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1039  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1040 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1041  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1042   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1043  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1044              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1045   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1046   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1047  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1048   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1049 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1050  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1051    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1052   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1053 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1054              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1055   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1056  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1057  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1058  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1059   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1060  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1061    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1062 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1063  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1064   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1065  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1066   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1067                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1068 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1069  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1070              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1071   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1072 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1073 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1074              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1075   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1076 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1077    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1078              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1079  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1080              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1081   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1082    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1083 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1084  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1085    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1086 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1087   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1088 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1089 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1090  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1091   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1092 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1093  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1094 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1095  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1096  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1097 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1098   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1099 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1100    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1101  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1102   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1103  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1104  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1105  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1106   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1107   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1108  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1109                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1110    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1111  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1112                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1113    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1114  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1115 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1116   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1117   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1118   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1119 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1120  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1121                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1122   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1123              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1124 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1125  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1126 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1127              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1128 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1129 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1130  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1131   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1132  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1133   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1134 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1135 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1136                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1137                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1138    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1139              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1140 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1141  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1142  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1143 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1144  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1145 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1146 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1147 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1148  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1149                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1150  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1151              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1152  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1153              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1154  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1155  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1156    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1157 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1158  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1159   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1160   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1161   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1162  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1163  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1164  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1165  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1166   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1167 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1168  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1169  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1170 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1171  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1172   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1173 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1174   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1175              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1176 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1177    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1178  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1179  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1180  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1181 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1182  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1183  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1184  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1185                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1186  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1187  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1188  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1189                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1190 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1191   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1192   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1193              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1194                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1195  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1196  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1197    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1198    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1199  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1200    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1201   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1202  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1203              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1204              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1205   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1206  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1207 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1208   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1209   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1210   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1211 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1212  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1213  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1214                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1215  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1216                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1217  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1218  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1219 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1220 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1221    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1222              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1223  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1224                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1225  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1226   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1227  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1228              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1229 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1230                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1231   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1232  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1233  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1234 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1235 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1236  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1237  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1238                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1239   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1240    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1241   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1242  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1243                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1244  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1245    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1246  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1247 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1248 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1249  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1250   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1251  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1252  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1253  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1254  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1255    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1256   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1257    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1258  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1259              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1260   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1261 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1262 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1263 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1264 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1265 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1266              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1267   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1268  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1269                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1270   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1271   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1272  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1273 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1274                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1275                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1276  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1277   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1278              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1279    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1280    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1281                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1282    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1283 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1284  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1285 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1286    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1287  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1288  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1289    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1290  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1291 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1292    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1293    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1294  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1295 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1296   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1297  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1298    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1299              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1300 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1301              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1302              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1303  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1304   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1305              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1306   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1307   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1308                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1309 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1310                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1311   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1312  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1313 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1314              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1315  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1316              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1317  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1318 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1319  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1320    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1321 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1322    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1323  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1324              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1325 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1326    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1327  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1328 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1329  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1330  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1331  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1332                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1333   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1334  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1335   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1336 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1337 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1338  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1339  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1340 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1341                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1342 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1343   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1344   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1345  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1346    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1347 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1348 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1349                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1350 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1351 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1352                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1353  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1354  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1355 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1356 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1357 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1358 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1359 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1360              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1361   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1362  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1363 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1364  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1365  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1366  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1367  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1368   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1369 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1370 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1371   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1372  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1373              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1374    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1375  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1376              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1377              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1378              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1379              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1380  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1381  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1382  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1383  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1384   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1385 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1386 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1387 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1388 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1389  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1390    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1391 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1392 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1393   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1394 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1395              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1396 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1397   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1398   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1399  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1400    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1401 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1402  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1403 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1404  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1405    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1406    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1407 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1408  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1409 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1410 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1411                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1412 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1413  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1414  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1415    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1416  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1417                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1418  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1419  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1420  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1421  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1422 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1423   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1424  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1425   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1426 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1427                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1428 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1429  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1430 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1431   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1432  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1433  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1434 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1435  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1436  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1437                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1438  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1439              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1440 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1441              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1442    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1443    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1444                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1445   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1446  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1447              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1448  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1449   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1450              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1451  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1452  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1453 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1454   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1455  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1456    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1457  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1458   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1459   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1460  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1461 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1462  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1463 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1464              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1465 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1466    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1467    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1468                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1469                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1470  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1471  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1472                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1473  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1474              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1475  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1476                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1477   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1478              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1479              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1480   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1481 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1482  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1483                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1484              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1485  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1486   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1487   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1488  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1489   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1490    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1491  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1492                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1493   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1494 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1495  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1496                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1497   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1498 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1499    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1500  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1501   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1502  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1503   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1504  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1505 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1506   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1507   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1508   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1509 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1510   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1511 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1512  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1513   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1514   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1515  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1516  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1517  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1518  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1519  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1520              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1521   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1522   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1523              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1524  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1525  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1526    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1527 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1528   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1529  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1530 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1531 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1532  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1533  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1534              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1535   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1536   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1537 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1538  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1539    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1540  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1541  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1542    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1543 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1544   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1545 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1546   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1547   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1548   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1549  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1550  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1551  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1552              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1553  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1554   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1555                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1556              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1557  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1558              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1559 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1560 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1561                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1562   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1563  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1564              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1565 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1566   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1567  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1568  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1569    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1570  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1571 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1572   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1573 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1574              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1575    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1576    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1577  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1578              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1579  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1580 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1581 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1582   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1583  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1584    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1585 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1586   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1587 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1588  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1589  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1590 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1591   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1592  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1593   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1594  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1595              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1596   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1597                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1598   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1599   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1600    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1601                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1602              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1603  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1604 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1605  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1606  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1607              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1608  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1609  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1610              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1611    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1612 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1613  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1614  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1615  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1616 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1617  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1618  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1619   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1620  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1621 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1622   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1623              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1624    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1625  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1626 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1627    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1628                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1629 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1630  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1631    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1632 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1633  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1634              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1635   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1636    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1637   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1638 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1639  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1640    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1641                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1642   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1643   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1644  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1645 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1646   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1647  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1648  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1649 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1650    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1651  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1652   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1653 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1654   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1655  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1656                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1657 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1658                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1659 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1660 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1661 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1662  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1663   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1664 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1665  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1666  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1667   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1668  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1669    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1670  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1671  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1672 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1673   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1674  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1675                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1676                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1677   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1678   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1679  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1680                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1681    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1682   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1683 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1684    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1685   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1686                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1687   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1688   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1689 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1690                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1691  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1692    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1693 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1694  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1695  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1696  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1697                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1698   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1699 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1700              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1701  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1702              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1703 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1704   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1705              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1706  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1707  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1708  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1709 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1710  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1711  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1712                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1713  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1714  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1715 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1716  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1717 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1718  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1719  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1720    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1721              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1722 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1723  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1724 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1725 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1726  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1727  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1728   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1729   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1730              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1731    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1732  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1733 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1734 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1735   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1736              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1737  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1738  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1739                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1740  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1741  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1742              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1743  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1744  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1745 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1746    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1747              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1748                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1749              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1750 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1751 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1752              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1753                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1754   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1755 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1756   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1757  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1758 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1759   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1760  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1761 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1762              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1763 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1764    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1765    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1766  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1767   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1768  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1769 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1770              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1771   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1772    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1773 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1774                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1775              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1776  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1777  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1778 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1779                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1780  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1781 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1782  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1783 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1784 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1785  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1786   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1787              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1788  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1789 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1790    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1791  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1792   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1793 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1794  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1795  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1796   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1797  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1798  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1799   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1800   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1801  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1802                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1803  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1804    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1805  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1806 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1807 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1808  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1809   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1810 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1811  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1812  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1813  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1814  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1815   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1816   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1817              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1818  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1819  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1820  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1821              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1822   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1823                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1824    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1825                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1826 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1827 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1828  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1829                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1830 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1831  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1832  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1833  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1834  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1835 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1836  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1837    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1838  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1839  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1840  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1841 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1842  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1843              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1844   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1845   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1846  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1847                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1848   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1849  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1850   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1851  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1852 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1853              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1854  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1855              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1856 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1857    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1858   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1859  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1860  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1861  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1862  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1863 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1864    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1865              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1866  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1867   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1868   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1869 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1870                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1871  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1872              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1873              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1874  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1875    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1876   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1877                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1878  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1879  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1880              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1881  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1882    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1883 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1884   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1885 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1886   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1887  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1888 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1889  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1890  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1891  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1892  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1893  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1894    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1895  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1896 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1897    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1898    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1899  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1900              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1901  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1902 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1903 INTRENCHMENT CR AT CONSTITUTION RD, NR ATLANTA, GA      USGS
    ## 1904 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1905  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1906  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1907              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1908   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1909  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1910 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1911  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1912  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1913   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1914                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1915   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1916    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1917                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1918              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1919 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1920  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1921  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1922  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1923    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1924                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1925  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1926   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1927  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1928  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1929    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1930                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1931    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1932 N.F. PEACHTREE CREEK, BUFORD HWY, NEAR ATLANTA, GA      USGS
    ## 1933  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1934   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1935  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1936              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1937  WOODALL CREEK AT DEFOORS FERRY RD, AT ATLANTA, GA      USGS
    ## 1938  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1939              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1940  NANCY CREEK AT RICKENBACKER DRIVE, AT ATLANTA, GA      USGS
    ## 1941  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1942   PROCTOR CREEK AT JACKSON PARKWAY, AT ATLANTA, GA      USGS
    ## 1943   SOUTH RIVER AT FORREST PARK ROAD, AT ATLANTA, GA      USGS
    ## 1944    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1945  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ## 1946                     PEACHTREE CREEK AT ATLANTA, GA      USGS
    ## 1947    NANCY CREEK AT WEST WESLEY ROAD, AT ATLANTA, GA      USGS
    ## 1948  S.F. PEACHTREE CREEK JOHNSON RD, NEAR ATLANTA, GA      USGS
    ## 1949              CHATTAHOOCHEE RIVER NEAR FAIRBURN, GA      USGS
    ## 1950  UTOY CREEK AT GREAT SOUTHWEST PKWY NR ATLANTA, GA      USGS
    ##      timeZoneOffset timeZoneAbbreviation dec_lat_va dec_lon_va       srs
    ## 1            -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 2            -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 3            -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 4            -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 5            -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 6            -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 7            -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 8            -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 9            -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 10           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 11           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 12           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 13           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 14           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 15           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 16           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 17           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 18           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 19           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 20           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 21           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 22           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 23           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 24           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 25           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 26           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 27           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 28           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 29           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 30           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 31           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 32           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 33           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 34           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 35           -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 36           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 37           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 38           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 39           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 40           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 41           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 42           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 43           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 44           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 45           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 46           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 47           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 48           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 49           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 50           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 51           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 52           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 53           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 54           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 55           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 56           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 57           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 58           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 59           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 60           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 61           -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 62           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 63           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 64           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 65           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 66           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 67           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 68           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 69           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 70           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 71           -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 72           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 73           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 74           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 75           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 76           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 77           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 78           -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 79           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 80           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 81           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 82           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 83           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 84           -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 85           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 86           -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 87           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 88           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 89           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 90           -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 91           -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 92           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 93           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 94           -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 95           -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 96           -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 97           -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 98           -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 99           -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 100          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 101          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 102          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 103          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 104          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 105          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 106          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 107          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 108          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 109          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 110          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 111          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 112          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 113          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 114          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 115          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 116          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 117          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 118          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 119          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 120          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 121          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 122          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 123          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 124          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 125          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 126          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 127          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 128          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 129          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 130          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 131          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 132          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 133          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 134          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 135          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 136          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 137          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 138          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 139          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 140          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 141          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 142          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 143          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 144          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 145          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 146          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 147          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 148          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 149          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 150          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 151          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 152          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 153          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 154          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 155          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 156          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 157          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 158          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 159          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 160          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 161          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 162          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 163          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 164          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 165          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 166          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 167          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 168          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 169          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 170          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 171          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 172          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 173          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 174          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 175          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 176          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 177          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 178          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 179          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 180          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 181          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 182          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 183          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 184          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 185          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 186          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 187          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 188          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 189          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 190          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 191          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 192          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 193          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 194          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 195          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 196          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 197          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 198          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 199          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 200          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 201          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 202          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 203          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 204          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 205          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 206          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 207          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 208          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 209          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 210          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 211          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 212          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 213          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 214          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 215          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 216          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 217          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 218          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 219          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 220          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 221          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 222          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 223          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 224          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 225          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 226          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 227          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 228          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 229          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 230          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 231          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 232          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 233          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 234          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 235          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 236          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 237          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 238          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 239          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 240          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 241          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 242          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 243          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 244          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 245          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 246          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 247          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 248          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 249          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 250          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 251          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 252          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 253          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 254          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 255          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 256          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 257          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 258          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 259          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 260          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 261          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 262          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 263          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 264          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 265          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 266          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 267          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 268          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 269          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 270          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 271          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 272          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 273          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 274          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 275          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 276          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 277          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 278          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 279          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 280          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 281          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 282          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 283          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 284          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 285          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 286          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 287          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 288          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 289          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 290          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 291          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 292          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 293          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 294          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 295          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 296          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 297          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 298          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 299          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 300          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 301          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 302          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 303          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 304          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 305          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 306          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 307          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 308          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 309          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 310          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 311          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 312          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 313          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 314          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 315          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 316          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 317          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 318          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 319          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 320          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 321          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 322          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 323          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 324          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 325          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 326          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 327          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 328          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 329          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 330          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 331          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 332          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 333          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 334          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 335          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 336          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 337          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 338          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 339          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 340          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 341          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 342          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 343          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 344          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 345          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 346          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 347          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 348          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 349          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 350          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 351          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 352          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 353          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 354          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 355          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 356          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 357          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 358          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 359          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 360          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 361          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 362          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 363          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 364          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 365          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 366          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 367          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 368          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 369          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 370          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 371          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 372          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 373          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 374          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 375          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 376          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 377          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 378          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 379          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 380          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 381          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 382          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 383          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 384          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 385          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 386          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 387          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 388          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 389          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 390          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 391          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 392          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 393          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 394          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 395          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 396          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 397          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 398          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 399          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 400          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 401          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 402          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 403          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 404          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 405          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 406          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 407          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 408          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 409          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 410          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 411          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 412          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 413          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 414          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 415          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 416          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 417          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 418          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 419          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 420          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 421          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 422          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 423          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 424          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 425          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 426          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 427          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 428          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 429          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 430          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 431          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 432          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 433          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 434          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 435          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 436          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 437          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 438          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 439          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 440          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 441          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 442          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 443          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 444          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 445          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 446          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 447          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 448          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 449          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 450          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 451          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 452          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 453          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 454          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 455          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 456          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 457          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 458          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 459          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 460          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 461          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 462          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 463          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 464          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 465          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 466          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 467          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 468          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 469          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 470          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 471          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 472          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 473          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 474          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 475          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 476          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 477          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 478          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 479          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 480          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 481          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 482          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 483          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 484          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 485          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 486          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 487          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 488          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 489          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 490          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 491          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 492          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 493          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 494          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 495          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 496          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 497          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 498          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 499          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 500          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 501          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 502          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 503          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 504          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 505          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 506          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 507          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 508          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 509          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 510          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 511          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 512          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 513          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 514          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 515          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 516          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 517          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 518          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 519          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 520          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 521          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 522          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 523          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 524          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 525          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 526          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 527          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 528          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 529          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 530          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 531          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 532          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 533          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 534          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 535          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 536          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 537          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 538          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 539          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 540          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 541          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 542          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 543          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 544          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 545          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 546          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 547          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 548          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 549          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 550          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 551          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 552          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 553          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 554          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 555          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 556          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 557          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 558          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 559          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 560          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 561          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 562          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 563          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 564          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 565          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 566          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 567          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 568          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 569          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 570          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 571          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 572          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 573          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 574          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 575          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 576          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 577          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 578          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 579          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 580          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 581          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 582          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 583          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 584          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 585          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 586          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 587          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 588          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 589          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 590          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 591          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 592          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 593          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 594          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 595          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 596          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 597          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 598          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 599          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 600          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 601          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 602          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 603          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 604          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 605          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 606          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 607          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 608          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 609          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 610          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 611          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 612          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 613          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 614          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 615          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 616          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 617          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 618          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 619          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 620          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 621          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 622          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 623          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 624          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 625          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 626          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 627          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 628          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 629          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 630          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 631          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 632          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 633          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 634          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 635          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 636          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 637          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 638          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 639          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 640          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 641          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 642          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 643          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 644          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 645          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 646          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 647          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 648          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 649          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 650          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 651          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 652          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 653          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 654          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 655          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 656          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 657          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 658          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 659          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 660          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 661          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 662          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 663          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 664          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 665          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 666          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 667          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 668          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 669          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 670          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 671          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 672          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 673          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 674          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 675          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 676          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 677          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 678          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 679          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 680          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 681          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 682          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 683          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 684          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 685          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 686          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 687          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 688          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 689          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 690          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 691          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 692          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 693          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 694          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 695          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 696          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 697          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 698          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 699          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 700          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 701          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 702          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 703          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 704          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 705          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 706          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 707          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 708          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 709          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 710          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 711          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 712          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 713          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 714          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 715          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 716          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 717          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 718          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 719          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 720          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 721          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 722          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 723          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 724          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 725          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 726          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 727          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 728          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 729          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 730          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 731          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 732          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 733          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 734          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 735          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 736          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 737          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 738          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 739          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 740          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 741          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 742          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 743          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 744          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 745          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 746          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 747          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 748          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 749          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 750          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 751          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 752          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 753          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 754          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 755          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 756          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 757          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 758          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 759          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 760          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 761          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 762          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 763          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 764          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 765          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 766          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 767          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 768          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 769          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 770          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 771          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 772          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 773          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 774          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 775          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 776          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 777          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 778          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 779          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 780          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 781          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 782          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 783          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 784          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 785          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 786          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 787          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 788          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 789          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 790          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 791          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 792          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 793          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 794          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 795          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 796          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 797          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 798          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 799          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 800          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 801          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 802          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 803          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 804          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 805          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 806          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 807          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 808          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 809          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 810          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 811          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 812          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 813          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 814          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 815          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 816          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 817          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 818          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 819          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 820          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 821          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 822          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 823          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 824          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 825          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 826          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 827          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 828          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 829          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 830          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 831          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 832          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 833          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 834          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 835          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 836          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 837          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 838          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 839          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 840          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 841          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 842          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 843          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 844          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 845          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 846          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 847          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 848          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 849          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 850          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 851          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 852          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 853          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 854          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 855          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 856          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 857          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 858          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 859          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 860          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 861          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 862          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 863          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 864          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 865          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 866          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 867          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 868          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 869          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 870          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 871          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 872          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 873          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 874          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 875          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 876          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 877          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 878          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 879          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 880          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 881          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 882          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 883          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 884          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 885          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 886          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 887          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 888          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 889          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 890          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 891          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 892          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 893          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 894          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 895          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 896          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 897          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 898          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 899          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 900          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 901          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 902          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 903          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 904          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 905          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 906          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 907          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 908          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 909          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 910          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 911          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 912          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 913          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 914          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 915          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 916          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 917          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 918          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 919          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 920          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 921          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 922          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 923          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 924          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 925          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 926          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 927          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 928          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 929          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 930          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 931          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 932          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 933          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 934          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 935          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 936          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 937          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 938          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 939          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 940          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 941          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 942          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 943          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 944          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 945          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 946          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 947          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 948          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 949          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 950          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 951          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 952          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 953          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 954          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 955          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 956          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 957          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 958          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 959          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 960          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 961          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 962          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 963          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 964          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 965          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 966          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 967          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 968          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 969          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 970          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 971          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 972          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 973          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 974          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 975          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 976          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 977          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 978          -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 979          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 980          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 981          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 982          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 983          -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 984          -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 985          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 986          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 987          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 988          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 989          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 990          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 991          -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 992          -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 993          -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 994          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 995          -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 996          -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 997          -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 998          -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 999          -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1000         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1001         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1002         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1003         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1004         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1005         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1006         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1007         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1008         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1009         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1010         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1011         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1012         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1013         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1014         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1015         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1016         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1017         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1018         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1019         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1020         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1021         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1022         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1023         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1024         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1025         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1026         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1027         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1028         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1029         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1030         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1031         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1032         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1033         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1034         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1035         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1036         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1037         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1038         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1039         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1040         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1041         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1042         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1043         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1044         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1045         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1046         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1047         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1048         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1049         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1050         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1051         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1052         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1053         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1054         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1055         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1056         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1057         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1058         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1059         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1060         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1061         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1062         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1063         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1064         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1065         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1066         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1067         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1068         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1069         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1070         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1071         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1072         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1073         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1074         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1075         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1076         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1077         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1078         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1079         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1080         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1081         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1082         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1083         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1084         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1085         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1086         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1087         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1088         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1089         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1090         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1091         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1092         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1093         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1094         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1095         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1096         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1097         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1098         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1099         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1100         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1101         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1102         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1103         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1104         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1105         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1106         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1107         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1108         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1109         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1110         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1111         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1112         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1113         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1114         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1115         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1116         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1117         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1118         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1119         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1120         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1121         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1122         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1123         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1124         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1125         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1126         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1127         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1128         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1129         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1130         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1131         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1132         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1133         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1134         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1135         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1136         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1137         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1138         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1139         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1140         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1141         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1142         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1143         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1144         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1145         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1146         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1147         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1148         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1149         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1150         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1151         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1152         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1153         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1154         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1155         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1156         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1157         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1158         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1159         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1160         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1161         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1162         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1163         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1164         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1165         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1166         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1167         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1168         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1169         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1170         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1171         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1172         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1173         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1174         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1175         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1176         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1177         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1178         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1179         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1180         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1181         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1182         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1183         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1184         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1185         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1186         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1187         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1188         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1189         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1190         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1191         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1192         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1193         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1194         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1195         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1196         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1197         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1198         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1199         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1200         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1201         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1202         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1203         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1204         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1205         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1206         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1207         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1208         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1209         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1210         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1211         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1212         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1213         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1214         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1215         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1216         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1217         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1218         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1219         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1220         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1221         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1222         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1223         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1224         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1225         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1226         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1227         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1228         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1229         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1230         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1231         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1232         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1233         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1234         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1235         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1236         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1237         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1238         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1239         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1240         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1241         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1242         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1243         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1244         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1245         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1246         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1247         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1248         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1249         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1250         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1251         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1252         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1253         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1254         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1255         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1256         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1257         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1258         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1259         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1260         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1261         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1262         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1263         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1264         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1265         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1266         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1267         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1268         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1269         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1270         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1271         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1272         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1273         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1274         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1275         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1276         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1277         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1278         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1279         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1280         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1281         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1282         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1283         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1284         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1285         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1286         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1287         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1288         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1289         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1290         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1291         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1292         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1293         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1294         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1295         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1296         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1297         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1298         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1299         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1300         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1301         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1302         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1303         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1304         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1305         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1306         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1307         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1308         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1309         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1310         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1311         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1312         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1313         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1314         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1315         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1316         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1317         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1318         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1319         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1320         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1321         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1322         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1323         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1324         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1325         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1326         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1327         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1328         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1329         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1330         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1331         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1332         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1333         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1334         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1335         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1336         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1337         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1338         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1339         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1340         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1341         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1342         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1343         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1344         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1345         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1346         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1347         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1348         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1349         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1350         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1351         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1352         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1353         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1354         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1355         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1356         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1357         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1358         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1359         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1360         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1361         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1362         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1363         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1364         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1365         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1366         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1367         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1368         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1369         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1370         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1371         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1372         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1373         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1374         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1375         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1376         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1377         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1378         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1379         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1380         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1381         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1382         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1383         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1384         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1385         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1386         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1387         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1388         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1389         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1390         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1391         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1392         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1393         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1394         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1395         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1396         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1397         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1398         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1399         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1400         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1401         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1402         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1403         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1404         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1405         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1406         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1407         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1408         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1409         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1410         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1411         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1412         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1413         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1414         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1415         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1416         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1417         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1418         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1419         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1420         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1421         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1422         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1423         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1424         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1425         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1426         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1427         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1428         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1429         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1430         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1431         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1432         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1433         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1434         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1435         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1436         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1437         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1438         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1439         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1440         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1441         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1442         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1443         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1444         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1445         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1446         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1447         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1448         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1449         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1450         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1451         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1452         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1453         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1454         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1455         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1456         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1457         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1458         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1459         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1460         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1461         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1462         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1463         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1464         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1465         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1466         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1467         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1468         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1469         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1470         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1471         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1472         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1473         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1474         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1475         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1476         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1477         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1478         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1479         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1480         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1481         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1482         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1483         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1484         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1485         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1486         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1487         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1488         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1489         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1490         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1491         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1492         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1493         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1494         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1495         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1496         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1497         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1498         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1499         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1500         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1501         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1502         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1503         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1504         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1505         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1506         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1507         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1508         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1509         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1510         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1511         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1512         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1513         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1514         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1515         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1516         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1517         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1518         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1519         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1520         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1521         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1522         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1523         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1524         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1525         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1526         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1527         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1528         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1529         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1530         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1531         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1532         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1533         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1534         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1535         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1536         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1537         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1538         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1539         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1540         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1541         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1542         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1543         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1544         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1545         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1546         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1547         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1548         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1549         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1550         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1551         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1552         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1553         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1554         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1555         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1556         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1557         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1558         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1559         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1560         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1561         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1562         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1563         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1564         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1565         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1566         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1567         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1568         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1569         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1570         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1571         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1572         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1573         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1574         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1575         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1576         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1577         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1578         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1579         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1580         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1581         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1582         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1583         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1584         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1585         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1586         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1587         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1588         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1589         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1590         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1591         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1592         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1593         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1594         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1595         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1596         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1597         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1598         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1599         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1600         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1601         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1602         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1603         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1604         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1605         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1606         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1607         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1608         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1609         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1610         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1611         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1612         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1613         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1614         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1615         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1616         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1617         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1618         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1619         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1620         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1621         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1622         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1623         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1624         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1625         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1626         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1627         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1628         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1629         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1630         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1631         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1632         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1633         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1634         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1635         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1636         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1637         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1638         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1639         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1640         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1641         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1642         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1643         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1644         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1645         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1646         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1647         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1648         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1649         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1650         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1651         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1652         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1653         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1654         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1655         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1656         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1657         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1658         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1659         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1660         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1661         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1662         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1663         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1664         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1665         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1666         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1667         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1668         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1669         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1670         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1671         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1672         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1673         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1674         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1675         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1676         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1677         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1678         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1679         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1680         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1681         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1682         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1683         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1684         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1685         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1686         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1687         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1688         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1689         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1690         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1691         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1692         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1693         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1694         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1695         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1696         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1697         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1698         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1699         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1700         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1701         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1702         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1703         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1704         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1705         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1706         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1707         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1708         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1709         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1710         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1711         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1712         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1713         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1714         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1715         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1716         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1717         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1718         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1719         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1720         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1721         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1722         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1723         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1724         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1725         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1726         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1727         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1728         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1729         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1730         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1731         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1732         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1733         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1734         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1735         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1736         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1737         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1738         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1739         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1740         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1741         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1742         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1743         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1744         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1745         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1746         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1747         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1748         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1749         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1750         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1751         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1752         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1753         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1754         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1755         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1756         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1757         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1758         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1759         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1760         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1761         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1762         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1763         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1764         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1765         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1766         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1767         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1768         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1769         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1770         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1771         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1772         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1773         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1774         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1775         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1776         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1777         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1778         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1779         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1780         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1781         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1782         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1783         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1784         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1785         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1786         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1787         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1788         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1789         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1790         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1791         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1792         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1793         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1794         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1795         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1796         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1797         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1798         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1799         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1800         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1801         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1802         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1803         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1804         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1805         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1806         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1807         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1808         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1809         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1810         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1811         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1812         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1813         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1814         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1815         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1816         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1817         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1818         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1819         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1820         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1821         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1822         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1823         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1824         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1825         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1826         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1827         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1828         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1829         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1830         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1831         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1832         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1833         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1834         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1835         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1836         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1837         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1838         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1839         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1840         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1841         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1842         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1843         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1844         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1845         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1846         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1847         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1848         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1849         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1850         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1851         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1852         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1853         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1854         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1855         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1856         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1857         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1858         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1859         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1860         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1861         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1862         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1863         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1864         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1865         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1866         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1867         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1868         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1869         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1870         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1871         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1872         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1873         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1874         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1875         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1876         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1877         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1878         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1879         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1880         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1881         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1882         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1883         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1884         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1885         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1886         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1887         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1888         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1889         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1890         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1891         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1892         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1893         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1894         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1895         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1896         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1897         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1898         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1899         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1900         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1901         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1902         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1903         -05:00                  EST   33.68900  -84.33048 EPSG:4326
    ## 1904         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1905         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1906         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1907         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1908         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1909         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1910         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1911         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1912         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1913         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1914         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1915         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1916         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1917         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1918         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1919         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1920         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1921         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1922         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1923         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1924         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1925         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1926         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1927         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1928         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1929         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1930         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1931         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1932         -05:00                  EST   33.83149  -84.34270 EPSG:4326
    ## 1933         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1934         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1935         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1936         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1937         -05:00                  EST   33.82177  -84.43882 EPSG:4326
    ## 1938         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1939         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1940         -05:00                  EST   33.86917  -84.37889 EPSG:4326
    ## 1941         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1942         -05:00                  EST   33.79427  -84.47437 EPSG:4326
    ## 1943         -05:00                  EST   33.67900  -84.35798 EPSG:4326
    ## 1944         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1945         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ## 1946         -05:00                  EST   33.82031  -84.40764 EPSG:4326
    ## 1947         -05:00                  EST   33.83844  -84.43937 EPSG:4326
    ## 1948         -05:00                  EST   33.80288  -84.34076 EPSG:4326
    ## 1949         -05:00                  EST   33.65667  -84.67361 EPSG:4326
    ## 1950         -05:00                  EST   33.74344  -84.56827 EPSG:4326
    ##      siteTypeCd   hucCd stateCd countyCd network
    ## 1            ST 3070103      13    13089    NWIS
    ## 2            ST 3130001      13    13121    NWIS
    ## 3            ST 3070103      13    13121    NWIS
    ## 4            ST 3130001      13    13121    NWIS
    ## 5            ST 3070103      13    13089    NWIS
    ## 6            ST 3130001      13    13121    NWIS
    ## 7            ST 3130002      13    13121    NWIS
    ## 8            ST 3130001      13    13089    NWIS
    ## 9            ST 3130002      13    13121    NWIS
    ## 10           ST 3130001      13    13121    NWIS
    ## 11           ST 3130001      13    13121    NWIS
    ## 12           ST 3130002      13    13121    NWIS
    ## 13           ST 3130002      13    13121    NWIS
    ## 14           ST 3130001      13    13121    NWIS
    ## 15           ST 3130001      13    13121    NWIS
    ## 16           ST 3130001      13    13089    NWIS
    ## 17           ST 3070103      13    13121    NWIS
    ## 18           ST 3130002      13    13121    NWIS
    ## 19           ST 3130002      13    13121    NWIS
    ## 20           ST 3130001      13    13121    NWIS
    ## 21           ST 3130002      13    13121    NWIS
    ## 22           ST 3070103      13    13089    NWIS
    ## 23           ST 3130001      13    13089    NWIS
    ## 24           ST 3130001      13    13089    NWIS
    ## 25           ST 3070103      13    13121    NWIS
    ## 26           ST 3130001      13    13089    NWIS
    ## 27           ST 3130001      13    13121    NWIS
    ## 28           ST 3070103      13    13089    NWIS
    ## 29           ST 3070103      13    13121    NWIS
    ## 30           ST 3130001      13    13121    NWIS
    ## 31           ST 3070103      13    13089    NWIS
    ## 32           ST 3070103      13    13121    NWIS
    ## 33           ST 3130001      13    13121    NWIS
    ## 34           ST 3130001      13    13089    NWIS
    ## 35           ST 3130002      13    13121    NWIS
    ## 36           ST 3130001      13    13121    NWIS
    ## 37           ST 3130001      13    13121    NWIS
    ## 38           ST 3130001      13    13121    NWIS
    ## 39           ST 3130002      13    13121    NWIS
    ## 40           ST 3130002      13    13121    NWIS
    ## 41           ST 3130001      13    13121    NWIS
    ## 42           ST 3070103      13    13121    NWIS
    ## 43           ST 3130001      13    13089    NWIS
    ## 44           ST 3130001      13    13089    NWIS
    ## 45           ST 3130002      13    13121    NWIS
    ## 46           ST 3130001      13    13121    NWIS
    ## 47           ST 3130001      13    13121    NWIS
    ## 48           ST 3130001      13    13089    NWIS
    ## 49           ST 3130001      13    13121    NWIS
    ## 50           ST 3130001      13    13121    NWIS
    ## 51           ST 3070103      13    13089    NWIS
    ## 52           ST 3070103      13    13089    NWIS
    ## 53           ST 3070103      13    13121    NWIS
    ## 54           ST 3130001      13    13121    NWIS
    ## 55           ST 3070103      13    13121    NWIS
    ## 56           ST 3130001      13    13121    NWIS
    ## 57           ST 3130001      13    13121    NWIS
    ## 58           ST 3130001      13    13121    NWIS
    ## 59           ST 3130001      13    13121    NWIS
    ## 60           ST 3130001      13    13121    NWIS
    ## 61           ST 3130002      13    13121    NWIS
    ## 62           ST 3070103      13    13121    NWIS
    ## 63           ST 3130001      13    13089    NWIS
    ## 64           ST 3070103      13    13089    NWIS
    ## 65           ST 3130001      13    13121    NWIS
    ## 66           ST 3130002      13    13121    NWIS
    ## 67           ST 3130001      13    13089    NWIS
    ## 68           ST 3070103      13    13121    NWIS
    ## 69           ST 3130002      13    13121    NWIS
    ## 70           ST 3130001      13    13089    NWIS
    ## 71           ST 3130001      13    13121    NWIS
    ## 72           ST 3130001      13    13121    NWIS
    ## 73           ST 3130002      13    13121    NWIS
    ## 74           ST 3130001      13    13089    NWIS
    ## 75           ST 3130001      13    13089    NWIS
    ## 76           ST 3070103      13    13089    NWIS
    ## 77           ST 3130001      13    13121    NWIS
    ## 78           ST 3070103      13    13121    NWIS
    ## 79           ST 3130001      13    13121    NWIS
    ## 80           ST 3130002      13    13121    NWIS
    ## 81           ST 3130001      13    13121    NWIS
    ## 82           ST 3130002      13    13121    NWIS
    ## 83           ST 3130001      13    13089    NWIS
    ## 84           ST 3130001      13    13089    NWIS
    ## 85           ST 3130002      13    13121    NWIS
    ## 86           ST 3130002      13    13121    NWIS
    ## 87           ST 3070103      13    13089    NWIS
    ## 88           ST 3130001      13    13121    NWIS
    ## 89           ST 3130001      13    13121    NWIS
    ## 90           ST 3130001      13    13121    NWIS
    ## 91           ST 3130002      13    13121    NWIS
    ## 92           ST 3070103      13    13089    NWIS
    ## 93           ST 3130001      13    13089    NWIS
    ## 94           ST 3130001      13    13121    NWIS
    ## 95           ST 3070103      13    13089    NWIS
    ## 96           ST 3130002      13    13121    NWIS
    ## 97           ST 3130002      13    13121    NWIS
    ## 98           ST 3130001      13    13089    NWIS
    ## 99           ST 3130001      13    13121    NWIS
    ## 100          ST 3130001      13    13089    NWIS
    ## 101          ST 3130001      13    13089    NWIS
    ## 102          ST 3130001      13    13121    NWIS
    ## 103          ST 3130002      13    13121    NWIS
    ## 104          ST 3070103      13    13089    NWIS
    ## 105          ST 3130001      13    13121    NWIS
    ## 106          ST 3130001      13    13089    NWIS
    ## 107          ST 3130001      13    13121    NWIS
    ## 108          ST 3130001      13    13089    NWIS
    ## 109          ST 3130001      13    13089    NWIS
    ## 110          ST 3130002      13    13121    NWIS
    ## 111          ST 3130001      13    13121    NWIS
    ## 112          ST 3130001      13    13089    NWIS
    ## 113          ST 3130002      13    13121    NWIS
    ## 114          ST 3130001      13    13121    NWIS
    ## 115          ST 3130002      13    13121    NWIS
    ## 116          ST 3130001      13    13121    NWIS
    ## 117          ST 3130001      13    13121    NWIS
    ## 118          ST 3070103      13    13121    NWIS
    ## 119          ST 3130001      13    13121    NWIS
    ## 120          ST 3130002      13    13121    NWIS
    ## 121          ST 3130001      13    13121    NWIS
    ## 122          ST 3130001      13    13121    NWIS
    ## 123          ST 3130002      13    13121    NWIS
    ## 124          ST 3130002      13    13121    NWIS
    ## 125          ST 3130002      13    13121    NWIS
    ## 126          ST 3130001      13    13121    NWIS
    ## 127          ST 3130001      13    13121    NWIS
    ## 128          ST 3130001      13    13121    NWIS
    ## 129          ST 3130001      13    13089    NWIS
    ## 130          ST 3130002      13    13121    NWIS
    ## 131          ST 3130002      13    13121    NWIS
    ## 132          ST 3130001      13    13121    NWIS
    ## 133          ST 3070103      13    13121    NWIS
    ## 134          ST 3130002      13    13121    NWIS
    ## 135          ST 3130001      13    13089    NWIS
    ## 136          ST 3130001      13    13089    NWIS
    ## 137          ST 3130001      13    13089    NWIS
    ## 138          ST 3130001      13    13089    NWIS
    ## 139          ST 3130001      13    13121    NWIS
    ## 140          ST 3130002      13    13121    NWIS
    ## 141          ST 3130002      13    13121    NWIS
    ## 142          ST 3130001      13    13089    NWIS
    ## 143          ST 3130002      13    13121    NWIS
    ## 144          ST 3130001      13    13121    NWIS
    ## 145          ST 3130001      13    13089    NWIS
    ## 146          ST 3130001      13    13121    NWIS
    ## 147          ST 3130001      13    13121    NWIS
    ## 148          ST 3130001      13    13121    NWIS
    ## 149          ST 3130002      13    13121    NWIS
    ## 150          ST 3130001      13    13121    NWIS
    ## 151          ST 3130001      13    13089    NWIS
    ## 152          ST 3070103      13    13089    NWIS
    ## 153          ST 3130001      13    13121    NWIS
    ## 154          ST 3130002      13    13121    NWIS
    ## 155          ST 3130001      13    13121    NWIS
    ## 156          ST 3130002      13    13121    NWIS
    ## 157          ST 3130001      13    13121    NWIS
    ## 158          ST 3130001      13    13089    NWIS
    ## 159          ST 3070103      13    13089    NWIS
    ## 160          ST 3070103      13    13121    NWIS
    ## 161          ST 3070103      13    13121    NWIS
    ## 162          ST 3130001      13    13089    NWIS
    ## 163          ST 3070103      13    13089    NWIS
    ## 164          ST 3130001      13    13121    NWIS
    ## 165          ST 3130001      13    13121    NWIS
    ## 166          ST 3130001      13    13089    NWIS
    ## 167          ST 3130002      13    13121    NWIS
    ## 168          ST 3130001      13    13089    NWIS
    ## 169          ST 3130001      13    13089    NWIS
    ## 170          ST 3070103      13    13121    NWIS
    ## 171          ST 3130001      13    13121    NWIS
    ## 172          ST 3130002      13    13121    NWIS
    ## 173          ST 3130001      13    13121    NWIS
    ## 174          ST 3070103      13    13089    NWIS
    ## 175          ST 3130001      13    13089    NWIS
    ## 176          ST 3130001      13    13089    NWIS
    ## 177          ST 3130002      13    13121    NWIS
    ## 178          ST 3070103      13    13089    NWIS
    ## 179          ST 3130001      13    13121    NWIS
    ## 180          ST 3130002      13    13121    NWIS
    ## 181          ST 3130001      13    13089    NWIS
    ## 182          ST 3130001      13    13089    NWIS
    ## 183          ST 3130001      13    13089    NWIS
    ## 184          ST 3130001      13    13089    NWIS
    ## 185          ST 3070103      13    13121    NWIS
    ## 186          ST 3130001      13    13121    NWIS
    ## 187          ST 3130001      13    13121    NWIS
    ## 188          ST 3130001      13    13121    NWIS
    ## 189          ST 3130001      13    13121    NWIS
    ## 190          ST 3130001      13    13089    NWIS
    ## 191          ST 3130001      13    13089    NWIS
    ## 192          ST 3130001      13    13089    NWIS
    ## 193          ST 3130002      13    13121    NWIS
    ## 194          ST 3130001      13    13089    NWIS
    ## 195          ST 3130001      13    13121    NWIS
    ## 196          ST 3130001      13    13089    NWIS
    ## 197          ST 3130001      13    13121    NWIS
    ## 198          ST 3130001      13    13121    NWIS
    ## 199          ST 3130001      13    13121    NWIS
    ## 200          ST 3130002      13    13121    NWIS
    ## 201          ST 3130001      13    13121    NWIS
    ## 202          ST 3130002      13    13121    NWIS
    ## 203          ST 3070103      13    13121    NWIS
    ## 204          ST 3070103      13    13121    NWIS
    ## 205          ST 3070103      13    13089    NWIS
    ## 206          ST 3130002      13    13121    NWIS
    ## 207          ST 3130001      13    13121    NWIS
    ## 208          ST 3070103      13    13089    NWIS
    ## 209          ST 3130001      13    13121    NWIS
    ## 210          ST 3130001      13    13121    NWIS
    ## 211          ST 3130001      13    13121    NWIS
    ## 212          ST 3130002      13    13121    NWIS
    ## 213          ST 3130002      13    13121    NWIS
    ## 214          ST 3130002      13    13121    NWIS
    ## 215          ST 3070103      13    13121    NWIS
    ## 216          ST 3130001      13    13089    NWIS
    ## 217          ST 3130001      13    13121    NWIS
    ## 218          ST 3130002      13    13121    NWIS
    ## 219          ST 3130001      13    13121    NWIS
    ## 220          ST 3130001      13    13121    NWIS
    ## 221          ST 3130001      13    13089    NWIS
    ## 222          ST 3130001      13    13089    NWIS
    ## 223          ST 3130001      13    13121    NWIS
    ## 224          ST 3130002      13    13121    NWIS
    ## 225          ST 3130002      13    13121    NWIS
    ## 226          ST 3130001      13    13121    NWIS
    ## 227          ST 3070103      13    13121    NWIS
    ## 228          ST 3130001      13    13089    NWIS
    ## 229          ST 3130001      13    13121    NWIS
    ## 230          ST 3130001      13    13089    NWIS
    ## 231          ST 3070103      13    13089    NWIS
    ## 232          ST 3130002      13    13121    NWIS
    ## 233          ST 3130002      13    13121    NWIS
    ## 234          ST 3130001      13    13121    NWIS
    ## 235          ST 3130001      13    13121    NWIS
    ## 236          ST 3130001      13    13121    NWIS
    ## 237          ST 3130002      13    13121    NWIS
    ## 238          ST 3130002      13    13121    NWIS
    ## 239          ST 3130001      13    13121    NWIS
    ## 240          ST 3130002      13    13121    NWIS
    ## 241          ST 3130001      13    13089    NWIS
    ## 242          ST 3130002      13    13121    NWIS
    ## 243          ST 3130002      13    13121    NWIS
    ## 244          ST 3130001      13    13089    NWIS
    ## 245          ST 3130001      13    13121    NWIS
    ## 246          ST 3130002      13    13121    NWIS
    ## 247          ST 3130001      13    13121    NWIS
    ## 248          ST 3130002      13    13121    NWIS
    ## 249          ST 3130001      13    13089    NWIS
    ## 250          ST 3130002      13    13121    NWIS
    ## 251          ST 3130001      13    13121    NWIS
    ## 252          ST 3130001      13    13089    NWIS
    ## 253          ST 3130001      13    13121    NWIS
    ## 254          ST 3130001      13    13121    NWIS
    ## 255          ST 3130001      13    13121    NWIS
    ## 256          ST 3130001      13    13089    NWIS
    ## 257          ST 3130001      13    13089    NWIS
    ## 258          ST 3130001      13    13089    NWIS
    ## 259          ST 3130001      13    13121    NWIS
    ## 260          ST 3130001      13    13121    NWIS
    ## 261          ST 3130001      13    13089    NWIS
    ## 262          ST 3130001      13    13089    NWIS
    ## 263          ST 3070103      13    13089    NWIS
    ## 264          ST 3130001      13    13121    NWIS
    ## 265          ST 3130001      13    13089    NWIS
    ## 266          ST 3130001      13    13089    NWIS
    ## 267          ST 3070103      13    13089    NWIS
    ## 268          ST 3070103      13    13121    NWIS
    ## 269          ST 3130002      13    13121    NWIS
    ## 270          ST 3070103      13    13121    NWIS
    ## 271          ST 3130001      13    13089    NWIS
    ## 272          ST 3130001      13    13121    NWIS
    ## 273          ST 3130002      13    13121    NWIS
    ## 274          ST 3130001      13    13089    NWIS
    ## 275          ST 3130001      13    13089    NWIS
    ## 276          ST 3070103      13    13089    NWIS
    ## 277          ST 3130001      13    13121    NWIS
    ## 278          ST 3130002      13    13121    NWIS
    ## 279          ST 3130001      13    13089    NWIS
    ## 280          ST 3130002      13    13121    NWIS
    ## 281          ST 3130001      13    13121    NWIS
    ## 282          ST 3130001      13    13121    NWIS
    ## 283          ST 3130001      13    13121    NWIS
    ## 284          ST 3130001      13    13121    NWIS
    ## 285          ST 3130001      13    13121    NWIS
    ## 286          ST 3130001      13    13089    NWIS
    ## 287          ST 3130002      13    13121    NWIS
    ## 288          ST 3130001      13    13121    NWIS
    ## 289          ST 3130001      13    13121    NWIS
    ## 290          ST 3130002      13    13121    NWIS
    ## 291          ST 3130001      13    13121    NWIS
    ## 292          ST 3130002      13    13121    NWIS
    ## 293          ST 3130001      13    13089    NWIS
    ## 294          ST 3130001      13    13121    NWIS
    ## 295          ST 3070103      13    13121    NWIS
    ## 296          ST 3130001      13    13121    NWIS
    ## 297          ST 3130001      13    13121    NWIS
    ## 298          ST 3130001      13    13121    NWIS
    ## 299          ST 3130001      13    13121    NWIS
    ## 300          ST 3130001      13    13089    NWIS
    ## 301          ST 3130001      13    13089    NWIS
    ## 302          ST 3130001      13    13121    NWIS
    ## 303          ST 3130001      13    13121    NWIS
    ## 304          ST 3130001      13    13121    NWIS
    ## 305          ST 3130001      13    13121    NWIS
    ## 306          ST 3130001      13    13121    NWIS
    ## 307          ST 3130001      13    13121    NWIS
    ## 308          ST 3130001      13    13121    NWIS
    ## 309          ST 3130002      13    13121    NWIS
    ## 310          ST 3130001      13    13121    NWIS
    ## 311          ST 3130001      13    13089    NWIS
    ## 312          ST 3130001      13    13121    NWIS
    ## 313          ST 3130001      13    13089    NWIS
    ## 314          ST 3130002      13    13121    NWIS
    ## 315          ST 3130002      13    13121    NWIS
    ## 316          ST 3070103      13    13121    NWIS
    ## 317          ST 3130002      13    13121    NWIS
    ## 318          ST 3130001      13    13121    NWIS
    ## 319          ST 3070103      13    13121    NWIS
    ## 320          ST 3130001      13    13121    NWIS
    ## 321          ST 3130002      13    13121    NWIS
    ## 322          ST 3130001      13    13089    NWIS
    ## 323          ST 3130002      13    13121    NWIS
    ## 324          ST 3070103      13    13089    NWIS
    ## 325          ST 3130001      13    13121    NWIS
    ## 326          ST 3070103      13    13121    NWIS
    ## 327          ST 3130002      13    13121    NWIS
    ## 328          ST 3070103      13    13121    NWIS
    ## 329          ST 3130002      13    13121    NWIS
    ## 330          ST 3130002      13    13121    NWIS
    ## 331          ST 3070103      13    13089    NWIS
    ## 332          ST 3130002      13    13121    NWIS
    ## 333          ST 3130001      13    13121    NWIS
    ## 334          ST 3130001      13    13089    NWIS
    ## 335          ST 3130002      13    13121    NWIS
    ## 336          ST 3130001      13    13089    NWIS
    ## 337          ST 3130002      13    13121    NWIS
    ## 338          ST 3130002      13    13121    NWIS
    ## 339          ST 3130002      13    13121    NWIS
    ## 340          ST 3130001      13    13121    NWIS
    ## 341          ST 3130001      13    13089    NWIS
    ## 342          ST 3130001      13    13121    NWIS
    ## 343          ST 3070103      13    13121    NWIS
    ## 344          ST 3070103      13    13121    NWIS
    ## 345          ST 3130002      13    13121    NWIS
    ## 346          ST 3130001      13    13089    NWIS
    ## 347          ST 3070103      13    13089    NWIS
    ## 348          ST 3130001      13    13121    NWIS
    ## 349          ST 3070103      13    13089    NWIS
    ## 350          ST 3070103      13    13121    NWIS
    ## 351          ST 3070103      13    13089    NWIS
    ## 352          ST 3130002      13    13121    NWIS
    ## 353          ST 3130001      13    13121    NWIS
    ## 354          ST 3130001      13    13089    NWIS
    ## 355          ST 3130002      13    13121    NWIS
    ## 356          ST 3070103      13    13089    NWIS
    ## 357          ST 3130001      13    13089    NWIS
    ## 358          ST 3070103      13    13089    NWIS
    ## 359          ST 3070103      13    13121    NWIS
    ## 360          ST 3130002      13    13121    NWIS
    ## 361          ST 3070103      13    13121    NWIS
    ## 362          ST 3070103      13    13121    NWIS
    ## 363          ST 3130001      13    13121    NWIS
    ## 364          ST 3130001      13    13121    NWIS
    ## 365          ST 3130002      13    13121    NWIS
    ## 366          ST 3130002      13    13121    NWIS
    ## 367          ST 3130001      13    13121    NWIS
    ## 368          ST 3130001      13    13121    NWIS
    ## 369          ST 3130001      13    13121    NWIS
    ## 370          ST 3070103      13    13121    NWIS
    ## 371          ST 3070103      13    13089    NWIS
    ## 372          ST 3130001      13    13121    NWIS
    ## 373          ST 3130001      13    13121    NWIS
    ## 374          ST 3130001      13    13089    NWIS
    ## 375          ST 3130001      13    13121    NWIS
    ## 376          ST 3130001      13    13089    NWIS
    ## 377          ST 3070103      13    13121    NWIS
    ## 378          ST 3070103      13    13121    NWIS
    ## 379          ST 3130001      13    13089    NWIS
    ## 380          ST 3130001      13    13089    NWIS
    ## 381          ST 3130002      13    13121    NWIS
    ## 382          ST 3130001      13    13121    NWIS
    ## 383          ST 3130002      13    13121    NWIS
    ## 384          ST 3130001      13    13121    NWIS
    ## 385          ST 3130002      13    13121    NWIS
    ## 386          ST 3130001      13    13121    NWIS
    ## 387          ST 3130001      13    13089    NWIS
    ## 388          ST 3130001      13    13089    NWIS
    ## 389          ST 3130001      13    13121    NWIS
    ## 390          ST 3070103      13    13121    NWIS
    ## 391          ST 3130001      13    13121    NWIS
    ## 392          ST 3070103      13    13089    NWIS
    ## 393          ST 3130001      13    13089    NWIS
    ## 394          ST 3130001      13    13121    NWIS
    ## 395          ST 3130002      13    13121    NWIS
    ## 396          ST 3130001      13    13121    NWIS
    ## 397          ST 3130001      13    13121    NWIS
    ## 398          ST 3130001      13    13089    NWIS
    ## 399          ST 3070103      13    13121    NWIS
    ## 400          ST 3130001      13    13121    NWIS
    ## 401          ST 3070103      13    13121    NWIS
    ## 402          ST 3130001      13    13121    NWIS
    ## 403          ST 3130001      13    13121    NWIS
    ## 404          ST 3130002      13    13121    NWIS
    ## 405          ST 3130001      13    13121    NWIS
    ## 406          ST 3130001      13    13121    NWIS
    ## 407          ST 3130002      13    13121    NWIS
    ## 408          ST 3070103      13    13089    NWIS
    ## 409          ST 3070103      13    13121    NWIS
    ## 410          ST 3130001      13    13121    NWIS
    ## 411          ST 3130001      13    13121    NWIS
    ## 412          ST 3130001      13    13089    NWIS
    ## 413          ST 3130001      13    13089    NWIS
    ## 414          ST 3130002      13    13121    NWIS
    ## 415          ST 3130002      13    13121    NWIS
    ## 416          ST 3130001      13    13121    NWIS
    ## 417          ST 3130001      13    13089    NWIS
    ## 418          ST 3130002      13    13121    NWIS
    ## 419          ST 3130002      13    13121    NWIS
    ## 420          ST 3130001      13    13121    NWIS
    ## 421          ST 3130001      13    13089    NWIS
    ## 422          ST 3130001      13    13121    NWIS
    ## 423          ST 3070103      13    13089    NWIS
    ## 424          ST 3130001      13    13121    NWIS
    ## 425          ST 3130002      13    13121    NWIS
    ## 426          ST 3130002      13    13121    NWIS
    ## 427          ST 3130001      13    13089    NWIS
    ## 428          ST 3070103      13    13089    NWIS
    ## 429          ST 3130002      13    13121    NWIS
    ## 430          ST 3130001      13    13089    NWIS
    ## 431          ST 3130001      13    13121    NWIS
    ## 432          ST 3070103      13    13089    NWIS
    ## 433          ST 3130001      13    13121    NWIS
    ## 434          ST 3130002      13    13121    NWIS
    ## 435          ST 3130002      13    13121    NWIS
    ## 436          ST 3130002      13    13121    NWIS
    ## 437          ST 3130001      13    13121    NWIS
    ## 438          ST 3130002      13    13121    NWIS
    ## 439          ST 3130001      13    13121    NWIS
    ## 440          ST 3130002      13    13121    NWIS
    ## 441          ST 3130001      13    13121    NWIS
    ## 442          ST 3130002      13    13121    NWIS
    ## 443          ST 3070103      13    13089    NWIS
    ## 444          ST 3070103      13    13089    NWIS
    ## 445          ST 3130001      13    13089    NWIS
    ## 446          ST 3130001      13    13121    NWIS
    ## 447          ST 3070103      13    13089    NWIS
    ## 448          ST 3130001      13    13121    NWIS
    ## 449          ST 3130001      13    13121    NWIS
    ## 450          ST 3130002      13    13121    NWIS
    ## 451          ST 3130001      13    13089    NWIS
    ## 452          ST 3130001      13    13121    NWIS
    ## 453          ST 3070103      13    13089    NWIS
    ## 454          ST 3130001      13    13121    NWIS
    ## 455          ST 3070103      13    13089    NWIS
    ## 456          ST 3130002      13    13121    NWIS
    ## 457          ST 3130001      13    13089    NWIS
    ## 458          ST 3130002      13    13121    NWIS
    ## 459          ST 3130001      13    13121    NWIS
    ## 460          ST 3070103      13    13121    NWIS
    ## 461          ST 3130001      13    13121    NWIS
    ## 462          ST 3130001      13    13121    NWIS
    ## 463          ST 3070103      13    13121    NWIS
    ## 464          ST 3130001      13    13121    NWIS
    ## 465          ST 3130001      13    13121    NWIS
    ## 466          ST 3130001      13    13089    NWIS
    ## 467          ST 3130002      13    13121    NWIS
    ## 468          ST 3130001      13    13089    NWIS
    ## 469          ST 3130001      13    13089    NWIS
    ## 470          ST 3130001      13    13121    NWIS
    ## 471          ST 3130002      13    13121    NWIS
    ## 472          ST 3130001      13    13121    NWIS
    ## 473          ST 3130001      13    13089    NWIS
    ## 474          ST 3130001      13    13089    NWIS
    ## 475          ST 3130001      13    13121    NWIS
    ## 476          ST 3130001      13    13121    NWIS
    ## 477          ST 3130001      13    13121    NWIS
    ## 478          ST 3130001      13    13121    NWIS
    ## 479          ST 3130001      13    13121    NWIS
    ## 480          ST 3130001      13    13121    NWIS
    ## 481          ST 3070103      13    13089    NWIS
    ## 482          ST 3070103      13    13089    NWIS
    ## 483          ST 3130001      13    13121    NWIS
    ## 484          ST 3130001      13    13089    NWIS
    ## 485          ST 3130002      13    13121    NWIS
    ## 486          ST 3070103      13    13121    NWIS
    ## 487          ST 3130001      13    13121    NWIS
    ## 488          ST 3130001      13    13089    NWIS
    ## 489          ST 3130001      13    13121    NWIS
    ## 490          ST 3130001      13    13121    NWIS
    ## 491          ST 3130002      13    13121    NWIS
    ## 492          ST 3130001      13    13121    NWIS
    ## 493          ST 3130002      13    13121    NWIS
    ## 494          ST 3130001      13    13089    NWIS
    ## 495          ST 3130001      13    13089    NWIS
    ## 496          ST 3130001      13    13089    NWIS
    ## 497          ST 3130002      13    13121    NWIS
    ## 498          ST 3070103      13    13089    NWIS
    ## 499          ST 3070103      13    13089    NWIS
    ## 500          ST 3130001      13    13089    NWIS
    ## 501          ST 3130001      13    13121    NWIS
    ## 502          ST 3130002      13    13121    NWIS
    ## 503          ST 3130002      13    13121    NWIS
    ## 504          ST 3130002      13    13121    NWIS
    ## 505          ST 3130001      13    13121    NWIS
    ## 506          ST 3130001      13    13121    NWIS
    ## 507          ST 3130001      13    13121    NWIS
    ## 508          ST 3130001      13    13121    NWIS
    ## 509          ST 3130001      13    13121    NWIS
    ## 510          ST 3130002      13    13121    NWIS
    ## 511          ST 3130002      13    13121    NWIS
    ## 512          ST 3130002      13    13121    NWIS
    ## 513          ST 3130001      13    13121    NWIS
    ## 514          ST 3130001      13    13089    NWIS
    ## 515          ST 3130002      13    13121    NWIS
    ## 516          ST 3130001      13    13121    NWIS
    ## 517          ST 3130001      13    13121    NWIS
    ## 518          ST 3130001      13    13121    NWIS
    ## 519          ST 3130002      13    13121    NWIS
    ## 520          ST 3130001      13    13121    NWIS
    ## 521          ST 3070103      13    13089    NWIS
    ## 522          ST 3130001      13    13121    NWIS
    ## 523          ST 3130001      13    13121    NWIS
    ## 524          ST 3130002      13    13121    NWIS
    ## 525          ST 3130002      13    13121    NWIS
    ## 526          ST 3130001      13    13089    NWIS
    ## 527          ST 3070103      13    13089    NWIS
    ## 528          ST 3130001      13    13121    NWIS
    ## 529          ST 3130001      13    13121    NWIS
    ## 530          ST 3130002      13    13121    NWIS
    ## 531          ST 3130001      13    13089    NWIS
    ## 532          ST 3130002      13    13121    NWIS
    ## 533          ST 3070103      13    13089    NWIS
    ## 534          ST 3130001      13    13121    NWIS
    ## 535          ST 3130002      13    13121    NWIS
    ## 536          ST 3130001      13    13121    NWIS
    ## 537          ST 3130001      13    13121    NWIS
    ## 538          ST 3130001      13    13121    NWIS
    ## 539          ST 3130002      13    13121    NWIS
    ## 540          ST 3130001      13    13089    NWIS
    ## 541          ST 3130001      13    13089    NWIS
    ## 542          ST 3130002      13    13121    NWIS
    ## 543          ST 3130001      13    13121    NWIS
    ## 544          ST 3130001      13    13121    NWIS
    ## 545          ST 3130002      13    13121    NWIS
    ## 546          ST 3130001      13    13121    NWIS
    ## 547          ST 3070103      13    13089    NWIS
    ## 548          ST 3130001      13    13089    NWIS
    ## 549          ST 3070103      13    13121    NWIS
    ## 550          ST 3130002      13    13121    NWIS
    ## 551          ST 3130001      13    13089    NWIS
    ## 552          ST 3130001      13    13121    NWIS
    ## 553          ST 3130002      13    13121    NWIS
    ## 554          ST 3130002      13    13121    NWIS
    ## 555          ST 3130002      13    13121    NWIS
    ## 556          ST 3130001      13    13121    NWIS
    ## 557          ST 3130002      13    13121    NWIS
    ## 558          ST 3130002      13    13121    NWIS
    ## 559          ST 3130001      13    13121    NWIS
    ## 560          ST 3070103      13    13121    NWIS
    ## 561          ST 3130001      13    13121    NWIS
    ## 562          ST 3130002      13    13121    NWIS
    ## 563          ST 3130001      13    13121    NWIS
    ## 564          ST 3130001      13    13121    NWIS
    ## 565          ST 3070103      13    13121    NWIS
    ## 566          ST 3130001      13    13121    NWIS
    ## 567          ST 3130001      13    13121    NWIS
    ## 568          ST 3130002      13    13121    NWIS
    ## 569          ST 3130001      13    13121    NWIS
    ## 570          ST 3130001      13    13089    NWIS
    ## 571          ST 3130002      13    13121    NWIS
    ## 572          ST 3070103      13    13121    NWIS
    ## 573          ST 3130001      13    13089    NWIS
    ## 574          ST 3130002      13    13121    NWIS
    ## 575          ST 3130001      13    13089    NWIS
    ## 576          ST 3130001      13    13089    NWIS
    ## 577          ST 3130001      13    13089    NWIS
    ## 578          ST 3130002      13    13121    NWIS
    ## 579          ST 3130001      13    13121    NWIS
    ## 580          ST 3130001      13    13121    NWIS
    ## 581          ST 3130002      13    13121    NWIS
    ## 582          ST 3070103      13    13121    NWIS
    ## 583          ST 3130002      13    13121    NWIS
    ## 584          ST 3130001      13    13121    NWIS
    ## 585          ST 3070103      13    13089    NWIS
    ## 586          ST 3070103      13    13089    NWIS
    ## 587          ST 3130001      13    13121    NWIS
    ## 588          ST 3130001      13    13089    NWIS
    ## 589          ST 3130002      13    13121    NWIS
    ## 590          ST 3130002      13    13121    NWIS
    ## 591          ST 3130001      13    13089    NWIS
    ## 592          ST 3130002      13    13121    NWIS
    ## 593          ST 3130001      13    13121    NWIS
    ## 594          ST 3130001      13    13089    NWIS
    ## 595          ST 3130002      13    13121    NWIS
    ## 596          ST 3130001      13    13089    NWIS
    ## 597          ST 3130002      13    13121    NWIS
    ## 598          ST 3070103      13    13121    NWIS
    ## 599          ST 3130001      13    13121    NWIS
    ## 600          ST 3130001      13    13089    NWIS
    ## 601          ST 3130001      13    13121    NWIS
    ## 602          ST 3130002      13    13121    NWIS
    ## 603          ST 3130001      13    13089    NWIS
    ## 604          ST 3130002      13    13121    NWIS
    ## 605          ST 3130001      13    13121    NWIS
    ## 606          ST 3130001      13    13121    NWIS
    ## 607          ST 3070103      13    13089    NWIS
    ## 608          ST 3130001      13    13121    NWIS
    ## 609          ST 3130001      13    13089    NWIS
    ## 610          ST 3130001      13    13089    NWIS
    ## 611          ST 3130002      13    13121    NWIS
    ## 612          ST 3070103      13    13089    NWIS
    ## 613          ST 3130001      13    13121    NWIS
    ## 614          ST 3130001      13    13121    NWIS
    ## 615          ST 3070103      13    13121    NWIS
    ## 616          ST 3130002      13    13121    NWIS
    ## 617          ST 3130001      13    13121    NWIS
    ## 618          ST 3130001      13    13121    NWIS
    ## 619          ST 3130001      13    13089    NWIS
    ## 620          ST 3070103      13    13089    NWIS
    ## 621          ST 3130001      13    13121    NWIS
    ## 622          ST 3130001      13    13121    NWIS
    ## 623          ST 3130001      13    13121    NWIS
    ## 624          ST 3130001      13    13121    NWIS
    ## 625          ST 3130001      13    13121    NWIS
    ## 626          ST 3130002      13    13121    NWIS
    ## 627          ST 3130001      13    13121    NWIS
    ## 628          ST 3130001      13    13121    NWIS
    ## 629          ST 3070103      13    13121    NWIS
    ## 630          ST 3130002      13    13121    NWIS
    ## 631          ST 3130002      13    13121    NWIS
    ## 632          ST 3130001      13    13121    NWIS
    ## 633          ST 3130002      13    13121    NWIS
    ## 634          ST 3130001      13    13121    NWIS
    ## 635          ST 3070103      13    13089    NWIS
    ## 636          ST 3130001      13    13121    NWIS
    ## 637          ST 3130001      13    13089    NWIS
    ## 638          ST 3130001      13    13121    NWIS
    ## 639          ST 3130001      13    13121    NWIS
    ## 640          ST 3130001      13    13089    NWIS
    ## 641          ST 3130002      13    13121    NWIS
    ## 642          ST 3130001      13    13121    NWIS
    ## 643          ST 3130001      13    13121    NWIS
    ## 644          ST 3130001      13    13089    NWIS
    ## 645          ST 3130001      13    13121    NWIS
    ## 646          ST 3130001      13    13121    NWIS
    ## 647          ST 3130002      13    13121    NWIS
    ## 648          ST 3130001      13    13121    NWIS
    ## 649          ST 3130001      13    13121    NWIS
    ## 650          ST 3130001      13    13089    NWIS
    ## 651          ST 3070103      13    13121    NWIS
    ## 652          ST 3130001      13    13089    NWIS
    ## 653          ST 3130002      13    13121    NWIS
    ## 654          ST 3130001      13    13121    NWIS
    ## 655          ST 3130001      13    13121    NWIS
    ## 656          ST 3130001      13    13089    NWIS
    ## 657          ST 3070103      13    13121    NWIS
    ## 658          ST 3130002      13    13121    NWIS
    ## 659          ST 3070103      13    13089    NWIS
    ## 660          ST 3130001      13    13121    NWIS
    ## 661          ST 3130001      13    13121    NWIS
    ## 662          ST 3130002      13    13121    NWIS
    ## 663          ST 3130002      13    13121    NWIS
    ## 664          ST 3130001      13    13089    NWIS
    ## 665          ST 3130001      13    13089    NWIS
    ## 666          ST 3070103      13    13121    NWIS
    ## 667          ST 3130002      13    13121    NWIS
    ## 668          ST 3130002      13    13121    NWIS
    ## 669          ST 3130001      13    13089    NWIS
    ## 670          ST 3130001      13    13089    NWIS
    ## 671          ST 3070103      13    13121    NWIS
    ## 672          ST 3130001      13    13089    NWIS
    ## 673          ST 3130001      13    13089    NWIS
    ## 674          ST 3130002      13    13121    NWIS
    ## 675          ST 3130002      13    13121    NWIS
    ## 676          ST 3070103      13    13121    NWIS
    ## 677          ST 3130001      13    13121    NWIS
    ## 678          ST 3130002      13    13121    NWIS
    ## 679          ST 3070103      13    13121    NWIS
    ## 680          ST 3130001      13    13121    NWIS
    ## 681          ST 3130001      13    13121    NWIS
    ## 682          ST 3130001      13    13089    NWIS
    ## 683          ST 3130002      13    13121    NWIS
    ## 684          ST 3130002      13    13121    NWIS
    ## 685          ST 3130001      13    13089    NWIS
    ## 686          ST 3070103      13    13089    NWIS
    ## 687          ST 3130001      13    13121    NWIS
    ## 688          ST 3130002      13    13121    NWIS
    ## 689          ST 3130001      13    13089    NWIS
    ## 690          ST 3130001      13    13121    NWIS
    ## 691          ST 3130002      13    13121    NWIS
    ## 692          ST 3130001      13    13121    NWIS
    ## 693          ST 3130001      13    13089    NWIS
    ## 694          ST 3130001      13    13121    NWIS
    ## 695          ST 3130002      13    13121    NWIS
    ## 696          ST 3070103      13    13089    NWIS
    ## 697          ST 3130001      13    13089    NWIS
    ## 698          ST 3130001      13    13121    NWIS
    ## 699          ST 3130002      13    13121    NWIS
    ## 700          ST 3070103      13    13089    NWIS
    ## 701          ST 3130002      13    13121    NWIS
    ## 702          ST 3070103      13    13089    NWIS
    ## 703          ST 3130001      13    13089    NWIS
    ## 704          ST 3130001      13    13089    NWIS
    ## 705          ST 3070103      13    13121    NWIS
    ## 706          ST 3130001      13    13121    NWIS
    ## 707          ST 3070103      13    13121    NWIS
    ## 708          ST 3130001      13    13121    NWIS
    ## 709          ST 3130001      13    13121    NWIS
    ## 710          ST 3130001      13    13089    NWIS
    ## 711          ST 3070103      13    13089    NWIS
    ## 712          ST 3130001      13    13089    NWIS
    ## 713          ST 3130002      13    13121    NWIS
    ## 714          ST 3130002      13    13121    NWIS
    ## 715          ST 3130002      13    13121    NWIS
    ## 716          ST 3130002      13    13121    NWIS
    ## 717          ST 3130001      13    13089    NWIS
    ## 718          ST 3130001      13    13121    NWIS
    ## 719          ST 3130001      13    13121    NWIS
    ## 720          ST 3130002      13    13121    NWIS
    ## 721          ST 3130001      13    13089    NWIS
    ## 722          ST 3070103      13    13089    NWIS
    ## 723          ST 3130002      13    13121    NWIS
    ## 724          ST 3130002      13    13121    NWIS
    ## 725          ST 3130001      13    13121    NWIS
    ## 726          ST 3070103      13    13121    NWIS
    ## 727          ST 3070103      13    13089    NWIS
    ## 728          ST 3070103      13    13121    NWIS
    ## 729          ST 3070103      13    13121    NWIS
    ## 730          ST 3130002      13    13121    NWIS
    ## 731          ST 3130001      13    13089    NWIS
    ## 732          ST 3130002      13    13121    NWIS
    ## 733          ST 3130001      13    13121    NWIS
    ## 734          ST 3130001      13    13121    NWIS
    ## 735          ST 3130001      13    13089    NWIS
    ## 736          ST 3130002      13    13121    NWIS
    ## 737          ST 3130001      13    13121    NWIS
    ## 738          ST 3130002      13    13121    NWIS
    ## 739          ST 3070103      13    13121    NWIS
    ## 740          ST 3130001      13    13089    NWIS
    ## 741          ST 3130001      13    13121    NWIS
    ## 742          ST 3130001      13    13121    NWIS
    ## 743          ST 3130001      13    13121    NWIS
    ## 744          ST 3070103      13    13121    NWIS
    ## 745          ST 3130001      13    13121    NWIS
    ## 746          ST 3070103      13    13089    NWIS
    ## 747          ST 3070103      13    13089    NWIS
    ## 748          ST 3130001      13    13121    NWIS
    ## 749          ST 3130001      13    13121    NWIS
    ## 750          ST 3130002      13    13121    NWIS
    ## 751          ST 3130001      13    13121    NWIS
    ## 752          ST 3130001      13    13121    NWIS
    ## 753          ST 3070103      13    13089    NWIS
    ## 754          ST 3130001      13    13121    NWIS
    ## 755          ST 3130001      13    13121    NWIS
    ## 756          ST 3130001      13    13121    NWIS
    ## 757          ST 3130001      13    13121    NWIS
    ## 758          ST 3130001      13    13121    NWIS
    ## 759          ST 3130001      13    13089    NWIS
    ## 760          ST 3070103      13    13121    NWIS
    ## 761          ST 3130002      13    13121    NWIS
    ## 762          ST 3130001      13    13121    NWIS
    ## 763          ST 3130001      13    13121    NWIS
    ## 764          ST 3130001      13    13121    NWIS
    ## 765          ST 3130001      13    13121    NWIS
    ## 766          ST 3130001      13    13121    NWIS
    ## 767          ST 3130001      13    13089    NWIS
    ## 768          ST 3130001      13    13121    NWIS
    ## 769          ST 3130001      13    13121    NWIS
    ## 770          ST 3130002      13    13121    NWIS
    ## 771          ST 3130002      13    13121    NWIS
    ## 772          ST 3130001      13    13089    NWIS
    ## 773          ST 3130002      13    13121    NWIS
    ## 774          ST 3130001      13    13121    NWIS
    ## 775          ST 3070103      13    13089    NWIS
    ## 776          ST 3070103      13    13089    NWIS
    ## 777          ST 3130001      13    13089    NWIS
    ## 778          ST 3130001      13    13089    NWIS
    ## 779          ST 3130001      13    13089    NWIS
    ## 780          ST 3070103      13    13121    NWIS
    ## 781          ST 3130001      13    13089    NWIS
    ## 782          ST 3130001      13    13121    NWIS
    ## 783          ST 3130001      13    13121    NWIS
    ## 784          ST 3130001      13    13089    NWIS
    ## 785          ST 3130002      13    13121    NWIS
    ## 786          ST 3130001      13    13121    NWIS
    ## 787          ST 3070103      13    13089    NWIS
    ## 788          ST 3130001      13    13121    NWIS
    ## 789          ST 3130001      13    13089    NWIS
    ## 790          ST 3130001      13    13121    NWIS
    ## 791          ST 3070103      13    13089    NWIS
    ## 792          ST 3070103      13    13121    NWIS
    ## 793          ST 3130001      13    13089    NWIS
    ## 794          ST 3070103      13    13121    NWIS
    ## 795          ST 3070103      13    13089    NWIS
    ## 796          ST 3130001      13    13121    NWIS
    ## 797          ST 3130002      13    13121    NWIS
    ## 798          ST 3130001      13    13089    NWIS
    ## 799          ST 3130001      13    13121    NWIS
    ## 800          ST 3130001      13    13121    NWIS
    ## 801          ST 3130001      13    13089    NWIS
    ## 802          ST 3130002      13    13121    NWIS
    ## 803          ST 3130002      13    13121    NWIS
    ## 804          ST 3130002      13    13121    NWIS
    ## 805          ST 3130001      13    13089    NWIS
    ## 806          ST 3130001      13    13089    NWIS
    ## 807          ST 3130002      13    13121    NWIS
    ## 808          ST 3130001      13    13121    NWIS
    ## 809          ST 3130001      13    13089    NWIS
    ## 810          ST 3130001      13    13121    NWIS
    ## 811          ST 3130002      13    13121    NWIS
    ## 812          ST 3130002      13    13121    NWIS
    ## 813          ST 3130002      13    13121    NWIS
    ## 814          ST 3130001      13    13121    NWIS
    ## 815          ST 3130001      13    13121    NWIS
    ## 816          ST 3130001      13    13121    NWIS
    ## 817          ST 3070103      13    13121    NWIS
    ## 818          ST 3130002      13    13121    NWIS
    ## 819          ST 3130001      13    13089    NWIS
    ## 820          ST 3130002      13    13121    NWIS
    ## 821          ST 3130001      13    13121    NWIS
    ## 822          ST 3130001      13    13121    NWIS
    ## 823          ST 3130002      13    13121    NWIS
    ## 824          ST 3130002      13    13121    NWIS
    ## 825          ST 3130002      13    13121    NWIS
    ## 826          ST 3130002      13    13121    NWIS
    ## 827          ST 3130001      13    13121    NWIS
    ## 828          ST 3130001      13    13089    NWIS
    ## 829          ST 3130001      13    13089    NWIS
    ## 830          ST 3130002      13    13121    NWIS
    ## 831          ST 3130001      13    13121    NWIS
    ## 832          ST 3130001      13    13089    NWIS
    ## 833          ST 3130001      13    13089    NWIS
    ## 834          ST 3130001      13    13089    NWIS
    ## 835          ST 3130001      13    13121    NWIS
    ## 836          ST 3130002      13    13121    NWIS
    ## 837          ST 3130001      13    13121    NWIS
    ## 838          ST 3130001      13    13121    NWIS
    ## 839          ST 3130002      13    13121    NWIS
    ## 840          ST 3130001      13    13121    NWIS
    ## 841          ST 3130001      13    13121    NWIS
    ## 842          ST 3130001      13    13121    NWIS
    ## 843          ST 3070103      13    13121    NWIS
    ## 844          ST 3130002      13    13121    NWIS
    ## 845          ST 3130001      13    13121    NWIS
    ## 846          ST 3130001      13    13121    NWIS
    ## 847          ST 3130001      13    13121    NWIS
    ## 848          ST 3130001      13    13121    NWIS
    ## 849          ST 3130001      13    13121    NWIS
    ## 850          ST 3070103      13    13089    NWIS
    ## 851          ST 3130001      13    13121    NWIS
    ## 852          ST 3130001      13    13121    NWIS
    ## 853          ST 3130001      13    13089    NWIS
    ## 854          ST 3130002      13    13121    NWIS
    ## 855          ST 3130001      13    13121    NWIS
    ## 856          ST 3130002      13    13121    NWIS
    ## 857          ST 3130002      13    13121    NWIS
    ## 858          ST 3130001      13    13121    NWIS
    ## 859          ST 3130002      13    13121    NWIS
    ## 860          ST 3130001      13    13089    NWIS
    ## 861          ST 3130001      13    13121    NWIS
    ## 862          ST 3130001      13    13121    NWIS
    ## 863          ST 3130001      13    13121    NWIS
    ## 864          ST 3130001      13    13121    NWIS
    ## 865          ST 3130001      13    13089    NWIS
    ## 866          ST 3130001      13    13121    NWIS
    ## 867          ST 3070103      13    13089    NWIS
    ## 868          ST 3130001      13    13089    NWIS
    ## 869          ST 3130001      13    13089    NWIS
    ## 870          ST 3130001      13    13121    NWIS
    ## 871          ST 3130002      13    13121    NWIS
    ## 872          ST 3130001      13    13089    NWIS
    ## 873          ST 3130002      13    13121    NWIS
    ## 874          ST 3130001      13    13089    NWIS
    ## 875          ST 3130002      13    13121    NWIS
    ## 876          ST 3130002      13    13121    NWIS
    ## 877          ST 3130002      13    13121    NWIS
    ## 878          ST 3130001      13    13121    NWIS
    ## 879          ST 3130001      13    13121    NWIS
    ## 880          ST 3070103      13    13121    NWIS
    ## 881          ST 3130001      13    13121    NWIS
    ## 882          ST 3070103      13    13089    NWIS
    ## 883          ST 3130001      13    13121    NWIS
    ## 884          ST 3130001      13    13089    NWIS
    ## 885          ST 3070103      13    13089    NWIS
    ## 886          ST 3130001      13    13089    NWIS
    ## 887          ST 3130001      13    13121    NWIS
    ## 888          ST 3130002      13    13121    NWIS
    ## 889          ST 3070103      13    13121    NWIS
    ## 890          ST 3130001      13    13121    NWIS
    ## 891          ST 3130001      13    13121    NWIS
    ## 892          ST 3130001      13    13121    NWIS
    ## 893          ST 3130001      13    13089    NWIS
    ## 894          ST 3130001      13    13121    NWIS
    ## 895          ST 3130002      13    13121    NWIS
    ## 896          ST 3130001      13    13121    NWIS
    ## 897          ST 3130002      13    13121    NWIS
    ## 898          ST 3130001      13    13121    NWIS
    ## 899          ST 3130001      13    13121    NWIS
    ## 900          ST 3130001      13    13121    NWIS
    ## 901          ST 3130002      13    13121    NWIS
    ## 902          ST 3130002      13    13121    NWIS
    ## 903          ST 3130001      13    13121    NWIS
    ## 904          ST 3130001      13    13089    NWIS
    ## 905          ST 3130002      13    13121    NWIS
    ## 906          ST 3130001      13    13121    NWIS
    ## 907          ST 3130001      13    13089    NWIS
    ## 908          ST 3130001      13    13121    NWIS
    ## 909          ST 3130002      13    13121    NWIS
    ## 910          ST 3130002      13    13121    NWIS
    ## 911          ST 3070103      13    13121    NWIS
    ## 912          ST 3070103      13    13089    NWIS
    ## 913          ST 3130001      13    13121    NWIS
    ## 914          ST 3130002      13    13121    NWIS
    ## 915          ST 3130001      13    13089    NWIS
    ## 916          ST 3130001      13    13089    NWIS
    ## 917          ST 3130001      13    13121    NWIS
    ## 918          ST 3130001      13    13121    NWIS
    ## 919          ST 3130001      13    13121    NWIS
    ## 920          ST 3130001      13    13121    NWIS
    ## 921          ST 3130002      13    13121    NWIS
    ## 922          ST 3130001      13    13121    NWIS
    ## 923          ST 3130001      13    13089    NWIS
    ## 924          ST 3130002      13    13121    NWIS
    ## 925          ST 3130001      13    13089    NWIS
    ## 926          ST 3130001      13    13121    NWIS
    ## 927          ST 3070103      13    13089    NWIS
    ## 928          ST 3070103      13    13121    NWIS
    ## 929          ST 3070103      13    13121    NWIS
    ## 930          ST 3130001      13    13121    NWIS
    ## 931          ST 3070103      13    13089    NWIS
    ## 932          ST 3130002      13    13121    NWIS
    ## 933          ST 3130002      13    13121    NWIS
    ## 934          ST 3130002      13    13121    NWIS
    ## 935          ST 3130001      13    13089    NWIS
    ## 936          ST 3070103      13    13089    NWIS
    ## 937          ST 3070103      13    13089    NWIS
    ## 938          ST 3130001      13    13089    NWIS
    ## 939          ST 3130001      13    13089    NWIS
    ## 940          ST 3130002      13    13121    NWIS
    ## 941          ST 3130001      13    13121    NWIS
    ## 942          ST 3130001      13    13089    NWIS
    ## 943          ST 3130001      13    13121    NWIS
    ## 944          ST 3130001      13    13121    NWIS
    ## 945          ST 3130001      13    13121    NWIS
    ## 946          ST 3130002      13    13121    NWIS
    ## 947          ST 3130001      13    13121    NWIS
    ## 948          ST 3070103      13    13089    NWIS
    ## 949          ST 3130001      13    13121    NWIS
    ## 950          ST 3130002      13    13121    NWIS
    ## 951          ST 3130001      13    13089    NWIS
    ## 952          ST 3070103      13    13121    NWIS
    ## 953          ST 3130002      13    13121    NWIS
    ## 954          ST 3130001      13    13121    NWIS
    ## 955          ST 3130001      13    13089    NWIS
    ## 956          ST 3130001      13    13121    NWIS
    ## 957          ST 3130001      13    13089    NWIS
    ## 958          ST 3130001      13    13121    NWIS
    ## 959          ST 3130002      13    13121    NWIS
    ## 960          ST 3130001      13    13089    NWIS
    ## 961          ST 3130002      13    13121    NWIS
    ## 962          ST 3130002      13    13121    NWIS
    ## 963          ST 3070103      13    13121    NWIS
    ## 964          ST 3130002      13    13121    NWIS
    ## 965          ST 3130001      13    13089    NWIS
    ## 966          ST 3130001      13    13089    NWIS
    ## 967          ST 3130001      13    13121    NWIS
    ## 968          ST 3130001      13    13121    NWIS
    ## 969          ST 3070103      13    13089    NWIS
    ## 970          ST 3130001      13    13121    NWIS
    ## 971          ST 3130002      13    13121    NWIS
    ## 972          ST 3130001      13    13089    NWIS
    ## 973          ST 3130002      13    13121    NWIS
    ## 974          ST 3130001      13    13121    NWIS
    ## 975          ST 3130001      13    13121    NWIS
    ## 976          ST 3130002      13    13121    NWIS
    ## 977          ST 3130001      13    13121    NWIS
    ## 978          ST 3130001      13    13121    NWIS
    ## 979          ST 3130002      13    13121    NWIS
    ## 980          ST 3130002      13    13121    NWIS
    ## 981          ST 3130002      13    13121    NWIS
    ## 982          ST 3130001      13    13089    NWIS
    ## 983          ST 3130001      13    13121    NWIS
    ## 984          ST 3130002      13    13121    NWIS
    ## 985          ST 3130001      13    13121    NWIS
    ## 986          ST 3130001      13    13089    NWIS
    ## 987          ST 3070103      13    13121    NWIS
    ## 988          ST 3130001      13    13121    NWIS
    ## 989          ST 3070103      13    13121    NWIS
    ## 990          ST 3130001      13    13089    NWIS
    ## 991          ST 3130002      13    13121    NWIS
    ## 992          ST 3130002      13    13121    NWIS
    ## 993          ST 3070103      13    13121    NWIS
    ## 994          ST 3130001      13    13089    NWIS
    ## 995          ST 3070103      13    13089    NWIS
    ## 996          ST 3130001      13    13089    NWIS
    ## 997          ST 3130001      13    13089    NWIS
    ## 998          ST 3130001      13    13121    NWIS
    ## 999          ST 3130001      13    13121    NWIS
    ## 1000         ST 3070103      13    13089    NWIS
    ## 1001         ST 3130002      13    13121    NWIS
    ## 1002         ST 3130002      13    13121    NWIS
    ## 1003         ST 3130001      13    13121    NWIS
    ## 1004         ST 3130002      13    13121    NWIS
    ## 1005         ST 3070103      13    13121    NWIS
    ## 1006         ST 3130001      13    13121    NWIS
    ## 1007         ST 3130001      13    13089    NWIS
    ## 1008         ST 3070103      13    13089    NWIS
    ## 1009         ST 3130001      13    13121    NWIS
    ## 1010         ST 3130001      13    13121    NWIS
    ## 1011         ST 3130001      13    13121    NWIS
    ## 1012         ST 3130001      13    13089    NWIS
    ## 1013         ST 3130001      13    13121    NWIS
    ## 1014         ST 3130002      13    13121    NWIS
    ## 1015         ST 3130002      13    13121    NWIS
    ## 1016         ST 3130001      13    13121    NWIS
    ## 1017         ST 3130001      13    13121    NWIS
    ## 1018         ST 3130001      13    13121    NWIS
    ## 1019         ST 3070103      13    13121    NWIS
    ## 1020         ST 3130001      13    13089    NWIS
    ## 1021         ST 3130001      13    13121    NWIS
    ## 1022         ST 3130002      13    13121    NWIS
    ## 1023         ST 3130002      13    13121    NWIS
    ## 1024         ST 3130001      13    13121    NWIS
    ## 1025         ST 3130001      13    13121    NWIS
    ## 1026         ST 3130002      13    13121    NWIS
    ## 1027         ST 3130001      13    13089    NWIS
    ## 1028         ST 3130001      13    13121    NWIS
    ## 1029         ST 3130001      13    13089    NWIS
    ## 1030         ST 3130002      13    13121    NWIS
    ## 1031         ST 3130001      13    13121    NWIS
    ## 1032         ST 3130001      13    13121    NWIS
    ## 1033         ST 3130001      13    13121    NWIS
    ## 1034         ST 3130001      13    13089    NWIS
    ## 1035         ST 3130001      13    13089    NWIS
    ## 1036         ST 3130001      13    13121    NWIS
    ## 1037         ST 3130001      13    13089    NWIS
    ## 1038         ST 3130001      13    13121    NWIS
    ## 1039         ST 3130001      13    13121    NWIS
    ## 1040         ST 3130001      13    13089    NWIS
    ## 1041         ST 3130002      13    13121    NWIS
    ## 1042         ST 3130002      13    13121    NWIS
    ## 1043         ST 3130001      13    13121    NWIS
    ## 1044         ST 3130002      13    13121    NWIS
    ## 1045         ST 3130002      13    13121    NWIS
    ## 1046         ST 3130002      13    13121    NWIS
    ## 1047         ST 3130001      13    13121    NWIS
    ## 1048         ST 3070103      13    13121    NWIS
    ## 1049         ST 3130001      13    13089    NWIS
    ## 1050         ST 3130001      13    13121    NWIS
    ## 1051         ST 3130001      13    13121    NWIS
    ## 1052         ST 3130002      13    13121    NWIS
    ## 1053         ST 3070103      13    13089    NWIS
    ## 1054         ST 3130002      13    13121    NWIS
    ## 1055         ST 3130002      13    13121    NWIS
    ## 1056         ST 3130001      13    13121    NWIS
    ## 1057         ST 3130001      13    13121    NWIS
    ## 1058         ST 3130002      13    13121    NWIS
    ## 1059         ST 3070103      13    13121    NWIS
    ## 1060         ST 3130001      13    13089    NWIS
    ## 1061         ST 3130001      13    13121    NWIS
    ## 1062         ST 3070103      13    13089    NWIS
    ## 1063         ST 3130001      13    13089    NWIS
    ## 1064         ST 3070103      13    13121    NWIS
    ## 1065         ST 3130001      13    13089    NWIS
    ## 1066         ST 3070103      13    13121    NWIS
    ## 1067         ST 3130001      13    13121    NWIS
    ## 1068         ST 3130001      13    13089    NWIS
    ## 1069         ST 3130001      13    13121    NWIS
    ## 1070         ST 3130002      13    13121    NWIS
    ## 1071         ST 3130002      13    13121    NWIS
    ## 1072         ST 3130001      13    13089    NWIS
    ## 1073         ST 3070103      13    13089    NWIS
    ## 1074         ST 3130002      13    13121    NWIS
    ## 1075         ST 3130002      13    13121    NWIS
    ## 1076         ST 3070103      13    13089    NWIS
    ## 1077         ST 3130001      13    13121    NWIS
    ## 1078         ST 3130002      13    13121    NWIS
    ## 1079         ST 3130001      13    13121    NWIS
    ## 1080         ST 3130002      13    13121    NWIS
    ## 1081         ST 3130002      13    13121    NWIS
    ## 1082         ST 3130001      13    13121    NWIS
    ## 1083         ST 3130001      13    13089    NWIS
    ## 1084         ST 3130001      13    13089    NWIS
    ## 1085         ST 3130001      13    13121    NWIS
    ## 1086         ST 3130001      13    13089    NWIS
    ## 1087         ST 3130002      13    13121    NWIS
    ## 1088         ST 3130001      13    13089    NWIS
    ## 1089         ST 3070103      13    13089    NWIS
    ## 1090         ST 3130001      13    13089    NWIS
    ## 1091         ST 3130002      13    13121    NWIS
    ## 1092         ST 3130001      13    13089    NWIS
    ## 1093         ST 3130001      13    13089    NWIS
    ## 1094         ST 3130001      13    13089    NWIS
    ## 1095         ST 3130001      13    13089    NWIS
    ## 1096         ST 3130001      13    13089    NWIS
    ## 1097         ST 3070103      13    13089    NWIS
    ## 1098         ST 3130002      13    13121    NWIS
    ## 1099         ST 3130001      13    13089    NWIS
    ## 1100         ST 3130001      13    13121    NWIS
    ## 1101         ST 3130001      13    13121    NWIS
    ## 1102         ST 3130002      13    13121    NWIS
    ## 1103         ST 3130001      13    13121    NWIS
    ## 1104         ST 3130001      13    13121    NWIS
    ## 1105         ST 3130001      13    13121    NWIS
    ## 1106         ST 3070103      13    13121    NWIS
    ## 1107         ST 3130002      13    13121    NWIS
    ## 1108         ST 3130002      13    13121    NWIS
    ## 1109         ST 3130001      13    13121    NWIS
    ## 1110         ST 3130001      13    13121    NWIS
    ## 1111         ST 3130001      13    13121    NWIS
    ## 1112         ST 3130001      13    13121    NWIS
    ## 1113         ST 3130001      13    13121    NWIS
    ## 1114         ST 3130001      13    13121    NWIS
    ## 1115         ST 3070103      13    13089    NWIS
    ## 1116         ST 3070103      13    13121    NWIS
    ## 1117         ST 3070103      13    13121    NWIS
    ## 1118         ST 3130002      13    13121    NWIS
    ## 1119         ST 3130001      13    13089    NWIS
    ## 1120         ST 3130002      13    13121    NWIS
    ## 1121         ST 3130001      13    13121    NWIS
    ## 1122         ST 3070103      13    13121    NWIS
    ## 1123         ST 3130002      13    13121    NWIS
    ## 1124         ST 3130001      13    13089    NWIS
    ## 1125         ST 3130001      13    13121    NWIS
    ## 1126         ST 3130001      13    13089    NWIS
    ## 1127         ST 3130002      13    13121    NWIS
    ## 1128         ST 3130001      13    13089    NWIS
    ## 1129         ST 3070103      13    13089    NWIS
    ## 1130         ST 3130001      13    13121    NWIS
    ## 1131         ST 3130002      13    13121    NWIS
    ## 1132         ST 3130001      13    13121    NWIS
    ## 1133         ST 3130002      13    13121    NWIS
    ## 1134         ST 3130001      13    13089    NWIS
    ## 1135         ST 3130001      13    13089    NWIS
    ## 1136         ST 3130001      13    13121    NWIS
    ## 1137         ST 3130001      13    13121    NWIS
    ## 1138         ST 3130001      13    13121    NWIS
    ## 1139         ST 3130002      13    13121    NWIS
    ## 1140         ST 3070103      13    13089    NWIS
    ## 1141         ST 3130001      13    13089    NWIS
    ## 1142         ST 3130001      13    13089    NWIS
    ## 1143         ST 3070103      13    13089    NWIS
    ## 1144         ST 3130001      13    13121    NWIS
    ## 1145         ST 3130001      13    13089    NWIS
    ## 1146         ST 3070103      13    13089    NWIS
    ## 1147         ST 3130001      13    13089    NWIS
    ## 1148         ST 3130001      13    13121    NWIS
    ## 1149         ST 3130001      13    13121    NWIS
    ## 1150         ST 3130001      13    13089    NWIS
    ## 1151         ST 3130002      13    13121    NWIS
    ## 1152         ST 3130001      13    13121    NWIS
    ## 1153         ST 3130002      13    13121    NWIS
    ## 1154         ST 3130001      13    13089    NWIS
    ## 1155         ST 3130001      13    13121    NWIS
    ## 1156         ST 3130001      13    13121    NWIS
    ## 1157         ST 3130001      13    13089    NWIS
    ## 1158         ST 3130001      13    13121    NWIS
    ## 1159         ST 3070103      13    13121    NWIS
    ## 1160         ST 3130002      13    13121    NWIS
    ## 1161         ST 3130002      13    13121    NWIS
    ## 1162         ST 3130002      13    13121    NWIS
    ## 1163         ST 3130002      13    13121    NWIS
    ## 1164         ST 3130001      13    13121    NWIS
    ## 1165         ST 3130002      13    13121    NWIS
    ## 1166         ST 3130002      13    13121    NWIS
    ## 1167         ST 3130001      13    13089    NWIS
    ## 1168         ST 3130001      13    13089    NWIS
    ## 1169         ST 3130001      13    13089    NWIS
    ## 1170         ST 3130001      13    13089    NWIS
    ## 1171         ST 3130001      13    13121    NWIS
    ## 1172         ST 3070103      13    13121    NWIS
    ## 1173         ST 3070103      13    13089    NWIS
    ## 1174         ST 3070103      13    13121    NWIS
    ## 1175         ST 3130002      13    13121    NWIS
    ## 1176         ST 3070103      13    13089    NWIS
    ## 1177         ST 3130001      13    13121    NWIS
    ## 1178         ST 3130001      13    13089    NWIS
    ## 1179         ST 3130001      13    13089    NWIS
    ## 1180         ST 3130001      13    13121    NWIS
    ## 1181         ST 3130001      13    13089    NWIS
    ## 1182         ST 3130002      13    13121    NWIS
    ## 1183         ST 3130001      13    13121    NWIS
    ## 1184         ST 3130001      13    13089    NWIS
    ## 1185         ST 3130001      13    13121    NWIS
    ## 1186         ST 3130001      13    13121    NWIS
    ## 1187         ST 3130002      13    13121    NWIS
    ## 1188         ST 3130001      13    13089    NWIS
    ## 1189         ST 3130001      13    13121    NWIS
    ## 1190         ST 3130001      13    13089    NWIS
    ## 1191         ST 3130002      13    13121    NWIS
    ## 1192         ST 3070103      13    13121    NWIS
    ## 1193         ST 3130002      13    13121    NWIS
    ## 1194         ST 3130001      13    13121    NWIS
    ## 1195         ST 3130001      13    13121    NWIS
    ## 1196         ST 3130001      13    13089    NWIS
    ## 1197         ST 3130001      13    13121    NWIS
    ## 1198         ST 3130001      13    13121    NWIS
    ## 1199         ST 3130001      13    13121    NWIS
    ## 1200         ST 3130001      13    13121    NWIS
    ## 1201         ST 3130002      13    13121    NWIS
    ## 1202         ST 3130001      13    13089    NWIS
    ## 1203         ST 3130002      13    13121    NWIS
    ## 1204         ST 3130002      13    13121    NWIS
    ## 1205         ST 3070103      13    13121    NWIS
    ## 1206         ST 3130001      13    13121    NWIS
    ## 1207         ST 3130001      13    13089    NWIS
    ## 1208         ST 3070103      13    13121    NWIS
    ## 1209         ST 3130002      13    13121    NWIS
    ## 1210         ST 3130002      13    13121    NWIS
    ## 1211         ST 3070103      13    13089    NWIS
    ## 1212         ST 3130002      13    13121    NWIS
    ## 1213         ST 3130001      13    13089    NWIS
    ## 1214         ST 3130001      13    13121    NWIS
    ## 1215         ST 3130001      13    13089    NWIS
    ## 1216         ST 3130001      13    13121    NWIS
    ## 1217         ST 3130001      13    13121    NWIS
    ## 1218         ST 3130001      13    13121    NWIS
    ## 1219         ST 3070103      13    13089    NWIS
    ## 1220         ST 3130001      13    13089    NWIS
    ## 1221         ST 3130001      13    13121    NWIS
    ## 1222         ST 3130002      13    13121    NWIS
    ## 1223         ST 3130001      13    13121    NWIS
    ## 1224         ST 3130001      13    13121    NWIS
    ## 1225         ST 3130001      13    13089    NWIS
    ## 1226         ST 3070103      13    13121    NWIS
    ## 1227         ST 3130001      13    13121    NWIS
    ## 1228         ST 3130002      13    13121    NWIS
    ## 1229         ST 3130001      13    13089    NWIS
    ## 1230         ST 3130001      13    13121    NWIS
    ## 1231         ST 3130002      13    13121    NWIS
    ## 1232         ST 3130001      13    13121    NWIS
    ## 1233         ST 3130001      13    13121    NWIS
    ## 1234         ST 3070103      13    13089    NWIS
    ## 1235         ST 3070103      13    13089    NWIS
    ## 1236         ST 3130001      13    13121    NWIS
    ## 1237         ST 3130002      13    13121    NWIS
    ## 1238         ST 3130001      13    13121    NWIS
    ## 1239         ST 3070103      13    13121    NWIS
    ## 1240         ST 3130001      13    13121    NWIS
    ## 1241         ST 3130002      13    13121    NWIS
    ## 1242         ST 3130002      13    13121    NWIS
    ## 1243         ST 3130001      13    13121    NWIS
    ## 1244         ST 3130001      13    13121    NWIS
    ## 1245         ST 3130001      13    13121    NWIS
    ## 1246         ST 3130001      13    13121    NWIS
    ## 1247         ST 3070103      13    13089    NWIS
    ## 1248         ST 3130001      13    13089    NWIS
    ## 1249         ST 3130001      13    13121    NWIS
    ## 1250         ST 3070103      13    13121    NWIS
    ## 1251         ST 3130001      13    13121    NWIS
    ## 1252         ST 3130001      13    13089    NWIS
    ## 1253         ST 3130001      13    13121    NWIS
    ## 1254         ST 3130001      13    13089    NWIS
    ## 1255         ST 3130001      13    13121    NWIS
    ## 1256         ST 3070103      13    13121    NWIS
    ## 1257         ST 3130001      13    13121    NWIS
    ## 1258         ST 3130001      13    13121    NWIS
    ## 1259         ST 3130002      13    13121    NWIS
    ## 1260         ST 3070103      13    13121    NWIS
    ## 1261         ST 3130001      13    13089    NWIS
    ## 1262         ST 3130001      13    13089    NWIS
    ## 1263         ST 3130001      13    13089    NWIS
    ## 1264         ST 3130001      13    13089    NWIS
    ## 1265         ST 3130001      13    13089    NWIS
    ## 1266         ST 3130002      13    13121    NWIS
    ## 1267         ST 3130002      13    13121    NWIS
    ## 1268         ST 3130001      13    13121    NWIS
    ## 1269         ST 3130001      13    13121    NWIS
    ## 1270         ST 3070103      13    13121    NWIS
    ## 1271         ST 3070103      13    13121    NWIS
    ## 1272         ST 3130002      13    13121    NWIS
    ## 1273         ST 3070103      13    13089    NWIS
    ## 1274         ST 3130001      13    13121    NWIS
    ## 1275         ST 3130001      13    13121    NWIS
    ## 1276         ST 3130002      13    13121    NWIS
    ## 1277         ST 3130002      13    13121    NWIS
    ## 1278         ST 3130002      13    13121    NWIS
    ## 1279         ST 3130001      13    13121    NWIS
    ## 1280         ST 3130001      13    13121    NWIS
    ## 1281         ST 3130001      13    13121    NWIS
    ## 1282         ST 3130001      13    13121    NWIS
    ## 1283         ST 3130001      13    13089    NWIS
    ## 1284         ST 3130002      13    13121    NWIS
    ## 1285         ST 3130001      13    13089    NWIS
    ## 1286         ST 3130001      13    13121    NWIS
    ## 1287         ST 3130001      13    13121    NWIS
    ## 1288         ST 3130001      13    13089    NWIS
    ## 1289         ST 3130001      13    13121    NWIS
    ## 1290         ST 3130001      13    13089    NWIS
    ## 1291         ST 3070103      13    13089    NWIS
    ## 1292         ST 3130001      13    13121    NWIS
    ## 1293         ST 3130001      13    13121    NWIS
    ## 1294         ST 3130001      13    13121    NWIS
    ## 1295         ST 3070103      13    13089    NWIS
    ## 1296         ST 3130002      13    13121    NWIS
    ## 1297         ST 3130002      13    13121    NWIS
    ## 1298         ST 3130001      13    13121    NWIS
    ## 1299         ST 3130002      13    13121    NWIS
    ## 1300         ST 3130001      13    13089    NWIS
    ## 1301         ST 3130002      13    13121    NWIS
    ## 1302         ST 3130002      13    13121    NWIS
    ## 1303         ST 3130002      13    13121    NWIS
    ## 1304         ST 3070103      13    13121    NWIS
    ## 1305         ST 3130002      13    13121    NWIS
    ## 1306         ST 3130002      13    13121    NWIS
    ## 1307         ST 3070103      13    13121    NWIS
    ## 1308         ST 3130001      13    13121    NWIS
    ## 1309         ST 3070103      13    13089    NWIS
    ## 1310         ST 3130001      13    13121    NWIS
    ## 1311         ST 3070103      13    13121    NWIS
    ## 1312         ST 3130001      13    13121    NWIS
    ## 1313         ST 3070103      13    13089    NWIS
    ## 1314         ST 3130002      13    13121    NWIS
    ## 1315         ST 3130001      13    13089    NWIS
    ## 1316         ST 3130002      13    13121    NWIS
    ## 1317         ST 3130001      13    13121    NWIS
    ## 1318         ST 3070103      13    13089    NWIS
    ## 1319         ST 3130002      13    13121    NWIS
    ## 1320         ST 3130001      13    13121    NWIS
    ## 1321         ST 3070103      13    13089    NWIS
    ## 1322         ST 3130001      13    13121    NWIS
    ## 1323         ST 3130001      13    13121    NWIS
    ## 1324         ST 3130002      13    13121    NWIS
    ## 1325         ST 3070103      13    13089    NWIS
    ## 1326         ST 3130001      13    13121    NWIS
    ## 1327         ST 3130001      13    13121    NWIS
    ## 1328         ST 3130001      13    13089    NWIS
    ## 1329         ST 3130001      13    13121    NWIS
    ## 1330         ST 3130001      13    13121    NWIS
    ## 1331         ST 3130001      13    13121    NWIS
    ## 1332         ST 3130001      13    13121    NWIS
    ## 1333         ST 3070103      13    13121    NWIS
    ## 1334         ST 3130001      13    13121    NWIS
    ## 1335         ST 3130002      13    13121    NWIS
    ## 1336         ST 3130001      13    13089    NWIS
    ## 1337         ST 3070103      13    13089    NWIS
    ## 1338         ST 3130001      13    13121    NWIS
    ## 1339         ST 3130001      13    13121    NWIS
    ## 1340         ST 3070103      13    13089    NWIS
    ## 1341         ST 3130001      13    13121    NWIS
    ## 1342         ST 3070103      13    13089    NWIS
    ## 1343         ST 3130002      13    13121    NWIS
    ## 1344         ST 3130002      13    13121    NWIS
    ## 1345         ST 3130001      13    13089    NWIS
    ## 1346         ST 3130001      13    13121    NWIS
    ## 1347         ST 3130001      13    13089    NWIS
    ## 1348         ST 3070103      13    13089    NWIS
    ## 1349         ST 3130001      13    13121    NWIS
    ## 1350         ST 3130001      13    13089    NWIS
    ## 1351         ST 3070103      13    13089    NWIS
    ## 1352         ST 3130001      13    13121    NWIS
    ## 1353         ST 3130001      13    13121    NWIS
    ## 1354         ST 3130001      13    13089    NWIS
    ## 1355         ST 3070103      13    13089    NWIS
    ## 1356         ST 3070103      13    13089    NWIS
    ## 1357         ST 3130001      13    13089    NWIS
    ## 1358         ST 3130001      13    13089    NWIS
    ## 1359         ST 3070103      13    13089    NWIS
    ## 1360         ST 3130002      13    13121    NWIS
    ## 1361         ST 3070103      13    13121    NWIS
    ## 1362         ST 3130001      13    13121    NWIS
    ## 1363         ST 3130001      13    13089    NWIS
    ## 1364         ST 3130002      13    13121    NWIS
    ## 1365         ST 3130001      13    13089    NWIS
    ## 1366         ST 3130002      13    13121    NWIS
    ## 1367         ST 3130001      13    13121    NWIS
    ## 1368         ST 3130002      13    13121    NWIS
    ## 1369         ST 3070103      13    13089    NWIS
    ## 1370         ST 3130001      13    13089    NWIS
    ## 1371         ST 3130002      13    13121    NWIS
    ## 1372         ST 3130001      13    13089    NWIS
    ## 1373         ST 3130002      13    13121    NWIS
    ## 1374         ST 3130001      13    13121    NWIS
    ## 1375         ST 3130001      13    13121    NWIS
    ## 1376         ST 3130002      13    13121    NWIS
    ## 1377         ST 3130002      13    13121    NWIS
    ## 1378         ST 3130002      13    13121    NWIS
    ## 1379         ST 3130002      13    13121    NWIS
    ## 1380         ST 3130001      13    13121    NWIS
    ## 1381         ST 3130002      13    13121    NWIS
    ## 1382         ST 3130002      13    13121    NWIS
    ## 1383         ST 3130001      13    13089    NWIS
    ## 1384         ST 3070103      13    13121    NWIS
    ## 1385         ST 3070103      13    13089    NWIS
    ## 1386         ST 3130001      13    13089    NWIS
    ## 1387         ST 3130001      13    13089    NWIS
    ## 1388         ST 3070103      13    13089    NWIS
    ## 1389         ST 3130001      13    13089    NWIS
    ## 1390         ST 3130001      13    13121    NWIS
    ## 1391         ST 3070103      13    13089    NWIS
    ## 1392         ST 3070103      13    13089    NWIS
    ## 1393         ST 3130002      13    13121    NWIS
    ## 1394         ST 3130001      13    13089    NWIS
    ## 1395         ST 3130002      13    13121    NWIS
    ## 1396         ST 3130001      13    13089    NWIS
    ## 1397         ST 3130002      13    13121    NWIS
    ## 1398         ST 3130002      13    13121    NWIS
    ## 1399         ST 3130001      13    13121    NWIS
    ## 1400         ST 3130001      13    13121    NWIS
    ## 1401         ST 3070103      13    13089    NWIS
    ## 1402         ST 3130001      13    13089    NWIS
    ## 1403         ST 3070103      13    13089    NWIS
    ## 1404         ST 3130001      13    13089    NWIS
    ## 1405         ST 3130001      13    13121    NWIS
    ## 1406         ST 3130001      13    13121    NWIS
    ## 1407         ST 3070103      13    13089    NWIS
    ## 1408         ST 3130001      13    13121    NWIS
    ## 1409         ST 3130001      13    13089    NWIS
    ## 1410         ST 3070103      13    13089    NWIS
    ## 1411         ST 3130001      13    13121    NWIS
    ## 1412         ST 3070103      13    13089    NWIS
    ## 1413         ST 3130001      13    13089    NWIS
    ## 1414         ST 3130001      13    13121    NWIS
    ## 1415         ST 3130001      13    13121    NWIS
    ## 1416         ST 3130001      13    13089    NWIS
    ## 1417         ST 3130001      13    13121    NWIS
    ## 1418         ST 3130001      13    13121    NWIS
    ## 1419         ST 3130002      13    13121    NWIS
    ## 1420         ST 3130001      13    13121    NWIS
    ## 1421         ST 3130001      13    13089    NWIS
    ## 1422         ST 3130001      13    13089    NWIS
    ## 1423         ST 3130002      13    13121    NWIS
    ## 1424         ST 3130001      13    13089    NWIS
    ## 1425         ST 3130002      13    13121    NWIS
    ## 1426         ST 3070103      13    13089    NWIS
    ## 1427         ST 3130001      13    13121    NWIS
    ## 1428         ST 3130001      13    13089    NWIS
    ## 1429         ST 3130001      13    13089    NWIS
    ## 1430         ST 3070103      13    13089    NWIS
    ## 1431         ST 3070103      13    13121    NWIS
    ## 1432         ST 3130001      13    13089    NWIS
    ## 1433         ST 3130001      13    13121    NWIS
    ## 1434         ST 3070103      13    13089    NWIS
    ## 1435         ST 3130001      13    13089    NWIS
    ## 1436         ST 3130001      13    13121    NWIS
    ## 1437         ST 3130001      13    13121    NWIS
    ## 1438         ST 3130001      13    13089    NWIS
    ## 1439         ST 3130002      13    13121    NWIS
    ## 1440         ST 3130001      13    13089    NWIS
    ## 1441         ST 3130002      13    13121    NWIS
    ## 1442         ST 3130001      13    13121    NWIS
    ## 1443         ST 3130001      13    13121    NWIS
    ## 1444         ST 3130001      13    13121    NWIS
    ## 1445         ST 3130002      13    13121    NWIS
    ## 1446         ST 3130001      13    13121    NWIS
    ## 1447         ST 3130002      13    13121    NWIS
    ## 1448         ST 3130001      13    13089    NWIS
    ## 1449         ST 3070103      13    13121    NWIS
    ## 1450         ST 3130002      13    13121    NWIS
    ## 1451         ST 3130002      13    13121    NWIS
    ## 1452         ST 3130001      13    13089    NWIS
    ## 1453         ST 3070103      13    13089    NWIS
    ## 1454         ST 3130002      13    13121    NWIS
    ## 1455         ST 3130001      13    13089    NWIS
    ## 1456         ST 3130001      13    13121    NWIS
    ## 1457         ST 3130001      13    13121    NWIS
    ## 1458         ST 3070103      13    13121    NWIS
    ## 1459         ST 3130002      13    13121    NWIS
    ## 1460         ST 3130001      13    13089    NWIS
    ## 1461         ST 3070103      13    13089    NWIS
    ## 1462         ST 3130001      13    13121    NWIS
    ## 1463         ST 3130001      13    13089    NWIS
    ## 1464         ST 3130002      13    13121    NWIS
    ## 1465         ST 3130001      13    13089    NWIS
    ## 1466         ST 3130001      13    13121    NWIS
    ## 1467         ST 3130001      13    13121    NWIS
    ## 1468         ST 3130001      13    13121    NWIS
    ## 1469         ST 3130001      13    13121    NWIS
    ## 1470         ST 3130001      13    13121    NWIS
    ## 1471         ST 3130001      13    13121    NWIS
    ## 1472         ST 3130001      13    13121    NWIS
    ## 1473         ST 3130001      13    13121    NWIS
    ## 1474         ST 3130002      13    13121    NWIS
    ## 1475         ST 3130001      13    13121    NWIS
    ## 1476         ST 3130001      13    13121    NWIS
    ## 1477         ST 3070103      13    13121    NWIS
    ## 1478         ST 3130002      13    13121    NWIS
    ## 1479         ST 3130002      13    13121    NWIS
    ## 1480         ST 3070103      13    13121    NWIS
    ## 1481         ST 3070103      13    13089    NWIS
    ## 1482         ST 3130001      13    13121    NWIS
    ## 1483         ST 3130001      13    13121    NWIS
    ## 1484         ST 3130002      13    13121    NWIS
    ## 1485         ST 3130002      13    13121    NWIS
    ## 1486         ST 3130002      13    13121    NWIS
    ## 1487         ST 3130002      13    13121    NWIS
    ## 1488         ST 3130001      13    13089    NWIS
    ## 1489         ST 3070103      13    13121    NWIS
    ## 1490         ST 3130001      13    13121    NWIS
    ## 1491         ST 3130002      13    13121    NWIS
    ## 1492         ST 3130001      13    13121    NWIS
    ## 1493         ST 3070103      13    13121    NWIS
    ## 1494         ST 3130001      13    13089    NWIS
    ## 1495         ST 3130002      13    13121    NWIS
    ## 1496         ST 3130001      13    13121    NWIS
    ## 1497         ST 3070103      13    13121    NWIS
    ## 1498         ST 3070103      13    13089    NWIS
    ## 1499         ST 3130001      13    13121    NWIS
    ## 1500         ST 3130002      13    13121    NWIS
    ## 1501         ST 3130002      13    13121    NWIS
    ## 1502         ST 3130001      13    13121    NWIS
    ## 1503         ST 3130002      13    13121    NWIS
    ## 1504         ST 3130001      13    13121    NWIS
    ## 1505         ST 3070103      13    13089    NWIS
    ## 1506         ST 3130002      13    13121    NWIS
    ## 1507         ST 3130002      13    13121    NWIS
    ## 1508         ST 3130002      13    13121    NWIS
    ## 1509         ST 3070103      13    13089    NWIS
    ## 1510         ST 3130002      13    13121    NWIS
    ## 1511         ST 3130001      13    13089    NWIS
    ## 1512         ST 3130001      13    13121    NWIS
    ## 1513         ST 3070103      13    13121    NWIS
    ## 1514         ST 3130002      13    13121    NWIS
    ## 1515         ST 3130001      13    13089    NWIS
    ## 1516         ST 3130002      13    13121    NWIS
    ## 1517         ST 3130001      13    13089    NWIS
    ## 1518         ST 3130001      13    13121    NWIS
    ## 1519         ST 3130002      13    13121    NWIS
    ## 1520         ST 3130002      13    13121    NWIS
    ## 1521         ST 3070103      13    13121    NWIS
    ## 1522         ST 3070103      13    13121    NWIS
    ## 1523         ST 3130002      13    13121    NWIS
    ## 1524         ST 3130002      13    13121    NWIS
    ## 1525         ST 3130001      13    13121    NWIS
    ## 1526         ST 3130001      13    13121    NWIS
    ## 1527         ST 3130001      13    13089    NWIS
    ## 1528         ST 3130002      13    13121    NWIS
    ## 1529         ST 3130001      13    13121    NWIS
    ## 1530         ST 3070103      13    13089    NWIS
    ## 1531         ST 3130001      13    13089    NWIS
    ## 1532         ST 3130001      13    13121    NWIS
    ## 1533         ST 3130001      13    13121    NWIS
    ## 1534         ST 3130002      13    13121    NWIS
    ## 1535         ST 3130002      13    13121    NWIS
    ## 1536         ST 3130002      13    13121    NWIS
    ## 1537         ST 3070103      13    13089    NWIS
    ## 1538         ST 3130001      13    13121    NWIS
    ## 1539         ST 3130001      13    13121    NWIS
    ## 1540         ST 3130001      13    13089    NWIS
    ## 1541         ST 3130001      13    13089    NWIS
    ## 1542         ST 3130001      13    13121    NWIS
    ## 1543         ST 3130001      13    13089    NWIS
    ## 1544         ST 3130002      13    13121    NWIS
    ## 1545         ST 3130001      13    13089    NWIS
    ## 1546         ST 3070103      13    13121    NWIS
    ## 1547         ST 3130002      13    13121    NWIS
    ## 1548         ST 3070103      13    13121    NWIS
    ## 1549         ST 3130001      13    13121    NWIS
    ## 1550         ST 3130001      13    13121    NWIS
    ## 1551         ST 3130001      13    13089    NWIS
    ## 1552         ST 3130002      13    13121    NWIS
    ## 1553         ST 3130002      13    13121    NWIS
    ## 1554         ST 3130002      13    13121    NWIS
    ## 1555         ST 3130001      13    13121    NWIS
    ## 1556         ST 3130002      13    13121    NWIS
    ## 1557         ST 3130001      13    13089    NWIS
    ## 1558         ST 3130002      13    13121    NWIS
    ## 1559         ST 3070103      13    13089    NWIS
    ## 1560         ST 3070103      13    13089    NWIS
    ## 1561         ST 3130001      13    13121    NWIS
    ## 1562         ST 3130002      13    13121    NWIS
    ## 1563         ST 3130001      13    13121    NWIS
    ## 1564         ST 3130002      13    13121    NWIS
    ## 1565         ST 3130001      13    13089    NWIS
    ## 1566         ST 3130002      13    13121    NWIS
    ## 1567         ST 3130002      13    13121    NWIS
    ## 1568         ST 3130001      13    13121    NWIS
    ## 1569         ST 3130001      13    13121    NWIS
    ## 1570         ST 3130001      13    13089    NWIS
    ## 1571         ST 3070103      13    13089    NWIS
    ## 1572         ST 3070103      13    13121    NWIS
    ## 1573         ST 3130001      13    13089    NWIS
    ## 1574         ST 3130002      13    13121    NWIS
    ## 1575         ST 3130001      13    13121    NWIS
    ## 1576         ST 3130001      13    13121    NWIS
    ## 1577         ST 3130001      13    13121    NWIS
    ## 1578         ST 3130002      13    13121    NWIS
    ## 1579         ST 3130002      13    13121    NWIS
    ## 1580         ST 3130001      13    13089    NWIS
    ## 1581         ST 3130001      13    13089    NWIS
    ## 1582         ST 3130002      13    13121    NWIS
    ## 1583         ST 3130002      13    13121    NWIS
    ## 1584         ST 3130001      13    13121    NWIS
    ## 1585         ST 3070103      13    13089    NWIS
    ## 1586         ST 3130002      13    13121    NWIS
    ## 1587         ST 3070103      13    13089    NWIS
    ## 1588         ST 3130001      13    13121    NWIS
    ## 1589         ST 3130001      13    13121    NWIS
    ## 1590         ST 3130001      13    13089    NWIS
    ## 1591         ST 3130002      13    13121    NWIS
    ## 1592         ST 3130001      13    13121    NWIS
    ## 1593         ST 3130002      13    13121    NWIS
    ## 1594         ST 3130001      13    13121    NWIS
    ## 1595         ST 3130002      13    13121    NWIS
    ## 1596         ST 3070103      13    13121    NWIS
    ## 1597         ST 3130001      13    13121    NWIS
    ## 1598         ST 3130002      13    13121    NWIS
    ## 1599         ST 3130002      13    13121    NWIS
    ## 1600         ST 3130001      13    13121    NWIS
    ## 1601         ST 3130001      13    13121    NWIS
    ## 1602         ST 3130002      13    13121    NWIS
    ## 1603         ST 3130001      13    13121    NWIS
    ## 1604         ST 3070103      13    13089    NWIS
    ## 1605         ST 3130001      13    13121    NWIS
    ## 1606         ST 3130001      13    13089    NWIS
    ## 1607         ST 3130002      13    13121    NWIS
    ## 1608         ST 3130001      13    13089    NWIS
    ## 1609         ST 3130001      13    13121    NWIS
    ## 1610         ST 3130002      13    13121    NWIS
    ## 1611         ST 3130001      13    13121    NWIS
    ## 1612         ST 3070103      13    13089    NWIS
    ## 1613         ST 3130001      13    13121    NWIS
    ## 1614         ST 3130001      13    13089    NWIS
    ## 1615         ST 3130001      13    13121    NWIS
    ## 1616         ST 3130001      13    13089    NWIS
    ## 1617         ST 3130001      13    13121    NWIS
    ## 1618         ST 3130001      13    13121    NWIS
    ## 1619         ST 3130002      13    13121    NWIS
    ## 1620         ST 3130001      13    13121    NWIS
    ## 1621         ST 3070103      13    13089    NWIS
    ## 1622         ST 3130002      13    13121    NWIS
    ## 1623         ST 3130002      13    13121    NWIS
    ## 1624         ST 3130001      13    13121    NWIS
    ## 1625         ST 3130001      13    13089    NWIS
    ## 1626         ST 3070103      13    13089    NWIS
    ## 1627         ST 3130001      13    13121    NWIS
    ## 1628         ST 3130001      13    13121    NWIS
    ## 1629         ST 3130001      13    13089    NWIS
    ## 1630         ST 3130001      13    13121    NWIS
    ## 1631         ST 3130001      13    13121    NWIS
    ## 1632         ST 3130001      13    13089    NWIS
    ## 1633         ST 3130001      13    13121    NWIS
    ## 1634         ST 3130002      13    13121    NWIS
    ## 1635         ST 3130002      13    13121    NWIS
    ## 1636         ST 3130001      13    13121    NWIS
    ## 1637         ST 3130002      13    13121    NWIS
    ## 1638         ST 3070103      13    13089    NWIS
    ## 1639         ST 3130001      13    13121    NWIS
    ## 1640         ST 3130001      13    13121    NWIS
    ## 1641         ST 3130001      13    13121    NWIS
    ## 1642         ST 3070103      13    13121    NWIS
    ## 1643         ST 3070103      13    13121    NWIS
    ## 1644         ST 3130001      13    13121    NWIS
    ## 1645         ST 3130001      13    13089    NWIS
    ## 1646         ST 3130002      13    13121    NWIS
    ## 1647         ST 3130001      13    13089    NWIS
    ## 1648         ST 3130001      13    13089    NWIS
    ## 1649         ST 3130001      13    13089    NWIS
    ## 1650         ST 3130001      13    13121    NWIS
    ## 1651         ST 3130001      13    13121    NWIS
    ## 1652         ST 3070103      13    13121    NWIS
    ## 1653         ST 3070103      13    13089    NWIS
    ## 1654         ST 3130002      13    13121    NWIS
    ## 1655         ST 3130001      13    13121    NWIS
    ## 1656         ST 3130001      13    13121    NWIS
    ## 1657         ST 3070103      13    13089    NWIS
    ## 1658         ST 3130001      13    13121    NWIS
    ## 1659         ST 3070103      13    13089    NWIS
    ## 1660         ST 3130001      13    13089    NWIS
    ## 1661         ST 3130001      13    13089    NWIS
    ## 1662         ST 3130001      13    13121    NWIS
    ## 1663         ST 3130002      13    13121    NWIS
    ## 1664         ST 3130001      13    13089    NWIS
    ## 1665         ST 3130001      13    13121    NWIS
    ## 1666         ST 3130002      13    13121    NWIS
    ## 1667         ST 3070103      13    13121    NWIS
    ## 1668         ST 3130001      13    13121    NWIS
    ## 1669         ST 3130001      13    13121    NWIS
    ## 1670         ST 3130002      13    13121    NWIS
    ## 1671         ST 3130001      13    13121    NWIS
    ## 1672         ST 3130001      13    13089    NWIS
    ## 1673         ST 3130002      13    13121    NWIS
    ## 1674         ST 3130001      13    13121    NWIS
    ## 1675         ST 3130001      13    13121    NWIS
    ## 1676         ST 3130001      13    13121    NWIS
    ## 1677         ST 3130002      13    13121    NWIS
    ## 1678         ST 3130002      13    13121    NWIS
    ## 1679         ST 3130001      13    13121    NWIS
    ## 1680         ST 3130001      13    13121    NWIS
    ## 1681         ST 3130001      13    13121    NWIS
    ## 1682         ST 3070103      13    13121    NWIS
    ## 1683         ST 3130001      13    13089    NWIS
    ## 1684         ST 3130001      13    13121    NWIS
    ## 1685         ST 3070103      13    13121    NWIS
    ## 1686         ST 3130001      13    13121    NWIS
    ## 1687         ST 3070103      13    13121    NWIS
    ## 1688         ST 3130002      13    13121    NWIS
    ## 1689         ST 3130001      13    13089    NWIS
    ## 1690         ST 3130001      13    13121    NWIS
    ## 1691         ST 3130002      13    13121    NWIS
    ## 1692         ST 3130001      13    13121    NWIS
    ## 1693         ST 3070103      13    13089    NWIS
    ## 1694         ST 3130001      13    13121    NWIS
    ## 1695         ST 3130001      13    13089    NWIS
    ## 1696         ST 3130001      13    13121    NWIS
    ## 1697         ST 3130001      13    13121    NWIS
    ## 1698         ST 3130002      13    13121    NWIS
    ## 1699         ST 3130001      13    13089    NWIS
    ## 1700         ST 3130002      13    13121    NWIS
    ## 1701         ST 3130001      13    13121    NWIS
    ## 1702         ST 3130002      13    13121    NWIS
    ## 1703         ST 3070103      13    13089    NWIS
    ## 1704         ST 3130002      13    13121    NWIS
    ## 1705         ST 3130002      13    13121    NWIS
    ## 1706         ST 3130001      13    13121    NWIS
    ## 1707         ST 3130001      13    13121    NWIS
    ## 1708         ST 3130001      13    13121    NWIS
    ## 1709         ST 3130001      13    13089    NWIS
    ## 1710         ST 3130001      13    13121    NWIS
    ## 1711         ST 3130001      13    13089    NWIS
    ## 1712         ST 3130001      13    13121    NWIS
    ## 1713         ST 3130001      13    13121    NWIS
    ## 1714         ST 3130001      13    13089    NWIS
    ## 1715         ST 3130001      13    13089    NWIS
    ## 1716         ST 3130001      13    13121    NWIS
    ## 1717         ST 3130001      13    13089    NWIS
    ## 1718         ST 3130001      13    13089    NWIS
    ## 1719         ST 3130001      13    13121    NWIS
    ## 1720         ST 3130001      13    13121    NWIS
    ## 1721         ST 3130002      13    13121    NWIS
    ## 1722         ST 3070103      13    13089    NWIS
    ## 1723         ST 3130002      13    13121    NWIS
    ## 1724         ST 3070103      13    13089    NWIS
    ## 1725         ST 3070103      13    13089    NWIS
    ## 1726         ST 3130001      13    13121    NWIS
    ## 1727         ST 3130002      13    13121    NWIS
    ## 1728         ST 3130002      13    13121    NWIS
    ## 1729         ST 3070103      13    13121    NWIS
    ## 1730         ST 3130002      13    13121    NWIS
    ## 1731         ST 3130001      13    13121    NWIS
    ## 1732         ST 3130002      13    13121    NWIS
    ## 1733         ST 3070103      13    13089    NWIS
    ## 1734         ST 3130001      13    13089    NWIS
    ## 1735         ST 3130002      13    13121    NWIS
    ## 1736         ST 3130002      13    13121    NWIS
    ## 1737         ST 3130001      13    13089    NWIS
    ## 1738         ST 3130001      13    13121    NWIS
    ## 1739         ST 3130001      13    13121    NWIS
    ## 1740         ST 3130002      13    13121    NWIS
    ## 1741         ST 3130001      13    13121    NWIS
    ## 1742         ST 3130002      13    13121    NWIS
    ## 1743         ST 3130002      13    13121    NWIS
    ## 1744         ST 3130002      13    13121    NWIS
    ## 1745         ST 3130001      13    13089    NWIS
    ## 1746         ST 3130001      13    13121    NWIS
    ## 1747         ST 3130002      13    13121    NWIS
    ## 1748         ST 3130001      13    13121    NWIS
    ## 1749         ST 3130002      13    13121    NWIS
    ## 1750         ST 3070103      13    13089    NWIS
    ## 1751         ST 3130001      13    13089    NWIS
    ## 1752         ST 3130002      13    13121    NWIS
    ## 1753         ST 3130001      13    13121    NWIS
    ## 1754         ST 3070103      13    13121    NWIS
    ## 1755         ST 3130001      13    13089    NWIS
    ## 1756         ST 3130002      13    13121    NWIS
    ## 1757         ST 3130002      13    13121    NWIS
    ## 1758         ST 3130001      13    13089    NWIS
    ## 1759         ST 3130002      13    13121    NWIS
    ## 1760         ST 3130001      13    13089    NWIS
    ## 1761         ST 3130001      13    13089    NWIS
    ## 1762         ST 3130002      13    13121    NWIS
    ## 1763         ST 3070103      13    13089    NWIS
    ## 1764         ST 3130001      13    13121    NWIS
    ## 1765         ST 3130001      13    13121    NWIS
    ## 1766         ST 3130002      13    13121    NWIS
    ## 1767         ST 3130002      13    13121    NWIS
    ## 1768         ST 3130001      13    13121    NWIS
    ## 1769         ST 3130001      13    13089    NWIS
    ## 1770         ST 3130002      13    13121    NWIS
    ## 1771         ST 3070103      13    13121    NWIS
    ## 1772         ST 3130001      13    13121    NWIS
    ## 1773         ST 3130001      13    13089    NWIS
    ## 1774         ST 3130001      13    13121    NWIS
    ## 1775         ST 3130002      13    13121    NWIS
    ## 1776         ST 3130001      13    13121    NWIS
    ## 1777         ST 3130002      13    13121    NWIS
    ## 1778         ST 3130001      13    13089    NWIS
    ## 1779         ST 3130001      13    13121    NWIS
    ## 1780         ST 3130001      13    13121    NWIS
    ## 1781         ST 3130001      13    13089    NWIS
    ## 1782         ST 3130001      13    13121    NWIS
    ## 1783         ST 3070103      13    13089    NWIS
    ## 1784         ST 3130001      13    13089    NWIS
    ## 1785         ST 3130001      13    13089    NWIS
    ## 1786         ST 3130002      13    13121    NWIS
    ## 1787         ST 3130002      13    13121    NWIS
    ## 1788         ST 3130001      13    13121    NWIS
    ## 1789         ST 3130001      13    13089    NWIS
    ## 1790         ST 3130001      13    13121    NWIS
    ## 1791         ST 3130001      13    13121    NWIS
    ## 1792         ST 3070103      13    13121    NWIS
    ## 1793         ST 3070103      13    13089    NWIS
    ## 1794         ST 3130001      13    13089    NWIS
    ## 1795         ST 3130001      13    13089    NWIS
    ## 1796         ST 3070103      13    13121    NWIS
    ## 1797         ST 3130002      13    13121    NWIS
    ## 1798         ST 3130001      13    13121    NWIS
    ## 1799         ST 3130002      13    13121    NWIS
    ## 1800         ST 3070103      13    13121    NWIS
    ## 1801         ST 3130001      13    13089    NWIS
    ## 1802         ST 3130001      13    13121    NWIS
    ## 1803         ST 3130001      13    13121    NWIS
    ## 1804         ST 3130001      13    13121    NWIS
    ## 1805         ST 3130002      13    13121    NWIS
    ## 1806         ST 3130001      13    13089    NWIS
    ## 1807         ST 3070103      13    13089    NWIS
    ## 1808         ST 3130002      13    13121    NWIS
    ## 1809         ST 3130002      13    13121    NWIS
    ## 1810         ST 3130001      13    13089    NWIS
    ## 1811         ST 3130001      13    13121    NWIS
    ## 1812         ST 3130002      13    13121    NWIS
    ## 1813         ST 3130001      13    13089    NWIS
    ## 1814         ST 3130001      13    13089    NWIS
    ## 1815         ST 3070103      13    13121    NWIS
    ## 1816         ST 3070103      13    13121    NWIS
    ## 1817         ST 3130002      13    13121    NWIS
    ## 1818         ST 3130001      13    13121    NWIS
    ## 1819         ST 3130001      13    13121    NWIS
    ## 1820         ST 3130001      13    13089    NWIS
    ## 1821         ST 3130002      13    13121    NWIS
    ## 1822         ST 3130002      13    13121    NWIS
    ## 1823         ST 3130001      13    13121    NWIS
    ## 1824         ST 3130001      13    13121    NWIS
    ## 1825         ST 3130001      13    13121    NWIS
    ## 1826         ST 3130001      13    13089    NWIS
    ## 1827         ST 3070103      13    13089    NWIS
    ## 1828         ST 3130001      13    13121    NWIS
    ## 1829         ST 3130001      13    13121    NWIS
    ## 1830         ST 3130001      13    13089    NWIS
    ## 1831         ST 3130001      13    13121    NWIS
    ## 1832         ST 3130001      13    13121    NWIS
    ## 1833         ST 3130001      13    13121    NWIS
    ## 1834         ST 3130001      13    13121    NWIS
    ## 1835         ST 3130001      13    13089    NWIS
    ## 1836         ST 3130002      13    13121    NWIS
    ## 1837         ST 3130001      13    13121    NWIS
    ## 1838         ST 3130001      13    13121    NWIS
    ## 1839         ST 3130001      13    13089    NWIS
    ## 1840         ST 3130001      13    13121    NWIS
    ## 1841         ST 3130001      13    13089    NWIS
    ## 1842         ST 3130002      13    13121    NWIS
    ## 1843         ST 3130002      13    13121    NWIS
    ## 1844         ST 3130002      13    13121    NWIS
    ## 1845         ST 3130002      13    13121    NWIS
    ## 1846         ST 3130001      13    13089    NWIS
    ## 1847         ST 3130001      13    13121    NWIS
    ## 1848         ST 3130002      13    13121    NWIS
    ## 1849         ST 3130002      13    13121    NWIS
    ## 1850         ST 3130002      13    13121    NWIS
    ## 1851         ST 3130001      13    13121    NWIS
    ## 1852         ST 3130001      13    13089    NWIS
    ## 1853         ST 3130002      13    13121    NWIS
    ## 1854         ST 3130001      13    13121    NWIS
    ## 1855         ST 3130002      13    13121    NWIS
    ## 1856         ST 3130001      13    13089    NWIS
    ## 1857         ST 3130001      13    13121    NWIS
    ## 1858         ST 3130002      13    13121    NWIS
    ## 1859         ST 3130001      13    13121    NWIS
    ## 1860         ST 3130001      13    13121    NWIS
    ## 1861         ST 3130001      13    13121    NWIS
    ## 1862         ST 3130001      13    13121    NWIS
    ## 1863         ST 3070103      13    13089    NWIS
    ## 1864         ST 3130001      13    13121    NWIS
    ## 1865         ST 3130002      13    13121    NWIS
    ## 1866         ST 3130001      13    13089    NWIS
    ## 1867         ST 3130002      13    13121    NWIS
    ## 1868         ST 3130002      13    13121    NWIS
    ## 1869         ST 3070103      13    13089    NWIS
    ## 1870         ST 3130001      13    13121    NWIS
    ## 1871         ST 3130002      13    13121    NWIS
    ## 1872         ST 3130002      13    13121    NWIS
    ## 1873         ST 3130002      13    13121    NWIS
    ## 1874         ST 3130001      13    13121    NWIS
    ## 1875         ST 3130001      13    13121    NWIS
    ## 1876         ST 3070103      13    13121    NWIS
    ## 1877         ST 3130001      13    13121    NWIS
    ## 1878         ST 3130002      13    13121    NWIS
    ## 1879         ST 3130001      13    13121    NWIS
    ## 1880         ST 3130002      13    13121    NWIS
    ## 1881         ST 3130001      13    13121    NWIS
    ## 1882         ST 3130001      13    13121    NWIS
    ## 1883         ST 3070103      13    13089    NWIS
    ## 1884         ST 3130002      13    13121    NWIS
    ## 1885         ST 3070103      13    13089    NWIS
    ## 1886         ST 3130002      13    13121    NWIS
    ## 1887         ST 3130002      13    13121    NWIS
    ## 1888         ST 3070103      13    13089    NWIS
    ## 1889         ST 3130001      13    13121    NWIS
    ## 1890         ST 3130002      13    13121    NWIS
    ## 1891         ST 3130002      13    13121    NWIS
    ## 1892         ST 3130001      13    13089    NWIS
    ## 1893         ST 3130001      13    13121    NWIS
    ## 1894         ST 3130001      13    13121    NWIS
    ## 1895         ST 3130001      13    13089    NWIS
    ## 1896         ST 3070103      13    13089    NWIS
    ## 1897         ST 3130001      13    13121    NWIS
    ## 1898         ST 3130001      13    13121    NWIS
    ## 1899         ST 3130002      13    13121    NWIS
    ## 1900         ST 3130002      13    13121    NWIS
    ## 1901         ST 3130001      13    13121    NWIS
    ## 1902         ST 3070103      13    13089    NWIS
    ## 1903         ST 3070103      13    13089    NWIS
    ## 1904         ST 3130001      13    13089    NWIS
    ## 1905         ST 3130001      13    13121    NWIS
    ## 1906         ST 3130001      13    13121    NWIS
    ## 1907         ST 3130002      13    13121    NWIS
    ## 1908         ST 3130002      13    13121    NWIS
    ## 1909         ST 3130001      13    13089    NWIS
    ## 1910         ST 3130001      13    13089    NWIS
    ## 1911         ST 3130001      13    13121    NWIS
    ## 1912         ST 3130001      13    13089    NWIS
    ## 1913         ST 3130002      13    13121    NWIS
    ## 1914         ST 3130001      13    13121    NWIS
    ## 1915         ST 3130002      13    13121    NWIS
    ## 1916         ST 3130001      13    13121    NWIS
    ## 1917         ST 3130001      13    13121    NWIS
    ## 1918         ST 3130002      13    13121    NWIS
    ## 1919         ST 3130001      13    13089    NWIS
    ## 1920         ST 3130002      13    13121    NWIS
    ## 1921         ST 3130001      13    13121    NWIS
    ## 1922         ST 3130001      13    13121    NWIS
    ## 1923         ST 3130001      13    13121    NWIS
    ## 1924         ST 3130001      13    13121    NWIS
    ## 1925         ST 3130001      13    13121    NWIS
    ## 1926         ST 3070103      13    13121    NWIS
    ## 1927         ST 3130002      13    13121    NWIS
    ## 1928         ST 3130001      13    13121    NWIS
    ## 1929         ST 3130001      13    13121    NWIS
    ## 1930         ST 3130001      13    13121    NWIS
    ## 1931         ST 3130001      13    13121    NWIS
    ## 1932         ST 3130001      13    13089    NWIS
    ## 1933         ST 3130001      13    13121    NWIS
    ## 1934         ST 3130002      13    13121    NWIS
    ## 1935         ST 3130001      13    13089    NWIS
    ## 1936         ST 3130002      13    13121    NWIS
    ## 1937         ST 3130001      13    13121    NWIS
    ## 1938         ST 3130001      13    13089    NWIS
    ## 1939         ST 3130002      13    13121    NWIS
    ## 1940         ST 3130001      13    13121    NWIS
    ## 1941         ST 3130001      13    13089    NWIS
    ## 1942         ST 3130002      13    13121    NWIS
    ## 1943         ST 3070103      13    13121    NWIS
    ## 1944         ST 3130001      13    13121    NWIS
    ## 1945         ST 3130002      13    13121    NWIS
    ## 1946         ST 3130001      13    13121    NWIS
    ## 1947         ST 3130001      13    13121    NWIS
    ## 1948         ST 3130001      13    13089    NWIS
    ## 1949         ST 3130002      13    13121    NWIS
    ## 1950         ST 3130002      13    13121    NWIS

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

    ##       site_no            dateTime Flow
    ## 136  02336240 2011-05-12 09:15:00 11.0
    ## 1255 02336410 2011-05-09 06:45:00 21.0
    ## 603  02336240 2011-05-22 19:45:00  8.9
    ## 1256 02203655 2011-05-29 22:00:00 11.0
    ## 1604 02203700 2011-05-08 06:45:00  5.1
    ## 1622 02336526 2011-05-04 00:30:00 67.0

``` r
head(DO)
```

    ##       site_no            dateTime   DO
    ## 1622 02336526 2011-05-04 00:30:00  8.1
    ## 229  02336300 2011-05-16 18:30:00  9.0
    ## 931  02203700 2011-05-12 21:30:00 10.0
    ## 603  02336240 2011-05-22 19:45:00  9.6
    ## 741  02336360 2011-05-27 01:30:00  6.8
    ## 766  02336410 2011-05-05 22:45:00  8.8

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
    ## 1 02203700 2011-05-10 07:30:00  4.6       A  20.2 7.3 3.3   68.36
    ## 2 02203700 2011-05-16 21:45:00 11.0       A  19.4 7.1 3.3   66.92
    ## 3 02203700 2011-05-11 05:45:00  4.6     A e  22.1 7.4 3.5   71.78
    ## 4 02203700 2011-05-10 05:45:00  4.9       A  20.9  NA 3.5   69.62
    ## 5 02203700 2011-05-11 10:15:00  4.6     A e  20.3 7.4 3.5   68.54
    ## 6 02203700 2011-05-11 03:15:00  4.9     A e  23.4 7.4 3.6   74.12

``` r
#descending
head(arrange(intro_df, desc(DO)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH   DO Wtemp_F
    ## 1 02336526 2011-05-18 22:15:00  3.6     A e  17.4 8.9 12.8   63.32
    ## 2 02336526 2011-05-19 22:00:00  3.6       A  19.8 8.9 12.6   67.64
    ## 3 02336526 2011-05-20 19:30:00  3.5       A  21.5 8.6 12.2   70.70
    ## 4 02336526 2011-05-17 21:15:00  3.6       A  16.4 8.1 12.2   61.52
    ## 5 02336526 2011-05-21 22:00:00  3.5       A  23.9 9.0 12.1   75.02
    ## 6 02336526 2011-05-25 20:45:00  2.8       A  25.4 8.7 12.1   77.72

``` r
#multiple columns: lowest flow with highest temperature at top
head(arrange(intro_df, Flow, desc(Wtemp)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO Wtemp_F
    ## 1 02336313 2011-06-01 03:45:00 0.65       A  25.3 7.2 4.6   77.54
    ## 2 02336313 2011-05-31 20:15:00 0.69       A  26.9 7.2 7.0   80.42
    ## 3 02336313 2011-05-30 23:15:00 0.69       A  26.3 7.3 5.8   79.34
    ## 4 02336313 2011-05-31 01:30:00 0.69       A  25.7 7.3 5.6   78.26
    ## 5 02336313 2011-05-31 01:15:00 0.69       A  25.7 7.3 5.4   78.26
    ## 6 02336313 2011-05-31 03:45:00 0.69       A  24.8 7.4 5.4   76.64

Now `slice()`, which accomplishes what we did with the numeric indices before. Remembering back to that, we could grab rows of the data frame with something like `intro_df[3:10,]` or we can use `slice`:

``` r
#grab rows 3 through 10
slice(intro_df, 3:10)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH   DO Wtemp_F
    ## 1 02203655 2011-05-22 09:30:00    7.8       A  20.6 7.0  6.6   69.08
    ## 2 02336313 2011-05-22 12:00:00    1.3       A  19.3 7.2  7.3   66.74
    ## 3 02203700 2011-05-09 10:30:00    4.9       A  18.0 7.2  4.4   64.40
    ## 4 02336313 2011-05-13 12:15:00    1.0       A  20.4 7.2  7.1   68.72
    ## 5 02337170 2011-05-18 23:15:00 4510.0       A  13.5 6.9 10.0   56.30
    ## 6 02336120 2011-05-08 15:45:00   17.0     A e  17.6 7.2  8.7   63.68
    ## 7 02336526 2011-05-11 11:30:00    4.0       A  20.8 7.0  6.6   69.44
    ## 8 02336410 2011-05-10 04:15:00   19.0       A  21.5 7.0  7.2   70.70

We now have quite a few tools that we can use to clean and manipulate data in R. We have barely touched what both base R and `dplyr` are capable of accomplishing, but hopefully you now have some basics to build on.
