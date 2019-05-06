## Best City Picker ##
## James Temoshenko and Kordell Teenie ##

library(graphics)
library(shiny)
library(dplyr)

################# ------- IMPORT DATA HERE: ------- #################


#base city data
cities.data <- data.frame(read.csv("./data/uscitiestrimmed.csv"))

#income
income.data <- data.frame(read.csv("./data/kaggle_income.csv"))

#healthcare
healthcare.data <- data.frame(read.csv("./data/")) #still need data

#crime
crime.data

#tax rates
taxes.data

#housing
housing.data

#food
food.data #zomato data?

#entertainment
entertainment.data

#civic
civic.data

#colleges
college.data

#social media reception
socialmedia.data



### FORMAT DATA FOR FINAL DATAFRAME ###

#income
income.data <- select(income.data,ZipCode=Zip_Code,MeanIncome=Mean)

#healthcare
healthcare.data

#crime
crime.data

#tax rates
taxes.data

#housing
housing.data

#food
food.data #zomato data?

#entertainment
entertainment.data

#civic
civic.data

#colleges
college.data

#social media reception
socialmedia.data



### Final Preparations ###

#final data table, to be used in server
final.data <- select(cities.data,City=city,State=state_name,ZipCode=county_fips)

##Merge everything together in to final data table.

#income
final.data <- merge(final.data, income.data, by.x="ZipCode", by.y="ZipCode")
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
    
  })
  output$table <- renderDataTable(
    final.score %>% mutate(
      #income
      MeanIncome.Score = percent_rank(final.data$MeanIncome) * vals$income,
      TotalScore = MeanIncome.Score + MeanIncome.Score
      
      )
    )
}



### Run the application ###


shinyApp(ui = ui, server = server)


