---
author: Lindsay R. Carr
slug: Crib
draft: True
title: Crib Sheet
menu:
  weight=2
---

<table style="width:51%;">
<colgroup>
<col width="5%" />
<col width="15%" />
<col width="15%" />
<col width="15%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Function/operator</th>
<th align="left">Description</th>
<th align="left">Package (if not base R)</th>
<th align="left">Lesson Introduced</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code># my comment</code></td>
<td align="left">Comment</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>myfunction()</code></td>
<td align="left">Function call</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>mydata[1,4]</code></td>
<td align="left">Indexing [row, col]</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>{ my...code }</code></td>
<td align="left">Code block (function definitions, etc.)</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>options(repos=c(&quot;https://cran.rstudio.com/&quot;,&quot;http://owi.usgs.gov/R&quot;))</code></td>
<td align="left">Include GRAN as a source of packages</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>install.packages</code></td>
<td align="left">Install a package (like installing a software program)</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>library</code></td>
<td align="left">Load a package (like opening a program)</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>mylib::myfun()</code></td>
<td align="left">Call the version of the function myfun that's defined in the library mylib</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>help(&quot;print&quot;)</code></td>
<td align="left">Get the help page for a topic</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>?print</code></td>
<td align="left">Get the help page for a topic</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>apropos(&quot;print&quot;)</code></td>
<td align="left">Search help topics containing &quot;print&quot;</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>??&quot;print&quot;</code></td>
<td align="left">Search help topics containing &quot;print&quot;</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>ls(&quot;package:stats&quot;)</code></td>
<td align="left">List the functions defined in the stats package</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="even">
<td align="left"><code>pri - Tab</code></td>
<td align="left">When you press the Tab key, RStudio tries to complete your word</td>
<td align="left"></td>
<td align="left">A</td>
</tr>
<tr class="odd">
<td align="left"><code>1+1</code></td>
<td align="left">Add</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>10-4</code></td>
<td align="left">Subtract</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>3*2</code></td>
<td align="left">Multiply</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>3^3</code></td>
<td align="left">Exponents</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>100/10</code></td>
<td align="left">Divide</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>5%%2</code></td>
<td align="left">Modulus</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>5&gt;2</code></td>
<td align="left">Greater than</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>4&lt;5</code></td>
<td align="left">Less than</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>5&lt;=5</code></td>
<td align="left">Less than or equal</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>8&gt;=2</code></td>
<td align="left">Greater than or equal</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>2==2</code></td>
<td align="left">Equality</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>5!=7</code></td>
<td align="left">Not Equals</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>x &lt;- 8</code></td>
<td align="left">Assignment operator</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>z &lt;- 8 + x</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>a &lt;- &quot;R Class&quot;</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>print(x)</code></td>
<td align="left">Print objects or values in the console</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>x</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>ls()</code></td>
<td align="left">List objects in the current workspace</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>rm(x)</code></td>
<td align="left">Remove an object</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>getwd()</code></td>
<td align="left">See what file directory your workspace is currently set to</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>setwd()</code></td>
<td align="left">Change the working directory -- be careful with this!</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>list.files()</code></td>
<td align="left">See the names of files in your current directory</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>is.na()</code></td>
<td align="left">Says whether a value(s) is missing (NA) or not</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>na.omit()</code></td>
<td align="left">Removes an missing (NA) values</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>c()</code></td>
<td align="left">Combine arguments into a vector (or combine lists)</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>class()</code></td>
<td align="left">Tells you the R data type</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>str()</code></td>
<td align="left">Says the class and gives a small summary</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>length()</code></td>
<td align="left">Gives the number of elements</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>seq()</code></td>
<td align="left">Create a series of numbers (or dates)</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>1:10</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>rep()</code></td>
<td align="left">Repeat individual values, vectors, or lists</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>paste()</code></td>
<td align="left">Combine multiple character strings</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>factor()</code></td>
<td align="left">Create factors from character or numeric vectors</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>data.frame()</code></td>
<td align="left">Create a data frame, don't forget this is a default arg: <code>stringsAsFactors = TRUE</code></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>head()</code></td>
<td align="left">Look at the top 6 rows of a data frame (unless n is specified)</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>tail()</code></td>
<td align="left">Look at the bottom 6 rows of a data frame (unless n is specified)</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>names()</code></td>
<td align="left">Get the names of an R object</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>colnames()</code></td>
<td align="left">Get column names of data frame</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>rownames()</code></td>
<td align="left">Get row names of data frame</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>dim()</code></td>
<td align="left">Tells the number of rows and/or columns in a data frame</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>nrow()</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>ncol()</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>summary()</code></td>
<td align="left">Summarizes each column of a data frame, gives basic stats for numeric columns</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>list()</code></td>
<td align="left">Create lists</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>read.csv()</code></td>
<td align="left">Load data into R from a filepath or URL</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>read.table()</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>write.csv()</code></td>
<td align="left">Save R objects as files</td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>write.table()</code></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>readNWISdata()</code></td>
<td align="left">Read in data from NWIS</td>
<td align="left">dataRetrieval</td>
<td align="left">B</td>
</tr>
<tr class="even">
<td align="left"><code>readNWISqw()</code></td>
<td align="left">Read in water quality data from NWIS</td>
<td align="left">dataRetrieval</td>
<td align="left">B</td>
</tr>
<tr class="odd">
<td align="left"><code>x[7]</code></td>
<td align="left">Get the seventh element of a vector</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>x[8:10]</code></td>
<td align="left">Get a elements from index 8 though 10</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>x[c(2, 3, 5)]</code></td>
<td align="left">Get elements 2, 3, and 5</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>x[c(TRUE, FALSE)]</code></td>
<td align="left">Subset with logicals</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>x[x %% 2 == 0]</code></td>
<td align="left">Example of subsetting with a &quot;filter&quot;</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>select()</code></td>
<td align="left">Select columns out of a data frame</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>filter()</code></td>
<td align="left">Filter data based on some condition</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>rbind()</code></td>
<td align="left">Combine two R objects either row- or column-wise</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>merge()</code></td>
<td align="left">Merge two data frames on a column</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>all.equal()</code></td>
<td align="left">Test if two objects are equal</td>
<td align="left"></td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>inner_join()</code></td>
<td align="left">Inner join between two data frames</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>left_join()</code></td>
<td align="left">Left outer join between two data frames</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>right_join()</code></td>
<td align="left">Right outer join between two data frames</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>full_join()</code></td>
<td align="left">Full outer join between two data frames</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>anti_join()</code></td>
<td align="left">Drop all rows in the first data frame that has a match in the second</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>group()</code></td>
<td align="left">Group data by a specified column in a data frame</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>summarize()</code></td>
<td align="left">Summarize multiple values into a single value</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>arrange()</code></td>
<td align="left">Arrange rows by variables. Defaults to ascending order</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>slice()</code></td>
<td align="left">Slice an object</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>mutate()</code></td>
<td align="left">Create a new column based on some operation on an existing column</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="odd">
<td align="left"><code>rowwise()</code></td>
<td align="left">Apply some operation to each row</td>
<td align="left">dplyr</td>
<td align="left">C</td>
</tr>
<tr class="even">
<td align="left"><code>range()</code></td>
<td align="left">Find the range of a vector</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="odd">
<td align="left"><code>IQR()</code></td>
<td align="left">Get the interquartile range of a vector</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="even">
<td align="left"><code>quantile()</code></td>
<td align="left">Defaults to 0, 25, 50, 75, and 100% quantiles of a vector</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="odd">
<td align="left"><code>plot()</code></td>
<td align="left">Basic function for creating scatterplots, can also take data frames as inputs</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="even">
<td align="left"><code>abline()</code></td>
<td align="left">Add a line to a plot using slope + y-intercept,vertical or horizontal value, or a linear model</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="odd">
<td align="left"><code>lm()</code></td>
<td align="left">Find the regression line for a dataset</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="even">
<td align="left"><code>boxplot()</code></td>
<td align="left">Create boxplots</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="odd">
<td align="left"><code>hist()</code></td>
<td align="left">Create histograms</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="even">
<td align="left"><code>ecdf()</code></td>
<td align="left">Empirical cumulative distribution (can be used as an input to plot() )</td>
<td align="left"></td>
<td align="left">D</td>
</tr>
<tr class="odd">
<td align="left"><code>t.test()</code></td>
<td align="left">t-test</td>
<td align="left"></td>
<td align="left">E</td>
</tr>
<tr class="even">
<td align="left"><code>cor()</code></td>
<td align="left">Correlation (several methods available)</td>
<td align="left"></td>
<td align="left">E</td>
</tr>
<tr class="odd">
<td align="left"><code>cor.test()</code></td>
<td align="left">Correlation test</td>
<td align="left"></td>
<td align="left">E</td>
</tr>
<tr class="even">
<td align="left"><code>lm()</code></td>
<td align="left">Linear regression model</td>
<td align="left"></td>
<td align="left">E</td>
</tr>
<tr class="odd">
<td align="left"><code>summary(lm())</code></td>
<td align="left">Summarize a linear regression model</td>
<td align="left"></td>
<td align="left">E</td>
</tr>
<tr class="even">
<td align="left"><code>readNWISDaily()</code></td>
<td align="left">Get NWIS daily data</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>readNWISInfo()</code></td>
<td align="left">Get NWIS site information</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="even">
<td align="left"><code>as.egret()</code></td>
<td align="left">Create an EGRET data object</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>plotFlowSingle()</code></td>
<td align="left">Make a 1-panel plot of flow</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="even">
<td align="left"><code>setPA()</code></td>
<td align="left">Set the period of analysis for a WRTDS model</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>plotFourStats()</code></td>
<td align="left">Plot mean, max, median, and 7-day minimum stats for discharge</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="even">
<td align="left"><code>readNWISSample()</code></td>
<td align="left">Get NWIS sample data</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>mergeReport()</code></td>
<td align="left">Combine EGRET data objects</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="even">
<td align="left"><code>multiPlotDataOverview()</code></td>
<td align="left">Inspect solute data in 4 plots</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>modelEstimation()</code></td>
<td align="left">Fit a WRTDS model</td>
<td align="left">EGRET</td>
<td align="left">F</td>
</tr>
<tr class="even">
<td align="left"><code>vignette()</code></td>
<td align="left">Run a vignette or list the vignettes in a package</td>
<td align="left"></td>
<td align="left">F</td>
</tr>
<tr class="odd">
<td align="left"><code>plot()</code></td>
<td align="left">Make a basic plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>points()</code></td>
<td align="left">Add points to a plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>par()</code></td>
<td align="left">Set plotting parameters</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>par(las=)</code></td>
<td align="left">Set axis label orientation</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>par(tck=)</code></td>
<td align="left">Set tick length</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>par(bg=)</code></td>
<td align="left">Set background color</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>legend()</code></td>
<td align="left">Add a legend to a plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>curve()</code></td>
<td align="left">Plot an expression</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>rect()</code></td>
<td align="left">Add a rectangle to a plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>polygon()</code></td>
<td align="left">Add a polygon to a plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>symbols()</code></td>
<td align="left">Add symbols to a plot</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>axis()</code></td>
<td align="left">Add tick marks and labels to an axis</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>layout()</code></td>
<td align="left">Specify a layout for multiple plots on a figure</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>png()</code></td>
<td align="left">Open a .png plotting device</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>svg()</code></td>
<td align="left">Open an .svg plotting device</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>jpeg()</code></td>
<td align="left">Open a .jpeg plotting device</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>pdf()</code></td>
<td align="left">Open a .pdf plotting device</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="even">
<td align="left"><code>dev.off()</code></td>
<td align="left">Save and close one or more plotting devices</td>
<td align="left"></td>
<td align="left">G</td>
</tr>
<tr class="odd">
<td align="left"><code>ggplot()</code></td>
<td align="left">Start a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>ggplot(aes())</code></td>
<td align="left">Set the aesthetics (variables for x, y, groups, colors, etc.) for a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>g + geom_point()</code></td>
<td align="left">Add points to a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>labs()</code></td>
<td align="left">Set main and axis labels for a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>ggtitle()</code></td>
<td align="left">Set the main title of a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>xlab()</code></td>
<td align="left">Set the x axis label for a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>ylab()</code></td>
<td align="left">Set the y axis label for a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>geom_smooth()</code></td>
<td align="left">Add a smoother or regression line to a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>geom_boxplot()</code></td>
<td align="left">Add boxes to a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>geom_histogram()</code></td>
<td align="left">Add a histogram to a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>geom_bar()</code></td>
<td align="left">Add bars to a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>theme()</code></td>
<td align="left">Set thematic traits of a plot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>theme_bw()</code></td>
<td align="left">A simple black and white plot theme</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>theme_classic()</code></td>
<td align="left">A very simple black and white plot theme</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="odd">
<td align="left"><code>ggsave()</code></td>
<td align="left">Save a ggplot</td>
<td align="left">ggplot2</td>
<td align="left">H</td>
</tr>
<tr class="even">
<td align="left"><code>function()</code></td>
<td align="left">Define a function</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="odd">
<td align="left"><code>if</code></td>
<td align="left">Conditional control structure</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="even">
<td align="left"><code>ifelse</code></td>
<td align="left">Conditional control structure</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="odd">
<td align="left"><code>else</code></td>
<td align="left">Conditional control structure</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="even">
<td align="left"><code>for</code></td>
<td align="left">Control structure for a loop</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="odd">
<td align="left"><code>system.time()</code></td>
<td align="left">Return CPU time</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="even">
<td align="left"><code>return()</code></td>
<td align="left">Include in a function to reply with a specific value to the caller</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
<tr class="odd">
<td align="left"><code>jitter()</code></td>
<td align="left">Add some random noise to a numeric vector</td>
<td align="left"></td>
<td align="left">I</td>
</tr>
</tbody>
</table>
