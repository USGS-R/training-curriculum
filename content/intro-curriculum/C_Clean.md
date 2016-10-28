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
-   [Exercise 3](#exercise-3): Using `dplyr` to modify and summarize data.

Lesson Goals
------------

-   Show and tell on using base R for data manipulation
-   Better understand data cleaning through use of `dplyr`
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
```

You might have noticed that the date column is treated as character and not Date or POSIX. Handling dates are beyond this course, but they are available in this dataset if you would like to work with them.

Exercise 1
----------

This exercise is going to focus on using what we just covered on `dplyr` to start to clean up a dataset. Our goal for this is to create a new data frame that represents a subset of the observations as well as a subset of the data.

1.  Using dplyr, remove the `Flow_cd` column. Think `select()`. Give the new data frame a new name, so you can distinguish it from your raw data.
2.  Next, we are going to get a subset of the observations. We only want data where flow was greater than 10 cubic feet per second. Also give this data frame a different name than before.
3.  Lastly, add a new column with flow in units of cubic meters per second. Hint: there are 3.28 feet in a meter.

Merging Data
------------

Joining data in `dplyr` is accomplished via the various `x_join()` commands (e.g., `inner_join`, `left_join`, `anti_join`, etc). These are very SQL-esque so if you speak SQL then these will be pretty easy for you. If not then they aren't immediately intuitive. There are also the base functions `rbind()` and `merge()`, but we won't be covering these because they are redundant with the faster, more readable `dplyr` functions.

We are going to talk about several different ways to do this. First, let's add some new rows to a data frame. This is very handy as you might have data collected and entered at one time, and then additional observations made later that need to be added. So with `rbind()` we can stack two data frames with the same columns to store more observations.

In this example, let's imagine we collected 3 new observations for water temperature and pH at the site "00000001". Notice that we did not collect anything for discharge or dissolved oxygen. What happens in the columns that don't match when the we bind the rows of these two data frames?

``` r
#Let's first create a new small example data.frame
new_data <- data.frame(site_no=rep("00000001", 3), 
                       dateTime=c("2016-09-01 07:45:00", "2016-09-02 07:45:00", "2016-09-03 07:45:00"), 
                       Wtemp=c(14.0, 16.4, 16.0),
                       pH = c(7.8, 8.5, 8.3),
                       stringsAsFactors = FALSE)
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

    ##       site_no            dateTime Flow Flow_cd Wtemp  pH  DO
    ## 2998 02337170 2011-05-15 12:15:00 2280     A e  15.1 6.9 9.6
    ## 2999 02336728 2011-05-31 11:00:00   13       A  22.7 7.0 7.3
    ## 3000 02336120 2011-05-01 12:15:00   18       E  18.0 7.1 7.9
    ## 3001 00000001 2016-09-01 07:45:00   NA    <NA>  14.0 7.8  NA
    ## 3002 00000001 2016-09-02 07:45:00   NA    <NA>  16.4 8.5  NA
    ## 3003 00000001 2016-09-03 07:45:00   NA    <NA>  16.0 8.3  NA

Now something to think about. Could you add a vector as a new row? Why/Why not? When/When not?

Let's go back to the columns now. There are simple ways to add columns of the same length with observations in the same order to a data frame, but it is very common to have to datasets that are in different orders and have differing numbers of rows. What we want to do in that case is going to be more of a database type function and join two tables based on a common column. We can achieve this by using `x_join` functions. So let's imagine that we did actually collect dissolved oxygen, discharge, and chloride concentration on our observation dates. Also, we collected on some additional dates. We don't care about the additional dates, so use the `left_join` function from `dplyr`, which keeps all rows from the first (left) data frame. See `?left_join` for more information.

``` r
# DO and discharge data
forgotten_data <- data.frame(site_no=rep("00000001", 5),
                             dateTime=c("2016-09-01 07:45:00", "2016-09-02 07:45:00", "2016-09-03 07:45:00",
                                        "2016-09-04 07:45:00", "2016-09-05 07:45:00"),
                             DO=c(10.2,8.7,9.3,9.2,8.9),
                             Cl_conc=c(15.6,11.0,14.2,13.6,13.7),
                             Flow=c(25,54,67,60,59),
                             stringsAsFactors = FALSE)

left_join(new_data, forgotten_data, by=c("site_no", "dateTime"))
```

    ##    site_no            dateTime Wtemp  pH   DO Cl_conc Flow
    ## 1 00000001 2016-09-01 07:45:00  14.0 7.8 10.2    15.6   25
    ## 2 00000001 2016-09-02 07:45:00  16.4 8.5  8.7    11.0   54
    ## 3 00000001 2016-09-03 07:45:00  16.0 8.3  9.3    14.2   67

Notice that the `left_join` kept only the matching rows (September 1-3), but kept all columns. If we wanted to remove the chloride concentration column, we can use `select` which we learned earlier in this lesson.

Exercise 2
----------

In this exercise we are going to practice merging data. We will be using two subsets of`intro_df` (see) the code snippet below).

``` r
# could use sample_n() to select random rows, but we want everyone in the class to have the same values
# e.g. sample_n(intro_df, size=20)

#subset intro_df
rows2keep <- c(1634, 1123, 2970, 1052, 2527, 1431, 2437, 1877, 2718, 2357, 
               1290, 225, 479, 1678, 274, 1816, 418, 1777, 611, 2993)
intro_df_subset <- intro_df[rows2keep,]

# keep only flow for one dataframe
Q <- select(intro_df_subset, site_no, dateTime, Flow)

# select 8 values and only keep DO for second dataframe
DO <- intro_df_subset[c(1, 5, 7, 9, 12, 16, 17, 19),]
DO <- select(DO, site_no, dateTime, DO)

head(Q)
```

    ##       site_no            dateTime Flow
    ## 1634 02336313 2011-05-01 12:45:00  1.1
    ## 1123 02336360 2011-05-03 20:30:00 14.0
    ## 2970 02336410 2011-05-18 12:45:00 16.0
    ## 1052 02336360 2011-05-08 21:15:00 13.0
    ## 2527 02336360 2011-05-22 13:30:00  9.8
    ## 1431 02203655 2011-05-06 08:30:00 12.0

``` r
head(DO)
```

    ##       site_no            dateTime  DO
    ## 1634 02336313 2011-05-01 12:45:00 7.2
    ## 2527 02336360 2011-05-22 13:30:00 7.5
    ## 2437 02336313 2011-05-29 09:15:00 6.0
    ## 2718 02336240 2011-05-17 00:00:00 8.6
    ## 225  02336360 2011-05-08 23:15:00 8.5
    ## 1816 02203655 2011-05-28 06:15:00 7.0

1.  Run the lines above to create the two data frames we will be working with.
2.  Create a new data frame, `DO_Q`, that is a merge of `Q` and `DO`, but with only lines in `DO` preserved in the output. The columns to merge on are the site and date columns.
3.  Now try merging, but keeping all `Q` observations, and call it `Q_DO`. You should notice a lot of `NA` values where the `DO` dataframe did not have a matching observation.
4.  Add another line to your code and create a data frame that removes all NA values from `Q_DO`. Woah - that's the same dataframe as our `DO_Q`!
5.  If that goes quickly, feel free to explore other joins (`inner_join`, `full_join`, etc).

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
intro_df_summary <- summarize(intro_df_grouped, mean(Flow), mean(Wtemp))
intro_df_summary
```

    ## # A tibble: 11 x 3
    ##     site_no mean(Flow) mean(Wtemp)
    ##       <chr>      <dbl>       <dbl>
    ## 1  02203655         NA          NA
    ## 2  02203700         NA          NA
    ## 3  02336120         NA          NA
    ## 4  02336240         NA          NA
    ## 5  02336300         NA          NA
    ## 6  02336313         NA          NA
    ## 7  02336360         NA          NA
    ## 8  02336410         NA          NA
    ## 9  02336526         NA          NA
    ## 10 02336728         NA          NA
    ## 11 02337170         NA          NA

Notice that this summary just returns NAs. We need the mean calculations to ignore the NA values. We could remove the NAs using `filter()` and then pass that data.frame into `summarize`, or we can tell the mean function to ignore the NAs using the argument `na.rm=TRUE` in the `mean` function. See `?mean` to learn more about this argument.

``` r
intro_df_summary <- summarize(intro_df_grouped, mean(Flow, na.rm=TRUE), mean(Wtemp, na.rm=TRUE))
intro_df_summary
```

    ## # A tibble: 11 x 3
    ##     site_no mean(Flow, na.rm = TRUE) mean(Wtemp, na.rm = TRUE)
    ##       <chr>                    <dbl>                     <dbl>
    ## 1  02203655                33.323762                  19.92233
    ## 2  02203700                 6.446245                  20.15709
    ## 3  02336120                33.730368                  20.42346
    ## 4  02336240                56.163265                  20.23841
    ## 5  02336300                34.072650                  20.69274
    ## 6  02336313                 1.005055                  20.55941
    ## 7  02336360                21.761348                  20.74409
    ## 8  02336410                26.837037                  20.72316
    ## 9  02336526                17.418387                  20.77638
    ## 10 02336728                36.441089                  21.09694
    ## 11 02337170              3190.458015                  18.16958

There are many other functions in `dplyr` that are useful. Let's run through some examples with `arrange()` and `slice()`.

First `arrange()` will re-order a data frame based on the values in a specified column. It will take multiple columns and can be in descending or ascending order.

``` r
#ascending order is default
head(arrange(intro_df, DO))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO
    ## 1 02203700 2011-05-11 07:15:00  4.6       X  21.4 7.4 3.2
    ## 2 02203700 2011-05-11 07:45:00  4.6       E  21.2 7.4 3.2
    ## 3 02203700 2011-05-11 06:45:00   NA       E  21.6 7.4 3.3
    ## 4 02203700 2011-05-10 07:30:00  4.6       A  20.2 7.3 3.3
    ## 5 02203700 2011-05-11 07:00:00  4.6       X  21.5 7.4 3.3
    ## 6 02203700 2011-05-16 21:45:00 11.0       A  19.4 7.1 3.3

``` r
#descending
head(arrange(intro_df, desc(DO)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH   DO
    ## 1 02336526 2011-05-18 22:15:00  3.6     A e  17.4 8.9 12.8
    ## 2 02336526 2011-05-19 22:00:00  3.6       A  19.8 8.9 12.6
    ## 3 02336526 2011-05-24 21:00:00  3.0       E  25.3 8.9 12.4
    ## 4 02336526 2011-05-20 19:30:00  3.5       A  21.5 8.6 12.2
    ## 5 02336526 2011-05-17 21:15:00  3.6       A  16.4 8.1 12.2
    ## 6 02336526 2011-05-21 22:00:00  3.5       A  23.9 9.0 12.1

``` r
#multiple columns: lowest flow with highest temperature at top
head(arrange(intro_df, Flow, desc(Wtemp)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO
    ## 1 02336313 2011-05-31 23:30:00 0.65       E  26.6 7.3 5.6
    ## 2 02336313 2011-06-01 03:45:00 0.65       A  25.3 7.2 4.6
    ## 3 02336313 2011-05-31 20:15:00 0.69       A  26.9 7.2 7.0
    ## 4 02336313 2011-05-30 23:15:00 0.69       A  26.3 7.3 5.8
    ## 5 02336313 2011-05-30 23:45:00 0.69       E  26.2 7.3 5.9
    ## 6 02336313 2011-05-31 01:30:00 0.69       A  25.7 7.3 5.6

Now `slice()`, which accomplishes what we did with the numeric indices before. Remembering back to that, we could grab rows of the data frame with something like `intro_df[3:10,]` or we can use `slice`:

``` r
#grab rows 3 through 10
slice(intro_df, 3:10)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH   DO
    ## 1 02203655 2011-05-22 09:30:00    7.8       A  20.6 7.0  6.6
    ## 2 02336240 2011-05-14 23:15:00   10.0       X  22.0 7.3  7.8
    ## 3 02336313 2011-05-22 12:00:00    1.3       A  19.3 7.2  7.3
    ## 4 02336728 2011-05-25 01:30:00    8.6       X  24.2 7.1  7.3
    ## 5 02203700 2011-05-09 10:30:00    4.9       A  18.0 7.2  4.4
    ## 6 02337170 2011-05-30 13:30:00 1350.0       X  22.6 6.9  7.1
    ## 7 02336313 2011-05-13 12:15:00    1.0       A  20.4 7.2  7.1
    ## 8 02337170 2011-05-18 23:15:00 4510.0       A  13.5 6.9 10.0

Lastly, one more function, `rowwise()`, allows us to run rowwise, operations. Let's say we had two dissolved oxygen columns, and we only wanted to keep the maximum value out of the two for each observation. This can easily be accomplished using`rowwise`. First, add a new dissolved oxygen column with random values (see `?runif`).

``` r
intro_df_2DO <- mutate(intro_df, DO_2 = runif(n=nrow(intro_df), min = 5.0, max = 18.0))
head(intro_df_2DO)
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO      DO_2
    ## 1 02203700 2011-05-20 16:45:00  4.0     A e    NA 7.0 8.6  7.184540
    ## 2 02336410 2011-05-28 08:15:00 35.0       A  21.8 6.9 6.9 15.497713
    ## 3 02203655 2011-05-22 09:30:00  7.8       A  20.6 7.0 6.6 10.004251
    ## 4 02336240 2011-05-14 23:15:00 10.0       X  22.0 7.3 7.8  9.260546
    ## 5 02336313 2011-05-22 12:00:00  1.3       A  19.3 7.2 7.3 12.827309
    ## 6 02336728 2011-05-25 01:30:00  8.6       X  24.2 7.1 7.3 12.857123

Now, let's use `rowwise` to find the maximum dissolved oxygen for each observation.

``` r
head(mutate(intro_df_2DO, max_DO = max(DO, DO_2)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO      DO_2 max_DO
    ## 1 02203700 2011-05-20 16:45:00  4.0     A e    NA 7.0 8.6  7.184540     NA
    ## 2 02336410 2011-05-28 08:15:00 35.0       A  21.8 6.9 6.9 15.497713     NA
    ## 3 02203655 2011-05-22 09:30:00  7.8       A  20.6 7.0 6.6 10.004251     NA
    ## 4 02336240 2011-05-14 23:15:00 10.0       X  22.0 7.3 7.8  9.260546     NA
    ## 5 02336313 2011-05-22 12:00:00  1.3       A  19.3 7.2 7.3 12.827309     NA
    ## 6 02336728 2011-05-25 01:30:00  8.6       X  24.2 7.1 7.3 12.857123     NA

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

    ## # A tibble: 6 x 9
    ##    site_no            dateTime  Flow Flow_cd Wtemp    pH    DO      DO_2
    ##      <chr>               <chr> <dbl>   <chr> <dbl> <dbl> <dbl>     <dbl>
    ## 1 02203700 2011-05-20 16:45:00   4.0     A e    NA   7.0   8.6  7.184540
    ## 2 02336410 2011-05-28 08:15:00  35.0       A  21.8   6.9   6.9 15.497713
    ## 3 02203655 2011-05-22 09:30:00   7.8       A  20.6   7.0   6.6 10.004251
    ## 4 02336240 2011-05-14 23:15:00  10.0       X  22.0   7.3   7.8  9.260546
    ## 5 02336313 2011-05-22 12:00:00   1.3       A  19.3   7.2   7.3 12.827309
    ## 6 02336728 2011-05-25 01:30:00   8.6       X  24.2   7.1   7.3 12.857123
    ## # ... with 1 more variables: max_DO <dbl>

We now have quite a few tools that we can use to clean and manipulate data in R. We have barely touched what both base R and `dplyr` are capable of accomplishing, but hopefully you now have some basics to build on.

Let's practice some of these last functions.

Exercise 3
----------

Next, we're going to practice summarizing large datasets (using `intro_df`). If you complete a step and notice that your neighbor has not, see if you can answer any questions to help them get it done.

1.  Create a new data.frame that gives the maximum water temperature (`Wtemp`) for each site and name it `intro_df_max_site_temp`. Hint: don't forget about `group_by()`, and use `na.rm=TRUE` in statistics functions!

2.  Next, create a new data.frame that gives the average water temperature (`Wtemp`) for each pH value and name it `intro_df_mean_pH_temp`.

3.  Challenge: Find the minimum flow, water temperature, and dissolved oxygen for each site using `summarize_at`.
