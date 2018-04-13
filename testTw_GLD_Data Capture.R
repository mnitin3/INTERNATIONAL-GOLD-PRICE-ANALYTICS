setwd("C:/Users/mnitin3/Documents/R/Gold Prediction")
library(dplyr)
library(RMySQL)
library(sentiment)
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(ROAuth)
library(lubridate)
library(Quandl)

# Declare Twitter API Credentials
api_key <- "70BYtjDMZgNbCvPOGr6gFS5tV" # From dev.twitter.com
api_secret <-
  "68kRITbwEYyPc3b4cdjOHwvvGdHExm5uiPDK2OpJeHnjjPfKIf" # From dev.twitter.com
token <-
  "42370357-tZ8LJmWq4UQLjsisLEbPNOXqWHbfxuONwAKv6juQU" # From dev.twitter.com
token_secret <-
  "Wg6i3RaIHeNEF3TOHmrQZJ0Rpd5ex7GohYJmIl7OlrZgk" # From dev.twitter.com

###############
#Positive words
 posw <-
  scan(
    "positive-words.txt",
    what = "character",
    comment.char = ";"
  )
#posw[100]

negw <-
  scan(
    "negative-words.txt",
    what = "character",
    comment.char = ";"
  )
negw[100]
###############
#Create Required Tables : 
  dbSendQuery(
    con,
    "drop table record_senti2")

dbSendQuery(
  con,
  "CREATE TABLE `record_senti2` ( `Countoftweet` int,  `Positive` float,  `Negetive` float,  `Date` DATE, `Price` float)"
)




##########################
# Create Twitter Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)
1


tweets <-
  searchTwitter(
    "#BRIKK OR #GoldGenie OR #Miansai OR #GoldSouk OR #GoldPrice OR #24Karat OR #22Karat OR #18Karat OR #GoldJewellery OR #GoldBullion OR #GoldBar OR #YellowMetal OR #SpotGold OR #GoldFutures OR #GoldDemand",
    n =
      10000,
    lang = "en"
  )

# Transform tweets list into a data frame
tweets.df <- twListToDF(tweets)
tablename <-  tolower("Fulldataappend")

con <-
  dbConnect(
    MySQL(),
    user = 'root',
    password = 'admin',
    host = 'localhost',
    dbname = 'tweet_db'
  )

### Write tweets to table ###
dbWriteTable(
  conn = con,
  name = tablename,
  value = tweets.df,
  append = TRUE,
  row.names = FALSE,
  overwrite  = FALSE
)

combine_data = dbSendQuery(con, paste("select distinct * from ", tablename))
tdata = fetch(combine_data, n = -1)
tdata[, 5] <- as.Date(tdata[, 5])
#head(tdata)
nrow(tdata)
write.table(tdata, file = "tweet_data.csv", col.names = TRUE)
min_date <- min(tdata[, 5])
max_date <- max(tdata[, 5])

############ Data Capture End ################


query <-
  paste(
    "select * from dim_date where full_date >='",
    min_date,
    "' and full_date<= '",
    max_date,
    "'"
  )

dim_data = dbSendQuery(con, query)

dim_date = fetch(dim_data, n = -1)
dim_date[, 2] <- as.Date(dim_date[, 2])
n <- nrow(dim_date)

#######################

for(i in 1:n){


dd <- filter(tdata, created == as.Date(dim_date[i,2]))
print(as.Date(dim_date[i, 2]))      

tweetcnt <- nrow(dd)
print(tweetcnt)

sentidf <- as.data.frame(cbind(tweetcnt,possum, negsum, as.Date(dim_date[i,2])))
if(tweetcnt > 0){
      ## Cleaning data ##
      # remove retweet entities
      abc <- dd
      abc = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", abc)
      # remove at people
      abc = gsub("@\\w+", "", abc)
      # remove punctuation
      abc = gsub("[[:punct:]]", "", abc)
      # remove numbers
      abc = gsub("[[:digit:]]", "", abc)
      # remove html links
      abc = gsub("http\\w+", "", abc)
      # remove unnecessary spaces
      abc = gsub("[ \t]{2,}", "", abc)
      abc = gsub("^\\s+|\\s+$", "", abc)
      abc <- gsub(" +"," ",gsub("^ +","",gsub("[^a-zA-Z0-9 ]","",abc)))
      
      clean_tweet <- abc

      ## Splt into words 
      
      WordList <- str_split(clean_tweet, "\\s+")
      #WordList[16]
      
      #length(WordList)
      
      for (j in 1:length(WordList)) {
        posmatch <- lapply(WordList[j], function(x) {
          match(x, posw)
        })
        possum <- sum(!is.na(posmatch))
      
        negmatch <- lapply(WordList[j], function(x) {
          match(x, negw)
        })
        negsum <- sum(!is.na(negmatch))
      }
      final_score[j] <- possum - negsum
      
      }
      else
      {
        possum <- 0
        negsum <- 0
      }


      
#sentidf[i,] <- cbind(tweetcnt,possum, negsum, as.Date(dim_date[i,2])) 
queryIns <-
        paste(
          "INSERT INTO `tweet_db`.`record_senti2` VALUES (",
          tweetcnt,
          ",",
          possum,
          ",",
          negsum,
          ",",
          dimdate,
          ",",
          100,
          ");"
        )

dbSendQuery(con, queryIns)
      print(paste("Inserted",tweetcnt, "for date: ", as.Date(dim_date[i,2])))
      
}


