---
date: 2016-09-13
slug: introR-SWFWMD-Sep16
title: SWFWMD
menu: 
  main:
    parent: Course Specific Material
    weight: 1
---
September 13th - 15th in Tampa, FL

### Installation

See [Before the Workshop](/intro-curriculum/Before) for information on what software should be installed prior to the course.

### Tentative schedule

**Day 1**

-   08:00 am - 09:00 am -- Instructors available for questions
-   09:00 am - 10:30 am -- [Introduction](/intro-curriculum/Introduction)
-   10:30 am - 10:45 am -- *Break*
-   10:45 am - 12:15 pm -- [Get](/intro-curriculum/Get)
-   12:15 pm - 01:15 pm -- *Lunch*
-   01:15 pm - 03:15 pm -- [Clean](/intro-curriculum/Clean)
-   03:15 pm - 03:30 pm -- *Break*
-   03:30 pm - 04:30 pm -- [Clean](/intro-curriculum/Clean) continued
-   04:30 pm - 05:00 pm -- End of day wrap-up

**Day 2**

-   08:00 am - 08:30 am -- Instructors available for questions
-   08:30 am - 09:30 am -- [Explore](/intro-curriculum/Explore)
-   09:30 am - 10:30 am -- [Analyze: Base](/intro-curriculum/Analyze)
-   10:30 am - 10:45 am -- *Break*
-   10:45 am - 12:00 pm -- Analyze: [dataRetrieval](https://owi.usgs.gov/R/dataRetrieval.html) and [RODBC](https://cran.r-project.org/web/packages/RODBC/RODBC.pdf)
-   12:00 pm - 01:00 pm -- *Lunch*
-   01:00 pm - 02:30 pm -- Visualize: [base](/intro-curriculum/Visualize/) or [ggplot2](/intro-curriculum/ggplot2/)
-   02:30 pm - 02:45 pm -- *Break*
-   02:45 pm - 04:00 pm -- Visualize: [base](/intro-curriculum/Visualize/) or [ggplot2](/intro-curriculum/ggplot2/) continued
-   04:00 pm - 04:30 pm -- End of day wrap-up

**Day 3**

-   08:00 am - 08:30 am -- Instructors available for questions
-   08:30 am - 09:30 am -- [Repeat](/intro-curriculum/Reproduce/)
-   09:30 am - 11:30 am -- Practice: [USGS R packages](/intro-curriculum/USGS/), projects (group/individual), or [additional topics](/intro-curriculum/Additional/)

### Data files

Download data from the [Data page](/intro-curriculum/data/).

### Additional resources

-   [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/) (data wrangling, visualization, shiny, markdown, RStudio, etc)
-   [USGS-R GitHub](https://github.com/USGS-R) (package source code + bug/feature reporting)
-   [USGS-R blog](https://owi.usgs.gov/blog/tags/r)

### Instructors

Lindsay Carr (<lcarr@usgs.gov>) -- *primary contact*

Joe Mills (<tmills@usgs.gov>)

John Stamm (<jstamm@usgs.gov>)

### Lesson scripts

#### Introduction to R

``` r
1 + 1
1 - 2
1 * 3
1/2
2^3
2%%2 # modulus
1:10 # sequence 

# Using functions:
mean(1:10)
mean(x=1:10)
seq(from=2, to=10) # generating a sequence
seq(2,10)

# install packages

install.packages("RODBC") # should only run once
# update packages regularly (can run the line above)
library("RODBC")
require("RODBC") # don't use this -- fails silently if package isn't installed
# if you can't write to the default library, 
# you need to specific lib in install.packages and
# the location of the library for library()
# See https://owi.usgs.gov/R/training-curriculum/intro-curriculum/Before/
# to edit .Rprofile and change the default library location

# Getting help
?seq # I know the name of the function
??sequence # fuzzy match
```

#### Get

``` r
# Lesson B: Get

# assignment operators + objects
x <- 2
x = 2 # possible, but try to use this for function args

# any of these work - but be consistent
myvalue <- 2
myValue <- 3 # different than object above - case sensitive
my_value <- 4
my.value <- 5

# overwrite objects
x <- 7

# helpful functions for environment
rm(x) # don't put in scripts - just use when debugging
ls()

####***####  data structures

# data classes
x <- 5 # numeric + integer
x <- 5.6 # numeric
myname <- "Lindsay" # character
myname + 1 # doesn't work
3 > 2
isLarger <- 5 > 7 # logical
# station numbers often have leading zeros - if numeric,
# the leading zeros can get dropped

# vectors
firstVector <- c(5, 10, 11, 15)
class(firstVector)
length(firstVector)

charVector <- c("gw", "wq", "q")
class(charVector)

# ==
class(firstVector) == "numeric"
class(firstVector) != "numeric"

# data.frames
# built in R datasets, see data()
data(iris)
iris # shows up in environment under "Data"

### reading in data
# readxl package for reading in excel

# preferred method is to save excel as csv 
getwd() # absolute path of current directory
read.csv('data/course_NWISdata.csv') 
list.files('data') # give names of files in the folder "data"

intro_df <- read.csv('data/course_NWISdata.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))
class(intro_df)
names(intro_df)
colnames(intro_df) # same as names for dataframes
ncol(intro_df)
nrow(intro_df)
str(intro_df)

head(intro_df)
tail(intro_df)
tail(intro_df, n = 1)

summary(intro_df)
```

#### Clean - base R

``` r
###This script is cleaning our dataframe up for analysis
#Read in the data
intro_df <- read.csv('data/course_NWISdata.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))

myFullVector <- c(1:20)
length(myFullVector) #See how long hte vector is

myFullVector[1:5] #Positions 1 through 5
myFullVector[-1]

mySubVector <- myFullVector[c(1,5,9)] #Subset off specific positions

myFullVector[myFullVector > 10] #Subset off a condition

myFullVector == max(myFullVector)

myFullVector[myFullVector == max(myFullVector)] #Subset off a condition

####This section will subset the dataframe using base R functions
intro_df[1,1] #Pull out 1st row 1st column, notation is [row,column]

testSubsetRow <- intro_df[1,] #Pull out 1st row all columns, notation is [row,column]
testSubsetColumn <- intro_df[,1] #Pull out 1st row all columns, notation is [row,column]


names(intro_df) #Get names of variables in dataframe

myFlowValue <- intro_df$Flow_Inst ###Single column by name

myFlowValue <- intro_df[c("dateTime","Flow_Inst")]

myPeakValues <- intro_df[intro_df$Flow_Inst == max(intro_df$Flow_Inst,na.rm=TRUE),] ###This doesn't work I dont know why

unique(intro_df$Flow_Inst_cd) ###
myRejectedValue <- intro_df[intro_df$Flow_Inst_cd == "X",] ###This pulls out rejected values

###Replace some missing values
is.na(intro_df$Flow_Inst) #Test each entry in column if its NA

missingFlowValues <- intro_df[is.na(intro_df$Flow_Inst),] #Give rows where there are missing values in flow
#THIS DOES NOT WORK BECAUSE OF BAD [row,column] notation. missingFlowValues <- intro_df[is.na(intro_df$Flow_Inst)] #Give rows where there are missing values in flow

missingFlowValues <- intro_df[!is.na(intro_df$Flow_Inst)] #Give rows where there are NO missing values in flow

##One more demo using a smaller dataset


subIntroDf <- intro_df[1:10,]

subIntroDf$Flow_Inst_cd == "X"
subIntroDf$Flow_Inst_cd != "X"

subIntroDf[c(TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE),] #[rows,columns]

subIntroDf[subIntroDf$Flow_Inst_cd == "X",]

####Fill missing flow values
filledFlowValues <- intro_df
filledFlowValues$Flow_Inst[is.na(filledFlowValues$Flow_Inst)] <- 0.01

filledFlowValues$Flow_Inst[is.na(filledFlowValues$Flow_Inst)]
```

#### Clean - dplyr

``` r
###This script is cleaning data using the dplyr package
install.packages("dplyr") #install the dplyr package
library("dplyr") #Load the dplyr package

intro_df <- read.csv('data/course_NWISdata.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))

#stats::filter #example of calling a function from a specific package

#select some columns
dplyr_sel <- select(intro_df,site_no,dateTime,DO_Inst)
head(dplyr_sel)

#filter on a column
dplyr_high_temp <- filter(intro_df, Wtemp_Inst > 15)

dplyr_estimated_q <- filter(intro_df,Flow_Inst_cd == "E")

dplyr_highT_estQ <- filter(intro_df, Flow_Inst_cd == "E" & 
                             Wtemp_Inst > 15) ###Chain together conditions using &

dplyr_highT_estQ <- filter(intro_df, Flow_Inst_cd == "E" | 
                             Wtemp_Inst > 15) ###This does OR

###This is an example of date as character
x <- "2013-01-01"
class(x)

###Now convert it to a date class
x <- as.Date("2013-01-01") 
class(x)

###Date time class
minDate <- as.POSIXct("2011-05-20")
maxDate <- as.POSIXct("2011-05-25")

###get date range
min(intro_df$dateTime)
max(intro_df$dateTime)

#Now lets filter on date range
dplyr_newData <- filter(intro_df,dateTime >= minDate &
                          dateTime <= maxDate)

dplyr_newData <- filter(intro_df,dateTime >= as.POSIXct("2011-05-20") &
                          dateTime <= as.POSIXct("2011-05-25"))

###Now lets make a new variable
intro_df$site_no #Pull out a single column

###Using base R
intro_df_newVar <- intro_df #Make a copy of intro_df so we don't muck it up
intro_df_newVar$DO_Inst_ugL <- intro_df_newVar$DO_Inst * 1000 #new variable is DO in ug L-1
head(intro_df_newVar)

###Using dplyr
intro_df_newVar_dplyr <- mutate(intro_df, DO_Inst_ugL = DO_Inst * 1000,
                                DO_Inst_gL = DO_Inst / 1000
                                )


########Groupy by and summarize
intro_df_summary <- group_by(intro_df,site_no)
intro_df_summary <- summarize(intro_df_summary,mean(Flow_Inst,na.rm=TRUE),
                              mean(Wtemp_Inst,na.rm=TRUE))
```

#### Explore

``` r
# read in cleaned up data frame (dataframe from the end of the Clean section)
intro_df <- read.csv('data/course_NWISdata_cleaned.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))

#dateTime needs to be a date
intro_df$dateTime <- as.POSIXct(intro_df$dateTime,
                                format="%Y-%m-%d %H:%M:%S")
# if your dates were changed in excel, e.g. "11/05/2011 10:45"
intro_df$dateTime <- as.POSIXct(intro_df$dateTime,
                                format="%m/%d/%Y %H:%M")

# basic exploratory stats
summary(intro_df) # summary can have data frame as input

# these stat functions need single numeric vector as input
min(intro_df$pH_Inst, na.rm=TRUE)
max(intro_df$pH_Inst, na.rm=TRUE)
range(intro_df$pH_Inst, na.rm=TRUE)

quantile(intro_df$pH_Inst, na.rm=TRUE)
quantile(intro_df$pH_Inst, probs=0.9, na.rm=TRUE)
pH_probs <- quantile(intro_df$pH_Inst, probs=c(0.9,0.3), na.rm=TRUE)
pH_probs[2]
pH_probs['30%'] #use the name to subset for a named vector

IQR(intro_df$pH_Inst, na.rm = TRUE)

# suspect value (neg flow)
min_discharge <- min(intro_df$Flow_Inst, na.rm=TRUE)
# if you want to remove any negative flows
library(dplyr)
intro_df_posQ <- filter(intro_df, Flow_Inst >= 0)
min(intro_df_posQ$Flow_Inst, na.rm=TRUE)

## Plotting!!!

plot(1,2)
plot(x=1,y=2)

# plot a timeseries
plot(x=intro_df$dateTime, y=intro_df$Flow_Inst)
plot(x=intro_df_posQ$dateTime, y=intro_df_posQ$Flow_Inst)

# saving plots
png(filename="all_timeseries.png")
plot(x=intro_df$dateTime, y=intro_df$Flow_Inst)
dev.off()

#pairs plot
plot(intro_df) # gives weird results, then fails
# use select to keep only Flow, Wtemp, pH, DO
intro_df_meas <- select(intro_df, Flow_Inst, Wtemp_Inst, pH_Inst, DO_Inst)
intro_df_meas <- select(intro_df, -site_no, -dateTime, -Flow_Inst_cd)

plot(intro_df_meas)

# boxplots
boxplot(intro_df$Wtemp_Inst)
# boxplot(y ~ x) notation for grouping boxplots
boxplot(intro_df$Wtemp_Inst ~ intro_df$site_no)
```

#### Analyze: base

``` r
library(dplyr)

###This will deal with date formats on import (unless dates got reformatted in Excel, see below)
intro_df <- read.csv('data/course_NWISdata_cleaned.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character","POSIXct",rep(NA, 5)))
# if your dates were reformatted in excel, the conversion has to be done in 2 steps
intro_df <- read.csv('data/course_NWISdata_cleaned.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))
intro_df$dateTime <- as.POSIXct(intro_df$dateTime,
                                format="%m/%d/%Y %H:%M")

### stats tests
?t.test # get help for ttest

"X" %in% c("X","E")
"X" == c("X","E")

"X" =="X" | "X" == "E"
#1 question: Does X = X OR X = E?

"X" == c("X","E")
#2 questions: Does X equal X? Does X = E?

#row1FlowInst <- intro_df$Flow_Inst_cd[1] #This just pulls out the first entry of 
err_est_df <- filter(intro_df,Flow_Inst_cd %in% c("X","E"))

###Now we can do a t.test
t.test(err_est_df$Flow_Inst~err_est_df$Flow_Inst_cd)
ttestResult <- t.test(err_est_df$Flow_Inst~err_est_df$Flow_Inst_cd)

names(ttestResult) #Get names

ttestResult$p.value #Pull out p-value
ttestResult$conf.int #Pull out conf.int
attr(ttestResult$conf.int,"conf.level") #Get an attribute, which is meta data about the data vector

attributes(ttestResult$conf.int) #Get the attribute names
attributes(ttestResult$conf.int)$conf.int #Get the attribute value

###Linear model
?lm
lm(intro_df$DO_Inst~intro_df$Wtemp_Inst) #Simple console output of lm model
linMod <- lm(intro_df$DO_Inst~intro_df$Wtemp_Inst) #Dump output into an object
summary(linMod) #luse summary to get more comprehensive output
names(linMod) #get names of list

linMod$coefficients #Get my coefs
linMod$residuals #Get my residuals
plot(linMod$fitted.values,linMod$residuals) #Plot residuals vs fitted

plot(intro_df$DO_Inst,linMod$residuals) #Plot residuals vs measured, note the two different data sources before $
###THis is a problem lets look at the lengths
length(intro_df$DO_Inst)
length(linMod$residuals)
length(na.omit(intro_df$DO_Inst))
###Ok, problem is there are NAs in water temp AND DO that were dropped in the linear model
noNAData <- select(intro_df,DO_Inst,Wtemp_Inst)#Select the two columns used in model
noNAData <- na.omit(noNAData)#Remove all NAs
#OK, now we have the same length
plot(noNAData$DO_Inst,linMod$residuals)#Plot residuals vs measured
```

#### sink() example

``` r
# using sink to send output to a file instead of the console
# useful for saving statistical output
sink('output.txt') # turn sink ON and specify where to send output
print('this is my output')
sink() # this closes the file & returns print to console
print('this is my output again')
```

#### Analyze: dataRetrieval

``` r
library(dataRetrieval)

?readNWISdata
?whatNWISsites

fl_Q <- readNWISdata(stateCd = "FL", 
                     parameterCd = '00060',
                     startDate = "2015-01-01",
                     drainAreaMin = 100,
                     drainAreaMax = 350)

# whatNWISsites example not currently working for everyone (but does for some)-- investigating why
bBox_Tampa <- c(-82.491546, 27.825487, -81.872196, 28.370917)
site_nums_Tampa <- whatNWISsites(bBox=bBox_Tampa,
                                 parameterCd = '00400')

site_Chaz <- "02310674"
chaz_pcodes <- c('00060', '00010', '00065')
NWIS_data_chaz <- readNWISdata(site=site_Chaz, 
                               parameterCd=chaz_pcodes,
                               startDate="2016-01-01")
str(NWIS_data_chaz)

NWIS_data_chaz <- renameNWISColumns(NWIS_data_chaz)
attributes(NWIS_data_chaz)
chaz_info <- attr(NWIS_data_chaz, 'siteInfo')
chaz_info$station_nm
```

#### Visualize - ggplot2

``` r
#install.packages("ggplot2") #Run if you don't have it installed
library(ggplot2)
library(dplyr)

###This will deal with date formats on import (unless dates got reformatted in Excel, see below)
intro_df <- read.csv('data/course_NWISdata_cleaned.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character","POSIXct",rep(NA, 5)))
# if your dates were reformatted in excel, the conversion has to be done in 2 steps
intro_df <- read.csv('data/course_NWISdata_cleaned.csv', 
                     stringsAsFactors = FALSE,
                     colClasses = c("character", rep(NA, 6)))
intro_df$dateTime <- as.POSIXct(intro_df$dateTime,
                                format="%m/%d/%Y %H:%M")


intro_df_posQ <- filter(intro_df,Flow_Inst >= 0)

uniqueSites <- unique(intro_df_posQ$site_no)
uniqueSites[1:5]

posQ_fiveSites <- filter(intro_df_posQ,site_no %in% uniqueSites[1:5])


p1 <- ggplot(data=posQ_fiveSites,
             aes(x=dateTime,
                 y=Flow_Inst)) +
  geom_point()

p1

####Now add some color
posQ_fiveSites <- filter(intro_df_posQ,site_no %in% uniqueSites[6:10])
posQ_fiveSites <- filter(posQ_fiveSites, Flow_Inst < 100) #Get rid of highflow sites so we ca nsee it


p2 <- ggplot(data=posQ_fiveSites,
             aes(x=dateTime,
                 y=Flow_Inst,
                 color=site_no)) +
  geom_point() +
  geom_line() 
p2

###Now lets change shapes
p2 <- ggplot(data=posQ_fiveSites,
             aes(x=dateTime,
                 y=Flow_Inst,
                 color=site_no,
                 shape=site_no)) +
  geom_point() +
  geom_line() 
p2

###Now lets change shapes
p2 <- ggplot(data=posQ_fiveSites,
             aes(x=dateTime,
                 y=Flow_Inst,
                 color=site_no,
                 shape=site_no)) +
  geom_point() +
  geom_line() +
  ylab("Discharge, cfs") +
  xlab("Date") +
  ggtitle("Discharge at five sites in Georgia") +
  theme_bw()
p2

ggsave(filename="georgiaPlot.pdf",
       plot = p2,
       width = 8,
       height = 8,
       units="in")

#########Now lets plot two variable using facet
p3 <- ggplot(data=posQ_fiveSites,
             aes(x=dateTime,
                 y=Flow_Inst,
                 color=site_no,
                 shape=site_no)) +
  geom_point() +
  geom_line() +
  ylab("Discharge, cfs") +
  xlab("Date") +
  ggtitle("Discharge at five sites in Georgia") +
  theme_bw() +
  facet_grid(site_no~.) +
  geom_smooth(color="black")
p3
```
