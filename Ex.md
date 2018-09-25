
Using DavisRaw.rds,  explore the following:

+ What's the average rental price in Davis for this day's posts?

+ Find the observation with the lowest value for price. Is it a legitimate entry?
  If not, remove it from the data.frame
  
+ Add a new column to the data.frame that measures rent price per square foot. 

+ Which postings have more baths than bedrooms?
  + Which postings have 4 or more baths and a square footage that is either NA or below the median
  + Look at the values of the title variable for these and see if the number of
    bathrooms may be wrong.
	+ Correct the value for bath for the observations where we see, e.g., 2.5

+ How many postings have NA for the square footage?
  
+ Find the observations that are apartments and have exactly 1 bedroom and 1 bath.
  How many are there?

+ Find the observations that have NA for the value of type.
  Update the data.frame to change such values to "house".
    + Bonus: Change the entire `type` factor to include a new level "mobile home" and then 
	  set the observations with NA for type to "mobile home".
  
+ Find the median price for each combination of the numbers of bedrooms and baths?  
 

  
+ Plot the relationship between price and size of the rental unit (square feet)
