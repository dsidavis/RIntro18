source("postInfo.R")
library(XML)

# Chose one of these.
ff = list.files("Cache", pattern = "^_apa_", full = TRUE)
# Just one day's posts.
ff = list.files("Cache2", full = TRUE)

vals = i = lapply(ff, getPostInfo)
w = sapply(i, is.null)
ff[w]
# All are deleted or flagged for removal.

# But not all regular posts have the same column names/attributes in the post

i = i[!w]

sort(table(unlist(lapply(i, names))))

# venue
# suspension, drive, cylinders, odometer, fuel, transmission, condition  seem to be auto-related.

z = sapply(i, function(x) "venue" %in% names(x))
out = c("suspension", "drive", "cylinders", "odometer", "fuel", "transmission", "condition", "venue")
z = !sapply(i, function(x) any(names(x) %in% out))

sort(table(unlist(lapply(i[z], names))))

i = i[z]

i = lapply(i, function(x) { if(!("header" %in% names(x))) x$header = NA ; x })

ii = do.call(rbind, i)
class(ii)
dim(ii)
rownames(ii) = ii$file = basename(ff[!w][z])



normalizeSpace = function(x) gsub("[[:space:]]+", " ", x)
trim = function(x) gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)

ii$title = gsub("[[:space:]]+(hide this posting|unhide)[[:space:]]+", "", ii$title)
ii$title = trim(normalizeSpace(ii$title))


ii$bedrooms = NA
ii$bath = NA

w = !is.na(ii$header) & grepl("BR", ii$header)
tmp = gsub("([0-9]+)BR.*", "\\1", ii$header[w])
ii$bedrooms[w]  = as.integer(tmp)
tmp = gsub(".*([0-9]+)Ba", "\\1", ii$header[w])
# check the ones that don't give a number.
# sharedBa and splitBa.
# Only 36 of these.
ii$header[w] [is.na(as.integer(tmp))]
ii$bath[w]  = as.integer(tmp)
#ii$bathType = 

# Something odd here.  7 bedrooms, no baths.
# 5 baths for 0, 1, 2,... bedrooms.
# Overplotting.
with(ii, plot(bedrooms, bath))
with(ii, table(bedrooms, bath))


ii$sqft = NA

w = is.na(ii$sqft)
w = w & grepl("[0-9,]+ft2", ii$title)
ii$sqft[w] = as.integer(gsub(".*[^0-9]([0-9,]+)ft2.*", "\\1", ii$title[w]))

w = is.na(ii$sqft)
w = w & grepl("[0-9,]+ ([Ss]q. [Ff]t.|ft2)", ii$body)
ii$sqft[w] = as.integer(gsub(".*[^0-9]([0-9,]+ )([Ss]q. ?[Ff]t.|ft2).*", "\\1", ii$body[w]))


w = is.na(ii$sqft)
w = w & grepl("[0-9,] ?sqft", ii$body)
ii$sqft[w] = as.integer(gsub(".*[^0-9]([0-9,]+) ?sqft.*", "\\1", ii$body[w]))

table(is.na(ii$sqft))

o = sample(which(is.na(ii$sqft)), 10)

head(ii[is.na(ii$sqft), ])


ii$title = gsub("unhide$", "", ii$title)


#saveRDS(ii, "SacApartments.rds")

# size (sqft)
# dryer washer
# parking

# zip


table(grepl("elk grove|winters|woodland|vacaville|dixon|sacramento|davis", ii$body, ignore.case = TRUE))


source("funs.R")
ii$datePosted = mkDate(ii$posted)
ii$dateUpdated = mkDate(ii$updated)

dir = "Cache"
ii$parking = factor(sapply(file.path(dir, ii$file), function(d) getParking(xpathSApply(htmlParse(d), "//p[@class = 'attrgroup']//span", xmlValue))))
ii$laundry = factor(sapply(file.path(dir, ii$file), function(d) getLaundry(xpathSApply(htmlParse(d), "//p[@class = 'attrgroup']//span", xmlValue))))
ii$type = factor(sapply(file.path(dir, ii$file), function(d) getAptType(xpathSApply(htmlParse(d), "//p[@class = 'attrgroup']//span", xmlValue))))

ii$furnished = sapply(file.path(dir, ii$file), function(d) "furnished" %in% xpathSApply(htmlParse(d), "//p[@class = 'attrgroup']//span", xmlValue))

#saveRDS(ii, "DavisRaw.rds")
saveRDS(ii, "SacDavisApartments.rds")


if(FALSE) {

DavisPOS = c(long = -121.44, lat = 38.33)
SacPOS = c(-121.28, 38.33)
D = sqrt(sum((SacPOS - DavisPOS)^2))/2
dist = sqrt( (ii$lat - DavisPOS["lat"])^2 + (ii$long - DavisPOS["long"])^2 )

inDavis = (dist <= D)
table(inDavis)

Davis = ii[inDavis,]





z = grep("davis", ii$body, ignore.case = TRUE)
r = gregexpr("davis", ii$body[z], ignore.case = TRUE)
mapply(function(x, m) substring(x, m - 15, m + 20), ii$body[z], r)

Davis2 = ii[z,]

smoothScatter(Davis2$long, Davis2$lat)
}
