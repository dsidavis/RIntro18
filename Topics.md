From start to writing simple functions and automating repetitive tasks.


+ Installing R and RStudio
+ Difference between R and RStudio.
+ Overview of RStudio GUI
   + Important elements
      + Prompt/command panel
      + Script area
	  + Workspace
	  + Plots
	  + Menus
	  
 Try to get used to doing things with R commands, rather than the menus and dialogs.
   + Reproducible.
   + Makes it easier to see what you've actually done and to get help from others.
   
 If you are going to be using R a lot and on different machines, you may want to explore other interfaces.

# Load Data
Load some data from a URL.
+ See what appears in the Workspace
+ readRDS(), load(), saveRDS()/save() 
   + multiple variables
+ Where did R put this?
   + getwd()
   + Can load from other directories with `load("~/MyDir/file.rda")`
      + ~ means your home directory.
+ saveRDS(), readRDS() - individual objects w/o names


# Querying the Objects

+ ls()
+ just refer to an object by its variable name
  + this seems easy, but is importantly evaluating the expression that is the name of the
    variable. R will do this consistently in other contexts.
+ evaluating the variable name causes R to print its contents.
+ Typically we want to query 
   + class()
   + length()
   + dim()
   + names()
   + typeof()
   + str() - see the structure of the object


   
# Doing Something with the Data

+ We have a data frame
  + rows and columns/variables.
+ Get individual variables with $
  `dav$price`
  `dav[["price"]]`

# Managing your workspace
+ ls()
+ rm()

## Everything is a function call

## Help
+ ?topic


# Data Analysis
+ Numeric summaries
+ Graphical summaries
  + Typically prefer graphical
  

## Data Types
+ logical
+ integer
+ numeric
+ character
+ factor
+ matrix
+ list
+ data.frame
  

+ Dates
+ Times (POSIXct, POSIXlt)


## Univariate
+ `mean(dav$price)`
+ `sd(dav$price)`
+ `summary(dav$price)`
+ `table(dav$br)`


+ `hist(dav$price)`
+ `plot(density(dav$price))`
+ `boxplot(dav$price)`

## Creating New Variables

+ mutate()


## NAs

## Subsetting
+ [ and subset/filter
+ Six ways to subset
    + index/position
	+ name
	+ logical vector
	+ nothing/empty specification (e.g. `x[]`)
	+ negative index to drop
	+ (by matrix!)
+ Works in each dimension
    + `df[1:3, c("price", "bedroom", "bath")]`
    + `df[d$price <= 1000, c("bedroom", "bath")]`

## Bivariate Analysis


## Loops: lapply, sapply

+ Writing functions

## Group By
+ split
+ tapply, by, aggregate



# Processing Text Data

+ substring()
+ stringr package
+ regular expressions 
  + Very powerful and arcane
  + functions in base & stringr packages
  + Real smarts is in the regular expression language.



# Formulae and Models
+ Linear models
+ lm(price ~ sqft + br, dav)`
+ lm(price ~ sqft + br, dav, subset = )`





# ggplot2 
Documentation https://ggplot2.tidyverse.org/reference/index.html
