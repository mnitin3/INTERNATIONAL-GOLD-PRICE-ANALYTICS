getNews <- function(symbol, number){
  
  # Warn about length
  if (number>300) {
    warning("May only get 300 stories from google")
  }
  
  # load libraries
  require(XML); require(plyr); require(stringr); require(lubridate);
  require(xts); require(RDSTK)
  
  # construct url to news feed rss and encode it correctly
  url.b1 = 'http://www.google.com/finance/company_news?q='
  url    = paste(url.b1, symbol, '&output=rss', "&start=", 1,
                 "&num=", number, sep = '')
  url    = URLencode(url)
  
  # parse xml tree, get item nodes, extract data and return data frame
  doc   = xmlTreeParse(url, useInternalNodes = TRUE)
  nodes = getNodeSet(doc, "//item")
  mydf  = ldply(nodes, as.data.frame(xmlToList))
  
  class(mydf)
  
  con <-
    dbConnect(
      MySQL(),
      user = 'root',
      password = 'admin',
      host = 'localhost',
      dbname = 'tweet_db'
    )
  
  dbWriteTable(
    conn = con,
    name = "newsd",
    value = mydf,
    append = TRUE,
    row.names = FALSE,
    overwrite  = FALSE
  )
return(summary(mydf))  
}
news <- getNews('Gold',300)
news
