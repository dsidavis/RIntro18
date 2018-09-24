mkDate =
function(x)
{
  as.Date(gsub("T.*", "", x), "%Y-%m-%d")
}


LaundryTypes = c("laundry in bldg", "w/d hookups", "w/d in unit", "laundry on site")
getLaundry =
function(ats)    
    getType(ats, LaundryTypes)

ParkingTypes = c("no parking", "off-street parking", "attached garage", "street parking", "carport")
getParking =
function(ats)
    getType(ats, ParkingTypes)

mkParking =
function(x)
{
    cp = grepl("carport", x, ignore.case = TRUE)
    grg = grepl("garage", x, ignore.case = TRUE)    
    os = grepl("off[ -]?street", x, ignore.case = TRUE)
    str = grepl("street", x, ignore.case = TRUE)
    ans = factor(rep(NA, length(x)), levels = c("carport", "garage","off-street", "street"))
    ans[cp] = "carport"
    ans[grg & !cp]= "garage"
    ans[os & !(grg | cp)]= "off-street"
    ans[strs & !(grg | cp | os)]= "off-street"        

browser()
}


HouseTypes = c("apartment", "duplex", "townhouse", "loft", "house", "condo")

getAptType =
function(ats)
        getType(ats, HouseTypes)

getType =
function(ats, Types)    
{
    i = match(ats, Types, 0)
    if(all(i == 0))
        NA
    else
        Types[i]
}
