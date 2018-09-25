findNearCheapest =
   # ourPos starting point. Center of our universe.    
function(data, proximity = 0.01, ourPos = c(long = -121.73113, lat = 38.5538))
{    
     # Computing the euclidean distance between our starting point and all
     # 175 rental units posted yesterday.
    dist = sqrt( (data$long - ourPos[1])^2 + (data$lat - ourPos[2])^2 )


# STEP 3
# Find the subset of observations in the davis variable
# which are within .01 units of our starting point.
# ????
    within2 = dist <= proximity

    idx = which(within2)
    candidates = data[idx, ]

    candidates[order(candidates$price),]
}
