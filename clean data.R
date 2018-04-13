
# Use the searchTwitter function to only get tweets within 50 miles of Los Angeles
#tweets_geolocated <- searchTwitter("'Gold Price' OR #GoldPrice", n=10000, lang="en", geocode="34.049933,-118.240843,50mi", since="2014-08-20")
#tweets_geolocated.df <- twListToDF(tweets_geolocated)


## Get Tweets
#
# abc <- dbGetQuery(con, "select * from tweetjun201620 union select * from tweetjun201619   ")
#
#
#
#
## Cleaning data ##

clean_tweet <- function(abc){
# remove retweet entities
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

return(abc)
}
head(abc)

class_emo1 = classify_emotion(abc, algorithm="bayes", prior=1.0)





# union <- ""
# while (i < NROW(data)) {
#   union <- paste(union,"select * from ", data[i,1])
#   if (i == NROW(data) - 1)
#     break
#   else
#     union = paste(union, " Union ")
#   i <- i + 1
# }