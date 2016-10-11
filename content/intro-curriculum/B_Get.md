---
author: Jeffrey W. Hollister & Luke Winslow
date: 9999-01-09
slug: Get
title: B. Get
image: img/main/intro-icons-300px/get.png
menu: 
  main:
    parent: Introduction to R Course
    weight: 1
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

*Borrowed liberally from Jenny Bryan's [course materials on R](http://www.stat.ubc.ca/~jenny/STAT545A/quick-index.html) and Karthik Ram's [material from the Canberra Software Carpentry R Bootcamp](https://github.com/swcarpentry/2013-10-09-canberra). Anything good is because of Jenny and Karthik. Mistakes are all mine.*

Remember that everything in R is an object. With regards to data, those objects have some specific characteristics that help R (and us) know what kind of data we are dealing with and what kind of operations can be done on that data. This stuff may be a bit dry, but a basic understanding will help as so much of what we do with analysis has to do with the organization and type of data we have. First, lets discuss the atomic data types.

### Data Types

There are 6 basic atomic classes: character, numeric (real or decimal), integer, logical, complex, and raw.

| Example         | Type      |
|-----------------|-----------|
| "a", "swc"      | character |
| 2, 15.5         | numeric   |
| 2L              | integer   |
| `TRUE`, `FALSE` | logical   |
| 1+4i            | complex   |
| 62 6f 62        | raw       |

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

All of the examples so far have relied on entering data directly into the console or a script. That mode is certainly useful for demonstrating data structures, but would be a nightmare if you were dealing with a real dataset. What we generally want to do is read in data from a file or from a database that resides on your local machine or on the web. There are a gazillion ways that this can be accomplished, right now, we are going to work with one, `read.csv()`. It's worth mentioning that many people want to read data from Excel files. There are a variety of ways to pull data from Excel, but we recommend saving it as a csv and reading it in using `read.csv`.

`read.csv()` is a specialized version of `read.table()` that focuses on, big surprise here, `.csv` files. This command assumes a header row with column names and that the delimiter is a comma. The expected
no data value is `NA` and by default, strings are converted to factors (this can trip people up).

Source files for `read.csv()` can either be on a local hard drive or, and this is pretty cool, on the web. If you had a local file it would be accessed like `mydf <- read.csv("C:/path/to/local/file.csv")`. If you are grabbing data from a website, just put the URL in the function like `mydf <- read.csv("http://www.mywebsitewithadataset.com/thecsvfileIwant.csv")`. As an aside, paths and use of forward vs back slash is important. R is looking for forward slashes ("/"), or Unix-like paths. You can use these in place of the back slash and be fine. You can use a back slash but it needs to be a double back slash ("\\"). This is because the single backslash in an escape character that is used to indicate things like newlines or tabs. Doesn't really matter which one you use, I would just select one and be consistent.

We are going to use the same dataset for the rest of this course (exercises will use different datasets). This dataset is originally from NWIS and was altered using [this R code](https://github.com/USGS-R/gsIntroR/blob/master/R/create_df.R). Download the required csv from [here](/intro-curriculum/data). Put the file in your current working directory or include the entire filepath any palce we specify only the filename.

``` r
# Read in the data and take a look at it
intro_df <- read.csv("data/course_NWISdata.csv")
head(intro_df)
```

    ##   site_no            dateTime Flow_Inst Flow_Inst_cd Wtemp_Inst pH_Inst
    ## 1 2336360 2011-05-03 21:45:00      14.0            X       21.4     7.2
    ## 2 2336300 2011-05-01 08:00:00      32.0            X       19.1     7.2
    ## 3 2337170 2011-05-29 22:45:00    1470.0            A       24.0     6.9
    ## 4 2203655 2011-05-25 01:30:00       7.5          A e       23.1       7
    ## 5 2336120 2011-05-02 07:30:00      16.0            A       19.7     7.1
    ## 6 2336120 2011-05-12 16:15:00      14.0          A e       22.3     7.2
    ##   DO_Inst
    ## 1     8.1
    ## 2     7.1
    ## 3     7.6
    ## 4     6.2
    ## 5     7.6
    ## 6     8.1

``` r
str(intro_df)
```

    ## 'data.frame':    3000 obs. of  7 variables:
    ##  $ site_no     : int  2336360 2336300 2337170 2203655 2336120 2336120 2336120 2336300 2336360 2336120 ...
    ##  $ dateTime    : Factor w/ 1958 levels "2011-05-01 04:00:00",..: 184 13 1825 1525 80 721 726 126 1676 1703 ...
    ##  $ Flow_Inst   : num  14 32 1470 7.5 16 14 14 32 162 162 ...
    ##  $ Flow_Inst_cd: Factor w/ 4 levels "A","A e","E",..: 4 4 1 2 1 2 1 4 2 3 ...
    ##  $ Wtemp_Inst  : num  21.4 19.1 24 23.1 19.7 22.3 23.4 22.3 21 21.2 ...
    ##  $ pH_Inst     : Factor w/ 32 levels " ","6.2","6.3",..: 12 12 9 10 11 12 13 13 6 4 ...
    ##  $ DO_Inst     : num  8.1 7.1 7.6 6.2 7.6 8.1 8.5 7.5 7.6 7.2 ...

``` r
dim(intro_df)
```

    ## [1] 3000    7

``` r
summary(intro_df)
```

    ##     site_no                        dateTime      Flow_Inst       
    ##  Min.   : 2203655   2011-05-05 02:45:00:   5   Min.   :-90800.0  
    ##  1st Qu.: 2336240   2011-05-10 23:30:00:   5   1st Qu.:     5.1  
    ##  Median : 2336360   2011-05-14 09:00:00:   5   Median :    12.0  
    ##  Mean   : 4217421   2011-05-16 09:00:00:   5   Mean   :   488.2  
    ##  3rd Qu.: 2336728   2011-05-21 10:00:00:   5   3rd Qu.:    25.0  
    ##  Max.   :21989773   2011-05-24 14:45:00:   5   Max.   : 92100.0  
    ##                     (Other)            :2970   NA's   :90        
    ##  Flow_Inst_cd   Wtemp_Inst      pH_Inst       DO_Inst      
    ##  A  :1500     Min.   :11.9   7.2    :574   Min.   : 3.200  
    ##  A e: 500     1st Qu.:18.2   7.1    :435   1st Qu.: 6.800  
    ##  E  : 500     Median :21.2   7      :385   Median : 7.700  
    ##  X  : 500     Mean   :20.7   7.3    :376   Mean   : 7.692  
    ##               3rd Qu.:23.2   7.4    :274   3rd Qu.: 8.600  
    ##               Max.   :28.0   (Other):856   Max.   :12.600  
    ##               NA's   :90     NA's   :100   NA's   :90

A common issue in reading in data is getting the column formats right. For example, the `dateTime` and `Flow_Inst_cd` columns in `intro_df` are factors by default (can you confirm this?). If you want it to be a character column instead, you can prevent it ever becoming a factor with the `stringsAsFactors` argument to `read.csv`, `data.frame`, and other data.frame-making functions:

``` r
str(read.csv("data/course_NWISdata.csv"))
str(read.csv("data/course_NWISdata.csv", stringsAsFactors=FALSE))
```

Another issue with reading in USGS data is that site numbers often have a leading zero that is dropped if it defaults to an integer. To prevent this, you can specify the class for each column, using NA for ones that you would like R to choose. In our dataset, we know that site numbers (column one) should be treated as character. We aren't positive about the other six, so we say `NA` in the arguments for `colClasses` to indicate we want `read.table` to choose for us. See `?read.table` for more information about how that how that works.

``` r
intro_df <- read.csv("data/course_NWISdata.csv", stringsAsFactors = FALSE, colClasses = c("character", rep(NA, 6)))
str(intro_df)
```

    ## 'data.frame':    3000 obs. of  7 variables:
    ##  $ site_no     : chr  "02336360" "02336300" "02337170" "02203655" ...
    ##  $ dateTime    : chr  "2011-05-03 21:45:00" "2011-05-01 08:00:00" "2011-05-29 22:45:00" "2011-05-25 01:30:00" ...
    ##  $ Flow_Inst   : num  14 32 1470 7.5 16 14 14 32 162 162 ...
    ##  $ Flow_Inst_cd: chr  "X" "X" "A" "A e" ...
    ##  $ Wtemp_Inst  : num  21.4 19.1 24 23.1 19.7 22.3 23.4 22.3 21 21.2 ...
    ##  $ pH_Inst     : chr  "7.2" "7.2" "6.9" "7" ...
    ##  $ DO_Inst     : num  8.1 7.1 7.6 6.2 7.6 8.1 8.5 7.5 7.6 7.2 ...

Now our data frame is read in with columns as numeric, integer, or character, and the site numbers still have their leading zeros.

You can also save objects in your R workspace as csv files.

``` r
write.table(intro_df, file = "example_data_frame.csv", sep=",")
# or
write.csv(intro_df, file="example_data_frame.csv")
```

Optional: Reading NWIS data into R
----------------------------------

The USGS has created an R package to directly link NWIS with R. It is called `dataRetrieval`. With it, you can quickly and easily get NWIS data into R. The package functions are designed to handle the data types when pulling the data, so you don't need to worry about it. Go ahead and experiment with it.

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
3.  Add commands to create a new data frame named `ion_balance` that contains all the data in the IonBalance.csv file. Download this file from the [data section](/intro-curriculum/data). Be sure you put the file in your current working directory or include the entire filepath.
4.  Add commands to your script that will provides details on the structure (hint: str) of this newly created data frame.
5.  Run the script and make sure it doesn’t throw any errors and you do in fact get the data frame.
6.  If you still have some time, explore the data frame using some of the commands we covered.
