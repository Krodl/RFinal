install.packages("scales")
library(scales)
universities.df <- data.frame(read.csv("./data/National Universities Rankings.csv"))
universities.df

universitiesTrimmed.df <- data.frame(
  name = character(),
  city = character(),
  rank = double(),
  stringsAsFactors = FALSE
)

index <- 1
for(i in universities.df$Name){
  index <- index + 1
  university <- gsub("\n", "", universities.df$Name[index])
  city <- gsub(",.*", "", universities.df$Location[index])
  rank <- round((universities.df$Rank[index])/220, 2) # Divide rank by 220 to get percentile between 0 and 1. In this case lower is better.
  universitiesTrimmed.df[nrow(universitiesTrimmed.df) + 1,] = list(university, city, rank)
}
write.csv(universitiesTrimmed.df, "universityRanks")
