#==================================================================================================================================
#                                           Final Project
#                                              CIT460
#                                 Kordell Teenie & James Temoshenko
#==================================================================================================================================
#Cities from: https://simplemaps.com/data/us-cities
cities <- data.frame(read.csv("./data/uscitiestrimmed.csv"))
cities$city
cityNames <- data.frame(cities$city)

names(cities)



#Twitter Analysis
#==================================================================================================================================
#                                                             Packages
#==================================================================================================================================
#install the required package
install.packages("SnowballC")
install.packages("tm")
install.packages("twitteR")
install.packages("syuzhet")

#start the required packages
library("twitteR")
library("tm")
library("SnowballC")
library("syuzhet")
#==================================================================================================================================
#                                                           Setup 'twitteR'
#==================================================================================================================================
#API Keys & Tokens
api_key <- "NDoBb3wuypYCji6aOa0YgwUHa" #your API key in the quotes
api_secret <-
  "SosJ3MRRP88Ek5rGTMDWcOQMgW4FbWQNsRj2pjocVCjb3a0rvz" #your API secret token in the quotes
token <-
  "745719169-u9nPNCjBQuqLYBM4QMchfhRuRDqmVUz5tZHj9Ol8" #your token in the quotes
token_secret <-
  "0r1M59LIOix9VgXKOiBC7itDO3zR1tzlsArvZvr4uAWfH" #your token secret in the quotes

#Set up the Twitter oauth
setup_twitter_oauth(api_key, api_secret, token, token_secret)
#==================================================================================================================================
#                                                           Gather Tweets
#==================================================================================================================================
tweets <-
  searchTwitter("Game of Thrones",
                n = 1000,
                lang = "en",
                resultType = 'recent')
tweets

tweets.df <- twListToDF(tweets) #create tweets df
head(tweets.df) #See the head of the df for tweets
head(tweets.df$text) #See just the text from each tweets

n.tweet <- length(tweets) #length of tweets.

#Clean up hashtags, links, and other symbols
tweets.df2 <- gsub("http\\D+\\w+", "", tweets.df$text)

tweets.df2 <- gsub("https\\D+\\w+", "", tweets.df2)

tweets.df2 <- gsub("#\\w+", "", tweets.df2)

tweets.df2 <- gsub("@\\w+", "", tweets.df2)
head(tweets.df2)
#==================================================================================================================================
#                                                         Sentiment Analysis
#==================================================================================================================================
word.df <-
  as.vector(tweets.df2) #Create dataframe for words from each tweet.

emotion.df <-
  get_nrc_sentiment(word.df) #Get emotions of the word.df

emotion.df2 <-
  cbind(tweets.df2, emotion.df) #Bind words.df and emotion.df by their common words.

head(emotion.df2)

sent.value <-
  get_sentiment(word.df) #Get a sentiment score for each word based on emotion attached to it
head(sent.value)
head(word.df)
most.positive <-
  word.df[sent.value == max(sent.value)] #Get the most positive tweets

most.positive

most.negative <- word.df[sent.value <= min(sent.value)]

most.negative

#Sentimental values for all of the tweets
sent.value

#Create a positive tweets dataframe, a negative tweets dataframe, and a neutral tweets DF
positive.tweets <- word.df[sent.value > 0]
negative.tweets <- word.df[sent.value < 0]
neutral.tweets <- word.df[sent.value == 0]

#Alternate way to seperate
category_senti <-
  ifelse(sent.value < 0,
         "Negative",
         ifelse(sent.value > 0, "Positive", "Neutral"))
head(category_senti)
table(category_senti)

#===================================================================================================================================
citySentiment.df <- data.frame(
  City = character(),
  Positive = integer(),
  Negative = integer(),
  stringsAsFactors = FALSE
)
#==================================================================================================================================
#                                                           Setup 'twitteR'
#==================================================================================================================================
#API Keys & Tokens
api_key <- "NDoBb3wuypYCji6aOa0YgwUHa" #your API key in the quotes
api_secret <-
  "SosJ3MRRP88Ek5rGTMDWcOQMgW4FbWQNsRj2pjocVCjb3a0rvz" #your API secret token in the quotes
token <-
  "745719169-u9nPNCjBQuqLYBM4QMchfhRuRDqmVUz5tZHj9Ol8" #your token in the quotes
token_secret <-
  "0r1M59LIOix9VgXKOiBC7itDO3zR1tzlsArvZvr4uAWfH" #your token secret in the quotes

#Set up the Twitter oauth
setup_twitter_oauth(api_key, api_secret, token, token_secret)

for (i in cities$city) {

  #==================================================================================================================================
  #                                                           Gather Tweets
  #==================================================================================================================================
  i
  tweets <-
    searchTwitter(i,
                  n = 50,
                  lang = "en",
                  resultType = 'recent',
                  retryOnRateLimit = 200)
  if (length(tweets) == 0) {
    next
  }
  
  tweets.df <- twListToDF(tweets) #create tweets df
  
  n.tweet <- length(tweets) #length of tweets.
  
  #Clean up hashtags, links, and other symbols
  tweets.df2 <- gsub("http\\D+\\w+", "", tweets.df$text)
  
  tweets.df2 <- gsub("https\\D+\\w+", "", tweets.df2)
  
  tweets.df2 <- gsub("#\\w+", "", tweets.df2)
  
  tweets.df2 <- gsub("@\\w+", "", tweets.df2)
  #==================================================================================================================================
  #                                                         Sentiment Analysis
  #==================================================================================================================================
  word.df <-
    as.vector(tweets.df2) #Create dataframe for words from each tweet.
  
  emotion.df <-
    get_nrc_sentiment(word.df) #Get emotions of the word.df
  
  emotion.df2 <-
    cbind(tweets.df2, emotion.df) #Bind words.df and emotion.df by their common words.
  
  sent.value <-
    get_sentiment(word.df) #Get a sentiment score for each word based on emotion attached to it
  
  #Create a positive tweets dataframe, a negative tweets dataframe, and a neutral tweets DF
  positive.tweets <- word.df[sent.value > 0]
  negative.tweets <- word.df[sent.value < 0]
  neutral.tweets <- word.df[sent.value == 0]
  
  
  #Alternate way to seperate
  category_senti <-
    ifelse(sent.value < 0,
           "Negative",
           ifelse(sent.value > 0, "Positive", "Neutral"))
  table(category_senti)
  
  citySentiment.df[nrow(citySentiment.df) + 1, ] = list(i, length(positive.tweets), length(negative.tweets))
}
write.csv(citySentiment.df, "CityCentiment.csv")

