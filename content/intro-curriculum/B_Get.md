---
author: Jeffrey W. Hollister & Luke Winslow
date: 2016-07-09
slug: Get
draft: True
title: B. Get
menu: 
image: img/main/intro-icons-300px/get.png
---
The second lesson is going to start to lay the foundation for working with data in R. We will cover some of the very basics of R first, then move on to how you get data into R and how you work with some of the basic data structures. Lastly, we will cover some ways to find relevant data and pull it directly into R.

Quick Links to Exercises and R code
-----------------------------------

-   [Exercise 1](#exercise-1): Introduction to the console and basic functions
-   [Exercise 2](#exercise-2): Read in data

Lesson Goals
------------

-   Understand workflow basics
-   Learn R concepts such as assignment and operators
-   Learn some useful R functions
-   Understand the basic data structures and data types
-   Be able to read data into R from a variety of sources

More basics
-----------

Before we jump into details on data in R we need to introduce a few of the basics about working in the console, working via scripts, and workspaces/projects. We will also start working with some simple, yet important R functions.

### Workflow

Being thoughtful about workflow from the beginning of a project is something that gets overlooked a lot, but a little up-front effort can provide a big benefit. For our purposes we are going to make use of RStudio projects and will script *EVERYTHING*. The console has its utility and we will use it plenty, especially when we are first figuring out how to use commands. But beyond that, we will store all of our work in a script. The basic workflow I am going to advocate is:

1.  Use a single project for this workshop (we created that in Lesson 1: Exercise 1).
2.  Start everything in a script and use copy/paste, Ctrl+Enter / Cmd+Enter, or the RStudio tools to send to the console.
3.  Use a new script for each lesson.
4.  Comment ruthlessly.
5.  Don't save .RData files or workspace history. The script should recreate whatever you need.

This, of course, is not the only way you can structure a workflow, but I think it should be a good starting point for this workshop and one you can adapt to your own work afterwards. And to provide a little motivation, the more you utilize scripts, the more reproducible your work is, the more likely you will be able to recall what you did 3 months from now (your future self will thank you), and the easier it will be to transition your work from scripts to functions and, ultimately, to R packages.

### Working in the Console

As I mentioned above, the console and using R interactively is very powerful. We will do this quite a bit. Let's spend a little time playing around in the console and learn a few new functions.

R can be used as a calculator and a way to compare values. Some examples of the basic operators:

``` r
#A really powerful calculator!
1 + 1 #Add
10 - 4 #Subtract
3 * 2 #Multiply
3 ^ 3 #Exponents
100 / 10 #Divide
5 %% 2 #Modulus
5 > 2 #Greater than
4 < 5 #Less than
5 <= 5 #Less than or equal
8 >= 2 #Greater than or equal
2 == 2 #Equality: notice that it is TWO equal signs!
5 != 7 #Not Equals
```

That's neat, but so what...

Well, it could be interesting to do something with those values and save them for re-use. We can do that with objects (everything in R is an object) and use the assignment operator, `<-`. Know that object names cannot start with a number, contain spaces, or (most) special characters. Underscore and periods are allowed.

``` r
#Numeric assignment
x <- 5
x
```

    ## [1] 5

``` r
y <- x + 1
y
```

    ## [1] 6

``` r
z <- x + y
z
```

    ## [1] 11

``` r
#Character
a <- "Bob"
a
```

    ## [1] "Bob"

``` r
b <- "Sue"
b
```

    ## [1] "Sue"

``` r
a2 <- "Larry"
a2
```

    ## [1] "Larry"

Now that we have a little experience working in the console and creating objects with `<-`, we might want to be able to do some additional things to navigate around, look at these objects etc.

Some functions that you might find useful for working with your R workspace:

``` r
#List all objects in current workspace
ls() 
ls(pattern="a")

#Remove an object
rm(x)

#Save your workspace
#Saves the whole thing to a file called lessonB.RData
save.image("lessonB.RData") 
#Saves just the a and y objects to a file called lessonB_ay.RData
save(a, y, file="lessonB_ay.RData")
```

A note about saving your workspace: This should not be something you do regularly because your script should contain code that can easily recreate all of the objects in your workspace.

This is probably a good spot to bring up quotes vs no quotes around arguments in a function. This is a very common stumbling block. The general rule is that no quotes are used only when referring to an object that currently exists. Quotes are used in all other cases. For instance in `save(a, y, file="lessonB_ay.RData")` the objects `a` and `y` are not quoted because they are objects in the workspace. `file` is an argument of save and arguments are never quoted. We quote the name of the file "lessonB\_ay.RData" because it is not an R object but the name of a file to be created. You will likely still have some issues with this. My recommendation is to think about if it is an object in your R workspace or not. If so, no quotes! This isn't foolproof, but works well most of the time.

Next thing you might want to do is navigate around your files and directories.

``` r
#See the current directory
getwd()

#Change the directory
setwd("temp")

#List files and directories
list.files()
```

While you can do this directly from the console, it is going to be better practice to mostly use RStudio projects to manage your folders, working directory etc. You can also navigate using the Files, etc. pane.

Exercise 1
----------

For this first excercise I am actually going to ignore my workflow advice from above. We are still in explore mode and saving this as a script doesn't yet make a whole lot of sense. Remember to use the green stickies when you have completed, and red stickies if you are running into problems. So, for this exercise:

1.  Create two objects named `number1` and `number2` and give them the values of 25 and 4, respectively
2.  Create two more objects named `string1` and `string2`, give them any character string that you would like.
3.  Now using `number1`,`number2`, and the power of math create an object called `number3` that equals 100.
4.  Create two more objects whose value is of your choosing
5.  List the objects in your workspace
6.  Remove `string2`
7.  Try to add `string1` and `number1`. What happens?

So the last question in exercise 1 was a bit of a contrived way to segue into data types and structures. So with that last bit, what did we ask R to do? Why did it respond the way it did?

In short it has a lot to do with data types. Let's learn some more.

Data types and data structures in R
-----------------------------------

*Borrowed liberally from Jenny Bryan's [course materials on r](http://www.stat.ubc.ca/~jenny/STAT545A/quick-index.html) and Karthik Ram's [material from the Canberra Software Carpentry R Bootcamp](https://github.com/swcarpentry/2013-10-09-canberra). Anything good is because of Jenny and Karthik. Mistakes are all mine.*

Remember that everything in R is an object. With regards to data, those objects have some specific characteristics that help R (and us) know what kind of data we are dealing with and what kind of operations can be done on that data. This stuff may be a bit dry, but a basic understanding will help as so much of what we do with analysis has to do with the organization and type of data we have. First, lets discuss the atomic data types.

### Data Types

There are 6 basic atomic classes: character, numeric (real or decimal), integer, logical, complex, and raw.

| Example         |       Type|
|:----------------|----------:|
| "a", "swc"      |  character|
| 2, 15.5         |    numeric|
| 2L              |    integer|
| `TRUE`, `FALSE` |    logical|
| 1+4i            |    complex|
| 62 6f 62        |        raw|

In this workshop we will deal almost exclusively with three (and these are, in my experience, by far the most common): character, numeric, and logical.

### NA, Inf, and NaN

There are values that you will run across on ocassion that aren't really data types but are important to know about.

`NA` is R's value for missing data. You will see this often and need to figure out how to deal with them in your analysis. A few built in functions are useful for dealing with `NA`. We will show their usage a bit later.

``` r
na.omit() #na.omit - removes them
na.exclude() #similar to omit, but has different behavior with some functions.
is.na() #Will tell you if a value is NA
```

`Inf` is infinity. You can have positive or negative infinity.

``` r
1 / 0
```

    ## [1] Inf

``` r
1 / Inf
```

    ## [1] 0

`NaN` means Not a number. it's an undefined value.

``` r
0 / 0
```

    ## [1] NaN

``` r
NaN
```

    ## [1] NaN

### Data Structures

The next set of information relates to the many data structures in R.

The data structures in base R include:

-   vector
-   list
-   matrix
-   data frame
-   factors
-   tables

Our efforts will focus on vectors and data frames. We will discuss just the basics of lists and factors. I will leave it to your curiousity to explore the matrix and table data structures.

### Vectors

A vector is the most common and basic data structure in `R` and is pretty much the workhorse of R.

A vector can be a vector of characters, logical, integers or numeric and all values in the vector must be of the same data type. Specifically, these are known as atomic vectors.

There are many ways to create vectors, but we will focus on one, `c()`, which is a very common way to create a vector from a set of values. `c()` combines a set of arguments into a single vector. For instance,

``` r
char_vector <- c("Joe", "Bob", "Sue")
num_vector <- c(1, 6, 99, -2)
logical_vector <- c(TRUE, FALSE, FALSE, TRUE, T, F)
```

Now that we have these we can use some functions to examine the vectors.

``` r
#Print the vector
print(char_vector)
```

    ## [1] "Joe" "Bob" "Sue"

``` r
char_vector
```

    ## [1] "Joe" "Bob" "Sue"

``` r
#Examine the vector
typeof(char_vector)
```

    ## [1] "character"

``` r
length(logical_vector)
```

    ## [1] 6

``` r
class(num_vector)
```

    ## [1] "numeric"

``` r
str(char_vector)
```

    ##  chr [1:3] "Joe" "Bob" "Sue"

We can also add to existing vectors using `c()`.

``` r
char_vector <- c(char_vector, "Jeff")
char_vector
```

    ## [1] "Joe"  "Bob"  "Sue"  "Jeff"

There are some ways to speed up entry of values.

``` r
#Create a series
series <- 1:10
seq(10)
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
seq(1, 10, by = 0.1)
```

    ##  [1]  1.0  1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9  2.0  2.1  2.2  2.3
    ## [15]  2.4  2.5  2.6  2.7  2.8  2.9  3.0  3.1  3.2  3.3  3.4  3.5  3.6  3.7
    ## [29]  3.8  3.9  4.0  4.1  4.2  4.3  4.4  4.5  4.6  4.7  4.8  4.9  5.0  5.1
    ## [43]  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9  6.0  6.1  6.2  6.3  6.4  6.5
    ## [57]  6.6  6.7  6.8  6.9  7.0  7.1  7.2  7.3  7.4  7.5  7.6  7.7  7.8  7.9
    ## [71]  8.0  8.1  8.2  8.3  8.4  8.5  8.6  8.7  8.8  8.9  9.0  9.1  9.2  9.3
    ## [85]  9.4  9.5  9.6  9.7  9.8  9.9 10.0

``` r
#Repeat values
fives <- rep(5, 10)
fives
```

    ##  [1] 5 5 5 5 5 5 5 5 5 5

``` r
laugh <- rep("Ha", 100)
laugh
```

    ##   [1] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [15] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [29] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [43] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [57] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [71] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [85] "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha" "Ha"
    ##  [99] "Ha" "Ha"

Lastly, R can operate directly on vectors. This means we can use use our arithmetic functions on vectors and also many functions can deal with vectors directly. The result of this is another vector, equal to the length of the longest one.

``` r
#A numeric example
x <- 1:10
y <- 10:1
z <- x + y
z
```

    ##  [1] 11 11 11 11 11 11 11 11 11 11

``` r
#another one, with different lengths
a <- 1
b <- 1:10
c <- a + b
c
```

    ##  [1]  2  3  4  5  6  7  8  9 10 11

``` r
#A character example with paste()
first <- c("Buggs", "Elmer", "Pepe", "Foghorn")
last <- c("Bunny", "Fudd", "Le Pew", "Leghorn")
first_last <- paste(first, last)
first_last
```

    ## [1] "Buggs Bunny"     "Elmer Fudd"      "Pepe Le Pew"     "Foghorn Leghorn"

### Factors

Factors are special vectors that represent categorical data. Factors can be ordered or unordered and are often important with modelling functions such as `lm()` and `glm()` (think dummy variables) and also in plot methods.

Factors are pretty much integers that have labels on them. While factors look (and often behave) like character vectors, they are actually integers under the hood, and you need to be careful when treating them like strings. Some string methods will coerce factors to strings, while others will throw an error.

Factors may be ordered (e.g., low, medium, high) or unordered (e.g. male, female).

Factors can be created with `factor()`. Input is a character vector.

``` r
#An unordered factor
yn <- factor(c("yes", "no", "no", "yes", "yes"))
yn
```

    ## [1] yes no  no  yes yes
    ## Levels: no yes

``` r
#An ordered factor
lmh <- factor(c("high","high","low","medium","low","medium","high"),
              levels=c("low","medium","high"), ordered=TRUE)
lmh
```

    ## [1] high   high   low    medium low    medium high  
    ## Levels: low < medium < high

### Data frames

Data frames are the data structure you will most often use when doing data analysis. They are the most spreadsheet like data structure in R, but unlike spreadsheets there are some rules that must be followed. This is a good thing!

Data frames are made up of rows and columns. Each column is a vector and those vectors must be of the same length. Essentially, anything that can be saved in a `.csv` file can be read in as a data frame. Data frames have several attributes. The ones you will interact with the most are column names, row names, dimension.

So one way to create a data frame is from some vectors and the `data.frame()` command:

``` r
numbers <- c(1:26, NA)
lettersNew <- c(NA, letters) #letters is a special object available from base R
logical <- c(rep(TRUE, 13), NA, rep(FALSE, 13))
examp_df <- data.frame(lettersNew, numbers, logical, stringsAsFactors = FALSE)
```

Now that we have this data frame we probably want to do something with it. We can examine it in many ways.

``` r
#See the first 6 rows
head(examp_df)
```

    ##   lettersNew numbers logical
    ## 1       <NA>       1    TRUE
    ## 2          a       2    TRUE
    ## 3          b       3    TRUE
    ## 4          c       4    TRUE
    ## 5          d       5    TRUE
    ## 6          e       6    TRUE

``` r
#See the last 6 rows
tail(examp_df)
```

    ##    lettersNew numbers logical
    ## 22          u      22   FALSE
    ## 23          v      23   FALSE
    ## 24          w      24   FALSE
    ## 25          x      25   FALSE
    ## 26          y      26   FALSE
    ## 27          z      NA   FALSE

``` r
#See column names
names(examp_df)
```

    ## [1] "lettersNew" "numbers"    "logical"

``` r
#see row names
rownames(examp_df)
```

    ##  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12" "13" "14"
    ## [15] "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27"

``` r
#Show structure of full data frame
str(examp_df)
```

    ## 'data.frame':    27 obs. of  3 variables:
    ##  $ lettersNew: chr  NA "a" "b" "c" ...
    ##  $ numbers   : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ logical   : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...

``` r
#Show number of rows and colums
dim(examp_df)
```

    ## [1] 27  3

``` r
nrow(examp_df)
```

    ## [1] 27

``` r
ncol(examp_df)
```

    ## [1] 3

``` r
#Get summary info
summary(examp_df)
```

    ##   lettersNew           numbers       logical       
    ##  Length:27          Min.   : 1.00   Mode :logical  
    ##  Class :character   1st Qu.: 7.25   FALSE:13       
    ##  Mode  :character   Median :13.50   TRUE :13       
    ##                     Mean   :13.50   NA's :1        
    ##                     3rd Qu.:19.75                  
    ##                     Max.   :26.00                  
    ##                     NA's   :1

``` r
#remove NA
na.omit(examp_df)
```

    ##    lettersNew numbers logical
    ## 2           a       2    TRUE
    ## 3           b       3    TRUE
    ## 4           c       4    TRUE
    ## 5           d       5    TRUE
    ## 6           e       6    TRUE
    ## 7           f       7    TRUE
    ## 8           g       8    TRUE
    ## 9           h       9    TRUE
    ## 10          i      10    TRUE
    ## 11          j      11    TRUE
    ## 12          k      12    TRUE
    ## 13          l      13    TRUE
    ## 15          n      15   FALSE
    ## 16          o      16   FALSE
    ## 17          p      17   FALSE
    ## 18          q      18   FALSE
    ## 19          r      19   FALSE
    ## 20          s      20   FALSE
    ## 21          t      21   FALSE
    ## 22          u      22   FALSE
    ## 23          v      23   FALSE
    ## 24          w      24   FALSE
    ## 25          x      25   FALSE
    ## 26          y      26   FALSE

### Lists

Lists are actually a special type of vector, but it is probably best to think of them as their own thing. Lists can contain multiple items, of multiple types, and of multiple structures. They are very versatile and often used inside functions or as an output of functions.

Also, lists don't print out like a vector. They print a new line for each element.

Lists are made simply with the `list()` function.

``` r
examp_list <- list(
  letters=c("x","y","z"),
  animals=c("cat","dog","bird","fish"),
  numbers=1:100,
  df=examp_df)
examp_list
```

    ## $letters
    ## [1] "x" "y" "z"
    ## 
    ## $animals
    ## [1] "cat"  "dog"  "bird" "fish"
    ## 
    ## $numbers
    ##   [1]   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
    ##  [18]  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34
    ##  [35]  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51
    ##  [52]  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68
    ##  [69]  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85
    ##  [86]  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100
    ## 
    ## $df
    ##    lettersNew numbers logical
    ## 1        <NA>       1    TRUE
    ## 2           a       2    TRUE
    ## 3           b       3    TRUE
    ## 4           c       4    TRUE
    ## 5           d       5    TRUE
    ## 6           e       6    TRUE
    ## 7           f       7    TRUE
    ## 8           g       8    TRUE
    ## 9           h       9    TRUE
    ## 10          i      10    TRUE
    ## 11          j      11    TRUE
    ## 12          k      12    TRUE
    ## 13          l      13    TRUE
    ## 14          m      14      NA
    ## 15          n      15   FALSE
    ## 16          o      16   FALSE
    ## 17          p      17   FALSE
    ## 18          q      18   FALSE
    ## 19          r      19   FALSE
    ## 20          s      20   FALSE
    ## 21          t      21   FALSE
    ## 22          u      22   FALSE
    ## 23          v      23   FALSE
    ## 24          w      24   FALSE
    ## 25          x      25   FALSE
    ## 26          y      26   FALSE
    ## 27          z      NA   FALSE

If you want to learn more about lists or any other data structure, [Hadley Wickham's Advanced R section on data structures](http://adv-r.had.co.nz/Data-structures.html) is good.

Reading data into R
-------------------

All of the examples so far have relied on entering data directly into the console or a script. That mode is certainly useful for demonstrating data structures, but would be a nightmare if you were dealing with a real dataset. What we generally want to do is read in data from a file or from a database that resides on your local machine or on the web. There are a gazillion ways that this can be accomplished, right now, we are going to work with one, `read.csv()`. If there is time later, we may talk about some others.

`read.csv()` is a specialized version of `read.table()` that focuses on, big surprise here, `.csv` files. This command assumes a header row with column names and that the delimiter is a comma. The expected
no data value is `NA` and by default, strings are converted to factors (this can trip people up).

Source files for `read.csv()` can either be on a local hard drive or, and this is pretty cool, on the web. We will be using the later for our examples and exercises. If you had a local file it would be accessed like `mydf <- read.csv("C:/path/to/local/file.csv")`. As an aside, paths and use of forward vs back slash is important. R is looking for forward slashes ("/"), or unix-like paths. You can use these in place of the back slash and be fine. You can use a back slash but it needs to be a double back slash ("\\"). This is because the single backslash in an escape character that is used to indicate things like newlines or tabs. Doesn't really matter which one you use, I would just select one and be consistent.

For now we are going to be focusing on grabbing data from a website, which just requires using an URL in the `read.csv()` function.

``` r
#Grab data from the web
web_df <- read.csv("http://usgs-r.github.io/introR/figure/example.csv")
head(web_df)
```

    ##   X id      data1    data2 groups
    ## 1 1  1  0.1739595 54.21928      1
    ## 2 2  2  0.4947904 69.92845      1
    ## 3 3  3  2.1739104 47.50045      1
    ## 4 4  4 -2.1275110 30.16031      1
    ## 5 5  5  0.5302878 84.45975      1
    ## 6 6  6  0.3000054 56.41225      1

``` r
str(web_df)
```

    ## 'data.frame':    100 obs. of  5 variables:
    ##  $ X     : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ id    : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ data1 : num  0.174 0.495 2.174 -2.128 0.53 ...
    ##  $ data2 : num  54.2 69.9 47.5 30.2 84.5 ...
    ##  $ groups: int  1 1 1 1 1 1 1 1 1 1 ...

``` r
dim(web_df)
```

    ## [1] 100   5

``` r
summary(web_df)
```

    ##        X                id             data1              data2      
    ##  Min.   :  1.00   Min.   :  1.00   Min.   :-2.12751   Min.   :11.13  
    ##  1st Qu.: 25.75   1st Qu.: 25.75   1st Qu.:-0.57451   1st Qu.:31.47  
    ##  Median : 50.50   Median : 50.50   Median :-0.02109   Median :52.09  
    ##  Mean   : 50.50   Mean   : 50.50   Mean   : 0.07867   Mean   :54.14  
    ##  3rd Qu.: 75.25   3rd Qu.: 75.25   3rd Qu.: 0.79215   3rd Qu.:78.42  
    ##  Max.   :100.00   Max.   :100.00   Max.   : 2.20980   Max.   :99.52  
    ##      groups    
    ##  Min.   :1.00  
    ##  1st Qu.:1.00  
    ##  Median :2.00  
    ##  Mean   :2.30  
    ##  3rd Qu.:3.25  
    ##  Max.   :4.00

There are a variety of ways to pull data from Excel. We are going to show you our recommended way, which involves saving the data to a CSV.

Let's give it a try. Download the example excel sheet [here](http://usgs-r.github.io/introR/figure/example.xlsx).

Now, open the example in Excel, make sure you're on the first worksheet, and go to File &gt; Save As. Select CSV in the drop-down menu and save the file as "example.csv" in your usgs\_r\_workshop directory.

![How to save csv](figure/excel_to_csv.png)

``` r
first_sheet <- read.csv("example.csv")
#Did it work?
first_sheet
```

A common issue in reading in data is getting the column formats right. For example, the `first_sheet$Names` column is a factor by default (can you confirm this?). If you want it to be a character column instead, you can prevent it ever becoming a factor with the `stringsAsFactors` argument to `read.csv`, `data.frame`, and other data.frame-making functions:

``` r
str(read.csv("example.csv"))
str(read.csv("example.csv", stringsAsFactors=FALSE))
```

You can also save objects in your R workspace as csv files.

``` r
write.table(web_df, file = "example_data_frame.csv", sep=",")
# or
write.csv(web_df, file="example_data_frame.csv")
```

Reading NWIS data into R
------------------------

The USGS has created an R package to directly link NWIS with R. It is called `dataRetrieval`. With it, you can quickly and easily get NWIS data into R. Go ahead and experiment with it.

``` r
library(dataRetrieval)
# Gather NWIS data:
siteListPhos <- readNWISdata(
  stateCd="FL", parameterCd="00665", drainAreaMin=400,
  siteType="ST", service="site") 
phosData <- readNWISqw(siteListPhos$site_no, parameterCd="00665")
head(phosData)
```

So now we have a basic feel on how to work in R, how data is dealt with, and how to pull data from a file into R. Next we are going to practice some of these skills.

Exercise 2
----------

For this exercise we are going to read in data from a csv file, look at that data, and be able to describe some basic information about that dataset. The data we will use originally comes from the `smwrData` datasets (and can be accessed using the `data()` function, but we are going to practice reading in csv files).

1.  Create a new script in RStudio. Name it “usgs\_analysis.R”
2.  As you write the script comment as you go.
3.  Add commands to create a new data frame named `ion_balance` that contains all the data in the IonBalance.csv file. The file is stored in the `gsIntroR` package. To get the filepath for this csv file use the following code:

``` r
filepath <- system.file("IonBalance.csv", package = "gsIntroR")
filepath_complete <- file.path(filepath, "IonBalance.csv")
```

1.  Add commands to your script that will provides details on the structure (hint: str) of this newly created data frame.
2.  Run the script and make sure it doesn’t throw any errors and you do in fact get the data frame.
3.  If you still have some time, explore the data frame using some of the commands we covered.
