install.packages("googleway")
library(googleway)

#testing with the api
google_places("bikes", location = c(40.791450, -77.861153), key = "AIzaSyA_CCCg4swAZbOagjba1JENRC8QoxfSOcQ")
bikes.df <- google_places(place_type = "museum", location = c(40.791450, -77.861153), radius = 50000, key = "AIzaSyA_CCCg4swAZbOagjba1JENRC8QoxfSOcQ")
length(bikes.df$results$rating)

#Create the empty DF
cityMuseumRankings <- data.frame(
  city = character(),
  avgRating = double(),
  stringsAsFactors = FALSE
)
#Need an index
index <- 1

#Loop
for(i in cities$city){
  print(paste0(i, " | Index at: ", index))
  avgRating <- 0
  museums.df <- google_places(place_type = "museum", location = c(cities$lat[index],cities$lng[index]), radius = 50000, key = "AIzaSyA_CCCg4swAZbOagjba1JENRC8QoxfSOcQ")
  if(length(museums.df$results$rating) != 0){
    for(u in museums.df$results$rating){
      avgRating <- avgRating + u
    }
    city <- i
    avgRating <- (avgRating/length(museums.df$results$rating))/5
    cityMuseumRankings[nrow(cityMuseumRankings) + 1,] = list(city, avgRating)
  }
  index <- index + 1
}
