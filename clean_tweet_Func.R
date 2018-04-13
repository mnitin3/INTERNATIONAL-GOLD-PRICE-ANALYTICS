clean_tweet <- function(data_tweet) {
  # remove retweet entities
  abc = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", data_tweet)
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

