ff = c("scrape.R", "postInfo.R", "fixInitialPosts.R", "df.R")
invisible(lapply(file.path("~/Data/CraigsList/R", ff), source, globalenv()))

u = "https://sacramento.craigslist.org/search/apa?search_distance=20&postal=95616&availabilityMode=0&housing_type=1&housing_type=2&housing_type=3&housing_type=4&housing_type=5&housing_type=6&housing_type=7&housing_type=8&housing_type=9&sale_date=all+dates"

sac = craigslist(u, getPostInfo = NULL, save = filenameGenerator("Cache"))
