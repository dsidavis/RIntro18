

Consider the data in flow.csv.
The file starts with 
```
!Program,FlocomPlus,3.0.10.1
!Download Start,2018/09/20 14:56:57
!Device,AgriFlo
!SerialNo,28741
!Ident,"?????"
!Version,3.10.5
!Device Time,2018/09/20 14:56:57
!Battery,"OK",13.91V
!
!Channels,7
!Names,"velocity","depth","indexing","flowrate","totalflow","battery","solar"
!Units,"ft/s","in","","gal/min","gal","V","V"
!Interval,30
2018/09/13 12:36:40,*Note,"Unit started"
2018/09/13 12:36:46,*Note,"Unit stopped"
2018/09/13 13:15:42,*Note,"Unit started"
2018/09/13 13:16:00,0.38,-0.058,2.28,0.0,0.0,13.75,14.77
2018/09/13 13:16:30,0.889,-0.044,2.3,0.0,0.0,13.95,19.58
2018/09/13 13:17:00,0.381,-0.073,1.54,0.0,0.0,13.95,19.5
2018/09/13 13:17:30,0.0,-0.073,1.85,0.0,0.0,13.9,19.17
2018/09/13 13:18:00,0.0,0.0,1.65,0.0,0.0,13.9,19.14
2018/09/13 13:18:30,3.251,3.399,88.79,394.443,197.221,13.9,19.11
2018/09/13 13:19:00,3.441,3.574,90.94,448.998,421.72,13.95,19.37
2018/09/13 13:19:30,3.766,3.851,101.85,547.467,695.454,13.95,19.36
```
and ends with
```
2018/09/20 14:54:00,4.249,4.435,121.27,757,1116434,13.95,19.61
2018/09/20 14:56:00,4.259,4.58,121.34,795,1118024,13.96,19.63
!
!Points,16062
!Download End,2018/09/20 14:58:27
```


+ The lines that start with ! are comments.
  So we want to ignore those.
+ The lines that contain the word Unit are Notes and we want to ignore those also.
+ The line that starts !Names provides the names of the variables. We want those.
+ The line that starts with !Units provides the units which we may want.


The function read.csv() can almost read this file.
We could skip the first 16 lines with 
```
tmp = read.csv("flow.csv", skip = 16, header = FALSE, stringsAsFactors = FALSE)
```
But the final lines starting with ! will cause some problems.


Let's compute the column/variable names from the file.
We could  just open the file and extract them manually.
But let's do it programmatically. Imagine that we have 
many of  these files and they contain slightly different variables.

```
lines = readLines("flow.csv")
i = grep("!Names", lines)
names = lines[i]
```

Next we split this line into pieces at the comma (,):
```
els = strsplit(names, ",")
```
strsplit() returns a list with one element for each element of the character
vector it was given, i.e. names. This is  because
we get a vector of elements for each string in names and each string
may produce/contain a different number of elements when split.

We only have one string/line here, so we can get the elements with
```
varNames = els[[1]]
```

We don't want the first element "!Names", so we exclude this
```
varNames = varNames[-1]
```

We don't want the quote character (") at the start and end.
So let's remove those with gsub
```
varNames = gsub('"', '', varNames)
```
When we print varNames, we see
```
[1] "velocity"  "depth"     "indexing"  "flowrate"  "totalflow"
[6] "battery"   "solar"    
```
The "s appear, but that is because R prints all strings with quotes
around them to show the start and end of each string.
But these are different from
```
[1] "\"velocity\""  "\"depth\""     "\"indexing\""  "\"flowrate\"" 
[5] "\"totalflow\"" "\"battery\""   "\"solar\""    
```
where we see the " within the strings.


There are `ncol(tmp)` columns which is 8 in this case.
However, we only have 7 elements in varNames.

Looking at the first few lines of the data frame we read using
read.csv()
```
head(tmp)
                   V1    V2     V3    V4      V5      V6    V7    V8
1 2018/09/13 13:16:00  0.38 -0.058  2.28   0.000   0.000 13.75 14.77
2 2018/09/13 13:16:30 0.889 -0.044   2.3   0.000   0.000 13.95 19.58
3 2018/09/13 13:17:00 0.381 -0.073  1.54   0.000   0.000 13.95 19.50
4 2018/09/13 13:17:30   0.0 -0.073  1.85   0.000   0.000 13.90 19.17
5 2018/09/13 13:18:00   0.0    0.0  1.65   0.000   0.000 13.90 19.14
6 2018/09/13 13:18:30 3.251  3.399 88.79 394.443 197.221 13.90 19.11
```
we see that the first column is a date and time.
There is no name in varNames for this colunn. So we can add it 
```
varNames = c("DateTime", varNames)
```

We can now add these as names
```
names(tmp) = varNames
```

##
What are the types of each column:
```
sapply(tmp, class)
   DateTime    velocity       depth    indexing    flowrate 
"character" "character" "character" "character"   "numeric" 
  totalflow     battery       solar 
  "numeric"   "numeric"   "numeric" 
```
The velocity, depth and indexing are characters.
We expected them to be numeric.
So let's find out why read.csv() didn't find numbers for these
in each row.

One way to do this is to convert velocity to numeric and see where we
don't get a number:
```
v = as.numeric(tmp$velocity)
```
We get a warning about
```
NAs introduced by coercion 
```
That's what we expected. 
Let's find out how many NAs we produced and where, i.e., what rows:
```
which(is.na(v))
 [1]   737  2077  3613  4964  6481  6482  6497  7846  9375 10731 12253
[12] 13615 14661 14663 14769 15110 15489 15834 16082 16084
```
Let's look at those rows:
```
tmp[is.na(v),]
                 DateTime            velocity                   depth indexing flowrate totalflow battery solar
737   2018/09/13 19:23:30               *Note       No external power                NA        NA      NA    NA
2077  2018/09/14 06:33:00               *Note External power restored                NA        NA      NA    NA
3613  2018/09/14 19:20:30               *Note       No external power                NA        NA      NA    NA
4964  2018/09/15 06:35:30               *Note External power restored                NA        NA      NA    NA
6481  2018/09/15 19:13:30               *Note     Sensor not detected  battery       NA        NA      NA    NA
6482  2018/09/15 19:13:30               *Note     Sensor not detected    solar       NA        NA      NA    NA
6497  2018/09/15 19:20:30               *Note       No external power                NA        NA      NA    NA
7846  2018/09/16 06:34:30               *Note External power restored                NA        NA      NA    NA
9375  2018/09/16 19:18:30               *Note       No external power                NA        NA      NA    NA
10731 2018/09/17 06:36:00               *Note External power restored                NA        NA      NA    NA
12253 2018/09/17 19:16:30               *Note       No external power                NA        NA      NA    NA
13615 2018/09/18 06:37:00               *Note External power restored                NA        NA      NA    NA
14661 2018/09/18 15:19:59               *Note            Unit stopped                NA        NA      NA    NA
14663 2018/09/18 15:47:53               *Note            Unit started                NA        NA      NA    NA
14769 2018/09/18 19:18:00               *Note       No external power                NA        NA      NA    NA
15110 2018/09/19 06:38:00               *Note External power restored                NA        NA      NA    NA
15489 2018/09/19 19:14:00               *Note       No external power                NA        NA      NA    NA
15834 2018/09/20 06:42:00               *Note External power restored                NA        NA      NA    NA
16082                   !                                                            NA        NA      NA    NA
16084       !Download End 2018/09/20 14:58:27                                        NA        NA      NA    NA
```
What do we notice?  
+ Almost all of the rows have a *Note in the velocity field.
These indicate status message lines.
+ The last two rows of this subset start with ! in the velocity field.
These are comments.

Let's drop these rows:
```
tmp = tmp[!is.na(v),]
```

Now let's convert the velocity in this subset to numbers
```
v = as.numeric(tmp$velocity)
```
We didn't get any warning message about producing NAs.
We can check if there are NAs with
```
table(is.na(v))
```
or
```
any(is.na(v))
```


Let's convert the depth and indexing columns also:
```
tmp$velocity = as.numeric(tmp$velocity)
tmp$depth = as.numeric(tmp$depth)
tmp$indexing = as.numeric(tmp$indexing)
```
(BTW, I'd probably do this with
```
v = c("velocity", "depth", "indexing")
tmp[v] = lapply(tmp[v], as.numeric)
```
if there were a lot of variables to convert.)


Again, we get no NA warning.
Let's check the classes of the columns again to confirm our expectations:
```
sapply(tmp, class)
   DateTime    velocity       depth    indexing    flowrate   totalflow     battery       solar 
"character"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric" 
```

But let's check how many NAs there are in each column of tmp:
```
sapply(tmp, function(x) sum(is.na(x)))
```
So there are some!

Why didn't we get a warning?


Let's find out which rows have any NA values
```
sapply(tmp, function(x) which(is.na(x)))
```
We can collapse this down and find the unique values:
```
i = unique(unlist(sapply(tmp, function(x) which(is.na(x)))))
```
Let's look at those rows

The first two of these (14662, and 16083) seem to have a DateTime starting with
!Interval and !Points respectively.
These correspond to line in the flow.csv file like
```
!Interval,120
```
So let's kill these off 
```
tmp = tmp[ - i[1:2], ]
```

What about the third row i[3]
```
                DateTime velocity depth indexing flowrate totalflow battery solar
6480 2018/09/15 19:13:30    4.415 4.595   124.07  827.713  661756.4      NA    NA
```
We can manually search the file flow.csv for the string '2018/09/15 19:13:30'.
We can also find it programmatically
```
ll = readLines("flow.csv")
j = grep("2018/09/15 19:13:30", ll)
```
We find three matching lines:
```
[1] "2018/09/15 19:13:30,4.415,4.595,124.07,827.713,661756.438,,"   
[2] "2018/09/15 19:13:30,*Note,\"Sensor not detected\",\"battery\"" 
[3] "2018/09/15 19:13:30,*Note,\"Sensor not detected\",\"solar\""  
```
We filtered out the last 2 earlier. But the first of these
ends with ,,
So there are genuinely no values for the last two variables in this line.
The NAs are legitimate and we want to keep this row.

## Converting the Date-Time

Now let's change DateTime to an object with class POSIXct.
strptime() does this.
```
dt = strptime(tmp$DateTime, "%Y/%m/%d %H:%M:%S")
```
We immediately check the first few values to see if they are correct/meaningful
```
head(dt)
[1] "2018-09-13 13:16:00 PDT" "2018-09-13 13:16:30 PDT"
[3] "2018-09-13 13:17:00 PDT" "2018-09-13 13:17:30 PDT"
[5] "2018-09-13 13:18:00 PDT" "2018-09-13 13:18:30 PDT"
```
These look okay.

To put these back into the data frame we convert them to POSIXct
which are numeric values representing seconds since Jan 1, 1970:
```
tmp$DateTime = as.POSIXct(dt)
```



# Manually Edited Flow File

We have read the data from the original flow.csv file
dealing with the lines that weren't in "standard" CSV format.
In fact, the researcher copied and edited that file to make it more "standard"
and readable via read.csv, adding and removing columns and specifying the variable/column names
at the top. This is in flow_edited.csv.
So let's read it:
```
d = read.csv("flow_edited.csv", stringsAsFactors = FALSE)
```
We check the class, dims, names:
```
class(d)
dim(d)
names(d)
```

For contextual reasons, we need to increase velocity by 7%
```
d$velocity * 1.07
```
We get an error
```
Error in d$velocity * 1.07 : non-numeric argument to binary operator
```
So velocity is not a numeric vector. Let's look at the types.
We should habitually check the types/class of each column immediately after we created the data.frame:
```
sapply(d, class)
  Date_time    velocity   velocity2       depth    indexing    flowrate   flowrate2   totalflow  totalflow2     battery       solar     Comment 
"character" "character" "character" "character" "character"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric"   "numeric" "character" 
```
velocity, velocity2, depth, indexing are all character.
So this manual editing didn't quite work.

Let's see where the non-numbers are:
```
v = as.numeric(d$velocity)
which(is.na(v))
```
Let's look at the original values of velocity which gave rise to NAs:
```
d$velocity[ is.na(v) ]
```
These are all *Note values again.
So we know which lines these correspond to so let's remove
them from the flow_edited.csv file.

Alternatively, we can 
+ read all the lines in the file, 
+ find the "bad" lines
+ discard the bad lines
+ use read.csv() to read from the content containing the remaining lines.

```
ll = readLines("flow_edited.csv")
bad = grepl("Note", ll)
ll = ll[ !bad ]
d = read.csv(textConnection(ll), stringsAsFactors = FALSE)
sapply(d, class)
```
This all seems good now.
Of course, we may want to just fix the flow_edited.csv file once and for all.
