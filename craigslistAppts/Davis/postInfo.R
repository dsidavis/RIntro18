getPostInfo =
function(doc)
{
  if(is.character(doc))
     doc = htmlParse(doc)

  if(length(xmlRoot(doc)) == 0)
      return(NULL)

  id = xpathSApply(doc, "//p[@class = 'postinginfo' and contains(., 'post id:')]", function(x) gsub("post id: ", "", xmlValue(x)))

  if(length(id) == 0)
      return(NULL)

  attrs0 = attrs = xpathSApply(doc, "//*[@class = 'attrgroup']/span", xmlValue)

  attrs = processAttrs(attrs)

  tmp = getNodeSet(doc, "//*[@class = 'postingtitletext']")
  title = if(length(tmp)) xmlValue(tmp[[1]]) else ""

  body = xpathSApply(doc, "//section[@id= 'postingbody']", xmlValue)
  if(length(body) == 0)
      body = ""

  map = getNodeSet(doc, "//div[@id = 'map']")
  if(length(map)) {
      map = map[[1]]
      lat = as.numeric(xmlGetAttr(map, "data-latitude"))
      long = as.numeric(xmlGetAttr(map, "data-longitude")      )
  } else
       lat = long = NA

  postDate = xpathSApply(doc, "//p[not(@id = 'display-date') and contains(@class, 'postinginfo')]/time",  function(x) structure(xmlGetAttr(x, "datetime"), names = gsub(": ", "", xmlValue(getSibling(x, FALSE)))))


  price = xpathSApply(doc, "//span[@class = 'price']", xmlValue)
  price = as.numeric(gsub("^\\$", "", price))
  if(length(price) == 0) price = NA
 
  ans = data.frame(id = id, price = price, title = title, body = body, lat = lat, long = long, stringsAsFactors = FALSE, posted = postDate["posted"], updated = postDate["updated"])

  ans[names(attrs)] =  attrs
  ans
}

processAttrs =
function(txt)
{
  i = grep("^[a-z]+:", txt)
  ans = structure(gsub("^[a-z]+:", "", txt[i]), names = gsub(":.*", "", txt[i]))
  if(!(1 %in% i))
      ans["header"] = txt[1]
  
  XML:::trim(ans)
}


Rbind =
function(rows)
{
  tt = table(unlist(lapply(rows, names)))
  i = tt < length(rows)
  if(any(i)) {
      ids = names(tt)[i]
      rows = lapply(rows, function(r) {
                      m = is.na(match(ids, names(r)))
                      if(any(m))
                          r[ ids[m] ] = NA
                      r
                   })
  }

  do.call(rbind, rows) # , stringsAsFactors = FALSE)
}
