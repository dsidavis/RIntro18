

# Introduction to R

This workshop aims to get you 
+ up and running with the R language, 
+ exploring and manipulating data,
+ using good practices for reproducible computations and analyses,
+ writing simple functions for reuse in other projects and automating repetitive computations
+ on the way to learn more about how to reason about R code.



## An R Session

The R language and the interface from which we use the language and give commands
are two separate entities and there are many different interfaces tat all connect
to the same R language.
These include
+ RGui
+ RStudio
+ Jupyter and R notebooks
+ Web services
+ powerful text editors, e.g., Emacs, vim, sublime
+ Rcmdr

And there are interfaces for specific tasks, e.g., that talk to R
+ Rcmdr
+ rattle
+ Shiny apps

Many people use RStudio.  There are many good reasons for chosing  each of these at different times
or as your primary interface. Your needs may change over time. 
We can discuss pros and cons of different interfaces.


## Starting R Studio


We'll organize the files  for this workshop in its own directory, say RIntro.
We'll put the data, R code, notes, etc. there.
You can create this directory using your operating system's (OS)  file explorer.
Alternatively, you can use the terminal. We'll do it in R as this is the same
across all OSes
```{r}
dir.create("~/RIntro")
```

Next, we are going to tell R to use this as the working directory.
```
setwd("~/RIntro")
```
This means R will use this directory when we refer to files without any path in their name.


Ideally we'd use version control (e.g. git) for the files in this RIntro directory.
We can talk about this if you're interested.



### Commands to Start every R session: ~/.Rprofile 

It can be useful to put R commands into a file named .Rprofile in your HOME directory  (often
referred to via ~).
Here you can load R packages, set options, source R files, load data, etc. that you use
in all of your sessions.



## A Tour of the RStudio GUI (Graphical User Interface)

There are 5 main areas in the RStudio interface:
+ Prompt/command panel (bottom left)
+ Script area (top left)
+ Workspace & History (top right)
+ Plots, Packages, Help, Files (bottom right)
+ Menus that bring up different dialogs.


We're going to use the script area to write our R commands into files
and then send the commands to the prompt/command panel to execute them.

By putting the commands into a file, we ensure that we have them after the R session
and we can reconstruct what we did.
We'll refine the text in the script/file so that it works.


In the Top-left corner, open a new script file by clicking on the left-most icon (a + with a page
under it) or via the menu File -> New File-> R Script.
Now, in the script file, enter the R command
```
10 /
```
This is an incomplete command to divide 10 by ...  That's okay for now as we want to illustrate  what R will do with it.
Click on the Run button in the toolbar at the top of the GUI.
R shows the 10 / at the prompt (the > in the Prompt/command panel in the lower left of the GUI)
and then on a new line displays a +.  This indicates that R thinks the command makes sense but is
incomplete so it is giving you an opportunity to complete it.
We can complete it in the prompt panel but then we wouldn't have the actual code in the script
file. So alternatively, we click on the Stop button in the prompt panel and go back to our script
file.
We complete the command to read
```
10 / 3
```
R displays the answer 10.333 as
```
[1] 10.3333
```
The [1] indicates that this is the first element of a vector. In this case there is only element.
But it is good to know that R thinks in terms of vectors - ordered collections of values - and not
single values. This is because that is what we have in data analysis.


We can write commands across multiple lines in our script and then send the entire collection of
lines
to the R prompt by selecting/highlighting the lines and clicking the Run button.


If all the code is in the script file, then 
+ you can rerun it later on
+ you know what you actually did, not what you remember
+ you didn't add extra commands that aren't recorded that change subsequent 
+ send it to somebody else to run and get the same results (answers or errors)
+ adapt the code to do new things reliably.

All of these are essential for reproducible, valid data analysis.

There are also various tools to create reproducible dynamic documents
that will actually help you get results (tables, plots, etc.) into documents
as you modify the code.  These remove the manual drudgery and error-prone nature
of cutting-and-pasting results reliably into Word, GoogleDocs, LaTeX, etc. documents.
knitr and markdown are two of the tools in R that are worth exploring.


# R Script

From here on, enter the commands into your R script.
Refine each command until it works.
Add comments to your R scripts that explain
+ what each command  is  attempting to do
+ what you learned that you should remember about R and the command so you can understand it later


# Readding Data

The first thing is to read our data into R.
We'll work with data about rental units in Davis from yesterday (Sun, Sep 23 2018).
We'll explore and describe the dataset soon.  But first, we'll read it with
```
davis = readRDS(url("http://dsi.ucdavis.edu/RIntro18/DavisRaw.rds"))
```
We are reading this directly from the Web server, i.e., a URL.
We could download it to our machine first, then put it in our RIntro directory
and then read it into R with
```
davis = readRDS("DavisRaw.rds")
```

An rds file (doesn't have to have this file extension) stores the contents of a single R object.
It can be a complicated object with many values, but it is a single object.
We'll talk about RDA files which can contain multiple objects and variables.

Some things to note about the command above.
+ We called the readRDS() and the url() functions.
+ Our input to the url() function was a literal character string
+ url("http://...") returned an R value/object and this was the input to readRDS()
+ readRDS() returns the R object that was stored in/serialized to  the file
+ `davis = value` assigns the value to a variable named `davis`.
+ We get to decide the name of the variable (`davis`) to which to assign/store the value.


So assignments to create or overwrite variables in R are of the form
```
variable = value
variable <- value
```
(For completeness, you may also see `->` being used, and also a call to the assign() function.)


You can create new variables yourself, e.g.,
```
x = 4
name = "Duncan"
gotIt = TRUE
```

Note that these variables appear in the top-left panel of the RStudio GUI.
We can also list the names of the variables we have created with the `ls()`
function
```
ls()
```

We can also remove variables when we no longer need their values using `rm()`,
e.g.,
```
rm(x, name)
```
Be careful not to remove a variable you do want. After a call to rm(), it is gone
unless you happened to save()/saveRDS() the variable earlier.



## Back to our Data

We assigned the value from readRDS() to a variable we called `davis`.
What is it? You can see some details about it in the "Environment" panel in the top-right panel of the RStudio
GUI. But that only shows you some information. We can query the object for much more information.
You should get into the habit of doing this for objects you create. 
The functions we use all the time for this include
+ class()
+ typeof()
+ length()
+ str()
+ names()
+ dim(), nrow(), ncol()


What does these functions do?
Look them up with the help command, e.g.,
```
help("class")
?names
```


So the calls
```
class(davis)
typeof(davis)
```
tell us that the value currently assigned to the variable name davis is 
a data.frame and a list respectively.
The class tells us the high-level way we should think about the object - a data.frame.
The typeof tells us the low-level construction of the object - a list.
We'll talk about these later.


For now, let's stipulate that a data.frame is a 2-dimensional table with 
columns corresponding to variables and rows corresponding to observations.
In the case of our Davis data, each observation is an ad/posting for a rental unit.
(Note we may have 2 postings for the same rental unit!)
The columns are attributes/measurements for the postings.
We have a value for each variable for each posting.
Some of these values may be missing (e.g. if we don't have the square footage for the rental unit.)

So there are the same number of observations for all of the variables in the data frame
and they are arranged in the same order to correspond to the postings for the rental units.
This is a data frame.

We care about the relationships between variables. But first, let's look at individual variables.
First, let's look at the names of the columns/variables in the data frame. We use names():
```{r}
names(davis)
```
We see there are 13 names, each corresponding to a variable.


How many rows/observations are there in `davis`?
```
nrow(davis)
```

We can get a description of the elements (columns/variables) of `davis` with
```
str(davis)
```
This gives us a summary of the structure  (hence str)
We can see the type of the different elements.
But we'll 

We can pull-out a variable/column using either, e.g.,
```
davis$price
davis[["price"]]
```
Both are useful, but the first is shorter and simpler.
These commands are saying "in the value corresponding to the variable `davis`, extract the element named price".


For simplicity, we'll assign this to the variable `p`:
```
p = davis$price
```
This makes a copy of the vector of price values. These two objects are now separate.
So if we changed p, `davis$price` would not change, and vice versa.

What is the class of the value assigned to `p`? Its type? Its length?



