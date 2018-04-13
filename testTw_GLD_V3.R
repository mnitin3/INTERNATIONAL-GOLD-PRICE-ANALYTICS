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

source("~/R/Gold Prediction/clean_tweet_Func.R")
# Declare Twitter API Credentials
api_key <- "70BYtjDMZgNbCvPOGr6gFS5tV" # From dev.twitter.com
api_secret <-
  "68kRITbwEYyPc3b4cdjOHwvvGdHExm5uiPDK2OpJeHnjjPfKIf" # From dev.twitter.com
token <-
  "42370357-tZ8LJmWq4UQLjsisLEbPNOXqWHbfxuONwAKv6juQU" # From dev.twitter.com
token_secret <-
  "Wg6i3RaIHeNEF3TOHmrQZJ0Rpd5ex7GohYJmIl7OlrZgk" # From dev.twitter.com

# Create Twitter Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)
1


tweets <-
  searchTwitter(
    "#BRIKK OR #GoldGenie OR #Miansai OR #GoldSouk OR #GoldPrice OR #24Karat OR #22Karat OR #18Karat OR #GoldJewellery OR #GoldBullion OR #GoldBar OR #YellowMetal OR #SpotGold OR #GoldFutures OR #GoldDemand",
    n =
      1000,
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
nrow(dim_date)


dbSendQuery(
  con,
  "drop table record_senti")

dbSendQuery(
  con,
  "CREATE TABLE `record_senti` ( `ANGER` float,  `DISGUST` float,  `FEAR` float,  `JOY` float,  `SADNESS` float,  `SURPRISE` float, `Date` varchar(50), `Price` float,`TweetCnt` int )"
)


#Quandl
#code: WGC/GOLD_DAILY_INR
gpdata = Quandl("WGC/GOLD_DAILY_INR",
                start_date = min_date,
                end_date = max_date)
filter(gpdata, Date == as.Date(dim_date[i, 2]))
#write.table(gpdata,file= "gold_price.csv", col.names = TRUE)

i <- 1 
while (i <= NROW(dim_date)) {
  print(i)
  dd <- filter(tdata, created == as.Date(dim_date[i, 2]))
  
  if (nrow(dd) == 0) {
    class_emo1[1] = 0
    class_emo1[2] = 0
    class_emo1[3] = 0
    class_emo1[4] = 0
    class_emo1[5] = 0
    class_emo1[6] = 0
    
  } else {
    clean_dd <- clean_tweet(dd$text)
    con_text <- paste(clean_dd, collapse = " ")
    class_emo1 = classify_emotion(con_text, algorithm = "bayes", verbose = TRUE)
    #summ <- summary(class_emo1)
    #summ <- sub(":", "", summ)
  }
  
  if (length(gpdata$Value[gpdata$Date == dim_date[i, 2]]) == 0) {
    price <-
      0
  } else {
    price <- gpdata$Value[gpdata$Date == dim_date[i, 2]]
  }
  
  queryIns <-
    paste(
      "INSERT INTO `tweet_db`.`record_senti` VALUES (",
      class_emo1[1],
      ",",
      class_emo1[2],
      ",",
      class_emo1[3],
      ",",
      class_emo1[4],
      ",",
      class_emo1[5],
      ",",
      class_emo1[6],
      ",",
      dim_date[i, 1],
      ",",
       price,
      ",",
      nrow(dd),
      ");"
    )
  
  dbSendQuery(con, queryIns)
  print(paste("Inserted for date: ", dim_date[i, 2]))
  i <- i + 1
}

que = dbSendQuery(con,  "select * from record_senti")
senti <- fetch(que, n = -1)
class(senti)
senti_tbl <- tbl_df(senti)

write.table(senti, file = "sentiments.csv", col.names = TRUE)


# #########################
# #Regression Model
# attach(senti)
# 
# lm.fit <- lm(Price ~ ANGER+DISGUST+FEAR+JOY+SADNESS+SURPRISE, data = senti)
# summary(lm.fit)
# plot(lm.fit)



############################
# XGBOOST

library(xgboost)
sentimat <- as.matrix(senti[,-7])
xgb_model <- xgboost(data = sentimat, label = Price, max_depth = 6, 
                     eta = 1, nthread = 3, nrounds = 100, objective = "reg:linear")
