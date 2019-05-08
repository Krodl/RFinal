cities <- data.frame(read.csv("./data/uscitiestrimmed.csv"))
cities

crimeData <- data.frame(read.csv("./data/crime_data.csv"))
crimeData

#Create new dataframe for city, county, crimerate to be analysed by app
crimeDataWithCity <- data.frame(
  city = character(),
  county = character(),
  crime_rate_per_100000 = double(),
  stringsAsFactors = FALSE
)
crimeDataWithCityTest <- data.frame(
  city = character(),
  county = character(),
  crime_rate_per_100000 = double(),
  stringsAsFactors = FALSE
)
#counters for the nested loop
county_index_counter <- 1
city_index_counter <- 1

#Read through crimeRate DF for county names, cross-reference the names with the cities DF, get city name, county name, crime rate, and insert new line
#into the crimeDataWithCity df
for(i in crimeData$county_name) {
  city_index_counter <- 1 #City index needs to reset every time before it steps through the cities dataframe
  county <- crimeData$county_name[county_index_counter]
  #Trim county data for State abbreviation and check it in the next loop to avoid repeats.
  state <- gsub(".*,\\s", "", county)
  county <- gsub("\\sCounty,.*","",county)
  county <- gsub("\\scity,.*","",county)
  county <- gsub(",\\s.*","",county)
  for (u in cities$county_name) {
    state2 <- cities$state_id[city_index_counter]
    state2 <- gsub("\n", "", state2)
    if(county == u & state == state2){
      city <- gsub("\n", "", cities$city[city_index_counter]) 
      crime_rate <- crimeData$crime_rate_per_100000[county_index_counter] #Get the crime rate OF EACH
      crimeDataWithCityTest[nrow(crimeDataWithCityTest) + 1,] = list(city, county, crime_rate)
      print(paste0("City: ", city, " | County: ", county, " | At index: ", county_index_counter, " | Crime rate: ", crime_rate))
    }
    city_index_counter <- city_index_counter + 1
  }
  county_index_counter <- county_index_counter + 1
}
#Write crimeDataWithCity df to csv
write.csv(crimeDataWithCityTest, file = "crimeDataWithCity.csv")


county <- "Crittenden County, AR"
state <- gsub(".*,\\s", "", county)
state
