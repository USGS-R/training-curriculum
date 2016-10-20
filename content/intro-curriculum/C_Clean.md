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
    ## 1 02337170 2011-05-19 01:00:00    4270.0            A       13.4     6.9
    ## 2 02336120 2011-05-19 02:30:00      13.0            E       16.9    <NA>
    ## 3 02336300 2011-05-12 22:00:00      27.0            X       26.4     7.5
    ## 4 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 5 02336313 2011-05-08 14:30:00       1.1            A       17.7     7.2
    ## 6 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ##   DO_Inst
    ## 1    10.0
    ## 2     8.6
    ## 3     8.5
    ## 4     6.8
    ## 5     8.9
    ## 6     7.0

``` r
#And grab the first site_no
intro_df[1,1]
```

    ## [1] "02337170"

``` r
#Get a whole column
head(intro_df[,7])
```

    ## [1] 10.0  8.6  8.5  6.8  8.9  7.0

``` r
#Get a single row
intro_df[15,]
```

    ##     site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 15 02336360 2011-05-21 10:00:00       9.8          A e       19.1     7.1
    ##    DO_Inst
    ## 15     7.3

``` r
#Grab multiple rows
intro_df[3:7,]
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 3 02336300 2011-05-12 22:00:00      27.0            X       26.4     7.5
    ## 4 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 5 02336313 2011-05-08 14:30:00       1.1            A       17.7     7.2
    ## 6 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ## 7 02337170 2011-05-26 08:00:00    1760.0            A       20.0       7
    ##   DO_Inst
    ## 3     8.5
    ## 4     6.8
    ## 5     8.9
    ## 6     7.0
    ## 7     8.5

Did you notice the difference between subsetting by a row and subsetting by a column? Subsetting a column returns a vector, but subsetting a row returns a data.frame. This is because columns (like vectors) contain a single data type, but rows can contain multiple data types, so it could not become a vector.

Also remember that data frames have column names. We can use those too. Let's try it.

``` r
#First, there are a couple of ways to use the column names
head(intro_df$site_no)
```

    ## [1] "02337170" "02336120" "02336300" "02336526" "02336313" "02336360"

``` r
head(intro_df["site_no"])
```

    ##    site_no
    ## 1 02337170
    ## 2 02336120
    ## 3 02336300
    ## 4 02336526
    ## 5 02336313
    ## 6 02336360

``` r
head(intro_df[["site_no"]])
```

    ## [1] "02337170" "02336120" "02336300" "02336526" "02336313" "02336360"

``` r
#Multiple colums
head(intro_df[c("dateTime","Flow_Inst")])
```

    ##              dateTime Flow_Inst
    ## 1 2011-05-19 01:00:00    4270.0
    ## 2 2011-05-19 02:30:00      13.0
    ## 3 2011-05-12 22:00:00      27.0
    ## 4 2011-05-24 13:15:00       3.1
    ## 5 2011-05-08 14:30:00       1.1
    ## 6 2011-05-22 10:15:00       9.8

``` r
#Now we can combine what we have seen to do some more complex queries
#Get all the data where water temperature is greater than 15
high_temp <- intro_df[intro_df$Wtemp_Inst > 15,]
head(high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 2 02336120 2011-05-19 02:30:00      13.0            E       16.9    <NA>
    ## 3 02336300 2011-05-12 22:00:00      27.0            X       26.4     7.5
    ## 4 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 5 02336313 2011-05-08 14:30:00       1.1            A       17.7     7.2
    ## 6 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ## 7 02337170 2011-05-26 08:00:00    1760.0            A       20.0       7
    ##   DO_Inst
    ## 2     8.6
    ## 3     8.5
    ## 4     6.8
    ## 5     8.9
    ## 6     7.0
    ## 7     8.5

``` r
#Or maybe we want just the discharge that was estimated (code is "E")
estimated_q <- intro_df$Flow_Inst[intro_df$Flow_Inst_cd == "E"]
head(estimated_q)
```

    ## [1] 13.0  3.1  9.8 12.0 15.0 11.0

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
    ## 1 02337170 2011-05-19 01:00:00    10.0
    ## 2 02336120 2011-05-19 02:30:00     8.6
    ## 3 02336300 2011-05-12 22:00:00     8.5
    ## 4 02336526 2011-05-24 13:15:00     6.8
    ## 5 02336313 2011-05-08 14:30:00     8.9
    ## 6 02336360 2011-05-22 10:15:00     7.0

``` r
#Now select some observations, like before
dplyr_high_temp <- filter(intro_df, Wtemp_Inst > 15)
head(dplyr_high_temp)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-19 02:30:00      13.0            E       16.9    <NA>
    ## 2 02336300 2011-05-12 22:00:00      27.0            X       26.4     7.5
    ## 3 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 4 02336313 2011-05-08 14:30:00       1.1            A       17.7     7.2
    ## 5 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ## 6 02337170 2011-05-26 08:00:00    1760.0            A       20.0       7
    ##   DO_Inst
    ## 1     8.6
    ## 2     8.5
    ## 3     6.8
    ## 4     8.9
    ## 5     7.0
    ## 6     8.5

``` r
#Find just observations with estimated flows (as above)
dplyr_estimated_q <- filter(intro_df, Flow_Inst_cd == "E")
head(dplyr_estimated_q)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02336120 2011-05-19 02:30:00      13.0            E       16.9    <NA>
    ## 2 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 3 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ## 4 02336728 2011-05-16 16:15:00      12.0            E       17.1     7.2
    ## 5 02336410 2011-05-20 05:30:00      15.0            E       17.9     7.2
    ## 6 02336410 2011-05-26 01:00:00      11.0            E       24.5     7.3
    ##   DO_Inst
    ## 1     8.6
    ## 2     6.8
    ## 3     7.0
    ## 4     9.1
    ## 5     8.3
    ## 6     7.2

Now we have seen how to filter observations and select columns within a data frame. Now I want to add a new column. In dplyr, `mutate()` allows us to add new columns. These can be vectors you are adding or based on expressions applied to existing columns. For instance, we have a column of dissolved oxygen in milligrams per liter (mg/L), but we would like to add a column with dissolved oxygen in milligrams per milliliter (mg/mL).

``` r
#Add a column with dissolved oxygen in mg/mL instead of mg/L
intro_df_newcolumn <- mutate(intro_df, DO_mgmL = DO_Inst/1000)
head(intro_df_newcolumn)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 02337170 2011-05-19 01:00:00    4270.0            A       13.4     6.9
    ## 2 02336120 2011-05-19 02:30:00      13.0            E       16.9    <NA>
    ## 3 02336300 2011-05-12 22:00:00      27.0            X       26.4     7.5
    ## 4 02336526 2011-05-24 13:15:00       3.1            E       21.3     7.5
    ## 5 02336313 2011-05-08 14:30:00       1.1            A       17.7     7.2
    ## 6 02336360 2011-05-22 10:15:00       9.8            E       20.5     7.1
    ##   DO_Inst DO_mgmL
    ## 1    10.0  0.0100
    ## 2     8.6  0.0086
    ## 3     8.5  0.0085
    ## 4     6.8  0.0068
    ## 5     8.9  0.0089
    ## 6     7.0  0.0070

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
    ## 1 02336300 2011-05-12 22:00:00        27            X
    ## 2 02336240 2011-05-14 00:15:00        11            X
    ## 3 02336313 2011-05-09 18:30:00         1            X
    ## 4 02203655 2011-05-07 07:30:00        12            X
    ## 5 02337170 2011-05-28 07:15:00      3220            X
    ## 6 02336360 2011-05-15 11:30:00        11            X

``` r
#Nested function
dplyr_error_nest <- filter(
  select(intro_df, site_no, dateTime, Flow_Inst, Flow_Inst_cd),
  Flow_Inst_cd == "X")
head(dplyr_error_nest)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336300 2011-05-12 22:00:00        27            X
    ## 2 02336240 2011-05-14 00:15:00        11            X
    ## 3 02336313 2011-05-09 18:30:00         1            X
    ## 4 02203655 2011-05-07 07:30:00        12            X
    ## 5 02337170 2011-05-28 07:15:00      3220            X
    ## 6 02336360 2011-05-15 11:30:00        11            X

``` r
#Pipes
dplyr_error_pipe <- intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X")
head(dplyr_error_pipe)
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336300 2011-05-12 22:00:00        27            X
    ## 2 02336240 2011-05-14 00:15:00        11            X
    ## 3 02336313 2011-05-09 18:30:00         1            X
    ## 4 02203655 2011-05-07 07:30:00        12            X
    ## 5 02337170 2011-05-28 07:15:00      3220            X
    ## 6 02336360 2011-05-15 11:30:00        11            X

``` r
# Every function, including head(), can be chained
intro_df %>% 
  select(site_no, dateTime, Flow_Inst, Flow_Inst_cd) %>%
  filter(Flow_Inst_cd == "X") %>% 
  head()
```

    ##    site_no            dateTime Flow_Inst Flow_Inst_cd
    ## 1 02336300 2011-05-12 22:00:00        27            X
    ## 2 02336240 2011-05-14 00:15:00        11            X
    ## 3 02336313 2011-05-09 18:30:00         1            X
    ## 4 02203655 2011-05-07 07:30:00        12            X
    ## 5 02337170 2011-05-28 07:15:00      3220            X
    ## 6 02336360 2011-05-15 11:30:00        11            X

Although we show you the nested and piping methods, we will only use the intermediate data frames method for the remainder of this material.

Cleaning up dataset
-------------------

Before moving on to merging, let's try cleaning up our `intro_df` data.frame. First, take a quick look at the structure: `summary(intro_df)`. Notice anything strange? Hint: why are the pH values character? That shouldn't be the case; there should be numeric values in that column. If there are any entries that are not numeric values or `NA`, R will treat the entire column as character. You can coerce them to numeric (so anything that is not NA or a number will be coerced into NA), but you should investigate what values are causing the issue first. To do this, we coerce to numeric and look at what values were considered NA in the numeric column, but not in the character column.

``` r
pH_df <- select(intro_df, pH_Inst)
pH_numeric_df <- mutate(pH_df, pH_Inst_numeric = as.numeric(pH_Inst))
# two filter conditions: coerced numeric column is NA, but original column is not
# this pinpoints what observations are causing the entire column to be character
filter(pH_numeric_df, is.na(pH_Inst_numeric), pH_Inst != "NA")
```

    ##    pH_Inst pH_Inst_numeric
    ## 1     <6.5              NA
    ## 2     <7.1              NA
    ## 3     <7.5              NA
    ## 4     <7.2              NA
    ## 5       <7              NA
    ## 6     <7.2              NA
    ## 7     <7.3              NA
    ## 8     <8.9              NA
    ## 9     <6.6              NA
    ## 10    <7.2              NA
    ## 11    <7.4              NA
    ## 12    <6.8              NA
    ## 13    <7.1              NA
    ## 14    <6.8              NA
    ## 15    <7.2              NA
    ## 16    <7.3              NA
    ## 17    <6.9              NA
    ## 18    <7.4              NA
    ## 19    <7.5              NA
    ## 20    <6.9              NA
    ## 21    <6.9              NA
    ## 22      <7              NA
    ## 23      <7              NA
    ## 24    <6.8              NA
    ## 25      <7              NA
    ## 26    <7.2              NA
    ## 27    <7.3              NA
    ## 28    <7.3              NA
    ## 29    <7.4              NA
    ## 30    <6.9              NA

Looks like the culprits are values that are lower than the detection limit, and have a `<` symbol. We want to keep this information, but we want to have a column of numeric pH values. So we can add a new column that is just whether the observation was below the detection limit or not. We can use the `grepl` function to make a new column of Ts and Fs for below detection limit or not. Then, use `gsub` to get rid of the '&lt;' symbol. And now you can have a column of all pH values, but retain the detection limit information.

``` r
# add column of logic for below detection limit or not
intro_df <- mutate(intro_df, pH_det_lim = grepl(pattern='<', x=pH_Inst))
summary(intro_df)
```

    ##    site_no            dateTime           Flow_Inst      
    ##  Length:3000        Length:3000        Min.   :   0.65  
    ##  Class :character   Class :character   1st Qu.:   5.70  
    ##  Mode  :character   Mode  :character   Median :  12.00  
    ##                                        Mean   : 302.00  
    ##                                        3rd Qu.:  22.00  
    ##                                        Max.   :7340.00  
    ##                                        NA's   :90       
    ##  Flow_Inst_cd         Wtemp_Inst      pH_Inst             DO_Inst      
    ##  Length:3000        Min.   :12.90   Length:3000        Min.   : 3.200  
    ##  Class :character   1st Qu.:17.80   Class :character   1st Qu.: 7.100  
    ##  Mode  :character   Median :20.70   Mode  :character   Median : 7.900  
    ##                     Mean   :20.29                      Mean   : 7.823  
    ##                     3rd Qu.:22.60                      3rd Qu.: 8.600  
    ##                     Max.   :27.70                      Max.   :12.700  
    ##                     NA's   :90                         NA's   :90      
    ##  pH_det_lim     
    ##  Mode :logical  
    ##  FALSE:2970     
    ##  TRUE :30       
    ##  NA's :0        
    ##                 
    ##                 
    ## 

``` r
# now, remove '<' symbols
intro_df <- mutate(intro_df, pH_Inst = gsub(pattern='<', replacement='', x=pH_Inst))
summary(intro_df)
```

    ##    site_no            dateTime           Flow_Inst      
    ##  Length:3000        Length:3000        Min.   :   0.65  
    ##  Class :character   Class :character   1st Qu.:   5.70  
    ##  Mode  :character   Mode  :character   Median :  12.00  
    ##                                        Mean   : 302.00  
    ##                                        3rd Qu.:  22.00  
    ##                                        Max.   :7340.00  
    ##                                        NA's   :90       
    ##  Flow_Inst_cd         Wtemp_Inst      pH_Inst             DO_Inst      
    ##  Length:3000        Min.   :12.90   Length:3000        Min.   : 3.200  
    ##  Class :character   1st Qu.:17.80   Class :character   1st Qu.: 7.100  
    ##  Mode  :character   Median :20.70   Mode  :character   Median : 7.900  
    ##                     Mean   :20.29                      Mean   : 7.823  
    ##                     3rd Qu.:22.60                      3rd Qu.: 8.600  
    ##                     Max.   :27.70                      Max.   :12.700  
    ##                     NA's   :90                         NA's   :90      
    ##  pH_det_lim     
    ##  Mode :logical  
    ##  FALSE:2970     
    ##  TRUE :30       
    ##  NA's :0        
    ##                 
    ##                 
    ## 

``` r
# now coerce the column into numeric values using as.numeric
intro_df <- mutate(intro_df, pH_Inst = as.numeric(pH_Inst))
summary(intro_df)
```

    ##    site_no            dateTime           Flow_Inst      
    ##  Length:3000        Length:3000        Min.   :   0.65  
    ##  Class :character   Class :character   1st Qu.:   5.70  
    ##  Mode  :character   Mode  :character   Median :  12.00  
    ##                                        Mean   : 302.00  
    ##                                        3rd Qu.:  22.00  
    ##                                        Max.   :7340.00  
    ##                                        NA's   :90       
    ##  Flow_Inst_cd         Wtemp_Inst       pH_Inst         DO_Inst      
    ##  Length:3000        Min.   :12.90   Min.   :6.200   Min.   : 3.200  
    ##  Class :character   1st Qu.:17.80   1st Qu.:7.000   1st Qu.: 7.100  
    ##  Mode  :character   Median :20.70   Median :7.100   Median : 7.900  
    ##                     Mean   :20.29   Mean   :7.136   Mean   : 7.823  
    ##                     3rd Qu.:22.60   3rd Qu.:7.300   3rd Qu.: 8.600  
    ##                     Max.   :27.70   Max.   :9.100   Max.   :12.700  
    ##                     NA's   :90      NA's   :90      NA's   :90      
    ##  pH_det_lim     
    ##  Mode :logical  
    ##  FALSE:2970     
    ##  TRUE :30       
    ##  NA's :0        
    ##                 
    ##                 
    ## 

As a final step before moving to the next section, let's rename some of the column names. We are going to have to reference columns a lot, and might not want to type `_Inst` for every single one, especially since they are all `_Inst`, so it's not giving us additional information. Let's rename all columns with `_Inst` using the `rename` function from `dplyr`.

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

    ##       site_no            dateTime   Flow Flow_cd Wtemp  pH  DO pH_det_lim
    ## 2998 02203700 2011-05-07 14:45:00    5.3       A  16.3 7.2 8.2      FALSE
    ## 2999 02337170 2011-05-13 15:15:00 2840.0     A e  16.5 6.9 9.3      FALSE
    ## 3000 02336410 2011-05-30 04:00:00   16.0     A e  24.3 7.0 6.3      FALSE
    ## 3001 00000001 2016-09-01 07:45:00     NA    <NA>  14.0 7.8  NA         NA
    ## 3002 00000001 2016-09-02 07:45:00     NA    <NA>  16.4 8.5  NA         NA
    ## 3003 00000001 2016-09-03 07:45:00     NA    <NA>  16.0 8.3  NA         NA

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

    ##       site_no            dateTime    Flow
    ## 1634 02336313 2011-05-30 09:00:00    0.73
    ## 1123 02336240 2011-05-29 06:30:00   15.00
    ## 2970 02203700 2011-05-04 00:45:00   47.00
    ## 1052 02336526 2011-05-13 04:30:00    3.60
    ## 2527 02336120 2011-05-13 02:30:00   14.00
    ## 1431 02337170 2011-05-08 12:30:00 1560.00

``` r
head(DO)
```

    ##       site_no            dateTime  DO
    ## 1634 02336313 2011-05-30 09:00:00 5.8
    ## 2527 02336120 2011-05-13 02:30:00 7.2
    ## 2437 02336120 2011-05-14 21:30:00 8.5
    ## 2718 02336526 2011-05-24 04:45:00 6.9
    ## 225  02203700 2011-05-08 23:00:00 5.6
    ## 1816 02336728 2011-05-20 16:30:00 9.3

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
    ## 1  02203655                30.547396                  20.26649
    ## 2  02203700                 6.748097                  20.15979
    ## 3  02336120                38.823548                  20.74419
    ## 4  02336240                42.409756                  19.85100
    ## 5  02336300                35.263374                  20.56311
    ## 6  02336313                 1.001215                  20.46490
    ## 7  02336360                17.874516                  20.77532
    ## 8  02336410                30.583333                  20.61348
    ## 9  02336526                20.005212                  20.67690
    ## 10 02336728                36.938095                  20.99104
    ## 11 02337170              2899.464286                  18.13154

There are many other functions in `dplyr` that are useful. Let's run through some examples with `arrange()` and `slice()`.

First `arrange()` will re-order a data frame based on the values in a specified column. It will take multiple columns and can be in descending or ascending order.

``` r
#ascending order is default
head(arrange(intro_df, DO))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO pH_det_lim
    ## 1 02203700 2011-05-11 08:00:00  4.6     A e  21.1 7.4 3.2      FALSE
    ## 2 02203700 2011-05-11 07:15:00  4.6     A e  21.4 7.4 3.2      FALSE
    ## 3 02203700 2011-05-11 09:15:00  4.6       E    NA 7.4 3.3      FALSE
    ## 4 02203700 2011-05-11 06:45:00  4.6       E  21.6 7.4 3.3      FALSE
    ## 5 02203700 2011-05-12 07:15:00  4.6       E  21.6 6.8 3.4      FALSE
    ## 6 02203700 2011-05-11 06:15:00  4.6       E  21.8 7.4 3.4      FALSE

``` r
#descending
head(arrange(intro_df, desc(DO)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH   DO pH_det_lim
    ## 1 02336526 2011-05-19 20:15:00  3.5       E  19.4 8.7 12.7      FALSE
    ## 2 02336526 2011-05-19 22:15:00  3.6       A  19.9 8.9 12.6      FALSE
    ## 3 02336526 2011-05-21 20:00:00  3.3       E  23.2 8.9 12.4      FALSE
    ## 4 02336526 2011-05-24 21:15:00  3.0       A  25.3 8.9 12.3      FALSE
    ## 5 02336526 2011-05-20 21:30:00  3.5       A  22.2 8.9 12.3      FALSE
    ## 6 02336526 2011-05-19 23:15:00  3.6       A  20.0 9.0 12.3      FALSE

``` r
#multiple columns: lowest flow with highest temperature at top
head(arrange(intro_df, Flow, desc(Wtemp)))
```

    ##    site_no            dateTime Flow Flow_cd Wtemp  pH  DO pH_det_lim
    ## 1 02336313 2011-05-31 21:15:00 0.65       A  26.8 7.2 6.3      FALSE
    ## 2 02336313 2011-06-01 01:15:00 0.65       A  26.1 7.3 5.1      FALSE
    ## 3 02336313 2011-05-31 02:00:00 0.69       A  25.5 7.3 5.6      FALSE
    ## 4 02336313 2011-05-30 21:15:00 0.73       A  26.5 7.3 6.5      FALSE
    ## 5 02336313 2011-05-30 21:30:00 0.73     A e  26.4 7.3 6.3      FALSE
    ## 6 02336313 2011-05-30 20:15:00 0.73     A e  26.4 7.3 6.4      FALSE

Now `slice()`, which accomplishes what we did with the numeric indices before. Remembering back to that, we could grab rows of the data frame with something like `intro_df[3:10,]` or we can use `slice`:

``` r
#grab rows 3 through 10
slice(intro_df, 3:10)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH  DO pH_det_lim
    ## 1 02336300 2011-05-12 22:00:00   27.0       X  26.4 7.5 8.5      FALSE
    ## 2 02336526 2011-05-24 13:15:00    3.1       E  21.3 7.5 6.8      FALSE
    ## 3 02336313 2011-05-08 14:30:00    1.1       A  17.7 7.2 8.9      FALSE
    ## 4 02336360 2011-05-22 10:15:00    9.8       E  20.5 7.1 7.0      FALSE
    ## 5 02337170 2011-05-26 08:00:00 1760.0       A  20.0 7.0 8.5      FALSE
    ## 6 02336728 2011-05-16 16:15:00   12.0       E  17.1 7.2 9.1      FALSE
    ## 7 02336240 2011-05-14 00:15:00   11.0       X  23.0 7.2 7.4      FALSE
    ## 8 02336410 2011-05-26 15:45:00   11.0       A  22.9 7.3 7.8      FALSE

Lastly, one more function, `rowwise()`, allows us to run rowwise, operations. Let's say we had two dissolved oxygen columns, and we only wanted to keep the maximum value out of the two for each observation. This can easily be accomplished using`rowwise`. First, add a new dissolved oxygen column with random values (see `?runif`).

``` r
intro_df_2DO <- mutate(intro_df, DO_2 = runif(n=nrow(intro_df), min = 5.0, max = 18.0))
head(intro_df_2DO)
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH   DO pH_det_lim
    ## 1 02337170 2011-05-19 01:00:00 4270.0       A  13.4 6.9 10.0      FALSE
    ## 2 02336120 2011-05-19 02:30:00   13.0       E  16.9  NA  8.6      FALSE
    ## 3 02336300 2011-05-12 22:00:00   27.0       X  26.4 7.5  8.5      FALSE
    ## 4 02336526 2011-05-24 13:15:00    3.1       E  21.3 7.5  6.8      FALSE
    ## 5 02336313 2011-05-08 14:30:00    1.1       A  17.7 7.2  8.9      FALSE
    ## 6 02336360 2011-05-22 10:15:00    9.8       E  20.5 7.1  7.0      FALSE
    ##        DO_2
    ## 1  7.184540
    ## 2 15.497713
    ## 3 10.004251
    ## 4  9.260546
    ## 5 12.827309
    ## 6 12.857123

Now, let's use `rowwise` to find the maximum dissolved oxygen for each observation.

``` r
head(mutate(intro_df_2DO, max_DO = max(DO, DO_2)))
```

    ##    site_no            dateTime   Flow Flow_cd Wtemp  pH   DO pH_det_lim
    ## 1 02337170 2011-05-19 01:00:00 4270.0       A  13.4 6.9 10.0      FALSE
    ## 2 02336120 2011-05-19 02:30:00   13.0       E  16.9  NA  8.6      FALSE
    ## 3 02336300 2011-05-12 22:00:00   27.0       X  26.4 7.5  8.5      FALSE
    ## 4 02336526 2011-05-24 13:15:00    3.1       E  21.3 7.5  6.8      FALSE
    ## 5 02336313 2011-05-08 14:30:00    1.1       A  17.7 7.2  8.9      FALSE
    ## 6 02336360 2011-05-22 10:15:00    9.8       E  20.5 7.1  7.0      FALSE
    ##        DO_2 max_DO
    ## 1  7.184540     NA
    ## 2 15.497713     NA
    ## 3 10.004251     NA
    ## 4  9.260546     NA
    ## 5 12.827309     NA
    ## 6 12.857123     NA

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
#Add a column that totals landuse for each observation
intro_df_DO_max <- mutate(intro_df_2DO_byrow, max_DO = max(DO, DO_2))
head(intro_df_DO_max)
```

    ## # A tibble: 6 x 10
    ##    site_no            dateTime   Flow Flow_cd Wtemp    pH    DO pH_det_lim
    ##      <chr>               <chr>  <dbl>   <chr> <dbl> <dbl> <dbl>      <lgl>
    ## 1 02337170 2011-05-19 01:00:00 4270.0       A  13.4   6.9  10.0      FALSE
    ## 2 02336120 2011-05-19 02:30:00   13.0       E  16.9    NA   8.6      FALSE
    ## 3 02336300 2011-05-12 22:00:00   27.0       X  26.4   7.5   8.5      FALSE
    ## 4 02336526 2011-05-24 13:15:00    3.1       E  21.3   7.5   6.8      FALSE
    ## 5 02336313 2011-05-08 14:30:00    1.1       A  17.7   7.2   8.9      FALSE
    ## 6 02336360 2011-05-22 10:15:00    9.8       E  20.5   7.1   7.0      FALSE
    ## # ... with 2 more variables: DO_2 <dbl>, max_DO <dbl>

We now have quite a few tools that we can use to clean and manipulate data in R. We have barely touched what both base R and `dplyr` are capable of accomplishing, but hopefully you now have some basics to build on.

Let's practice some of these last functions.

Exercise 3
----------

Next, we're going to practice summarizing large datasets (using `intro_df`). If you complete a step and notice that your neighbor has not, see if you can answer any questions to help them get it done.

1.  Create a new data.frame that gives the maximum water temperature (`Wtemp`) for each site and name it `intro_df_max_site_temp`. Hint: don't forget about `group_by()`, and use `na.rm=TRUE` in statistics functions!

2.  Next, create a new data.frame that gives the average water temperature (`Wtemp`) for each pH value and name it `intro_df_mean_pH_temp`.

3.  Challenge: Find the minimum flow, water temperature, and dissolved oxygen for each site using `summarize_at`.
