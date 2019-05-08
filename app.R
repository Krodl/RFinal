## Best City Picker ##
## James Temoshenko and Kordell Teenie ##

library(graphics)
library(shiny)
library(dplyr)
library(ggplot2)
library(ggmap)
library("readxl")

################# ------- IMPORT DATA HERE: ------- #################


#base city data
cities.data <- data.frame(read.csv("./data/uscitiestrimmed.csv"))

#income
income.data <- data.frame(read.csv("./data/kaggle_income.csv"))

#healthcare

#crime
crime.data <- data.frame(read.csv("./data/crimeDataWithCity.csv"))

#tax rates
taxes.data <- read_xlsx("./data/taxes.xlsx")

#housing

#food

#entertainment

#civic

#colleges

#social media reception



### FORMAT DATA FOR FINAL DATAFRAME ###

#final data table, to be used in server
final.data <- select(cities.data,City=city,State=state_name,County=county_name,ZipCode=county_fips,lat,long=lng)

#income
income.data <- select(income.data,ZipCode=Zip_Code,MeanIncome=Mean)

#healthcare

#crime
crime.data <- select(crime.data,City=city,Crime=crime_rate_per_100000)

#tax rates
taxes.data <- select(taxes.data,State,StateTax=StateTaxData,LocalTax=LocalTaxData)

#housing

#food

#entertainment

#civic

#colleges

#social media reception



### Final Preparations ###

##Merge everything together in to final data table.

#income
final.data <- merge(final.data, income.data, by.x="ZipCode", by.y="ZipCode")

#taxes
final.data <- merge(final.data, taxes.data, by.x="State", by.y="State")

#crime
final.data <- merge(final.data, crime.data, by.x="City", by.y="City")

final.score <- final.data



### UI ###


ui <- fluidPage(titlePanel("City Rank"),
                
                sidebarLayout(
                  sidebarPanel(
                    
                    helpText("Importance of... (Lower=less important, higher=more important)"),
                    
                    sliderInput(
                      "healthcare",
                      label = "Healthcare: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "income",
                      label = "Median Income: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "crime",
                      label = "Crime Rate: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "taxes",
                      label = "State & City Taxes: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "housing",
                      label = "Housing Cost: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "recreational",
                      label = "Recreational Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "entertainment",
                      label = "Entertainment Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "civic",
                      label = "Civic Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "college",
                      label = "College Ratings:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "socialmedia",
                      label = "Social Media Sentiment: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    sliderInput(
                      "food",
                      label = "Restauraunts:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    actionButton("goButton", "Update Table")
                  ),
                  
                  mainPanel(dataTableOutput('table'))
                  
                ))



### SERVER ###


server <- function(input, output) {
  
  ### Calculate scores
  vals <- reactiveValues()
  
  ##Watch for change to input....
  observe({
    #income
    vals$income <- input$income
    vals$taxes <- input$taxes
    
  })
  
  
  output$table <- renderDataTable(
    final.score %>% mutate(
      #income
      MeanIncome.Score = percent_rank(final.score$MeanIncome) * vals$income,
      Taxes.Score = percent_rank(final.score$StateTax) * vals$taxes * -1,
      Total.Score = MeanIncome.Score + Taxes.Score
    )
  )
}



### Run the application ###


shinyApp(ui = ui, server = server)


