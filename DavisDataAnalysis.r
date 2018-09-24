
# A note to myself

ourLat = median(davis$lat)  #  maybe mean()
ourLong = median(davis$long)

# Our starting point. Center of our universe.
ourPos = c(median(davis$long), median(davis$lat))

# Comouting the euclidean distance between our starting point and all
# 175 rental units posted yesterday.
dist = sqrt( (davis$long - ourPos[1])^2 + (davis$lat - ourPos[2])^2 )


# STEP 3
# Find the subset of observations in the davis variable
# which are within .01 units of our starting point.
# ????
within2 = dist  < 0.01


idx = which(within2)

candidates = davis[idx, ]
w = candidates$price == min(candidates$price)
which(w)
candidates[which(w), c("lat", "long")]
